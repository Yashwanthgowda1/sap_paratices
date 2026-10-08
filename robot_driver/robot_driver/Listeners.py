"""
Create a reports of events reported by robot.
    More info from:
        https://docs.robotframework.org/docs/extending_robot_framework/listeners_prerun_api/listeners

"""

import os
import sys
from enum import Enum, auto
import time
from threading import Lock, Thread


class DiscoverMeetingNames:
    # This class is used to discover meeting names required by the current test selection.
    # It is intended that an actual run is first:
    # - run with '--dryrun --listener Listeners.DiscoverMeetingNames'
    # - and then the actual run, which picks up the meetings it must create during setup.

    ROBOT_LISTENER_API_VERSION = 2
    ROBOT_LIBRARY_SCOPE = "GLOBAL"

    def __init__(self):
        self.ROBOT_LIBRARY_LISTENER = self
        self.discovered_meetings = []
        # TODO: clear the meeting name list?

    def start_suite(self, name, attrs):
        # TODO: Perhaps a Suite can have a 'required meetings' variable?
        print(f"start_suite: {name}")
        # print(attrs)

    # def start_test(self, name, attrs):
    #     print(name)
    #     print(attrs)
    #     pass

    def start_keyword(self, name, attrs):
        # Look for the 'Require Meeting' keyword
        # print(f"start_keyword: {name}")
        if attrs["kwname"] == "Require Meeting Name":
            # print(attrs)
            if not attrs["args"]:
                print("ERROR - no meeting name was supplied!")
            else:
                # Note: assuming no other arguments:
                _meeting_name = attrs["args"][0]

                if not _meeting_name in self.discovered_meetings:
                    self.discovered_meetings.append(_meeting_name)

                print(f"FOUND KEYWORD: '{name}', meeting='{_meeting_name}'")

    # def end_keyword(self, name, attrs):
    #     print(name)
    #     print(attrs)
    #     pass

    # def end_test(self, name, attrs):
    #     print(name)
    #     print(attrs)
    #     pass

    # def end_suite(self, name, attrs):
    #     print(name)
    #     print(attrs)
    #     pass

    # def library_import(self, name, attrs):
    #     print(name)
    #     print(attrs)
    #     pass

    # def resource_import(self, name, attrs):
    #     # TODO: Perhaps 'all meeting names' list?
    #     print(name)
    #     print(attrs)
    #     pass

    # def variables_import(self, name, attrs):
    #     # TODO: Perhaps 'all meeting names' list?
    #     print(f"variables_import: {name}")
    #     # print(attrs)

    def close(self):
        print(f"\nThe required meetings list is: {self.discovered_meetings}\n")
        # TODO: shutdown tasks...
        pass


# This class is used for playback only
class RobotEvent(Enum):
    START_SUITE = auto()
    END_SUITE = auto()
    START_TEST = auto()
    END_TEST = auto()
    START_KEYWORD = auto()
    END_KEYWORD = auto()


def get_robot_aware_abspath(filename: str) -> str:
    # Return the abspath of the indicated file name.
    # If no path separator is specified in the output filename, check for Robot '-d' output directory specification.
    if filename.find(os.sep) == -1:
        for n in range(1, len(sys.argv)):
            if "-d" == sys.argv[n]:
                return os.path.join(sys.argv[n + 1], filename)
    return os.path.abspath(filename)


