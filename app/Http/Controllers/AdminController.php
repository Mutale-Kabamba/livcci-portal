<?php

namespace App\Http\Controllers;

use App\Events\PaymentThresholdReached;
use App\Mail\WelcomeApprovedMember;
use Barryvdh\DomPDF\Facade\Pdf;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Mail;
use Illuminate\Foundation\Application;
use Inertia\Inertia;
use App\Models\BusinessPayment;
use App\Models\BusinessProfile;
use App\Models\ChamberEvent;
use App\Models\Invoice;
use App\Models\Setting;
use App\Models\SiteContent;
use App\Models\User;

class AdminController extends Controller
{
    public function accounts()
    {
        $users = User::query()
            ->select(['id', 'name', 'email', 'is_admin', 'role', 'email_verified_at', 'created_at'])
            ->latest()
            ->get();

        return Inertia::render('Admin/Accounts', [
            'users' => $users,
        ]);
    }

    public function updateAccountRole(Request $request, User $user)
    {
        $validated = $request->validate([
            'is_admin' => 'required|boolean',
            'role' => 'nullable|in:super_admin,finance,finance_officer,media,media_officer,media_communication,secretariat',
        ]);

        if ((int) $user->id === (int) auth()->id() && !$validated['is_admin']) {
            return back()->with('error', 'You cannot remove your own admin access.');
        }

        if ($user->is_admin && !$validated['is_admin']) {
            $adminCount = User::where('is_admin', true)->count();
            if ($adminCount <= 1) {
                return back()->with('error', 'At least one admin account must remain.');
            }
        }

        $role = $validated['role'] ?? $user->role;

        if ($validated['is_admin'] && blank($role)) {
            $role = 'secretariat';
        }

        User::whereKey($user->id)->update([
            'is_admin' => $validated['is_admin'],
            'role' => $role,
        ]);

        return back()->with('message', 'Account role updated successfully.');
    }

    public function deleteAccount(User $user)
    {
        if ((int) $user->id === (int) auth()->id()) {
            return back()->with('error', 'You cannot delete your own account from this page.');
        }

        if ($user->is_admin) {
            $adminCount = User::where('is_admin', true)->count();
            if ($adminCount <= 1) {
                return back()->with('error', 'At least one admin account must remain.');
            }
        }

        $user->delete();

        return back()->with('message', 'Account deleted successfully.');
    }

