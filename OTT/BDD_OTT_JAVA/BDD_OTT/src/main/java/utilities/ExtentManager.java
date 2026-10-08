package utilities;

import com.aventstack.extentreports.ExtentReports;
import com.aventstack.extentreports.ExtentTest;
import com.aventstack.extentreports.reporter.ExtentSparkReporter;
import com.aventstack.extentreports.reporter.configuration.Theme;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;

public class ExtentManager {
	/***
	 * This code mainly focuing under the report attaching to extentreportadapter
	 * 
	 */

    private static ExtentReports extent;
    private static ThreadLocal<ExtentTest> test = new ThreadLocal<>();

    public static ExtentReports getInstance() {
        if (extent == null) {
            createInstance();
        }
        return extent;
    }

    public static ExtentTest getTest() {
        return test.get();
    }

    public static void setTest(ExtentTest extentTest) {
        test.set(extentTest);
    }

    public static ExtentReports createInstance() {
        String timestamp = new SimpleDateFormat("d-MMM-yy_HH-mm-ss").format(new Date());
        String reportPath = "./test-output/ExtentReport/ExtentReport_" + timestamp + ".html";

        ExtentSparkReporter sparkReporter = new ExtentSparkReporter(reportPath);
        sparkReporter.config().setDocumentTitle("Automation Test Report");
        sparkReporter.config().setReportName("Jio Hotstar Test Report");
        sparkReporter.config().setTheme(Theme.DARK);

        extent = new ExtentReports();
        extent.attachReporter(sparkReporter);

        // Set system information
        extent.setSystemInfo("Environment", "QA");
        extent.setSystemInfo("Browser", "Chrome");
        extent.setSystemInfo("OS", System.getProperty("os.name"));

        return extent;
    }

    public static String captureScreenshot(String screenshotName) {
        try {
            File screenshotDir = new File("test-output/SparkReport/screenshots");
            if (!screenshotDir.exists()) {
                screenshotDir.mkdirs();
            }

            String timestamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
            String fileName = screenshotName.replaceAll("[^a-zA-Z0-9]", "_") + "_" + timestamp + ".png";
            File screenshotFile = new File(screenshotDir, fileName);

            // This method will be called from BaseTest
            return screenshotFile.getAbsolutePath();
        } catch (Exception e) {
            System.out.println("Error creating screenshot path: " + e.getMessage());
            return null;
        }
    }
}