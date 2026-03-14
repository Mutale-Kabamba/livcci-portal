<?php

namespace App\Mail;

use App\Models\BusinessProfile;
use App\Models\User;
use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Address;
use Illuminate\Mail\Mailables\Attachment;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;

class WelcomeMember extends Mailable
{
    use Queueable, SerializesModels;

    public function __construct(
        public User $user,
        public ?BusinessProfile $profile = null,
    ) {
    }

    public function envelope(): Envelope
    {
        return new Envelope(
            subject: 'Welcome to LiVCCI Member Portal',
            from: new Address('livcci@oristudiozm.com', 'LiVCCI Secretariat'),
        );
    }

    public function content(): Content
    {
        return new Content(
            view: 'emails.welcome-member',
            with: [
                'user' => $this->user,
                'profile' => $this->profile,
            ],
        );
    }

    public function attachments(): array
    {
        if (!$this->profile?->invoice_pdf_path) {
            return [];
        }

        return [
            Attachment::fromStorageDisk('public', ltrim(str_replace('/storage/', '', $this->profile->invoice_pdf_path), '/'))
                ->as('Invoice.pdf')
                ->withMime('application/pdf'),
        ];
    }
}
