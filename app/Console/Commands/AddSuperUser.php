<?php

namespace App\Console\Commands;

use App\Models\User;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Hash;

class AddSuperUser extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'user:add-super {name} {email} {password}';

    /**
     * The description of the console command.
     *
     * @var string
     */
    protected $description = 'Create a new super user account';

    /**
     * Execute the console command.
     */
    public function handle(): int
    {
        $name = $this->argument('name');
        $email = $this->argument('email');
        $password = $this->argument('password');

        // Check if user already exists
        if (User::where('email', $email)->exists()) {
            $this->error("A user with email '{$email}' already exists.");
            return self::FAILURE;
        }

        try {
            $user = User::create([
                'name' => $name,
                'email' => $email,
                'password' => Hash::make($password),
                'is_admin' => true,
                'role' => 'super_admin',
            ]);

            $this->info("Super user '{$user->name}' ({$user->email}) created successfully!");
            $this->line("User ID: {$user->id}");

            return self::SUCCESS;
        } catch (\Exception $e) {
            $this->error("Failed to create super user: {$e->getMessage()}");
            return self::FAILURE;
        }
    }
}
