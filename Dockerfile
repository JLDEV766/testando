FROM maven:3.9.9-amazoncorretto-21-alpine AS build
WORKDIR /app

# Corrigido para garantir que o pom.xml seja copiado corretamente
COPY ./pom.xml ./pom.xml
COPY ./src ./src

ARG PROFILE

RUN echo "PROFILE:" $PROFILE
RUN mvn package -DskipTests=true

# Imagem final
FROM registry.access.redhat.com/ubi8/openjdk-21:1.20

ENV LANG='pt_BR.UTF-8' LANGUAGE='pt_BR:pt'
ENV JAVA_OPTIONS="-Dquarkus.http.host=0.0.0.0 -Djava.util.logging.manager=org.jboss.logmanager.LogManager -Duser.timezone=America/Fortaleza"

# Copiando os arquivos do build corretamente
COPY --from=build --chown=185 /app/target/quarkus-app/lib/ /deployments/lib/
COPY --from=build --chown=185 /app/target/quarkus-app/*.jar /deployments/
COPY --from=build --chown=185 /app/target/quarkus-app/app/ /deployments/app/
COPY --from=build --chown=185 /app/target/quarkus-app/quarkus/ /deployments/quarkus/

EXPOSE 8081
USER 185
ENTRYPOINT [ "java", "-jar", "/deployments/quarkus-run.jar" ]
