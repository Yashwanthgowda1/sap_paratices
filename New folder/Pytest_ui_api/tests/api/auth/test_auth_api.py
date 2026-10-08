import pytest
import allure
from utilities.api_client import APIClient
from utilities.schema_validator import assert_schema
from test_data import TestData


@allure.epic("JioHotstar")
@allure.feature("API - Authentication")
@pytest.mark.api
@pytest.mark.auth
class TestAuthAPI:
    """TC-API-AUTH-001 to TC-API-AUTH-006: Auth REST API tests."""

    @allure.story("Login - valid credentials")
    @allure.title("TC-API-AUTH-001 | [SANITY] POST /auth/login returns 200 with token")
    @allure.severity(allure.severity_level.BLOCKER)
    @pytest.mark.sanity
    @pytest.mark.smoke
    @pytest.mark.TC_API_AUTH_001
    def test_login_returns_200_with_token(self, api_client):
        payload = {"email": TestData.VALID_USER["email"], "password": TestData.VALID_USER["password"]}
        resp = api_client.post("/auth/login", payload)
        assert resp.status_code == 200, f"Expected 200, got {resp.status_code}"
        body = resp.json()
        assert "token" in body, "Response body must contain 'token'"
        assert_schema(body, "login_response.json")

    @allure.story("Login - invalid password")
    @allure.title("TC-API-AUTH-002 | [SMOKE] POST /auth/login returns 401 for wrong password")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.smoke
    @pytest.mark.negative
    @pytest.mark.TC_API_AUTH_002
    def test_login_invalid_password_returns_401(self, api_client):
        payload = {"email": TestData.VALID_USER["email"], "password": "WrongPass999!"}
        resp = api_client.post("/auth/login", payload)
        assert resp.status_code == 401, f"Expected 401, got {resp.status_code}"

    @allure.story("Login - missing email")
    @allure.title("TC-API-AUTH-003 | [NEGATIVE] POST /auth/login returns 400 for missing email field")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.negative
    @pytest.mark.regression
    @pytest.mark.TC_API_AUTH_003
    def test_login_missing_email_returns_400(self, api_client):
        resp = api_client.post("/auth/login", {"password": "Test@1234"})
        assert resp.status_code in (400, 422), f"Expected 4xx, got {resp.status_code}"

    @allure.story("Token refresh")
    @allure.title("TC-API-AUTH-004 | [REGRESSION] POST /auth/refresh returns new access token")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.regression
    @pytest.mark.TC_API_AUTH_004
    def test_token_refresh(self, authenticated_client):
        resp = authenticated_client.post("/auth/refresh")
        assert resp.status_code == 200, f"Expected 200, got {resp.status_code}"
        body = resp.json()
        assert "token" in body, "Refresh response must contain new token"

    @allure.story("Logout API")
    @allure.title("TC-API-AUTH-005 | [REGRESSION] POST /auth/logout invalidates the session")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    @pytest.mark.TC_API_AUTH_005
    def test_logout_invalidates_session(self, authenticated_client):
        resp = authenticated_client.post("/auth/logout")
        assert resp.status_code in (200, 204), f"Expected 200/204, got {resp.status_code}"

    @allure.story("Protected endpoint without token")
    @allure.title("TC-API-AUTH-006 | [NEGATIVE] GET /user/profile returns 401 without auth token")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.negative
    @pytest.mark.regression
    @pytest.mark.TC_API_AUTH_006
    def test_protected_endpoint_no_token_returns_401(self, api_client):
        resp = api_client.get("/user/profile")
        assert resp.status_code == 401, f"Expected 401, got {resp.status_code}"

    @allure.story("Login - empty password")
    @allure.title("TC-API-AUTH-007 | [NEGATIVE] POST /auth/login returns 400 for empty password")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.negative
    @pytest.mark.regression
    @pytest.mark.TC_API_AUTH_007
    def test_login_empty_password_returns_4xx(self, api_client):
        resp = api_client.post("/auth/login", {"email": TestData.VALID_USER["email"], "password": ""})
        assert resp.status_code in (400, 422), f"Expected 4xx, got {resp.status_code}"

    @allure.story("Login response time")
    @allure.title("TC-API-AUTH-008 | [PERFORMANCE] POST /auth/login responds within 3 seconds")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    @pytest.mark.TC_API_AUTH_008
    def test_login_response_time(self, api_client):
        payload = {"email": TestData.VALID_USER["email"], "password": TestData.VALID_USER["password"]}
        resp = api_client.post("/auth/login", payload)
        assert resp.elapsed.total_seconds() < 3.0, \
            f"Login API took {resp.elapsed.total_seconds():.2f}s — exceeds 3s threshold"
