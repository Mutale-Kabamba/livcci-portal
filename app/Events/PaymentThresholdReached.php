<?php

namespace App\Events;

use App\Models\BusinessProfile;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class PaymentThresholdReached
{
    use Dispatchable, SerializesModels;

    public function __construct(
        public BusinessProfile $profile,
        public float $percentage,
        public float $amountPaid,
        public float $annualFee,
    ) {
    }
}
