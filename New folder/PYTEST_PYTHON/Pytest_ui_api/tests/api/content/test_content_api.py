import pytest
import allure
from utilities.schema_validator import assert_schema
from test_data import TestData
from config.config import Config


@allure.epic("JioHotstar")
@allure.feature("API - Content Catalogue")
@pytest.mark.api
@pytest.mark.content
class TestContentAPI:
    """TC-API-CNT-001 to TC-API-CNT-010: Content catalogue REST API tests."""

    @allure.story("GET /content returns list")
    @allure.title("TC-API-CNT-001 | [SANITY] GET /content returns 200 with content array")
    @allure.severity(allure.severity_level.BLOCKER)
    @pytest.mark.sanity
    @pytest.mark.smoke
    @pytest.mark.TC_API_CNT_001
    def test_get_content_returns_200(self, api_client):
        resp = api_client.get("/content")
        assert resp.status_code == 200, f"Expected 200, got {resp.status_code}"
        body = resp.json()
        assert_schema(body, "content_list_response.json")
        assert isinstance(body.get("items"), list), "'items' should be a list"

    @allure.story("GET /content/{id} returns detail")
    @allure.title("TC-API-CNT-002 | [SMOKE] GET /content/{id} returns content details")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.smoke
    @pytest.mark.TC_API_CNT_002
    def test_get_content_by_id(self, api_client):
        content_id = Config.FREE_CONTENT_ID
        resp = api_client.get(f"/content/{content_id}")
        assert resp.status_code == 200, f"Expected 200, got {resp.status_code}"
        body = resp.json()
        assert_schema(body, "content_detail_response.json")
        assert body.get("id") == content_id, "Response ID should match requested ID"

    @allure.story("GET /content/{id} — unknown ID")
    @allure.title("TC-API-CNT-003 | [NEGATIVE] GET /content/{id} returns 404 for unknown content ID")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.negative
    @pytest.mark.regression
    @pytest.mark.TC_API_CNT_003
    def test_get_content_unknown_id_returns_404(self, api_client):
        resp = api_client.get("/content/NONEXISTENT_ID_9999")
        assert resp.status_code == 404, f"Expected 404, got {resp.status_code}"

    @allure.story("GET /search returns relevant results")
    @allure.title("TC-API-CNT-004 | [SMOKE] GET /search?q= returns relevant results")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.smoke
    @pytest.mark.TC_API_CNT_004
    def test_search_returns_results(self, api_client):
        resp = api_client.get("/search", params={"q": TestData.CONTENT["search_keyword"]})
        assert resp.status_code == 200, f"Expected 200, got {resp.status_code}"
        body = resp.json()
        assert body.get("items") is not None, "Search response must include 'items'"

    @allure.story("Content filter by genre")
    @allure.title("TC-API-CNT-005 | [REGRESSION] GET /content?genre= filters by genre")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    @pytest.mark.TC_API_CNT_005
    def test_content_filter_by_genre(self, api_client):
        resp = api_client.get("/content", params={"genre": "drama"})
        assert resp.status_code == 200, f"Expected 200, got {resp.status_code}"
        body = resp.json()
        assert isinstance(body.get("items"), list), "Filtered result must be a list"

    @allure.story("Content filter by language")
    @allure.title("TC-API-CNT-006 | [REGRESSION] GET /content?language= filters by language")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    @pytest.mark.TC_API_CNT_006
    def test_content_filter_by_language(self, api_client):
        resp = api_client.get("/content", params={"language": "hindi"})
        assert resp.status_code == 200, f"Expected 200, got {resp.status_code}"

    @allure.story("Content pagination")
    @allure.title("TC-API-CNT-007 | [REGRESSION] GET /content supports page and limit params")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    @pytest.mark.TC_API_CNT_007
    def test_content_pagination(self, api_client):
        resp = api_client.get("/content", params={"page": 1, "limit": 5})
        assert resp.status_code == 200, f"Expected 200, got {resp.status_code}"
        items = resp.json().get("items", [])
        assert len(items) <= 5, "Page size should respect 'limit' parameter"

    @allure.story("Search — empty query")
    @allure.title("TC-API-CNT-008 | [NEGATIVE] GET /search with empty query returns 400")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.negative
    @pytest.mark.regression
    @pytest.mark.TC_API_CNT_008
    def test_search_empty_query(self, api_client):
        resp = api_client.get("/search", params={"q": ""})
        assert resp.status_code in (400, 422), f"Expected 4xx for empty query, got {resp.status_code}"

    @allure.story("Parametrised search keywords")
    @allure.title("TC-API-CNT-009 | [REGRESSION] Parametrised search returns results for each keyword")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    @pytest.mark.TC_API_CNT_009
    @pytest.mark.parametrize("keyword", TestData.SEARCH_KEYWORDS_VALID)
    def test_parametrised_search(self, api_client, keyword):
        resp = api_client.get("/search", params={"q": keyword})
        assert resp.status_code == 200, f"Search '{keyword}' expected 200, got {resp.status_code}"

    @allure.story("Content API response time")
    @allure.title("TC-API-CNT-010 | [PERFORMANCE] GET /content responds within 2 seconds")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    @pytest.mark.TC_API_CNT_010
    def test_content_list_response_time(self, api_client):
        resp = api_client.get("/content")
        elapsed = resp.elapsed.total_seconds()
        assert elapsed < 2.0, f"Content list API took {elapsed:.2f}s — exceeds 2s threshold"
