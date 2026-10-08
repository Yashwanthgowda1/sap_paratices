from resource.library.Setuputility import SetupUtility
from resource.library.common_web_andriod import driver, find_element, take_screenshot_on_error, load_locators
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as Ec
from selenium.common.exceptions import TimeoutException

config = SetupUtility.load_config()
sing_in_dict = load_locators("resource/page_object/sigin.json")

def get_login_credentials():
    username = config['login_credentials']['username']
    password = config['login_credentials']['password']
    return username, password

def perform_login(device_type="web"):
    global driver  
    username, password = get_login_credentials()

    element = find_element(device_type, sing_in_dict, "sing_in_page")
    if element:
        find_element(device_type, sing_in_dict, "username_text_field").send_keys(username)
        find_element(device_type, sing_in_dict, "password_text_field").send_keys(password)
        find_element(device_type, sing_in_dict, "login_button").click()

        try:
            WebDriverWait(driver, 10).until(Ec.title_contains("Dashboard"))
        except TimeoutException:
            take_screenshot_on_error("Login not done successfully")
            raise Exception("Login not done successfully")
        
def search_methods(device_type="web"):
    find_element(device_type,sing_in_dict,"search_field").send_keys("python dictionary")
