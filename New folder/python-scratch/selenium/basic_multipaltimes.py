import datetime
import time
import  requests
from  selenium import  webdriver
import pyautogui
import time

import  os
from selenium.webdriver.common import by
from  selenium.webdriver.support.ui import  Select, WebDriverWait
from  selenium.webdriver.support import  expected_conditions as Ec
from selenium.common.exceptions import NoSuchElementException
from  selenium.common.exceptions import NoSuchAttributeException, StaleElementReferenceException
from  selenium.webdriver.common.by import  By
from  selenium.webdriver.common.action_chains import ActionChains
from  selenium.webdriver.common.alert import Alert
from  selenium.webdriver.chrome.options import  Options
from selenium.webdriver.support.relative_locator import locate_with
from  datetime import  timedelta

options = Options()
options.add_argument("--incognito")
options.add_argument("--start-maximized")
options.add_argument("--disable-notifications")
download_path = rf"C:\Users\C5403671\Downloads"
prefs = {
    "profile.default_content_setting_values.notifications": 1,
    "profile.default_content_setting_values.geolocation": 1,
    "profile.default_content_setting_values.media_stream": 1,
    "download.default_directory": download_path,
    "download.prompt_for_download": False,
    "download.directory_upgrade": True,
    "safebrowsing.enabled": True


}
options.add_experimental_option("prefs" ,prefs)

driver = webdriver.Chrome(options=options)
driver.get("https://selectorshub.com/xpath-practice-page/")
driver.maximize_window()

