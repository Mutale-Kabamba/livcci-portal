<?php

namespace App\Mail;

use App\Models\BusinessProfile;
use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;

class WelcomeApprovedMember extends Mailable
{
    use Queueable, SerializesModels;

    public function __construct(public BusinessProfile $profile)
    {
    }

    public function envelope(): Envelope
    {
        return new Envelope(
            subject: 'Welcome to LiVCCI - Membership Approved',
        );
    }

    public function content(): Content
    {
        return new Content(
            view: 'emails.welcome-approved-member',
            with: [
                'profile' => $this->profile,
            ],
        );
    }

    public function attachments(): array
    {
        return [];
    }
}
