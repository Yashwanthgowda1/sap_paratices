import  json
import subprocess
import  os
from datetime import datetime
import requests
from appium import webdriver
from appium.webdriver.common.appiumby import AppiumBy
from library.utils.web import sleep
from  appium.webdriver.common.touch_action import  TouchAction
from selenium.common import NoSuchElementException, StaleElementReferenceException

__config=None
logcat_process = None
def load_config():
    global __config  # use the global variable
    if __config is not None:
        # If already loaded, return cached config
        print("the config loaded alredy")
        return __config
    cwd = os.getcwd()
    root_file=os.path.abspath(os.path.join(cwd, '..'))
    main_config_path=os.path.join(root_file,"config.json")
    print(main_config_path)
    if main_config_path.endswith(".json") and os.path.isfile(main_config_path):

        with open(main_config_path, 'r', encoding='utf-8') as file:
            __config=json.load(file)
        return __config
    else:
        return  None




def prepare_device(device_udid, package_name="in.startv.hotstar"):
    """
    Stop the app and clear cache for a specific device before starting tests.
    """
    # Force-stop the app (makes sure it's not running)
    subprocess.run(
        ["adb", "-s", device_udid, "shell", "am", "force-stop", package_name],
        capture_output=True,
        text=True
    )

    # Clear app data/cache
    subprocess.run(
        ["adb", "-s", device_udid, "shell", "pm", "clear", package_name],
        capture_output=True,
        text=True
    )

    print(f" Device {device_udid}: {package_name} stopped and cache cleared.")


def devic_ip_port():
    __config=load_config()
    port_number = __config.get('devices', {}).get('device_1', {}).get('port')
    ip_devices=__config['devices']['device_1']['desired_caps']['udid']
    print(port_number)
    print(ip_devices)
    return  port_number, ip_devices

def logcat_collection(device_ip, filename_prefix="yashwanth"):
    # Root folder for logs
    global logcat_process
    file_path = os.getcwd()
    root_file_path = os.path.abspath(os.path.join(file_path, '..'))
    logs_folder = os.path.join(root_file_path, 'device_logs')

    os.makedirs(logs_folder, exist_ok=True)

    # Timestamp for uniqueness
    if not  os.path.exists(logs_folder):
        return
    timestamp = datetime.now()
    logs_time = timestamp.strftime("%Y-%m-%d_%H-%M-%S")

    # Proper filename inside the folder
    filename = f"{filename_prefix}_{device_ip}_{logs_time}.txt"
    file_path = os.path.join(logs_folder, filename)

    # Run adb logcat
    try:
        # popen is run in the background
        logcat_process =subprocess.Popen(
            f"adb -s {device_ip} logcat  > \"{file_path}\"",
            shell=True,
        )
        print("Logcat captured successfully at:", file_path)
    except subprocess.CalledProcessError:
        print("❌ Failed to capture logcat")


def stop_logcat():
    global logcat_process
    if logcat_process:
        logcat_process.terminate()  # stops the background logcat process
        logcat_process.wait()
        print("🛑 Logcat stopped")
        logcat_process = None

def start_running_appium(port, timeout=30):
    """
    Start Appium server and wait until it is ready (Windows).
    """
    # Start Appium server in a new CMD window
    subprocess.Popen(f'start cmd /k "appium -p {port}"', shell=True)
    print(f"🚀 Appium server starting on port {port}...")

    url = f"http://127.0.0.1:{port}/wd/hub/status"

    for i in range(timeout):
        try:
            r = requests.get(url)
            if r.status_code == 200:
                print(f"✅ Appium is running on port {port}")
                return True
        except requests.exceptions.ConnectionError:
            pass
        sleep(1)  # wait 1 second before retrying

    raise Exception(f"❌ Appium failed to start on port {port} after {timeout} seconds")

def appium_desired_caps_connect(port):
    __config=load_config()

    config_caps=__config.get('common_desired_caps', {})
    desired_caps={
        "appActivity": config_caps['appActivity'],
        "appPackage":config_caps['appPackage'],
        "automationName": config_caps['automationName'],
        "platformName": config_caps['platformName'],
        "deviceName":  __config['devices']['device_1']['desired_caps']['udid'],
        "newCommandTimeout": config_caps['newCommandTimeout'],
        "optionalIntentArguments": config_caps['optionalIntentArguments'],
    }

    print("the dict is ", desired_caps)
    driver = webdriver.Remote(f"http://127.0.0.1:{port}/wd/hub", dict(desired_caps))
    sleep(5000)
    print("waiting for load the device")
    return  driver
    # driver.find_element(AppiumBy.XPATH, "element_id")


def swipe_top_by_cordinates(driver):
    size=driver.get_window_size()
    start_x=size['width']/2
    start_y=size['height']*0.8    #from the bottom
    end_y=size['height']*0.2
    actions = TouchAction(driver)
    actions.press(x=start_x, y=start_y).move_to(x=start_x, y=end_y).release().perform()


def swipe_right_left(driver):
    size = driver.get_window_size()
    start_x = size['width'] / 0.8
    start_y = size['height'] * 0.2  # from the bottom
    end_y = size['height'] /2
    actions = TouchAction(driver)
    actions.press(x=start_x, y=end_y).move_to(x=start_y, y=end_y).release().perform()


def swip_top_bottom(driver):
    size = driver.get_window_size()
    start_x = size['width'] / 2
    start_y = size['height'] * 0.2  # from the bottom
    end_y = size['height'] * 0.8
    actions = TouchAction(driver)
    actions.press(x=start_x, y=start_y).move_to(x=start_x, y=end_y).release().perform()


def click_on_update_app_(driver):

    driver.find_element(AppiumBy.XPATH, "//*[@text='Update App']").click()
    flag=driver.find_element(AppiumBy.XPATH, "//*[@text='JioHotstar']").is_displayed()
    if flag:
        # conentdic most of the time
        uninstall=driver.find_element(AppiumBy.ACCESSIBILITY_ID, "Uninstall")
        if uninstall.is_displayed():
            uninstall.click()
#             verify the option like cancell and all
            flag=driver.find_element(AppiumBy.XPATH, "//*[@text='Uninstall this app?']").is_displayed()
            if flag:
                driver.find_element(AppiumBy.ACCESSIBILITY_ID,"Cancel" ).click()
                falging = True
                while falging:
                    swipe_top_by_cordinates(driver)
                    try:
                        vales = driver.find_element(AppiumBy.ACCESSIBILITY_ID, "Google Play refund policy")
                        if vales.is_displayed():
                            falging = False
                    except (NoSuchElementException, StaleElementReferenceException):
                        # Element not yet visible or reference is stale
                        pass





if __name__=="__main__":
   port ,ip_address=devic_ip_port()
   prepare_device(ip_address)
   logcat_collection(ip_address, "hosting")
   start_running_appium(port)
   driver=appium_desired_caps_connect(port)
   sleep(1000)
   click_on_update_app_(driver)
   stop_logcat()






