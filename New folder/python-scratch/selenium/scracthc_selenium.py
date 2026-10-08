import os.path
import time
from datetime import timedelta,datetime

from appium.options.android import UiAutomator2Options
from appium.webdriver.common.appiumby import AppiumBy
from appium.webdriver.common.touch_action import TouchAction
from  selenium import  webdriver
from  selenium.webdriver.common.action_chains import  ActionChains
from  selenium.common.exceptions import  StaleElementReferenceException, NoSuchElementException
from  selenium.webdriver.support.ui import  Select,WebDriverWait
from  selenium.webdriver.support import  expected_conditions as Ec
from selenium.webdriver.common.by import  By
from  selenium.webdriver.common.alert import  Alert
from  appium.webdriver.common import  appiumby
options=webdriver.ChromeOptions()
options.add_argument("--start-maximized")
options.add_argument("--incognito")

prefs = {
    "profile.default_content_setting_values.notifications": 2,
    "profile.default_content_setting_values.geolocation": 2,
    "profile.default_content_setting_values.media_stream_mic": 2,
    "profile.default_content_setting_values.media_stream_camera": 2
}

options.add_experimental_option("prefs", prefs)
driver=webdriver.Chrome(options=options)
driver.get("https://www.snapdeal.com/")
webelent=driver.find_element(By.CSS_SELECTOR, "button[class*='DownloadAppButton']")
driver.find_element(By.ID, "search-box-input").send_keys("shirts")
wait=WebDriverWait(driver, 10)
suggestions = wait.until(
    Ec.presence_of_all_elements_located(
        (By.XPATH, "//div[contains(@class,'SuggestionContainer')]/div[contains(@class,'AutoSuggestionsEle')]/span")
    )
)

for suggestion in suggestions:
    text = suggestion.text.strip().lower()
    print(text)

    if "women" in text:
        driver.execute_script("arguments[0].click();", suggestion)
        break
brand_locator = (
    By.XPATH,
    "//div[contains(text(),'Brand') or @data-filtername='Brand']"
)

scroll = wait.until(
    Ec.presence_of_element_located(brand_locator)
)
# scroll by hard code value
# time.sleep(10)
# driver.execute_script("window.scrollBy(500, 1000)")
# print("the ardcode value get scrolled ")
#
# actual_time = (datetime.now() + timedelta(days=3)).strftime("%Y-%m-%d")
#
# path = os.path.join("selenium_screen")
#
# os.makedirs(path, exist_ok=True)
#
# filename = os.path.join(
#     path,
#     f"the_actualscreenshot_{actual_time}.png"
# )
#
# driver.save_screenshot(filename)
# # scroll by elent loaction of elemnt
# loc=scroll.location
# x=loc.get('x')
# y=loc.get('y')
# driver.execute_script("window.scrollBy(arguments[0], arguments[1])",
#     x,y)
#
# print("the scroll elemnt location is done")
# driver.save_screenshot(filename)
# driver.execute_script("window.scrollBy(500, -1000)")
# time.sleep(10)
# driver.execute_script("arguments[0].scrollIntoView(true)", scroll)
# driver.save_screenshot(filename)
# print("the scroll ito elent refrence")
# scroll.click()
# viewmore = driver.find_element(
#     By.XPATH,
#     "//*[@data-displayname='Brand']//button[contains(@class,'view-more-button')]"
# )
#
# # viewmore.click()
# driver.save_screenshot(filename)
mouse=driver.find_element(By.XPATH, "//div[@class='accountInner']")
action=ActionChains(driver)
# action.double_click()
# action.move_by_offset(100, 100)
# action.click_and_hold()
# action.drag_and_drop()
# action.context_click()
action.move_to_element(mouse).perform()
driver.find_element(By.XPATH, "//a[text()='login']").click()
# frame = driver.find_element(By.XPATH, "//iframe")
time.sleep(10)

driver.switch_to.frame("loginIframe")
driver.find_element(By.CSS_SELECTOR, "[placeholder='Mobile Number/ Email']").send_keys("6736373733")
time.sleep(10)
driver.find_element(By.CSS_SELECTOR, "[id='close-pop']").click()
driver.switch_to.default_content()
parent=driver.current_window_handle
parent_title = driver.title

driver.find_element(By.XPATH, "(//p[@class='product-title '])[1]").click()
time.sleep(10)

all_windows = driver.window_handles


