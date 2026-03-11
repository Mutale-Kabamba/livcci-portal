<?php

namespace Tests\Feature;

use App\Models\User;
use App\Models\BusinessProfile;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Tests\TestCase;

class BusinessProfileTest extends TestCase
{
    use RefreshDatabase;

    protected User $user;
    protected User $admin;

    protected function setUp(): void
    {
        parent::setUp();

        Storage::fake('public');

        $this->user = User::factory()->create(['is_admin' => false]);
        $this->admin = User::factory()->create(['is_admin' => true]);
    }

    /**
     * Test unauthenticated users cannot create profiles
     */
    public function test_unauthenticated_users_cannot_create_profile()
    {
        $response = $this->get(route('profile.business.create'));
        $response->assertRedirect('login');
    }

    /**
     * Test authenticated users can view create form
     */
    public function test_authenticated_user_can_view_create_form()
    {
        $response = $this->actingAs($this->user)->get(route('profile.business.create'));
        $response->assertOk();
        $response->assertInertia(fn ($page) => $page->component('BusinessProfile/Create'));
    }

    /**
     * Test user with existing profile is redirected from create
     */
    public function test_user_with_existing_profile_redirected_from_create()
    {
        $profile = BusinessProfile::factory()->create(['user_id' => $this->user->id]);

        $response = $this->actingAs($this->user)->get(route('profile.business.create'));
        $response->assertRedirect(route('profile.business.edit'));
    }

    /**
     * Test business profile creation with valid data
     */
    public function test_create_business_profile_with_valid_data()
    {
        $data = [
            'company_name' => 'Test Company',
            'industry_sector' => 'Technology',
            'member_type' => 'Business',
            'member_category' => 'Information Technology',
            'tpin' => '1234567890',
            'pacra_reg_no' => 'PACRA123',
            'short_description' => 'A test business description',
            'contact_email' => 'test@example.com',
            'phone' => '+923001234567',
            'address' => '123 Main Street',
            'website_url' => 'https://example.com',
        ];

        $response = $this->actingAs($this->user)->post(route('profile.business.store'), $data);

        $response->assertRedirect(route('dashboard'));
        $this->assertDatabaseHas('business_profiles', [
            'user_id' => $this->user->id,
            'company_name' => 'Test Company',
            'tpin' => '1234567890',
        ]);
    }

    /**
     * Test business profile creation with logo
     */
    public function test_create_profile_with_logo_upload()
    {
        $data = [
            'company_name' => 'Test Company',
            'industry_sector' => 'Technology',
            'member_type' => 'Business',
            'member_category' => 'Information Technology',
            'tpin' => '1234567890',
            'pacra_reg_no' => 'PACRA123',
            'short_description' => 'Test description',
            'contact_email' => 'test@example.com',
            'phone' => '+923001234567',
            'logo' => UploadedFile::fake()->image('logo.jpg', 100, 100),
        ];

        $response = $this->actingAs($this->user)->post(route('profile.business.store'), $data);

        $response->assertRedirect(route('dashboard'));
        
        $profile = $this->user->businessProfile;
        $this->assertNotNull($profile->logo_url);
        $this->assertStringContainsString('/storage/logos/', $profile->logo_url);
        Storage::disk('public')->assertExists(str_replace('/storage/', '', $profile->logo_url));
    }

    /**
     * Test business profile creation validation - required fields
     */
    public function test_create_profile_validation_required_fields()
    {
        $data = [
            'company_name' => '',
            'industry_sector' => '',
            'member_type' => '',
            'member_category' => '',
            'tpin' => '',
            'contact_email' => 'invalid-email',
            'phone' => '',
        ];

        $response = $this->actingAs($this->user)->post(route('profile.business.store'), $data);

        $response->assertSessionHasErrors([
            'company_name', 'industry_sector', 'member_type', 'member_category', 
            'tpin', 'contact_email', 'phone', 'short_description'
        ]);
    }

    /**
     * Test duplicate TPIN validation
     */
    public function test_create_profile_duplicate_tpin()
    {
        $existingProfile = BusinessProfile::factory()->create(['tpin' => 'DUPLICATE123']);

        $data = [
            'company_name' => 'Another Company',
            'industry_sector' => 'Technology',
            'member_type' => 'Business',
            'member_category' => 'Information Technology',
            'tpin' => 'DUPLICATE123',
            'short_description' => 'Test',
            'contact_email' => 'another@example.com',
            'phone' => '+923001234568',
        ];

        $response = $this->actingAs($this->user)->post(route('profile.business.store'), $data);

        $response->assertSessionHasErrors('tpin');
    }

