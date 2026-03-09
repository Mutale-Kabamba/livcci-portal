<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { Head, useForm } from '@inertiajs/vue3';
import { ref } from 'vue';

const logoPreview = ref(null);

const form = useForm({
    company_name: '',
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

// Membership Types
const membershipTypes = [
    'Individual',
    'Co-operative', 
    'Business',
    'Academia',
    'Corporate',
    'Affiliate'
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

const submit = () => {
    form.post(route('profile.business.store'));
};
</script>

<template>
    <Head title="Join Chamber Directory" />

    <AuthenticatedLayout>
        <template #header>
            <h2 class="font-semibold text-xl text-gray-800 leading-tight">Create Business Profile</h2>
        </template>

        <div class="py-12">
            <div class="max-w-3xl mx-auto sm:px-6 lg:px-8">
                <div class="bg-white overflow-hidden shadow-sm sm:rounded-lg p-8">
                    
                    <form @submit.prevent="submit" class="space-y-6">
                        <!-- NAME -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700">NAME</label>
                            <input v-model="form.company_name" type="text" placeholder="e.g. Ori Studio Limited" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500" required>
                        </div>

                        <!-- MEMBER TYPE -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700">MEMBER TYPE</label>
                            <select v-model="form.member_type" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500" required>
                                <option disabled value="">Select membership type...</option>
                                <option v-for="type in membershipTypes" :key="type" :value="type">{{ type }}</option>
                            </select>
                        </div>

                        <!-- MEMBER CATEGORY -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700">MEMBER CATEGORY</label>
                            <select v-model="form.member_category" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500" required>
                                <option disabled value="">Select category...</option>
                                <option v-for="category in membershipCategories" :key="category" :value="category">{{ category }}</option>
                            </select>
                        </div>

                        <!-- TPIN -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700">TPIN</label>
                            <input v-model="form.tpin" type="text" placeholder="Tax Payer Identification Number" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500" required>
                        </div>

                        <!-- PACRA REG NO (conditional) -->
                        <div v-if="form.member_type !== 'Individual'">
                            <label class="block text-sm font-medium text-gray-700">PACRA REG NO.</label>
                            <input v-model="form.pacra_reg_no" type="text" placeholder="Patents and Companies Registration Agency Registration Number" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500">
                        </div>

                        <!-- SHORT DESCRIPTION -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700">SHORT DESCRIPTION (15 words max)</label>
                            <textarea v-model="form.short_description" rows="3" placeholder="Brief description of your business/services..." class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500" required></textarea>
                            <p class="text-xs text-gray-500 mt-1">{{ form.short_description.split(' ').length }}/15 words</p>
                        </div>

                        <!-- CONTACTS -->
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div>
                                <label class="block text-sm font-medium text-gray-700">EMAIL</label>
                                <input v-model="form.contact_email" type="email" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500" required>
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700">PHONE</label>
                                <input v-model="form.phone" type="text" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500" required>
                            </div>
                        </div>

                        <!-- ADDRESS -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700">ADDRESS</label>
                            <textarea v-model="form.address" rows="2" placeholder="Business address..." class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"></textarea>
                        </div>

                        <!-- WEBSITE & LOGO -->
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div>
                                <label class="block text-sm font-medium text-gray-700">WEBSITE URL (Optional)</label>
                                <input v-model="form.website_url" type="url" placeholder="https://www.example.com" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500">
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700">LOGO (Optional)</label>
                                <input @change="handleLogoUpload" type="file" accept="image/*" class="mt-1 block w-full rounded-md border border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 p-2">
                                <p class="text-xs text-gray-500 mt-1">Supported formats: JPG, PNG, GIF (Max 5MB)</p>
                                <div v-if="logoPreview" class="mt-4">
                                    <p class="text-sm font-medium text-gray-700 mb-2">Logo Preview:</p>
                                    <img :src="logoPreview" class="h-24 w-auto rounded border border-gray-300 p-2 bg-gray-50" alt="Logo Preview">
                                </div>
                            </div>
                        </div>

                        <div class="pt-4">
                            <button type="submit" :disabled="form.processing" class="w-full bg-indigo-600 text-white font-bold py-3 px-4 rounded hover:bg-indigo-700 disabled:opacity-50">
                                Save Profile to Directory
                            </button>
                        </div>
                    </form>

                </div>
            </div>
        </div>
    </AuthenticatedLayout>
</template>