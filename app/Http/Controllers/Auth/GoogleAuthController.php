<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;
use Laravel\Socialite\Facades\Socialite;

class GoogleAuthController extends Controller
{
    public function redirectToGoogle(): RedirectResponse
    {
        return Socialite::driver('google')->stateless()->redirect();
    }

    public function handleGoogleCallback(Request $request): RedirectResponse
    {
        if ($request->filled('error')) {
            \Log::warning('Google authentication callback returned an error', [
                'error' => $request->string('error')->toString(),
                'error_description' => $request->string('error_description')->toString(),
            ]);

            return redirect()->route('login')
                ->withErrors(['email' => 'Google sign-in was cancelled or denied. Please try again.']);
        }

        if (!$request->filled('code')) {
            \Log::warning('Google authentication callback missing code', [
                'query' => $request->query(),
            ]);

            return redirect()->route('login')
                ->withErrors(['email' => 'Google authentication failed: missing authorization code.']);
        }

        try {
            $googleUser = Socialite::driver('google')->stateless()->user();
        } catch (\Throwable $exception) {
            \Log::warning('Google authentication failed', [
                'error' => $exception->getMessage(),
            ]);

            return redirect()->route('login')
                ->withErrors(['email' => 'Google authentication failed. Please try again.']);
        }

        $email = $googleUser->getEmail();
        if (blank($email)) {
            return redirect()->route('login')
                ->withErrors(['email' => 'Google account does not provide an email address.']);
        }

        $user = User::query()
            ->where('google_id', (string) $googleUser->getId())
            ->orWhere('email', $email)
            ->first();

        if ($user) {
            $user->forceFill([
                'google_id' => (string) $googleUser->getId(),
                'avatar_url' => $googleUser->getAvatar(),
                'email_verified_at' => $user->email_verified_at ?? now(),
            ])->save();
        } else {
            $user = User::create([
                'name' => $googleUser->getName() ?: $googleUser->getNickname() ?: 'Google User',
                'email' => $email,
                'password' => Hash::make(Str::random(40)),
                'google_id' => (string) $googleUser->getId(),
                'avatar_url' => $googleUser->getAvatar(),
                'email_verified_at' => now(),
            ]);
        }

        Auth::login($user, true);
        $request->session()->regenerate();

        if ($user->is_admin) {
            return redirect()->route('portal.mode.choose');
        }

        $request->session()->put('portal_mode', 'ordinary');

        return redirect()->route('dashboard');
    }
}
