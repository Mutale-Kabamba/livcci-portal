<?php

namespace Database\Factories;

use App\Models\BusinessProfile;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

class BusinessProfileFactory extends Factory
{
    protected $model = BusinessProfile::class;

    public function definition(): array
    {
        return [
            'user_id' => User::factory(),
            'company_name' => $this->faker->company(),
            'industry_sector' => $this->faker->randomElement([
                'Agriculture', 'Banking & Finance', 'Construction', 'Education', 'Energy',
                'Entertainment', 'Food & Beverage', 'Healthcare', 'Hospitality', 'Information Technology'
            ]),
            'member_type' => $this->faker->randomElement(['Individual', 'Co-operative', 'Business', 'Academia', 'Corporate', 'Affiliate']),
            'member_category' => $this->faker->randomElement([
                'Advertising', 'Agriculture', 'Automotive', 'Banks', 'Healthcare & Wellness',
                'Information Technology', 'Insurance', 'Manufacturing', 'Real Estate', 'Retail'
            ]),
            'tpin' => $this->faker->unique()->numerify('##########'),
            'pacra_reg_no' => $this->faker->optional()->numerify('PACRA#####'),
            'short_description' => $this->faker->sentence(10),
            'contact_email' => $this->faker->companyEmail(),
            'phone' => $this->faker->phoneNumber(),
            'address' => $this->faker->address(),
            'website_url' => $this->faker->optional()->url(),
            'logo_url' => null,
            'status' => 'pending',
        ];
    }

    public function approved(): static
    {
        return $this->state(function (array $attributes) {
            return ['status' => 'approved'];
        });
    }

    public function suspended(): static
    {
        return $this->state(function (array $attributes) {
            return ['status' => 'suspended'];
        });
    }

    public function deactivated(): static
    {
        return $this->state(function (array $attributes) {
            return ['status' => 'deactivated'];
        });
    }
}
