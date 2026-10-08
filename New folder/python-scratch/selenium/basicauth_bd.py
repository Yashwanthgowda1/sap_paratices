from selenium.webdriver.common.action_chains import ActionChains
from selenium.common.exceptions import StaleElementReferenceException, ElementClickInterceptedException, NoSuchElementException
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.alert import Alert
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import Select, WebDriverWait
from selenium.webdriver.common.by import By
from selenium import webdriver
import time

import os
download=os.path.abspath(__file__)
print("the currentpath is ", download)
download_dir=os.path.join(os.path.dirname(download), "download_folders")
print(download_dir)

if not os.path.exists(download_dir):
    os.makedirs(download_dir)
    print("Directory created")
else:
    print("Directory already exists")


prefs={
    "profile.default_content_settings_values.notifications":1,
    "profile.default_content_settings_values.media_stream":1,
    "profile.default_content_settings_values.geolocation":1,
    "download.default_directory": download_dir,
        "download.prompt_for_download": False,
        "download.directory_upgrade": True
}
option=Options()
option.add_argument("--incognito")
option.add_argument("--start-maximized")
option.add_experimental_option("prefs", prefs)

# driver=webdriver.Chrome(options=option)
# driver.get("https://www.leafground.com/")
# wait=WebDriverWait(driver, timeout=10)
# bolleans=wait.until(EC.presence_of_element_located((By.CSS_SELECTOR, "[class='route-bar-breadcrumb']")));
# print("the emnet is viable is ", bolleans.text)
# elmnsts=driver.find_element(By.CSS_SELECTOR, "[id='menuform:j_idt38']")
# ac=ActionChains(driver)
# # elments=ac.move_to_element(elmnsts[1]).perform()
# elmnsts.click()
# cond=driver.find_element(By.XPATH, "//span[text()='Dashboard']")
# elmnsts_dash=wait.until(EC.visibility_of(cond))
# if elmnsts_dash:
#     currenturl=driver.current_url
#     driver.find_element(By.XPATH, "//span[text()='Auth']").click()
#     afterchangedurl=driver.current_url
#     if currenturl==afterchangedurl:
#         raise AssertionError("the elmnet which url is trying is same not changes")
#     webelemnst=wait.until(EC.visibility_of_element_located((By.XPATH, "//*[text()='Basic Authentication (New Window)']")))
#     if webelemnst.is_displayed():
#         print("the visbality of the webelemnst is ", webelemnst.text)
#         beforeclik_parent=driver.current_window_handle
#         driver.find_element(By.ID, "j_idt88:j_idt90").click()
#         all_chilednew_window=driver.window_handles
#         for each in all_chilednew_window:
#             if each != beforeclik_parent:
#                 print(driver.title)
#                 driver.switch_to.window(each)
              
#                 break

#         # -------------------------------------------------------
#         # APPROACH 1: Embed credentials directly in the URL
#         # Works for most sites. Format: http://user:pass@host:port/path
#         # -------------------------------------------------------
#         driver.get("http://admin:testleaf@leafground.com:8090/login")

#         # Validate success message appears after login
    
#         # -------------------------------------------------------
#         # APPROACH 2: CDP (Chrome DevTools Protocol) — set auth header
#         # Best when you can't change the URL (e.g. redirects, dynamic URLs)
#         # -------------------------------------------------------
#         # import base64
#         # credentials = base64.b64encode(b"admin:admin").decode("utf-8")
#         # driver.execute_cdp_cmd("Network.enable", {})
#         # driver.execute_cdp_cmd("Network.setExtraHTTPHeaders", {
#         #     "headers": {"Authorization": f"Basic {credentials}"}
#         # })
#         # driver.get("http://leafground.com:8090/login")

#         # -------------------------------------------------------
#         # APPROACH 3: Switch to Alert (only if site uses JS prompt, NOT native dialog)
#         # NOTE: Native browser Basic Auth dialogs are NOT JS alerts in Chrome/Edge 77+
#         #       This approach will raise NoAlertPresentException on modern browsers
#         # -------------------------------------------------------
#         # from selenium.webdriver.common.keys import Keys
#         # alert = driver.switch_to.alert
#         # alert.send_keys("admin" + Keys.TAB + "admin")
#         # alert.accept()
#         driver.switch_to.window(beforeclik_parent)

