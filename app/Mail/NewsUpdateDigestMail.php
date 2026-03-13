<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Address;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;

class NewsUpdateDigestMail extends Mailable
{
    use Queueable, SerializesModels;

    public function __construct(public array $events)
    {
    }

    public function envelope(): Envelope
    {
        return new Envelope(
            subject: 'LiVCCI Updates - News & Events Digest',
            from: new Address((string) config('mail.from.address'), 'LiVCCI Secretariat'),
        );
    }

    public function content(): Content
    {
        return new Content(
            view: 'emails.news-update-digest',
            with: [
                'events' => $this->events,
            ],
        );
    }

    public function attachments(): array
    {
        return [];
    }
}
