package stepDefinitions;


import org.testng.Assert;

import Page_object.Catogory;
import Page_object.LoginPage;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;

public class Catagorysetp {
	
	public TestContextsetups Textcontextsetup;
	public  Catogory Catagory_page;
	public LoginPage loginpage;
	public Catagorysetp(TestContextsetups textcontent) {
		this.Textcontextsetup=textcontent;
		Catagory_page=Textcontextsetup.pageobjectmanager.categorypage();
		loginpage=Textcontextsetup.pageobjectmanager.loginpage();
	}
	
	

	@And("^user navigate to (.+)$")
	public void user_navigate_to(String string) throws InterruptedException {
		String title_before_click = Textcontextsetup.driver.getTitle();
		loginpage.click_on_catagory();
		String title_after_click = Textcontextsetup.driver.getTitle();
		Assert.assertEquals(title_after_click, title_before_click);
		System.out.println("the eement has clicked on the catagory");
		Thread.sleep(1000);
		
		
		
		
		
	}
	@Then("^select (.+)$")
	public void select_options_in_catagory(String option) throws InterruptedException {
		Catagory_page.verify_options_in_catagory();
		Catagory_page.select_option_in_catagory(option);
		
	}
	
	
	
	@Then("^verfy the option (.+) avilable$")
	public void option_avilable(String language) {
		Catagory_page.click_choice_language(language);
		
	
	   
	}

	@Then("^selected option (.+) is opened$")
	public void select_required_language(String lang) {
		Catagory_page.verify_selected_language_opened(lang);
	}

}