# browser_menu = wait.until(EC.element_to_be_clickable(
#     (By.XPATH, "//ul[@class='layout-menu']//span[text()='Browser']/parent::a")
# ))
# browser_menu.click()
# name_parent=driver.current_window_handle
# print(name_parent.title)
# driver.find_element(By.XPATH, "//span[text()='Alert']").click()
# alert_winowchanedlink=driver.window_handles
# for eachwindow in alert_winowchanedlink:
#     if eachwindow!=name_parent:
#         driver.switch_to.window(eachwindow)
#         print(driver.title)
#         break
#     alerst=driver.find_elements(By.XPATH, "//*[@class='card']/button")
#     i=0
#     for each_alers in alerst:
#         if i<2:
#             each_alers.click()
#             try:
#                 alert = driver.switch_to.alert
#                 print(alert.text)
#                 alert.accept()
#                 i+=1
#             except Exception:
#                 pass
# time.sleep(100)
# driver.find_element(By.XPATH, driver.find_element(By.XPATH, "//span[text()='Window']")).click()
# currentwindow=driver.current_window_handle
# print("the currentwindowtitkes ", currentwindow)
# driver.find_element("//span[text()='Open Multiple']").click()
# mutipal=driver.window_handles
# for switching in mutipal:
#     if currentwindow!=switching:
#         driver.switch_to.window(switching)
#         elemnsts=wait.until(EC.visibility_of_element_located((By.XPATH, "//*[text()='Customer Analytics Table']")))
#         if not elemnsts:
#              raise AssertionError("the elmnet which driver not able to find")
#         driver.close()
# driver.switch_to.window(currentwindow)
# bol=driver.find_element("//span[text()='Open with delay']").is_displayed()
# if bol:
#     print("all window condition")

# ================================================================
# FRAMES / IFRAMES — SWITCH AND HANDLE
# ================================================================

driver = webdriver.Chrome(options=option)
driver.get("https://www.leafground.com/")
wait = WebDriverWait(driver, timeout=10)

# --- Switch to frame by INDEX (0 = first frame on page) ---
driver.switch_to.frame(0)
# interact with elements inside the frame
elem = driver.find_element(By.XPATH, "//input[@type='text']")
elem.send_keys("inside frame")
# return to main page
driver.switch_to.default_content()

# --- Switch to frame by NAME or ID ---
driver.switch_to.frame("frame_name_or_id")
driver.find_element(By.XPATH, "//button").click()
driver.switch_to.default_content()

# --- Switch to frame by WebElement (most reliable) ---
frame_element = wait.until(EC.presence_of_element_located((By.TAG_NAME, "iframe")))
driver.switch_to.frame(frame_element)
driver.find_element(By.XPATH, "//input").send_keys("hello")
driver.switch_to.default_content()

# ================================================================
# NESTED FRAMES (frame inside a frame)
# ================================================================
# Structure:
#   main page
#     └── outer frame
#           └── inner frame

# Step 1: switch to outer frame
driver.switch_to.frame(0)

# Step 2: switch to inner frame (relative to outer)
driver.switch_to.frame(0)

# Interact inside inner frame
driver.find_element(By.XPATH, "//input").send_keys("nested frame")

# Step 3a: go up ONE level to outer frame
driver.switch_to.parent_frame()

# Step 3b: go all the way back to main page
driver.switch_to.default_content()

# ================================================================
# SUMMARY — which method to use
# ================================================================
# switch_to.frame(0)              → by index  (fragile if page adds frames)
# switch_to.frame("name_or_id")   → by name/id attribute
# switch_to.frame(webelement)     → by element (most reliable)
# switch_to.default_content()     → exit ALL frames → back to main page
# switch_to.parent_frame()        → exit ONE level (nested frames only)

# ================================================================
# DROPDOWNS
# ================================================================

# --- TYPE 1: Native HTML <select> dropdown — use Select class ---
# <select id="country">
#   <option value="in">India</option>
#   <option value="us">USA</option>
# </select>

