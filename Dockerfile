# Use an official Maven image to build the project
FROM maven:3.9.8 AS build

# Set the working directory in the container
WORKDIR /app

# Copy the pom.xml and src directory into the container
COPY pom.xml /app/
COPY src /app/src

# Build the project
RUN mvn clean package

# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the compiled classes and dependencies from the build stage
COPY --from=build /app/target/classes /app/classes
COPY --from=build /app/target/dependency /app/dependency

EXPOSE 80

# Command to run the application
CMD ["java", "-cp", "/app/classes:/app/dependency/*", "Main"]