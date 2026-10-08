import requests

BASE_URL = "https://restful-booker.herokuapp.com"

# ================================================================
# 1. GET TOKEN (POST /auth)
# ================================================================
auth_response = requests.post(
    f"{BASE_URL}/auth",
    json={"username": "admin", "password": "password123"}
)
assert auth_response.status_code == 200, f"Auth failed: {auth_response.status_code}"
token = auth_response.json()["token"]
print("Token:", token)

# Token goes in Cookie header for update/delete operations
auth_headers = {
    "Content-Type": "application/json",
    "Cookie": f"token={token}"
}

# ================================================================
# 2. GET ALL BOOKINGS (GET /booking) — no token needed
# ================================================================
get_all = requests.get(f"{BASE_URL}/booking")
assert get_all.status_code == 200
print("All bookings:", get_all.json())

# ================================================================
# 3. GET SINGLE BOOKING (GET /booking/{id}) — no token needed
# ================================================================
booking_id = get_all.json()[0]["bookingid"]
get_one = requests.get(f"{BASE_URL}/booking/{booking_id}")
assert get_one.status_code == 200
print("Single booking:", get_one.json())

# ================================================================
# 4. CREATE BOOKING (POST /booking) — no token needed
#    use json= because body is JSON
# ================================================================
create_response = requests.post(
    f"{BASE_URL}/booking",
    json={
        "firstname": "John",
        "lastname": "Doe",
        "totalprice": 100,
        "depositpaid": True,
        "bookingdates": {
            "checkin": "2025-01-01",
            "checkout": "2025-01-05"
        },
        "additionalneeds": "Breakfast"
    }
)
assert create_response.status_code == 200
new_id = create_response.json()["bookingid"]
print("Created booking ID:", new_id)

# ================================================================
# 5. UPDATE FULL BOOKING (PUT /booking/{id}) — TOKEN REQUIRED
#    use json= for body, auth_headers has token in Cookie
# ================================================================
update_response = requests.put(
    f"{BASE_URL}/booking/{new_id}",
    json={
        "firstname": "Jane",
        "lastname": "Smith",
      
    },
    headers=auth_headers
)
assert update_response.status_code == 200
print("Updated:", update_response.json())

# ================================================================
# 6. PARTIAL UPDATE (PATCH /booking/{id}) — TOKEN REQUIRED
#    update only specific fields
# ================================================================
patch_response = requests.patch(
    f"{BASE_URL}/booking/{new_id}",
    json={"firstname": "UpdatedName"},
    headers=auth_headers
)
assert patch_response.status_code == 200
print("Patched:", patch_response.json())

# ================================================================
# 7. DELETE BOOKING (DELETE /booking/{id}) — TOKEN REQUIRED
#    no body needed for delete
# ================================================================
delete_response = requests.delete(
    f"{BASE_URL}/booking/{new_id}",
    headers=auth_headers
)
assert delete_response.status_code == 201
print("Deleted booking:", new_id)




# in play wright the majore diffrmce is  data : 

# // tests/booking.spec.ts
# import { test, expect } from '@playwright/test';

# const BASE_URL = 'https://restful-booker.herokuapp.com';

# test('Full booking API flow', async ({ request }) => {

#   // ================================================================
#   // 1. GET TOKEN (POST /auth)
#   // ================================================================
#   const authRes = await request.post(`${BASE_URL}/auth`, {
#     data: { username: 'admin', password: 'password123' }
#   });
#   expect(authRes.status()).toBe(200);
#   const { token } = await authRes.json();
#   console.log('Token:', token);

#   const authHeaders = {
#     'Content-Type': 'application/json',
#     'Cookie': `token=${token}`
#   };

#   // ================================================================
#   // 2. GET ALL BOOKINGS (GET /booking)
#   // ================================================================
#   const getAllRes = await request.get(`${BASE_URL}/booking`);
#   expect(getAllRes.status()).toBe(200);
#   const allBookings = await getAllRes.json();
#   console.log('All bookings:', allBookings);

