FROM clickandobey-java-dockerized-webservice-shared as build-base

WORKDIR /build_dir

RUN gradle --no-daemon build -x test

FROM openjdk:15-slim

ENV APP_NAME=webservice
WORKDIR /${APP_NAME}

COPY --from=build-base /build_dir/build/libs/java-dockerized-webservice.jar /${APP_NAME}/app.jar
COPY docker/app/run_webservice.sh /${APP_NAME}/run_webservice.sh

ENTRYPOINT ["sh", "-c", "/${APP_NAME}/run_webservice.sh"]