class ReportWithTimes:
    """
    ReportWithTimes - accumulate and dump runs with event timestamps/durations to TXT or CSV.

    Invocation:
        Class takes a filename argument for output.
        - If the output filename ends with '.CSV', output is a CSV file.
        - Default output is TEXT.

    Tracker Usage:
        For each event reported, the same Tracker is used in both the 'active_stack' and
        the 'historic_list'.
        - 'active_stack' created on start, finalized on end.
        - 'historic_list' inserted on start, to maintain reported event order.

    """

    ROBOT_LISTENER_API_VERSION = 2

    class Tracker:
        """
        Internal utility class
            A Tracker is used to track and format events.
        """

        def __init__(self, event: RobotEvent, name, attributes):
            self.event = event
            self.name = name
            self.attributes = attributes
            self.depth = 0

        def to_string(self):
            """Return a pretty string representation"""
            depth_indicator = format("-" * self.depth, ">8s")
            what = self.event.name.removeprefix("START_")
            return f"{format(what, '>8s')}: {depth_indicator}: {format(self.attributes['elapsedtime'],'>8d')} ms. : {self.name}"

        @staticmethod
        def get_csv_header():
            """Return a header string for the 'to_csv()' detail"""
            return "What,Depth,Elapsed,Id tag,Test Name,All Tags"

        def to_csv(self):
            """Return a CSV representation"""
            digit_tag = ""
            _tags = ""

            # Replace all commas in text strings to avoid confusing excel.
            # Currently replacing with a token ('[ACOMMA]'), we could also use something else
            # like a '-', but it would be difficult to do a search/replace to restore the original text.
            test_name = str.replace(self.name, ",", "[ACOMMA]")

            if "tags" in self.attributes:
                _tags = " ".join(self.attributes["tags"])

                # Attempt to isolate/report the 6-digit unique tag:
                for t in _tags.split(" "):
                    if len(t) == 6 and t.isdecimal():
                        digit_tag = t
                        break

            what = self.event.name.removeprefix("START_")
            return f"{what},{self.depth},{self.attributes['elapsedtime']},{digit_tag},{test_name},{_tags}"

    def __init__(self, filename="ReportWithTimes.txt"):
        LEGAL_EXTENSIONS = [".txt", ".csv"]

        def isLegalExtension(filename: str):
            for val in LEGAL_EXTENSIONS:
                if filename.lower().endswith(val):
                    return True
            return False

        if not isLegalExtension(filename):
            raise AssertionError(
                f"Specified filename '{filename}' does not have a legal extension ({LEGAL_EXTENSIONS})"
            )
        self.filename = get_robot_aware_abspath(filename)
        print(f"Using {os.path.dirname(os.path.abspath(self.filename))} as output directory for {filename}")

        self.historic_list = []
        self.active_stack = []
        self.max_depth = 0

        # Initialize the output file
        if os.path.exists(self.filename):
            os.remove(self.filename)
        self.outfile = open(self.filename, "w", encoding="utf-8", buffering=1)
        if filename.lower().endswith(".csv"):
            self.outfile.write(self.Tracker.get_csv_header() + "\n")

    def start_suite(self, name, attrs):
        """A Suite is starting."""
        self.start_something(RobotEvent.START_SUITE, name, attrs)

    def start_test(self, name, attrs):
        """A Test is starting."""
        self.start_something(RobotEvent.START_TEST, name, attrs)

    def start_keyword(self, name, attrs):
        """A Keyword is starting."""
        self.start_something(RobotEvent.START_KEYWORD, name, attrs)

    def end_keyword(self, name, attrs):
        """A Keyword is ending."""
        self.end_something(RobotEvent.END_KEYWORD, name, attrs)

    def end_test(self, name, attrs):
        """A Test is ending."""
        # self.outfile.write(f"end_test: '{name}': ")
        # if attrs["status"] == "PASS":
        #     self.outfile.write("PASS\n")
        # else:
        #     self.outfile.write("FAIL: %s\n" % attrs["message"])
        self.end_something(RobotEvent.END_TEST, name, attrs)

    def end_suite(self, name, attrs):
        """A Suite is ending."""
        # self.outfile.write("end_suite: %s %s\n%s\n" % (name, attrs["status"], attrs["message"]))
        self.end_something(RobotEvent.END_SUITE, name, attrs)

    def start_something(self, what: RobotEvent, name, attrs):
        """Peform actions for starting something."""
        if len(self.active_stack) > self.max_depth:
            self.max_depth = len(self.active_stack)

        tracker = self.Tracker(what, name, attrs)
        self.active_stack.append((name, tracker))
        self.historic_list.append(tracker)

    def end_something(self, what: RobotEvent, name, attrs):
        """Peform actions for ending something."""
        old_name, tracker = self.active_stack.pop()
        if old_name != name:
            raise AssertionError(f"End '{what}' - Names don't match, Old: '{old_name}', New: '{name}'")

        # Replace the old tracker's attribute list
        tracker.attributes = attrs
        tracker.depth = len(self.active_stack)

    def close(self):
        """We are about to be unloaded, peform final actions."""

        # Dump the historical list
        for tracker in self.historic_list:
            if self.filename.lower().endswith(".csv"):
                self.outfile.write(f"{tracker.to_csv()}\n")
            else:
                self.outfile.write(f"{tracker.to_string()}\n")

        self.outfile.close()


