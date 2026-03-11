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
            'tpin' => 'required|string|max:20|unique:business_profiles,tpin,' . $profileId,
            'pacra_reg_no' => 'nullable|string|max:50|unique:business_profiles,pacra_reg_no,' . $profileId,
            'short_description' => 'required|string|max:500',
            'contact_email' => 'required|email|max:255',
            'phone' => 'required|string|max:20',
            'address' => 'nullable|string|max:500',
            'website_url' => 'nullable|url|max:255',
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
            'logo.image' => 'The logo must be an image file.',
            'logo.mimes' => 'Logo must be a JPEG, PNG, JPG, or GIF image.',
            'logo.max' => 'Logo file size cannot exceed 5MB.',
        ];
    }
}
