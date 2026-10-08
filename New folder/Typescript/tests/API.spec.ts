import { test, expect } from "@playwright/test";
import { faker } from "@faker-js/faker";
import { date, z } from "zod";

let token: string;
let bookingId: number;

// ================================
// 📐 Zod Schema Definitions
// ================================
const BookingDatesSchema = z.object({
  checkin: z.string().regex(/^\d{4}-\d{2}-\d{2}$/, "Invalid checkin date format"),
  checkout: z.string().regex(/^\d{4}-\d{2}-\d{2}$/, "Invalid checkout date format")
});

const BookingSchema = z.object({
  firstname: z.string(),
  lastname: z.string(),
  totalprice: z.number(),
  depositpaid: z.boolean(),
  bookingdates: BookingDatesSchema,
  additionalneeds: z.string().optional()
});

const CreateBookingResponseSchema = z.object({
  bookingid: z.number(),
  booking: BookingSchema
});

function assertSchema<T>(schema: z.ZodSchema<T>, data: unknown, label: string): T {
  const result = schema.safeParse(data);
  expect(result.success, `[Schema Fail] ${label}: ${JSON.stringify(result.success ? null : (result as z.ZodSafeParseError<T>).error.issues)}`).toBe(true);
  return (result as z.ZodSafeParseSuccess<T>).data;
}


// ================================
// 🧪 Faker Payload Generator
// ================================
export function createBookingPayload() {
  return {
    firstname: faker.person.firstName(),
    lastname: faker.person.lastName(),
    totalprice: faker.number.int({ min: 100, max: 1000 }),
    depositpaid: faker.datatype.boolean(),
    bookingdates: {
      checkin: faker.date.past().toISOString().split("T")[0],
      checkout: faker.date.future().toISOString().split("T")[0]
    },
    additionalneeds: "Breakfast"
  };
}


// ================================
// 📦 Data Driven Tests
// ================================
const testDataCount = 3;

test.describe("Data Driven Booking API with Faker", () => {

  for (let i = 0; i < testDataCount; i++) {

    test(`Create & Get Booking - Iteration ${i + 1}`, async ({ request }, testInfo) => {

      // =========================
      // 🟢 POST - Create Booking
      // =========================
      const payload = createBookingPayload();

      const createResponse = await request.post(
        "https://restful-booker.herokuapp.com/booking",
        {
          data: payload,
          headers: {
            "Content-Type": "application/json"
          }
        }
      );

      expect(createResponse.ok()).toBeTruthy();

      const createBody = await createResponse.json();
      assertSchema(CreateBookingResponseSchema, createBody, "POST /booking response");
      const bookingId = createBody.bookingid;

      console.log(`Created Booking ID: ${bookingId}`);

      // =========================
      // 📎 ATTACH POST
      // =========================
      await testInfo.attach("POST Payload", {
        body: JSON.stringify(payload, null, 2),
        contentType: "application/json"
      });

      await testInfo.attach("POST Response", {
        body: JSON.stringify(createBody, null, 2),
        contentType: "application/json"
      });

      // =========================
      // 🔵 GET - Fetch Booking
      // =========================
      const getResponse = await request.get(
        `https://restful-booker.herokuapp.com/booking/${bookingId}`
      );

      expect(getResponse.status()).toBe(200);

      const getBody = await getResponse.json();
      assertSchema(BookingSchema, getBody, "GET /booking/:id response");

      console.log("Fetched Booking:", getBody);

      // =========================
      // 📎 ATTACH GET
      // =========================
      await testInfo.attach("GET Response", {
        body: JSON.stringify(getBody, null, 2),
        contentType: "application/json"
      });

    });

  }

});







// ================================
// 🟢 GROUP START
// ================================
test.describe("Booking API Suite (Token Based Flow)", () => {

  // ================================
  // 🔐 BEFORE ALL - TOKEN GENERATION
  // ================================
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
    token = body.token;

    console.log("Token Generated:", token);
  });


  // ================================
  // 🟢 CREATE BOOKING
  // ================================
  test("Create Booking", async ({ request }) => {

    const payload = {
      firstname: faker.person.firstName(),
      lastname: faker.person.lastName(),
      totalprice: 250,
      depositpaid: true,
      bookingdates: {
        checkin: "2025-01-01",
        checkout: "2025-01-10"
      },
      additionalneeds: "Breakfast"
    };

    const response = await request.post(
      "https://restful-booker.herokuapp.com/booking",
      {
        data: payload,
        headers: {
          "Content-Type": "application/json"
        }
      }
    );

    expect(response.ok()).toBeTruthy();

    const body = await response.json();
    assertSchema(CreateBookingResponseSchema, body, "POST /booking response");
    bookingId = body.bookingid;

    console.log("Booking Created:", bookingId);
  });


  // ================================
  // 🔵 GET BOOKING
  // ================================
  test("Get Booking", async ({ request }) => {

    const response = await request.get(
      `https://restful-booker.herokuapp.com/booking/${bookingId}`
    );

    expect(response.status()).toBe(200);

    const body = await response.json();
    assertSchema(BookingSchema, body, "GET /booking/:id response");

    console.log("Booking Data:", body);
  });


  // ================================
  // 🟡 UPDATE BOOKING (USES TOKEN)
  // ================================
  test("Update Booking", async ({ request }) => {

    const updatedPayload = {
      firstname: "UpdatedName",
      lastname: "Tester",
      totalprice: 999,
      depositpaid: false,
      bookingdates: {
        checkin: "2025-02-01",
        checkout: "2025-02-10"
      },
      additionalneeds: "Lunch"
    };

    const response = await request.put(
      `https://restful-booker.herokuapp.com/booking/${bookingId}`,
      {
        data: updatedPayload,
        headers: {
          "Content-Type": "application/json",
          "Cookie": `token=${token}`
        }
      }
    );

    expect(response.status()).toBe(200);

    const body = await response.json();
    assertSchema(BookingSchema, body, "PUT /booking/:id response");
    console.log("Updated Booking:", body);
  });



 test("Partial Update Booking (PATCH)", async ({ request }) => {

    const patchPayload = {firstname: "PatchedName"};

    const response = await request.patch(
      `https://restful-booker.herokuapp.com/booking/${bookingId}`,
      {
        data: patchPayload,
        headers: {
          "Content-Type": "application/json",
          "Cookie": `token=${token}`
        }
      }
    );

    expect(response.ok()).toBeTruthy();

    const body = await response.json();
    expect(date).toHaveProperty("firstname")
    assertSchema(BookingSchema, body, "PATCH /booking/:id response");
    expect(body).toHaveProperty("firstname");



    console.log("Patched Booking:", body);
  });
  test("Delete Booking", async ({ request }) => {

    const response = await request.delete(
      `https://restful-booker.herokuapp.com/booking/${bookingId}`,
      {
        headers: {
          "Cookie": `token=${token}` 
            // 🔐 AUTH REQUIRED
        }
      }
    );

    expect(response.status()).toBe(201);

    console.log("Booking Deleted");
  });


});