slector_page=driver.find_element(By.XPATH, "//h6[text()='Dummy Form']")
if not slector_page:
    try:
        if slector_page.is_displayed():
            print(driver.current_url)
            # fluent wiat
            wait=WebDriverWait(driver,timeout=20, poll_frequency=3, ignored_exceptions=[StaleElementReferenceException,NoSuchElementException])
            username=wait.until(Ec.visibility_of_element_located((By.XPATH, "//*[@title='Email']")))
            print("Displayed:", username.is_displayed())
            username.send_keys("yashwanth")
            password_textfiled=driver.find_element(By.ID, "pass")
            time.sleep(10)
            print("now pass enter ", password_textfiled.is_displayed())

            if  password_textfiled.is_displayed():
                os.makedirs("../selenium_screen/aguest_how_many_timr_tolearn", exist_ok=True)
    #             need to scroll the elmnet using java script exicuter by loaction of lemnt
                values=password_textfiled.location
                x=values['x']
                y=values['y']
                acutalltime=datetime.datetime
                driver.execute_script("window.scrollBy(arguments[0], arguments[1])", x, y)
                result = driver.save_screenshot(
                    f"../selenium_screen/aguest_how_many_timr_tolearn/finalmotrola{acutalltime.now().strftime('%H-%M-%S')}.png"
                )

                print(result)
                password_textfiled.send_keys("amma")
                time.sleep(3)
    #             scroll by hard code valur oe elemnt refence
                driver.execute_script("window.scrollBy(100,500)")
                print("the scroll by hardcode values also")

                result = driver.save_screenshot(
                    f"../selenium_screen/aguest_how_many_timr_tolearn/finalmotrola{acutalltime.now().strftime('%H-%M-%S')}.png"
                )

                print(result)
                loaction_submit=driver.find_element(By.XPATH, "//button[text()='Submit']")
                time.sleep(3)
                driver.execute_script("arguments[0].scrollIntoView(true)", loaction_submit
                                      )
                print(driver.execute_script("return document.URL"))
                print(driver.execute_script("return document.title"))
                print("ul and title is premited")
                excutescript=driver.find_element(By.XPATH, "//label[text()='Country']")
                driver.execute_script("arguments[0].value=arguments[1]", excutescript, "indian")
                print("the exicute script is donme")

                if loaction_submit.is_displayed():
                    print("tghe submit is dispalyed")

    #
                workinised_frames = wait.until(
                    Ec.element_to_be_clickable(
                        (By.XPATH, "//a[contains(text(),'practice iframe inside')]")
                    )
                )
                print(workinised_frames.is_displayed())
                print(workinised_frames.location)
                before = driver.execute_script("return window.pageYOffset")
                location = workinised_frames.location_once_scrolled_into_view
                size = workinised_frames.size

                x = location["x"] + size["width"] // 2
                y = location["y"] + size["height"] // 2

                blocked_by = driver.execute_script("""
                return document.elementFromPoint(arguments[0], arguments[1]);
                """, x, y)
                after = driver.execute_script("return window.pageYOffset")

                print("Before:", before)
                print("After :", after)



                driver.execute_script("arguments[0].click();", workinised_frames)

                print("the elmnte is clicked over here shodew root")

                wait = WebDriverWait(driver, 20)



                host = wait.until(
                    Ec.presence_of_element_located((By.ID, "userName"))
                )

                shadow_root = host.shadow_root

                element = shadow_root.find_element(By.CSS_SELECTOR, "a")
                if not element.is_displayed():
                    raise  Exception("elmnet i not diplayed ")

                element = driver.execute_script("""
                    return document
                        .querySelector("#userName")
                        .shadowRoot
                        .querySelector("a");
                """)
                parmet_window=driver.current_window_handle

                driver.execute_script("arguments[0].click();", element)
                child_winows=driver.window_handles
                for ecahwinodw in child_winows:
                    if ecahwinodw==parmet_window:
                        continue
                    else:
                        driver.switch_to.window(ecahwinodw)
                        driver.find_element(By.XPATH, "//input[@name='search_query']").send_keys("youtube")
                        driver.save_screenshot(
                            f"../selenium_screen/aguest_how_many_timr_tolearn/finalmotrola{acutalltime.now().strftime('%H-%M-%S')}.png"
                        )
                driver.switch_to.window(parmet_window)
                elements = driver.execute_script("""
                                return document
                                    .querySelector("#userName")
                                    .shadowRoot
                                    .querySelector("a");
                            """)

                print("Is displayed:", element.is_displayed())
                driver.back()
                # need to chekc wherathre i can go back

                diables_or_not=driver.find_element(By.XPATH,"//input[@placeholder='First Enter name']")
                location = diables_or_not.location_once_scrolled_into_view
                size = diables_or_not.size

                x = location["x"] + size["width"] // 2
                y = location["y"] + size["height"] // 2

                scroll_dibaledelemnts = driver.execute_script("""
                            return document.elementFromPoint(arguments[0], arguments[1]);
                            """, x, y)
    #             need tocked
                if not diables_or_not.is_enabled():
                    driver.find_element(By.XPATH, "//*[name()='svg'][@onclick='nameField()']").click()
                    if diables_or_not.is_enabled():
                        print("the lemnt is enabled now you can pass the data")
                        diables_or_not.send_keys("yashwanth")
                        driver.save_screenshot(
                            f"../selenium_screen/aguest_how_many_timr_tolearn/finalmotrola{acutalltime.now().strftime('%H-%M-%S')}.png"
                        )
                    mouse_hover=driver.find_element(By.CLASS_NAME, "dropdown")
                    action=ActionChains(driver)
                    action.move_to_element(mouse_hover).perform()
                    listof_elemnts_mosehove=driver.find_elements(By.XPATH, "//*[@class='dropdown-content']/a")
                    for eaching in listof_elemnts_mosehove:
                        print(eaching.text)
                    selector_dropdown=driver.find_element(By.ID, "cars")
                    sc=Select(selector_dropdown)
                    all_selcted_option=sc.options
                    print("in we get all the slected option ovr here ", len(all_selcted_option))
                    if sc.is_multiple:
                        sc.select_by_index(0)
                        sc.select_by_value("audi")
                        sc.select_by_visible_text("Opel")
                        print(sc.first_selected_option)
                        print(sc.all_selected_options)
                    else:
                        sc.select_by_index(0)
                        time.sleep(10)
                        sc.select_by_value("audi")
                        time.sleep(10)
                        sc.select_by_visible_text("Opel")
                        time.sleep(10)
    #                     date pickel
                    print("dropdown things done")
                    date_input = driver.find_element(By.XPATH, "//input[@type='date']")
                    driver.execute_script(
                        "arguments[0].value='2026-08-19';",
                        date_input
                    )

    #                 valiadte file dowload or not
                    file_path = rf"C:\Users\C5403671\Downloads"
                    expected_file = "Mega-sale-600-×-360-px-30.png"
                    scroll_first_loaction=driver.find_element(
                        By.XPATH,
                        "//a[normalize-space()='Click to Download PNG File']"
                    )
                    if scroll_first_loaction:
                        location_dowlad = scroll_first_loaction.location_once_scrolled_into_view
                        size = scroll_first_loaction.size
                        # loaction_dowllaodreturn dict va;lue nee tp take dict and conact wyth actula size

                        x = location_dowlad["x"] + size["width"] // 2
                        y = location_dowlad["y"] + size["height"] // 2

                        driver.execute_script("""
                                                return document.elementFromPoint(arguments[0], arguments[1]);
                                                """, x, y)
                        driver.execute_script(
                            "arguments[0].click();",
                            scroll_first_loaction
                        )
                        timeout = 20

                        for _ in range(timeout):
                            if os.path.exists(os.path.join(file_path, expected_file)):
                                print(" Download completed")
                                break
                            time.sleep(1)
                        else:
                            raise Exception("Download failed")

















    except Exception as e:
        print(type(e))
        print(e)
