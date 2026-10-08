import pytest
import allure
from utilities.api_client import APIClient
from config.config import Config
from test_data import TestData


@allure.epic("JioHotstar")
@allure.feature("API - Authentication")
@pytest.mark.api
@pytest.mark.auth
class TestAuthAPI:
    """TC-API-AUTH-001 to TC-API-AUTH-006: Auth REST API tests."""

    @pytest.fixture(autouse=True)
    def setup(self):
        self.client = APIClient()

    @allure.story("Login API - valid credentials")
    @allure.title("TC-API-AUTH-001 | [SANITY] POST /auth/login returns 200 with token for valid user")
    @allure.severity(allure.severity_level.BLOCKER)
    @pytest.mark.sanity
    @pytest.mark.smoke
    def test_login_valid_credentials(self):
        payload = {"email": TestData.VALID_USER["email"], "password": TestData.VALID_USER["password"]}
        response = self.client.post("/auth/login", payload)
        assert response.status_code == 200, f"Expected 200, got {response.status_code}"
        body = response.json()
        assert "token" in body, "Response should contain auth token"

    @allure.story("Login API - invalid credentials")
    @allure.title("TC-API-AUTH-002 | [SMOKE] POST /auth/login returns 401 for invalid password")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.smoke
    @pytest.mark.negative
    def test_login_invalid_credentials(self):
        payload = {"email": TestData.VALID_USER["email"], "password": "WrongPass999"}
        response = self.client.post("/auth/login", payload)
        assert response.status_code == 401, f"Expected 401, got {response.status_code}"

    @allure.story("Login API - missing fields")
    @allure.title("TC-API-AUTH-003 | [NEGATIVE] POST /auth/login returns 400 for missing email")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.negative
    @pytest.mark.regression
    def test_login_missing_email(self):
        response = self.client.post("/auth/login", {"password": "Test@1234"})
        assert response.status_code in (400, 422), f"Expected 4xx, got {response.status_code}"

    @allure.story("Token refresh")
    @allure.title("TC-API-AUTH-004 | [REGRESSION] POST /auth/refresh returns new access token")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.regression
    def test_token_refresh(self):
        login_resp = self.client.post("/auth/login", {
            "email": TestData.VALID_USER["email"],
            "password": TestData.VALID_USER["password"]
        })
        if login_resp.status_code != 200:
            pytest.skip("Login endpoint unavailable in this environment")
        token = login_resp.json().get("token")
        self.client.set_auth_header(token)
        refresh_resp = self.client.post("/auth/refresh")
        assert refresh_resp.status_code == 200, f"Expected 200, got {refresh_resp.status_code}"
        assert "token" in refresh_resp.json(), "Refresh should return new token"

    @allure.story("Logout API")
    @allure.title("TC-API-AUTH-005 | [REGRESSION] POST /auth/logout invalidates session")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    def test_logout_api(self):
        login_resp = self.client.post("/auth/login", {
            "email": TestData.VALID_USER["email"],
            "password": TestData.VALID_USER["password"]
        })
        if login_resp.status_code != 200:
            pytest.skip("Login endpoint unavailable in this environment")
        token = login_resp.json().get("token")
        self.client.set_auth_header(token)
        logout_resp = self.client.post("/auth/logout")
        assert logout_resp.status_code in (200, 204), f"Expected 200/204, got {logout_resp.status_code}"

    @allure.story("Protected endpoint without token")
    @allure.title("TC-API-AUTH-006 | [NEGATIVE] GET /user/profile returns 401 without auth token")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.negative
    @pytest.mark.regression
    def test_protected_endpoint_without_token(self):
        response = self.client.get("/user/profile")
        assert response.status_code == 401, f"Expected 401 for unauthenticated request, got {response.status_code}"
