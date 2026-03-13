<?php

namespace App\Http\Middleware;

use Illuminate\Http\Request;
use Inertia\Middleware;

class HandleInertiaRequests extends Middleware
{
    /**
     * The root template that is loaded on the first page visit.
     *
     * @var string
     */
    protected $rootView = 'app';

    /**
     * Determine the current asset version.
     */
    public function version(Request $request): ?string
    {
        return parent::version($request);
    }

    /**
     * Define the props that are shared by default.
     *
     * @return array<string, mixed>
     */
    public function share(Request $request): array
    {
        $user = $request->user();

        return [
            ...parent::share($request),
            'auth' => [
                'user' => $user,
                'permissions' => [
                    'is_super_admin' => $user?->isSuperAdmin() ?? false,
                    'can_manage_finance' => $user?->can('manage_finance') ?? false,
                    'can_manage_content' => $user?->can('manage_content') ?? false,
                    'can_manage_members' => $user?->can('manage_members') ?? false,
                    'can_view_reports' => $user?->can('view_reports') ?? false,
                    'can_manage_accounts' => $user?->can('manage_accounts') ?? false,
                ],
            ],
        ];
    }
}
