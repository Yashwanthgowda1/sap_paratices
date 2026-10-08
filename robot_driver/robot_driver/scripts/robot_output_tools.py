import datetime
from datetime import timedelta
import os
import logging
import xml.dom.minidom
from csv_tools import csv_safe_string


class Rbt_Test:
    def __init__(self, test_name, test_status, test_start_time, test_end_time, test_tags) -> None:
        self.test_name = test_name
        self.test_status = test_status
        self.test_start_time = test_start_time
        self.test_end_time = test_end_time
        self.test_tags = test_tags

        # Generate some fields:
        self.test_duration = duration_from_robot_timestamps(test_start_time, test_end_time)
        self.test_unique_tag = unique_robot_tag(test_tags)

        self.keywords = []

    def csv(self):
        # Note: 'test_duration' is a 'timedelta' and can also be reported as
        #   test_duration.seconds or
        #   test_duration.microseconds

        return f"{csv_safe_string(self.test_name)},{self.test_status},{self.test_duration},{self.test_unique_tag}"

    @staticmethod
    def CSV_title():
        return "test name,test status,test duration,unique tag"

    @staticmethod
    def CSV_blank():
        return "," * str(Rbt_Test.CSV_title()).count(",")


class Rbt_Keyword:
    def __init__(self, kw_name, kw_library, kw_status, kw_start_time, kw_end_time, kw_type, depth) -> None:
        self.kw_name = kw_name
        self.kw_library = kw_library
        self.kw_status = kw_status
        self.kw_start_time = kw_start_time
        self.kw_end_time = kw_end_time
        self.kw_type = kw_type
        self.depth = depth

        self.keywords = []

        # Generate some fields:
        self.duration = duration_from_robot_timestamps(kw_start_time, kw_end_time)

    def csv(self):
        return f"{self.kw_library},{self.kw_name},{self.depth},{self.kw_status},{self.duration},{self.kw_type}"

    @staticmethod
    def CSV_title():
        return "kw_library,kw_name,kw_depth,kw_status,kw_duration,kw_type"

    @staticmethod
    def CSV_blank():
        return "," * str(Rbt_Keyword.CSV_title()).count(",")


class Rbt_Suite:
    def __init__(self, dirname, name, start_time, end_time, result) -> None:
        self.name = name
        self.dirname = dirname
        self.start_time = start_time
        self.end_time = end_time
        self.result = result

        self.keywords = []
        self.subsuites = []
        self.testcases = []

        # Generate some fields:
        self.duration = duration_from_robot_timestamps(start_time, end_time)

    def to_string(self) -> str:
        ret = "Rbt_Suite:"
        ret += f"\n\tname:      {self.name}"
        ret += f"\n\tdirname:   {self.dirname}"
        ret += f"\n\tresult:    {self.result}"
        ret += f"\n\tkeywords:  {len(self.keywords)}"
        ret += f"\n\tsubsuites: {len(self.subsuites)}"
        ret += f"\n\ttestcases: {len(self.testcases)}"
        return ret

    def csv(self):
        return f"{self.name},{self.duration},{self.result}"

    @staticmethod
    def CSV_title():
        return "suitename,suiteduration,result"

    @staticmethod
    def CSV_blank():
        return "," * str(Rbt_Suite.CSV_title()).count(",")


