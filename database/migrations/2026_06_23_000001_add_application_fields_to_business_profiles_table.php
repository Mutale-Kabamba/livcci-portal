<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('business_profiles', function (Blueprint $table) {
            if (!Schema::hasColumn('business_profiles', 'owner_director_name')) {
                $table->string('owner_director_name')->nullable()->after('address');
            }
            if (!Schema::hasColumn('business_profiles', 'owner_director_phone')) {
                $table->string('owner_director_phone')->nullable()->after('owner_director_name');
            }
            if (!Schema::hasColumn('business_profiles', 'contact_person_name')) {
                $table->string('contact_person_name')->nullable()->after('owner_director_phone');
            }
            if (!Schema::hasColumn('business_profiles', 'contact_person_phone')) {
                $table->string('contact_person_phone')->nullable()->after('contact_person_name');
            }
            if (!Schema::hasColumn('business_profiles', 'business_reg_number')) {
                $table->string('business_reg_number')->nullable()->after('contact_person_phone');
            }
            if (!Schema::hasColumn('business_profiles', 'napsa_reg_number')) {
                $table->string('napsa_reg_number')->nullable()->after('business_reg_number');
            }
            if (!Schema::hasColumn('business_profiles', 'wcfcb_number')) {
                $table->string('wcfcb_number')->nullable()->after('napsa_reg_number');
            }
            if (!Schema::hasColumn('business_profiles', 'number_of_employees')) {
                $table->unsignedInteger('number_of_employees')->nullable()->after('wcfcb_number');
            }
            if (!Schema::hasColumn('business_profiles', 'annual_turnover')) {
                $table->decimal('annual_turnover', 15, 2)->nullable()->after('number_of_employees');
            }
        });
    }

    public function down(): void
    {
        Schema::table('business_profiles', function (Blueprint $table) {
            $cols = ['owner_director_name', 'owner_director_phone', 'contact_person_name', 'contact_person_phone',
                     'business_reg_number', 'napsa_reg_number', 'wcfcb_number', 'number_of_employees', 'annual_turnover'];
            foreach ($cols as $col) {
                if (Schema::hasColumn('business_profiles', $col)) {
                    $table->dropColumn($col);
                }
            }
        });
    }
};
