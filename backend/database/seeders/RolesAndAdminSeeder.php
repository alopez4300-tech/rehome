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

        $admin = User::firstOrCreate(
            ["email" => env("ADMIN_EMAIL","admin@example.com")],
            [
                "name" => env("ADMIN_NAME","Admin"),
                "password" => Hash::make(env("ADMIN_PASSWORD","password")),
                "email_verified_at" => now(),
            ]
        );

        $admin->syncRoles(["admin"]);
    }
}
