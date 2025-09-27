use Illuminate\Support\Facades\Hash;
use App\Models\User;
Artisan::command('app:make-user {email} {role} {--name=User} {--password=password}', function () {
    $email = $this->argument('email');
    $role  = $this->argument('role'); // admin|team|consultant|client
    $name  = $this->option('name');
    $pass  = $this->option('password');

    if (! in_array($role, ['admin','team','consultant','client'], true)) {
        $this->error("Invalid role: $role");
        return 1;
    }

    $u = User::updateOrCreate(['email' => $email], [
        'name' => $name,
        'password' => Hash::make($pass),
        'email_verified_at' => now(),
    ]);

    $u->syncRoles([$role]);
    $this->info("User {$u->email} set to role: {$role}");
})->purpose('Create or update a user and assign a role');
<?php

use Illuminate\Foundation\Inspiring;
use Illuminate\Support\Facades\Artisan;

Artisan::command('inspire', function () {
    $this->comment(Inspiring::quote());
})->purpose('Display an inspiring quote');
