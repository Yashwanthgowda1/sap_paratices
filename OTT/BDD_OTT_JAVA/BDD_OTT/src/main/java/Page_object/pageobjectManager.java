package Page_object;

import org.openqa.selenium.WebDriver;

import utilities.genaricutilty;

public class pageobjectManager {

    WebDriver driver;

    LoginPage loginpage;
    Catogory categorypage;
 

    public pageobjectManager(WebDriver driver) {

        this.driver = driver;
  
        

    }

    public LoginPage loginpage() {

        if (loginpage == null) {

            loginpage = new LoginPage(driver);

        }

        return loginpage;

    }

    public Catogory categorypage() {

        if (categorypage == null) {

            categorypage = new Catogory(driver);

        }

        return categorypage;

    

}
}
