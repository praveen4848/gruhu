# Multi-stage build for Gruhu Scandinavian Atelier
# Stage 1: Build the WAR package using Maven & Eclipse Temurin JDK 21
FROM maven:3.9.9-eclipse-temurin-21 AS builder
WORKDIR /build

# Copy pom.xml and source code
COPY pom.xml .
COPY src ./src

# Build production WAR package
RUN mvn clean package -DskipTests

# Stage 2: Run Tomcat 10.1 (Jakarta Servlet 6.0)
FROM tomcat:10.1-jdk21-temurin

# Clean default Tomcat sample apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Disable Tomcat 8005 shutdown port so cloud container health checks only target port 8080
RUN sed -i 's/<Server port="8005" shutdown="SHUTDOWN">/<Server port="-1" shutdown="SHUTDOWN">/g' /usr/local/tomcat/conf/server.xml

# Deploy Gruhu as ROOT application (served directly at domain root /)
COPY --from=builder /build/target/gruhu.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
