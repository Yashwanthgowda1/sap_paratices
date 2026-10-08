package stepDefinitions;

import java.util.List;

import org.testng.Assert;

import Page_object.LoginPage;
import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.And;

import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;

//the concept called testinjection or sprint boot we can do
//making all the function losslesly coupling
//factory methods 


public class LoginSteps {
	public TestContextsetups Textcontentsetups;

	LoginPage loginpages; 

	public LoginSteps(TestContextsetups Textcontentsetups) {
		this.Textcontentsetups = Textcontentsetups;
		loginpages=Textcontentsetups.pageobjectmanager.loginpage();
	}
	
	
	

	@When("user observes the left side navigation menu")
	public void left_side_navigation_menu() {
		// Write code here that turns the phrase above into concrete actions
		loginpages.logo_home_page();

	}

	@Then("user should see below options")
	public void user_should_see_below_options(DataTable dataTable) {
		List<String> datatable = dataTable.asList(String.class);
		for (String str : datatable) {
			if (str.toLowerCase().equals("home")) {
				loginpages.Home_page_option();
			} else if (str.toLowerCase().equals("search")) {
				loginpages.search_option_main();

			} else if (str.toLowerCase().equals("sports")) {
				loginpages.sports_option();
			} else {
				loginpages.catogory_option();
			}
		}

	}


}
