package com.apitesting.models;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * INTERVIEW CONCEPT: POJO (Plain Old Java Object) used for request body serialization
 * and response body deserialization via Jackson.
 *
 * RestAssured automatically converts POJO → JSON when passed to .body()
 * and JSON → POJO when using .as(Booking.class)
 */
public class Booking {

    @JsonProperty("firstname")
    private String firstname;

    @JsonProperty("lastname")
    private String lastname;

    @JsonProperty("totalprice")
    private int totalprice;

    @JsonProperty("depositpaid")
    private boolean depositpaid;

    @JsonProperty("bookingdates")
    private BookingDates bookingdates;

    @JsonProperty("additionalneeds")
    private String additionalneeds;

    // Default constructor required by Jackson
    public Booking() {}

    public Booking(String firstname, String lastname, int totalprice,
                   boolean depositpaid, BookingDates bookingdates, String additionalneeds) {
        this.firstname      = firstname;
        this.lastname       = lastname;
        this.totalprice     = totalprice;
        this.depositpaid    = depositpaid;
        this.bookingdates   = bookingdates;
        this.additionalneeds = additionalneeds;
    }

    // ── Getters & Setters ──
    public String getFirstname()            { return firstname; }
    public void setFirstname(String v)      { this.firstname = v; }

    public String getLastname()             { return lastname; }
    public void setLastname(String v)       { this.lastname = v; }

    public int getTotalprice()              { return totalprice; }
    public void setTotalprice(int v)        { this.totalprice = v; }

    public boolean isDepositpaid()          { return depositpaid; }
    public void setDepositpaid(boolean v)   { this.depositpaid = v; }

    public BookingDates getBookingdates()         { return bookingdates; }
    public void setBookingdates(BookingDates v)   { this.bookingdates = v; }

    public String getAdditionalneeds()            { return additionalneeds; }
    public void setAdditionalneeds(String v)      { this.additionalneeds = v; }

    @Override
    public String toString() {
        return "Booking{firstname='" + firstname + "', lastname='" + lastname +
               "', totalprice=" + totalprice + ", depositpaid=" + depositpaid + "}";
    }
}
