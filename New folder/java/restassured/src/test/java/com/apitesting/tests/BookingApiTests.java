package com.apitesting.tests;

import com.apitesting.base.BaseTest;
import com.apitesting.models.AuthRequest;
import com.apitesting.models.Booking;
import com.apitesting.models.BookingDates;
import io.restassured.path.json.JsonPath;
import io.restassured.response.Response;
import org.testng.Assert;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.DataProvider;
import org.testng.annotations.Test;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static io.restassured.RestAssured.given;
import static io.restassured.module.jsv.JsonSchemaValidator.matchesJsonSchemaInClasspath;
import static org.hamcrest.Matchers.*;

/**
 * ============================================================
 *  COMPLETE RESTASSURED INTERVIEW GUIDE
 *  API: https://restful-booker.herokuapp.com
 *  Docs: https://restful-booker.herokuapp.com/apidoc/
 * ============================================================
 *
 *  TOPICS COVERED:
 *  1.  GET all bookings — query params, response validation
 *  2.  GET single booking — path params, JSONPath extraction
 *  3.  POST create booking — POJO body, 200/201 validation
 *  4.  PUT full update — Cookie/Token auth
 *  5.  PATCH partial update
 *  6.  DELETE booking
 *  7.  Token generation (/auth endpoint)
 *  8.  Basic Auth (.auth().basic())
 *  9.  Hamcrest matchers — equalTo, hasItems, greaterThan, etc.
 *  10. JSONPath — extract values from response
 *  11. Response time validation
 *  12. Headers / Content-Type assertions
 *  13. JSON Schema validation
 *  14. RequestSpec / ResponseSpec reuse
 *  15. End-to-end CRUD chaining
 *  16. Data-driven testing — @DataProvider
 *  17. Negative tests — 404, 403
 *  18. Logging — request & response
 *  19. Extract + store values between tests
 *  20. Map / HashMap as request body (no POJO)
 * ============================================================
 */
public class BookingApiTests extends BaseTest {

    // ── Shared state across tests (stored after create / auth) ──
    private static int createdBookingId;
    private static String authToken;

    // ================================================================
    // SCENARIO 1 — TOKEN GENERATION
    // POST /auth  →  returns { "token": "abc123" }
    // INTERVIEW: Always generate token first in @BeforeClass if tests need auth.
    // ================================================================
    @BeforeClass(alwaysRun = true)
    public void generateAuthToken() {
        AuthRequest authRequest = new AuthRequest("admin", "password123");

        authToken = given()
                .spec(requestSpec)
                .body(authRequest)
            .when()
                .post("/auth")
            .then()
                .statusCode(200)
                .body("token", notNullValue())
                .extract().path("token");  // extract the token string

        System.out.println("Auth Token: " + authToken);
    }

    // ================================================================
    // SCENARIO 2 — GET ALL BOOKINGS (no auth needed)
    // GET /booking  →  returns list of bookingids
    // INTERVIEW: Validate status, content-type, list is non-empty
    // ================================================================
    @Test(priority = 1, description = "Get all bookings and validate response structure")
    public void test_getAllBookings() {
        given()
            .spec(requestSpec)
        .when()
            .get("/booking")
        .then()
            .spec(responseSpec)                          // reusable response spec (time < 5s)
            .statusCode(200)                             // assert HTTP status
            .contentType("application/json")             // assert content-type header
            .header("Content-Type", containsString("application/json"))
            .body("$", not(empty()))                     // response body list is not empty
            .body("bookingid", everyItem(greaterThan(0))); // every bookingid > 0
    }

    // ================================================================
    // SCENARIO 3 — GET BOOKINGS WITH QUERY PARAMETERS
    // GET /booking?firstname=Jim&lastname=Brown
    // INTERVIEW: Shows how to pass query params
    // ================================================================
    @Test(priority = 2, description = "Filter bookings by firstname and lastname")
    public void test_getBookingsByName() {
        given()
            .spec(requestSpec)
            .queryParam("firstname", "Jim")
            .queryParam("lastname", "Brown")
        .when()
            .get("/booking")
        .then()
            .statusCode(200)
            .body("size()", greaterThanOrEqualTo(0)); // may be empty — just assert list
    }

