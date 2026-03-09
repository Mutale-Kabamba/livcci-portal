<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Inertia\Inertia;
use App\Models\BusinessProfile;
use Illuminate\Support\Facades\Storage;

class BusinessProfileController extends Controller
{   
    public function index()
    {
        // ONLY fetch profiles where status is 'approved'
        $profiles = BusinessProfile::where('status', 'approved')
                        ->orderBy('company_name', 'asc')
                        ->get();

        return Inertia::render('BusinessProfile/Index', [
            'profiles' => $profiles
        ]);
    }
    // 1. Show the HTML Form
    public function create()
    {
        return Inertia::render('BusinessProfile/Create');
    }

    // 2. Save the Form Data to the Database
    public function store(Request $request)
    {
        // Validate the incoming data
        $validated = $request->validate([
            'company_name' => 'required|string|max:255',
            'member_type' => 'required|in:Individual,Co-operative,Business,Academia,Corporate,Affiliate',
            'member_category' => 'required|string|max:255',
            'tpin' => 'required|string|max:20',
            'pacra_reg_no' => 'nullable|string|max:50',
            'short_description' => 'required|string|max:500',
            'contact_email' => 'required|email|max:255',
            'phone' => 'required|string|max:20',
            'address' => 'nullable|string|max:500',
            'website_url' => 'nullable|url|max:255',
            'logo' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:5120', // 5MB max
        ]);

        // Handle logo file upload
        if ($request->hasFile('logo')) {
            $logoPath = $request->file('logo')->store('logos', 'public');
            $validated['logo_url'] = '/storage/' . $logoPath;
        }

        // Create the profile linked to the currently logged-in user
        $request->user()->businessProfile()->create($validated);

        // Redirect back to the dashboard
        return redirect()->route('dashboard');
    }
    // 3. Show the Edit Form (Pre-filled with existing data)
    public function edit(Request $request)
    {
        return Inertia::render('BusinessProfile/Edit', [
            // Pass the user's existing profile to the form
            'businessProfile' => $request->user()->businessProfile 
        ]);
    }

    // 4. Save the Updated Data to the Database
    public function update(Request $request)
    {
        $validated = $request->validate([
            'company_name' => 'required|string|max:255',
            'member_type' => 'required|in:Individual,Co-operative,Business,Academia,Corporate,Affiliate',
            'member_category' => 'required|string|max:255',
            'tpin' => 'required|string|max:20',
            'pacra_reg_no' => 'nullable|string|max:50',
            'short_description' => 'required|string|max:500',
            'contact_email' => 'required|email|max:255',
            'phone' => 'required|string|max:20',
            'address' => 'nullable|string|max:500',
            'website_url' => 'nullable|url|max:255',
            'logo' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:5120', // 5MB max
        ]);

        // Handle logo file upload
        if ($request->hasFile('logo')) {
            $profile = $request->user()->businessProfile;
            
            // Delete old logo if it exists
            if ($profile && $profile->logo_url) {
                // Extract path from URL and delete
                $oldPath = str_replace('/storage/', '', $profile->logo_url);
                Storage::disk('public')->delete($oldPath);
            }
            
            $logoPath = $request->file('logo')->store('logos', 'public');
            $validated['logo_url'] = '/storage/' . $logoPath;
        }

        // Find the profile linked to the user and update it
        $request->user()->businessProfile()->update($validated);

        // Send them back to the dashboard
        return redirect()->route('dashboard');
    }
}