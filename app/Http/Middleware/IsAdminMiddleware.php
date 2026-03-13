<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class IsAdminMiddleware
{
    public function handle(Request $request, Closure $next): Response
    {
        if (!auth()->check()) {
            return redirect()->route('login');
        }

        if (!auth()->user()->is_admin) {
            return redirect()->route('dashboard')
                ->with('error', 'Admin access is restricted to authorized Secretariat users.');
        }

        if ($request->session()->get('portal_mode') !== 'admin') {
            return redirect()->route('portal.mode.choose')
                ->with('error', 'Select Admin mode to access the admin portal.');
        }

        return $next($request);
    }
}