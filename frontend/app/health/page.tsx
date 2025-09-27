"use client";

import { useEffect, useState } from "react";
import { api } from "@/lib/api";

export default function Health() {
  const [status, setStatus] = useState<string>("checking...");

  useEffect(() => {
    api
      .get("/api/ping")
      .then(res => setStatus(JSON.stringify(res.data)))
      .catch(e => setStatus(`error: ${e?.message || "unknown"}`));
  }, []);

  return (
    <main style={{ maxWidth: 600, margin: "80px auto", fontFamily: "system-ui" }}>
      <h1 style={{ fontSize: 24, marginBottom: 12 }}>Health</h1>
      <pre style={{ padding: 12, background: "#f6f6f6", borderRadius: 8 }}>{status}</pre>
    </main>
  );
}
