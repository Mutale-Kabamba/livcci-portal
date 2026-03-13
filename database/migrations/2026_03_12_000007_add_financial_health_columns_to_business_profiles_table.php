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
            if (!Schema::hasColumn('business_profiles', 'annual_fee')) {
                $table->decimal('annual_fee', 12, 2)->default(0)->after('membership_type');
            }

            if (!Schema::hasColumn('business_profiles', 'total_paid')) {
                $table->decimal('total_paid', 12, 2)->default(0)->after('annual_fee');
            }

            if (!Schema::hasColumn('business_profiles', 'is_active')) {
                $table->boolean('is_active')->default(false)->after('status');
            }
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('business_profiles', function (Blueprint $table) {
            if (Schema::hasColumn('business_profiles', 'total_paid')) {
                $table->dropColumn('total_paid');
            }

            if (Schema::hasColumn('business_profiles', 'annual_fee')) {
                $table->dropColumn('annual_fee');
            }
        });
    }
};
