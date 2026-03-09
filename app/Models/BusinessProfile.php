<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class BusinessProfile extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id', 'company_name', 'member_type', 'member_category', 'tpin', 'pacra_reg_no', 
        'short_description', 'contact_email', 'phone', 'address', 'website_url', 'logo_url', 'status'
    ];

    // Establish the relationship back to the user
    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