class GenerateTestData:
    """
    GenerateTestData - dump all events in a format suitable for copy/pasting to the test data used here.

    Note: This class is not generally useful - only created to generate test data for playback.
    (See 'event_list', below.)

    Invocation:
        Class takes a filename argument for output, default is 'generated_event_list.py'.
        Example: --dryrun --listener listeners.GenerateTestData:junk.py

    """

    ROBOT_LISTENER_API_VERSION = 2

    def __init__(self, filename="generated_event_list.py"):
        self.filename = get_robot_aware_abspath(filename)

        # Initialize the output file
        if os.path.exists(self.filename):
            os.remove(self.filename)
        self.outfile = open(self.filename, "w", encoding="utf-8", buffering=1)

        self.outfile.write(self.get_py_header() + "\n")

    def start_suite(self, name, attrs):
        """A Suite is starting."""
        # self.outfile.write("start_suite: %s '%s'\n" % (name, attrs["doc"]))
        self.write_py(RobotEvent.START_SUITE, name, attrs)

    def start_test(self, name, attrs):
        """A Test is starting."""
        # tags = " ".join(attrs["tags"])
        # self.outfile.write("start_test: %s '%s' [ %s ]\n" % (name, attrs["doc"], tags))
        self.write_py(RobotEvent.START_TEST, name, attrs)

    def start_keyword(self, name, attrs):
        """A Keyword is starting."""
        self.write_py(RobotEvent.START_KEYWORD, name, attrs)

    def end_keyword(self, name, attrs):
        """A Keyword is ending."""
        self.write_py(RobotEvent.END_KEYWORD, name, attrs)

    def end_test(self, name, attrs):
        """A Test is ending."""
        # self.outfile.write(f"end_test: '{name}': ")
        # if attrs["status"] == "PASS":
        #     self.outfile.write("PASS\n")
        # else:
        #     self.outfile.write("FAIL: %s\n" % attrs["message"])
        self.write_py(RobotEvent.END_TEST, name, attrs)

    def end_suite(self, name, attrs):
        """A Suite is ending."""
        # self.outfile.write("end_suite: %s %s\n%s\n" % (name, attrs["status"], attrs["message"]))
        self.write_py(RobotEvent.END_SUITE, name, attrs)

    def write_py(self, event: RobotEvent, name, attrs):
        """Persist the event as {"what": RobotEvent.XXXX, "name": "suiteA", "attributes": []}"""
        att = str(attrs)
        entry = '    {"what": ' + str(event) + ', "name": "' + name + '", "attributes": ' + att + "},\n"
        self.outfile.write(entry)

    def close(self):
        """We are about to be unloaded, peform final actions."""
        self.outfile.write("]\n")
        self.outfile.close()

    @staticmethod
    def get_py_header():
        """Return a header string for the 'to_py()' detail"""
        return "event_list = [\n"


