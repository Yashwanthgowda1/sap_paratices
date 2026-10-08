import requests
from config.config import WebConfig
from utilities.logger import get_logger

log = get_logger(__name__)


class APIClient:
    """
    Lightweight REST API client wrapping the requests library.
    Used for:
      - API-only test cases
      - Seeding test data before UI tests
      - Verifying backend state after UI actions
    """

    def __init__(self, base_url: str = None):
        self.base_url = (base_url or WebConfig.API_BASE_URL).rstrip("/")
        self.session  = requests.Session()
        self.session.headers.update({"Content-Type": "application/json"})

    def set_auth_header(self, token: str):
        self.session.headers.update({"Authorization": f"Bearer {token}"})
        log.debug("Auth token set on API client")

    def get(self, endpoint: str, params: dict = None) -> requests.Response:
        url = f"{self.base_url}{endpoint}"
        log.info(f"GET  {url}  params={params}")
        response = self.session.get(url, params=params)
        log.debug(f"Response [{response.status_code}]: {response.text[:200]}")
        return response

    def post(self, endpoint: str, payload: dict = None) -> requests.Response:
        url = f"{self.base_url}{endpoint}"
        log.info(f"POST {url}  payload={payload}")
        response = self.session.post(url, json=payload)
        log.debug(f"Response [{response.status_code}]: {response.text[:200]}")
        return response

    def put(self, endpoint: str, payload: dict = None) -> requests.Response:
        url = f"{self.base_url}{endpoint}"
        log.info(f"PUT  {url}")
        response = self.session.put(url, json=payload)
        log.debug(f"Response [{response.status_code}]: {response.text[:200]}")
        return response

    def delete(self, endpoint: str) -> requests.Response:
        url = f"{self.base_url}{endpoint}"
        log.info(f"DELETE {url}")
        response = self.session.delete(url)
        log.debug(f"Response [{response.status_code}]")
        return response