#   // ================================================================
#   // 3. GET SINGLE BOOKING (GET /booking/{id})
#   // ================================================================
#   const bookingId = allBookings[0].bookingid;
#   const getOneRes = await request.get(`${BASE_URL}/booking/${bookingId}`);
#   expect(getOneRes.status()).toBe(200);
#   console.log('Single booking:', await getOneRes.json());

#   // ================================================================
#   // 4. CREATE BOOKING (POST /booking)
#   // ================================================================
#   const createRes = await request.post(`${BASE_URL}/booking`, {
#     data: {
#       firstname: 'John',
#       lastname: 'Doe',
#       totalprice: 100,
#       depositpaid: true,
#       bookingdates: {
#         checkin: '2025-01-01',
#         checkout: '2025-01-05'
#       },
#       additionalneeds: 'Breakfast'
#     }
#   });
#   expect(createRes.status()).toBe(200);
#   const newId = (await createRes.json()).bookingid;
#   console.log('Created booking ID:', newId);

#   // ================================================================
#   // 5. UPDATE FULL BOOKING (PUT /booking/{id}) — TOKEN REQUIRED
#   //    Must send ALL fields — PUT replaces the entire record
#   // ================================================================
#   const existing = await (await request.get(`${BASE_URL}/booking/${newId}`)).json();
#   const putRes = await request.put(`${BASE_URL}/booking/${newId}`, {
#     headers: authHeaders,
#     data: {
#       ...existing,           // spread all existing fields first
#       firstname: 'Jane',     // then override only what you want to change
#       lastname: 'Smith'
#     }
#   });
#   expect(putRes.status()).toBe(200);
#   console.log('Updated:', await putRes.json());

#   // ================================================================
#   // 6. PARTIAL UPDATE (PATCH /booking/{id}) — TOKEN REQUIRED
#   // ================================================================
#   const patchRes = await request.patch(`${BASE_URL}/booking/${newId}`, {
#     headers: authHeaders,
#     data: { firstname: 'UpdatedName' }
#   });
#   expect(patchRes.status()).toBe(200);
#   console.log('Patched:', await patchRes.json());

#   // ================================================================
#   // 7. DELETE BOOKING (DELETE /booking/{id}) — TOKEN REQUIRED
#   // ================================================================
#   const deleteRes = await request.delete(`${BASE_URL}/booking/${newId}`, {
#     headers: authHeaders
#   });
#   expect(deleteRes.status()).toBe(201);
#   console.log('Deleted booking:', newId);
# });



// BookingApiTest.java
import io.restassured.RestAssured;
import io.restassured.response.Response;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import java.util.HashMap;
import java.util.Map;

import static io.restassured.RestAssured.*;
import static org.hamcrest.Matchers.*;

public class BookingApiTest {

    static String BASE_URL = "https://restful-booker.herokuapp.com";
    static String token;
    static int newId;

    @BeforeAll
    static void setup() {
        RestAssured.baseURI = BASE_URL;
    }

