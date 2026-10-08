import time

import requests
from  selenium import  webdriver
from  selenium.common.exceptions import StaleElementReferenceException, InvalidElementStateException
from  selenium.webdriver.common.alert import  Alert
from  selenium.webdriver.support.ui import Select, WebDriverWait
from selenium.webdriver.support import expected_conditions as ec
from  selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
import  os
option=Options()
option.add_argument("--start-maximized")
profile={
    "profile.default_content_settings.notifications":2,
    "profile.default_content_settings.media_stream":2,
    "profile.default_content_settings.geolocation":2

}
option.add_experimental_option("prefs", profile)

driver = webdriver.Chrome(options=option)
driver.get("https://www.hotstar.com/in/home")
wait=WebDriverWait(driver, timeout=10)
webelmnts=wait.until(ec.visibility_of_element_located((By.CSS_SELECTOR, "[class='icon-sports-line soul-icon NAV_ICON_FONT_SIZE']")))
os.makedirs("./screenshots/firstelementfound", exist_ok=True)
webelmnts.screenshot("./screenshots/firstelementfound/elementq.png")
webelmnts.click()
print("the clicked to  the elemnts")
time.sleep(10)
scolling_elemnet=driver.find_element(By.CSS_SELECTOR, "[title='LIVE Now']")
loaction=scolling_elemnet.location
x=loaction['x']
y=loaction['y']
driver.execute_script("window.scrollBy(arguments[0], arguments[1]);", x, y)
string_next="//h2[text()='LIVE Now']/ancestor::div[contains(@class, '7N6Y-huRJR43HnUwKB')]/following-sibling::div[@data-testid='tray-container']/descendant::button[contains(@class,'button-next')]"
string_diable_next="//h2[text()='LIVE Now']/ancestor::div[contains(@class, '7N6Y-huRJR43HnUwKB')]/following-sibling::div[@data-testid='tray-container']/descendant::button[contains(@class,'button-disabled')]"
for i in range(5):

        disabled_buttons = driver.find_elements(By.XPATH, string_diable_next)

        if len(disabled_buttons) > 0 and disabled_buttons[0].is_displayed():
            print("Next button disabled")
            disabled_buttons[0].screenshot("./screenshots/firstelementfound/element.png")
            break

        driver.find_element(By.XPATH, string_next).click()






# def auth_token(base_url):
#     payload = {
#         "username": "admin",
#         "password": "password123"
#     }
#
#     response = requests.post(
#         f"{base_url}/auth",
#         json=payload,
#         headers={"Content-Type": "application/json",
#         "Authorization" : "Barrer ${token}
#         },
#         timeout=15
#     )
#
#     if response.status_code == 200:
#         return response.json().get("token")
#
#
# def create_session(base_url, token):
#     session = requests.Session()
#     session.base_url=base_url
#
#     session.headers.update({
#         "Content-Type": "application/json",
#         "Accept": "application/json",
#         "Cookie": f"token={token}"
#     })
#
#     session.base_url = base_url
#
#     return session
#
#
# base_url = "https://restful-booker.herokuapp.com"
#
# payload = {
#     "firstname": "John",
#     "lastname": "Doe",
#     "totalprice": 150,
#     "depositpaid": True,
#     "bookingdates": {
#         "checkin": "2025-01-10",
#         "checkout": "2025-01-15"
#     },
#     "additionalneeds": "Breakfast"
# }
#
# # ✅ correct flow
# token = auth_token(base_url)
# session = create_session(base_url, token)
#
# response = session.post(
#     session.base_url + "/booking",
#     json=payload,
#     headers={"Content-Type": "application/json"}
# )
# responce_all=session.get(session.base_url + f"/booking/{response.json()["bookingid"]}",)
# # print("thestsus is ", responce_all.json().get("bookingdates"))
# dict_val=responce_all.json().get("bookingdates", {})
# print(dict_val["checkin"])
# print(response.status_code)
# print(response.json())

# if webelmnts.is_displayed():
#     webelmnts.screenshot("./screnshot/firtselemntfound/elemnt.png")
#     webelmnts.click()
# vlaidation of the broken links
while True:
    all_elemnts=driver.find_elements(By.XPATH, "//div[@data-testid='tray-card-default']//a[@data-testid='link']")
    print("the total number ements need to validate ", len(all_elemnts))
    for each in all_elemnts:
        title = each.get_attribute("aria-label")
        links=each.get_attribute("href")
        try:
            response=requests.get(links, timeout=10)
            if response.status_code>=400:
                print(f"the link is broken : {each}  and link is {links}" )
            else:
                print(f" the link is valide {links}")
        except requests.exceptions.RequestException:
            print(f"unableto access {links}")
    old_height = driver.execute_script(
        "return document.body.scrollHeight"
    )
    driver.execute_script( "window.scrollTo(0, document.body.scrollHeight)")
    new_hight = driver.execute_script(
        "return document.body.scrollHeight"
    )
    if old_height==new_hight:
        print("all the elmnts get captured ")
        break

driver.execute_script("arguments[0].click", webelmnts)
driver.execute_script("arguments[0].value=arguments[1]", webelmnts, "sendingkey")
values=str(driver.execute_script("return document.URL"))
title=str(driver.execute_script("return document.title"))
scroll_elmnt_refr=driver.execute_script("arguments[0].scrollIntoView(true)", webelmnts)
scroll_inise_table=driver.execute_script("arguments[0].scrollTop+arguments[0].scrollHeight", webelmnts
                                         )

alert=Alert(driver)
alert.accept()
alert.dismiss()
alert.send_keys("")
val=alert.text

sc=Select(webelmnts)
sc.select_by_index(0)
if sc.is_multiple:
    sc.select_by_value("")
    sc.select_by_visible_text("")
    sc.select_by_index(0)
    values=sc.all_selected_options
    first_slected=sc.first_selected_option
else:
    all_options_dripdown=sc.options
    for ecah in all_options_dripdown:
        sc.select_by_visible_text(ecah.text)

#         popusps
parentwindow=driver.current_window_handle
all_childs=driver.window_handles

# franes
driver.switch_to.frame("id")
driver.switch_to.frame("values")
driver.switch_to.frame("webelents")
driver.switch_to.parent_frame()
driver.switch_to.default_content()





