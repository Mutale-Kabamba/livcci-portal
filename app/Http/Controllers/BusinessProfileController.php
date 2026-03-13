<?php

namespace App\Http\Controllers;

use App\Http\Requests\StoreBusinessProfileRequest;
use App\Http\Requests\UpdateBusinessProfileRequest;
use App\Models\BusinessPayment;
use App\Models\BusinessProfile;
use App\Models\Invoice;
use App\Services\BusinessProfileFileService;
use Barryvdh\DomPDF\Facade\Pdf;
use Illuminate\Http\RedirectResponse;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Inertia\Inertia;
use Inertia\Response;

class BusinessProfileController extends Controller
{
    private BusinessProfileFileService $fileService;

    public function __construct(BusinessProfileFileService $fileService)
    {
        $this->fileService = $fileService;
    }

    /**
     * Display a listing of approved business profiles in the directory.
     */
    public function index(): Response
    {
        $profiles = BusinessProfile::where('is_active', true)
            ->orderBy('company_name', 'asc')
            ->get();

        return Inertia::render('BusinessProfile/Index', [
            'profiles' => $profiles,
        ]);
    }

    /**
     * Show the form for creating a new business profile.
     */
    public function create(): Response|RedirectResponse
    {
        $profileCount = BusinessProfile::where('user_id', auth()->id())->count();

        if ($profileCount >= 4) {
            return redirect()->route('dashboard')
                ->with('error', 'You have reached the maximum of 4 business profiles.');
        }

        return Inertia::render('BusinessProfile/Create');
    }

