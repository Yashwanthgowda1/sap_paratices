import time

from selenium import webdriver
from  selenium.webdriver.common import  Webdriverwait
from selenium.webdriver.chrome.options import Options
from  selenium.webdriver.common.by import  By

options = Options()

# Correct argument
options.add_argument("--remote-allow-origins=*")
options.add_argument("--start-maximized")

prefs = {
    "profile.default_content_settings.geolocation": 2,
    "profile.default_content_settings.notifications": 2,
    "profile.default_content_settings.media_stream": 2
}
options.add_experimental_option("prefs", prefs)

driver = webdriver.Chrome(options=options)
driver.get("https://www.amazon.in/s?k=laptops&crid=37W91GMKJF9U3&sprefix=laptops%2Caps%2C410&ref=nb_sb_noss_1")

driver.implicitly_wait(10)
listof_locators=driver.find_elements(By.XPATH, "//h2[contains(@class,'a-size-medium a-spacing-none a-color-base a-text-normal')]")


pricing = "/ancestor::div[@data-cy='title-recipe']/following-sibling::div[contains(@class,'puisg-row')]/descendant::span[@class='a-price']/span[@class='a-offscreen']"
with open("file_all_laptops_and_prices.txt", "w+", encoding="utf-8") as f:
    for eachproduct in listof_locators:
        nameof_product = eachproduct.text.strip()

        try:
            # Search for price using driver from root instead of eachproduct
            price_elements = driver.find_elements(By.XPATH, f'//*[contains(text(),"{nameof_product}")]' + pricing)
            prices_text = " / ".join([p.text for p in price_elements]) if price_elements else "Price not found"
        except:
            prices_text = "Price not found"

        # Write to file
        f.write(f"Product: {nameof_product}\nPrice: {prices_text}\n\n")