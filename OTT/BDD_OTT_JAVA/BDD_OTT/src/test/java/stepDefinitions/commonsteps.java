package stepDefinitions;

import Page_object.LoginPage;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;


public class commonsteps {
	public TestContextsetups Testcontextsetups;
	 LoginPage loginpages;
	
	
	public commonsteps(TestContextsetups testcontext) {
		this.Testcontextsetups=testcontext;
		loginpages=Testcontextsetups.pageobjectmanager.loginpage();
		
	}
	
	@Given("user launches the JioHotstar application")
	public void user_launches_the_application() {
	    // Write code here that turns the phrase above into concrete actions
	   loginpages.logo_home_page();
	   
	}

	@And("user navigates to the home page")
	public void user_navigates_to_the_home_page() {
	    // Write code here that turns the phrase above into concrete actions
	   loginpages.logo_home_page();
	}

}
