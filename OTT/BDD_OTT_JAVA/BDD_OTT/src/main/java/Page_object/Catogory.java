package Page_object;

import java.util.List;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.testng.Assert;

import utilities.genaricutilty;

public class Catogory {
	WebDriver driver;
	genaricutilty utility;

private	String language_selections = "//div[contains(@class,'_1K_nduHspHzl7lSOnX3Q5m')]/descendant::a[contains(@aria-label,'%s,LANGUAGE')]";

private	By catogory_option = By.cssSelector("[class*=\"TITLE1 ON_SURFACE_DEFAULT\"]");
private	By lanuage_slected_opened = By.xpath("//*[contains(@class,'1zc788KtPN0EmaoSx7RUA_')]");
private By  scroll_window_in_catogory=By.cssSelector("div[class*='_1YdYQGsQhvyNNgqKkJ']");
private By  option_required_select=By.cssSelector("[class*='_1zc788KtPN0EmaoSx7RUA_']");
private By   side_nav_bar_opened=By.xpath("//p[text()='Categories']");
	
	public Catogory(WebDriver driver) {
		this.driver = driver;
		utility=new genaricutilty(driver);
		

	}

	public String language_selection(String language) {

	    // Remove quotes if they come from feature file
	    language = language.replace("\"", "").strip();

	    System.out.println("the string which is getting -----------> " + language);

	    // Replace placeholder in xpath
	    String language_chosen = String.format(language_selections, language);

	    return language_chosen;
	}

	public  void click_choice_language(String option) {
		String crt_xpath = language_selection(option);
		WebElement lanugae_need_toview = driver.findElement(By.xpath(crt_xpath));
		if(lanugae_need_toview.getText().equals(option)) {
		lanugae_need_toview.click();
		}

	}

	public void verify_options_in_catagory() throws InterruptedException {
		System.out.println("the no side nav bar is appear");
		Thread.sleep(1000);
		WebElement elemnt=driver.findElement(side_nav_bar_opened);
		if(elemnt.isDisplayed()) {
			System.out.println("the side nav bar is removed by offset");
//			click side or do  mose over outside or move the mouse outside
			utility.Actionclass( elemnt, "mouseoffset", 100);
			
		}
		
		
		System.out.println("the clicking offeset --------------------------------------------------------");
		List<WebElement> options = driver.findElements(catogory_option);
		for (WebElement option : options) {
			System.out.println("the option are " + option.getText());
		}
		
	}
	
	
	
	public void select_option_in_catagory(String option) {
		List<WebElement> scroll_window_elents=driver.findElements(option_required_select);
		for(WebElement element : scroll_window_elents) {

		    if(element.getText().equalsIgnoreCase(option)) {
		    	while(!element.isDisplayed()) {
		    		utility.scroll_elemnt_reference(element);
		    	}
		        element.click();
		        
		        return;
		    }
		}
		
		
	}

	public void verify_selected_language_opened(String lnaugage) {
		String text = driver.findElement(lanuage_slected_opened).getText();
		if(lnaugage.toLowerCase().contains(text.toLowerCase())) {
		System.out.println("THE selected language is present and opend");

	}
	

//public String language_selection(String lanuguage) {
//	String language_chosen=language_selections.replace("English", lanuguage);
//	return language_chosen;
//	
//	
//}


	}
	
}
