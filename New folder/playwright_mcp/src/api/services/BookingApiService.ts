import { APIRequestContext } from '@playwright/test';
import { ApiClient, ApiResponse } from '../ApiClient';

export interface BookingDates {
  checkin:  string;
  checkout: string;
}

export interface BookingPayload {
  firstname:       string;
  lastname:        string;
  totalprice:      number;
  depositpaid:     boolean;
  bookingdates:    BookingDates;
  additionalneeds: string;
}

export interface Booking extends BookingPayload {}

export interface BookingId {
  bookingid: number;
}

export interface BookingCreatedResponse {
  bookingid: number;
  booking:   Booking;
}

export type PartialBookingPayload = Partial<BookingPayload>;

export class BookingApiService extends ApiClient {
  private authToken = '';

  constructor(request: APIRequestContext, baseURL: string) {
    super(request, baseURL, 'BookingApiService');
  }

  /** Provide the raw token returned by POST /auth for cookie-based auth. */
  setAuthToken(token: string): void {
    this.authToken = token;
  }

  private cookieHeader(): Record<string, string> {
    return this.authToken ? { Cookie: `token=${this.authToken}` } : {};
  }

  /** GET /booking — list all booking ids, optionally filtered by name. */
  getBookingIds(filter?: { firstname?: string; lastname?: string }): Promise<ApiResponse<BookingId[]>> {
    return this.get<BookingId[]>('/booking', {
      params: filter as Record<string, string>,
    });
  }

  /** GET /booking/:id */
  getBookingById(id: number): Promise<ApiResponse<Booking>> {
    return this.get<Booking>(`/booking/${id}`);
  }

  /** POST /booking */
  createBooking(payload: BookingPayload): Promise<ApiResponse<BookingCreatedResponse>> {
    return this.post<BookingCreatedResponse>('/booking', { data: payload });
  }

  /** PUT /booking/:id — full update (token required) */
  updateBooking(id: number, payload: BookingPayload): Promise<ApiResponse<Booking>> {
    return this.put<Booking>(`/booking/${id}`, {
      data:    payload,
      headers: this.cookieHeader(),
    });
  }

  /** PATCH /booking/:id — partial update (token required) */
  partialUpdateBooking(id: number, payload: PartialBookingPayload): Promise<ApiResponse<Booking>> {
    return this.patch<Booking>(`/booking/${id}`, {
      data:    payload,
      headers: this.cookieHeader(),
    });
  }

  /** DELETE /booking/:id (token required) */
  deleteBooking(id: number): Promise<ApiResponse<string>> {
    return this.delete<string>(`/booking/${id}`, {
      headers: this.cookieHeader(),
    });
  }
}
