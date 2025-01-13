FROM maven:3.8.4-openjdk-17-slim as build
WORKDIR /app
ADD src src
ADD pom.xml .

RUN mvn package -DskipTests=true

FROM registry.access.redhat.com/ubi8/openjdk-17:1.14-9

# We make four distinct layers so if there are application changes the library layers can be re-used
COPY --from=build --chown=185 /app/target/quarkus-app/lib/ /deployments/lib/
COPY --from=build --chown=185 /app/target/quarkus-app/*.jar /deployments/
COPY --from=build --chown=185 /app/target/quarkus-app/app/ /deployments/app/
COPY --from=build --chown=185 /app/target/quarkus-app/quarkus/ /deployments/quarkus/

EXPOSE 8080

ENTRYPOINT [ "java", "-jar", "/deployments/quarkus-run.jar" ]