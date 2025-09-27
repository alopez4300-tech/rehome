<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Spatie\Permission\Models\Role;

class RolesAndAdminSeeder extends Seeder
{
    public function run(): void
    {
        foreach (["admin","team","consultant","client"] as $r) {
            Role::firstOrCreate(["name" => $r, "guard_name" => "web"]);
        }

        // Admin (Filament)
        $admin = User::firstOrCreate(
            ["email" => "admin@example.com"],
            [
                "name" => "Admin Filament",
                "password" => Hash::make("password"),
                "email_verified_at" => now(),
            ]
        );
        $admin->syncRoles(["admin"]);

        // Team
        $team = User::firstOrCreate(
            ["email" => "team@example.com"],
            [
                "name" => "Team User",
                "password" => Hash::make("password"),
                "email_verified_at" => now(),
            ]
        );
        $team->syncRoles(["team"]);

        // Consultant
        $consultant = User::firstOrCreate(
            ["email" => "consultant@example.com"],
            [
                "name" => "Consultant User",
                "password" => Hash::make("password"),
                "email_verified_at" => now(),
            ]
        );
        $consultant->syncRoles(["consultant"]);

        // Client
        $client = User::firstOrCreate(
            ["email" => "client@example.com"],
            [
                "name" => "Client User",
                "password" => Hash::make("password"),
                "email_verified_at" => now(),
            ]
        );
        $client->syncRoles(["client"]);
    }
}