    // ================================================================
    // SCENARIO 4 — GET BOOKINGS WITH CHECKIN/CHECKOUT DATE FILTERS
    // GET /booking?checkin=2021-01-01&checkout=2021-12-31
    // INTERVIEW: Demonstrates date-based query params
    // ================================================================
    @Test(priority = 3, description = "Filter bookings by date range")
    public void test_getBookingsByDateRange() {
        given()
            .spec(requestSpec)
            .queryParam("checkin",  "2021-01-01")
            .queryParam("checkout", "2021-12-31")
        .when()
            .get("/booking")
        .then()
            .statusCode(200);
    }

    // ================================================================
    // SCENARIO 5 — CREATE BOOKING USING POJO (POST)
    // POST /booking  →  201/200 + bookingid in response
    // INTERVIEW: POJO → JSON serialization, extract bookingid for later
    // ================================================================
    @Test(priority = 4, description = "Create a new booking using POJO body")
    public void test_createBooking_withPOJO() {
        BookingDates dates   = new BookingDates("2025-01-01", "2025-01-10");
        Booking     newBooking = new Booking(
                "Yashwanth", "Gowda", 500, true, dates, "Breakfast"
        );

        Response response = given()
            .spec(requestSpec)
            .body(newBooking)                 // POJO auto-serialized to JSON by Jackson
        .when()
            .post("/booking")
        .then()
            .statusCode(200)                  // restful-booker returns 200 for POST
            .body("bookingid",  notNullValue())
            .body("booking.firstname",   equalTo("Yashwanth"))
            .body("booking.lastname",    equalTo("Gowda"))
            .body("booking.totalprice",  equalTo(500))
            .body("booking.depositpaid", equalTo(true))
            .body("booking.bookingdates.checkin",  equalTo("2025-01-01"))
            .body("booking.bookingdates.checkout", equalTo("2025-01-10"))
            .body("booking.additionalneeds",       equalTo("Breakfast"))
            .extract().response();

        // Store the bookingId for use in PUT/PATCH/DELETE tests
        createdBookingId = response.path("bookingid");
        System.out.println("Created Booking ID: " + createdBookingId);
    }

    // ================================================================
    // SCENARIO 6 — CREATE BOOKING USING MAP (no POJO)
    // INTERVIEW: Alternative to POJO — use HashMap for quick/inline bodies
    // ================================================================
    @Test(priority = 5, description = "Create booking using HashMap body (no POJO)")
    public void test_createBooking_withHashMap() {
        Map<String, Object> bookingDates = new HashMap<>();
        bookingDates.put("checkin",  "2025-02-01");
        bookingDates.put("checkout", "2025-02-10");

        Map<String, Object> body = new HashMap<>();
        body.put("firstname",       "John");
        body.put("lastname",        "Doe");
        body.put("totalprice",      300);
        body.put("depositpaid",     false);
        body.put("bookingdates",    bookingDates);
        body.put("additionalneeds", "Lunch");

        given()
            .spec(requestSpec)
            .body(body)
        .when()
            .post("/booking")
        .then()
            .statusCode(200)
            .body("bookingid", notNullValue())
            .body("booking.firstname", equalTo("John"));
    }

    // ================================================================
    // SCENARIO 7 — GET SINGLE BOOKING (path param)
    // GET /booking/{id}
    // INTERVIEW: Path param, POJO deserialization, JSONPath extraction
    // ================================================================
    @Test(priority = 6, dependsOnMethods = "test_createBooking_withPOJO",
          description = "Fetch single booking by ID and validate all fields")
    public void test_getBookingById() {
        Response response = given()
            .spec(requestSpec)
            .pathParam("id", createdBookingId)  // path param in URL template
        .when()
            .get("/booking/{id}")
        .then()
            .statusCode(200)
            .body("firstname",   equalTo("Yashwanth"))
            .body("lastname",    equalTo("Gowda"))
            .body("totalprice",  equalTo(500))
            .body("depositpaid", equalTo(true))
            .body("bookingdates.checkin",  notNullValue())
            .body("bookingdates.checkout", notNullValue())
            .extract().response();

        // ── JSONPath: extract individual fields from response ──
        JsonPath jp = response.jsonPath();
        String  firstName  = jp.getString("firstname");
        int     price      = jp.getInt("totalprice");
        boolean deposit    = jp.getBoolean("depositpaid");
        String  checkIn    = jp.getString("bookingdates.checkin");

        System.out.println("Fetched: " + firstName + " | Price: " + price
                            + " | Deposit: " + deposit + " | CheckIn: " + checkIn);

        // TestNG assertions on extracted values
        Assert.assertEquals(firstName, "Yashwanth", "firstname mismatch");
        Assert.assertEquals(price,     500,          "price mismatch");
        Assert.assertTrue(deposit,                   "deposit should be paid");

        // ── Deserialize whole response to POJO ──
        Booking bookingPojo = response.as(Booking.class);
        Assert.assertEquals(bookingPojo.getFirstname(), "Yashwanth");
        Assert.assertNotNull(bookingPojo.getBookingdates());
    }

