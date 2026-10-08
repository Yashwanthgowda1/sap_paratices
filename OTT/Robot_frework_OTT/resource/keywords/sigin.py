from library.common_web_andriod import CommonWebAndAndroid

common = CommonWebAndAndroid()

config = common.load_locators("config.json")
sign_in_dict = common.load_locators("resource/page_object/sigin.json")

def get_login_credentials():
    username = config['login_credentials']['username']
    password = config['login_credentials']['password']
    return username, password

def perform_login(device_type="web"):
    driver = common.driver
    username, password = get_login_credentials()

    username_elem = common.find_element(device_type, sign_in_dict, "username_text_field")
    username_elem.send_keys(username)

    password_elem = common.find_element(device_type, sign_in_dict, "password_text_field")
    password_elem.send_keys(password)
