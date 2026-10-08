from faker import Faker

fake = Faker("en_IN")


class DataGenerator:
    @staticmethod
    def random_email() -> str:
        return fake.email()

    @staticmethod
    def random_phone() -> str:
        return f"9{fake.numerify('#########')}"

    @staticmethod
    def random_name() -> str:
        return fake.name()

    @staticmethod
    def random_password(length: int = 10) -> str:
        return fake.password(length=length, special_chars=True, digits=True, upper_case=True)

    @staticmethod
    def random_string(length: int = 8) -> str:
        return fake.lexify("?" * length)

    @staticmethod
    def random_search_keyword() -> str:
        keywords = ["action", "drama", "comedy", "thriller", "romance", "sports", "news"]
        return fake.random_element(keywords)
