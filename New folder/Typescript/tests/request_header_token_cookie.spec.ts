import { test, expect, APIRequestContext } from "@playwright/test";

// ==========================================================
// CONCEPT 1: REQUESTS
// HTTP methods tell the server WHAT action to perform
// ==========================================================
// GET    → read/fetch data  (no body)
// POST   → create new data  (has body)
// PUT    → replace full record (has body)
// PATCH  → partial update    (has body)
// DELETE → remove record     (no body usually)
// ==========================================================

test.describe("REQUESTS - HTTP Methods", () => {

  test("GET - Read/Fetch data (no body needed)", async ({ request }) => {
    // GET does NOT send a body — just fetches data from server
    const response = await request.get(
      "https://restful-booker.herokuapp.com/booking/1"
    );

    console.log("Status:", response.status());        // 200 = OK
    const body = await response.json();
    console.log("Response Body:", body);

    expect(response.status()).toBe(200);
  });


  test("POST - Create new data (sends body)", async ({ request }) => {
    // POST sends a JSON body to create something on the server
    const response = await request.post(
      "https://restful-booker.herokuapp.com/booking",
      {
        // 'data' is the request BODY — what you are sending
        data: {
          firstname: "Yash",
          lastname: "Gowda",
          totalprice: 500,
          depositpaid: true,
          bookingdates: {
            checkin: "2025-01-01",
            checkout: "2025-01-10"
          },
          additionalneeds: "Breakfast"
        },
        headers: {
          "Content-Type": "application/json"   // tells server the body is JSON
        }
      }
    );

    console.log("Created:", await response.json());
    expect(response.ok()).toBeTruthy();   // ok() = status 200-299
  });


  test("PUT - Full update (replace entire record)", async ({ request }) => {
    // PUT replaces the WHOLE record — every field must be sent
    const response = await request.put(
      "https://restful-booker.herokuapp.com/booking/1",
      {
        data: {
          firstname: "NewFirst",
          lastname: "NewLast",
          totalprice: 999,
          depositpaid: false,
          bookingdates: {
            checkin: "2025-03-01",
            checkout: "2025-03-05"
          },
          additionalneeds: "Dinner"
        },
        headers: {
          "Content-Type": "application/json",
          "Cookie": "token=abc123"  // needs auth (see TOKEN section below)
        }
      }
    );

    console.log("PUT status:", response.status());
  });


  test("PATCH - Partial update (only changed fields)", async ({ request }) => {
    // PATCH sends only the fields you want to change
    const response = await request.patch(
      "https://restful-booker.herokuapp.com/booking/1",
      {
        data: {
          firstname: "PatchedOnly"   // only updating firstname
        },
        headers: {
          "Content-Type": "application/json",
          "Cookie": "token=abc123"
        }
      }
    );

    console.log("PATCH status:", response.status());
  });


  test("DELETE - Remove record", async ({ request }) => {
    // DELETE removes the record — no body needed usually
    const response = await request.delete(
      "https://restful-booker.herokuapp.com/booking/1",
      {
        headers: {
          "Cookie": "token=abc123"
        }
      }
    );

    console.log("DELETE status:", response.status()); // 201 = deleted
  });

});




// ==========================================================
// CONCEPT 2: HEADERS
// Headers are KEY=VALUE pairs sent with every request
// They carry METADATA about the request (not the actual data)
// ==========================================================
// Common Headers:
//   Content-Type   → what format the REQUEST BODY is in
//   Accept         → what format you WANT the response in
//   Authorization  → sends Bearer token for auth
//   Cookie         → sends cookie for auth (alternate method)
//   Custom headers → anything extra the API requires
// ==========================================================

