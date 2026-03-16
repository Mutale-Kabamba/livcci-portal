<?php

namespace App\Mail;

use App\Models\BusinessProfile;
use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Address;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;

class RenewalReminderMail extends Mailable
{
    use Queueable, SerializesModels;

    public function __construct(public BusinessProfile $profile, public int $daysRemaining)
    {
    }

    public function envelope(): Envelope
    {
        return new Envelope(
            subject: 'LiVCCI Membership Renewal Reminder',
            from: new Address('livcci@oristudiozm.com', 'LiVCCI Secretariat'),
        );
    }

    public function content(): Content
    {
        return new Content(
            view: 'emails.renewal-reminder',
            with: [
                'profile' => $this->profile,
                'daysRemaining' => $this->daysRemaining,
            ],
        );
    }

    public function attachments(): array
    {
        return [];
    }
}
