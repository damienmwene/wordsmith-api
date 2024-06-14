# Use the official OpenJDK 21 runtime as the base image
FROM openjdk:21-jdk-slim

# Set the working directory inside the container
WORKDIR /app/

COPY . /app/

RUN Main.java

# Expose the port your application will run on
EXPOSE 80

# Run the application
CMD ["java", "Main"]