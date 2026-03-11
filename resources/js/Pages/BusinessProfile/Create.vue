<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { Head, useForm } from '@inertiajs/vue3';
import { ref } from 'vue';

const logoPreview = ref(null);

const form = useForm({
    company_name: '',
    industry_sector: '',
    member_type: '',
    member_category: '',
    tpin: '',
    pacra_reg_no: '',
    short_description: '',
    contact_email: '',
    phone: '',
    address: '',
    website_url: '',
    logo: null,
});

const handleLogoUpload = (event) => {
    const file = event.target.files[0];
    if (file) {
        form.logo = file;
        const reader = new FileReader();
        reader.onload = (e) => {
            logoPreview.value = e.target.result;
        };
        reader.readAsDataURL(file);
    }
};

// Industry Sectors
const industrySectors = [
    'Tourism & Hospitality',
    'Trade & Commerce',
    'Financial Services',
    'Construction & Engineering',
    'Agriculture & Manufacturing',
    'Cooperatives & Social Enterprise',
    'IT & Creative Media'
];

// Membership Types
const membershipTypes = [
    'Corporate',
    'Ordinary',
    'Associate',
    'Cooperative'
];

// Membership Categories
const membershipCategories = [
    'Advertising',
    'Agriculture',
    'Apparel',
    'Appliances',
    'Art Galleries & Studios',
    'Automotive',
    'Banks',
    'Bars & Lounges',
    'Beauty Parlours & Saloons',
    'Business Services',
    'Cleaning Services',
    'Communication & Media',
    'Construction',
    'Education/Schools',
    'Engineering',
    'Entertainment',
    'Equipment',
    'Event Planners',
    'Exercise/Gym',
    'Financial Services',
    'Food',
    'Funeral Services',
    'Furniture',
    'Graphic Design',
    'Grocery',
    'Hardware/ Home & Garden',
    'Healthcare & Wellness',
    'Insurance',
    'Land Surveyors',
    'Landscaping',
    'Legal',
    'Lodging',
    'Manufacturing',
    'Medical Hospitals',
    'Mining & Exploration',
    'Music & Recording Studios',
    'Pest Control',
    'Pet care',
    'Photography & Video',
    'Printers',
    'Real Estate',
    'Restaurants & Catering',
    'Safety & Security Systems',
    'Sanitation/Garbage',
    'Sport/Recreation',
    'Staffing Service',
    'Tourism',
    'Transporting & Trucking',
    'Utilities'
];

const getError = (field) => {
    if (!form.errors[field]) return null;
    return Array.isArray(form.errors[field]) ? form.errors[field][0] : form.errors[field];
};

const submit = () => {
    form.post(route('profile.business.store'));
};
</script>

