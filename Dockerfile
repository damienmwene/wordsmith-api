# Use the official Maven image with JDK 17 to build the application
FROM maven:3.9.7-eclipse-temurin-17 AS build

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy the pom.xml file and the source code
COPY pom.xml .
COPY src ./src

# Package the application
RUN mvn clean package -DskipTests

# Use the official OpenJDK 17 image to run the application
FROM eclipse-temurin:17-jre

# Set the working directory inside the container
WORKDIR /app

# Copy the packaged jar file from the build stage
COPY --from=build /usr/src/app/target/*.jar app.jar

# Expose the port the app runs on
EXPOSE 8080

# Command to run the application
CMD ["java", "-jar", "app.jar"]