<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Facades\Storage;

class BusinessProfile extends Model
{
    use HasFactory, SoftDeletes;

    protected $appends = [
        'payment_percentage',
    ];

    protected $fillable = [
        'user_id', 'company_name', 'industry_sector', 'member_type', 'member_category', 'tpin', 'pacra_reg_no', 
        'business_activities', 'short_description', 'contact_email', 'phone', 'address', 'website_url', 'social_links', 'logo_url', 'status',
        'is_active', 'membership_type', 'annual_fee', 'total_paid', 'invoice_pdf_path', 'last_payment_date', 'subscription_expiry', 'membership_id'
    ];

    protected function casts(): array
    {
        return [
            'business_activities' => 'array',
            'social_links' => 'array',
            'is_active' => 'boolean',
            'annual_fee' => 'decimal:2',
            'total_paid' => 'decimal:2',
            'last_payment_date' => 'date',
            'subscription_expiry' => 'date',
        ];
    }

    public function getLogoUrlAttribute($value): ?string
    {
        if (!$value) {
            return null;
        }

        $value = (string) $value;

        if (str_starts_with($value, 'data:')) {
            return $value;
        }

        // For full URLs, convert same-origin /storage paths to relative paths so they remain valid
        // even if APP_URL/port differs between environments.
        if (str_starts_with($value, 'http://') || str_starts_with($value, 'https://')) {
            $path = parse_url($value, PHP_URL_PATH);
            if (is_string($path) && str_starts_with($path, '/storage/')) {
                $relativePath = ltrim(str_replace('/storage/', '', $path), '/');
                return Storage::disk('public')->exists($relativePath) ? $path : null;
            }

            return $value;
        }

        $normalized = $value;
        if (str_starts_with($normalized, 'storage/')) {
            $normalized = '/' . $normalized;
        } elseif (!str_starts_with($normalized, '/storage/')) {
            $normalized = '/storage/' . ltrim($normalized, '/');
        }

        $relativePath = ltrim(str_replace('/storage/', '', $normalized), '/');

        return Storage::disk('public')->exists($relativePath) ? $normalized : null;
    }

    public function getPaymentPercentageAttribute(): float
    {
        $annualFee = (float) ($this->annual_fee ?? 0);
        $totalPaid = (float) ($this->total_paid ?? 0);

        if ($annualFee <= 0) {
            return 0;
        }

        return round(($totalPaid / $annualFee) * 100, 2);
    }

    public function reevaluateFinancialHealth(): void
    {
        $annualFee = (float) ($this->annual_fee ?? 0);
        $totalPaid = (float) ($this->total_paid ?? 0);
        $isActive = $annualFee > 0 && ($totalPaid / $annualFee) >= 0.5;

        $this->forceFill([
            'is_active' => $isActive,
        ])->save();
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

    public function payments()
    {
        return $this->hasMany(BusinessPayment::class, 'profile_id');
    }
}
