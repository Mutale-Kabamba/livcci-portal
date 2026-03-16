<?php

namespace App\Mail;

use App\Models\BusinessProfile;
use App\Models\Invoice;
use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Address;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;

class InvoiceIssuedMail extends Mailable
{
    use Queueable, SerializesModels;

    public function __construct(public BusinessProfile $profile, public Invoice $invoice)
    {
    }

    public function envelope(): Envelope
    {
        return new Envelope(
            subject: 'LiVCCI Invoice Issued - ' . $this->invoice->invoice_number,
            from: new Address('livcci@oristudiozm.com', 'LiVCCI Secretariat'),
        );
    }

    public function content(): Content
    {
        return new Content(
            view: 'emails.invoice-issued',
            with: [
                'profile' => $this->profile,
                'invoice' => $this->invoice,
            ],
        );
    }

    public function attachments(): array
    {
        return [];
    }
}
