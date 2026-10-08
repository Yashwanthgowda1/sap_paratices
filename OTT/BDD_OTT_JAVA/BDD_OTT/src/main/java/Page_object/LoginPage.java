package Page_object;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.testng.Assert;

public class LoginPage {
	public WebDriver driver;
//	losing coupling by dependce ijuction
	
	private By  logo_home_page=By.xpath("//img[@alt=\"JioHotstar\"]");
	private By  Home_page_option=By.cssSelector("[class*=\"icon-home\"]");
	private By  search_option_main=By.cssSelector("i[class*='icon-search']");
	private By sports_option=By.xpath("//i[contains(@class,\"icon-sports\")]");
	private By catogory_option=By.xpath("//i[contains(@class,\"icon-category\")]");
	
	public LoginPage(WebDriver driver) {
		this.driver=driver;
	}
	
	public void logo_home_page() {
		boolean flag=driver.findElement(logo_home_page).isDisplayed();
		if(!flag) {
			Assert.assertFalse(flag);
		}
		
	}
	public void Home_page_option() {
		boolean flag=driver.findElement(Home_page_option).isDisplayed();
		if(!flag) {
			Assert.assertFalse(flag);
		}
	}
	public void search_option_main() {
		boolean flag=driver.findElement(search_option_main).isDisplayed();
		if(!flag) {
			Assert.assertFalse(flag);
		}
	}
	public void sports_option() {
		boolean flag=driver.findElement(sports_option).isDisplayed();
		if(!flag) {
			Assert.assertFalse(flag);
		}
	}
	public void catogory_option() {
		WebElement flag=driver.findElement(catogory_option);
		if(!flag.isDisplayed()) {
			Assert.assertFalse(false);
		}
		
		
	}
	public void click_on_catagory() {
		WebElement flag=driver.findElement(catogory_option);
		flag.click();
		
		
	}
	
	
	
	
	

}
