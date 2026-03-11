<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Storage;
use Illuminate\Foundation\Application;
use Inertia\Inertia;
use App\Models\BusinessProfile;
use App\Models\ChamberEvent;
use App\Models\Invoice;
use App\Models\SiteContent;
use App\Models\User;

class AdminController extends Controller
{
    public function accounts()
    {
        $users = User::query()
            ->select(['id', 'name', 'email', 'is_admin', 'email_verified_at', 'created_at'])
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

        User::whereKey($user->id)->update([
            'is_admin' => $validated['is_admin'],
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
        $profiles = BusinessProfile::with('user')->latest()->get();
        $events = ChamberEvent::latest()->get();
        $siteContents = SiteContent::orderBy('page')->orderBy('section')->get();

        return Inertia::render('Admin/Dashboard', [
            'profiles' => $profiles,
            'events' => $events,
            'siteContents' => $siteContents,
            'flash' => [
                'message' => session('message')
            ]
        ]);
    }

    public function upsertSiteContent(Request $request)
    {
        $validated = $request->validate([
            'page' => 'required|string|max:100',
            'section' => 'required|string|max:100',
            'content' => 'required|array',
        ]);

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

    public function generateInvoice(BusinessProfile $profile)
    {
        if (!$profile->membership_type) {
            return back()->with('error', 'Membership type is required before generating an invoice.');
        }

        $amount = match ($profile->membership_type) {
            'Corporate' => 2000,
            'Ordinary' => 1000,
            'Associate', 'Cooperative' => 500,
            default => 500,
        };

        Invoice::create([
            'profile_id' => $profile->id,
            'amount' => $amount,
            'status' => 'Unpaid',
            'invoice_number' => $this->generateInvoiceNumber(),
            'due_date' => now()->addDays(30)->toDateString(),
        ]);

        return back()->with('message', 'Invoice generated successfully.');
    }

    public function markAsPaid(Invoice $invoice)
    {
        $today = now()->toDateString();

        $invoice->update([
            'status' => 'Paid',
        ]);

        $invoice->profile()->update([
            'last_payment_date' => $today,
            'subscription_expiry' => now()->addYear()->toDateString(),
        ]);

        return back()->with('message', 'Invoice marked as paid and membership updated.');
    }

    private function generateInvoiceNumber(): string
    {
        do {
            $candidate = 'INV-' . now()->format('Ymd') . '-' . strtoupper(substr(bin2hex(random_bytes(3)), 0, 6));
        } while (Invoice::where('invoice_number', $candidate)->exists());

        return $candidate;
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

    private function getPageContent(string $page): array
    {
        return SiteContent::where('page', $page)
            ->get()
            ->mapWithKeys(function (SiteContent $item) {
                return [$item->section => $item->content];
            })
            ->toArray();
    }
}