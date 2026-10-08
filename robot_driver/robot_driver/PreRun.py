"""
Robot pre-run snoopers/filters.

Example args and combinations:
    --prerunmodifier PreRun.SimpleList
    --prerunmodifier PreRun.ExcludeTestsWithCountGreaterThanN:2
    --prerunmodifier PreRun.ReportTestTags
    --prerunmodifier PreRun.ExcludeTestsWithCountGreaterThanN:2
    --prerunmodifier PreRun.ExcludeTestsWithCountGreaterThanN:2 --prerunmodifier PreRun.ReportMaxCount
    --prerunmodifier PreRun.RequireTagX:alt_credentials --prerunmodifier PreRun.ReportMaxCount
    --prerunmodifier PreRun.RequirePartialTagX:bvt_pr_blocked
    --prerunmodifier PreRun.RequirePartialTagX
    --prerunmodifier PreRun.ExcludePartialTagX
    --prerunmodifier PreRun.ExcludePartialTagX:bvt
    --prerunmodifier PreRun.ReportTestInfoCSV
    --prerunmodifier PreRun.ReportTestSuppressions[:suppressions.md[:suppressions.txt]]

NOTE: Robot invokes prerun-modifiers SEQUENTAILLY, so order has significance.

Snoopers (info only - no effect on tests executed):
    SimpleList:
        Produces a list of suites and keywords which will be run.
        Note: When using '--dryrun', only top-level keywords are listed.
    ReportMaxCount:
        Produces a list of tests with their 'count' values which will be run.
    ReportTestTags:
        Report Suite, count, testname, and test tags
    ReportTestInfoCSV
        Report Test information in a CSV format
    ReportTestSuppressions
        Report Test supressions in a Markdown or TXT format (output file ends in '.md' or '.txt', default='suppressions.md')

Filters (modifies the test list AFTER robot has processed the command line specifiers):
    ExcludeTestsWithCountGreaterThanN:
        Exclude tests having 'count' greater than N.
    RequireTagX:
        Exclude tests which do NOT have tag 'X' (same as '-i X' command-line option)
    RequirePartialTagX:
        Include only tests with 'tags' containing the specified text (default='blocked_by_').
    ExcludePartialTagX:
        Include only tests without 'tags' containing the specified text (default='blocked_by_').
"""

import os
import sys

from robot.api import SuiteVisitor
from robot.running.model import TestCase, TestSuite, Keyword


def get_robot_aware_abspath(filename: str) -> str:
    # Return the abspath of the indicated file name.
    # If no path separator is specified in the output filename, check for Robot '-d' output directory specification.
    if filename.find(os.sep) == -1:
        for n in range(1, len(sys.argv)):
            if "-d" == sys.argv[n]:
                return os.path.join(sys.argv[n + 1], filename)
    return os.path.abspath(filename)


def recursivly_print_keyword(context: str, kw: Keyword):
    print(f"{kw.id}     {context} Keyword: '{kw}'")
    # No recursion - These never populate in 'pre-run', only in 'visitor's:
    if len(kw.children) > 0:
        raise AssertionError(f"{kw.id} {context} Keyword Children UNEXPECTED, count={len(kw.children)}")
    if len(kw.keywords) > 0:
        raise AssertionError(f"{kw.id} {context} Keyword keywords UNEXPECTED, count={len(kw.keywords)}")


def recursivly_print_suite(suite: TestSuite):
    print(f"{suite.id} - Suite: '{str(suite)}', test count={suite.test_count}):")

    print(f"{suite.id}     Suite Variables, count={len(suite.resource.variables)}")
    for _var in suite.resource.variables:
        print(f"{suite.id}     Suite Variable: '{_var.name}' = {_var.value}")

    print(f"{suite.id}     Suite Keywords, count= {len(suite.keywords)}")
    for _kw in suite.keywords:
        recursivly_print_keyword("Suite", _kw)

    print(f"{suite.id}     Suite Tests, count= {len(suite.tests)}")
    for _test in suite.tests:
        print(f"{_test.id} - Test: '{_test}'")
        print(f"{_test.id}     Test Tags={_test.tags}")

        print(f"{_test.id}     Test Keywords, count={len(_test.keywords)}")
        for _kw in _test.keywords:
            recursivly_print_keyword("Test", _kw)

    if len(suite.suites) > 0:
        print(f"{suite.id}     Sub-Suites ({len(suite.suites)}):")
        for _subsuite in suite.suites:
            recursivly_print_suite(_subsuite)