<template>
    <Head title="Create Business Profile" />

    <AuthenticatedLayout>
        <template #header>
            <h2 class="font-semibold text-xl text-gray-800 leading-tight">Create Business Profile</h2>
        </template>

        <div class="py-12">
            <div class="max-w-3xl mx-auto sm:px-6 lg:px-8">
                <div class="bg-white overflow-hidden shadow-sm sm:rounded-lg p-8">
                    
                    <!-- VALIDATION ERRORS SUMMARY -->
                    <div v-if="Object.keys(form.errors).length > 0" class="mb-6 p-4 bg-red-50 border border-red-200 rounded">
                        <h3 class="text-red-800 font-bold mb-3">Please fix the following errors:</h3>
                        <ul class="space-y-1">
                            <li v-for="(error, field) in form.errors" :key="field" class="text-red-700 text-sm">
                                <strong>{{ field }}:</strong> {{ Array.isArray(error) ? error[0] : error }}
                            </li>
                        </ul>
                    </div>

                    <form @submit.prevent="submit" class="space-y-6">
                        <!-- Company Name -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Company Name *</label>
                            <input 
                                v-model="form.company_name" 
                                type="text" 
                                placeholder="e.g. Ori Studio Limited"
                                :class="['w-full px-3 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500', 
                                         getError('company_name') ? 'border-red-500 bg-red-50' : 'border-gray-300']"
                                required
                            >
                            <p v-if="getError('company_name')" class="text-red-600 text-xs mt-1">{{ getError('company_name') }}</p>
                        </div>

                        <!-- Industry Sector -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Industry Sector *</label>
                            <select 
                                v-model="form.industry_sector"
                                :class="['w-full px-3 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500',
                                         getError('industry_sector') ? 'border-red-500 bg-red-50' : 'border-gray-300']"
                                required
                            >
                                <option value="">-- Select Industry Sector --</option>
                                <option v-for="sector in industrySectors" :key="sector" :value="sector">{{ sector }}</option>
                            </select>
                            <p v-if="getError('industry_sector')" class="text-red-600 text-xs mt-1">{{ getError('industry_sector') }}</p>
                        </div>

                        <!-- Member Type -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Membership Type *</label>
                            <select 
                                v-model="form.member_type"
                                :class="['w-full px-3 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500',
                                         getError('member_type') ? 'border-red-500 bg-red-50' : 'border-gray-300']"
                                required
                            >
                                <option value="">-- Select Type --</option>
                                <option v-for="type in membershipTypes" :key="type" :value="type">{{ type }}</option>
                            </select>
                            <p v-if="getError('member_type')" class="text-red-600 text-xs mt-1">{{ getError('member_type') }}</p>
                        </div>

                        <!-- Member Category -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Membership Category *</label>
                            <select 
                                v-model="form.member_category"
                                :class="['w-full px-3 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500',
                                         getError('member_category') ? 'border-red-500 bg-red-50' : 'border-gray-300']"
                                required
                            >
                                <option value="">-- Select Category --</option>
                                <option v-for="category in membershipCategories" :key="category" :value="category">{{ category }}</option>
                            </select>
                            <p v-if="getError('member_category')" class="text-red-600 text-xs mt-1">{{ getError('member_category') }}</p>
                        </div>

                        <!-- TPIN -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">TPIN (Tax ID) *</label>
                            <input 
                                v-model="form.tpin" 
                                type="text" 
                                placeholder="Tax Payer Identification Number"
                                :class="['w-full px-3 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500',
                                         getError('tpin') ? 'border-red-500 bg-red-50' : 'border-gray-300']"
                                required
                            >
                            <p v-if="getError('tpin')" class="text-red-600 text-xs mt-1">{{ getError('tpin') }}</p>
                        </div>

                        <!-- PACRA Reg No -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">PACRA Reg No. (Optional)</label>
                            <input 
                                v-model="form.pacra_reg_no" 
                                type="text" 
                                placeholder="For corporate entities"
                                :class="['w-full px-3 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500',
                                         getError('pacra_reg_no') ? 'border-red-500 bg-red-50' : 'border-gray-300']"
                            >
                            <p v-if="getError('pacra_reg_no')" class="text-red-600 text-xs mt-1">{{ getError('pacra_reg_no') }}</p>
                        </div>

                        <!-- Short Description -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Business Description (Max 500) *</label>
                            <textarea 
                                v-model="form.short_description" 
                                rows="3"
                                placeholder="Brief description of your business"
                                :class="['w-full px-3 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500',
                                         getError('short_description') ? 'border-red-500 bg-red-50' : 'border-gray-300']"
                                required
                            ></textarea>
                            <p class="text-xs text-gray-500 mt-1">{{ form.short_description.length }}/500</p>
                            <p v-if="getError('short_description')" class="text-red-600 text-xs mt-1">{{ getError('short_description') }}</p>
                        </div>

                        <!-- Contact Email -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Contact Email *</label>
                            <input 
                                v-model="form.contact_email" 
                                type="email"
                                placeholder="contact@example.com"
                                :class="['w-full px-3 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500',
                                         getError('contact_email') ? 'border-red-500 bg-red-50' : 'border-gray-300']"
                                required
                            >
                            <p v-if="getError('contact_email')" class="text-red-600 text-xs mt-1">{{ getError('contact_email') }}</p>
                        </div>

                        <!-- Phone -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Phone Number *</label>
                            <input 
                                v-model="form.phone" 
                                type="tel"
                                placeholder="+260 976 085 160"
                                :class="['w-full px-3 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500',
                                         getError('phone') ? 'border-red-500 bg-red-50' : 'border-gray-300']"
                                required
                            >
                            <p v-if="getError('phone')" class="text-red-600 text-xs mt-1">{{ getError('phone') }}</p>
                        </div>

                        <!-- Address -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Business Address (Optional)</label>
                            <textarea 
                                v-model="form.address" 
                                rows="2"
                                placeholder="Street address, city, etc"
                                :class="['w-full px-3 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500',
                                         getError('address') ? 'border-red-500 bg-red-50' : 'border-gray-300']"
                            ></textarea>
                            <p v-if="getError('address')" class="text-red-600 text-xs mt-1">{{ getError('address') }}</p>
                        </div>

                        <!-- Website URL -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Website URL (Optional)</label>
                            <input 
                                v-model="form.website_url" 
                                type="url"
                                placeholder="https://www.example.com"
                                :class="['w-full px-3 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500',
                                         getError('website_url') ? 'border-red-500 bg-red-50' : 'border-gray-300']"
                            >
                            <p v-if="getError('website_url')" class="text-red-600 text-xs mt-1">{{ getError('website_url') }}</p>
                        </div>

                        <!-- Logo Upload -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Company Logo (Optional)</label>
                            <input 
                                @change="handleLogoUpload" 
                                type="file" 
                                accept="image/*"
                                :class="['w-full px-3 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500',
                                         getError('logo') ? 'border-red-500 bg-red-50' : 'border-gray-300']"
                            >
                            <p class="text-xs text-gray-500 mt-1">JPG, PNG, GIF (Max 5MB)</p>
                            <p v-if="getError('logo')" class="text-red-600 text-xs mt-1">{{ getError('logo') }}</p>
                            <img v-if="logoPreview" :src="logoPreview" class="h-20 w-auto rounded mt-2 border border-gray-300 p-1" alt="Preview">
                        </div>

                        <!-- Submit -->
                        <div class="flex gap-4 pt-6">
                            <button 
                                type="submit" 
                                :disabled="form.processing"
                                class="flex-1 bg-indigo-600 text-white font-bold py-3 rounded hover:bg-indigo-700 disabled:opacity-50"
                            >
                                {{ form.processing ? 'Creating...' : 'Create Profile' }}
                            </button>
                            <a href="/dashboard" class="flex-1 bg-gray-300 text-gray-800 font-bold py-3 rounded hover:bg-gray-400 text-center">
                                Cancel
                            </a>
                        </div>
                    </form>

                </div>
            </div>
        </div>
    </AuthenticatedLayout>
</template>