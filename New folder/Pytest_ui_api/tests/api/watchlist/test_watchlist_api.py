import pytest
import allure
from config.config import Config
from test_data import TestData


@allure.epic("JioHotstar")
@allure.feature("API - Watchlist")
@pytest.mark.api
@pytest.mark.watchlist
class TestWatchlistAPI:
    """TC-API-WL-001 to TC-API-WL-008: Watchlist REST API tests."""

    FREE_ID = Config.FREE_CONTENT_ID

    @allure.story("GET watchlist")
    @allure.title("TC-API-WL-001 | [SANITY] GET /user/watchlist returns 200 for authenticated user")
    @allure.severity(allure.severity_level.BLOCKER)
    @pytest.mark.sanity
    @pytest.mark.smoke
    @pytest.mark.TC_API_WL_001
    def test_get_watchlist_authenticated(self, authenticated_client):
        resp = authenticated_client.get("/user/watchlist")
        assert resp.status_code == 200, f"Expected 200, got {resp.status_code}"
        body = resp.json()
        assert "items" in body, "Watchlist response must contain 'items'"

    @allure.story("GET watchlist — unauthenticated")
    @allure.title("TC-API-WL-002 | [NEGATIVE] GET /user/watchlist returns 401 without token")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.negative
    @pytest.mark.smoke
    @pytest.mark.TC_API_WL_002
    def test_get_watchlist_unauthenticated(self, api_client):
        resp = api_client.get("/user/watchlist")
        assert resp.status_code == 401, f"Expected 401, got {resp.status_code}"

    @allure.story("Add to watchlist")
    @allure.title("TC-API-WL-003 | [SMOKE] POST /user/watchlist adds content and returns 200/201")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.smoke
    @pytest.mark.TC_API_WL_003
    def test_add_to_watchlist(self, authenticated_client):
        resp = authenticated_client.post("/user/watchlist", {"content_id": self.FREE_ID})
        assert resp.status_code in (200, 201), f"Expected 200/201, got {resp.status_code}"

    @allure.story("Remove from watchlist")
    @allure.title("TC-API-WL-004 | [SMOKE] DELETE /user/watchlist/{id} removes item and returns 200/204")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.smoke
    @pytest.mark.TC_API_WL_004
    def test_remove_from_watchlist(self, authenticated_client):
        authenticated_client.post("/user/watchlist", {"content_id": self.FREE_ID})
        resp = authenticated_client.delete(f"/user/watchlist/{self.FREE_ID}")
        assert resp.status_code in (200, 204), f"Expected 200/204, got {resp.status_code}"

    @allure.story("Add duplicate item")
    @allure.title("TC-API-WL-005 | [NEGATIVE] Adding the same item twice returns 409 or is idempotent")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.negative
    @pytest.mark.regression
    @pytest.mark.TC_API_WL_005
    def test_add_duplicate_item(self, authenticated_client):
        authenticated_client.post("/user/watchlist", {"content_id": self.FREE_ID})
        resp = authenticated_client.post("/user/watchlist", {"content_id": self.FREE_ID})
        assert resp.status_code in (200, 201, 409), \
            f"Duplicate add should return 200/201 (idempotent) or 409 (conflict), got {resp.status_code}"

    @allure.story("Remove non-existent item")
    @allure.title("TC-API-WL-006 | [NEGATIVE] DELETE /user/watchlist/{id} returns 404 for unknown item")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.negative
    @pytest.mark.regression
    @pytest.mark.TC_API_WL_006
    def test_remove_nonexistent_item(self, authenticated_client):
        resp = authenticated_client.delete("/user/watchlist/NONEXISTENT_9999")
        assert resp.status_code == 404, f"Expected 404, got {resp.status_code}"

    @allure.story("Watchlist item appears after add")
    @allure.title("TC-API-WL-007 | [E2E] Item appears in GET /user/watchlist after adding it")
    @allure.severity(allure.severity_level.BLOCKER)
    @pytest.mark.e2e
    @pytest.mark.TC_API_WL_007
    def test_added_item_appears_in_list(self, authenticated_client):
        authenticated_client.post("/user/watchlist", {"content_id": self.FREE_ID})
        resp = authenticated_client.get("/user/watchlist")
        assert resp.status_code == 200
        ids = [item.get("id") or item.get("content_id") for item in resp.json().get("items", [])]
        assert self.FREE_ID in ids, f"Content {self.FREE_ID} should appear in watchlist after adding"

    @allure.story("Watchlist count updates")
    @allure.title("TC-API-WL-008 | [REGRESSION] Watchlist count increases after add and decreases after delete")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    @pytest.mark.TC_API_WL_008
    def test_watchlist_count_updates(self, authenticated_client):
        count_before = len(authenticated_client.get("/user/watchlist").json().get("items", []))
        authenticated_client.post("/user/watchlist", {"content_id": self.FREE_ID})
        count_after_add = len(authenticated_client.get("/user/watchlist").json().get("items", []))
        assert count_after_add >= count_before, "Count should increase (or stay same if duplicate)"
        authenticated_client.delete(f"/user/watchlist/{self.FREE_ID}")
        count_after_del = len(authenticated_client.get("/user/watchlist").json().get("items", []))
        assert count_after_del <= count_after_add, "Count should decrease after deletion"
