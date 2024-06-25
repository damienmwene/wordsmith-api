FROM maven:3.9.7-eclipse-temurin-17-alpine AS build

WORKDIR /usr/src/app

COPY pom.xml .
COPY src ./src

RUN mvn clean package -DskipTests

FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

COPY --from=build /usr/src/app/target/*.jar app.jar

EXPOSE 80

CMD ["java", "-jar", "app.jar"]
