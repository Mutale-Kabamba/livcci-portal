<?php

namespace App\Mail;

use App\Models\BusinessProfile;
use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Address;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;

class PaymentReceiptMail extends Mailable
{
    use Queueable, SerializesModels;

    public function __construct(
        public BusinessProfile $profile,
        public float $amount,
        public string $paymentDate,
        public string $paymentMethod,
        public ?string $reference = null,
        public ?string $receiptPdfPath = null,
    ) {
    }

    public function envelope(): Envelope
    {
        return new Envelope(
            subject: 'LiVCCI Payment Receipt - ' . $this->profile->company_name,
            from: new Address((string) config('mail.from.address'), 'LiVCCI Secretariat'),
        );
    }

    public function content(): Content
    {
        return new Content(
            view: 'emails.payment-receipt',
            with: [
                'profile' => $this->profile,
                'amount' => $this->amount,
                'paymentDate' => $this->paymentDate,
                'paymentMethod' => $this->paymentMethod,
                'reference' => $this->reference,
            ],
        );
    }

    public function attachments(): array
    {
        if (!$this->receiptPdfPath) {
            return [];
        }

        return [
            \Illuminate\Mail\Mailables\Attachment::fromStorageDisk('public', $this->receiptPdfPath)
                ->as('payment-receipt.pdf')
                ->withMime('application/pdf'),
        ];
    }
}
