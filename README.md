# java-dockerized-service

Example java webservice (dropwizard) that is dockerized, and easily loads up in to Intellij. It uses [Gradle] for the
build, and [Dropwizard] as the API to build the service on top of. We also use [Pytest] and [Pipenv] for integration
testing.

## Quick Start

1. Run `make`

## Useful Documents

* [Design](docs/design.md)
* [Development](docs/development.md)
* [SRE](docs/sre.md)
* [Testing](docs/testing.md)

[Gradle]: https://gradle.org/
[Dropwizard]: https://www.dropwizard.io/en/latest/
[Pytest]: https://docs.pytest.org/en/stable/
[Pipenv]: https://pypi.org/project/pipenv/