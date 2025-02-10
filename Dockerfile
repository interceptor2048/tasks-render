FROM openjdk:19-jdk AS build
WORKDIR /app
COPY build.gradle .
COPY settings.gradle .
COPY src src

COPY gradlew .
COPY gradle gradle

RUN chmod +x ./gradlew
RUN ./gradlew build -x test

FROM openjdk:19-jdk
VOLUME /tmp

COPY --from=build /app/target/*.jar app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
EXPOSE 8080