class Rbt_Root:
    def __init__(self, dirname) -> None:
        self.dirname = dirname

        # Read the Robot output.xml file:
        self.robot_xml = xml.dom.minidom.parse(os.path.join(self.dirname, "output.xml"))

        _root_element = self.robot_xml.firstChild
        self.name = _root_element.localName
        self.generator = _root_element.getAttribute("generator")
        self.generated = _root_element.getAttribute("generated")
        self.rpa = _root_element.getAttribute("rpa")

        self.root_suite = None
        self.parsed = False

    def to_string(self) -> str:
        ret = "Rbt_Root: " + str(type(self))
        ret += f"\n\t name:      {self.name}"
        ret += f"\n\t dirname:   {self.dirname}"
        ret += f"\n\t generator: {self.generator}"
        ret += f"\n\t generated: {self.generated}"
        ret += f"\n\t rpa:       {self.rpa}"
        return ret

    def emit_csv(
        self,
        max_depth,
        tag,
        classifier,
        root_csv,
        suite_csv,
        suite_kw_csv,
        subsuite_csv,
        subsuite_kw_csv,
        subsuite_tc_csv,
        subsuite_tc_kw_csv,
        sub_subsuite_csv,
        sub_subsuite_kw_csv,
        sub_subsuite_tc_csv,
        sub_subsuite_tc_kw_csv,
    ):
        if max_depth == 1:
            # pylint: disable=consider-using-f-string
            logging.info(
                "%s,%s,%s,%s,%s,%s,%s,%s,%s"
                % (
                    tag,
                    classifier,
                    root_csv,
                    suite_csv,
                    suite_kw_csv,
                    subsuite_csv,
                    subsuite_kw_csv,
                    subsuite_tc_csv,
                    subsuite_tc_kw_csv,
                )
            )
        elif max_depth == 2:
            # pylint: disable=consider-using-f-string
            logging.info(
                "%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s"
                % (
                    tag,
                    classifier,
                    root_csv,
                    suite_csv,
                    suite_kw_csv,
                    subsuite_csv,
                    subsuite_kw_csv,
                    subsuite_tc_csv,  # TODO: We never put tc in a sub_subsuite parent, report anyway?
                    subsuite_tc_kw_csv,  # TODO: We never put tc_kws in a sub_subsuite parent, report anyway?
                    sub_subsuite_csv,
                    sub_subsuite_kw_csv,
                    sub_subsuite_tc_csv,
                    sub_subsuite_tc_kw_csv,
                )
            )
        else:
            raise AssertionError(f"Cannot format for max_depth of {max_depth}")

    def csv(self):
        return f"{self.dirname},{self.generated}"

    @staticmethod
    def CSV_title():
        return "dir,generated"

    @staticmethod
    def CSV_blank():
        return "," * str(Rbt_Root.CSV_title()).count(",")

    def parse(self):
        # All the XML parsing
        def get_tags_from_xml(tags_node: xml.dom.Node):
            _tmp_list = []
            for _tag_node in tags_node.childNodes:
                if _tag_node.nodeName in ["#text"]:
                    continue

                if _tag_node.nodeName != "tag":
                    raise AssertionError(f"Unexpected: found '{_tag_node.nodeName}' in a 'tags' Nodelist")

                # TODO: Odd, the values are in '#text' sub-nodes?????
                for _sub_tag_node in _tag_node.childNodes:
                    _tmp_list.append(_sub_tag_node.nodeValue)

                    # TODO: Return just the 'nice' tag, or all??
                    # _candidate_tag = _sub_tag_node.nodeValue
                    # if str(_candidate_tag).isnumeric() and int(_candidate_tag) > 100000:
                    #     return csv_safe_string(childnode.userdata)
            return str.join(",", _tmp_list)

        def get_child_element_by_name(parent_node: xml.dom.Node, child_node_name: str):
            _parent_name = parent_node.getAttribute("name")
            for _child_node in parent_node.childNodes:
                if _child_node.nodeName == child_node_name:
                    return _child_node
            raise AssertionError(f"parent '{_parent_name}' has no child with name '{child_node_name}'")

        def get_test_from_xml(node: xml.dom.Node):
            _testname = node.getAttribute("name")

            # Forward-scan for the corresponding 'status' and 'tags' nodes
            _test_status_node = get_child_element_by_name(node, "status")
            _test_status = _test_status_node.getAttribute("status")
            _test_start_time = _test_status_node.getAttribute("starttime")
            _test_end_time = _test_status_node.getAttribute("endtime")

            _test_tags_node = get_child_element_by_name(node, "tags")
            _test_tags = get_tags_from_xml(_test_tags_node)

            theTest = Rbt_Test(_testname, _test_status, _test_start_time, _test_end_time, _test_tags)

            for childnode in node.childNodes:
                if childnode.nodeName in ["#text", "doc", "tags", "status"]:
                    continue
                if childnode.nodeName == "kw":
                    theTest.keywords.extend(recurse_keyword_node(childnode, 0))
                else:
                    raise AssertionError(f"Unknown test child node: {childnode.nodeName}")
            return theTest

        def get_keyword_from_xml(node: xml.dom.Node, depth):
            _kw_name = node.getAttribute("name")
            _kw_library = node.getAttribute("library")
            _kw_type = None
            if node.hasAttribute("type"):
                _kw_type = node.getAttribute("type")

            childnode = get_child_element_by_name(node, "status")
            _kw_status = childnode.getAttribute("status")
            _kw_start_time = childnode.getAttribute("starttime")
            _kw_end_time = childnode.getAttribute("endtime")
            return Rbt_Keyword(_kw_name, _kw_library, _kw_status, _kw_start_time, _kw_end_time, _kw_type, depth)

        def recurse_keyword_node(node, depth: int):
            _kwlist = []
            _kwlist.append(get_keyword_from_xml(node, depth))

            # Then, look for child 'kw' nodes and recurse into them:
            for childnode in node.childNodes:
                if childnode.nodeName == "kw":
                    _kwlist.extend(recurse_keyword_node(childnode, depth + 1))
            return _kwlist

        def get_suite_attributes_from_xml(node: xml.dom.Node):
            _suite_name = node.getAttribute("name")

            _status_node = get_child_element_by_name(node, "status")
            _result = _status_node.getAttribute("status")
            _start_time = _status_node.getAttribute("starttime")
            _end_time = _status_node.getAttribute("endtime")

            return _suite_name, _result, _start_time, _end_time

        def get_only_subsuite(suite_node: xml.dom.Node):
            # Decide if we can flatten this suite
            only_subsuite = None
            for node in suite_node.childNodes:
                if node.nodeName in ["#text", "doc", "status"]:
                    continue
                if node.nodeName in ["test", "kw"]:
                    return None
                if node.nodeName == "suite":
                    if only_subsuite is not None:
                        return None
                    only_subsuite = node
                    continue
                print(f"Unexpected nodename: {node.nodeName}")

            return only_subsuite

        def process_suites(suite_node: xml.dom.Node, suite_name: str):
            _real_suite_name, _suite_result, _suite_start_time, _suite_end_time = get_suite_attributes_from_xml(
                suite_node
            )

            if suite_name is None:
                suite_name = _real_suite_name

            # If necessary, flatten (just the name) from parent.subsuiteA.subsuiteB to parent.subsuiteB
            only_subsuite = get_only_subsuite(suite_node)
            if only_subsuite is not None:
                # BUG: We are skipping keywords in this suite

                # update name, use this as the new root.
                _new_subsuite_name = only_subsuite.getAttribute("name")

                return process_suites(only_subsuite, f"{suite_name}.{_new_subsuite_name}")

            thisSuite = Rbt_Suite(
                self.dirname,
                name=suite_name,
                start_time=_suite_start_time,
                end_time=_suite_end_time,
                result=_suite_result,
            )

            for node in suite_node.childNodes:
                if node.nodeName in ["#text", "doc", "status"]:
                    continue
                if node.nodeName == "kw":
                    thisSuite.keywords.extend(recurse_keyword_node(node, 0))

                elif node.nodeName == "test":
                    thisSuite.testcases.append(get_test_from_xml(node))

                elif node.nodeName == "suite":
                    _new_subsuite_name = node.getAttribute("name")
                    thisSuite.subsuites.append(process_suites(node, f"{suite_name}.{_new_subsuite_name}"))
                else:
                    raise AssertionError(f"Rbt_Suite '{suite_name}', found unknown '{node.nodeName}'")

            return thisSuite

        # All the other sub-suites 'names' will be flattened off of this common root name.
        _root_suite_node = get_child_element_by_name(self.robot_xml.firstChild, "suite")
        self.root_suite = process_suites(_root_suite_node, suite_name=None)
        self.parsed = True

    def recursively_emit_keywords(
        self,
        max_depth,
        tag,
        parent_suite: Rbt_Suite,
        tc: Rbt_Test,
        kw: Rbt_Keyword,
        parent_subsuite: Rbt_Suite,
        subsuite_tc: Rbt_Test,
        subsuite_kw: Rbt_Keyword,
    ):
        # keywords can have child keywords emit them all.
        kw_blank = Rbt_Keyword.CSV_blank()
        tc_blank = Rbt_Test.CSV_blank()
        suite_blank = Rbt_Suite.CSV_blank()

        if parent_suite is None:
            # A Suite keyword:
            self.emit_csv(
                max_depth,
                tag,
                "ROOTSUITE_KEYWORD",
                self.csv(),
                self.root_suite.csv(),
                kw.csv(),
                suite_blank,
                kw_blank,
                tc_blank,
                kw_blank,
                suite_blank,
                kw_blank,
                tc_blank,
                kw_blank,
            )
        elif tc is None:
            if subsuite_tc is None:
                self.emit_csv(
                    max_depth,
                    tag,
                    "SUBSUITE_KEYWORD",
                    self.csv(),
                    self.root_suite.csv(),
                    kw_blank,
                    parent_suite.csv(),
                    kw.csv(),
                    tc_blank,
                    kw_blank,
                    suite_blank,
                    kw_blank,
                    tc_blank,
                    kw_blank,
                )
            else:
                self.emit_csv(
                    max_depth,
                    tag,
                    "SUB_SUBSUITE_KEYWORD",
                    self.csv(),
                    self.root_suite.csv(),
                    kw_blank,
                    parent_suite.csv(),
                    kw_blank,
                    tc_blank,
                    kw_blank,
                    parent_subsuite.csv(),
                    kw_blank,
                    subsuite_tc.csv(),
                    subsuite_kw.csv(),
                )
                # for sub_subsuite_kw in
        else:
            if subsuite_tc is None:
                self.emit_csv(
                    max_depth,
                    tag,
                    "SUBSUITE_TESTCASE_KEYWORD",
                    self.csv(),
                    self.root_suite.csv(),
                    kw_blank,
                    parent_suite.csv(),
                    kw_blank,
                    tc.csv(),
                    kw.csv(),
                    suite_blank,
                    kw_blank,
                    tc_blank,
                    kw_blank,
                )
            else:
                self.emit_csv(
                    max_depth,
                    tag,
                    "SUB_SUBSUITE_TESTCASE_KEYWORD",
                    self.csv(),
                    self.root_suite.csv(),
                    kw_blank,
                    parent_suite.csv(),
                    kw_blank,
                    tc_blank,
                    kw_blank,
                    parent_subsuite.csv(),
                    kw_blank,
                    subsuite_tc.csv(),
                    subsuite_kw.csv(),
                )

        if kw is not None:
            for child_kw in kw.keywords:
                self.recursively_emit_keywords(
                    max_depth, tag, parent_suite, tc, child_kw, parent_subsuite, subsuite_tc, subsuite_kw
                )

    # Dump the parsed robot 'output.xml' as a CSV.
    def dump_csv(self, tag):
        # From the specified keyword list, extract only the setup/teardown keywords
        def get_only_typed_keywords(kw_list, filter_type):
            if filter_type not in ["setup", "teardown"]:
                raise AssertionError(f"Illegal 'filter_type' specified: {filter_type}")
            retlist = []
            if filter_type == "setup":
                for kw in kw_list:
                    if kw.kw_type == "teardown":
                        break
                    retlist.append(kw)
            else:
                _skipping = True
                for kw in kw_list:
                    if kw.kw_type == "teardown":
                        _skipping = False
                    if not _skipping:
                        retlist.append(kw)
            return retlist

        # Checking for root_suite/subsuite or root_suite/subsuite/sub_subsuite depth (1 or 2 expected)
        def get_max_depth(suite: Rbt_Suite):
            if len(suite.subsuites) == 0:
                return 0

            _max_depth = 1
            for _subsuite in suite.subsuites:
                _sub_depth = get_max_depth(_subsuite)
                if _sub_depth + _max_depth > _max_depth:
                    _max_depth = _sub_depth + _max_depth
            return _max_depth

        # Sanity check root suites must have no testcases:
        if len(self.root_suite.testcases) > 0:
            raise AssertionError(f"Found testcases in root suite: {self.root_suite.csv()}")

        # We are formatting a single CSV line for each suite, keyword, test, etc.
        # Need to enforce the same formatting, so we have to know how many suite/subsuite/sub-subsuite items to emit.
        _max_depth = get_max_depth(self.root_suite)
        if _max_depth > 2:
            raise AssertionError(
                f"Sanity check failed: Expecting subsuite nesting to be less than 2, discovered {_max_depth}"
            )

        logging.info("Max suite nesting depth is %d.", _max_depth)

        kw_blank = Rbt_Keyword.CSV_blank()
        suite_blank = Rbt_Suite.CSV_blank()
        testcase_blank = Rbt_Test.CSV_blank()

        # Emit the csv title:
        self.emit_csv(
            _max_depth,
            tag,
            "",
            Rbt_Root.CSV_title(),
            Rbt_Suite.CSV_title(),
            Rbt_Keyword.CSV_title(),
            Rbt_Suite.CSV_title(),
            Rbt_Keyword.CSV_title(),
            Rbt_Test.CSV_title(),
            Rbt_Keyword.CSV_title(),
            Rbt_Suite.CSV_title(),
            Rbt_Keyword.CSV_title(),
            Rbt_Test.CSV_title(),
            Rbt_Keyword.CSV_title(),
        )

        # This root node:
        self.emit_csv(
            _max_depth,
            tag,
            "ROOT",
            self.csv(),
            suite_blank,
            kw_blank,
            suite_blank,
            kw_blank,
            testcase_blank,
            kw_blank,
            suite_blank,
            kw_blank,
            testcase_blank,
            kw_blank,
        )

        # This root suite:
        self.emit_csv(
            _max_depth,
            tag,
            "ROOTSUITE",
            self.csv(),
            self.root_suite.csv(),
            kw_blank,
            suite_blank,
            kw_blank,
            testcase_blank,
            kw_blank,
            suite_blank,
            kw_blank,
            testcase_blank,
            kw_blank,
        )

        # This is a suite - all 'suite' keywords must be 'setup' or 'teardown'.
        # Note: All keyword lists - separatly emit 'setup' and 'teardown' keywords. First setup:
        for _kw in get_only_typed_keywords(self.root_suite.keywords, "setup"):
            self.recursively_emit_keywords(_max_depth, tag, None, None, _kw, None, None, None)

        # Same processing for subsuites as for this suite:
        for subsuite in self.root_suite.subsuites:
            # A Subsuite:
            self.emit_csv(
                _max_depth,
                tag,
                "SUBSUITE",
                self.csv(),
                self.root_suite.csv(),
                kw_blank,
                subsuite.csv(),
                kw_blank,
                testcase_blank,
                kw_blank,
                suite_blank,
                kw_blank,
                testcase_blank,
                kw_blank,
            )

            for _kw in get_only_typed_keywords(subsuite.keywords, "setup"):
                # A Subsuite keyword:
                self.recursively_emit_keywords(_max_depth, tag, subsuite, None, _kw, None, None, None)

            for _tc in subsuite.testcases:
                # A Subsuite testcase:
                self.emit_csv(
                    _max_depth,
                    tag,
                    "SUBSUITE_TESTCASE",
                    self.csv(),
                    self.root_suite.csv(),
                    kw_blank,
                    subsuite.csv(),
                    kw_blank,
                    _tc.csv(),
                    kw_blank,
                    suite_blank,
                    kw_blank,
                    testcase_blank,
                    kw_blank,
                )

                for _tc_kw in _tc.keywords:
                    self.recursively_emit_keywords(_max_depth, tag, subsuite, _tc, _tc_kw, None, None, None)

            # And all the sub_subsuites
            for sub_subsuite in subsuite.subsuites:
                # Sanity check:
                if len(sub_subsuite.subsuites) > 0:
                    raise AssertionError(f"Found unexpected sub-sub-suite: {sub_subsuite.subsuites[0].csv()}")

                # A Sub_Subsuite:
                self.emit_csv(
                    _max_depth,
                    tag,
                    "SUB_SUBSUITE",
                    self.csv(),
                    self.root_suite.csv(),
                    kw_blank,
                    subsuite.csv(),
                    kw_blank,
                    testcase_blank,
                    kw_blank,
                    sub_subsuite.csv(),
                    kw_blank,
                    testcase_blank,
                    kw_blank,
                )

                for _kw in get_only_typed_keywords(sub_subsuite.keywords, "setup"):
                    self.recursively_emit_keywords(_max_depth, tag, subsuite, None, _kw, sub_subsuite, None, _kw)

                for _tc in sub_subsuite.testcases:
                    self.emit_csv(
                        _max_depth,
                        tag,
                        "SUB_SUBSUITE_TESTCASE",
                        self.csv(),
                        self.root_suite.csv(),
                        kw_blank,
                        subsuite.csv(),
                        kw_blank,
                        testcase_blank,
                        kw_blank,
                        sub_subsuite.csv(),
                        kw_blank,
                        _tc.csv(),
                        kw_blank,
                    )

                    for _tc_kw in _tc.keywords:
                        self.emit_csv(
                            _max_depth,
                            tag,
                            "SUB_SUBSUITE_TESTCASE_KEYWORD",
                            self.csv(),
                            self.root_suite.csv(),
                            kw_blank,
                            subsuite.csv(),
                            kw_blank,
                            testcase_blank,
                            kw_blank,
                            sub_subsuite.csv(),
                            kw_blank,
                            _tc.csv(),
                            _tc_kw.csv(),
                        )

            for _kw in get_only_typed_keywords(subsuite.keywords, "teardown"):
                # A Subsuite keyword:
                self.recursively_emit_keywords(_max_depth, tag, subsuite, None, _kw, None, None, None)

        for _kw in get_only_typed_keywords(self.root_suite.keywords, "teardown"):
            self.recursively_emit_keywords(_max_depth, tag, None, None, _kw, None, None, None)

        logging.info("dump_csv complete")


