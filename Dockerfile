# Étape 1 : Compilation de l'application avec Maven
FROM maven:3.8 as maven
WORKDIR /app

# Copier d'abord le pom.xml pour profiter du cache Docker s'il ne change pas
COPY pom.xml .
# Copier l'ensemble du dossier source (attention à la faute de frappe "scr" → "src")
COPY src ./src

# Construire le jar avec Maven
RUN ["mvn", "clean", "package"]

# Étape 2 : Création de l'image finale basée sur OpenJDK
FROM openjdk:21
WORKDIR /app

# Copier le jar compilé depuis l'étape "maven"
# Veille à utiliser le chemin correct si le jar se trouve dans target
COPY --from=maven /app/target/hello-world-0.0.1-SNAPSHOT.jar ./hello-world.jar

# Définir la commande de démarrage de l'application
ENTRYPOINT ["java", "-jar", "hello-world.jar"]
