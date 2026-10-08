import os
import requests
from config.config import Config
from utilities.logger import get_logger

log = get_logger(__name__)

_HS_HEADERS = {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
    "x-hs-platform": "PCTV",
    "x-hs-appversion": "6.0.0",
    "x-country-code": "IN",
    "x-hs-client-id": os.getenv("CLIENT_ID", "test-client"),
}


class APIClient:
    """Thin wrapper around requests.Session for JioHotstar API calls."""

    def __init__(self, base_url: str = None, token: str = None):
        self.base_url = (base_url or Config.API_BASE_URL).rstrip("/")
        self.session = requests.Session()
        self.session.headers.update(_HS_HEADERS)
        if token:
            self.session.headers.update({"Authorization": f"Bearer {token}"})

    # ── Auth helpers ──────────────────────────────────────────────────────────
    def set_auth_header(self, token: str):
        self.session.headers.update({"Authorization": f"Bearer {token}"})

    def clear_auth_header(self):
        self.session.headers.pop("Authorization", None)

    # ── HTTP verbs ─────────────────────────────────────────────────────────────
    def get(self, endpoint: str, params: dict = None, **kwargs) -> requests.Response:
        url = f"{self.base_url}{endpoint}"
        log.info(f"GET {url} | params={params}")
        resp = self.session.get(url, params=params, **kwargs)
        self._log_response(resp)
        return resp

    def post(self, endpoint: str, payload: dict = None, **kwargs) -> requests.Response:
        url = f"{self.base_url}{endpoint}"
        log.info(f"POST {url} | payload={payload}")
        resp = self.session.post(url, json=payload, **kwargs)
        self._log_response(resp)
        return resp

    def put(self, endpoint: str, payload: dict = None, **kwargs) -> requests.Response:
        url = f"{self.base_url}{endpoint}"
        log.info(f"PUT {url}")
        resp = self.session.put(url, json=payload, **kwargs)
        self._log_response(resp)
        return resp

    def delete(self, endpoint: str, **kwargs) -> requests.Response:
        url = f"{self.base_url}{endpoint}"
        log.info(f"DELETE {url}")
        resp = self.session.delete(url, **kwargs)
        self._log_response(resp)
        return resp

    def patch(self, endpoint: str, payload: dict = None, **kwargs) -> requests.Response:
        url = f"{self.base_url}{endpoint}"
        log.info(f"PATCH {url}")
        resp = self.session.patch(url, json=payload, **kwargs)
        self._log_response(resp)
        return resp

    @staticmethod
    def _log_response(resp: requests.Response):
        log.debug(f"Response [{resp.status_code}]: {resp.text[:400]}")
