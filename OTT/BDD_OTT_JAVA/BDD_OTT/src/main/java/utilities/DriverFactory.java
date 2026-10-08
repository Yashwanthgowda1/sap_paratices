package utilities;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;

public class DriverFactory {
	
	private WebDriver driver;
//in feature need to pas the the paremeter reading from resource file browser type
	public WebDriver getDriver() {
		String choice_driver="chrome";
		if(driver==null) {
			switch (choice_driver) {

		    case "chrome":
		        ChromeOptions options = new ChromeOptions();
		        options.addArguments("--disable-notifications");
		        options.addArguments("--start-maximized");
		        driver = new ChromeDriver(options);
		        driver.get("https://www.hotstar.com/");
		        break;
		}
		

			
		}
		return driver;
	}
	
	 public void quitDriver() {
	        try {
	            if (driver != null) {
	                driver.quit();
	                driver = null;
	                System.out.println("Browser quit successfully");
	            }
	        } catch (Exception e) {
	            System.out.println("Exception while quitting browser: " + e.getMessage());
	        }
	    }
	
		
		
		
		
		  
		
	}


