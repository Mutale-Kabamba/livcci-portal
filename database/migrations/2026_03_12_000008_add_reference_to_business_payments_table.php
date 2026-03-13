<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('business_payments', function (Blueprint $table) {
            if (!Schema::hasColumn('business_payments', 'reference')) {
                $table->string('reference')->nullable()->after('payment_method');
            }
        });

        if (Schema::hasColumn('business_payments', 'reference_number') && Schema::hasColumn('business_payments', 'reference')) {
            DB::table('business_payments')->whereNull('reference')->update([
                'reference' => DB::raw('reference_number'),
            ]);
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('business_payments', function (Blueprint $table) {
            if (Schema::hasColumn('business_payments', 'reference')) {
                $table->dropColumn('reference');
            }
        });
    }
};
