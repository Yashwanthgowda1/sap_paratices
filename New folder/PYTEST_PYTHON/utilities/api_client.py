import os
import requests
from config.config import Config
from utilities.logger import get_logger

log = get_logger(__name__)


class APIClient:
    def __init__(self, base_url: str = None, token: str = None):
        self.base_url = base_url or Config.API_BASE_URL
        self.session = requests.Session()
        if token:
            self.session.headers.update({"Authorization": f"Bearer {token}"})
        self.session.headers.update({
            "Content-Type": "application/json",
            "Accept": "application/json",
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36",
            "x-hs-platform": "PCTV",
            "x-hs-appversion": "6.0.0",
            "x-country-code": "IN",
            "x-hs-client-id": os.getenv("CLIENT_ID", ""),
        })

    def get(self, endpoint: str, params: dict = None, **kwargs) -> requests.Response:
        url = f"{self.base_url}{endpoint}"
        log.info(f"GET {url} | params={params}")
        response = self.session.get(url, params=params, **kwargs)
        log.debug(f"Response [{response.status_code}]: {response.text[:300]}")
        return response

    def post(self, endpoint: str, payload: dict = None, **kwargs) -> requests.Response:
        url = f"{self.base_url}{endpoint}"
        log.info(f"POST {url} | payload={payload}")
        response = self.session.post(url, json=payload, **kwargs)
        log.debug(f"Response [{response.status_code}]: {response.text[:300]}")
        return response

    def put(self, endpoint: str, payload: dict = None, **kwargs) -> requests.Response:
        url = f"{self.base_url}{endpoint}"
        log.info(f"PUT {url}")
        response = self.session.put(url, json=payload, **kwargs)
        log.debug(f"Response [{response.status_code}]: {response.text[:300]}")
        return response

    def delete(self, endpoint: str, **kwargs) -> requests.Response:
        url = f"{self.base_url}{endpoint}"
        log.info(f"DELETE {url}")
        response = self.session.delete(url, **kwargs)
        log.debug(f"Response [{response.status_code}]: {response.text[:300]}")
        return response

    def set_auth_header(self, token: str):
        self.session.headers.update({"Authorization": f"Bearer {token}"})