elif not slector_page:

    file_path = rf"C:\Users\C5403671\Downloads"
    expected_file = "Mega-sale-600-×-360-px-30.png"
    scroll_first_loaction = driver.find_element(
        By.XPATH,
        "//a[normalize-space()='Click to Download PNG File']"
    )
    if scroll_first_loaction:
        location_dowlad = scroll_first_loaction.location_once_scrolled_into_view
        size = scroll_first_loaction.size
        # loaction_dowllaodreturn dict va;lue nee tp take dict and conact wyth actula size

        x = location_dowlad["x"] + size["width"] // 2
        y = location_dowlad["y"] + size["height"] // 2

        driver.execute_script("""
                                                return document.elementFromPoint(arguments[0], arguments[1]);
                                                """, x, y)
    #     driver.execute_script(
    #         "arguments[0].click();",
    #         scroll_first_loaction
    #     )
    #     timeout = 20
    #
    #     for _ in range(timeout):
    #         if os.path.exists(os.path.join(download_path, expected_file)):
    #             print(" Download completed")
    #             break
    #         time.sleep(1)
    #     else:
    #         raise Exception("Download failed")

    driver.execute_script(
        "arguments[0].click();",
        scroll_first_loaction
    )

    time.sleep(2)

    # enter full path
    pyautogui.write(
        r"C:\Users\C5403671\Downloads\Mega-sale-600-×-360-px-30.png",
        interval=0.03
    )

    pyautogui.press("enter")
    driver.find_element(By.XPATH, "//button[text()='Click To Open Window Alert']").click()

    alert=driver.switch_to.alert
    print(alert.text)
    alert.accept()
    time.sleep(10)
    print("the alert is accepted")
    driver.find_element(By.XPATH, "//button[text()='Click To Open Window Alert']").click()
    alert.dismiss()
    time.sleep(20)
    driver.find_element(By.XPATH, "//button[text()='Click To Open Window Prompt Alert']").click()
    print(alert.text)
    alert.send_keys("ammm first time yaeshseini")
    alert.accept()