for each_switch in all_windows:

    if each_switch != parent:

        driver.switch_to.window(each_switch)
        el=driver.find_elements(By.ID, "pincode-check")

        current_winodw=[]
        if len(el)>0 and el[0].is_displayed():

            print("the send key option found")
            el[0].send_keys("573211")
            driver.save_screenshot("chilswindow.png")
            current = driver.current_window_handle
            # get current index
            index = all_windows.index(current)
            for each in all_windows[index-1::-1]:
                driver.switch_to.window(each)
                if driver.current_window_handle == parent:
                    print("working fine all the concept are covered")
                    break

                else:
                    continue

wait = WebDriverWait(
    driver,
    20,
    poll_frequency=2,
    ignored_exceptions=[No]
)

element = wait.until(
    Ec.presence_of_element_located((By.ID, "username"))
)

element.send_keys("admin")







# appium connection

option=UiAutomator2Options()
option.platform_name = "Android"
option.device_name = "emulator-5554"

option.app_activity = ".Settings"
option.app_package = "com.android.settings"

option.automation_name = "UiAutomator2"

option.new_command_timeout = 1000

driver.find_element(AppiumBy.ACCESSIBILITY_ID , "contect desc")
driver.find_element(AppiumBy.ID , "resource id")
driver.find_element(AppiumBy.XPATH, "xpath we will take")
driver.find_element(AppiumBy.CLASS_NAME, "class name")
driver.find_element(
    AppiumBy.ANDROID_UIAUTOMATOR,
    'new UiSelector().textContains("Log")'
)
driver.find_element(
    AppiumBy.ANDROID_UIAUTOMATOR,
    'new UiSelector().clickable(true)'
)
driver.find_element(
    AppiumBy.ANDROID_UIAUTOMATOR,
    'new UiSelector().scrollable(true)'
)

# in ios"  lable means visble text
driver.find_element(
    AppiumBy.IOS_PREDICATE,
    'label == "Login" AND enabled == 1'
)
# we an also use the contains
driver.find_element(
    AppiumBy.IOS_PREDICATE,
    'label CONTAINS "Log"'
)
driver.find_element(
    AppiumBy.IOS_PREDICATE,
    'label BEGINSWITH "Set"'
)

driver.find_element(
    AppiumBy.IOS_CLASS_CHAIN,
    '**/XCUIElementTypeButton[`label == "Login"`]'
)
driver=webdriver.Remote("http://127.0.0.1:4327", options=option)
element=driver.find_element(AppiumBy.XPATH, "")
# scrol the down to up
def scroll_up(driver):

        size = driver.get_window_size()

        width = size["width"]

        height = size["height"]

        start_x = width // 2

        start_y = int(height * 0.8)

        end_y = int(height * 0.2)

        action = TouchAction(driver)

        action.press(x=start_x, y=start_y) \
            .wait(1000) \
            .move_to(x=0, y=end_y-start_y) \
            .release() \
            .perform()

def scroll_down(driver):
    size = driver.get_window_size()
    width=size["width"]
    height=size["height"]
    start_x=width//2
    start_y=int(height*0.2)
    end_y=int(height*0.8)
    action=TouchAction(driver)
    action.press(start_x, start_y).wait(100).move_to(x=0, y=end_y-start_y).release().perform()

def swipe_left_to_right(driver):

    size = driver.get_window_size()

    width = size["width"]

    height = size["height"]

    start_x = int(width * 0.2)

    end_x = int(width * 0.8)

    start_y = height // 2

    action = TouchAction(driver)

    action.press(x=start_x, y=start_y).wait(1000).move_to(x=end_x-start_x, y=0).release().perform()

def swipe_right_left(driver):

    size = driver.get_window_size()

    width = size["width"]

    height = size["height"]

    start_x = int(width * 0.8)

    end_x = int(width * 0.2)

    start_y = height // 2

    action = TouchAction(driver)

    action.press(x=start_x, y=start_y)\
          .wait(1000)\
          .move_to(x=end_x-start_x, y=0)\
          .release()\
          .perform()

# or:

driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiScrollable(new UiSelector().scrollable(true)).scrollIntoView(new UiSelector().resourceId("com.demo:id/login"))')

driver.find_element(
    AppiumBy.ANDROID_UIAUTOMATOR,
    'new UiScrollable(new UiSelector().scrollable(true)).setAsHorizontalList().scrollIntoView(new UiSelector().text("Photos"))'
)
# elemnt tap
TouchAction(driver).tap(element).perform()
# tap on cordinate
TouchAction(driver).tap(x=100, y=200).perform()
ac=TouchAction(driver)
ac.long_press(element).wait(100).release().perform()