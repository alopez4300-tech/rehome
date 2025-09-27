import axios from "axios";

export const api = axios.create({
  baseURL: process.env.NEXT_PUBLIC_API_URL,
  withCredentials: true, // send/receive Sanctum cookies
  headers: { "X-Requested-With": "XMLHttpRequest" },
});

// Helpers
export async function getCsrf() {
  await api.get("/sanctum/csrf-cookie");
}