    /**
     * Test logo file validation - size limit
     */
    public function test_logo_upload_size_validation()
    {
        $data = [
            'company_name' => 'Test Company',
            'industry_sector' => 'Technology',
            'member_type' => 'Business',
            'member_category' => 'Information Technology',
            'tpin' => '1234567890',
            'short_description' => 'Test',
            'contact_email' => 'test@example.com',
            'phone' => '+923001234567',
            'logo' => UploadedFile::fake()->image('logo.jpg')->size(6000), // Exceeds 5MB
        ];

        $response = $this->actingAs($this->user)->post(route('profile.business.store'), $data);

        $response->assertSessionHasErrors('logo');
    }

    /**
     * Test business profile update with valid data
     */
    public function test_update_profile_with_valid_data()
    {
        $profile = BusinessProfile::factory()->create(['user_id' => $this->user->id]);

        $data = [
            'company_name' => 'Updated Company',
            'industry_sector' => 'Finance',
            'member_type' => 'Corporate',
            'member_category' => 'Banks',
            'tpin' => $profile->tpin,
            'short_description' => 'Updated description',
            'contact_email' => 'updated@example.com',
            'phone' => '+923009876543',
        ];

        $response = $this->actingAs($this->user)->patch(route('profile.business.update'), $data);

        $response->assertRedirect(route('dashboard'));
        $profile->refresh();
        $this->assertEquals('Updated Company', $profile->company_name);
        $this->assertEquals('updated@example.com', $profile->contact_email);
    }

    /**
     * Test profile update with logo replacement
     */
    public function test_update_profile_replace_logo()
    {
        $profile = BusinessProfile::factory()->create(['user_id' => $this->user->id]);
        $oldLogo = UploadedFile::fake()->image('old_logo.jpg');
        $profile->update(['logo_url' => '/storage/logos/' . $oldLogo->hashName()]);

        $newLogo = UploadedFile::fake()->image('new_logo.jpg');

        $data = [
            'company_name' => $profile->company_name,
            'industry_sector' => $profile->industry_sector,
            'member_type' => $profile->member_type,
            'member_category' => $profile->member_category,
            'tpin' => $profile->tpin,
            'short_description' => $profile->short_description,
            'contact_email' => $profile->contact_email,
            'phone' => $profile->phone,
            'logo' => $newLogo,
        ];

        $response = $this->actingAs($this->user)->patch(route('profile.business.update'), $data);

        $response->assertRedirect(route('dashboard'));
        $profile->refresh();
        $this->assertNotNull($profile->logo_url);
    }

    /**
     * Test user cannot edit other user's profile
     */
    public function test_user_cannot_edit_other_users_profile()
    {
        $otherUser = User::factory()->create();
        $profile = BusinessProfile::factory()->create(['user_id' => $otherUser->id]);

        $data = [
            'company_name' => 'Unauthorized Update',
            'industry_sector' => 'Technology',
            'member_type' => 'Business',
            'member_category' => 'Information Technology',
            'tpin' => $profile->tpin,
            'short_description' => 'Test',
            'contact_email' => 'test@example.com',
            'phone' => '+923001234567',
        ];

        $response = $this->actingAs($this->user)->patch(route('profile.business.update'), $data);

        $response->assertForbidden();
    }

    /**
     * Test admin can view profile edit page
     */
    public function test_user_can_view_edit_form()
    {
        $profile = BusinessProfile::factory()->create(['user_id' => $this->user->id]);

        $response = $this->actingAs($this->user)->get(route('profile.business.edit'));

        $response->assertOk();
        $response->assertInertia(fn ($page) => 
            $page->component('BusinessProfile/Edit')
                 ->has('businessProfile')
        );
    }

    /**
     * Test display approved profiles in directory
     */
    public function test_display_approved_profiles_in_directory()
    {
        $approvedProfile = BusinessProfile::factory()->create(['status' => 'approved']);
        $pendingProfile = BusinessProfile::factory()->create(['status' => 'pending']);
        $suspendedProfile = BusinessProfile::factory()->create(['status' => 'suspended']);

        $response = $this->get(route('directory.index'));

        $response->assertOk();
        $response->assertInertia(fn ($page) => 
            $page->component('BusinessProfile/Index')
                 ->has('profiles', 1)
                 ->where('profiles.0.id', $approvedProfile->id)
        );
    }

    /**
     * Test view individual profile detail
     */
    public function test_view_individual_profile_detail()
    {
        $profile = BusinessProfile::factory()->create(['status' => 'approved']);

        $response = $this->get(route('directory.show', $profile));

        $response->assertOk();
        $response->assertInertia(fn ($page) => 
            $page->component('BusinessProfile/Show')
                 ->has('businessProfile')
                 ->where('businessProfile.id', $profile->id)
        );
    }

