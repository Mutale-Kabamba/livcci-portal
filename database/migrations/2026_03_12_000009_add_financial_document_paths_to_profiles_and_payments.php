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
            if (!Schema::hasColumn('business_profiles', 'invoice_pdf_path')) {
                $table->string('invoice_pdf_path')->nullable()->after('total_paid');
            }
        });

        Schema::table('business_payments', function (Blueprint $table) {
            if (!Schema::hasColumn('business_payments', 'receipt_pdf_path')) {
                $table->string('receipt_pdf_path')->nullable()->after('reference');
            }
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('business_payments', function (Blueprint $table) {
            if (Schema::hasColumn('business_payments', 'receipt_pdf_path')) {
                $table->dropColumn('receipt_pdf_path');
            }
        });

        Schema::table('business_profiles', function (Blueprint $table) {
            if (Schema::hasColumn('business_profiles', 'invoice_pdf_path')) {
                $table->dropColumn('invoice_pdf_path');
            }
        });
    }
};
