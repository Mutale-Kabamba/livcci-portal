<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\LoginRequest;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;
use Inertia\Response;

class AuthenticatedSessionController extends Controller
{
    /**
     * Display the login view.
     */
    public function create(): Response
    {
        return Inertia::render('Auth/Login', [
            'canResetPassword' => Route::has('password.request'),
            'status' => session('status'),
        ]);
    }

    /**
     * Handle an incoming authentication request.
     */
    public function store(LoginRequest $request): RedirectResponse
    {
        $request->authenticate();

        $request->session()->regenerate();

        $user = $request->user();
        if ($user?->is_admin) {
            return redirect()->route('portal.mode.choose');
        }

        $request->session()->put('portal_mode', 'ordinary');

        return redirect()->intended(route('dashboard', absolute: false));
    }

    public function choosePortalMode(Request $request): Response|RedirectResponse
    {
        $user = $request->user();
        if (!$user || !$user->is_admin) {
            return redirect()->route('dashboard');
        }

        return Inertia::render('Auth/PortalMode', [
            'role' => $user->role,
        ]);
    }

    public function setPortalMode(Request $request): RedirectResponse
    {
        $validated = $request->validate([
            'mode' => 'required|in:admin,ordinary',
        ]);

        $user = $request->user();
        if (!$user || !$user->is_admin) {
            $request->session()->put('portal_mode', 'ordinary');
            return redirect()->route('dashboard');
        }

        $request->session()->put('portal_mode', $validated['mode']);

        if ($validated['mode'] === 'admin') {
            return redirect()->route('admin.dashboard');
        }

        return redirect()->route('dashboard');
    }

    /**
     * Destroy an authenticated session.
     */
    public function destroy(Request $request): RedirectResponse
    {
        Auth::guard('web')->logout();

        $request->session()->invalidate();

        $request->session()->regenerateToken();

        return redirect('/');
    }
}
