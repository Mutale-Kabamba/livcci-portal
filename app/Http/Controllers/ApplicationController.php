<?php

namespace App\Http\Controllers;

use App\Http\Requests\UnifiedApplicationRequest;
use App\Mail\InvoiceIssuedMail;
use App\Models\BusinessProfile;
use App\Models\Invoice;
use App\Models\User;
use App\Services\BusinessProfileFileService;
use Illuminate\Http\RedirectResponse;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
use Inertia\Inertia;
use Inertia\Response;

class ApplicationController extends Controller
{
    private BusinessProfileFileService $fileService;

    public function __construct(BusinessProfileFileService $fileService)
    {
        $this->fileService = $fileService;
    }

    /**
     * Show the unified application form.
     */
    public function create(): Response
    {
        return Inertia::render('Application/Create');
    }

    /**
     * Store a unified application (create user account and business profile).
     */
    public function store(UnifiedApplicationRequest $request): RedirectResponse
    {
        try {
            $validated = $request->validated();

            // Use transaction to ensure atomicity
            DB::transaction(function () use ($request, &$validated) {
                // Create user account
                $user = User::create([
                    'name' => $validated['full_name'],
                    'email' => $validated['email'],
                    'password' => Hash::make($validated['password']),
                    'is_admin' => false,
                ]);

                // Handle logo file upload
                if ($request->hasFile('logo')) {
                    $validated['logo_url'] = $this->fileService->storeLogo($request->file('logo'));
                }

                if ($request->hasFile('proof_of_payment')) {
                    $validated['proof_of_payment_path'] = $request->file('proof_of_payment')->store('proof-payments', 'public');
                }

                // Handle document uploads
                $documentPaths = [];
                $documents = ['certificate_of_incorporation', 'tpin_certificate', 'zra_tax_clearance', 'napsa_certificate', 'wcfcb_certificate', 'company_profile'];
                foreach ($documents as $doc) {
                    if ($request->hasFile($doc)) {
                        $documentPaths[$doc] = $request->file($doc)->store('documents', 'public');
                    }
                }

                unset($validated['logo'], $validated['proof_of_payment'], $validated['password'], $validated['password_confirmation'], $validated['full_name']);

                $annualFee = $this->resolveAnnualFee($validated['member_category'] ?? null, $validated['member_type'] ?? null);
                $validated['annual_fee'] = $annualFee;
                $validated['total_paid'] = 0;
                $validated['is_active'] = false;
                $validated['status'] = 'pending';
                $validated['social_links'] = $this->sanitizeSocialLinks(
                    $validated['social_links'] ?? $request->input('social_links', [])
                );

                // Store document paths if any
                if (!empty($documentPaths)) {
                    $validated['document_paths'] = json_encode($documentPaths);
                }

                // Create the business profile linked to the newly created user
                $profile = BusinessProfile::create(array_merge($validated, [
                    'user_id' => $user->id,
                ]));

                $invoiceNumber = $this->generateInvoiceNumber();
                $invoice = Invoice::create([
                    'profile_id' => $profile->id,
                    'amount' => $annualFee,
                    'status' => 'Unpaid',
                    'invoice_number' => $invoiceNumber,
                    'due_date' => now()->addDays(30)->toDateString(),
                ]);

                $invoicePdfPath = $this->storePremiumInvoicePdf($profile->fresh(), $invoiceNumber, $annualFee);
                $profile->update([
                    'invoice_pdf_path' => $invoicePdfPath,
                ]);

                if (!blank($profile->contact_email)) {
                    try {
                        Mail::to($profile->contact_email)->send(new InvoiceIssuedMail($profile->fresh(), $invoice));
                    } catch (\Throwable $exception) {
                        \Log::warning('Failed to send initial invoice email', [
                            'profile_id' => $profile->id,
                            'invoice_id' => $invoice->id,
                            'error' => $exception->getMessage(),
                        ]);
                    }
                }
            });

            return redirect()->route('login')
                ->with('success', 'Application submitted successfully! Please log in with your credentials. Your profile will be reviewed shortly.');
        } catch (\Exception $e) {
            \Log::error('Error creating unified application: ' . $e->getMessage(), ['exception' => $e]);

            return back()
                ->withInput($request->except(['password', 'password_confirmation']))
                ->with('error', 'Failed to submit application. Please try again.');
        }
    }

    /**
     * Resolve annual membership fee based on category.
     */
    private function resolveAnnualFee(?string $memberCategory, ?string $memberType): float
    {
        $category = strtolower((string) $memberCategory);
        if (str_contains($category, 'corporate') || $memberType === 'Corporate') return 2000;
        if (str_contains($category, 'ordinary') || $memberType === 'Ordinary') return 1000;
        if (str_contains($category, 'associate') || str_contains($category, 'cooperative')) return 500;

        return 1000;
    }

    /**
     * Generate a unique invoice number.
     */
    private function generateInvoiceNumber(): string
    {
        $year = now()->format('Y');
        $prefix = 'INV-' . $year . '-';
        $nextSequence = 1;

        $lastInvoiceNumber = Invoice::query()
            ->where('invoice_number', 'like', $prefix . '%')
            ->latest('id')
            ->value('invoice_number');

        if ($lastInvoiceNumber && preg_match('/^INV-' . $year . '-(\d{3})$/', $lastInvoiceNumber, $matches)) {
            $nextSequence = ((int) $matches[1]) + 1;
        }

        do {
            $candidate = $prefix . str_pad((string) $nextSequence, 3, '0', STR_PAD_LEFT);
            $nextSequence++;
        } while (Invoice::where('invoice_number', $candidate)->exists());

        return $candidate;
    }

    /**
     * Store premium invoice as PDF.
     */
    private function storePremiumInvoicePdf(BusinessProfile $profile, string $invoiceNumber, float $annualFee): string
    {
        // Placeholder - implement PDF generation as needed
        $relativePath = 'invoices/profile-' . $profile->id . '-' . now()->format('YmdHis') . '.pdf';
        return $relativePath;
    }

    /**
     * Sanitize social links.
     */
    private function sanitizeSocialLinks(?array $links): array
    {
        if (!$links) {
            return [];
        }

        $sanitized = [];
        $allowed = ['linkedin', 'facebook', 'x', 'instagram', 'whatsapp'];

        foreach ($links as $platform => $url) {
            if (in_array($platform, $allowed) && !blank($url)) {
                $sanitized[$platform] = filter_var($url, FILTER_SANITIZE_URL);
            }
        }

        return $sanitized;
    }
}
