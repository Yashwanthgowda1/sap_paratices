import pytest
import allure
from utilities.schema_validator import assert_schema
from test_data import TestData


@allure.epic("JioHotstar")
@allure.feature("API - Subscription")
@pytest.mark.api
@pytest.mark.subscription
class TestSubscriptionAPI:
    """TC-API-SUB-001 to TC-API-SUB-008: Subscription REST API tests."""

    @allure.story("GET subscription plans")
    @allure.title("TC-API-SUB-001 | [SANITY] GET /subscription/plans returns 200 with plans array")
    @allure.severity(allure.severity_level.BLOCKER)
    @pytest.mark.sanity
    @pytest.mark.smoke
    @pytest.mark.TC_API_SUB_001
    def test_get_plans_returns_200(self, api_client):
        resp = api_client.get("/subscription/plans")
        assert resp.status_code == 200, f"Expected 200, got {resp.status_code}"
        body = resp.json()
        assert_schema(body, "subscription_plans_response.json")
        assert len(body.get("plans", [])) > 0, "Plans list should not be empty"

    @allure.story("All plans have required fields")
    @allure.title("TC-API-SUB-002 | [SMOKE] All plans contain id, name, and price")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.smoke
    @pytest.mark.TC_API_SUB_002
    def test_all_plans_have_required_fields(self, api_client):
        resp = api_client.get("/subscription/plans")
        assert resp.status_code == 200
        for plan in resp.json().get("plans", []):
            assert plan.get("id"),    f"Plan missing 'id': {plan}"
            assert plan.get("name"),  f"Plan missing 'name': {plan}"
            assert plan.get("price") is not None, f"Plan missing 'price': {plan}"

    @allure.story("Validate coupon")
    @allure.title("TC-API-SUB-003 | [SMOKE] POST /subscription/validate-coupon returns 200 for valid coupon")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.smoke
    @pytest.mark.TC_API_SUB_003
    def test_validate_valid_coupon(self, authenticated_client):
        resp = authenticated_client.post("/subscription/validate-coupon", {"code": "VALID_TEST_COUPON"})
        assert resp.status_code in (200, 404), \
            f"Expected 200 (valid) or 404 (not found in env), got {resp.status_code}"

    @allure.story("Invalid coupon returns 400")
    @allure.title("TC-API-SUB-004 | [NEGATIVE] POST /subscription/validate-coupon returns 400 for invalid code")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.negative
    @pytest.mark.regression
    @pytest.mark.TC_API_SUB_004
    def test_validate_invalid_coupon_returns_4xx(self, api_client):
        resp = api_client.post("/subscription/validate-coupon", {"code": TestData.INVALID_COUPON})
        assert resp.status_code in (400, 404, 422), \
            f"Expected 4xx for invalid coupon, got {resp.status_code}"

    @allure.story("Current subscription for authenticated user")
    @allure.title("TC-API-SUB-005 | [REGRESSION] GET /user/subscription returns subscription info")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.regression
    @pytest.mark.TC_API_SUB_005
    def test_get_user_subscription(self, authenticated_client):
        resp = authenticated_client.get("/user/subscription")
        assert resp.status_code in (200, 404), \
            f"Expected 200 (has subscription) or 404 (no plan), got {resp.status_code}"
        if resp.status_code == 200:
            assert resp.json().get("plan") is not None, "Subscription response should contain plan info"

    @allure.story("Subscription — unauthenticated")
    @allure.title("TC-API-SUB-006 | [NEGATIVE] GET /user/subscription returns 401 without token")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.negative
    @pytest.mark.regression
    @pytest.mark.TC_API_SUB_006
    def test_get_subscription_unauthenticated(self, api_client):
        resp = api_client.get("/user/subscription")
        assert resp.status_code == 401, f"Expected 401, got {resp.status_code}"

    @allure.story("Plans response time")
    @allure.title("TC-API-SUB-007 | [PERFORMANCE] GET /subscription/plans responds within 2 seconds")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    @pytest.mark.TC_API_SUB_007
    def test_plans_response_time(self, api_client):
        resp = api_client.get("/subscription/plans")
        elapsed = resp.elapsed.total_seconds()
        assert elapsed < 2.0, f"Plans API took {elapsed:.2f}s — exceeds 2s threshold"

    @allure.story("Plans available per country")
    @allure.title("TC-API-SUB-008 | [REGRESSION] GET /subscription/plans returns plans for IN region")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    @pytest.mark.TC_API_SUB_008
    def test_plans_available_for_india(self, api_client):
        resp = api_client.get("/subscription/plans", params={"country": "IN"})
        assert resp.status_code == 200, f"Expected 200 for IN, got {resp.status_code}"
        plans = resp.json().get("plans", [])
        assert len(plans) > 0, "Should have at least one plan available for India"
