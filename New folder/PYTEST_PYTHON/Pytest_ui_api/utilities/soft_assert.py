from utilities.logger import get_logger

log = get_logger(__name__)


class SoftAssert:
    """Collect multiple assertion failures and raise them all at once at the end of the test."""

    def __init__(self):
        self._failures: list[str] = []

    def check(self, condition: bool, message: str):
        if not condition:
            log.warning(f"[SOFT ASSERT FAIL] {message}")
            self._failures.append(message)

    def assert_all(self):
        if self._failures:
            summary = "\n".join(f"  - {f}" for f in self._failures)
            raise AssertionError(f"{len(self._failures)} soft assertion(s) failed:\n{summary}")
