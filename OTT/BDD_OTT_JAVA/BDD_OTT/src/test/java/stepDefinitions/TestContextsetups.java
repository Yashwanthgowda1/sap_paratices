package stepDefinitions;

import utilities.DriverFactory;

import org.openqa.selenium.WebDriver;


import Page_object.pageobjectManager;

public class TestContextsetups {
//here we mwntion the what are the common property need to share with steps definations
	public pageobjectManager pageobjectmanager;
	public WebDriver driver;
	public DriverFactory driverFactory;
//	public Catogory catogory;
	
	
	
	
	public TestContextsetups() {
		
		driverFactory = new DriverFactory();
		driver = driverFactory.getDriver();
		pageobjectmanager=new pageobjectManager(driver);
		
	}
	
}
