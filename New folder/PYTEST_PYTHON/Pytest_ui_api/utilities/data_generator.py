import random
import string
from datetime import datetime


class DataGenerator:
    @staticmethod
    def random_email(domain: str = "testmail.com") -> str:
        rand = "".join(random.choices(string.ascii_lowercase + string.digits, k=8))
        return f"auto_{rand}@{domain}"

    @staticmethod
    def random_string(length: int = 8) -> str:
        return "".join(random.choices(string.ascii_letters, k=length))

    @staticmethod
    def random_password(length: int = 12) -> str:
        chars = string.ascii_letters + string.digits + "@#$!"
        return "".join(random.choices(chars, k=length))

    @staticmethod
    def timestamp_suffix() -> str:
        return datetime.now().strftime("%Y%m%d%H%M%S")