    // ================================================================
    // SCENARIO 8 — PUT FULL UPDATE (with Cookie token auth)
    // PUT /booking/{id}  — requires Cookie: token=<value>
    // INTERVIEW: Shows how to pass Cookie header for auth
    // ================================================================
    @Test(priority = 7, dependsOnMethods = "test_createBooking_withPOJO",
          description = "Full update of booking with auth token as Cookie")
    public void test_updateBooking_PUT() {
        BookingDates dates      = new BookingDates("2025-03-01", "2025-03-10");
        Booking     updated     = new Booking(
                "UpdatedFirst", "UpdatedLast", 999, false, dates, "Dinner"
        );

        given()
            .spec(requestSpec)
            .cookie("token", authToken)          // INTERVIEW: auth via Cookie header
            .pathParam("id", createdBookingId)
            .body(updated)
        .when()
            .put("/booking/{id}")
        .then()
            .statusCode(200)
            .body("firstname",  equalTo("UpdatedFirst"))
            .body("lastname",   equalTo("UpdatedLast"))
            .body("totalprice", equalTo(999));
    }

    // ================================================================
    // SCENARIO 9 — PUT WITH BASIC AUTH (alternative auth method)
    // INTERVIEW: Shows .auth().preemptive().basic() vs Cookie
    // ================================================================
    @Test(priority = 8, dependsOnMethods = "test_createBooking_withPOJO",
          description = "Full update using Basic Auth instead of token")
    public void test_updateBooking_PUT_basicAuth() {
        BookingDates dates  = new BookingDates("2025-04-01", "2025-04-10");
        Booking     payload = new Booking(
                "BasicAuth", "User", 750, true, dates, "Both"
        );

        given()
            .spec(requestSpec)
            .auth().preemptive().basic("admin", "password123")  // Basic Auth
            .pathParam("id", createdBookingId)
            .body(payload)
        .when()
            .put("/booking/{id}")
        .then()
            .statusCode(200)
            .body("firstname", equalTo("BasicAuth"));
    }

    // ================================================================
    // SCENARIO 10 — PATCH PARTIAL UPDATE
    // PATCH /booking/{id}  — only send fields you want to change
    // INTERVIEW: PATCH vs PUT difference
    // ================================================================
    @Test(priority = 9, dependsOnMethods = "test_createBooking_withPOJO",
          description = "Partial update — only firstname and totalprice changed")
    public void test_partialUpdateBooking_PATCH() {
        Map<String, Object> partialBody = new HashMap<>();
        partialBody.put("firstname",  "PatchedName");
        partialBody.put("totalprice", 1200);

        given()
            .spec(requestSpec)
            .cookie("token", authToken)
            .pathParam("id", createdBookingId)
            .body(partialBody)
        .when()
            .patch("/booking/{id}")
        .then()
            .statusCode(200)
            .body("firstname",  equalTo("PatchedName"))
            .body("totalprice", equalTo(1200));
    }

    // ================================================================
    // SCENARIO 11 — DELETE BOOKING
    // DELETE /booking/{id}  →  201 Created (restful-booker quirk)
    // INTERVIEW: Auth required, assert 201, then confirm 404 on re-fetch
    // ================================================================
    @Test(priority = 10, dependsOnMethods = "test_createBooking_withPOJO",
          description = "Delete booking and verify it no longer exists")
    public void test_deleteBooking() {
        // Step 1: Delete
        given()
            .spec(requestSpec)
            .cookie("token", authToken)
            .pathParam("id", createdBookingId)
        .when()
            .delete("/booking/{id}")
        .then()
            .statusCode(201);  // restful-booker returns 201 for DELETE

        // Step 2: Confirm deletion → expect 404
        given()
            .spec(requestSpec)
            .pathParam("id", createdBookingId)
        .when()
            .get("/booking/{id}")
        .then()
            .statusCode(404);
    }

