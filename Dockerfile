# Multi-stage build for optimal image size
FROM openjdk:17-slim as builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN apt-get update && apt-get install -y maven && apt-get clean
RUN mvn clean package -DskipTests

# Runtime image
FROM openjdk:17-slim
WORKDIR /app

# Copy the built jar from builder stage
COPY --from=builder /app/target/app.jar app.jar

# Expose the port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
