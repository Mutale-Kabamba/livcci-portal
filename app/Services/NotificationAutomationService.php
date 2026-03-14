<?php

namespace App\Services;

use App\Mail\NewsUpdateDigestMail;
use App\Mail\RenewalReminderMail;
use App\Models\BusinessProfile;
use App\Models\ChamberEvent;
use App\Models\User;
use Illuminate\Support\Facades\Mail;

class NotificationAutomationService
{
    /**
     * Send reminders at specific day offsets before expiry.
     */
    public function sendRenewalReminders(array $offsets = [30]): int
    {
        $today = now()->startOfDay();
        $count = 0;

        $profiles = BusinessProfile::query()
            ->where('status', 'approved')
            ->whereNotNull('contact_email')
            ->whereNotNull('subscription_expiry')
            ->get();

        foreach ($profiles as $profile) {
            $daysRemaining = $today->diffInDays($profile->subscription_expiry->startOfDay(), false);
            if (!in_array($daysRemaining, $offsets, true)) {
                continue;
            }

            Mail::to($profile->contact_email)->send(new RenewalReminderMail($profile, $daysRemaining));
            $count++;
        }

        return $count;
    }

    /**
     * Send a daily digest of recently published events/updates.
     */
    public function sendNewsDigestUpdates(): int
    {
        $events = ChamberEvent::query()
            ->where('created_at', '>=', now()->subDay())
            ->latest()
            ->get(['title', 'type', 'event_date', 'description'])
            ->toArray();

        if (empty($events)) {
            return 0;
        }

        $emails = BusinessProfile::query()
            ->where('status', 'approved')
            ->whereNotNull('contact_email')
            ->pluck('contact_email')
            ->filter()
            ->unique()
            ->values();

        $count = 0;
        foreach ($emails as $email) {
            Mail::to($email)->send(new NewsUpdateDigestMail($events));
            $count++;
        }

        return $count;
    }

    /**
     * Remind users who have not verified email yet.
     */
    public function sendVerificationReminders(): int
    {
        $users = User::query()
            ->whereNull('email_verified_at')
            ->whereNull('google_id')
            ->whereDate('created_at', '<=', now()->subDay())
            ->get();

        $count = 0;
        foreach ($users as $user) {
            $user->sendEmailVerificationNotification();
            $count++;
        }

        return $count;
    }
}
