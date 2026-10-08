r"""
sem_sig_relay - Propagate a subprocess exit code with abort support via a semaphore.

This standalone script launchs the specified subprocess and waits for:
- the subprocess to exit, or
- the creation of an 'abort' semaphore file.

Upon 'abort' file detection, this script:
- sends 'signal.CTRL_C_EVENT' to the running subprocess,
- time.sleep() a few seconds,
- 'sys.exit()'s with an appropriate exit code.

The exit code is:
- the subprocess 'returncode', or
- one of one of the EXIT_CODE_xxx, below (plus any subprocess exit code).

This script is intended for a Windows environment, where signals are sent to ALL
processes in a process group - including parent processes, which may not expect/handle signals.

Notes:
        # WARNING: 'creationflags' MUST contain CREATE_NEW_CONSOLE or DETACHED_PROCESS!
        #   Without one of these flags, this process group (parents AND children) gets the
        #   kill signal - (for CIFX automation, this kills off executee!)
        #   (DETACHED_PROCESS is undefined until python 3.7+, lab is currently 3.6)

        self.robot_process = subprocess.Popen(robot_cmd, creationflags=CREATE_NEW_CONSOLE)

The invocation: python sem_sig_relay.py -c "sleep 10"
- Works as expected (C:\Program Files\Git\usr\bin\sleep.exe)

The invocation: python sem_sig_relay.py -c "cmd /k dir"
- Does NOT work as expected, the window executes the 'dir' command, but the builtin does not
  reflect the status, and when the flagfile asks for abort, the final 'wait()' hangs because
  the CMD window handles ctl-C (you must type 'exit' to see the expected behavior).
"""

import os
import sys
import time
import logging
import getopt
import subprocess
from subprocess import TimeoutExpired
import signal

# import traceback

EXIT_CODE_SEMAPHORE = 100
EXIT_CODE_SEMAPHORE_CHILD_STILL_RUNNING = 99
EXIT_CODE_INVALID_ARGS = 98
EXIT_CODE_UNEXPECTED = 97