class SimpleList(SuiteVisitor):
    """
    Prints a list of suites and their keywords.
    """

    def __init__(self):
        pass

    def start_suite(self, suite: TestSuite):
        recursivly_print_suite(suite)
        print("-" * 40)

        # Don't return here anymore, just want the initial startup.
        return False

    def end_suite(self, suite):
        # suite.keywords.teardown = None
        print(f"SuiteTeardown suite={str(suite)}")


def get_tag_value(what: str, test: TestCase):
    lookfor = f"{what}="
    for arg in test.keywords.setup.args:
        if not arg.startswith(lookfor):
            continue
        name, val = arg.split("=")
        if name == what:
            return int(val)
        raise AssertionError(f"Cannot parse {arg} keyword in {test.parent}{test.name}")
    raise AssertionError(f"Cannot find '{lookfor}'... in {test.keywords.setup.args} for {test.parent}{test.name}")


class ExcludeTestsWithCountGreaterThanN(SuiteVisitor):
    """
    I've only got two devices, so I want to ignore tests requiring 'count' > 2.
    Instead of frabricating explicit '--exclude <tags>' lists, this
    filter will exclude tests requiring more "count=N" endpoints.
    """

    def __init__(self, count_max="2"):
        self.count_max = int(count_max)

    def start_suite(self, suite):
        """Remove tests that match the given pattern."""
        suite.tests = [t for t in suite.tests if not self._is_excluded(t)]

    def _is_excluded(self, test):
        """
        Return True is setup.keywords.args contains a "count-N" argument
        where the 'N' value is greater than self.count_max.
        """
        try:
            count = get_tag_value("count", test)
        except Exception as err:
            print(f"** WARNING ** Excluding ({err})")
            return True
        if count > self.count_max:
            print(f"Excluding (count={count}): {test.parent}{test.name}")
            return True

        return False

    def end_suite(self, suite):
        """Remove suites that are empty after removing tests."""
        suite.suites = [s for s in suite.suites if s.test_count > 0]

    def visit_test(self, test):
        # """Avoid visiting tests and their keywords to save a little time."""
        pass


class RequireTagX(SuiteVisitor):
    """
    Filter out tests which do NOT contain the specified tag.
    You would notmally just do a '-i <tag>', this is an aid to developing these filters.
    This just allows me to control WHEN tests are evaluated, for example:
        --dryrun --prerunmodifier PreRun.RequireTagX:alt_credentials --prerunmodifier PreRun.ReportMaxCount
        Will report the number of endpoints for all suites containing tag 'alt_credentials'.
    But if the SAME arguments order is reversed:
        --dryrun --prerunmodifier PreRun.ReportMaxCount --prerunmodifier PreRun.RequireTagX:alt_credentials
        Will report the number of endpoints for ALL suites.
    """

    def __init__(self, tag):
        self.required_tag = tag

    def start_suite(self, suite):
        """Remove tests that match the given pattern."""
        suite.tests = [t for t in suite.tests if not self._is_excluded(t)]

    def _is_excluded(self, test):
        """
        Return True if test.tags contains self.required_tag , else false
        """
        if not self.required_tag in test.tags:
            print(f"Excluding (noTag={self.required_tag}): {test.name}")
            return True
        return False

    def end_suite(self, suite):
        """Remove suites that are empty after removing tests."""
        suite.suites = [s for s in suite.suites if s.test_count > 0]

    def visit_test(self, test):
        # """Avoid visiting tests and their keywords to save a little time."""
        pass


class RequirePartialTagX(SuiteVisitor):
    """
    Similar to RequireTagX, but this examines each tag and only accepts the test
    when a tag 'containing' the text specified in 'required_partial_tag' exists.
    """

    def __init__(self, required_partial_tag="blocked_by_"):
        self.required_partial_tag = required_partial_tag

    def start_suite(self, suite):
        """Remove tests that do not have tags containing the given required_partial_tag."""
        suite.tests = [t for t in suite.tests if not self._is_excluded(suite.name, t)]

    def _is_excluded(self, suitename, test):
        """
        Return True if test.tags contains a tag containing self.required_partial_tag , else false
        """
        for tag in test.tags:
            if self.required_partial_tag in tag:
                # print(f"Tag={tag} contains {self.required_partial_tag}): {suitename} {test.name}")
                return False
        return True

    def end_suite(self, suite):
        """Remove suites that are empty after removing tests."""
        suite.suites = [s for s in suite.suites if s.test_count > 0]

    def visit_test(self, test):
        # """Avoid visiting tests and their keywords to save a little time."""
        pass


