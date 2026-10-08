"""Standalone script for making sure chrome driver is working whenever node is upgraded as chrome comes with node"""

from selenium import webdriver
from selenium.webdriver.chrome.options import Options as ChromeOptions

THE_DRIVERS = {}


def get_instance(which):
    """Get the driver instance"""
    if which not in THE_DRIVERS:
        raise ValueError(f"No driver instance found for key: {which}")
    return THE_DRIVERS[which]


def wait_for_response(context, message):
    """wait_for_response"""
    return input(f"{context}: {message}\nWAITING: ")


def sleep_with_message(context, sleep_secs, message):
    """sleep_with_message"""
    print(f"{context} Sleeping: {sleep_secs}: {message} ...")


def delete_instance(which):
    get_instance(which).quit()
    print(f"{which}: WebDriver closed successfully.")


def create_chrome_instance():
    chrome_options = ChromeOptions()
    # Initialize WebDriver with different options
    chrome_options.add_argument("--incognito")
    # chrome_options.add_argument("--no-sandbox")

    _driver = webdriver.Chrome(options=chrome_options)
    # Odd thing here, the console starts reporting what
    # look like driver startup messages for several seconds.
    #
    # This means the '_driver' returned is not fully initialized, and may be unusable/failed?
    #
    # sleep_with_message(15, "let browser start up")
    return _driver


def create_instance(which, browser_name="chrome"):
    if which in THE_DRIVERS:
        print(f"{which} Deleting previous instance ...")
        delete_instance(which)

    # Note: Only chrome is implemented, we should add edge, firefox, etc...
    if browser_name.lower() != "chrome":
        raise NotImplementedError(f"Sorry no support for '{browser_name}' yet - please add!")

    THE_DRIVERS[which] = create_chrome_instance()

    wait_for_response(which, "WebDriver initiated successfully")


####
#    Playground - go crazy...
####
if __name__ == "__main__":
    #
    # Pick how many instances by adding names in this list:
    #
    browsers = ["TDC1"]
    # browsers = ["TDC1", "TDC2"]

    #
    # Pick the URL to fetch:
    #
    # the_url = "https://login.microsoftonline.com/common/oauth2/v2.0/authorize?response_type=id_token&scope=openid%20profile&client_id=5e3ce6c0-2b1f-4285-8d4b-75ee78787346&redirect_uri=https%3A%2F%2Fteams.microsoft.com%2Fgo&state=eyJpZCI6IjEzNWY2NDM2LTExNGUtNDNiYy1iMjFhLWJkMGY4YWFlNGZhOCIsInRzIjoxNzE4MTc1NTAzLCJtZXRob2QiOiJyZWRpcmVjdEludGVyYWN0aW9uIn0%3D&nonce=cb8fcdc6-5fb5-4a79-beed-af0ebc2a5f96&client_info=1&x-client-SKU=MSAL.JS&x-client-Ver=1.3.4&prompt=select_account&client-request-id=e0fe0fc2-2879-4f77-b522-cefa68a12384&response_mode=fragment&sso_reload=true"
    the_url = "https://login.microsoftonline.com/common/oauth2/deviceauth"

    for which in browsers:
        create_instance(which)

    for which in browsers:
        driver = get_instance(which)

        print(f"{which}: ChromeDriver version:{driver.capabilities['chrome']['chromedriverVersion']}")
        print(f"{which}: Chrome version: {driver.capabilities['browserVersion']}")
        driver.get(the_url)

    wait_for_response("ALL", "Press <CR> to close all browsers: ")

    for which in browsers:
        delete_instance(which)

    print("Done")