class RobotListenerWorkerThreadExample:
    """
    Robot listener which maintains a background task while robot events are being fired.
    Invocation:
        Class takes a filename argument for output
        - worker task interval is hard-coded to 5 seconds.
        - TODO: add 'interval' argument for worker task.

    class BackgroundPeriodicTask:
        Task simply writes 'doing something' whenever 'interval' seconds elapses.

    class SafeWriter:
        A common/shared threadsafe log writer.

    Info from:
        https://github.com/robotframework/robotframework/blob/master/doc/userguide/src/ExtendingRobotFramework/ListenerInterface.rst

    """

    ROBOT_LISTENER_API_VERSION = 2

    class SafeWriter:
        """
        Threadsafe writer
        """

        def __init__(self, outfilename):
            self.outfilename = outfilename
            self.lock = Lock()
            self.outfile = open(outfilename, "w", encoding="utf-8", buffering=1)

        def write(self, message):
            self.lock.acquire()
            self.outfile.write(message)
            self.lock.release()

        def close(self):
            self.outfile.close()

    class BackgroundPeriodicTask:
        """
        A background periodic task class
            Class manages a background thread task.
        """

        def __init__(self, interval, writer):
            self.interval = interval
            self.outfile = writer
            self.shutdown_flag = False
            self.worker = Thread(target=self.worker_function)
            self.worker.start()

        def worker_function(self):
            self.outfile.write("worker_function starts\n")
            while not self.shutdown_flag:
                self.outfile.write("worker_function does some work\n")
                time.sleep(self.interval)
            self.outfile.write("worker_function ends\n")

        def shutdown(self):
            self.shutdown_flag = True
            self.worker.join()
            self.outfile.write("worker_function has been shut down\n")

    def __init__(self, filename="background_output.txt"):
        filename = get_robot_aware_abspath(filename)
        self.outfile = self.SafeWriter(filename)
        self.outfile.write("INIT\n")
        self.bg_task = self.BackgroundPeriodicTask(5, self.outfile)

    def start_suite(self, name, attrs):
        """A Suite is starting."""
        self.start_something("Suite", name, attrs)

    def start_test(self, name, attrs):
        """A Test is starting."""
        self.start_something("Test", name, attrs)

    def start_keyword(self, name, attrs):
        """A Keyword is starting."""
        self.start_something("Keyword", name, attrs)

    def end_keyword(self, name, attrs):
        """A Keyword is ending."""
        self.end_something("Keyword", name, attrs)

    def end_test(self, name, attrs):
        """A Test is ending."""
        self.end_something("Test", name, attrs)

    def end_suite(self, name, attrs):
        """A Suite is ending."""
        self.end_something("Suite", name, attrs)

    def start_something(self, what, name, attrs):
        """Peform actions for starting something."""
        self.outfile.write(f"- start {what}: '{name}'\n")

    def end_something(self, what, name, attrs):
        """Peform actions for ending something."""
        self.outfile.write(f"- end   {what}: '{name}'\n")

    def close(self):
        """We are about to be unloaded, peform final actions."""
        self.outfile.write("CLOSE\n")
        self.bg_task.shutdown()
        self.outfile.close()


def run_playback():
    # This method is intended to 'replay' an actual robot test event stream, without robot.

    event_list = [
        # Dummy test data - for testing 'ReportWithTimes'
        #   Generated by using 'GenerateTestData' above to produce 'junk.py', which is copy/pasted here.
        #       robot --dryrun --listener Listeners.GenerateTestData:junk.py ...
        #   Huge file! Not very interesting, but can be helpful debugging this Listener.ReportWithTimes.
        {
            # Old test data removed - useless data - copy/paste the 'junk.py' generated above...
            # TODO: It would be better to just import the file...
        },
    ]

    # Test event data

    # Pick a non-default output file:
    TEST_OUTPUT_FILE = "junk.csv"
    # TEST_OUTPUT_FILE = "junk.txt"
    # TEST_OUTPUT_FILE = "junk.py"

    # (pick ONLY ONE) Get an instance of a listener to test:
    # hook = RobotListenerWorkerThreadExample(TEST_OUTPUT_FILE)
    hook = ReportWithTimes(TEST_OUTPUT_FILE)
    # hook = GenerateTestData(TEST_OUTPUT_FILE)

    try:
        # Play back all the test data events to the listener
        for ev in event_list:
            print(f"Processing event {ev['what']}")

            if ev["what"] == RobotEvent.START_SUITE:
                hook.start_suite(ev["name"], ev["attributes"])
            elif ev["what"] == RobotEvent.END_SUITE:
                hook.end_suite(ev["name"], ev["attributes"])
            elif ev["what"] == RobotEvent.START_TEST:
                hook.start_test(ev["name"], ev["attributes"])
            elif ev["what"] == RobotEvent.END_TEST:
                hook.end_test(ev["name"], ev["attributes"])
            elif ev["what"] == RobotEvent.START_KEYWORD:
                hook.start_keyword(ev["name"], ev["attributes"])
            elif ev["what"] == RobotEvent.END_KEYWORD:
                hook.end_keyword(ev["name"], ev["attributes"])
            else:
                raise AssertionError(f"Undefined event: {ev['what']}")

            # sleep optional - in case you want to slow down the event playback.
            # time.sleep(0.5)
    finally:
        hook.close()
    print(f"Test Complete, output is in '{TEST_OUTPUT_FILE}'")


if __name__ == "__main__":
    # playground here, put in your favorite tests
    run_playback()