    @Test
    void fullBookingFlow() {

        // ================================================================
        // 1. GET TOKEN (POST /auth)
        // ================================================================
        token = given()
            .contentType("application/json")
            .body(Map.of("username", "admin", "password", "password123"))
        .when()
            .post("/auth")
        .then()
            .statusCode(200)
            .extract().path("token");

        System.out.println("Token: " + token);

        // ================================================================
        // 2. GET ALL BOOKINGS (GET /booking)
        // ================================================================
        Response getAllRes = given()
        .when()
            .get("/booking")
        .then()
            .statusCode(200)
            .extract().response();

        System.out.println("All bookings: " + getAllRes.asString());

        // ================================================================
        // 3. GET SINGLE BOOKING (GET /booking/{id})
        // ================================================================
        int bookingId = getAllRes.jsonPath().getInt("[0].bookingid");

        given()
        .when()
            .get("/booking/" + bookingId)
        .then()
            .statusCode(200)
            .body("firstname", notNullValue());

        System.out.println("Single booking ID: " + bookingId);

        // ================================================================
        // 4. CREATE BOOKING (POST /booking)
        // ================================================================
        Map<String, Object> bookingDates = Map.of(
            "checkin", "2025-01-01",
            "checkout", "2025-01-05"
        );

        Map<String, Object> createBody = new HashMap<>();
        createBody.put("firstname", "John");
        createBody.put("lastname", "Doe");
        createBody.put("totalprice", 100);
        createBody.put("depositpaid", true);
        createBody.put("bookingdates", bookingDates);
        createBody.put("additionalneeds", "Breakfast");

        newId = given()
            .contentType("application/json")
            .body(createBody)
        .when()
            .post("/booking")
        .then()
            .statusCode(200)
            .extract().path("bookingid");

        System.out.println("Created booking ID: " + newId);

        // ================================================================
        // 5. UPDATE FULL BOOKING (PUT /booking/{id}) — TOKEN REQUIRED
        //    Must send ALL fields — PUT replaces entire record
        // ================================================================
        Map<String, Object> putBody = new HashMap<>();
        putBody.put("firstname", "Jane");
        putBody.put("lastname", "Smith");
        putBody.put("totalprice", 200);
        putBody.put("depositpaid", true);
        putBody.put("bookingdates", bookingDates);
        putBody.put("additionalneeds", "Lunch");

        given()
            .contentType("application/json")
            .cookie("token", token)
            .header("Authorization", "Bearer " + token) 
            .body(putBody)
        .when()
            .put("/booking/" + newId)
        .then()
            .statusCode(200)
            .body("firstname", equalTo("Jane"))
            .body("lastname", equalTo("Smith"));

        System.out.println("Updated booking: " + newId);

        // ================================================================
        // 6. PARTIAL UPDATE (PATCH /booking/{id}) — TOKEN REQUIRED
        // ================================================================
        given()
            .contentType("application/json")
            .cookie("token", token)
            .body(Map.of("firstname", "UpdatedName"))
        .when()
            .patch("/booking/" + newId)
        .then()
            .statusCode(200)
            .body("firstname", equalTo("UpdatedName"));

        System.out.println("Patched booking: " + newId);

        // ================================================================
        // 7. DELETE BOOKING (DELETE /booking/{id}) — TOKEN REQUIRED
        // ================================================================
        given()
            .cookie("token", token)
        .when()
            .delete("/booking/" + newId)
        .then()
            .statusCode(201);

        System.out.println("Deleted booking: " + newId);
    }
}

# sigle file uplaod in python
# Single file upload
with open("test.pdf", "rb") as f:
    response = requests.post(
        f"{BASE_URL}/upload",
        files={"file": f},
        headers={"Cookie": f"token={token}"}
    )

# With extra form fields alongside file
with open("test.pdf", "rb") as f:
    response = requests.post(
        f"{BASE_URL}/upload",
        files={"file": ("test.pdf", f, "application/pdf")},
        data={"name": "myfile", "category": "docs"}  # extra fields
    )

files = [
    ("files", ("doc1.pdf",  open("doc1.pdf",  "rb"), "application/pdf")),
    ("files", ("photo.png", open("photo.png", "rb"), "image/png")),
    ("files", ("data.csv",  open("data.csv",  "rb"), "text/csv")),
]
response = requests.post(f"{BASE_URL}/upload/multiple", files=files)


# playwright
import { readFileSync } from 'fs';

const response = await request.post(`${BASE_URL}/upload`, {
    headers: { 'Cookie': `token=${token}` },
    multipart: {
        file: {
            name: 'test.pdf',
            mimeType: 'application/pdf',
            buffer: readFileSync('test.pdf')
        },
        name: 'myfile',       // extra field
        category: 'docs'
    }
});



const response = await request.post(`${BASE_URL}/upload/multiple`, {
    multipart: {
        'files[0]': {
            name: 'doc1.pdf',
            mimeType: 'application/pdf',
            buffer: readFileSync('doc1.pdf')
        },
        'files[1]': {
            name: 'photo.png',
            mimeType: 'image/png',
            buffer: readFileSync('photo.png')
        },
        'files[2]': {
            name: 'data.csv',
            mimeType: 'text/csv',
            buffer: readFileSync('data.csv')
        }
    }
});


