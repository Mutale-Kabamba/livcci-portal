<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('business_profiles', function (Blueprint $table) {
            if (!Schema::hasColumn('business_profiles', 'document_paths')) {
                $table->json('document_paths')->nullable()->after('proof_of_payment_path')->comment('JSON storage for certificate uploads');
            }
        });
    }

    public function down(): void
    {
        Schema::table('business_profiles', function (Blueprint $table) {
            if (Schema::hasColumn('business_profiles', 'document_paths')) {
                $table->dropColumn('document_paths');
            }
        });
    }
};
