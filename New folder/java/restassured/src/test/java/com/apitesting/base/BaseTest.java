package com.apitesting.base;

import io.restassured.RestAssured;
import io.restassured.builder.RequestSpecBuilder;
import io.restassured.builder.ResponseSpecBuilder;
import io.restassured.filter.log.LogDetail;
import io.restassured.http.ContentType;
import io.restassured.specification.RequestSpecification;
import io.restassured.specification.ResponseSpecification;
import org.testng.annotations.BeforeClass;

import static org.hamcrest.Matchers.lessThan;

/**
 * INTERVIEW CONCEPT: BaseTest centralizes all common setup.
 * Every test class extends this — avoids repeating base URI, headers, logging.
 *
 * API under test: https://restful-booker.herokuapp.com
 * Docs:           https://restful-booker.herokuapp.com/apidoc/
 */
public class BaseTest {

    protected static RequestSpecification requestSpec;
    protected static ResponseSpecification responseSpec;

    @BeforeClass
    public void setup() {
        // ── Global default: applies to EVERY request when you use RestAssured.given()
        RestAssured.baseURI = "https://restful-booker.herokuapp.com";
        RestAssured.enableLoggingOfRequestAndResponseIfValidationFails();

        // ── RequestSpecBuilder: reusable request defaults (headers, content-type, logging)
        requestSpec = new RequestSpecBuilder()
                .setBaseUri("https://restful-booker.herokuapp.com")
                .setContentType(ContentType.JSON)
                .setAccept(ContentType.JSON)
                .addHeader("Accept", "application/json")
                .log(LogDetail.ALL)          // log request details
                .build();

        // ── ResponseSpecBuilder: common response assertions applied to every response
        responseSpec = new ResponseSpecBuilder()
                .expectResponseTime(lessThan(5000L))   // all APIs must respond < 5 sec
                .log(LogDetail.ALL)                    // log response details
                .build();
    }
}