class _MonitorWithSemaphore:
    DEFAULT_SEMAPHORE_FILENAME = "shutdownflag.txt"
    DEFAULT_LINGER_SECONDS = 30

    def __init__(self):
        self.command_text = None
        self.semaphore_filename = self.DEFAULT_SEMAPHORE_FILENAME
        self.exit_delay = self.DEFAULT_LINGER_SECONDS
        self.logdir = "."

        self.command_process = None
        self.exit_code = None

    def parse_args(self):
        # Required parameters:
        self.command_text = None

        try:
            opts, args = getopt.getopt(sys.argv[1:], "hc:f:d:l:", ["cmd=", "flagfile=", "delay=", "logdir="])
            logging.debug("opts=%s", str(opts))
            logging.debug("args=%s", str(args))

            for opt, arg in opts:
                if opt == "-h":
                    self.usage()
                    sys.exit(EXIT_CODE_INVALID_ARGS)
                elif opt in ("-c", "--cmd"):
                    self.command_text = arg
                elif opt in ("-f", "--flagfile"):
                    self.semaphore_filename = arg
                elif opt in ("-d", "--delay"):
                    self.exit_delay = int(arg)
                elif opt in ("-l", "--logdir"):
                    self.logdir = arg
                else:
                    raise getopt.GetoptError(opt, "Unknown option: " + opt)
            if not self.command_text:
                self.usage("Missing required parameter: '-c <command>'")
                sys.exit(EXIT_CODE_INVALID_ARGS)
            return 0
        except getopt.GetoptError as opterr:
            self.usage(opterr.msg)
            sys.exit(EXIT_CODE_INVALID_ARGS)

    def check_semaphore(self):
        if not os.path.isfile(self.semaphore_filename):
            return False

        logging.info("Semaphor was set, checking the command...")
        self.check_process()
        if not self.exit_code is None:
            logging.info("But the command already exited with %d, returning that.", self.exit_code)
            return True
        logging.info("Sending CTRL_C_EVENT to the command...")
        os.kill(self.command_process.pid, signal.CTRL_C_EVENT)

        # Poll: let the process react to the signal:
        logging.info("Checking %d times for command exit...", self.exit_delay)
        for check in range(1, self.exit_delay):
            time.sleep(1)
            self.check_process()
            if not self.exit_code is None:
                logging.info("Command exited with code %d after %d checks.", self.exit_code, check)
                self.exit_code = EXIT_CODE_SEMAPHORE | self.exit_code
                return True

        logging.info("Checked %d times, the command did not terminate, waiting on it...", check)
        try:
            _result = self.command_process.wait(timeout=15)
        except TimeoutExpired as timeout:
            logging.warning("Wait timed out: %s", str(timeout))
            _result = None

        if _result is None:
            logging.info("Process was still running!")
            # This is problematic, if the launch flags for THIS process are preventing
            #   the expected behavior in the subprocess, the 'terminate' will probably
            #   also be ignored. Best effort...
            self.command_process.terminate()
            # self.command_process.kill()
            self.exit_code = EXIT_CODE_SEMAPHORE_CHILD_STILL_RUNNING
        else:
            self.exit_code = EXIT_CODE_SEMAPHORE | _result
        return True

    def launch_cmd(self):
        self.command_process = subprocess.Popen(self.command_text, shell=True)

    def check_process(self):
        self.exit_code = self.command_process.poll()
        if not self.exit_code is None:
            logging.info("Process exited with code: %d", self.exit_code)

    def usage(self, context=None):
        if context:
            logging.info(context)
        logging.info("Usage:\n\t%s -c <command> [-f <flagfile>] [-d <delay>] [-l <logdir>]", sys.argv[0])
        logging.info("Where:")
        logging.info("\tcommand  - is a command to launch and monitor for exit.")
        logging.info("\tflagfile - is a file name whose presence will cause ctl-C to be sent to the")
        logging.info("\t           command. Removed on startup, default=%d", self.DEFAULT_SEMAPHORE_FILENAME)
        logging.info("\tdelay    - is the number of seconds, after sending ctl-C, to wait for the final")
        logging.info("\t           command status before exiting. Default=%d.", self.DEFAULT_LINGER_SECONDS)
        logging.info("\tlogdir   - is the directory to create the log file")

    def init_logging(self):
        logfile = os.path.join(os.path.abspath(self.logdir), "sem_sig_relay.log")
        print("logfile=%s" % logfile)
        if os.path.isfile(logfile):
            os.remove(logfile)
        logger = logging.getLogger()
        handler = logging.FileHandler(logfile)
        logger.addHandler(handler)

    def main(self):
        self.parse_args()
        self.init_logging()

        logging.debug("Startup, args:")
        logging.debug("\t logdir:   %s", self.logdir)
        logging.debug("\t flagfile: %s", self.semaphore_filename)
        logging.debug("\t delay:    %s", self.exit_delay)
        logging.debug("\t command:  %s", self.command_text)

        if os.path.isfile(self.semaphore_filename):
            logging.info("Removing stale flagfile (%s)", self.semaphore_filename)
            os.remove(self.semaphore_filename)
        self.launch_cmd()
        while self.exit_code is None:
            time.sleep(5)
            if self.check_semaphore():
                break
            self.check_process()
        return self.exit_code


if __name__ == "__main__":
    signal.signal(signal.SIGINT, signal.SIG_IGN)
    FORMAT = "%(asctime)-15s %(message)s"
    logging.basicConfig(level=logging.DEBUG, format=FORMAT)

    print("Startup, args are: %s" % str(sys.argv))

    _worker = _MonitorWithSemaphore()
    try:
        result = _worker.main()
    except Exception:
        # traceback.print_exc()
        logging.error("Unexpected error!", exc_info=True)
        sys.exit(EXIT_CODE_UNEXPECTED)
    logging.info("Success exiting with code %d", result)
    sys.exit(result)
