FROM maven:3.9.9-amazoncorretto-21-alpine AS build
WORKDIR /app
ADD src src
ADD pom.xml .

RUN mvn package -DskipTests=true


FROM registry.access.redhat.com/ubi8/openjdk-21:1.20


ENV LANG='pt_BR.UTF-8' LANGUAGE='pt_BR:pt'

# Configure the JAVA_OPTIONS, you can add -XshowSettings:vm to also display the heap size.
ENV JAVA_OPTIONS="-Dquarkus.http.host=0.0.0.0 -Djava.util.logging.manager=org.jboss.logmanager.LogManager -Duser.timezone=America/Fortaleza"

# We make four distinct layers so if there are application changes the library layers can be re-used
COPY --from=build --chown=185 /app/target/quarkus-app/lib/ /deployments/lib/
COPY --from=build --chown=185 /app/target/quarkus-app/*.jar /deployments/
COPY --from=build --chown=185 /app/target/quarkus-app/app/ /deployments/app/
COPY --from=build --chown=185 /app/target/quarkus-app/quarkus/ /deployments/quarkus/

EXPOSE 8081
USER 185


ENTRYPOINT [ "java", "-jar", "/deployments/quarkus-run.jar" ]