    // ================================================================
    // SCENARIO 12 — JSON SCHEMA VALIDATION
    // INTERVIEW: Validate response structure matches a schema file
    // Schema file: src/test/resources/booking_schema.json
    // ================================================================
    @Test(priority = 11, description = "Validate GET /booking/{id} response matches JSON schema")
    public void test_jsonSchemaValidation() {
        given()
            .spec(requestSpec)
            .pathParam("id", 1)
        .when()
            .get("/booking/{id}")
        .then()
            .statusCode(200)
            .body(matchesJsonSchemaInClasspath("booking_schema.json"));  // schema on classpath
    }

    // ================================================================
    // SCENARIO 13 — RESPONSE TIME ASSERTION
    // INTERVIEW: API must respond within SLA
    // ================================================================
    @Test(priority = 12, description = "API response time must be under 3 seconds")
    public void test_responseTimeValidation() {
        given()
            .spec(requestSpec)
        .when()
            .get("/booking")
        .then()
            .statusCode(200)
            .time(lessThan(3000L));  // milliseconds
    }

    // ================================================================
    // SCENARIO 14 — HEADER ASSERTIONS
    // INTERVIEW: Verify response headers (server, content-type, etc.)
    // ================================================================
    @Test(priority = 13, description = "Validate response headers")
    public void test_responseHeaderAssertions() {
        given()
            .spec(requestSpec)
        .when()
            .get("/booking")
        .then()
            .statusCode(200)
            .header("Content-Type", containsString("application/json"))
            .header("Connection",   equalTo("keep-alive"))
            .headers("Content-Type", containsString("json"),
                     "Connection",   equalTo("keep-alive")); // multiple headers at once
    }

    // ================================================================
    // SCENARIO 15 — EXTRACT LIST FROM RESPONSE (JSONPath on arrays)
    // INTERVIEW: Get all bookingids, verify count and values
    // ================================================================
    @Test(priority = 14, description = "Extract and assert list of booking IDs from response")
    public void test_extractListFromResponse() {
        Response response = given()
            .spec(requestSpec)
        .when()
            .get("/booking")
        .then()
            .statusCode(200)
            .extract().response();

        // Extract list of all bookingids using JSONPath
        List<Integer> bookingIds = response.jsonPath().getList("bookingid", Integer.class);
        System.out.println("Total bookings: " + bookingIds.size());

        Assert.assertFalse(bookingIds.isEmpty(), "Booking list should not be empty");
        Assert.assertTrue(bookingIds.stream().allMatch(id -> id > 0), "All IDs must be positive");
    }

    // ================================================================
    // SCENARIO 16 — BEARER TOKEN AUTH (how you'd do it with JWT APIs)
    // INTERVIEW: Most real-world APIs use Authorization: Bearer <token>
    // ================================================================
    @Test(priority = 15, description = "Demonstrate Bearer Token authorization header")
    public void test_bearerTokenAuth() {
        String fakeJwt = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.example";

        // restful-booker doesn't use Bearer, but this shows the pattern
        given()
            .spec(requestSpec)
            .header("Authorization", "Bearer " + fakeJwt)
            .pathParam("id", 1)
        .when()
            .get("/booking/{id}")
        .then()
            // Will return 200 or 403 depending on server — pattern is what matters
            .statusCode(anyOf(is(200), is(403)));
    }

    // ================================================================
    // SCENARIO 17 — DATA-DRIVEN TESTING with @DataProvider
    // INTERVIEW: Run same test with multiple inputs (TestNG feature)
    // ================================================================
    @DataProvider(name = "bookingNames")
    public Object[][] bookingNameProvider() {
        return new Object[][] {
            { "Jim",  "Brown"  },
            { "John", "Smith"  },
            { "Mary", "Jones"  },
        };
    }

    @Test(priority = 16, dataProvider = "bookingNames",
          description = "Data-driven: search bookings by different name combos")
    public void test_getBookingByName_datadriven(String firstName, String lastName) {
        given()
            .spec(requestSpec)
            .queryParam("firstname", firstName)
            .queryParam("lastname",  lastName)
        .when()
            .get("/booking")
        .then()
            .statusCode(200)
            .body("size()", greaterThanOrEqualTo(0));

        System.out.println("Searched for: " + firstName + " " + lastName);
    }

