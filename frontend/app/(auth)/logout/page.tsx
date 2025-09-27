"use client";

import { useEffect } from "react";
import { logout } from "@/lib/auth";
import { useRouter } from "next/navigation";

export default function LogoutPage() {
  const router = useRouter();
  useEffect(() => {
    logout().finally(() => {
      router.push("/login");
    });
  }, [router]);
  return (
    <main className="flex flex-col items-center justify-center min-h-screen">
      <div className="text-lg">Signing out...</div>
    </main>
  );
}
