from utilities.logger import get_logger

log = get_logger(__name__)


class SoftAssert:
    """
    Soft assertions — collect ALL failures in a test, report them together.

    Normal assert:   stops test at first failure (hard assert)
    SoftAssert:      records failures, test continues, all failures reported at end

    Example use case:
        Check 10 fields on a form — report ALL wrong fields, not just the first one.
    """

    def __init__(self):
        self._failures = []

    def assert_equal(self, actual, expected, message: str = ""):
        if actual != expected:
            msg = f"SOFT ASSERT FAILED: {message} | Expected='{expected}' Actual='{actual}'"
            log.warning(msg)
            self._failures.append(msg)
        else:
            log.debug(f"SOFT ASSERT PASSED: {message}")

    def assert_true(self, condition: bool, message: str = ""):
        if not condition:
            msg = f"SOFT ASSERT FAILED: {message} | Condition is False"
            log.warning(msg)
            self._failures.append(msg)

    def assert_false(self, condition: bool, message: str = ""):
        if condition:
            msg = f"SOFT ASSERT FAILED: {message} | Condition is True (expected False)"
            log.warning(msg)
            self._failures.append(msg)

    def assert_in(self, item, container, message: str = ""):
        if item not in container:
            msg = f"SOFT ASSERT FAILED: {message} | '{item}' not found in '{container}'"
            log.warning(msg)
            self._failures.append(msg)

    def assert_all(self):
        """Call at end of test — raises ONE combined error if any soft asserts failed."""
        if self._failures:
            combined = "\n".join(f"  [{i+1}] {f}" for i, f in enumerate(self._failures))
            raise AssertionError(f"{len(self._failures)} soft assertion(s) failed:\n{combined}")
        self._failures.clear()
