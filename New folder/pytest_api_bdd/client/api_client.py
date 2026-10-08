import requests
from config.settings import Config
from utils.logger import get_logger

logger = get_logger("http_client")


class APIClient:
    # ------------------------------------------------------------------ #
    #  Internal setup — tests never touch session directly               #
    # ------------------------------------------------------------------ #

    def __init__(self, base_url: str = Config.BASE_URL, token: str = None):
        self.base_url = base_url.rstrip("/")
        self._session = self._create_session(token)  # fully internal

    def _create_session(self, token: str) -> requests.Session:
        """Build and configure the session once. Never called by tests."""
        session = requests.Session()
        session.headers.update({
            "Content-Type": "application/json",
            "Accept":        "application/json",
        })
        if token:
            session.headers.update({"Cookie": f"token={token}"})
        return session

    def _build_url(self, endpoint: str) -> str:
        return f"{self.base_url}/{endpoint.lstrip('/')}"

    def _log_response(self, response: requests.Response) -> None:
        logger.debug(f"  <- {response.status_code}  ({response.elapsed.total_seconds():.3f}s)")

    # ------------------------------------------------------------------ #
    #  Public HTTP methods                                                 #
    #  Signature:  method(endpoint, payload=None)                         #
    #                                                                      #
    #  GET   → payload goes to params= (query string)                     #
    #  POST / PUT / PATCH → payload goes to json= (request body)         #
    #  DELETE → no payload needed                                         #
    # ------------------------------------------------------------------ #

    def get(self, endpoint: str, payload: dict = None) -> requests.Response:
        """
        GET request.  payload becomes query-string params.

        test usage:
            response = api_client.get("/booking")
            response = api_client.get("/booking", payload={"firstname": "Yash"})
        """
        url = self._build_url(endpoint)
        logger.info(f"GET  {url}  params={payload}")
        response = self._session.get(url, params=payload, timeout=Config.TIMEOUT)
        self._log_response(response)
        return response

    def post(self, endpoint: str, payload: dict = None) -> requests.Response:
        """
        POST request.  payload becomes JSON body.

        test usage:
            response = api_client.post("/booking", payload={...})
        """
        url = self._build_url(endpoint)
        logger.info(f"POST {url}  body={payload}")
        response = self._session.post(url, json=payload, timeout=Config.TIMEOUT)
        self._log_response(response)
        return response

    def put(self, endpoint: str, payload: dict = None) -> requests.Response:
        """
        PUT request (full update).  payload becomes JSON body.

        test usage:
            response = api_client.put("/booking/1", payload={...})
        """
        url = self._build_url(endpoint)
        logger.info(f"PUT  {url}  body={payload}")
        response = self._session.put(url, json=payload, timeout=Config.TIMEOUT)
        self._log_response(response)
        return response

    def patch(self, endpoint: str, payload: dict = None) -> requests.Response:
        """
        PATCH request (partial update).  payload becomes JSON body.

        test usage:
            response = api_client.patch("/booking/1", payload={"totalprice": 999})
        """
        url = self._build_url(endpoint)
        logger.info(f"PATCH {url}  body={payload}")
        response = self._session.patch(url, json=payload, timeout=Config.TIMEOUT)
        self._log_response(response)
        return response

    def delete(self, endpoint: str) -> requests.Response:
        """
        DELETE request.  No payload.

        test usage:
            response = api_client.delete("/booking/1")
        """
        url = self._build_url(endpoint)
        logger.info(f"DELETE {url}")
        response = self._session.delete(url, timeout=Config.TIMEOUT)
        self._log_response(response)
        return response

    def close(self) -> None:
        """Close the internal session. Called by conftest teardown."""
        self._session.close()
