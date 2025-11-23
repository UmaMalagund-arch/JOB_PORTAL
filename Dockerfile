# FROM tomcat:9-jdk17
# RUN rm -rf /usr/local/tomcat/webapps/ROOT
# COPY target/jobportal-0.0.1-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war
# EXPOSE 8085
# CMD ["catalina.sh", "run"]
FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app
COPY target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
