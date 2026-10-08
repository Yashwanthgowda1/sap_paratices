package utilities;

import org.openqa.selenium.Alert;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.Point;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
//import org.openqa.selenium.interactions.Action;
import org.openqa.selenium.interactions.Actions;
import org.testng.Assert;

//import utilities.DriverFactory;

public class genaricutilty  {
	private Actions actions;
	private  JavascriptExecutor js;
	private WebDriver driver;
	private Alert alert;
	
	public genaricutilty(WebDriver driver) {
	
		this.driver=driver;
	}
	
	
	public void Actionclass(WebElement elemnt, String perform, int offset) {
	
		if(elemnt!=null && !perform.isEmpty()) {
			switch(perform.toLowerCase()) {
			case "mousehover": actions=new Actions(driver);
								actions.moveToElement(elemnt);
			
								break;
			case "mouseoffset": actions=new Actions(driver);
								Point  values=elemnt.getLocation();	
								int offset_move=offset!=0? offset : 0;
								actions.moveByOffset(values.getX()+offset_move, values.getY()+offset_move);
								break;
								
			
			}
		}
	}
	public void scroll_elemnt_reference( WebElement elemnt) {
		js=(JavascriptExecutor)driver;
		js.executeScript("arguments[0].scrollIntoView(true)", elemnt);
		if(!elemnt.isDisplayed()) {
			Assert.assertFalse(false);		
		}
		
	}
	public void handelAlertpops( String elemnt, String data) {
		alert = driver.switchTo().alert();

		switch (elemnt) {
		case "ok":
			alert.accept();
			break;
		case "cancel":
			alert.dismiss();
			break;
		case "sendkey":
			alert.sendKeys(data);
			break;
		case "gettext":
			alert.getText();
			break;
		default:
			System.out.println("another action is not intilized in frame work");

		}

	}

}