class ExcludePartialTagX(SuiteVisitor):
    """
    Similar to RequireTagX, but this examines each tag and only accepts the test
    when a tag 'containing' the text specified in 'required_partial_tag' exists.
    """

    def __init__(self, required_partial_tag="blocked_by_"):
        self.required_partial_tag = required_partial_tag

    def start_suite(self, suite):
        """Remove tests that do have tags containing the given required_partial_tag."""
        suite.tests = [t for t in suite.tests if self._is_excluded(suite.name, t)]

    def _is_excluded(self, suitename, test):
        """
        Return True if test.tags contains a tag containing self.required_partial_tag , else false
        """
        for tag in test.tags:
            if self.required_partial_tag in tag:
                print(f"Tag={tag} contains {self.required_partial_tag}): {suitename} {test.name}")
                return False
        return True

    def end_suite(self, suite):
        """Remove suites that are empty after removing tests."""
        suite.suites = [s for s in suite.suites if s.test_count > 0]

    def visit_test(self, test):
        # """Avoid visiting tests and their keywords to save a little time."""
        pass


class ReportMaxCount(SuiteVisitor):
    """
    I need to know how many endpoints each suite has specified.
    Just print the maximum value reported in "count=N" for each suite.
    """

    def start_suite(self, suite):
        _count_max = 0
        for test in suite.tests:
            try:
                count = get_tag_value("count", test)
                if count > _count_max:
                    _count_max = count
            except Exception as err:
                print(f"** WARNING ** Ignoring ({err})")

        print(f"{_count_max} Suite: {suite.name}")


class ReportTestTags(SuiteVisitor):
    """
    Report Suite, count, testname, and test tags
    """

    def start_test(self, test):
        try:
            count = get_tag_value("count", test)
        except Exception as err:
            print(f"** WARNING ** Ignoring ({err})")
            count = 0
        print(f"{count},{test.parent},{test},{test.tags}")


class ReportTestInfoCSV(SuiteVisitor):
    """
    Report Test information to a CSV file
    """

    def __init__(self, filename="TestInfo.csv"):
        self.filename = get_robot_aware_abspath(filename)
        self.csv_header = "Count,Parent,TestName,Tags"

        # Initialize the output file
        if os.path.exists(self.filename):
            os.remove(self.filename)
        self.outfile = open(self.filename, "w", encoding="utf-8", buffering=1)

        self.outfile.write(self.csv_header + "\n")

    def csv_str(self, noncsv: str):
        return noncsv.replace(",", "[ACOMMA]")

    def start_test(self, test):
        try:
            count = get_tag_value("count", test)
        except Exception as err:
            print(f"** WARNING ** Ignoring ({err})")
            count = 0
        self.outfile.write(f"{count},{test.parent},{self.csv_str(test.name)},{str.join(' ',test.tags)}\n")


class ReportTestSuppressions(SuiteVisitor):
    """
    Report Test Suppressions to a .MD or .TXT file.
    Suppressed tests contain a tag with the form:
        [original tag]_blocked_by_[bug number]
    """

    def __init__(self, outfile="Suppressions.md"):
        # Full pathname output file:
        self.outfile = get_robot_aware_abspath(outfile)
        self.is_md_output = outfile.lower().endswith(".md")

        # Initialize the output file
        if os.path.exists(self.outfile):
            os.remove(self.outfile)
        self.out = open(self.outfile, "w", encoding="utf-8", buffering=1)
        print(f"Suppressed tests will be written to: '{self.outfile}'")

        if self.is_md_output:
            self.out.write("|TestKey|Bug|BugState|Suite|Test|\n")
            self.out.write("|--|--|--|--|--|\n")

    def start_suite(self, suite):
        for test in suite.tests:
            for tag in test.tags:
                # Note: Loose 'blocked_' tag detection, strict parsing - keeping them clean.
                if "blocked_" in tag.lower():
                    if not "_blocked_by_" in tag:
                        self.out.write(
                            f"ERROR: Malformed block tag '{tag}' does NOT contain '_blocked_by_'. Suite '{suite.name}', Test '{test.name}'"
                        )
                        continue
                    _pieces = str(tag).split("_blocked_by_")
                    if len(_pieces) != 2:
                        self.out.write(
                            f"ERROR: Malformed block tag '{tag}' contains multiple '_blocked_by_' sequences. Suite '{suite.name}', Test '{test.name}'"
                        )
                        continue

                    # Ok, found a suppression, print it
                    if self.is_md_output:
                        self.out.write(
                            f"{test.tags[0]}|[{_pieces[1]}](https://domoreexp.visualstudio.com/MSTeams/_workitems/edit/{_pieces[1]})|Unknown|{suite.name}|{test.name}"
                        )
                    else:
                        self.out.write(
                            f"Test id {test.tags[0]} blocked by Bug {_pieces[1]}: Original tag: '{_pieces[0]}', Suite: {suite.name}, Test: {test.name}"
                        )
                    self.out.write("\n")
                    # break - no, continue to check all the tags.
