<?php

namespace App\Providers;

use Illuminate\Support\Facades\Vite;
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