elif False:
    driver.get("https://www.leafground.com/table.xhtml?utm_source")
    table_header=driver.find_element(By.CSS_SELECTOR, "[role='grid'] thead[id*='form']")
    list_header_rows=table_header.find_elements(By.CSS_SELECTOR, "th")
    actualtextlooking_=list_header_rows[1].find_element(By.CSS_SELECTOR, "span").text
    print(rf"the avtual text by header is getting is {actualtextlooking_}")
#     chekc the sec value of country hows is indaiun
    dicts={}
    while True:
        _value_for_colums=driver.find_elements(By.CSS_SELECTOR, "[role='grid'] tbody[id*='form'] tr[role='row']")


        print("the typeof the values is", type(dicts))
        for each_crows in range(len(_value_for_colums)):
                each_time_sec_table=_value_for_colums[each_crows].find_elements(By.XPATH, ".//td[@role = 'gridcell']")
                # print(each_time_sec_table[1].get_attribute("outerHTML"))
                span = each_time_sec_table[1].find_element(
                By.CSS_SELECTOR, "[style*='vertical-align']")
                print(f"{each_crows} and the getting is {span.text}")
                if span.text.strip() == "United Kingdom":
                    EACH_NAME_VALUES=each_time_sec_table[0].get_attribute("textContent")
                    lst = dicts.get(span.text.strip(), [])
                    lst.append(EACH_NAME_VALUES)
                    dicts[span.text.strip()] = lst
        ecah_itation=driver.find_element(By.XPATH, "//a[@aria-label='Next Page']")
        if ecah_itation.get_attribute("tabindex") != "0":
                break
        ecah_itation.click()
        time.sleep(2)

    print("the dict is ", dicts)
elif False:
    print("STEP 1: Finding element")

    elemnt = driver.find_element(
        By.XPATH,
        "//span[contains(text(),'nested iframe scenarios')]"
    )

    print("Element found:", elemnt.text)

    print("\nSTEP 2: Getting element location and size")

    location_dowlad = elemnt.location_once_scrolled_into_view
    size = elemnt.size

    print("Location:", location_dowlad)
    print("Size:", size)

    x = location_dowlad["x"] + size["width"] // 2
    y = location_dowlad["y"] + size["height"] // 2

    print("Center X:", x)
    print("Center Y:", y)

    print("\nSTEP 3: Checking element from point")

    point_element = driver.execute_script(
        """
        return document.elementFromPoint(arguments[0], arguments[1]);
        """,
        x,
        y
    )

    print("Element at point:", point_element)

    print("\nSTEP 4: Getting current window")

    current_window = driver.current_window_handle

    print("Current window:", current_window)

    print("\nSTEP 5: Clicking element")

    driver.execute_script(
        "arguments[0].click();",
        elemnt
    )

    print("Clicked successfully")

    print("\nSTEP 6: Getting window handles")

    child = driver.window_handles

    print("Window handles:", child)
    print("Number of windows:", len(child))

    print("\nSTEP 7: Waiting and switching window")

    time.sleep(20)

    driver.switch_to.window(child[1])

    print("Switched to child window:")
    print(driver.current_window_handle)

    print("\nSTEP 8: Checking iframe count")

    frames = driver.find_elements(By.TAG_NAME, "iframe")

    print("Number of iframes:", len(frames))

    for index, frame in enumerate(frames):
        print(
            "Frame index:",
            index,
            "ID:",
            frame.get_attribute("id"),
            "NAME:",
            frame.get_attribute("name")
        )

    print("\nSTEP 9: Switching to iframe")

    driver.switch_to.frame(0)

    print("Successfully switched to frame")

    print("\nSTEP 10: Finding input element")

    input_element = driver.find_element(
        By.ID,
        "inp_val"
    )

    print("Input element found:", input_element)

    input_element.send_keys("framesenterd")

    print("Text entered successfully")

    print("\nSTEP 11: Returning to default content")

    driver.switch_to.default_content()

    print("Returned to main content")

    print("\nSTEP 12: Switching back to parent window")

    driver.switch_to.window(child[0])

    print("Back to parent window:")
    print(driver.current_window_handle)











