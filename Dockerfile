FROM tomcat:9-jdk17
RUN rm -rf /usr/local/tomcat/webapps/ROOT
COPY target/Paytm.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8085
CMD ["catalina.sh", "run"]
