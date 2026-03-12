<?php

namespace App\Http\Controllers;

use App\Http\Requests\StoreBusinessProfileRequest;
use App\Http\Requests\UpdateBusinessProfileRequest;
use App\Models\BusinessProfile;
use App\Services\BusinessProfileFileService;
use Illuminate\Http\RedirectResponse;
use Illuminate\Support\Facades\DB;
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
        $profiles = BusinessProfile::where('status', 'approved')
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

                // Create the profile linked to the currently logged-in user
                $request->user()->businessProfile()->create($validated);
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
        if ($profile->status !== 'approved' && auth()->id() !== $profile->user_id && !auth()->user()?->is_admin) {
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
}