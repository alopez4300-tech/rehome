"use client";

import { useEffect, useState } from "react";
import { me, logout } from "@/lib/auth";
import { useRouter } from "next/navigation";

export default function Dashboard() {
  const [user, setUser] = useState<any>(null);
  const [err, setErr] = useState<string | null>(null);
  const router = useRouter();

  useEffect(() => {
    me()
      .then(setUser)
      .catch(() => {
        setErr("Not authenticated");
        router.replace("/login");
      });
  }, [router]);

  if (!user) return null;

  return (
    <main style={{ maxWidth: 720, margin: "60px auto", fontFamily: "system-ui" }}>
      <h1 style={{ fontSize: 24, marginBottom: 8 }}>Dashboard</h1>
      <p style={{ marginBottom: 24 }}>Signed in as <b>{user.email}</b></p>
      <button
        onClick={async () => {
          await logout();
          router.replace("/login");
        }}
        style={{ padding: 10, borderRadius: 8, border: "1px solid #ccc" }}
      >
        Sign out
      </button>
    </main>
  );
}
