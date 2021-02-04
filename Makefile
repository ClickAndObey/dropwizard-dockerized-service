all: clean lint test

MAJOR_VERSION := 1
MINOR_VERSION := 0
BUILD_VERSION ?= $(USER)
VERSION := $(MAJOR_VERSION).$(MINOR_VERSION).$(BUILD_VERSION)

ORGANIZATION := clickandobey
SERVICE_NAME := java-dockerized-webservice

PACKAGE_IMAGE_NAME := ${ORGANIZATION}-${SERVICE_NAME}-package

APP_IMAGE_NAME := ${ORGANIZATION}-${SERVICE_NAME}-app
APP_PORT := 9001
APP_CONTAINER_NAME := ${APP_IMAGE_NAME}

TEST_IMAGE_NAME := ${ORGANIZATION}-${SERVICE_NAME}-test
TEST_CONTAINER_NAME := ${TEST_IMAGE_NAME}

ROOT_DIRECTORY := `pwd`

# Local App Targets

run-webservice:
	@${ROOT_DIRECTORY}/gradlew run

# Docker App Targets

docker-build-app:
	@echo TODO: Implement Me!

docker-run-webservice:
	@echo TODO: Implement Me!

stop-webservice:
	@docker kill ${APP_CONTAINER_NAME} || true

# Testing

build-test-docker:
	@echo TODO: Implement Me!

test: unit-test integration-test
test-docker: unit-test-docker integration-test-docker

unit-test:
	@echo TODO: Implement Me!

unit-test-docker: build-test-docker
	@echo TODO: Implement Me!

integration-test: docker-run-webservice
	@echo TODO: Implement Me!

integration-test-docker: build-test-docker docker-run-webservice
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
	@rm -f build-test-docker
	@echo Cleaned Make Targets.
	@echo Removing Build Targets...
	@echo Removed Build Targets.