    // ================================================================
    // SCENARIO 18 — NEGATIVE TEST: GET non-existent booking → 404
    // INTERVIEW: Always test error cases in addition to happy paths
    // ================================================================
    @Test(priority = 17, description = "Negative test: fetch booking with invalid ID expects 404")
    public void test_getNonExistentBooking_404() {
        given()
            .spec(requestSpec)
            .pathParam("id", 999999)  // ID that doesn't exist
        .when()
            .get("/booking/{id}")
        .then()
            .statusCode(404);
    }

    // ================================================================
    // SCENARIO 19 — NEGATIVE TEST: UPDATE without auth → 403
    // INTERVIEW: Security boundary — no token = forbidden
    // ================================================================
    @Test(priority = 18, description = "Negative test: PUT without auth token expects 403")
    public void test_updateWithoutAuth_403() {
        Map<String, Object> body = new HashMap<>();
        body.put("firstname", "Hacker");

        given()
            .spec(requestSpec)
            .pathParam("id", 1)
            .body(body)           // no .cookie("token", ...) here
        .when()
            .put("/booking/{id}")
        .then()
            .statusCode(403);
    }

    // ================================================================
    // SCENARIO 20 — FULL LOGGING (request + response)
    // INTERVIEW: Use log().all() in requestSpec OR inline for debugging
    // ================================================================
    @Test(priority = 19, description = "Demonstrate logging entire request and response")
    public void test_loggingRequestAndResponse() {
        given()
            .log().all()          // log full request: method, URI, headers, body
            .spec(requestSpec)
        .when()
            .get("/booking")
        .then()
            .log().all()          // log full response: status, headers, body
            .statusCode(200);
    }

    // ================================================================
    // SCENARIO 21 — LOG ONLY ON FAILURE
    // INTERVIEW: Best practice — log only when test fails (less noise)
    // ================================================================
    @Test(priority = 20, description = "Log only if validation fails (best practice)")
    public void test_logOnlyOnFailure() {
        given()
            .log().ifValidationFails()   // request logged only on failure
        .when()
            .get("https://restful-booker.herokuapp.com/booking")
        .then()
            .log().ifValidationFails()   // response logged only on failure
            .statusCode(200);
    }

    // ================================================================
    // SCENARIO 22 — END-TO-END CRUD FLOW (chained test)
    // INTERVIEW: This is the most important scenario — CREATE → READ → UPDATE → DELETE
    // Everything is chained in one test with Assert validations.
    // ================================================================
    @Test(priority = 21, description = "End-to-end CRUD: Create → Read → Update → Delete")
    public void test_endToEnd_CRUD() {

        // ── STEP 1: Generate token ──────────────────────────────────────
        String token = given()
            .spec(requestSpec)
            .body(new AuthRequest("admin", "password123"))
        .when()
            .post("/auth")
        .then()
            .statusCode(200)
            .body("token", notNullValue())
            .extract().path("token");

        Assert.assertNotNull(token, "Token must not be null");
        System.out.println("[E2E] Token: " + token);

        // ── STEP 2: CREATE booking ──────────────────────────────────────
        BookingDates dates   = new BookingDates("2025-06-01", "2025-06-15");
        Booking     payload  = new Booking("E2E_First", "E2E_Last", 800, true, dates, "Spa");

        int bookingId = given()
            .spec(requestSpec)
            .body(payload)
        .when()
            .post("/booking")
        .then()
            .statusCode(200)
            .body("bookingid",         notNullValue())
            .body("booking.firstname", equalTo("E2E_First"))
            .extract().path("bookingid");

        Assert.assertTrue(bookingId > 0, "BookingId must be positive");
        System.out.println("[E2E] Created ID: " + bookingId);

        // ── STEP 3: READ created booking ───────────────────────────────
        Booking fetched = given()
            .spec(requestSpec)
            .pathParam("id", bookingId)
        .when()
            .get("/booking/{id}")
        .then()
            .statusCode(200)
            .body("firstname",  equalTo("E2E_First"))
            .body("totalprice", equalTo(800))
            .extract().as(Booking.class);       // deserialize to POJO

        Assert.assertEquals(fetched.getFirstname(), "E2E_First");
        Assert.assertEquals(fetched.getTotalprice(), 800);

        // ── STEP 4: UPDATE (PATCH) — change price only ─────────────────
        Map<String, Object> patch = new HashMap<>();
        patch.put("totalprice", 1500);
        patch.put("additionalneeds", "Pool + Spa");

        given()
            .spec(requestSpec)
            .cookie("token", token)
            .pathParam("id", bookingId)
            .body(patch)
        .when()
            .patch("/booking/{id}")
        .then()
            .statusCode(200)
            .body("totalprice",      equalTo(1500))
            .body("additionalneeds", equalTo("Pool + Spa"));

        // ── STEP 5: DELETE ─────────────────────────────────────────────
        given()
            .spec(requestSpec)
            .cookie("token", token)
            .pathParam("id", bookingId)
        .when()
            .delete("/booking/{id}")
        .then()
            .statusCode(201);

        // ── STEP 6: Verify deleted (should return 404) ──────────────────
        given()
            .spec(requestSpec)
            .pathParam("id", bookingId)
        .when()
            .get("/booking/{id}")
        .then()
            .statusCode(404);

        System.out.println("[E2E] CRUD flow complete. Booking " + bookingId + " deleted.");
    }