def parse_robot_output_xml(run_dir):
    # Parse the robot 'output.xml' file for all data.
    # The XML root node, 'robot' is parsed and logged, but otherwise ignored.
    #
    # Parsed information starts at the main 'suite' element.
    #   robot/suite
    # All other data is gathered into appropriate classes: Rbt_Suite, Rbt_Keyword, and Rbt_Test
    #
    # Note: Currently ignored XML nodes:
    #   robot/statistics
    #   robot/errors

    _dir = os.path.abspath(run_dir)

    _theRoot = Rbt_Root(_dir)

    # TODO: Possibly useful information:
    logging.info("outputxml root element=%s", _theRoot.csv())

    _theRoot.parse()

    return _theRoot


def duration_from_robot_timestamps(start_timestamp, end_timestamp) -> timedelta:
    # Expected timestamp format: 20230416 21:25:11.734
    _start = datetime.datetime.strptime(start_timestamp, "%Y%m%d %H:%M:%S.%f")
    _end = datetime.datetime.strptime(end_timestamp, "%Y%m%d %H:%M:%S.%f")
    return _end - _start


def unique_robot_tag(alltags) -> str:
    for tag in alltags.split(","):
        if len(tag) != 6:
            continue
        if str.isnumeric(tag):
            return tag

    # Pass2: There are some 5-digit tags (probably a bug, warn here)
    for tag in alltags.split(","):
        if len(tag) != 5:
            continue
        if str.isnumeric(tag):
            logging.warning("Short tag selected:'%s'", tag)
            return tag
    logging.warning("Cannot locate the unique tag (6 digits, isnumeric()) in: '%s'", alltags)
    return ""
