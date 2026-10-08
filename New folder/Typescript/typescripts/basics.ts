import { test, expect } from "@playwright/test";
import { faker } from "@faker-js/faker";
import * as allure from "allure-playwright";
import * as fs from "fs";


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

    test(`Create & Get Booking - Iteration ${i + 1}`, async ({ request }) => {

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
      const bookingId = createBody.bookingid;

      console.log(`Created Booking ID: ${bookingId}`);

      // =========================
      // 🔵 GET - Fetch Booking
      // =========================
      const getResponse = await request.get(
        `https://restful-booker.herokuapp.com/booking/${bookingId}`
      );

      expect(getResponse.status()).toBe(200);

      const getBody = await getResponse.json();

      console.log("Fetched Booking:", getBody);

      // =========================
      // 🟡 VALIDATION
      // =========================
      expect(getBody.firstname).toBe(payload.firstname);
      expect(getBody.lastname).toBe(payload.lastname);
      expect(getBody.totalprice).toBe(payload.totalprice);
      expect(getBody.depositpaid).toBe(payload.depositpaid);

      // =========================
      // 📎 ALLURE ATTACHMENTS
      // =========================
      await allure.attachment(
        "POST Payload",
        JSON.stringify(payload, null, 2),
        "application/json"
      );

      await allure.attachment(
        "POST Response",
        JSON.stringify(createBody, null, 2),
        "application/json"
      );

      await allure.attachment(
        "GET Response",
        JSON.stringify(getBody, null, 2),
        "application/json"
      );

    });

  }

});
