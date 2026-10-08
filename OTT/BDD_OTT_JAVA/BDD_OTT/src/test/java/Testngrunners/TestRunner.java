package Testngrunners;


import org.testng.annotations.DataProvider;

import io.cucumber.testng.AbstractTestNGCucumberTests;
import io.cucumber.testng.CucumberOptions;


@CucumberOptions(
        features = "src/test/java/feature",
        glue = "stepDefinitions",
        monochrome = true,
        plugin = {
//                "pretty",
//                "html:target/cucumber-report.html",
//                "json:target/cucumber.json",
                "com.aventstack.extentreports.cucumber.adapter.ExtentCucumberAdapter:",
//                "io.qameta.allure.cucumber7jvm.AllureCucumber7Jvm"
        }
)

public class TestRunner extends AbstractTestNGCucumberTests {
//how to make the test run in cucumber testngrunner 
//we call the testng scenrious and prive parell =true
    @Override
    @DataProvider(parallel = true)
    public Object[][] scenarios() {
        return super.scenarios();
    }

}
