<?php

namespace App\Listeners;

use App\Events\PaymentThresholdReached;
use App\Mail\MemberDirectoryEligibilityMail;
use Illuminate\Support\Facades\Mail;

class ActivateBusinessProfileAndNotifyMember
{
    public function handle(PaymentThresholdReached $event): void
    {
        $profile = $event->profile;

        if (!$profile->is_active) {
            $profile->update(['is_active' => true]);
        }

        if ($profile->contact_email) {
            Mail::to($profile->contact_email)->send(
                new MemberDirectoryEligibilityMail(
                    $profile->fresh(),
                    $event->percentage,
                    $event->amountPaid,
                    $event->annualFee
                )
            );
        }
    }
}