    public function dashboard()
    {
        $user = auth()->user();
        $canManageFinance = $user?->can('manage_finance') ?? false;
        $canManageMembers = $user?->can('manage_members') ?? false;

        $profiles = BusinessProfile::with([
                'user',
                'payments' => fn ($query) => $query->latest('payment_date')->latest('id'),
            ])
            ->latest()
            ->get()
            ->map(function (BusinessProfile $profile) {
                $effectiveType = $profile->membership_type ?: $profile->member_type;
                $annualFee = (float) ($profile->annual_fee ?? 0);
                if ($annualFee <= 0 && $effectiveType) {
                    $annualFee = $this->resolveMembershipAmount((string) $effectiveType);
                }
                $amountPaid = (float) ($profile->total_paid ?? 0);
                if ($amountPaid <= 0) {
                    $amountPaid = (float) $profile->payments->sum('amount');
                }
                $percentage = $annualFee > 0 ? round(($amountPaid / $annualFee) * 100, 2) : 0;

                $profile->setAttribute('annual_fee', $annualFee);
                $profile->setAttribute('amount_paid', $amountPaid);
                $profile->setAttribute('payment_percentage', $percentage);

                return $profile;
            });

        if (!$canManageMembers && !$canManageFinance) {
            // Content-focused roles should not receive TPIN/PACRA or payment-sensitive fields.
            $profiles = $profiles->map(function (BusinessProfile $profile) {
                return [
                    'id' => $profile->id,
                    'company_name' => $profile->company_name,
                    'status' => $profile->status,
                    'member_category' => $profile->member_category,
                    'industry_sector' => $profile->industry_sector,
                ];
            });
        }

        $events = ChamberEvent::latest()->get();
        $invoices = $canManageFinance
            ? Invoice::with('businessProfile:id,company_name,membership_id,membership_type')->latest()->get()
            : collect();
        $siteContents = SiteContent::orderBy('page')->orderBy('section')->get();
        $strategicPlan = $this->getStrategicPlanProgress();

        $totalExpectedRevenue = $profiles->sum(function (BusinessProfile $profile): int {
            if ((float) ($profile->annual_fee ?? 0) > 0) {
                return (float) $profile->annual_fee;
            }

            if ($profile->membership_type) {
                return $this->resolveMembershipAmount($profile->membership_type);
            }

            return 0;
        });

        $totalActualRevenue = (float) Invoice::query()
            ->where('status', 'Paid')
            ->sum('amount');

        $collectionPercentage = $totalExpectedRevenue > 0
            ? round(($totalActualRevenue / $totalExpectedRevenue) * 100, 2)
            : 0;

        $revenueCollectedToday = (float) BusinessPayment::query()
            ->whereDate('payment_date', now()->toDateString())
            ->sum('amount');

        $totalOutstandingReceivables = (float) BusinessProfile::query()
            ->get(['annual_fee', 'total_paid'])
            ->sum(function (BusinessProfile $profile) {
                return max(0, (float) ($profile->annual_fee ?? 0) - (float) ($profile->total_paid ?? 0));
            });

        $activationPipeline = BusinessProfile::query()
            ->where('total_paid', '>', 0)
            ->whereRaw('annual_fee > 0')
            ->whereRaw('(total_paid / annual_fee) < 0.5')
            ->count();

        $sectorStats = BusinessProfile::query()
            ->where('status', 'approved')
            ->selectRaw('industry_sector as sector, COUNT(*) as count')
            ->whereNotNull('industry_sector')
            ->groupBy('industry_sector')
            ->orderByDesc('count')
            ->get();

        $financialHealth = [
            'totalExpectedRevenue' => $totalExpectedRevenue,
            'totalActualRevenue' => $totalActualRevenue,
            'collectionPercentage' => $collectionPercentage,
            'revenueCollectedToday' => $revenueCollectedToday,
            'totalOutstandingReceivables' => $totalOutstandingReceivables,
            'activationPipeline' => $activationPipeline,
        ];

        if (!$canManageFinance) {
            $financialHealth = [
                'totalExpectedRevenue' => 0,
                'totalActualRevenue' => 0,
                'collectionPercentage' => 0,
                'revenueCollectedToday' => 0,
                'totalOutstandingReceivables' => 0,
                'activationPipeline' => 0,
            ];
        }

        return Inertia::render('Admin/Dashboard', [
            'profiles' => $profiles,
            'events' => $events,
            'invoices' => $invoices,
            'siteContents' => $siteContents,
            'strategicPlan' => $strategicPlan,
            'financialHealth' => $financialHealth,
            'sectorStats' => $sectorStats,
            'flash' => [
                'message' => session('message')
            ]
        ]);
    }

    public function saveStrategicPlan(Request $request)
    {
        $validated = $request->validate([
            'goal_1' => 'required|integer|min:0|max:100',
            'goal_2' => 'required|integer|min:0|max:100',
            'goal_3' => 'required|integer|min:0|max:100',
            'goal_4' => 'required|integer|min:0|max:100',
            'goal_5' => 'required|integer|min:0|max:100',
        ]);

        foreach ($validated as $key => $value) {
            Setting::updateOrCreate(
                ['key' => 'strategic_plan_' . $key],
                ['value' => (string) $value]
            );
        }

        return back()->with('message', 'Strategic plan progress saved successfully.');
    }

    public function upsertSiteContent(Request $request)
    {
        $validated = $request->validate([
            'page' => 'required|string|max:100',
            'section' => 'required|string|max:100',
            'content' => 'required|array',
        ]);

        if ($validated['page'] === 'leadership' && $validated['section'] === 'board_members') {
            $leadership = $request->validate([
                'content' => 'required|array|min:1',
                'content.*.name' => 'required|string|max:120',
                'content.*.position' => 'required|string|max:120',
                'content.*.gender' => 'required|in:male,female',
                'content.*.contact' => 'nullable|array',
                'content.*.contact.phone' => 'nullable|string|max:40',
                'content.*.contact.whatsapp' => 'nullable|string|max:120',
                'content.*.contact.facebook' => 'nullable|url|max:255',
                'content.*.contact.linkedin' => 'nullable|url|max:255',
            ]);

            $validated['content'] = collect($leadership['content'])
                ->map(function (array $member) {
                    $contact = $member['contact'] ?? [];

                    return [
                        'name' => trim((string) ($member['name'] ?? '')),
                        'position' => trim((string) ($member['position'] ?? '')),
                        'gender' => ($member['gender'] ?? 'male') === 'female' ? 'female' : 'male',
                        'contact' => [
                            'phone' => trim((string) ($contact['phone'] ?? '')),
                            'whatsapp' => trim((string) ($contact['whatsapp'] ?? '')),
                            'facebook' => trim((string) ($contact['facebook'] ?? '')),
                            'linkedin' => trim((string) ($contact['linkedin'] ?? '')),
                        ],
                    ];
                })
                ->values()
                ->all();
        }

        SiteContent::updateOrCreate(
            [
                'page' => $validated['page'],
                'section' => $validated['section'],
            ],
            [
                'content' => $validated['content'],
            ]
        );

        return back()->with('message', 'Frontend content saved successfully.');
    }

