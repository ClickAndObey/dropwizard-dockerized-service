# Development

## Docker

We dockerize the webservice to make it available to services like ECS (Elastic Container Service) and Kubernetes.
Dockerizing an application (or anything really) also helps with build consistency as docker is a silo-ed environment
that should be identical between whatever machine you are running on. Couple of caveats to that, but none you are likely
to ever run in to with general development.

## Gradle

[Gradle](https://gradle.org/) is the build tool we use for the project. It has built-in "functions" to perform basic
operations, but is extensible to perform what ever type of operation you might want.

## Dropwizard

[DropWizard](https://www.dropwizard.io/en/latest/) is the java API we use for implementing the webservice. It uses
resources to handle endpoints, and has built in configuration mechanics to help manage the administrative part of the
service.
