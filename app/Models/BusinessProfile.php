<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class BusinessProfile extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = [
        'user_id', 'company_name', 'industry_sector', 'member_type', 'member_category', 'tpin', 'pacra_reg_no', 
        'short_description', 'contact_email', 'phone', 'address', 'website_url', 'logo_url', 'status',
        'membership_type', 'last_payment_date', 'subscription_expiry', 'membership_id'
    ];

    protected function casts(): array
    {
        return [
            'last_payment_date' => 'date',
            'subscription_expiry' => 'date',
        ];
    }

    // Establish the relationship back to the user
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function invoices()
    {
        return $this->hasMany(Invoice::class, 'profile_id');
    }
}