    public function deleteSiteContent(SiteContent $content)
    {
        $content->delete();

        return back()->with('message', 'Frontend content deleted successfully.');
    }

    // 1. Logic to Update Status (Approve, Deactivate, Suspend)
    public function updateMemberStatus(Request $request, BusinessProfile $profile) 
    {
        try {
            $validated = $request->validate([
                'status' => 'required|in:pending,approved,suspended,deactivated'
            ]);

            $oldStatus = $profile->status;
            $newStatus = $validated['status'];

            $profile->update(['status' => $newStatus]);

            if ($oldStatus !== 'approved' && $newStatus === 'approved' && $profile->contact_email) {
                try {
                    Mail::to($profile->contact_email)->send(new WelcomeApprovedMember($profile));
                } catch (\Throwable $mailException) {
                    \Log::warning('Failed to send approved-member welcome email', [
                        'profile_id' => $profile->id,
                        'email' => $profile->contact_email,
                        'error' => $mailException->getMessage(),
                    ]);
                }
            }

            // Log the status change for audit trail
            \Log::info('Business profile status updated', [
                'profile_id' => $profile->id,
                'company_name' => $profile->company_name,
                'old_status' => $oldStatus,
                'new_status' => $newStatus,
                'admin_id' => auth()->id(),
                'timestamp' => now()
            ]);

            return back()->with('success', "Member status updated from '{$oldStatus}' to '{$newStatus}'.");
        } catch (\Exception $e) {
            \Log::error('Error updating member status: ' . $e->getMessage());
            return back()->with('error', 'Failed to update member status. Please try again.');
        }
    }

    // 2. Logic to Delete a Member (Hard delete - permanent removal)
    public function deleteMember(BusinessProfile $profile)
    {
        try {
            $companyName = $profile->company_name;
            $profileId = $profile->id;
            $userId = $profile->user_id;

            // Hard delete the profile (permanent removal)
            $profile->forceDelete();

            // Log the deletion for audit trail
            \Log::warning('Business profile permanently deleted', [
                'profile_id' => $profileId,
                'company_name' => $companyName,
                'user_id' => $userId,
                'admin_id' => auth()->id(),
                'timestamp' => now()
            ]);

            return back()->with('success', "Member profile '{$companyName}' has been permanently deleted.");
        } catch (\Exception $e) {
            \Log::error('Error deleting member profile: ' . $e->getMessage());
            return back()->with('error', 'Failed to delete member profile. Please try again.');
        }
    }

    public function downloadCertificate(BusinessProfile $profile)
    {
        if ($profile->status !== 'approved') {
            return back()->with('error', 'Certificates can only be downloaded for approved members.');
        }

        $validUntil = $profile->subscription_expiry ?? now()->addYear();

        $pdf = Pdf::loadView('emails.certificate', [
            'profile' => $profile,
            'validUntil' => $validUntil,
            'issueDate' => now(),
        ])->setPaper('a4', 'portrait');

        return $pdf->download('membership-certificate-' . $profile->id . '.pdf');
    }

