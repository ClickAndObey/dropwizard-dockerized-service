#!/usr/bin/env sh

APP_NAME=webservice
ENVIRONMENT=${ENVIRONMENT-docker}

echo "Running The Webservice ${APP_NAME} with environment '${ENVIRONMENT}'..."
java -jar "/${APP_NAME}/${APP_NAME}.jar" server "/${APP_NAME}/configuration/${ENVIRONMENT}/config.yaml"
echo "The Webservice has finished."