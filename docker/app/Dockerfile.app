FROM clickandobey-java-dockerized-webservice-shared as build-base

WORKDIR /build_dir

RUN gradle --no-daemon build -x test

FROM openjdk:15-slim

ENV APP_NAME=webservice
ENV ENVIRONMENT=docker

WORKDIR /${APP_NAME}

COPY --from=build-base /build_dir/build/libs/java-dockerized-webservice-all.jar /${APP_NAME}/${APP_NAME}.jar
COPY docker/app/run_webservice.sh /${APP_NAME}/run_webservice.sh
COPY configuration /${APP_NAME}/configuration

ENTRYPOINT ["sh", "-c", "/${APP_NAME}/run_webservice.sh"]