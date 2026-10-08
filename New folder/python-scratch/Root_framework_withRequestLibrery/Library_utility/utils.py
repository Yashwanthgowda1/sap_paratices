
import requests


from  auth import Auth
from  logger import  start_logging

class SessionManager:
    _session = None


    @classmethod
    def get_session(cls):
        """
        Get or create a session with the authentication token.
        Returns:
            requests.Session: A session object with the token.
        """
        if cls._session is None:
            logger=start_logging()
            logger.info("new session is created")
            token = Auth.barrer_token_genrate()
            cls._session = requests.Session()
            cls._session.headers.update({"Authorization": f"Bearer {token}"})
            logger.info("new session created")
        return cls._session