"""Custom soft-assertion helper — collects failures instead of stopping on first."""
from typing import Any, List
from utilities.logger import get_logger

log = get_logger(__name__)


class SoftAssert:
    def __init__(self):
        self._failures: List[str] = []

    def assert_equal(self, actual: Any, expected: Any, msg: str = ""):
        if actual != expected:
            err = f"{msg} | Expected: {expected!r}, Got: {actual!r}"
            log.warning(f"[SOFT ASSERT FAIL] {err}")
            self._failures.append(err)
        else:
            log.debug(f"[SOFT ASSERT PASS] {msg or f'{actual!r} == {expected!r}'}")

    def assert_true(self, condition: bool, msg: str = ""):
        if not condition:
            err = f"{msg} | Expected True, Got False"
            log.warning(f"[SOFT ASSERT FAIL] {err}")
            self._failures.append(err)

    def assert_false(self, condition: bool, msg: str = ""):
        if condition:
            err = f"{msg} | Expected False, Got True"
            log.warning(f"[SOFT ASSERT FAIL] {err}")
            self._failures.append(err)

    def assert_in(self, member: Any, container: Any, msg: str = ""):
        if member not in container:
            err = f"{msg} | {member!r} not found in {container!r}"
            log.warning(f"[SOFT ASSERT FAIL] {err}")
            self._failures.append(err)

    def assert_contains(self, text: str, substring: str, msg: str = ""):
        if substring not in text:
            err = f"{msg} | '{substring}' not in '{text}'"
            log.warning(f"[SOFT ASSERT FAIL] {err}")
            self._failures.append(err)

    def assert_all(self):
        """Call at end of test to raise any collected failures."""
        if self._failures:
            summary = "\n".join(f"  {i+1}. {f}" for i, f in enumerate(self._failures))
            raise AssertionError(f"{len(self._failures)} soft assertion(s) failed:\n{summary}")
