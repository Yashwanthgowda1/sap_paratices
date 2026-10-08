package utilities;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.commons.io.FileUtils;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.WebDriver;

import io.cucumber.java.Scenario;

public class ScreenshotUtil {

    public static String getscreenshot(WebDriver driver, Scenario scenario) throws IOException {
        String reportFolder = "test-output/ExtentReport/screenshots";
        File dir = new File(reportFolder);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        String timestamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
        String screenshotName = scenario.getName().replaceAll("[^a-zA-Z0-9]", "_") 
                + "_" + timestamp + ".png";
        String fullPath = reportFolder + "/" + screenshotName;

        try {
            TakesScreenshot ts = (TakesScreenshot) driver;
            File src = ts.getScreenshotAs(OutputType.FILE);
            FileUtils.copyFile(src, new File(fullPath));
            System.out.println("Screenshot saved at: " + fullPath);
        } catch (Exception e) {
            System.out.println("Screenshot capture failed: " + e.getMessage());
        }

        return fullPath; // return path
    }
}
