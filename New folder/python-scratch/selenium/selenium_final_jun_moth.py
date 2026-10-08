import time

from  selenium import webdriver

from  selenium.webdriver.common.by import By
from  selenium.webdriver.common.action_chains import  ActionChains
from  selenium.webdriver.common.alert import  Alert
from  selenium.webdriver.support.ui import  Select, WebDriverWait
from  selenium.webdriver.support import  expected_conditions as Ec

from  selenium.common.exceptions import  StaleElementReferenceException, NoSuchElementException, ElementClickInterceptedException, ElementNotVisibleException
from  selenium.webdriver.chrome.options import  Options

option=Options()
option.add_argument("--start-maximized")
option.add_argument("--incognito")
prefs={
    "profile.default_content_settings_values.notifications": 2,
    "profile.default_content_settings_values.geolocation": 2,
    "profile.default_content_settings_values.media_stream": 2,
}
option.add_experimental_option("prefs", prefs)
driver=webdriver.Chrome(options=option)
# driver.get("https://demoapps.qspiders.com/ui/dropdown/multiSelect?sublist=1")
# mutipalslect=driver.find_element(By.XPATH, "//select[contains(@class,'MuiNativeSelect-select')]")

# time.sleep(10)
# wait=WebDriverWait(driver, 20)
# mutipalslect=wait.until(Ec.presence_of_element_located((By.XPATH, "//select[contains(@class,'MuiNativeSelect-select')]")))

# wait_poolint=WebDriverWait(driver, poll_frequency=4, timeout=30, ignored_exceptions=[NoSuchElementException, ElementClickInterceptedException])
# mutipalslect=wait_poolint.until(Ec.presence_of_element_located((By.XPATH, "//select[contains(@class,'MuiNativeSelect-select')]")))
#
# sc=Select(mutipalslect)
# if sc.is_multiple:
#
#     sc.select_by_value("Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops")
#     sc.select_by_index(3)
#     sc.select_by_visible_text("Mens Casual Slim Fit...")
#     print("the all slected options" , sc.all_selected_options)
#     print("the fitrst slected option ", sc.first_selected_option)
#     sc.deselect_by_index(3)
#
# else:
#     sc.select_by_value("values")
#     sc.select_by_index(1)

#     frames withcings
# driver.get("https://demoapps.qspiders.com/ui/frames?sublist=0")
# wait=WebDriverWait(driver, poll_frequency=4, timeout=25, ignored_exceptions=[NoSuchElementException, ElementClickInterceptedException, StaleElementReferenceException])
# webelemnts=wait.until(Ec.presence_of_element_located((By.CSS_SELECTOR, "[class='w-full h-96']")))
# driver.switch_to.frame(webelemnts)
# booleans =driver.find_element(By.XPATH, "//h2[text()='Login']").is_displayed()
# if booleans:
#     driver.find_element(By.ID, "username").send_keys("myname is yashwant")
#     driver.find_element(By.ID, "password").send_keys("password")
#     driver.find_element(By.ID, "submitButton").click()
#     # success = wait.until(
#     #     Ec.presence_of_element_located(
#     #         (By.XPATH, "//*[contains(text(),'successful')]")
#     #     )
#     # )
#     #
#     # print("Message:", success.text)
#     # print("Displayed:", success.is_displayed())
#     driver.switch_to.default_content()



# driver.get("https://demoapps.qspiders.com/ui/checkbox?sublist=0")
# wait=WebDriverWait(driver, poll_frequency=4, timeout=25, ignored_exceptions=[NoSuchElementException, ElementClickInterceptedException, StaleElementReferenceException])
# webelemnts=wait.until(Ec.presence_of_element_located((By.CSS_SELECTOR, "[type='checkbox']")))
# if webelemnts.is_displayed():
#     all_sleected=driver.find_elements(By.CSS_SELECTOR, "[type='checkbox']")
#     for each in all_sleected:
#         if not each.is_selected():
#             each.click()
# driver.get("https://demoapps.qspiders.com/ui/auth?sublist=0")
#
# wait=WebDriverWait(driver, poll_frequency=4, timeout=25, ignored_exceptions=[NoSuchElementException, ElementClickInterceptedException, StaleElementReferenceException])
# webelemnts=wait.until(Ec.presence_of_element_located((By.CSS_SELECTOR, "[id='AuthLink']")))
# if webelemnts.is_displayed():
#     parentwindow = driver.current_window_handle
#     webelemnts.click()
#     child_windows=driver.window_handles
#     for each in child_windows:
#         if each!=parentwindow:
#             driver.switch_to.window(each)
#             if driver.current_url == "https://basic-auth-git-main-shashis-projects-4fa03ca5.vercel.app/":
#                 print("authoticationtab")
#                 driver.get(
#                     "https://admin:admin@basic-auth-git-main-shashis-projects-4fa03ca5.vercel.app/"
#                 )
#                 print("the auto is passed")
#     driver.switch_to.window(parentwindow)
#     driver.find_element(By.CSS_SELECTOR, "[id='AuthLink']").is_displayed()




driver.get("https://demoapps.qspiders.com/ui/video?sublist=0&scenario=1")
wait=WebDriverWait(driver, poll_frequency=4, timeout=25, ignored_exceptions=[NoSuchElementException, ElementClickInterceptedException, StaleElementReferenceException])
webelemnts=wait.until(Ec.presence_of_element_located((By.XPATH, "//p[text()='Video Player']")))

if webelemnts.is_displayed():
    video = driver.find_element(By.TAG_NAME, "video")

    # play video
    driver.execute_script("arguments[0].play()", video)
    print("widwo started to paly")
    time.sleep(20)
    # pause video
    driver.execute_script("arguments[0].pause()", video)

    # check video duration
    duration = driver.execute_script("return arguments[0].duration", video)
    print("Duration:", duration)

    # check current time
    current_time = driver.execute_script("return arguments[0].currentTime", video)
    print("Current Time:", current_time)

    # mute video
    driver.execute_script("arguments[0].muted = true", video)

    # seek video to 10 seconds
    driver.execute_script("arguments[0].currentTime = 10", video)

# javascript exicuter
driver.execute_script("return document.URL")
driver.execute_script("return document.TITLE")
# padd the text to elemenst
driver.execute_script("arguments[0].value=arguments[1]", webelemnts, "sndkeys")
driver.execute_script("arguments[0].click()", webelemnts)
# scroll by hard code
driver.execute_script("window.scrollBy(300, 7000)")
# scroll by elemnt refrence
driver.execute_script("window.scrollIntoView(true)", webelemnts)
# scroll into loaction
loacton=webelemnts.location
x=loacton.get('x')
y=loacton.get('y')
driver.execute_script("window.scrollTo(arguments[0], arguments[1]);",
    x,
    y)

ac=ActionChains(driver)
ac.move_to_element(webelemnts)
ac.context_click()
ac.double_click()
ac.move_by_offset(el, 100, 200)
alert=Alert(driver)
alert.accept()
alert.dismiss()
alert.send_keys("")
alert.text