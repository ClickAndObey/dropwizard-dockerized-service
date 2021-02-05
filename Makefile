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
APP_PORT := 9001
ADMIN_PORT := 9002
APP_CONTAINER_NAME := ${APP_IMAGE_NAME}

TEST_IMAGE_NAME := ${ORGANIZATION}-${SERVICE_NAME}-test
TEST_CONTAINER_NAME := ${TEST_IMAGE_NAME}

ROOT_DIRECTORY := `pwd`

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

stop-webservice:
	@docker kill ${APP_CONTAINER_NAME} || true

# Testing

docker-build-test: docker-build-shared docker/Dockerfile.test $(shell find src/test -name "*")
	@docker build \
		-t $(TEST_IMAGE_NAME) \
		-f docker/Dockerfile.test \
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
		--name ${TEST_CONTAINER_NAME} \
		${TEST_IMAGE_NAME}

integration-test: docker-run-webservice
	@echo TODO: Implement Me!

integration-test-docker: docker-build-test docker-run-webservice
	@echo TODO: Implement Me!

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
