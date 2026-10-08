import time

from  selenium import  webdriver
from  selenium.webdriver.common.by import  By
from  selenium.webdriver.support.ui import  WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from  selenium.webdriver.common.alert import Alert
from  selenium.webdriver.common.action_chains import  ActionChains
from  selenium.common.exceptions import NoSuchElementException, NoSuchAttributeException, StaleElementReferenceException
driver=webdriver.Chrome()
# driver.get("https://the-internet.herokuapp.com/dynamic_loading")
# driver.find_element(By.XPATH, "//a[text()='Example 1: Element on page that is hidden']").click()
# driver.find_element(By.XPATH, "//button[text()='Start']").click()
#
# wait =WebDriverWait(driver, timeout=30, poll_frequency=3,ignored_exceptions=[NoSuchElementException,
#         StaleElementReferenceException])
# elemnt=wait.until(EC.visibility_of_element_located((By.XPATH, "//h4[text()='Hello World!']")))
#
# print("The successful", elemnt.text)
#
# driver.get("https://the-internet.herokuapp.com/drag_and_drop")
# SRC=driver.find_element(By.ID, "column-a")
# DST=driver.find_element(By.ID, "column-b")
# action=ActionChains(driver)
# action.drag_and_drop(SRC, DST).perform()
# time.sleep(10)
#
# driver.get("https://the-internet.herokuapp.com/javascript_alerts")
# driver.find_element(By.XPATH, "//button[text()='Click for JS Alert']").click()
# alert=Alert(driver)
# print(alert.text)
# print(alert.accept())
# time.sleep(5)
# driver.find_element(By.XPATH, "//button[text()='Click for JS Confirm']").click()
# print(alert.text)
# alert.dismiss()
# time.sleep(5)
# driver.find_element(By.XPATH, "//button[text()='Click for JS Prompt']").click()
# print(alert.text)
# alert.send_keys("yahswnath promopt")
#
# alert.accept()
# time.sleep(5)
#
#
#
#
#
#
#
# import  requests
# driver.get("https://the-internet.herokuapp.com/broken_images")
#
# images = driver.find_elements(By.TAG_NAME, "img")
#
# print(f"Total images: {len(images)}")
#
# for img in images:
#     src = img.get_attribute("src")
#
#     if src is None or src == "":
#         print("Image source is missing")
#         continue
#
#     response = requests.get(src)
#
#     if response.status_code != 200:
#         print(f"Broken Image: {src}")
#     else:
#         print(f"Valid Image: {src}")
#
# driver.quit()


driver.get("https://the-internet.herokuapp.com/upload")
file=driver.find_element(By.ID, 'file-upload')
file.send_keys(r"C:\Users\C5403671\Downloads\CertificateOfCompletion_Integrating AI into the Product Architecture.pdf")
driver.find_element(By.ID, 'file-submit').click()
time.sleep(20)



# drop_zone = driver.find_element(By.ID, "drop-area")
# file_input = driver.find_element(By.ID, "fileInput")
#
# driver.execute_script("""
#     arguments[0].style.display = 'block';
# """, file_input)
#
# file_input.send_keys(r"C:\Users\YourName\Documents\testfile.txt")


# file_input = driver.find_element(By.ID, "fileUpload")
#
# driver.execute_script(
#     "arguments[0].removeAttribute('hidden');", file_input
# )
#
# file_input.send_keys(r"C:\Users\YourName\file.txt")



# fiule download

# import time
#download_dir = r"C:\Users\YourName\Downloads\selenium"
# os.makedirs(download_dir, exist_ok=True)
# timeout = 15
# for _ in range(timeout):
#     if os.path.exists(file_path):
#         break
#     time.sleep(1)
#
# assert os.path.exists(file_path), "Download failed"
waot=WebDriverWait(driver, timeout=20, poll_frequency=2, ignored_exceptions=[])
waot.until(EC.visibility_of_element_located((By.XPATH, "")))