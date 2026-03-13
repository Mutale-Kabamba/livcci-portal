<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UpdateBusinessProfileRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return auth()->check();
    }

    /**
     * Get the validation rules that apply to the request.
     */
    public function rules(): array
    {
        $profileId = auth()->user()->businessProfile?->id;

        return [
            'company_name' => 'required|string|max:255',
            'industry_sector' => 'required|in:Tourism & Hospitality,Trade & Commerce,Financial Services,Construction & Engineering,Agriculture & Manufacturing,Cooperatives & Social Enterprise,IT & Creative Media',
            'member_type' => 'required|in:Corporate,Ordinary,Associate,Cooperative',
            'member_category' => 'required|string|max:255',
            'business_activities' => 'required',
            'tpin' => 'required|string|max:20|unique:business_profiles,tpin,' . $profileId,
            'pacra_reg_no' => 'nullable|string|max:50|unique:business_profiles,pacra_reg_no,' . $profileId,
            'short_description' => 'required|string|max:500',
            'contact_email' => 'required|email|max:255',
            'phone' => 'required|string|max:20',
            'address' => 'nullable|string|max:500',
            'website_url' => 'nullable|url|max:255',
            'social_links' => 'nullable|array',
            'social_links.linkedin' => 'nullable|url|max:255',
            'social_links.facebook' => 'nullable|url|max:255',
            'social_links.x' => 'nullable|url|max:255',
            'social_links.instagram' => 'nullable|url|max:255',
            'social_links.whatsapp' => 'nullable|url|max:255',
            'logo' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:5120',
        ];
    }

    /**
     * Get custom messages for validator errors.
     */
    public function messages(): array
    {
        return [
            'company_name.required' => 'Company name is required.',
            'company_name.max' => 'Company name cannot exceed 255 characters.',
            'industry_sector.required' => 'Please select an industry sector.',
            'industry_sector.in' => 'Invalid industry sector selected.',
            'member_type.required' => 'Please select a membership type.',
            'member_type.in' => 'Invalid membership type selected.',
            'member_category.required' => 'Please select a membership category.',
            'business_activities.required' => 'Please select at least one business activity.',
            'tpin.required' => 'TPIN is required.',
            'tpin.max' => 'TPIN cannot exceed 20 characters.',
            'tpin.unique' => 'This TPIN is already registered. Please use a different one.',
            'pacra_reg_no.unique' => 'This PACRA registration number is already registered.',
            'short_description.required' => 'Please provide a short description of your business.',
            'short_description.max' => 'Description cannot exceed 500 characters.',
            'contact_email.required' => 'Contact email is required.',
            'contact_email.email' => 'Please enter a valid email address.',
            'phone.required' => 'Phone number is required.',
            'phone.max' => 'Phone number cannot exceed 20 characters.',
            'website_url.url' => 'Please enter a valid website URL.',
            'social_links.array' => 'Social links must be a valid list of platform URLs.',
            'social_links.*.url' => 'Each social link must be a valid URL.',
            'logo.image' => 'The logo must be an image file.',
            'logo.mimes' => 'Logo must be a JPEG, PNG, JPG, or GIF image.',
            'logo.max' => 'Logo file size cannot exceed 5MB.',
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

            if (count($items) < 1) {
                $fail('Please select at least one business activity.');
                return;
            }

            if (count($items) > 6) {
                $fail('You may select up to 6 business activities only.');
            }
        }], function ($input) {
            return is_string($input->business_activities);
        });
    }
}
