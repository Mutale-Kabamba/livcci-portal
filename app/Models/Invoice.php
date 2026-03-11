<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Invoice extends Model
{
    use HasFactory;

    protected $fillable = [
        'profile_id',
        'amount',
        'status',
        'invoice_number',
        'due_date',
    ];

    protected function casts(): array
    {
        return [
            'amount' => 'decimal:2',
            'due_date' => 'date',
        ];
    }

    public function profile()
    {
        return $this->belongsTo(BusinessProfile::class, 'profile_id');
    }

    public function businessProfile()
    {
        return $this->belongsTo(BusinessProfile::class, 'profile_id');
    }
}