test.describe("HEADERS - Metadata about the request", () => {

  test("Content-Type - tells server what format the body is", async ({ request }) => {
    const response = await request.post(
      "https://restful-booker.herokuapp.com/booking",
      {
        data: { firstname: "Yash", lastname: "G", totalprice: 100, depositpaid: true,
                bookingdates: { checkin: "2025-01-01", checkout: "2025-01-02" } },
        headers: {
          "Content-Type": "application/json",   // body is JSON format
          "Accept": "application/json"           // I want JSON response back
        }
      }
    );

    // You can READ the headers from the response too
    const responseHeaders = response.headers();
    console.log("Response Content-Type:", responseHeaders["content-type"]);

    expect(response.ok()).toBeTruthy();
  });


  test("Custom Headers - any extra header the API needs", async ({ request }) => {
    // Some APIs require custom headers like API-Key, x-request-id, etc.
    const response = await request.get(
      "https://restful-booker.herokuapp.com/booking",
      {
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          // "x-api-key": "your-key-here",   // example custom header
          // "x-request-id": "test-123"       // example trace header
        }
      }
    );

    // READ request headers back for debugging
    const allResponseHeaders = response.headers();
    console.log("All response headers:", allResponseHeaders);

    expect(response.status()).toBe(200);
  });

});




// ==========================================================
// CONCEPT 3: TOKEN
// A token is a string that proves "who you are" to the server
// Two ways to send it:
//   1. Authorization header  → "Authorization": "Bearer <token>"
//   2. Cookie header         → "Cookie": "token=<token>"
// ==========================================================
// Flow:
//   Step 1 → Login/Auth (POST username+password) → server returns token
//   Step 2 → Use that token in all protected requests
// ==========================================================

let globalToken: string;   // store token between tests

test.describe("TOKEN - Authentication Flow", () => {

  // Step 1: Login to get token — runs ONCE before all tests in this group
  test.beforeAll(async ({ request }) => {
    const response = await request.post(
      "https://restful-booker.herokuapp.com/auth",
      {
        data: {
          username: "admin",
          password: "password123"
        },
        headers: {
          "Content-Type": "application/json"
        }
      }
    );

    const body = await response.json();
    globalToken = body.token;  // save token for other tests

    console.log("Token received:", globalToken);
    expect(globalToken).toBeDefined();
  });


  // Step 2: Use token in a protected request
  test("Use Token in Authorization Header (Bearer style)", async ({ request }) => {
    // Some APIs use: "Authorization": "Bearer <token>"
    const response = await request.get(
      "https://restful-booker.herokuapp.com/booking/1",
      {
        headers: {
          "Authorization": `Bearer ${globalToken}`,   // Bearer = keyword, then space, then token
          "Accept": "application/json"
        }
      }
    );

    console.log("With Bearer token - status:", response.status());
  });


  test("Use Token in Cookie Header (this API uses cookie-style)", async ({ request }) => {
    // restful-booker uses cookie style: "Cookie": "token=<value>"
    const response = await request.put(
      "https://restful-booker.herokuapp.com/booking/1",
      {
        data: {
          firstname: "TokenTest",
          lastname: "User",
          totalprice: 100,
          depositpaid: true,
          bookingdates: { checkin: "2025-01-01", checkout: "2025-01-05" },
          additionalneeds: "None"
        },
        headers: {
          "Content-Type": "application/json",
          "Cookie": `token=${globalToken}`   // token sent as a cookie
        }
      }
    );

    console.log("With Cookie token - status:", response.status()); // 200 = updated
  });


  test("What happens WITHOUT token on protected route", async ({ request }) => {
    // Without a token, protected routes return 403 Forbidden
    const response = await request.delete(
      "https://restful-booker.herokuapp.com/booking/1"
      // NO headers = no token
    );

    console.log("Without token status:", response.status()); // 403 = Forbidden
    expect(response.status()).toBe(403);
  });

});




// ==========================================================
// CONCEPT 4: COOKIES
// Cookies are small key=value data stored on the client
// and automatically sent with every request to that domain
// ==========================================================
// In API testing (Playwright):
//   - You set cookies manually in headers: "Cookie": "name=value"
//   - Or you add them to the browser context for UI tests
//   - Cookies can hold: session IDs, tokens, preferences, etc.
// ==========================================================