# rest assured
given()
    .cookie("token", token)
    .contentType("multipart/form-data")
    .multiPart("file", new File("src/test/resources/test.pdf"), "application/pdf")
    .multiPart("name", "myfile")        // extra field
    .multiPart("category", "docs")
.when()
    .post("/upload")
.then()
    .statusCode(200);



given()
    .contentType("multipart/form-data")
    .multiPart("files", new File("doc1.pdf"),  "application/pdf")
    .multiPart("files", new File("photo.png"), "image/png")
    .multiPart("files", new File("data.csv"),  "text/csv")
.when()
    .post("/upload/multiple")
.then()
    .statusCode(200);


# ================================================================
# PATH PARAMS & QUERY PARAMS — ALL LANGUAGES
# ================================================================

# ---------------------------------------------------------------
# PYTHON (requests)
# ---------------------------------------------------------------

# PATH PARAM — embed directly in the URL f-string
# GET /booking/123
booking_id = 123
response = requests.get(f"{BASE_URL}/booking/{booking_id}")

# QUERY PARAMS — pass a dict to params= (requests auto-encodes)
# GET /booking?firstname=John&lastname=Doe
response = requests.get(
    f"{BASE_URL}/booking",
    params={"firstname": "John", "lastname": "Doe"}
)
print(response.url)   # shows full built URL with query string

# PATH + QUERY together
# GET /booking/123/details?format=json&lang=en
response = requests.get(
    f"{BASE_URL}/booking/{booking_id}/details",
    params={"format": "json", "lang": "en"}
)

# MULTI-VALUE query param (same key, two values)
# GET /booking?status=confirmed&status=pending
response = requests.get(
    f"{BASE_URL}/booking",
    params=[("status", "confirmed"), ("status", "pending")]
)


# ---------------------------------------------------------------
# PLAYWRIGHT TYPESCRIPT
# ---------------------------------------------------------------

# # PATH PARAM — embed in template literal
# const bookingId = 123;
# const res = await request.get(`${BASE_URL}/booking/${bookingId}`);

# # QUERY PARAMS — pass params: {} option
# // GET /booking?firstname=John&lastname=Doe
# const res = await request.get(`${BASE_URL}/booking`, {
#   params: { firstname: 'John', lastname: 'Doe' }
# });

# # PATH + QUERY together
# const res = await request.get(`${BASE_URL}/booking/${bookingId}/details`, {
#   params: { format: 'json', lang: 'en' }
# });

# # MULTI-VALUE — use URL API, append same key twice
# const url = new URL(`${BASE_URL}/booking`);
# ['confirmed', 'pending'].forEach(v => url.searchParams.append('status', v));
# const res = await request.get(url.toString());


# ---------------------------------------------------------------
# REST ASSURED (Java)
# ---------------------------------------------------------------

# // PATH PARAM — embed in string directly
# given().when().get("/booking/" + bookingId).then().statusCode(200);

# // PATH PARAM as named placeholder — .pathParam(name, value)
# given()
#     .pathParam("id", 123)
# .when()
#     .get("/booking/{id}")           // {id} replaced by 123
# .then()
#     .statusCode(200);

# // QUERY PARAMS — .queryParam(key, value)
# given()
#     .queryParam("firstname", "John")
#     .queryParam("lastname", "Doe")
# .when()
#     .get("/booking")
# .then()
#     .statusCode(200);

# // PATH + QUERY together
# given()
#     .pathParam("id", bookingId)
#     .queryParam("format", "json")
#     .queryParam("lang", "en")
# .when()
#     .get("/booking/{id}/details")
# .then()
#     .statusCode(200);

# // MULTI-VALUE query param — pass extra values after the key
# given()
#     .queryParam("status", "confirmed", "pending")
# .when()
#     .get("/booking")
# .then()
#     .statusCode(200);

