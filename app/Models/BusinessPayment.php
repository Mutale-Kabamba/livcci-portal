<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class BusinessPayment extends Model
{
    use HasFactory;

    protected $fillable = [
        'profile_id',
        'amount',
        'payment_method',
        'reference',
        'reference_number',
        'receipt_pdf_path',
        'payment_date',
    ];

    protected function casts(): array
    {
        return [
            'amount' => 'decimal:2',
            'payment_date' => 'date',
        ];
    }

    public function profile()
    {
        return $this->belongsTo(BusinessProfile::class, 'profile_id');
    }
}