test.describe("COOKIES - Sending and Reading Cookies", () => {

  test("Send Cookie manually in headers (API)", async ({ request }) => {
    // In API tests, cookies are just another header
    // Multiple cookies → separate with semicolon: "name1=val1; name2=val2"
    const response = await request.get(
      "https://restful-booker.herokuapp.com/booking/1",
      {
        headers: {
          "Cookie": "token=abc123; session=xyz"   // multiple cookies example
        }
      }
    );

    console.log("Status:", response.status());
  });


  test("Read cookies from response", async ({ request }) => {
    // After login, server sends back a Set-Cookie header
    const response = await request.post(
      "https://restful-booker.herokuapp.com/auth",
      {
        data: { username: "admin", password: "password123" },
        headers: { "Content-Type": "application/json" }
      }
    );

    // Check response headers for Set-Cookie
    const headers = response.headers();
    console.log("Set-Cookie header:", headers["set-cookie"]);  // may be undefined if API returns JSON token

    const body = await response.json();
    console.log("Token in body:", body.token);   // this API puts token in body, not cookie
  });


  test("Cookies in Browser Context (UI testing)", async ({ browser }) => {
    // For UI tests: you can inject cookies into the browser context
    // This simulates "already logged in" without going through login UI
    const context = await browser.newContext();

    // Add cookies to context (they'll be sent automatically with page requests)
    await context.addCookies([
      {
        name: "token",
        value: "abc123",
        domain: "restful-booker.herokuapp.com",
        path: "/"
      },
      {
        name: "session_id",
        value: "xyz789",
        domain: "restful-booker.herokuapp.com",
        path: "/"
      }
    ]);

    // Read cookies back
    const cookies = await context.cookies();
    console.log("Cookies in context:", cookies);

    // Clear all cookies
    await context.clearCookies();

    await context.close();
  });

});




// ==========================================================
// CONCEPT 5: COMPLETE FLOW - Putting it all together
// This is exactly what your API.spec.ts does:
//   1. POST /auth → get token
//   2. POST /booking → create (headers: Content-Type)
//   3. GET /booking/:id → read (no auth needed)
//   4. PUT /booking/:id → update (auth via Cookie: token=...)
//   5. DELETE /booking/:id → delete (auth via Cookie: token=...)
// ==========================================================

test.describe("FULL FLOW - Request + Header + Token + Cookie together", () => {

  let token: string;
  let bookingId: number;

  test.beforeAll(async ({ request }) => {
    // STEP 1: Get token (login)
    const authRes = await request.post("https://restful-booker.herokuapp.com/auth", {
      data: { username: "admin", password: "password123" },
      headers: { "Content-Type": "application/json" }   // HEADER: body format
    });
    token = (await authRes.json()).token;             // TOKEN: store for later
    console.log("1. Token:", token);
  });

  test("Create → Read → Update → Delete", async ({ request }) => {
    // STEP 2: POST - Create booking
    const createRes = await request.post("https://restful-booker.herokuapp.com/booking", {
      data: { firstname: "Test", lastname: "User", totalprice: 200, depositpaid: true,
              bookingdates: { checkin: "2025-05-01", checkout: "2025-05-05" } },
      headers: { "Content-Type": "application/json" }  // HEADER
    });
    bookingId = (await createRes.json()).bookingid;
    console.log("2. Created bookingId:", bookingId);

    // STEP 3: GET - Read it back
    const getRes = await request.get(`https://restful-booker.herokuapp.com/booking/${bookingId}`);
    expect(getRes.status()).toBe(200);
    console.log("3. Fetched:", await getRes.json());

    // STEP 4: PUT - Update (needs TOKEN as COOKIE)
    const putRes = await request.put(`https://restful-booker.herokuapp.com/booking/${bookingId}`, {
      data: { firstname: "Updated", lastname: "User", totalprice: 300, depositpaid: false,
              bookingdates: { checkin: "2025-06-01", checkout: "2025-06-05" } },
      headers: {
        "Content-Type": "application/json",   // HEADER: body format
        "Cookie": `token=${token}`             // TOKEN sent as COOKIE for auth
      }
    });
    expect(putRes.status()).toBe(200);
    console.log("4. Updated:", await putRes.json());

    // STEP 5: DELETE - Remove (needs TOKEN as COOKIE)
    const delRes = await request.delete(`https://restful-booker.herokuapp.com/booking/${bookingId}`, {
      headers: {
        "Cookie": `token=${token}`             // TOKEN sent as COOKIE for auth
      }
    });
    expect(delRes.status()).toBe(201);
    console.log("5. Deleted - status:", delRes.status());
  });

});
