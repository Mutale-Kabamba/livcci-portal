<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class IsAdminMiddleware
{
    public function handle(Request $request, Closure $next): Response
    {
        // Check if the user is logged in AND has admin privileges
        if (!auth()->check() || !auth()->user()->is_admin) {
            abort(403, 'Unauthorized access. Secretariat Admins only.');
        }

        return $next($request);
    }
}