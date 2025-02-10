# Importing JDK and copying required files
FROM openjdk:19-jdk AS build
WORKDIR /app
COPY build.gradle .
COPY settings.gradle .
COPY src src

# Copy Maven wrapper
COPY gradlew .
COPY gradle gradle

# Set execution permission for the Maven wrapper
RUN chmod +x ./gradlew
RUN ./gradlew build -x test

# Stage 2: Create the final Docker image using OpenJDK 19
FROM openjdk:19-jdk
VOLUME /tmp

# Copy the JAR from the build stage
COPY --from=build /app/target/*.jar app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
EXPOSE 8080