<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;

class User extends Authenticatable
{
    /** @use HasFactory<\Database\Factories\UserFactory> */
    use HasFactory, Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var list<string>
     */
    protected $fillable = [
        'name',
        'email',
        'password',
        'is_admin',
        'role',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var list<string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
            'is_admin' => 'boolean',
        ];
    }

    public function roleKey(): string
    {
        return strtolower((string) ($this->role ?? ''));
    }

    public function isSuperAdmin(): bool
    {
        return $this->is_admin && in_array($this->roleKey(), ['super_admin', 'super admin', ''], true)
            || $this->roleKey() === 'super_admin';
    }

    public function hasRole(string $role): bool
    {
        return $this->roleKey() === strtolower($role);
    }

    public function hasAnyRole(array $roles): bool
    {
        $role = $this->roleKey();
        $normalized = array_map(static fn ($value) => strtolower((string) $value), $roles);
        return in_array($role, $normalized, true);
    }

    public function businessProfile()
    {
        return $this->hasOne(BusinessProfile::class);
    }
}
