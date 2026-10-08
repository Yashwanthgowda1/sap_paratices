package hooks;

import java.io.IOException;

import org.openqa.selenium.WebDriver;


import io.cucumber.java.After;
import io.cucumber.java.AfterStep;
import io.cucumber.java.Before;
import io.cucumber.java.Scenario;

import com.aventstack.extentreports.MediaEntityBuilder;

import utilities.DriverFactory;
import utilities.ExtentManager;
import utilities.ScreenshotUtil;

public class Hooks extends ScreenshotUtil {
private WebDriver driver;

    @Before
    public void launch_browser() {
     DriverFactory drivers=new DriverFactory();
    		 driver=drivers.getDriver();
        System.out.println("Browser launched");
    }

    @AfterStep
    public void afterEachStep(Scenario scenario) throws IOException {
        if (scenario.isFailed()) {
            String path = ScreenshotUtil.getscreenshot(driver, scenario);
            ExtentManager.getTest().fail("Step Failed",
                    MediaEntityBuilder.createScreenCaptureFromPath(path).build());
        }
    }

    @After
    public void close_browser() {
        if (driver != null) {
            driver.quit();
            driver = null;
            System.out.println("Browser quit successfully");
        }
    }
}
