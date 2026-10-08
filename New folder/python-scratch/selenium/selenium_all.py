import time

from  selenium import  webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from  selenium.webdriver.common.action_chains import ActionChains
from  selenium.webdriver.common.alert import  Alert
from  selenium.common.exceptions import NoSuchElementException, StaleElementReferenceException, ElementNotVisibleException, ElementNotSelectableException
from  selenium.webdriver.support.ui import WebDriverWait, Select
from  selenium.webdriver.support import  expected_conditions as EC
import  requests
# options=Options()
#
# options.add_argument("--remote-allow-origins=*")
# options.add_argument("--start-maximized")
#
# options.add_argument("--incognito")
# pref={
#     "profile.default_content_settings.geolocation": 2,
#     "profile.default_content_settings.notifications": 2,
#     "profile.default_content_settings.media_stream": 2
#
# }
# options.add_experimental_option("prefs", pref)
# driver=webdriver.Chrome(options=options)
# driver.get("https://the-internet.herokuapp.com/")
# elemnst=driver.find_element(By.XPATH,"//a[text()='Broken Images']")
# link=elemnst.get_attribute("href")
# responce=requests.get(link)
# if responce.status_code<400:
#     print("the status code is ", responce.status_code)
#     print("this is broken not link")
# else:
#     print(
#         "this is the broekn link"
#     )
# driver.find_element(By.XPATH, "//a[text()='Checkboxes']").click()
# MULTIPAL=driver.find_elements(By.XPATH, "//*[@id='checkboxes']/*[@type='checkbox']")
# for i in  range(100) :
#     if not MULTIPAL[0].is_selected():
#         print("the check box is selected")
#         MULTIPAL[0].click()
#
#     if  MULTIPAL[1].is_selected():
#         MULTIPAL[1].click()
#         print("the check box is not slected")
#
# driver.back()
# action=ActionChains(driver)
# driver.find_element(By.XPATH, "//a[text()='Context Menu']").click()
#
# rightclick=driver.find_element(By.ID, "hot-spot")
#
# action.context_click(rightclick).perform()
# alert=Alert(driver)
# alert.accept()
# driver.back()
# driver.find_element(By.XPATH, "//a[text()='Drag and Drop']").click()
# src=driver.find_element(By.ID, "column-a")
# dst=driver.find_element(By.ID,"column-b" )
# action.click_and_hold(src).move_to_element(dst).release().perform()
# print("the drag and drop is done")
# driver.back()
# driver.find_element(By.XPATH, "//*[text()='Dynamic Loading']").click()
#
# driver.find_element(By.XPATH, "//*[text()='Example 2: Element rendered after the fact']").click()
#
# driver.find_element(By.XPATH, "//*[text()='Start']").click()
# # wait=WebDriverWait(driver, timeout=30)
# # wait.until(EC.visibility_of_element_located((By.XPATH, "//*[text()='Hello World!']")))
#
# # if textelemnt.is_displayed():
# #     print(textelemnt.text)
#
# wait=WebDriverWait(driver, timeout=10,poll_frequency=2,ignored_exceptions=[NoSuchElementException, StaleElementReferenceException])
# # textelemnt=driver.find_element(By.XPATH, "//*[text()='Hello World!']")
# elemnsts=wait.until(EC.visibility_of_element_located((By.XPATH, "//*[text()='Hello World!']")))
# print(elemnsts.text)
# driver.back()
# driver.back()
driver= webdriver.Chrome()
# driver.get("https://www.amazon.in/")
# driver.maximize_window()
# time.sleep(100)
# driver.find_element(By.ID, "twotabsearchtextbox").send_keys("laptops")
# # driver.execute_script("arguments[0].value = arguments[1];",
# #     js,
# #     "sendvalues")
# # print("the values is passed sucesfully")
# wait=WebDriverWait(driver, timeout=20, poll_frequency=3, ignored_exceptions= [NoSuchElementException, StaleElementReferenceException])
# elemnt=wait.until(EC.visibility_of_element_located((By.ID, "nav-logo-sprites")))
# # if elemnt.is_displayed():
# #     webelmnt=driver.find_element(By.ID, "searchDropdownBox")
# #     select=Select(webelmnt)
# #     if not  select.is_multiple:
# #         select.select_by_value("search-alias=amazon-devices")
# #         select.select_by_index(4)
# #         select.select_by_visible_text("Apps & Games")
# #         print(select.first_selected_option.text)
# #     else:
# #         select.select_by_value("amazon")
# #         select.deselect_by_value("amazon")
# #         select.deselect_by_index(3)
# #         select.all_selected_options
# #         select.deselect_all()
#
# driver.execute_script("history.go(0)")
# elemnt_title=driver.execute_script("return document.title")
# print("the tile of the page is ", elemnt_title)
#
# # scrolling suing the javascript
#
# # scrollby hardcore
# from  datetime import  timedelta,datetime
# import  os
#
# os.makedirs("screenshot", exist_ok=True)
#
# # driver.execute_script("window.scrollBy(100, 1000)")
#
# # scroll by elemnt refernce
# elementrefebce=driver.find_element(By.XPATH, "//*[text()='Instagram']")
# # driver.execute_script("arguments[0].scrollIntoView(true)", elementrefebce)
#
# # scroll by loaction
# # sizes=elementrefebce.location
# # x_size=sizes["x"]
# # y_size=sizes["y"]
# # driver.execute_script(f"window.scrollBy({x_size}, {y_size})")
#
#
#
#
# filename = "screenshot/picture_" + datetime.now().strftime("%d-%m-%Y_%H-%M-%S") + ".png"
#
# driver.get_screenshot_as_file(filename)
#
#


driver.get("https://the-internet.herokuapp.com/hovers")
elemnts=driver.find_elements(By.CSS_SELECTOR, "[alt='User Avatar']")
eachaftermousehover=driver.find_elements(By.XPATH, "//*[@class='figure']/descendant::h5")
action=ActionChains(driver)
for i in range(len(elemnts)):
    action.move_to_element(elemnts[i]).perform()
    action.double_click(elemnts)
    action.context_click(elemnts)

#     print(eachaftermousehover[i].text)


#  alert
allerts=Alert(driver)
allerts.accept()
allerts.dismiss()
allerts.send_keys("")


# frames
driver.switch_to.frame("")
driver.switch_to.frame("byindx")
driver.switch_to.frame("webelmnt")
driver.switch_to.default_content()
driver.switch_to.parent_frame()    # back ine step of frame parnet

parent=driver.current_window_handle

#    after click the child tab is opend ned window like 5 winodws

all_child_window=driver.window_handles
for ecahwindo in all_child_window:
    driver.switch_to.window(ecahwindo)
    presnet=driver.find_element("finsll the elemnst ")
    if presnet:
        driver.switch_to.window(parent)












