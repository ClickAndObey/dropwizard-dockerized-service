all: clean lint test

MAJOR_VERSION := 1
MINOR_VERSION := 0
BUILD_VERSION ?= $(USER)
VERSION := $(MAJOR_VERSION).$(MINOR_VERSION).$(BUILD_VERSION)

ORGANIZATION := clickandobey
SERVICE_NAME := java-dockerized-webservice

PACKAGE_IMAGE_NAME := ${ORGANIZATION}-${SERVICE_NAME}-package

SHARED_IMAGE_NAME := ${ORGANIZATION}-${SERVICE_NAME}-shared
APP_IMAGE_NAME := ${ORGANIZATION}-${SERVICE_NAME}-app
GITHUB_REPO := "docker.pkg.github.com"
APP_REPO_IMAGE_NAME := ${GITHUB_REPO}/${ORGANIZATION}/${SERVICE_NAME}/webservice:${VERSION}
APP_PORT := 9001
ADMIN_PORT := 9002
APP_CONTAINER_NAME := ${APP_IMAGE_NAME}

INTEGRATION_TEST_IMAGE_NAME := ${ORGANIZATION}-${SERVICE_NAME}-integration-test
INTEGRATION_TEST_CONTAINER_NAME := ${INTEGRATION_TEST_IMAGE_NAME}
UNIT_TEST_IMAGE_NAME := ${ORGANIZATION}-${SERVICE_NAME}-unit-test
UNIT_TEST_CONTAINER_NAME := ${UNIT_TEST_IMAGE_NAME}

ROOT_DIRECTORY := `pwd`
TEST_DIRECTORY := ${ROOT_DIRECTORY}/test
TEST_PYTHON_DIRECTORY := $(TEST_DIRECTORY)/python

ifneq ($(DEBUG),)
  INTERACTIVE=--interactive
  PDB=--pdb
  DETACH=--env "DETACH=None"
else
  INTERACTIVE=--env "INTERACTIVE=None"
  PDB=
  DETACH=--detach
endif

# Local App Targets

build-webservice:
	@gradle build -x test

run-webservice:
	@gradle run

# Shared Build Targets

docker-build-shared: docker/Dockerfile.shared $(shell find src/main -name "*")
	@docker build \
		-t ${SHARED_IMAGE_NAME} \
		-f docker/Dockerfile.shared \
		.
	@touch docker-build-shared

# Docker App Targets

docker-build-app: docker-build-shared docker/app/Dockerfile.app docker/app/run_webservice.sh
	@docker build \
		-t ${APP_IMAGE_NAME} \
		-f docker/app/Dockerfile.app \
		.
	@touch docker-build-app

docker-run-webservice: docker-build-app stop-webservice
	@docker run \
		--rm \
		${DETACH} \
		${INTERACTIVE} \
		--env ENVIRONMENT=docker \
		--name ${APP_CONTAINER_NAME} \
		-p ${APP_PORT}:9001 \
		-p ${ADMIN_PORT}:9002 \
		${APP_IMAGE_NAME}
	@${ROOT_DIRECTORY}/test/scripts/wait_for_webapp ${APP_PORT}

stop-webservice:
	@docker kill ${APP_CONTAINER_NAME} || true

# Testing

docker-build-test: docker-build-shared docker/Dockerfile.test.unit docker-build-shared docker/Dockerfile.test.integration $(shell find src/test -name "*") $(shell find test/python -name "*")
	@docker build \
		-t $(UNIT_TEST_IMAGE_NAME) \
		-f docker/Dockerfile.test.unit \
		.
	@docker build \
		-t $(INTEGRATION_TEST_IMAGE_NAME) \
		-f docker/Dockerfile.test.integration \
		.
	@touch docker-build-test

test: unit-test integration-test
test-docker: unit-test-docker integration-test-docker

unit-test:
	@gradle test

unit-test-docker: docker-build-test
	@docker run \
		--rm \
		${INTERACTIVE} \
		--name ${UNIT_TEST_CONTAINER_NAME} \
		${UNIT_TEST_IMAGE_NAME}

integration-test: stop-webservice docker-run-webservice setup-test-env
	@cd $(TEST_PYTHON_DIRECTORY); \
	pipenv run python -m pytest \
		--durations=10 \
		${TEST_OUTPUT_FLAG} \
		${FAILURE_FLAG} \
		-m 'integration ${TEST_STRING}' \
		.

integration-test-docker: docker-build-test stop-webservice docker-run-webservice
	@docker run \
		--rm \
		${INTERACTIVE} \
		--env "ENVIRONMENT=docker" \
		--name ${INTEGRATION_TEST_CONTAINER_NAME} \
		--link ${APP_CONTAINER_NAME} \
		${INTEGRATION_TEST_IMAGE_NAME} \
			--durations=10 \
			-x \
			-s \
			-m 'integration ${TEST_STRING}' \
			${PDB} \
			/test/python

# Release

release: docker-build-app github-docker-login
	@echo Tagging webservice image to ${APP_REPO_IMAGE_NAME}...
	@docker tag ${APP_IMAGE_NAME} ${APP_REPO_IMAGE_NAME}
	@echo Pushing webservice docker image to ${APP_REPO_IMAGE_NAME}...
	@docker push ${APP_REPO_IMAGE_NAME}

# Linting

lint: lint-markdown lint-java

lint-markdown:
	@echo Linting markdown files...
	@docker run \
		--rm \
		-v `pwd`:/workspace \
		wpengine/mdl \
			/workspace
	@echo Markdown linting complete.

lint-java:
	@echo TODO: Implement Me!

# Utilities

clean:
	@echo Cleaning Make Targets...
	@rm -f package
	@rm -f docker-build-app
	@rm -f docker-build-shared
	@rm -f docker-build-test
	@echo Cleaned Make Targets.
	@echo Removing Build Targets...
	@echo Removed Build Targets.

setup-test-env:
	@cd ${TEST_PYTHON_DIRECTORY}; \
	pipenv install --dev

update-python-dependencies:
	@cd ${TEST_PYTHON_DIRECTORY}; \
	pipenv lock

github-docker-login:
	@echo ${GITHUB_TOKEN} | docker login https://docker.pkg.github.com -u ${GITHUB_USER} --password-stdin