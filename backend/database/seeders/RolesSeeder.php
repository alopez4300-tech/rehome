<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Spatie\Permission\Models\Role;

class RolesSeeder extends Seeder
{
    public function run(): void
    {
        foreach (["admin","team","consultant","client"] as $role) {
            Role::firstOrCreate(["name" => $role, "guard_name" => "web"]);
        }
    }
}