    // ================================================================
    // SCENARIO 23 — HAMCREST MATCHERS REFERENCE
    // INTERVIEW: Know these cold — asked frequently
    // ================================================================
    @Test(priority = 22, description = "Demonstrate all common Hamcrest matchers")
    public void test_hamcrestMatchers_reference() {
        given()
            .spec(requestSpec)
            .pathParam("id", 1)
        .when()
            .get("/booking/{id}")
        .then()
            .statusCode(200)

            // ── String matchers ──
            .body("firstname", notNullValue())                    // not null
            .body("firstname", instanceOf(String.class))          // type check
            .body("firstname", not(emptyString()))                // not blank

            // ── Number matchers ──
            .body("totalprice", greaterThan(0))                   // > 0
            .body("totalprice", lessThanOrEqualTo(100000))        // <= 100000
            .body("totalprice", not(equalTo(0)))                  // not 0

            // ── Boolean ──
            .body("depositpaid", isA(Boolean.class))              // type is boolean

            // ── Nested object ──
            .body("bookingdates",          notNullValue())        // not null
            .body("bookingdates.checkin",  notNullValue())
            .body("bookingdates.checkout", notNullValue())

            // ── String content matchers ──
            .body("bookingdates.checkin", matchesPattern("\\d{4}-\\d{2}-\\d{2}")); // date regex
    }

    // ================================================================
    // SCENARIO 24 — EXTRACT SPECIFIC RESPONSE FIELDS
    // INTERVIEW: Shows extractPath(), extract().response(), jsonPath()
    // ================================================================
    @Test(priority = 23, description = "Different ways to extract values from a response")
    public void test_extractionMethods() {
        // Method 1: extract single value directly
        String firstname = given()
            .spec(requestSpec)
            .pathParam("id", 1)
        .when()
            .get("/booking/{id}")
        .then()
            .statusCode(200)
            .extract().path("firstname");

        System.out.println("Method1 - firstname: " + firstname);

        // Method 2: extract full response object, then use jsonPath
        Response response = given()
            .spec(requestSpec)
            .pathParam("id", 1)
        .when()
            .get("/booking/{id}")
        .then()
            .statusCode(200)
            .extract().response();

        String  lastname  = response.jsonPath().getString("lastname");
        int     price     = response.jsonPath().getInt("totalprice");
        String  checkin   = response.jsonPath().getString("bookingdates.checkin");
        String  bodyStr   = response.getBody().asString();        // raw JSON string
        int     status    = response.getStatusCode();
        String  ct        = response.getHeader("Content-Type");

        System.out.println("lastname="  + lastname);
        System.out.println("price="     + price);
        System.out.println("checkin="   + checkin);
        System.out.println("status="    + status);
        System.out.println("CT header=" + ct);

        // Method 3: deserialize to POJO
        Booking bookingPojo = response.as(Booking.class);
        System.out.println("POJO firstname: " + bookingPojo.getFirstname());
    }

    // ================================================================
    // SCENARIO 25 — HEALTH CHECK (GET /ping)
    // INTERVIEW: Ping endpoint — verify the service is alive (201 response)
    // ================================================================
    @Test(priority = 24, description = "Health check: GET /ping should return 201")
    public void test_healthCheck_ping() {
        given()
            .spec(requestSpec)
        .when()
            .get("/ping")
        .then()
            .statusCode(201);   // restful-booker /ping returns 201 Created
    }
}
