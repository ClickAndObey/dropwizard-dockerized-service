"""
Module used to test the administrative endpoints for the api.
"""

import os
import pytest
import requests


@pytest.mark.integration
@pytest.mark.system
@pytest.mark.AdminEndpoints
class TestAdminEndpoints:
    """
    Class used to test the administrative endpoints for the api.
    """

    __ENVIRONMENT_ENV_VARIABLE = "ENVIRONMENT"
    __DEFAULT_ENVIRONMENT_VALUE = "localhost"
    __ENVIRONMENT = os.getenv(
        __ENVIRONMENT_ENV_VARIABLE,
        __DEFAULT_ENVIRONMENT_VALUE
    )

    @pytest.fixture()
    def admin_host_url(self) -> str:
        """
        Return the admin url for the api.
        """
        if self.__ENVIRONMENT == "localhost":
            yield "http://localhost:9002"
            return
        if self.__ENVIRONMENT == "docker":
            yield "http://clickandobey-java-dockerized-webservice-app:9002"
            return

        raise ValueError(f"Unexpected environment value {self.__ENVIRONMENT}")

    def test_metrics(self, admin_host_url: str):
        """
        Test to ensure the configuration endpoint comes back as expected.
        """
        response = requests.get(f"{admin_host_url}/metrics")
        response.raise_for_status()
        assert response.status_code == 200, "Failed to get the correct response code from the metrics request."

        metrics_output = response.json()
        assert metrics_output, "Failed to get a metrics output."
        assert len(metrics_output) != 0, "Failed to find keys in the metrics dict."

    def test_healthchecks(self, admin_host_url: str):
        """
        Test to ensure the status endpoint comes back as expected.
        """
        response = requests.get(f"{admin_host_url}/healthcheck")
        response.raise_for_status()
        assert response.status_code == 200, "Failed to get the correct response code from the healthcheck request."

        status = response.json()
        assert status["hello"], "Failed to get the correct status."
