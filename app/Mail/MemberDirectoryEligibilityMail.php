<?php

namespace App\Mail;

use App\Models\BusinessProfile;
use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Address;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;

class MemberDirectoryEligibilityMail extends Mailable
{
    use Queueable, SerializesModels;

    public function __construct(
        public BusinessProfile $profile,
        public float $percentage,
        public float $amountPaid,
        public float $annualFee,
    ) {
    }

    public function envelope(): Envelope
    {
        return new Envelope(
            subject: 'LiVCCI Update - Eligible for Directory Listing',
            from: new Address((string) config('mail.from.address'), 'LiVCCI Secretariat'),
        );
    }

    public function content(): Content
    {
        return new Content(
            view: 'emails.member-directory-eligibility',
            with: [
                'profile' => $this->profile,
                'percentage' => $this->percentage,
                'amountPaid' => $this->amountPaid,
                'annualFee' => $this->annualFee,
            ],
        );
    }

    public function attachments(): array
    {
        return [];
    }
}
