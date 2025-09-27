<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\Hash;
use App\Models\User;

class MakeUser extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'app:make-user
        {email : Email address}
        {role : admin|team|consultant|client}
        {--name=User : Display name}
        {--password=password : Plain password}';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Create or update a user with a role';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        $email = (string)$this->argument('email');
        $role  = (string)$this->argument('role');
        $name  = (string)$this->option('name');
        $pass  = (string)$this->option('password');

        if (!in_array($role, ['admin','team','consultant','client'], true)) {
            $this->error("Invalid role: {$role}");
            return self::FAILURE;
        }

        $user = User::updateOrCreate(
            ['email' => $email],
            ['name' => $name, 'password' => Hash::make($pass)]
        );

        $user->syncRoles([$role]);
        $this->info("User {$user->email} is {$role}");
        return self::SUCCESS;
    }
}