    public function generateInvoice(BusinessProfile $profile)
    {
        if (!$profile->membership_type) {
            return back()->with('error', 'Membership type is required before generating an invoice.');
        }

        $amount = $this->resolveMembershipAmount($profile->membership_type);

        Invoice::create([
            'profile_id' => $profile->id,
            'amount' => $amount,
            'status' => 'Unpaid',
            'invoice_number' => $this->generateInvoiceNumber(),
            'due_date' => now()->addDays(30)->toDateString(),
        ]);

        // New cycle: reset paid amount against latest annual fee and re-evaluate active status.
        $profile->update([
            'annual_fee' => $amount,
            'total_paid' => 0,
        ]);
        $profile->reevaluateFinancialHealth();

        return back()->with('message', 'Invoice generated successfully.');
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'profile_id' => 'required|exists:business_profiles,id',
        ]);

        $profile = BusinessProfile::query()
            ->select(['id', 'membership_type'])
            ->findOrFail($validated['profile_id']);

        if (!$profile->membership_type) {
            return back()->with('error', 'Membership type is required before generating an invoice.');
        }

        $amount = $this->resolveMembershipAmount($profile->membership_type);

        Invoice::create([
            'profile_id' => $profile->id,
            'amount' => $amount,
            'status' => 'Unpaid',
            'invoice_number' => $this->generateInvoiceNumber(),
            'due_date' => now()->addDays(30)->toDateString(),
        ]);

        // New cycle: reset paid amount against latest annual fee and re-evaluate active status.
        $profile->update([
            'annual_fee' => $amount,
            'total_paid' => 0,
        ]);
        $profile->reevaluateFinancialHealth();

        return back()->with('message', 'Invoice generated successfully.');
    }

    public function markAsPaid(Invoice $invoice)
    {
        if ($invoice->status === 'Paid') {
            return back()->with('message', 'Invoice is already marked as paid.');
        }

        $today = now()->toDateString();
        $profile = $invoice->profile;
        $wasActive = (bool) $profile->is_active;

        $invoice->update([
            'status' => 'Paid',
        ]);

        $profile->update([
            'annual_fee' => $profile->annual_fee > 0 ? $profile->annual_fee : $invoice->amount,
            'total_paid' => (float) ($profile->total_paid ?? 0) + (float) $invoice->amount,
            'last_payment_date' => $today,
            'subscription_expiry' => now()->addYear()->toDateString(),
        ]);

        $profile->refresh();
        $profile->reevaluateFinancialHealth();

        if (!$wasActive && $profile->fresh()->is_active) {
            event(new PaymentThresholdReached(
                $profile->fresh(),
                $profile->fresh()->payment_percentage,
                (float) ($profile->fresh()->total_paid ?? 0),
                (float) ($profile->fresh()->annual_fee ?? 0),
            ));
        }

        return back()->with('message', 'Invoice marked as paid and membership updated.');
    }

    public function recordPayment(Request $request, BusinessProfile $profile)
    {
        $validated = $request->validate([
            'amount' => 'required|numeric|min:0.01',
            'payment_method' => 'required|in:Cash,Airtel Money,Bank Transfer',
            'reference' => 'nullable|string|max:255',
            'payment_date' => 'required|date',
        ]);

        $wasActive = (bool) $profile->is_active;

        $payment = BusinessPayment::create([
            'profile_id' => $profile->id,
            'amount' => $validated['amount'],
            'payment_method' => $validated['payment_method'],
            'reference' => $validated['reference'] ?? null,
            'reference_number' => $validated['reference'] ?? null,
            'payment_date' => $validated['payment_date'],
        ]);

        $receiptPdfPath = $this->storePaymentReceiptPdf($profile->fresh(), $payment);
        $payment->update(['receipt_pdf_path' => $receiptPdfPath]);

        $effectiveType = $profile->membership_type ?: $profile->member_type;
        $annualFee = (float) ($profile->annual_fee ?? 0);
        if ($annualFee <= 0 && $effectiveType) {
            $annualFee = $this->resolveMembershipAmount((string) $effectiveType);
        }

        $profile->update([
            'annual_fee' => $annualFee,
            'total_paid' => (float) ($profile->total_paid ?? 0) + (float) $validated['amount'],
            'last_payment_date' => $validated['payment_date'],
        ]);

        $profile->refresh();
        $profile->reevaluateFinancialHealth();
        $profile->refresh();

        if (!$wasActive && $profile->is_active) {
            event(new PaymentThresholdReached(
                $profile,
                $profile->payment_percentage,
                (float) ($profile->total_paid ?? 0),
                (float) ($profile->annual_fee ?? 0),
            ));
        }

        return back()->with('message', 'Payment recorded successfully.');
    }

    private function storePaymentReceiptPdf(BusinessProfile $profile, BusinessPayment $payment): string
    {
        $pdf = Pdf::loadView('pdfs.payment-receipt', [
            'profile' => $profile,
            'payment' => $payment,
        ])->setPaper('a4', 'portrait');

        $relativePath = 'receipts/profile-' . $profile->id . '-payment-' . $payment->id . '.pdf';
        Storage::disk('public')->put($relativePath, $pdf->output());

        return $relativePath;
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

    private function resolveMembershipAmount(string $membershipType): int
    {
        return match ($membershipType) {
            'Corporate' => 2000,
            'Ordinary' => 1000,
            'Associate', 'Cooperative' => 500,
            default => 500,
        };
    }

    // 3. Logic to Add News/Events
    public function storeEvent(Request $request)
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'type' => 'required|in:Meeting,Workshop,Expo,News',
            'event_date' => 'nullable|date',
            'description' => 'required|string',
            'external_link' => 'nullable|url',
            'image' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:5120',
        ]);

        $data = [
            'title' => $validated['title'],
            'type' => $validated['type'],
            'event_date' => $validated['event_date'],
            'description' => $validated['description'],
            'external_link' => $validated['external_link'] ?? null,
        ];

        if ($request->hasFile('image')) {
            $file = $request->file('image');
            $path = $file->store('events', 'public');
            $data['image_url'] = $path;
        }

        ChamberEvent::create($data);

        return back()->with('message', 'Event posted successfully!');
    }

    // 3b. Logic to Update News/Events
    public function updateEvent(Request $request, ChamberEvent $event)
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'type' => 'required|in:Meeting,Workshop,Expo,News',
            'event_date' => 'nullable|date',
            'description' => 'required|string',
            'external_link' => 'nullable|url',
            'image' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:5120',
        ]);

        $data = [
            'title' => $validated['title'],
            'type' => $validated['type'],
            'event_date' => $validated['event_date'],
            'description' => $validated['description'],
            'external_link' => $validated['external_link'] ?? null,
        ];

        if ($request->hasFile('image')) {
            $file = $request->file('image');
            $path = $file->store('events', 'public');
            $data['image_url'] = $path;
        }

        $event->update($data);

        if ($request->expectsJson() || $request->header('X-Requested-With') === 'XMLHttpRequest') {
            return response()->json(['message' => 'Event updated successfully!'], 200);
        }

        return back()->with('message', 'Event updated successfully!');
    }

    // 3c. Logic to Delete News/Events
    public function deleteEvent(ChamberEvent $event)
    {
        $event->delete();
        return back()->with('message', 'Event deleted successfully!');
    }

    // 4. Display News/Events on the public page
    public function showNews()
    {
        $events = ChamberEvent::latest()->get();
        
        return Inertia::render('News', [
            'events' => $events
        ]);
    }

    // 5. Display Home page with featured content
    public function showHome()
    {
        $events = ChamberEvent::latest()->limit(2)->get();
        $approvedMembers = BusinessProfile::where('status', 'approved')->get();
        $content = $this->getPageContent('home');
        
        return Inertia::render('Welcome', [
            'canLogin' => Route::has('login'),
            'canRegister' => Route::has('register'),
            'events' => $events,
            'approvedMembers' => $approvedMembers,
            'content' => $content,
        ]);
    }

    public function showAbout()
    {
        return Inertia::render('About', [
            'content' => $this->getPageContent('about'),
        ]);
    }

    public function showSectors()
    {
        return Inertia::render('Sectors', [
            'content' => $this->getPageContent('sectors'),
        ]);
    }

    public function showLeadership()
    {
        return Inertia::render('Leadership', [
            'content' => $this->getPageContent('leadership'),
        ]);
    }

    public function showMembership()
    {
        return Inertia::render('Membership', [
            'content' => $this->getPageContent('membership'),
        ]);
    }

    public function showStrategicGoals()
    {
        return Inertia::render('StrategicGoals', [
            'content' => $this->getPageContent('strategic-goals'),
        ]);
    }

    public function showStrategicGoalDetail(string $slug)
    {
        $goals = $this->getStrategicGoalDetails();

        if (!array_key_exists($slug, $goals)) {
            abort(404);
        }

        return Inertia::render('StrategicGoalDetail', [
            'goal' => $goals[$slug],
            'allGoals' => collect($goals)
                ->map(fn (array $goal) => [
                    'slug' => $goal['slug'],
                    'number' => $goal['number'],
                    'title' => $goal['title'],
                ])
                ->values()
                ->all(),
        ]);
    }

    private function getPageContent(string $page): array
    {
        return SiteContent::where('page', $page)
            ->get()
            ->mapWithKeys(function (SiteContent $item) {
                return [$item->section => $item->content];
            })
            ->toArray();
    }

    private function getStrategicPlanProgress(): array
    {
        $defaults = [
            'goal_1' => 0,
            'goal_2' => 0,
            'goal_3' => 0,
            'goal_4' => 0,
            'goal_5' => 0,
        ];

        $stored = Setting::query()
            ->whereIn('key', [
                'strategic_plan_goal_1',
                'strategic_plan_goal_2',
                'strategic_plan_goal_3',
                'strategic_plan_goal_4',
                'strategic_plan_goal_5',
            ])
            ->pluck('value', 'key');

        foreach (array_keys($defaults) as $goalKey) {
            $storedKey = 'strategic_plan_' . $goalKey;
            if ($stored->has($storedKey)) {
                $defaults[$goalKey] = max(0, min(100, (int) $stored->get($storedKey)));
            }
        }

        return $defaults;
    }

    private function getStrategicGoalDetails(): array
    {
        return [
            'goal-1' => [
                'slug' => 'goal-1',
                'number' => 1,
                'title' => 'Strengthened Governance and Institutional Capacity',
                'tagline' => 'Building a high-performance chamber institution with robust systems and accountable leadership.',
                'heroImage' => 'https://images.unsplash.com/photo-1552664730-d307ca884978?auto=format&fit=crop&w=1800&q=80',
                'overview' => 'This goal focuses on strengthening LiVCCI internal governance, improving organizational systems, and ensuring operational continuity through strong leadership and policy discipline.',
                'outcomes' => [
                    'Clear and enforceable governance structures across board and secretariat functions.',
                    'Improved operational controls, policy compliance, and role accountability.',
                    'Reliable institutional memory through documented processes and digital records.',
                ],
                'initiatives' => [
                    ['title' => 'Governance Charter Refresh', 'description' => 'Review board charters and governance policies to align with current strategic priorities and legal obligations.'],
                    ['title' => 'Secretariat Capacity Program', 'description' => 'Develop management and technical competencies through annual training and mentorship.'],
                    ['title' => 'Digital Operations Backbone', 'description' => 'Standardize documentation, workflows, and reporting on a central digital platform.'],
                ],
                'kpis' => [
                    ['label' => 'Policy Compliance Rate', 'target' => '95%'],
                    ['label' => 'Internal Process Automation', 'target' => '80%'],
                    ['label' => 'Annual Governance Reviews', 'target' => '4'],
                ],
            ],
            'goal-2' => [
                'slug' => 'goal-2',
                'number' => 2,
                'title' => 'Enhanced Member Services and Value Proposition',
                'tagline' => 'Delivering practical, measurable value that helps members grow and remain competitive.',
                'heroImage' => 'https://images.unsplash.com/photo-1521737604893-d14cc237f11d?auto=format&fit=crop&w=1800&q=80',
                'overview' => 'LiVCCI will elevate member experience through tailored services, stronger engagement pathways, and evidence-based support programs that respond to real business needs.',
                'outcomes' => [
                    'Higher member satisfaction and retention across all categories.',
                    'Expanded portfolio of high-impact support services and training programs.',
                    'Improved member participation in chamber events and initiatives.',
                ],
                'initiatives' => [
                    ['title' => 'Member Experience Redesign', 'description' => 'Improve onboarding, service tracking, and response times through structured service standards.'],
                    ['title' => 'Business Growth Clinics', 'description' => 'Quarterly expert-led sessions on finance, compliance, market access, and operations.'],
                    ['title' => 'Sector-Specific Networking Series', 'description' => 'Curated networking forums aligned to priority sectors and investment opportunities.'],
                ],
                'kpis' => [
                    ['label' => 'Member Retention Rate', 'target' => '85%'],
                    ['label' => 'Average Event Participation', 'target' => '300+ / quarter'],
                    ['label' => 'Service Satisfaction Score', 'target' => '4.5/5'],
                ],
            ],
            'goal-3' => [
                'slug' => 'goal-3',
                'number' => 3,
                'title' => 'Dynamic Advocacy and Strategic Partnerships',
                'tagline' => 'Positioning LiVCCI as a trusted voice for business and a catalyst for collaborative growth.',
                'heroImage' => 'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?auto=format&fit=crop&w=1800&q=80',
                'overview' => 'This goal advances LiVCCI advocacy influence and strengthens partnerships with public and private stakeholders to shape an enabling business climate in Livingstone and beyond.',
                'outcomes' => [
                    'Stronger policy influence through coordinated advocacy with evidence-backed proposals.',
                    'Formalized partnerships with key institutions and development agencies.',
                    'Increased visibility of member priorities in public policy dialogue.',
                ],
                'initiatives' => [
                    ['title' => 'Policy Position Papers', 'description' => 'Develop annual policy briefs based on member feedback and sector data.'],
                    ['title' => 'Public-Private Dialogue Forums', 'description' => 'Host structured roundtables with government and regulatory institutions.'],
                    ['title' => 'Strategic Partnership Framework', 'description' => 'Define, negotiate, and track partnership outcomes with clear targets and responsibilities.'],
                ],
                'kpis' => [
                    ['label' => 'Policy Submissions per Year', 'target' => '10+'],
                    ['label' => 'Active Strategic MoUs', 'target' => '12'],
                    ['label' => 'Advocacy Engagement Sessions', 'target' => '24 / year'],
                ],
            ],
            'goal-4' => [
                'slug' => 'goal-4',
                'number' => 4,
                'title' => 'Financial Sustainability and Resource Mobilization',
                'tagline' => 'Securing resilient revenue streams to sustain long-term impact and service delivery.',
                'heroImage' => 'https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?auto=format&fit=crop&w=1800&q=80',
                'overview' => 'LiVCCI will strengthen financial health through diversified income channels, strategic budgeting, and resource mobilization partnerships that reduce dependency risk.',
                'outcomes' => [
                    'More predictable and diversified annual revenue mix.',
                    'Improved budget execution and financial reporting quality.',
                    'Increased investment in member-facing strategic programs.',
                ],
                'initiatives' => [
                    ['title' => 'Revenue Diversification Plan', 'description' => 'Expand non-dues revenue through events, advisory services, and sponsorship products.'],
                    ['title' => 'Grant & Donor Pipeline', 'description' => 'Build proposal capacity and maintain an annual calendar for funding opportunities.'],
                    ['title' => 'Financial Governance Strengthening', 'description' => 'Introduce tighter forecasting, cash-flow controls, and board-level financial dashboards.'],
                ],
                'kpis' => [
                    ['label' => 'Non-Dues Revenue Share', 'target' => '40%'],
                    ['label' => 'Budget Variance', 'target' => '< 8%'],
                    ['label' => 'Annual Resource Mobilization Value', 'target' => 'ZMW 5M+'],
                ],
            ],
            'goal-5' => [
                'slug' => 'goal-5',
                'number' => 5,
                'title' => 'Communication, Publicity, and Research',
                'tagline' => 'Enhancing market visibility and decision-making through strategic communication and intelligence.',
                'heroImage' => 'https://images.unsplash.com/photo-1504711434969-e33886168f5c?auto=format&fit=crop&w=1800&q=80',
                'overview' => 'LiVCCI will improve communication reach, strengthen public brand visibility, and institutionalize business intelligence to support informed advocacy and member growth.',
                'outcomes' => [
                    'Higher public visibility and stronger chamber brand recognition.',
                    'Regular publication of business intelligence for members and stakeholders.',
                    'Improved communication consistency across digital and offline channels.',
                ],
                'initiatives' => [
                    ['title' => 'Integrated Communication Calendar', 'description' => 'Coordinate campaigns, media outreach, and event publicity through annual planning.'],
                    ['title' => 'Business Insight Reports', 'description' => 'Publish periodic market and policy research briefs focused on member sectors.'],
                    ['title' => 'Digital Reach Acceleration', 'description' => 'Expand website, newsletter, and social channels for stronger stakeholder engagement.'],
                ],
                'kpis' => [
                    ['label' => 'Research Briefs Published', 'target' => '12 / year'],
                    ['label' => 'Digital Audience Growth', 'target' => '+50%'],
                    ['label' => 'Media Mentions', 'target' => '100+ / year'],
                ],
            ],
        ];
    }
}