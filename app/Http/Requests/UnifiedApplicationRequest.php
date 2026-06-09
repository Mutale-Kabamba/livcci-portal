<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rules;

class UnifiedApplicationRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return !auth()->check(); // Only guests can apply
    }

    /**
     * Get the validation rules that apply to the request.
     */
    public function rules(): array
    {
        return [
            // Account creation fields
            'full_name' => 'required|string|max:255',
            'email' => 'required|string|lowercase|email|max:255|unique:users,email',
            'password' => ['required', 'confirmed', Rules\Password::defaults()],

            // Business Information
            'company_name' => 'required|string|max:255',
            'industry_sector' => 'required|in:Tourism & Hospitality,Trade & Commerce,Financial Services,Construction & Engineering,Agriculture & Manufacturing,Cooperatives & Social Enterprise,IT & Creative Media',
            'member_type' => 'required|in:Corporate,Ordinary,Associate,Cooperative',
            'member_category' => 'required|string|max:255',
            'business_activities' => 'required',
            'short_description' => 'required|string|max:500',

            // Contact Information
            'contact_email' => 'required|email|max:255',
            'phone' => ['required', 'regex:/^(\+260|260|0)(9\d{8}|7\d{8})$/'],
            'address' => 'nullable|string|max:500',
            'website_url' => 'nullable|url|max:255',
            'social_links' => 'nullable|array',
            'social_links.linkedin' => 'nullable|url|max:255',
            'social_links.facebook' => 'nullable|url|max:255',
            'social_links.x' => 'nullable|url|max:255',
            'social_links.instagram' => 'nullable|url|max:255',
            'social_links.whatsapp' => 'nullable|url|max:255',

            // Contact Persons
            'owner_director_name' => 'required|string|max:255',
            'owner_director_phone' => ['required', 'regex:/^(\+260|260|0)(9\d{8}|7\d{8})$/'],
            'contact_person_name' => 'nullable|string|max:255',
            'contact_person_phone' => ['nullable', 'regex:/^(\+260|260|0)(9\d{8}|7\d{8})$/'],

            // Registration Numbers
            'tpin' => ['required', 'regex:/^\d{10}$/', 'unique:business_profiles,tpin'],
            'business_reg_number' => 'nullable|string|max:50',
            'pacra_reg_no' => 'required_unless:member_type,Associate|nullable|string|max:50|unique:business_profiles,pacra_reg_no',
            'napsa_reg_number' => 'nullable|string|max:50',
            'wcfcb_number' => 'nullable|string|max:50',

            // Business Details
            'annual_turnover' => 'nullable|numeric|min:0',
            'number_of_employees' => 'required|integer|min:1',

            // File Uploads
            'logo' => 'nullable|image|mimes:jpeg,jpg,png|max:2048',
            'proof_of_payment' => 'nullable|file|mimes:pdf,jpg,jpeg,png|max:5120',
            'certificate_of_incorporation' => 'required|file|mimes:pdf,jpg,jpeg,png|max:5120',
            'tpin_certificate' => 'required|file|mimes:pdf,jpg,jpeg,png|max:5120',
            'zra_tax_clearance' => 'required|file|mimes:pdf,jpg,jpeg,png|max:5120',
            'napsa_certificate' => 'nullable|file|mimes:pdf,jpg,jpeg,png|max:5120',
            'wcfcb_certificate' => 'nullable|file|mimes:pdf,jpg,jpeg,png|max:5120',
            'company_profile' => 'required|file|mimes:pdf,doc,docx|max:5120',

            // Declaration
            'declaration_agreed' => 'required|accepted',
            'terms_agreed' => 'required|accepted',
        ];
    }

    /**
     * Get custom messages for validator errors.
     */
    public function messages(): array
    {
        return [
            'full_name.required' => 'Full name is required.',
            'email.required' => 'Email is required.',
            'email.email' => 'Please enter a valid email address.',
            'email.unique' => 'This email is already registered.',
            'password.required' => 'Password is required.',
            'password.confirmed' => 'Passwords do not match.',
            'company_name.required' => 'Company name is required.',
            'industry_sector.required' => 'Please select an industry sector.',
            'member_type.required' => 'Please select a membership type.',
            'member_category.required' => 'Please select a membership category.',
            'business_activities.required' => 'Please select at least one business activity.',
            'tpin.required' => 'TPIN is required.',
            'tpin.regex' => 'TPIN must be exactly 10 digits.',
            'tpin.unique' => 'This TPIN is already registered.',
            'pacra_reg_no.required_unless' => 'PACRA registration number is required unless Membership Type is Associate.',
            'pacra_reg_no.unique' => 'This PACRA registration number is already registered.',
            'contact_email.required' => 'Contact email is required.',
            'phone.required' => 'Phone number is required.',
            'phone.regex' => 'Phone number must be a valid Zambian number.',
            'number_of_employees.required' => 'Number of employees is required.',
            'owner_director_name.required' => 'Owner/Director name is required.',
            'owner_director_phone.required' => 'Owner/Director phone is required.',
            'certificate_of_incorporation.required' => 'Certificate of Incorporation is required.',
            'tpin_certificate.required' => 'TPIN Certificate is required.',
            'zra_tax_clearance.required' => 'ZRA Tax Clearance is required.',
            'company_profile.required' => 'Company Profile document is required.',
            'declaration_agreed.required' => 'You must agree to the declaration.',
            'terms_agreed.required' => 'You must agree to the terms and conditions.',
        ];
    }

    public function withValidator($validator): void
    {
        $validator->sometimes('business_activities', 'array|min:1|max:6', function ($input) {
            return is_array($input->business_activities);
        });

        $validator->sometimes('business_activities', [function ($attribute, $value, $fail) {
            if (!is_string($value)) {
                $fail('Business activities must be an array or a comma-separated string.');
                return;
            }

            $decoded = json_decode($value, true);
            if (json_last_error() === JSON_ERROR_NONE && is_array($decoded)) {
                $items = array_values(array_filter(array_map('trim', $decoded), function ($item) {
                    return $item !== '';
                }));
            } else {
                $items = array_values(array_filter(array_map('trim', explode(',', $value)), function ($item) {
                    return $item !== '';
                }));
            }

            if (empty($items)) {
                $fail('Please select at least one business activity.');
            }
        }], function ($input) {
            return is_string($input->business_activities);
        });
    }
}
