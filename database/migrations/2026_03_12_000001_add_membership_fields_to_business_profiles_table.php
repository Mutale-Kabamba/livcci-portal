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
            $table->enum('membership_type', ['Corporate', 'Ordinary', 'Associate', 'Cooperative'])
                ->nullable()
                ->after('member_category');
            $table->date('last_payment_date')->nullable()->after('status');
            $table->date('subscription_expiry')->nullable()->after('last_payment_date');
            $table->string('membership_id')->nullable()->unique()->after('subscription_expiry');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('business_profiles', function (Blueprint $table) {
            $table->dropUnique('business_profiles_membership_id_unique');
            $table->dropColumn([
                'membership_type',
                'last_payment_date',
                'subscription_expiry',
                'membership_id',
            ]);
        });
    }
};