dropdown_elem = driver.find_element(By.ID, "country")
sel = Select(dropdown_elem)

sel.select_by_visible_text("India")   # select by text shown in UI
sel.select_by_value("us")             # select by value attribute
sel.select_by_index(2)                # select by position (0-based)

print(sel.first_selected_option.text) # get currently selected option text
all_opts = [o.text for o in sel.options]  # get all option texts
print(all_opts)

# Multi-select dropdown (select multiple options)
sel.select_by_visible_text("India")
sel.select_by_visible_text("USA")
sel.deselect_by_visible_text("India")  # deselect one
sel.deselect_all()                     # deselect all

# --- TYPE 2: Custom dropdown (div/ul based, NOT <select>) ---
# <div class="dropdown">
#   <button>Select Country</button>
#   <ul>
#     <li>India</li>
#     <li>USA</li>
#   </ul>
# </div>

# Step 1: click the dropdown button to open options
driver.find_element(By.XPATH, "//button[contains(text(),'Select Country')]").click()

# Step 2: wait for options to appear, then click the option
wait.until(EC.element_to_be_clickable(
    (By.XPATH, "//ul//li[text()='India']")
)).click()

# ================================================================
# SUMMARY — which to use
# ================================================================
# <select> tag present   → use Select class (select_by_text/value/index)
# <div>/<ul> dropdown    → click toggle button, then click option directly

# ================================================================
# JAVASCRIPT EXECUTOR
# ================================================================

# --- JS CLICK (bypass visibility/interactable issues) ---
elem = driver.find_element(By.XPATH, "//button[text()='Submit']")
driver.execute_script("arguments[0].click();", elem)

# --- JS SEND TEXT (bypass readonly/disabled inputs) ---
input_elem = driver.find_element(By.ID, "username")
driver.execute_script("arguments[0].value=arguments[1];", input_elem, "the etxyvalues")

# --- JS HIGHLIGHT element (useful for debugging) ---
driver.execute_script("arguments[0].style.border='3px solid red';", elem)

# ================================================================
# SCROLLING — ALL WAYS
# ================================================================

# 1. Scroll to a specific element (bring into view)
elem = driver.find_element(By.XPATH, "//button[text()='Load More']")
driver.execute_script("arguments[0].scrollIntoView(true);", elem)

# 2. Scroll by pixels (x, y) — scrolls the MAIN PAGE
driver.execute_script("window.scrollBy(0, 500);")    # scroll down 500px
driver.execute_script("window.scrollBy(0, -500);")   # scroll up 500px
driver.execute_script("window.scrollBy(500, 0);")    # scroll right

# 3. Scroll to EXACT position on the page
driver.execute_script("window.scrollTo(0, 1000);")   # scroll to y=1000

# 4. Scroll to END of page using scrollHeight
driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")

# 5. Scroll to TOP of page
driver.execute_script("window.scrollTo(0, 0);")

# 6. Scroll INSIDE a scrollable element (div with overflow:auto/scroll)
scrollable_div = driver.find_element(By.ID, "scrollable-container")
driver.execute_script("arguments[0].scrollTop = arguments[0].scrollHeight;", scrollable_div)
# arguments[0] = the element, scrollTop = current scroll position inside it

# 7. Scroll inside element by specific pixels
driver.execute_script("arguments[0].scrollBy(0, 300);", scrollable_div)

# ================================================================
# CHECK IF PAGE WAS SCROLLED
# ================================================================

# Get current scroll position before scrolling
before_scroll = driver.execute_script("return window.scrollY;")

driver.execute_script("window.scrollBy(0, 500);")

# Get scroll position after scrolling
after_scroll = driver.execute_script("return window.scrollY;")

if after_scroll > before_scroll:
    print("Page scrolled successfully. Position:", after_scroll)
else:
    print("Page did NOT scroll")

# Check scroll position inside a div element
div_scroll_before = driver.execute_script("return arguments[0].scrollTop;", scrollable_div)
driver.execute_script("arguments[0].scrollTop += 300;", scrollable_div)
div_scroll_after = driver.execute_script("return arguments[0].scrollTop;", scrollable_div)

