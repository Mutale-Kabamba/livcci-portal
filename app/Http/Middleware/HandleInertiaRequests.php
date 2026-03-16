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
        $portalMode = (string) $request->session()->get('portal_mode', ($user?->is_admin ? 'admin' : 'ordinary'));
        $adminMode = $portalMode === 'admin' && ($user?->is_admin ?? false);

        return [
            ...parent::share($request),
            'auth' => [
                'user' => $user,
                'portal_mode' => $portalMode,
                'can_switch_portal_mode' => $user?->is_admin ?? false,
                'permissions' => [
                    'is_super_admin' => $adminMode ? ($user?->isSuperAdmin() ?? false) : false,
                    'can_manage_finance' => $adminMode ? ($user?->can('manage_finance') ?? false) : false,
                    'can_manage_content' => $adminMode ? ($user?->can('manage_content') ?? false) : false,
                    'can_manage_members' => $adminMode ? ($user?->can('manage_members') ?? false) : false,
                    'can_view_reports' => $adminMode ? ($user?->can('view_reports') ?? false) : false,
                    'can_manage_accounts' => $adminMode ? ($user?->can('manage_accounts') ?? false) : false,
                ],
            ],
        ];
    }
}