    /**
     * Store a newly created business profile in database.
     */
    public function store(StoreBusinessProfileRequest $request): RedirectResponse
    {
        try {
            $validated = $request->validated();

            // Use transaction to ensure atomicity
            DB::transaction(function () use ($request, &$validated) {
                // Handle logo file upload
                if ($request->hasFile('logo')) {
                    $validated['logo_url'] = $this->fileService->storeLogo($request->file('logo'));
                }

                $annualFee = $this->resolveAnnualFee($validated['member_category'] ?? null, $validated['member_type'] ?? null);
                $validated['annual_fee'] = $annualFee;
                $validated['total_paid'] = 0;
                $validated['is_active'] = false;
                $validated['social_links'] = $this->sanitizeSocialLinks(
                    $validated['social_links'] ?? $request->input('social_links', [])
                );

                // Create the profile linked to the currently logged-in user
                $profile = BusinessProfile::create(array_merge($validated, [
                    'user_id' => $request->user()->id,
                ]));

                $invoiceNumber = $this->generateInvoiceNumber();
                Invoice::create([
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
            });

            return redirect()->route('dashboard')
                ->with('success', 'Business profile created successfully! Your profile is now pending approval.');
        } catch (\Exception $e) {
            \Log::error('Error creating business profile: ' . $e->getMessage());

            return back()
                ->withInput()
                ->with('error', 'Failed to create business profile. Please try again.');
        }
    }

    /**
     * Display the form for editing the authenticated user's business profile.
     */
    public function edit(): Response|RedirectResponse
    {
        $profile = auth()->user()->businessProfile;

        if (!$profile) {
            return redirect()->route('profile.business.create')
                ->with('error', 'Business profile not found. Please create one first.');
        }

        return Inertia::render('BusinessProfile/Edit', [
            'businessProfile' => $profile,
        ]);
    }

    /**
     * Update the authenticated user's business profile in database.
     */
    public function update(UpdateBusinessProfileRequest $request): RedirectResponse
    {
        try {
            $profile = auth()->user()->businessProfile;

            if (!$profile) {
                return redirect()->route('profile.business.create')
                    ->with('error', 'Business profile not found.');
            }

            // Authorize the user can update this profile
            $this->authorize('update', $profile);

            $validated = $request->validated();

            // Use transaction to ensure atomicity
            DB::transaction(function () use ($request, $profile, &$validated) {
                // Handle logo file upload
                if ($request->hasFile('logo')) {
                    $validated['logo_url'] = $this->fileService->replaceLogo(
                        $request->file('logo'),
                        $profile->logo_url
                    );
                }

                $validated['social_links'] = $this->sanitizeSocialLinks(
                    $validated['social_links'] ?? $request->input('social_links', [])
                );

                $profile->update($validated);
            });

            return redirect()->route('dashboard')
                ->with('success', 'Business profile updated successfully!');
        } catch (\Exception $e) {
            \Log::error('Error updating business profile: ' . $e->getMessage());

            return back()
                ->withInput()
                ->with('error', 'Failed to update business profile. Please try again.');
        }
    }

    /**
     * Display a single business profile (public view).
     */
    public function show(BusinessProfile $profile): Response
    {
        // Only allow viewing approved profiles publicly, or if user is admin/owner
        if (!$profile->is_active && auth()->id() !== $profile->user_id && !auth()->user()?->is_admin) {
            abort(403, 'This profile is not publicly available.');
        }

        return Inertia::render('BusinessProfile/Show', [
            'businessProfile' => $profile->load('user'),
        ]);
    }

    /**
     * Soft delete the authenticated user's business profile.
     */
    public function destroy(): RedirectResponse
    {
        try {
            $profile = auth()->user()->businessProfile;

            if (!$profile) {
                return back()->with('error', 'Business profile not found.');
            }

            // Authorize the user can delete this profile
            $this->authorize('delete', $profile);

            // Soft delete the profile
            $profile->delete();

            return redirect()->route('dashboard')
                ->with('success', 'Business profile has been deleted. You can recover it from your account settings.');
        } catch (\Exception $e) {
            \Log::error('Error deleting business profile: ' . $e->getMessage());

            return back()
                ->with('error', 'Failed to delete business profile. Please try again.');
        }
    }

    public function downloadInvoice(BusinessProfile $profile)
    {
        if (auth()->id() !== $profile->user_id && !auth()->user()?->is_admin) {
            abort(403);
        }

        if (!$profile->invoice_pdf_path || !Storage::disk('public')->exists($profile->invoice_pdf_path)) {
            return back()->with('error', 'Invoice file not found.');
        }

        return Storage::disk('public')->download(
            $profile->invoice_pdf_path,
            'invoice-' . $profile->id . '.pdf'
        );
    }

    public function downloadReceipt(BusinessPayment $payment)
    {
        $profile = $payment->profile;
        if (!$profile || (auth()->id() !== $profile->user_id && !auth()->user()?->is_admin)) {
            abort(403);
        }

        if (!$payment->receipt_pdf_path || !Storage::disk('public')->exists($payment->receipt_pdf_path)) {
            return back()->with('error', 'Receipt file not found.');
        }

        return Storage::disk('public')->download(
            $payment->receipt_pdf_path,
            'receipt-' . $payment->id . '.pdf'
        );
    }

    private function resolveAnnualFee(?string $memberCategory, ?string $memberType): int
    {
        $category = strtolower((string) $memberCategory);
        if (str_contains($category, 'corporate')) return 2000;
        if (str_contains($category, 'ordinary')) return 1000;
        if (str_contains($category, 'associate') || str_contains($category, 'cooperative')) return 500;

        return match ($memberType) {
            'Corporate' => 2000,
            'Ordinary' => 1000,
            'Associate', 'Cooperative' => 500,
            default => 500,
        };
    }

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

    private function storePremiumInvoicePdf(BusinessProfile $profile, string $invoiceNumber, float $annualFee): string
    {
        $pdf = Pdf::loadView('pdfs.premium-invoice', [
            'profile' => $profile,
            'invoiceNumber' => $invoiceNumber,
            'invoiceDate' => now(),
            'annualFee' => $annualFee,
            'minimumToActivate' => $annualFee * 0.5,
        ])->setPaper('a4', 'portrait');

        $relativePath = 'invoices/profile-' . $profile->id . '-' . now()->format('YmdHis') . '.pdf';
        Storage::disk('public')->put($relativePath, $pdf->output());

        return $relativePath;
    }

    private function sanitizeSocialLinks(mixed $input): ?array
    {
        if (!is_array($input)) {
            return null;
        }

        $allowedKeys = ['linkedin', 'facebook', 'x', 'instagram', 'whatsapp'];
        $sanitized = [];

        foreach ($allowedKeys as $key) {
            $url = trim((string) ($input[$key] ?? ''));
            if ($url === '') {
                continue;
            }

            if (!preg_match('/^https?:\/\//i', $url)) {
                $url = 'https://' . $url;
            }

            if (filter_var($url, FILTER_VALIDATE_URL)) {
                $sanitized[$key] = $url;
            }
        }

        return !empty($sanitized) ? $sanitized : null;
    }
}