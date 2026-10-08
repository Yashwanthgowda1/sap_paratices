import os

import re
import subprocess
import csv
from multiprocessing import Lock
from shared_utils import config

csvfileName = "lag.csv"
timeformat = "%Y-%m-%d %H:%M:%S:%f"


class LagListener:
    class SafeWriter:
        """
        Threadsafe writer
        """

        header = [
            "Total Frame",
            "Flaky Frames",
            "Flaky Frames %",
            "50th percentile",
            "90th percentile",
            "95th percentile",
            "99th percentile",
            "50th gpu percentile",
            "90th gpu percentile",
            "95th gpu percentile",
            "99th gpu percentile",
        ]

        def __init__(self, outfilename):
            self.outfilename = outfilename
            self.lock = Lock()
            self.outfile = open(outfilename, "w", newline="")
            self.writer = csv.DictWriter(self.outfile, fieldnames=self.header)

        def write(self, message):
            self.lock.acquire()
            self.outfile.write(message)
            self.lock.release()

        def write_to_csv(self):
            self.lock.acquire()
            # writing headers (field names)
            self.writer.writeheader()
            self.lock.release()

        def append_to_csv(self, mydict):
            self.lock.acquire()
            self.writer.writerows(mydict)
            self.lock.release()

        def close(self):
            self.outfile.close()

    ROBOT_LISTENER_API_VERSION = 2

    def __init__(self, buildID=1):
        self.ch_DIR = os.path.join(os.path.realpath("."), "results", str(buildID))
        try:
            os.makedirs(self.ch_DIR, exist_ok=True)
            print("Directory '%s' created successfully" % self.ch_DIR)
        except OSError as error:
            print("Directory '%s' can not be created" % self.ch_DIR)

        self.csvfileName_updated = os.path.join(os.path.realpath("."), "results", str(buildID), csvfileName)
        print(self.csvfileName_updated)
        self.csvfile = self.SafeWriter(self.csvfileName_updated)
        self.csvfile.write_to_csv()

    def end_keyword(self, name, attrs):
        if "pretransition" in attrs["kwname"]:
            """do prep for a new data point"""
            csv_test_data = devices_janky_frame_stats()
            self.csvfile.append_to_csv(csv_test_data)

        elif "performtransition" in attrs["kwname"]:
            """do work for completing the data point"""
            csv_test_data = devices_janky_frame_stats()
            self.csvfile.append_to_csv(csv_test_data)

    def close(self):
        # self.bg_task.shutdown()
        self.csvfile.close()


def janky_frame_stats(device):
    stats = {}
    udid = config["devices"][device]["desired_caps"]["udid"].strip(":5555")
    cmd = "adb -s " + udid + " shell dumpsys gfxinfo " + config["common_desired_caps"]["appPackage"]
    output = str(subprocess.check_output(cmd, shell=True))
    Lines = str(output).split("\\n")

    for line in Lines:
        match = re.split("\s+", line.strip("\\r "))
        size = len(match)
        # Skip data after the 'App Summary' line.  This is to fix builds where
        # they have more entries that might match the other conditions.
        if len(match) >= 2 and match[0] == "GPU" and match[1] == "HISTOGRAM":
            break

        if match[0] == "Total" and match[1] == "frames":
            stats.update({"Total Frame": match[3]})
        elif match[0] == "Janky" and match[1] == "frames:":
            stats.update({"Janky Frames": match[2]})
            stats.update({"Janky Frames %": match[3].strip("(").strip(")")})
        elif match[0] == "50th" and match[1] == "percentile:":
            stats.update({"50th percentile(ms)": match[2].replace("ms", "")})
        elif match[0] == "90th" and match[1] == "percentile:":
            stats.update({"90th percentile(ms)": match[2].replace("ms", "")})
        elif match[0] == "95th" and match[1] == "percentile:":
            stats.update({"95th percentile(ms)": match[2].replace("ms", "")})
        elif match[0] == "99th" and match[1] == "percentile:":
            stats.update({"99th percentile(ms)": match[2].replace("ms", "")})
        elif match[0] == "50th" and match[1] == "gpu" and match[2] == "percentile:":
            stats.update({"50th gpu percentile(ms)": match[3].replace("ms", "")})
        elif match[0] == "90th" and match[1] == "gpu" and match[2] == "percentile:":
            stats.update({"90th gpu percentile(ms)": match[3].replace("ms", "")})
        elif match[0] == "95th" and match[1] == "gpu" and match[2] == "percentile:":
            stats.update({"95th gpu percentile(ms)": match[3].replace("ms", "")})
        elif match[0] == "99th" and match[1] == "gpu" and match[2] == "percentile:":
            stats.update({"99th gpu percentile(ms)": match[3].replace("ms", "")})
    return stats


def devices_janky_frame_stats():
    statsArr = []
    for device in config["devices"]:
        gxinfo_param = janky_frame_stats(device)
        gxinfo_param.update({"device": device})
        statsArr.append(gxinfo_param)
    return statsArr
