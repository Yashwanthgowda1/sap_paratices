import sys
import subprocess

from shared_utils import sleep_with_msg

# device_1 = sys.argv[1]
# device_2 = sys.argv[2]
# print "Devices : ", device_1, device_2
# print type(device_1)
# cp_req = sys.argv[1]
# teams_req = sys.argv[2]
adb = sys.argv[1]
devices = []
status = []


def check_device_status():
    out = subprocess.check_output(adb + " devices", shell=True)
    print(out)
    for x in out.splitlines()[1:-1]:
        # d = x.split()[0].strip(':5555')
        d = x.split()[0][:-5]
        s = x.split()[1]
        if s in ["device"]:
            devices.append(d)
            status.append(s)
        # device.append(d)
        # status.append(s)
        else:
            print("device {} not connected ".format(d))
    print("Available Devices : ", devices)


def get_apk_versions():
    for device in devices:
        cp_version = subprocess.check_output(
            adb
            + " -s "
            + device
            + " shell dumpsys package com.microsoft.windowsintune.companyportal | findstr versionName",
            shell=True,
        )
        teams_version = subprocess.check_output(
            adb + " -s " + device + " shell dumpsys package com.microsoft.skype.teams.ipphone | findstr versionName",
            shell=True,
        )
        print("Company Portal Version {} on device {} ".format(cp_version, device))
        print("Teams Version {} on device {} ".format(teams_version, device))
    pass


def update_cp():
    cp_req = "5.0.4715.0"
    for device in devices:
        cp_version = subprocess.check_output(
            adb
            + " -s "
            + device
            + " shell dumpsys package com.microsoft.windowsintune.companyportal | findstr versionName",
            shell=True,
        )
        if cp_version.split("=")[1].strip() != cp_req:
            print("Updating CP ")
            cp_out = subprocess.check_output(
                adb
                + " -s "
                + device
                + " install -r E:\\teams_apk\\com.microsoft.windowsintune.companyportal-signed-"
                + cp_req
                + ".apk"
            )
            print(cp_out)
        else:
            print("CP already updated")
        print("CP on Device {} matches required version".format(device))
    pass


def update_teams_apk():
    teams_req = "2020031901"
    for device in devices:
        teams_version = subprocess.check_output(
            adb + " -s " + device + " shell dumpsys package com.microsoft.skype.teams.ipphone | findstr versionName",
            shell=True,
        )
        if teams_version.rsplit(".")[-1].strip() != teams_req:
            print("Updating Teams ")
            teams_out = subprocess.check_output(
                adb + " -s " + device + " install -r E:\\teams_apk\\MicrosoftTeams-" + teams_req + ".apk"
            )
            print(teams_out)
        else:
            print("Teams already updated")
        print("Teams on Device {} matches required version ".format(device))
    pass


def root_devices():
    for device in devices:
        subprocess.check_output(adb + " -s " + device + " root")
    pass


def reboot_devices():
    print("Rebooting devices")
    for device in devices:
        subprocess.check_output(adb + " -s " + device + " reboot")
        # os.system("adb -s " + device + "reboot")
    sleep_with_msg(reboot_devices, 10, "reboot_devices")


def wait_for_devices_to_be_back():
    while True:
        out = subprocess.check_output(adb + " devices")
        print(out)
        for x in out.splitlines()[1:-1]:
            d = x.split()[0].strip(":5555")
            s = x.split()[1]
            if s in ["device"]:
                pass


check_device_status()
# reboot_devices()
root_devices()
get_apk_versions()
update_cp()
update_teams_apk()
print("Updates Done")
get_apk_versions()
