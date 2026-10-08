export interface Credentials {
  mobile: string;
  email: string;
  password: string;
  otp: string;
}

export interface SearchResult {
  title: string;
  type: 'movie' | 'show' | 'sport';
}
