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
        Schema::create('business_profiles', function (Blueprint $table) {
            $table->id();
            // This links the profile to the specific user account
            $table->foreignId('user_id')->constrained()->cascadeOnDelete(); 
            
            // Core Business Details
            $table->string('company_name');
            $table->string('industry_sector'); // e.g., Tourism, IT, Agriculture
            $table->text('description')->nullable();
            
            // Contact Info
            $table->string('contact_email');
            $table->string('phone_number');
            $table->string('website_url')->nullable();
            $table->string('logo_path')->nullable(); // For later when we add image uploads
            
            $table->timestamps();
        });
    }
};
