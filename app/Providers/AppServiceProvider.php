<?php

namespace App\Providers;

use App\Events\PaymentThresholdReached;
use App\Listeners\ActivateBusinessProfileAndNotifyMember;
use App\Mail\WelcomeMember;
use App\Models\BusinessProfile;
use App\Models\User;
use Illuminate\Auth\Events\Verified;
use Illuminate\Validation\Rules\Password;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Vite;
use Illuminate\Support\Facades\Event;
use Illuminate\Support\Facades\Gate;
use Illuminate\Support\ServiceProvider;
use App\Policies\BusinessProfilePolicy;

class AppServiceProvider extends ServiceProvider
{
    /**
     * The model to policy mappings for the application.
     */
    protected $policies = [
        BusinessProfile::class => BusinessProfilePolicy::class,
    ];

    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        Vite::prefetch(concurrency: 3);

        Password::defaults(function () {
            return Password::min(8)
                ->mixedCase()
                ->numbers()
                ->symbols();
        });

        Gate::define('manage_finance', function (User $user): bool {
            return $user->isSuperAdmin() || $user->hasAnyRole(['finance', 'finance_officer']);
        });

        Gate::define('manage_content', function (User $user): bool {
            return $user->isSuperAdmin() || $user->hasAnyRole(['media', 'media_officer', 'media_communication']);
        });

        Gate::define('manage_members', function (User $user): bool {
            return $user->isSuperAdmin() || $user->hasAnyRole(['secretariat']);
        });

        Gate::define('view_reports', function (User $user): bool {
            return $user->isSuperAdmin() || $user->hasAnyRole(['finance', 'finance_officer']);
        });

        Gate::define('manage_accounts', function (User $user): bool {
            return $user->isSuperAdmin();
        });

        Event::listen(
            PaymentThresholdReached::class,
            ActivateBusinessProfileAndNotifyMember::class,
        );

        Event::listen(Verified::class, function (Verified $event): void {
            $user = $event->user;
            if (!$user instanceof User) {
                return;
            }

            $profile = BusinessProfile::query()
                ->where('user_id', $user->id)
                ->latest('id')
                ->first();

            try {
                Mail::to($user->email)->send(new WelcomeMember($user, $profile));
            } catch (\Throwable $exception) {
                \Log::warning('Failed to send post-verification welcome email', [
                    'user_id' => $user->id,
                    'error' => $exception->getMessage(),
                ]);
            }
        });
        
        // Register policies
        foreach ($this->policies as $model => $policy) {
            $this->gate($model, $policy);
        }
    }

    /**
     * Register a model policy mapping.
     */
    protected function gate(string $model, string $policy): void
    {
        \Illuminate\Support\Facades\Gate::policy($model, $policy);
    }
}
