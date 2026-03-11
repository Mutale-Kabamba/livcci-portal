<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Storage;
use Illuminate\Foundation\Application;
use Inertia\Inertia;
use App\Models\BusinessProfile;
use App\Models\ChamberEvent;
use App\Models\User;

class AdminController extends Controller
{
    public function dashboard()
    {
        $profiles = BusinessProfile::with('user')->latest()->get();
        $events = ChamberEvent::latest()->get();

        return Inertia::render('Admin/Dashboard', [
            'profiles' => $profiles,
            'events' => $events,
            'flash' => [
                'message' => session('message')
            ]
        ]);
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
        
        return Inertia::render('Welcome', [
            'canLogin' => Route::has('login'),
            'canRegister' => Route::has('register'),
            'events' => $events,
            'approvedMembers' => $approvedMembers,
        ]);
    }
}