import os
import datetime
import re
import json
from collections import OrderedDict
import subprocess
import csv
import sys
import time
from threading import Thread
from multiprocessing import Lock
from pathlib import Path

file_name = "KeywordsMemoryStatsListener.html"
csvfileName = "report.csv"
configfileName = "config.json"
timeformat = "%Y-%m-%d %H:%M:%S:%f"
config = ""

with open(configfileName, "r") as jsonfile:
    config = json.loads(jsonfile.read(), object_pairs_hook=OrderedDict)


class KeywordsMemoryStatsListener:
    class SafeWriter:
        """
        Threadsafe writer
        """

        header = [
            "Time",
            "Test Suite Name",
            "Test Name",
            "Keyword Name",
            "Mode",
            "device",
            "nativeHeap Before",
            "dalvikHeap Before",
            "totalPss Before",
            "CPU Stats Before",
            "nativeHeap After",
            "dalvikHeap After",
            "totalPss After",
            "CPU Stats After",
            "Total Frame",
            "Janky Frames",
            "Janky Frames %",
            "50th percentile(ms)",
            "90th percentile(ms)",
            "95th percentile(ms)",
            "99th percentile(ms)",
            "50th gpu percentile(ms)",
            "90th gpu percentile(ms)",
            "95th gpu percentile(ms)",
            "99th gpu percentile(ms)",
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
            self.writer = csv.DictWriter(self.outfile, fieldnames=self.header)
            self.writer.writerows(mydict)
            self.lock.release()

        def close(self):
            self.outfile.close()

    ROBOT_LISTENER_API_VERSION = 2

    class BackgroundPeriodicTask:
        """
        A background periodic task class
            Class manages a background thread task.
        """

        def __init__(self, interval, writer, name):
            self.interval = interval
            self.outfile = writer
            self.shutdown_flag = False
            self.worker = Thread(target=self.write_periodic_data, args=(name,))
            self.worker.start()

        def write_periodic_data(self, name):
            while not self.shutdown_flag:
                test_data_csv = []
                time.sleep(int(self.interval))
                memoryparam = devices_memory_usage()

                csvdict = {
                    "Time": str(get_current_date_time(timeformat, True)),
                    "Test Name": str(name),
                    "Mode": "Periodic Metrics",
                }
                mp_index = 0
                for devStat in memoryparam:
                    csvdict.update({"device": devStat})
                    csvdict.update({"nativeHeap Before": memoryparam[devStat].nativeHeap})
                    csvdict.update({"dalvikHeap Before": memoryparam[devStat].dalvikHeap})
                    csvdict.update({"totalPss Before": memoryparam[devStat].totalPss})
                    csvdict.update({"nativeHeap After": memoryparam[devStat].nativeHeap})
                    csvdict.update({"dalvikHeap After": memoryparam[devStat].dalvikHeap})
                    csvdict.update({"totalPss After": memoryparam[devStat].totalPss})
                    test_data_csv.append(csvdict)
                    mp_index = mp_index + 1
                cpu_index = 0
                cpudata = devices_cpu_usage()
                if len(cpudata) == len(test_data_csv):
                    for data in cpudata:
                        cpuusage = fetchPercentagefromString(data)
                        size = len(cpuusage)
                        if size > 0:
                            test_data_csv[cpu_index].update({"CPU Stats Before": cpuusage[0]})
                            test_data_csv[cpu_index].update({"CPU Stats After": cpuusage[0]})
                        cpu_index = cpu_index + 1
                    gpu_test_data = self.devices_janky_frame_stats()
                    for i in range(len(test_data_csv)):
                        test_data_csv[i].update(gpu_test_data[i])
                    self.outfile.append_to_csv(test_data_csv)

        def devices_janky_frame_stats(self):
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

            statsArr = []
            for device in config["devices"]:
                gxinfo_param = janky_frame_stats(device)
                gxinfo_param.update({"device": device})
                statsArr.append(gxinfo_param)
            return statsArr

        def shutdown(self):
            self.shutdown_flag = True
            self.worker.join()

    def __init__(self, timeinterval=5, buildID=1):
        self.timeinterval = int(timeinterval)
        print("Time Interval to fetch the thread is ", timeinterval)

        self.ch_DIR = os.path.join(os.path.realpath(Path.home()), "results", str(buildID))

        print(self.ch_DIR)
        try:
            os.makedirs(self.ch_DIR, exist_ok=True)
            print("Directory '%s' created successfully" % self.ch_DIR)
        except OSError as error:
            print("Directory '%s' can not be created" % self.ch_DIR)

        self.file_name_updated = os.path.join(os.path.realpath(Path.home()), "results", str(buildID), file_name)
        print(self.file_name_updated)
        self.csvfileName_updated = os.path.join(os.path.realpath(Path.home()), "results", str(buildID), csvfileName)
        print(self.csvfileName_updated)

        self.htmlfile = self.SafeWriter(self.file_name_updated)
        message = """
        <html>
            <title>Live Memory Stats</title>
            <meta http-equiv="refresh" content="100">
            <link href="https://cdn.datatables.net/1.10.19/css/jquery.dataTables.min.css" rel="stylesheet" />
            <link href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.1.3/css/bootstrap.min.css" rel="stylesheet" />
            <script src="https://code.jquery.com/jquery-3.3.1.js" type="text/javascript"></script>
            <script src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.min.js" type="text/javascript"></script>
            <script src="https://cdn.datatables.net/buttons/1.5.2/js/dataTables.buttons.min.js" type="text/javascript"></script>
            <script src="https://cdn.datatables.net/buttons/1.5.2/js/buttons.flash.min.js" type="text/javascript"></script>
            <script>$(document).ready(function() {$('#live').DataTable({"order": [[0, "desc"]]});});</script>
        </html>

        <body>
            <h3 style="color:#009688;text-align:center"><b>RF Live CPU Stats</b></h3>
            <table id="live" class="table table-striped table-bordered">
                <thead>
                    <tr>
                        <th>Time</th>
                        <th>Suite (Tests)</th>
                        <th>Test Name</th>
                        <th>Keyword Name</th>
                        <th>Stats Before</th>
                        <th>Stats After</th>
                    </tr>
                </thead>
                <tbody>
        """
        self.htmlfile.write(message)
        self.csvfile = self.SafeWriter(self.csvfileName_updated)
        self.csvfile.write_to_csv()
        self.bg_task = self.BackgroundPeriodicTask(self.timeinterval, self.csvfile, "Perodic Task")
        # Uncomment this if you want to debug locally
        # current_dir = os.getcwd()
        # filename = current_dir + "/" + file_name
        # webbrowser.open_new_tab(filename)

    def start_suite(self, name, attrs):
        self.suite_name = name
        self.test_count = len(attrs["tests"])

    def start_test(self, name, attrs):
        self.test_start_time = attrs["starttime"]
        self.test_name = name
        self.statsBefore = get_cpu_and_memory_usage_stats()
        memoryparam = devices_memory_usage()
        self.test_data_csv = []
        for devStat in memoryparam:
            csvdict = {
                "Time": self.test_start_time,
                "Test Suite Name": self.suite_name,
                "Test Name": name,
            }
            csvdict.update({"device": devStat})
            csvdict.update({"nativeHeap Before": memoryparam[devStat].nativeHeap})
            csvdict.update({"dalvikHeap Before": memoryparam[devStat].dalvikHeap})
            csvdict.update({"totalPss Before": memoryparam[devStat].totalPss})
            self.test_data_csv.append(csvdict)
        cpudata = devices_cpu_usage()
        cpu_index = 0
        if len(self.test_data_csv) == len(cpudata):
            for data in cpudata:
                cpuusage = fetchPercentagefromString(data)
                size = len(cpuusage)
                if size > 0:
                    self.test_data_csv[cpu_index].update({"CPU Stats Before": cpuusage[0]})
                cpu_index = cpu_index + 1
        self.statsBeforedicttest = self.test_data_csv

    def start_keyword(self, name, attrs):
        self.statsBeforedict = {}
        self.statsKBefore = get_cpu_and_memory_usage_stats()
        self.keyword_start_time = attrs["starttime"]
        memoryparam = devices_memory_usage()

        self.deviceData = []
        for devStat in memoryparam:
            csvdict = {
                "Time": str(self.keyword_start_time),
                "Test Suite Name": str(self.suite_name),
                "Test Name": str(name),
                "Keyword Name": str(attrs["kwname"]),
            }
            csvdict.update({"device": devStat})
            csvdict.update({"nativeHeap Before": memoryparam[devStat].nativeHeap})
            csvdict.update({"dalvikHeap Before": memoryparam[devStat].dalvikHeap})
            csvdict.update({"totalPss Before": memoryparam[devStat].totalPss})
            self.deviceData.append(csvdict)
        cpudata = devices_cpu_usage()

        if len(cpudata) == len(self.deviceData):
            cpu_index = 0
            for data in cpudata:
                cpuusage = fetchPercentagefromString(data)
                size = len(cpuusage)
                if size > 0:
                    self.deviceData[cpu_index].update({"CPU Stats Before": cpuusage[0]})
                cpu_index = cpu_index + 1
            self.statsBeforedict = self.deviceData

    def end_keyword(self, name, attrs):
        self.statsKAfter = get_cpu_and_memory_usage_stats()

        message = """
                <tr>
                    <td style="text-align: left;">%s</td>
                    <td style="text-align: left;max-width:300px;background-color:#FFFAFA">%s</td>
                    <td style="text-align: left;max-width:300px;background-color:#FFFAFA">%s</td>
                    <td style="text-align: left;max-width:300px;background-color:#FFFAFA">%s</td>
                    <td style="text-align: left;max-width:300px;background-color:#FFFAFA">%s</td>
                    <td style="text-align: left;max-width:300px;background-color:#FFFAFA">%s</td>
                </tr>

        """ % (
            str(self.keyword_start_time),
            str(self.suite_name),
            str(name),
            str(attrs["kwname"]),
            str(self.statsKBefore),
            str(self.statsKAfter),
        )
        self.htmlfile.write(message)
        if len(self.statsBeforedict) > 0:
            memoryparam = devices_memory_usage()
            if len(memoryparam) > 0:
                mp_index = 0
                for devStat in memoryparam:
                    self.statsBeforedict[mp_index].update({"nativeHeap After": memoryparam[devStat].nativeHeap})
                    self.statsBeforedict[mp_index].update({"dalvikHeap After": memoryparam[devStat].dalvikHeap})
                    self.statsBeforedict[mp_index].update({"totalPss After": memoryparam[devStat].totalPss})
                mp_index = mp_index + 1
            cpudata = devices_cpu_usage()
            cpu_index = 0
            if len(cpudata) > 0:
                for data in cpudata:
                    cpuusage = fetchPercentagefromString(data)
                    size = len(cpuusage)
                    if size > 0:
                        self.statsBeforedict[cpu_index].update({"CPU Stats After": cpuusage[0]})
                    cpu_index = cpu_index + 1
            self.csvfile.append_to_csv(self.statsBeforedict)

    def end_test(self, name, attrs):
        self.test_end_time = get_current_date_time(timeformat, True)
        self.statsAfter = get_cpu_and_memory_usage_stats()

        message = """

                <tr>
                    <td style="text-align: left;">%s</td>
                    <td style="text-align: left;max-width:300px;">%s</td>
                    <td style="text-align: left;max-width:300px;">%s</td>
                    <td style="max-width:300px;">-</td>
                    <td style="text-align: left;max-width:300px;">%s</td>
                    <td style="text-align: left;max-width:300px;">%s</td>
                </tr>


        """ % (
            str(self.test_end_time),
            str(self.suite_name),
            str(name),
            str(self.statsBefore),
            str(self.statsAfter),
        )

        self.htmlfile.write(message)
        # write_report_file(message)
        memoryparam = devices_memory_usage()
        mp_index = 0
        if len(self.test_data_csv) > 0:
            for devStat in memoryparam:
                self.test_data_csv[mp_index].update({"Time": self.test_end_time})
                self.test_data_csv[mp_index].update({"nativeHeap After": memoryparam[devStat].nativeHeap})
                self.test_data_csv[mp_index].update({"dalvikHeap After": memoryparam[devStat].dalvikHeap})
                self.test_data_csv[mp_index].update({"totalPss After": memoryparam[devStat].totalPss})
                mp_index = mp_index + 1
            cpudata = devices_cpu_usage()
            cpu_index = 0
            for data in cpudata:
                cpuusage = fetchPercentagefromString(data)
                size = len(cpuusage)
                if size > 0:
                    self.test_data_csv[cpu_index].update({"CPU Stats After": cpuusage[0]})
                cpu_index = cpu_index + 1
        self.csvfile.append_to_csv(self.test_data_csv)

    def close(self):
        # live_logs_file = open(file_name, "a+")
        message = """
            <table align="center">
                <tr>
                    <th>
                        <h4>Execution completed! </h4>
                    </th>
                </tr>
            </table>
        """
        self.bg_task.shutdown()
        self.htmlfile.write(message)
        self.htmlfile.close()
        self.csvfile.close()
        # write_report_file(message)
        # self.t1.join()


def devices_memory_usage():
    def memory_stats(device):
        udid = config["devices"][device]["desired_caps"]["udid"].strip(":5555")
        cmd = "adb -s " + udid + " shell dumpsys meminfo " + config["common_desired_caps"]["appPackage"]
        results = [0, 0, 0]
        try:
            output = str(subprocess.check_output(cmd, shell=True))
            Lines = str(output).split("\\n")
            for line in Lines:
                match = re.split("\s+", line.strip("\\r "))
                # Skip data after the 'App Summary' line.  This is to fix builds where
                # they have more entries that might match the other conditions.
                if len(match) >= 2 and match[0] == "App" and match[1] == "Summary":
                    break
                result_idx = None
                query_idx = None
                if match[0] == "Native" and match[1] == "Heap":
                    result_idx = 0
                    query_idx = -2
                elif match[0] == "Dalvik" and match[1] == "Heap":
                    result_idx = 2
                    query_idx = -2
                elif match[0] == "TOTAL":
                    result_idx = 1
                    query_idx = 1
                    # If we already have a result, skip it and don't overwrite the data.
                if result_idx is not None and results[result_idx] != 0:
                    continue
                if result_idx is not None and query_idx is not None:
                    results[result_idx] = round(float(match[query_idx]) / 1000.0, 2)

        except subprocess.CalledProcessError as e:
            print("shell dumpsys meminfo stdout output on error:\n" + str(e.output))
        return results

    deviceStatusDict = {}
    for device in config["devices"]:
        results = memory_stats(device)
        if results[0] != 0:
            memoryparam1 = memoryparam(results[0], results[2], results[1])
            deviceStatusDict.update({device: memoryparam1})
    return deviceStatusDict


def devices_cpu_usage():
    def cpu_stats(device):
        stats = ""
        udid = config["devices"][device]["desired_caps"]["udid"].strip(":5555")
        cmd = "adb -s " + udid + " shell dumpsys cpuinfo " + config["common_desired_caps"]["appPackage"]
        try:
            output = str(subprocess.check_output(cmd, shell=True))
            Lines = str(output).split("\\n")

            for line in Lines:
                match = re.split("\s+", line.strip("\\r "))
                size = len(match)
                # Skip data after the 'App Summary' line.  This is to fix builds where
                # they have more entries that might match the other conditions.
                if size > 1:
                    if config["common_desired_caps"]["appPackage"] in match[1]:
                        stats += str(device) + " :  " + " ".join(match) + " <br>"
                        break

        except subprocess.CalledProcessError as e:
            print("shell dumpsys cpuinfo stdout output on error:\n" + str(e.output))
        return stats

    statsArr = []
    for device in config["devices"]:
        statsArr.append(cpu_stats(device))
    return statsArr


def fetchPercentagefromString(test_string):
    res = [i for i in test_string.split() if "%" in i]
    return res


def get_cpu_and_memory_usage_stats():
    def cpu_usage_stats():
        def listToString(value):
            str1 = " "
            return str1.join(value)

        cpustatlist = devices_cpu_usage()
        stats = "CPU Usage: \n<br>" + listToString(cpustatlist)
        return stats

    # gives a single float value
    cpu = cpu_usage_stats()

    def memory_usage_stats():
        stats = None
        deviceStatusDict = devices_memory_usage()
        size = len(deviceStatusDict)
        if size > 0:
            stats = "Memory Status is  \n<br>"
            for devStat in deviceStatusDict:
                stats += (
                    devStat
                    + ": \n <br> Native Heap : "
                    + str(deviceStatusDict[devStat].nativeHeap)
                    + " dalvik Heap : "
                    + str(deviceStatusDict[devStat].dalvikHeap)
                    + " totalPss : "
                    + str(deviceStatusDict[devStat].totalPss)
                    + " <br>"
                )
        return stats

    # gives an object with many fields
    ram = memory_usage_stats()
    # you can convert that object to a dictionary
    stats = str(ram) + "\n" + str(cpu) + "\n"
    return stats


def get_current_date_time(time_format, trim: bool):
    t = datetime.datetime.now()
    if t.microsecond % 1000 >= 500:  # check if there will be rounding up
        t = t + datetime.timedelta(milliseconds=1)  # manually round up
    if trim:
        return t.strftime(time_format)[:-3]
    else:
        return t.strftime(time_format)


class memoryparam:
    def __init__(self, nativeHeap, dalvikHeap, totalPss):
        self.nativeHeap = nativeHeap
        self.dalvikHeap = dalvikHeap
        self.totalPss = totalPss
