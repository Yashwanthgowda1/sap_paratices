from  selenium import  webdriver
from  selenium.webdriver.common.by import  By
from  selenium.common.exceptions import NoSuchElementException, NoSuchAttributeException, StaleElementReferenceException
from  selenium.webdriver.chrome.options import  Options
from  selenium.webdriver.support.ui import  WebDriverWait, Select
from  selenium.webdriver.support import  expected_conditions as Ec
from  selenium.webdriver.common.action_chains import ActionChains
import  time
from check import verifying_current_date_before_select

option=Options()
prefs={
    "profile.default_content_settings.notifications": 1,
    "profile.default_content_settings.geolocation":2,
    "profile.default_content_settings.media_stream":2

}
option.add_argument("--start-maximized")
option.add_experimental_option("prefs", prefs)
driver=webdriver.Chrome(options=option)
driver.get("https://www.makemytrip.com/flights/")
driver.implicitly_wait(10)
x_elemt=driver.find_element(By.XPATH, "//div[@class='tp-dt-header-icon']/img[@alt='minimize']")
if x_elemt.is_displayed():
    x_elemt.click()
driver.find_element(By.XPATH, "//span[@class='commonModal__close']").click()

elements = driver.find_elements(By.XPATH, "//div[contains(@class,'tooltipInfo')]")
time.sleep(10)
if elements:
    loaction_need = elements[0]
    if loaction_need.is_displayed():
        pointer=loaction_need.location
        size=loaction_need.size

        x = pointer['x']
        y = pointer['y']

        width = size['width'] + 20
        height = size['height'] + 20
        mouse_actions=ActionChains(driver)
        mouse_actions.move_by_offset((x+width), (y+height)).click().perform()
        if loaction_need.is_displayed():
            raise AssertionError(f"elemnt is still prsenst")
list_twotimes=['fromCity', 'toCity']
list_twotimes11=['beng', 'chen']
wait = WebDriverWait(driver, 10)
for lis, lt2 in zip(list_twotimes, list_twotimes11):
    from_city=driver.find_element(By.XPATH, f"//label[@for='{lis}']")
    from_city.click()
    displayed = wait.until(
        Ec.visibility_of_element_located(
            (By.XPATH, "//input[contains(@class,'react-autosuggest')]")
        )
    )

    if displayed.is():
        textfiledconatiner=driver.find_element(By.ID, 'react-autowhatever-1')
        for _ in range(4):
            driver.execute_script(
                "arguments[0].scrollTop += arguments[0].clientHeight;",
                textfiledconatiner
            )
            time.sleep(0.5)
    displayed.send_keys(lt2)
    driver.find_element(By.XPATH, "//li[contains(@class,'react-autosuggest__suggestion--first')]").click()
    displayed = driver.find_element(
        By.XPATH, f"//input[contains(@id,'{lis}')]"
    )
    taken_value=displayed.get_attribute("value")
    print("the taken values is the ", taken_value)
    if lt2 in taken_value.lower():
        print(taken_value)
driver.save_screenshot("make_mytrip.png")
driver.find_element(By.XPATH, "//label[@for='departure']")
time.sleep(10)
elemnts=driver.find_elements(By.XPATH, "//div[@class='DayPicker-Month']/div[@class='DayPicker-Caption']/div")
for startig_month in elemnts:
    start_side=startig_month
    print("the ach elemnst ", startig_month.text)

values_1="February 2026"
values_2="March 2026"

booking_date=verifying_current_date_before_select(25)

# //div[contains(@class,'DayPicker-Day')]/div[@class="dateInnerCell"]/p[text()='values']






