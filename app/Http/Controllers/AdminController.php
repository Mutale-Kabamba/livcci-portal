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
    $validated = $request->validate([
        'status' => 'required|in:pending,approved,suspended,deactivated'
    ]);

    $profile->update(['status' => $validated['status']]);

    return back()->with('message', 'Status updated!');
    }

    // 2. Logic to Delete a Member
    public function deleteMember(BusinessProfile $profile)
    {
        $profile->delete();
        return back()->with('message', 'Member profile removed successfully.');
    }

    // 3. Logic to Add News/Events
    public function storeEvent(Request $request)
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'type' => 'required|in:Meeting,Workshop,Expo,News',
            'event_date' => 'nullable|date',
            'description' => 'required|string',
            'image' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:5120',
        ]);

        $data = [
            'title' => $validated['title'],
            'type' => $validated['type'],
            'event_date' => $validated['event_date'],
            'description' => $validated['description'],
        ];

        if ($request->hasFile('image')) {
            $file = $request->file('image');
            $path = $file->store('events', 'public');
            $data['image_url'] = $path;
        }

        ChamberEvent::create($data);

        return back()->with('message', 'Event posted successfully!');
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