<?php

use Illuminate\Foundation\Inspiring;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\Schedule;
use App\Services\NotificationAutomationService;

Artisan::command('inspire', function () {
    $this->comment(Inspiring::quote());
})->purpose('Display an inspiring quote');

Schedule::call(function () {
    app(NotificationAutomationService::class)->sendVerificationReminders();
})->dailyAt('09:00')->name('mail:verification-reminders')->withoutOverlapping();

Schedule::call(function () {
    app(NotificationAutomationService::class)->sendNewsDigestUpdates();
})->dailyAt('17:00')->name('mail:news-digest')->withoutOverlapping();

Schedule::call(function () {
    app(NotificationAutomationService::class)->sendRenewalReminders();
})->dailyAt('08:00')->name('mail:renewal-reminders')->withoutOverlapping();
