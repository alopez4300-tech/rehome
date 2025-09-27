import { api, getCsrf } from "./api";

export async function login(email: string, password: string) {
  await getCsrf();
  const { data } = await api.post("/login", { email, password });
  return data.user;
}

export async function me() {
  const { data } = await api.get("/api/user");
  return data;
}

export async function logout() {
  await api.post("/logout");
}
