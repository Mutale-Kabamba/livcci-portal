<?php

namespace App\Providers;

use App\Events\PaymentThresholdReached;
use App\Listeners\ActivateBusinessProfileAndNotifyMember;
use App\Models\User;
use Illuminate\Support\Facades\Vite;
use Illuminate\Support\Facades\Event;
use Illuminate\Support\Facades\Gate;
use Illuminate\Support\ServiceProvider;
use App\Models\BusinessProfile;
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