if div_scroll_after > div_scroll_before:
    print("Div scrolled. New position:", div_scroll_after)

# ================================================================
# ACTION CHAINS — hover, double click, right click, drag & drop
# ================================================================

ac = ActionChains(driver)

# Hover over element (triggers dropdown menus)
hover_elem = driver.find_element(By.XPATH, "//span[text()='Products']")
ac.move_to_element(hover_elem).perform()

# Double click
dbl_elem = driver.find_element(By.ID, "editable-cell")
ac.double_click(dbl_elem).perform()

# Right click (context menu)
right_elem = driver.find_element(By.ID, "file-item")
ac.context_click(right_elem).perform()

# Click and hold → drag → release (drag & drop)
source = driver.find_element(By.ID, "drag-item")
target = driver.find_element(By.ID, "drop-zone")
ac.drag_and_drop(source, target).perform()

# Chain multiple actions together
ac.move_to_element(hover_elem).click().perform()

# ================================================================
# FILE UPLOAD
# ================================================================

# For <input type="file"> — use send_keys with absolute file path
file_input = driver.find_element(By.XPATH, "//input[@type='file']")
file_input.send_keys(r"C:\Users\user\Documents\test.pdf")

# If file input is hidden — make it visible with JS first, then send_keys
driver.execute_script("arguments[0].style.display='block';", file_input)
file_input.send_keys(r"C:\Users\user\Documents\test.pdf")

# Verify file was attached — check the value attribute
uploaded = file_input.get_attribute("value")
print("Uploaded file:", uploaded)  # prints filename


sc=Select(elem)
if sc.is_multiple:
    sc.all_selected_options
    sc.first_selected_option
    sc.options
    sc.select_by_index()
    sc.select_by_value()
    sc.select_by_visible_text("the values")
    sc.deselect_all()
ac=ActionChains(driver)
ac.context_click()
ac.double_click()
ac.move_by_offset(100, 100)

# ================================================================
# FILE UPLOAD
# ================================================================

# --- Standard upload: <input type="file"> visible ---
file_input = driver.find_element(By.XPATH, "//input[@type='file']")
file_input.send_keys(r"C:\Users\user\Documents\test.pdf")

# --- Upload multiple files at once ---
file_input.send_keys(r"C:\files\file1.pdf" + "\n" + r"C:\files\file2.pdf")

# --- Hidden file input — make visible with JS first ---
hidden_input = driver.find_element(By.XPATH, "//input[@type='file']")
driver.execute_script("arguments[0].style.display='block';", hidden_input)
hidden_input.send_keys(r"C:\Users\user\Documents\test.pdf")

# --- Verify upload worked — check input value or success message ---
uploaded_value = file_input.get_attribute("value")
print("Uploaded:", uploaded_value)  # prints the filename

wait.until(EC.visibility_of_element_located(
    (By.XPATH, "//*[contains(text(),'Upload successful')]")
))

# ================================================================
# FILE DOWNLOAD
# ================================================================
# Chrome is already configured to auto-download to download_dir (top of file)
# prefs["download.default_directory"] = download_dir
# prefs["download.prompt_for_download"] = False  ← no save dialog

# --- Click the download link/button ---
driver.find_element(By.XPATH, "//a[contains(text(),'Download')]").click()

# --- Wait for file to appear in download directory ---
import glob

def wait_for_download(folder, extension="*", timeout=30):
    end_time = time.time() + timeout
    while time.time() < end_time:
        files = glob.glob(os.path.join(folder, f"*.{extension}"))
        # .crdownload = Chrome partial download still in progress
        completed = [f for f in files if not f.endswith(".crdownload")]
        if completed:
            print("Downloaded:", completed[-1])
            return completed[-1]
        time.sleep(1)
    raise AssertionError("Download did not complete within timeout")

downloaded_file = wait_for_download(download_dir, extension="pdf")
print("File downloaded at:", downloaded_file)

# --- Verify file size > 0 (not empty/corrupted) ---
file_size = os.path.getsize(downloaded_file)
assert file_size > 0, "Downloaded file is empty"
print("File size:", file_size, "bytes")