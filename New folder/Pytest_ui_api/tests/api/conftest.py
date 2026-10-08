import pytest
from utilities.api_client import APIClient
from config.config import Config
from test_data import TestData


@pytest.fixture(scope="session")
def api_client() -> APIClient:
    """Unauthenticated API client shared across the entire API test session."""
    return APIClient()


@pytest.fixture(scope="session")
def auth_token(api_client) -> str:
    """Obtain a valid auth token once per session; skip all tests if unavailable."""
    resp = api_client.post("/auth/login", {
        "email": TestData.VALID_USER["email"],
        "password": TestData.VALID_USER["password"],
    })
    if resp.status_code != 200:
        pytest.skip(f"Login endpoint returned {resp.status_code} — skipping auth-dependent tests")
    return resp.json().get("token", "")


@pytest.fixture(scope="session")
def authenticated_client(auth_token) -> APIClient:
    """API client pre-loaded with a valid bearer token."""
    client = APIClient(token=auth_token)
    return client
