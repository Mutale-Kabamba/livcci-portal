<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('business_profiles', function (Blueprint $table) {
            // Add new member profile fields
            $table->string('member_type')->after('company_name'); // Individual, Co-operative, Business, Academia, Corporate, Affiliate
            $table->string('member_category')->after('member_type'); // From the provided list
            $table->string('tpin')->after('member_category'); // TPIN
            $table->string('pacra_reg_no')->nullable()->after('tpin'); // PACRA Reg No. (nullable for Individual)
            $table->string('short_description')->after('pacra_reg_no'); // Short description (15 words)
            
            // Update existing fields to match new naming
            $table->string('phone')->after('contact_email'); // Rename phone_number to phone
            $table->string('address')->nullable()->after('phone'); // Add address field
            
            // Rename logo_path to logo_url for consistency
            $table->renameColumn('logo_path', 'logo_url');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('business_profiles', function (Blueprint $table) {
            // Reverse the changes
            $table->dropColumn(['member_type', 'member_category', 'tpin', 'pacra_reg_no', 'short_description', 'phone', 'address']);
            $table->renameColumn('logo_url', 'logo_path');
        });
    }
};
