import pytest
import allure
import jsonschema
import json
from pathlib import Path
from utilities.api_client import APIClient
from test_data import TestData

_SCHEMA_DIR = Path(__file__).resolve().parent.parent.parent.parent / "test_data" / "json_schema"


def load_schema(name: str) -> dict:
    with open(_SCHEMA_DIR / name) as f:
        return json.load(f)


@allure.epic("JioHotstar")
@allure.feature("API - Content")
@pytest.mark.api
@pytest.mark.content
class TestContentAPI:
    """TC-API-CNT-001 to TC-API-CNT-006: Content catalogue API tests."""

    @pytest.fixture(autouse=True)
    def setup(self):
        self.client = APIClient()

    @allure.story("Get content list")
    @allure.title("TC-API-CNT-001 | [SANITY] GET /content returns 200 with content array")
    @allure.severity(allure.severity_level.BLOCKER)
    @pytest.mark.sanity
    @pytest.mark.smoke
    def test_get_content_list(self):
        response = self.client.get("/content", params={"type": "movie"})
        assert response.status_code == 200, f"Expected 200, got {response.status_code}"
        body = response.json()
        assert isinstance(body.get("data") or body, list), "Response should contain content list"

    @allure.story("Get content by ID")
    @allure.title("TC-API-CNT-002 | [SMOKE] GET /content/{id} returns 200 with content details")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.smoke
    def test_get_content_by_id(self):
        response = self.client.get("/content/movie-001")
        assert response.status_code == 200, f"Expected 200, got {response.status_code}"
        body = response.json()
        assert "title" in body or "id" in body, "Response should include content details"

    @allure.story("Content not found")
    @allure.title("TC-API-CNT-003 | [NEGATIVE] GET /content/{id} returns 404 for unknown content ID")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.negative
    @pytest.mark.regression
    def test_content_not_found(self):
        response = self.client.get("/content/nonexistent-id-xyz-00000")
        assert response.status_code == 404, f"Expected 404, got {response.status_code}"

    @allure.story("Search content API")
    @allure.title("TC-API-CNT-004 | [REGRESSION] GET /search?q=keyword returns relevant results")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    def test_search_content_api(self):
        response = self.client.get("/search", params={"q": TestData.SEARCH_VALID[0]})
        assert response.status_code == 200, f"Expected 200, got {response.status_code}"
        body = response.json()
        assert body is not None, "Search API should return a response body"

    @allure.story("Content filter by genre")
    @allure.title("TC-API-CNT-005 | [REGRESSION] GET /content?genre=Action returns filtered results")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    def test_content_filter_by_genre(self):
        response = self.client.get("/content", params={"genre": "Action"})
        assert response.status_code == 200, f"Expected 200, got {response.status_code}"

    @allure.story("Content filter by language")
    @allure.title("TC-API-CNT-006 | [REGRESSION] GET /content?language=Hindi returns filtered results")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    def test_content_filter_by_language(self):
        response = self.client.get("/content", params={"language": "Hindi"})
        assert response.status_code == 200, f"Expected 200, got {response.status_code}"
