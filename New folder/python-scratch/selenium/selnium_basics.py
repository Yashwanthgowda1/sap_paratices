import time

from  selenium import  webdriver
from  selenium.webdriver.common.by import By
from  selenium.webdriver.support.ui import Select
from  selenium.webdriver.support import  expected_conditions as Ec
from  selenium.webdriver.chrome.options import Options
from  selenium.webdriver.common.action_chains import  ActionChains
from  selenium.webdriver.support.ui  import  WebDriverWait
from  selenium.common.exceptions import  NoSuchElementException, StaleElementReferenceException, NoSuchAttributeException, NoSuchShadowRootException, NoSuchFrameException, ElementNotVisibleException, ElementNotInteractableException, ElementClickInterceptedException


options=Options()
# options.add_argument("--start-maximize")
options.add_argument("--remote-allow-origins=*")
options.add_argument("--start-maximized")
prefs={
    "profile.default_content_settings.geolocation": 2,
    "profile.default_content_settings.notifications": 2,
    "profile.default_content_settings.media_stream": 2,
}


options.add_experimental_option("prefs", prefs)



driver=webdriver.Chrome(options=options)
# driver.maximize_window()


#
driver.get("https://www.amazon.in/")
time.sleep(10)

if "online shopping" in    driver.title.lower():
    wait = WebDriverWait(driver, 10)

    support=wait.until(Ec.visibility_of_element_located((By.ID, "twotabsearchtextbox")))
    support.send_keys("ipphones")

    drop_down_locator=driver.find_element(By.ID, "searchDropdownBox")
    verify=drop_down_locator.get_attribute("aria-describedby")
    if verify  and "searchDropdownDescription" in verify:
        dropdown=Select(drop_down_locator)
        if  not dropdown.is_multiple:
            dropdown.select_by_value("search-alias=amazon-devices")
            time.sleep(10)
            dropdown.select_by_visible_text("Amazon Pharmacy")
            dropdown.select_by_index(7)
            print(dropdown.first_selected_option.text)
            # not work in the single slect
            # dropdown.deselect_by_index(7)
            # dropdown.deselect_by_value("search-alias=amazon-devices")
            # dropdown.deselect_by_visible_text("Amazon Pharmacy")
        else:
            raise  AssertionError(" it is single select drop down")

    # selcting the dropdowns
    all_option=driver.find_element(By.XPATH, "//a[contains(@aria-label,'Open All')  or @id='nav-hamburger-menu']")
    all_option.click()
    time.sleep(10)

    all_home=driver.find_element(By.XPATH, "//div[contains(@id,'hmenu-customer')]/child::b")

    scrolling_element = driver.find_element(By.XPATH, "//div[@id='hmenu-canvas']/div[@id='hmenu-content']")

    # Target element inside the menu
    need_to_scroll = driver.find_element(By.XPATH, "(//a[text()='Customer Service'])[2]")

    # Scroll the container until the element is in view
    driver.execute_script(
        "arguments[0].scrollTop = arguments[1].offsetTop;",scrolling_element, need_to_scroll
    )

    # Take screenshot
    driver.save_screenshot("first_image.png")
    driver.find_elements(By.XPATH , "//div[@aria-describedby='nav-menu-label' and  contains(@class,'ignore')]").click()
    driver.find_element(By.ID, "nav-search-submit-button")