    /**
     * Test cannot view unapproved profile without authorization
     */
    public function test_cannot_view_unapproved_profile_as_anonymous()
    {
        $profile = BusinessProfile::factory()->create(['status' => 'pending']);

        $response = $this->get(route('directory.show', $profile));

        $response->assertForbidden();
    }

    /**
     * Test owner can view their own unapproved profile
     */
    public function test_owner_can_view_own_unapproved_profile()
    {
        $profile = BusinessProfile::factory()->create(['user_id' => $this->user->id, 'status' => 'pending']);

        $response = $this->actingAs($this->user)->get(route('directory.show', $profile));

        $response->assertOk();
    }

    /**
     * Test soft delete profile
     */
    public function test_user_can_delete_own_profile()
    {
        $profile = BusinessProfile::factory()->create(['user_id' => $this->user->id]);

        $response = $this->actingAs($this->user)->delete(route('profile.business.destroy', $profile));

        $response->assertRedirect(route('dashboard'));
        
        // Verify soft delete
        $this->assertSoftDeleted('business_profiles', ['id' => $profile->id]);
    }

    /**
     * Test user cannot delete other user's profile
     */
    public function test_user_cannot_delete_other_users_profile()
    {
        $otherUser = User::factory()->create();
        $profile = BusinessProfile::factory()->create(['user_id' => $otherUser->id]);

        $response = $this->actingAs($this->user)->delete(route('profile.business.destroy', $profile));

        $response->assertForbidden();
    }

    /**
     * Test admin can update member status
     */
    public function test_admin_can_update_member_status()
    {
        $profile = BusinessProfile::factory()->create(['status' => 'pending']);

        $response = $this->actingAs($this->admin)->patch(
            route('admin.members.status', $profile),
            ['status' => 'approved']
        );

        $response->assertRedirect();
        $profile->refresh();
        $this->assertEquals('approved', $profile->status);
    }

    /**
     * Test non-admin cannot update member status
     */
    public function test_non_admin_cannot_update_member_status()
    {
        $profile = BusinessProfile::factory()->create(['status' => 'pending']);

        $response = $this->actingAs($this->user)->patch(
            route('admin.members.status', $profile),
            ['status' => 'approved']
        );

        $response->assertForbidden();
    }

    /**
     * Test admin can hard delete profile
     */
    public function test_admin_can_hard_delete_profile()
    {
        $profile = BusinessProfile::factory()->create();
        $profileId = $profile->id;

        $response = $this->actingAs($this->admin)->delete(
            route('admin.members.delete', $profile)
        );

        $response->assertRedirect();
        $this->assertDatabaseMissing('business_profiles', ['id' => $profileId]);
    }

    /**
     * Test non-admin cannot hard delete profile
     */
    public function test_non_admin_cannot_hard_delete_profile()
    {
        $profile = BusinessProfile::factory()->create();

        $response = $this->actingAs($this->user)->delete(
            route('admin.members.delete', $profile)
        );

        $response->assertForbidden();
    }

    /**
     * Test invalid status update
     */
    public function test_invalid_status_update_validation()
    {
        $profile = BusinessProfile::factory()->create(['status' => 'pending']);

        $response = $this->actingAs($this->admin)->patch(
            route('admin.members.status', $profile),
            ['status' => 'invalid_status']
        );

        $response->assertSessionHasErrors('status');
    }

    /**
     * Test profile status defaults to pending
     */
    public function test_new_profile_status_defaults_to_pending()
    {
        $data = [
            'company_name' => 'Test Company',
            'industry_sector' => 'Technology',
            'member_type' => 'Business',
            'member_category' => 'Information Technology',
            'tpin' => '1234567890',
            'short_description' => 'Test',
            'contact_email' => 'test@example.com',
            'phone' => '+923001234567',
        ];

        $this->actingAs($this->user)->post(route('profile.business.store'), $data);

        $profile = $this->user->businessProfile;
        $this->assertEquals('pending', $profile->status);
    }

    /**
     * Test form request unique validation excludes self
     */
    public function test_tpin_unique_validation_excludes_own_profile()
    {
        $profile = BusinessProfile::factory()->create(['user_id' => $this->user->id, 'tpin' => 'TPIN123']);

        $data = [
            'company_name' => $profile->company_name,
            'industry_sector' => $profile->industry_sector,
            'member_type' => $profile->member_type,
            'member_category' => $profile->member_category,
            'tpin' => 'TPIN123', // Same TPIN should be allowed for own profile
            'short_description' => $profile->short_description,
            'contact_email' => $profile->contact_email,
            'phone' => $profile->phone,
        ];

        $response = $this->actingAs($this->user)->patch(route('profile.business.update'), $data);

        $response->assertRedirect(route('dashboard'));
    }
}
