<?php

namespace App\Policies;

use App\Models\User;
use App\Models\BusinessProfile;

class BusinessProfilePolicy
{
    /**
     * Determine whether the user can view the business profile.
     */
    public function view(User $user, BusinessProfile $profile): bool
    {
        // Users can view their own profiles, admins can view all
        return $user->is_admin || $user->id === $profile->user_id;
    }

    /**
     * Determine whether the user can update the business profile.
     */
    public function update(User $user, BusinessProfile $profile): bool
    {
        // Only the profile owner can update, or an admin
        return $user->is_admin || $user->id === $profile->user_id;
    }

    /**
     * Determine whether the user can delete the business profile.
     */
    public function delete(User $user, BusinessProfile $profile): bool
    {
        // Only the profile owner can delete their own profile, or an admin
        return $user->is_admin || $user->id === $profile->user_id;
    }

    /**
     * Determine whether the user can permanently delete the business profile.
     * (Hard delete - only for admins)
     */
    public function forceDelete(User $user, BusinessProfile $profile): bool
    {
        return $user->is_admin;
    }

    /**
     * Determine whether the user can restore the business profile.
     * (Restore from soft delete - only for admins)
     */
    public function restore(User $user, BusinessProfile $profile): bool
    {
        return $user->is_admin;
    }
}
