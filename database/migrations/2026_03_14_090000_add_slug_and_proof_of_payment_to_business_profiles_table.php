<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Str;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('business_profiles', function (Blueprint $table) {
            if (!Schema::hasColumn('business_profiles', 'slug')) {
                $table->string('slug')->nullable()->unique()->after('company_name');
            }

            if (!Schema::hasColumn('business_profiles', 'proof_of_payment_path')) {
                $table->string('proof_of_payment_path')->nullable()->after('invoice_pdf_path');
            }
        });

        $profiles = DB::table('business_profiles')->select('id', 'company_name')->get();
        foreach ($profiles as $profile) {
            $base = Str::slug((string) $profile->company_name);
            $base = $base !== '' ? $base : 'business-profile';
            $slug = $base;
            $counter = 1;

            while (DB::table('business_profiles')->where('slug', $slug)->where('id', '!=', $profile->id)->exists()) {
                $slug = $base . '-' . $counter;
                $counter++;
            }

            DB::table('business_profiles')->where('id', $profile->id)->update(['slug' => $slug]);
        }
    }

    public function down(): void
    {
        Schema::table('business_profiles', function (Blueprint $table) {
            if (Schema::hasColumn('business_profiles', 'proof_of_payment_path')) {
                $table->dropColumn('proof_of_payment_path');
            }

            if (Schema::hasColumn('business_profiles', 'slug')) {
                $table->dropUnique(['slug']);
                $table->dropColumn('slug');
            }
        });
    }
};
