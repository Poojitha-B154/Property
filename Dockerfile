FROM tomcat:9-jre9 
MAINTAINER "poojithab1503@gmail.com"
RUN rm -rf /usr/local/tomcat/webapps/ROOT
COPY ./target/tech.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8081
