<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { Head, useForm } from '@inertiajs/vue3';
import { computed, ref, watch } from 'vue';
import { INDUSTRY_ACTIVITIES } from '@/constants/industryActivities';

const logoPreview = ref(null);
const MAX_ACTIVITIES = 6;

const form = useForm({
    company_name: '',
    industry_sector: '',
    member_type: '',
    member_category: '',
    selectedActivities: [],
    business_activities: '',
    tpin: '',
    pacra_reg_no: '',
    short_description: '',
    contact_email: '',
    phone: '',
    address: '',
    website_url: '',
    social_links: {},
    logo: null,
});

const socialPlatformOptions = [
    { key: 'linkedin', label: 'LinkedIn' },
    { key: 'facebook', label: 'Facebook' },
    { key: 'x', label: 'X / Twitter' },
    { key: 'instagram', label: 'Instagram' },
    { key: 'whatsapp', label: 'WhatsApp' },
];
const selectedSocialPlatform = ref('linkedin');
const socialLinkInput = ref('');
const socialLinkError = ref('');

const normalizeUrl = (value) => {
    const trimmed = String(value || '').trim();
    if (!trimmed) return '';
    return /^https?:\/\//i.test(trimmed) ? trimmed : `https://${trimmed}`;
};

const addSocialLink = () => {
    socialLinkError.value = '';
    const normalized = normalizeUrl(socialLinkInput.value);

    try {
        if (!normalized) {
            socialLinkError.value = 'Please enter a URL.';
            return;
        }

        // Throws if invalid
        new URL(normalized);
        form.social_links = {
            ...(form.social_links || {}),
            [selectedSocialPlatform.value]: normalized,
        };
        socialLinkInput.value = '';
    } catch {
        socialLinkError.value = 'Please enter a valid URL.';
    }
};

const removeSocialLink = (platform) => {
    const next = { ...(form.social_links || {}) };
    delete next[platform];
    form.social_links = next;
};

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
const industrySectors = Object.keys(INDUSTRY_ACTIVITIES);

// Membership Types
const membershipTypes = [
    'Corporate',
    'Ordinary',
    'Associate',
    'Cooperative'
];

const filteredActivities = computed(() => INDUSTRY_ACTIVITIES[form.industry_sector] || []);
const activitiesWarning = ref('');

const toggleActivity = (activity) => {
    const current = [...form.selectedActivities];
    const exists = current.includes(activity);

    if (exists) {
        form.selectedActivities = current.filter((item) => item !== activity);
        activitiesWarning.value = '';
        return;
    }

    if (current.length >= MAX_ACTIVITIES) {
            activitiesWarning.value = 'You can select up to 6 activities only.';
            return;
    }

    form.selectedActivities = [...current, activity];
    activitiesWarning.value = '';
};

watch(
    () => form.industry_sector,
    () => {
        form.selectedActivities = [];
        activitiesWarning.value = '';
    }
);

watch(
    () => form.selectedActivities,
    (activities) => {
        form.business_activities = JSON.stringify(activities || []);
    },
    { deep: true, immediate: true }
);

const getError = (field) => {
    if (!form.errors[field]) return null;
    return Array.isArray(form.errors[field]) ? form.errors[field][0] : form.errors[field];
};

const inputClasses = (field) => [
    'w-full rounded-xl border-2 bg-white px-4 py-3 text-sm text-gray-900 outline-none transition-all duration-300',
    'placeholder:text-gray-400 hover:border-[#1876C3]/50 focus:border-[#1876C3] focus:ring-4 focus:ring-[#1876C3]/15',
    getError(field) ? 'border-red-400 bg-red-50' : 'border-gray-200',
];

const submit = () => {
    // Keep backend compatibility where member_category is currently required.
    form.member_category = form.industry_sector || 'General';
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
            <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
                <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 items-start">
                    <div class="lg:col-span-2 bg-white overflow-hidden shadow-sm sm:rounded-xl p-8 border border-gray-100">
                    
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
                            <label class="block text-xs font-bold tracking-wide text-gray-500 uppercase mb-2">Company Name *</label>
                            <input 
                                v-model="form.company_name" 
                                type="text" 
                                placeholder="e.g. Ori Studio Limited"
                                :class="inputClasses('company_name')"
                                required
                            >
                            <p v-if="getError('company_name')" class="text-red-600 text-xs mt-1">{{ getError('company_name') }}</p>
                        </div>

                        <!-- Industry Sector -->
                        <div>
                            <label class="block text-xs font-bold tracking-wide text-gray-500 uppercase mb-2">Industry Sector *</label>
                            <select 
                                v-model="form.industry_sector"
                                :class="inputClasses('industry_sector')"
                                required
                            >
                                <option value="">-- Select Industry Sector --</option>
                                <option v-for="sector in industrySectors" :key="sector" :value="sector">{{ sector }}</option>
                            </select>
                            <p v-if="getError('industry_sector')" class="text-red-600 text-xs mt-1">{{ getError('industry_sector') }}</p>
                        </div>

                        <!-- Member Type -->
                        <div>
                            <label class="block text-xs font-bold tracking-wide text-gray-500 uppercase mb-2">Membership Type *</label>
                            <select 
                                v-model="form.member_type"
                                :class="inputClasses('member_type')"
                                required
                            >
                                <option value="">-- Select Type --</option>
                                <option v-for="type in membershipTypes" :key="type" :value="type">{{ type }}</option>
                            </select>
                            <p v-if="getError('member_type')" class="text-red-600 text-xs mt-1">{{ getError('member_type') }}</p>
                        </div>

                        <!-- Business Activities -->
                        <div>
                            <label class="block text-xs font-bold tracking-wide text-gray-500 uppercase mb-2">Business Activities (Select up to 6)</label>
                            <div v-if="!form.industry_sector" class="text-xs text-gray-500">Select an industry sector first to load activity tags.</div>
                            <div v-else class="flex flex-wrap gap-2 mt-2">
                                <button
                                    v-for="activity in filteredActivities"
                                    :key="activity"
                                    type="button"
                                    @click="toggleActivity(activity)"
                                    class="px-3 py-1.5 rounded-full text-xs font-semibold border transition-all duration-300"
                                    :class="form.selectedActivities.includes(activity)
                                        ? 'bg-[#1876C3] text-white border-[#1876C3]'
                                        : 'bg-white text-gray-700 border-gray-200 hover:border-[#1876C3] hover:text-[#1876C3]'"
                                >
                                    {{ activity }}
                                </button>
                            </div>
                            <p class="text-xs text-gray-500 mt-2">{{ form.selectedActivities.length }}/6 selected</p>
                            <p v-if="activitiesWarning" class="text-orange-600 text-xs mt-1">{{ activitiesWarning }}</p>
                            <p v-if="getError('business_activities')" class="text-red-600 text-xs mt-1">{{ getError('business_activities') }}</p>
                        </div>

                        <!-- TPIN -->
                        <div>
                            <label class="block text-xs font-bold tracking-wide text-gray-500 uppercase mb-2">TPIN (Tax ID) *</label>
                            <input 
                                v-model="form.tpin" 
                                type="text" 
                                placeholder="Tax Payer Identification Number"
                                :class="inputClasses('tpin')"
                                required
                            >
                            <p v-if="getError('tpin')" class="text-red-600 text-xs mt-1">{{ getError('tpin') }}</p>
                        </div>

                        <!-- PACRA Reg No -->
                        <div>
                            <label class="block text-xs font-bold tracking-wide text-gray-500 uppercase mb-2">PACRA Reg No. (Optional)</label>
                            <input 
                                v-model="form.pacra_reg_no" 
                                type="text" 
                                placeholder="For corporate entities"
                                :class="inputClasses('pacra_reg_no')"
                            >
                            <p v-if="getError('pacra_reg_no')" class="text-red-600 text-xs mt-1">{{ getError('pacra_reg_no') }}</p>
                        </div>

                        <!-- Short Description -->
                        <div>
                            <label class="block text-xs font-bold tracking-wide text-gray-500 uppercase mb-2">Business Description (Max 500) *</label>
                            <textarea 
                                v-model="form.short_description" 
                                rows="3"
                                placeholder="Brief description of your business"
                                :class="inputClasses('short_description')"
                                required
                            ></textarea>
                            <p class="text-xs text-gray-500 mt-1">{{ form.short_description.length }}/500</p>
                            <p v-if="getError('short_description')" class="text-red-600 text-xs mt-1">{{ getError('short_description') }}</p>
                        </div>

                        <!-- Contact Email -->
                        <div>
                            <label class="block text-xs font-bold tracking-wide text-gray-500 uppercase mb-2">Contact Email *</label>
                            <input 
                                v-model="form.contact_email" 
                                type="email"
                                placeholder="contact@example.com"
                                :class="inputClasses('contact_email')"
                                required
                            >
                            <p v-if="getError('contact_email')" class="text-red-600 text-xs mt-1">{{ getError('contact_email') }}</p>
                        </div>

                        <!-- Phone -->
                        <div>
                            <label class="block text-xs font-bold tracking-wide text-gray-500 uppercase mb-2">Phone Number *</label>
                            <input 
                                v-model="form.phone" 
                                type="tel"
                                placeholder="+260 976 085 160"
                                :class="inputClasses('phone')"
                                required
                            >
                            <p v-if="getError('phone')" class="text-red-600 text-xs mt-1">{{ getError('phone') }}</p>
                        </div>

                        <!-- Address -->
                        <div>
                            <label class="block text-xs font-bold tracking-wide text-gray-500 uppercase mb-2">Business Address (Optional)</label>
                            <textarea 
                                v-model="form.address" 
                                rows="2"
                                placeholder="Street address, city, etc"
                                :class="inputClasses('address')"
                            ></textarea>
                            <p v-if="getError('address')" class="text-red-600 text-xs mt-1">{{ getError('address') }}</p>
                        </div>

                        <!-- Website URL -->
                        <div>
                            <label class="block text-xs font-bold tracking-wide text-gray-500 uppercase mb-2">Website URL (Optional)</label>
                            <input 
                                v-model="form.website_url" 
                                type="url"
                                placeholder="https://www.example.com"
                                :class="inputClasses('website_url')"
                            >
                            <p v-if="getError('website_url')" class="text-red-600 text-xs mt-1">{{ getError('website_url') }}</p>
                        </div>

                        <!-- Social Connectivity -->
                        <div>
                            <label class="block text-xs font-bold tracking-wide text-gray-500 uppercase mb-2">Social Connectivity (Optional)</label>
                            <div class="grid grid-cols-1 sm:grid-cols-3 gap-2">
                                <select v-model="selectedSocialPlatform" :class="inputClasses('social_links')">
                                    <option v-for="option in socialPlatformOptions" :key="option.key" :value="option.key">{{ option.label }}</option>
                                </select>
                                <input
                                    v-model="socialLinkInput"
                                    type="url"
                                    placeholder="https://..."
                                    class="sm:col-span-2 w-full rounded-xl border-2 bg-white px-4 py-3 text-sm text-gray-900 outline-none transition-all duration-300 placeholder:text-gray-400 hover:border-[#1876C3]/50 focus:border-[#1876C3] focus:ring-4 focus:ring-[#1876C3]/15 border-gray-200"
                                >
                            </div>
                            <div class="mt-2">
                                <button type="button" @click="addSocialLink" class="inline-flex px-4 py-2 rounded-lg bg-[#1876C3] text-white text-xs font-bold hover:bg-[#1460A0] transition-all duration-300">Add Social Link</button>
                            </div>
                            <p v-if="socialLinkError" class="text-red-600 text-xs mt-1">{{ socialLinkError }}</p>

                            <div v-if="Object.keys(form.social_links || {}).length" class="mt-3 space-y-2">
                                <div v-for="(url, platform) in form.social_links" :key="platform" class="flex items-center justify-between rounded-lg border border-gray-200 bg-gray-50 px-3 py-2">
                                    <div>
                                        <p class="text-xs font-bold text-[#1D2A68] uppercase">{{ platform }}</p>
                                        <p class="text-xs text-gray-600 truncate max-w-[240px]">{{ url }}</p>
                                    </div>
                                    <button type="button" @click="removeSocialLink(platform)" class="text-xs font-bold text-red-600 hover:text-red-700">Remove</button>
                                </div>
                            </div>
                            <p v-if="getError('social_links')" class="text-red-600 text-xs mt-1">{{ getError('social_links') }}</p>
                            <p v-if="getError('social_links.linkedin') || getError('social_links.facebook') || getError('social_links.x') || getError('social_links.instagram') || getError('social_links.whatsapp')" class="text-red-600 text-xs mt-1">
                                One or more social links are invalid.
                            </p>
                        </div>

                        <!-- Logo Upload -->
                        <div>
                            <label class="block text-xs font-bold tracking-wide text-gray-500 uppercase mb-2">Company Logo (Optional)</label>
                            <input 
                                @change="handleLogoUpload" 
                                type="file" 
                                accept="image/*"
                                :class="inputClasses('logo')"
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
                                class="flex-1 bg-[#1D2A68] text-white font-bold py-3 rounded-xl hover:bg-[#15204f] transition-all duration-300 disabled:opacity-50"
                            >
                                {{ form.processing ? 'Creating...' : 'Create Profile' }}
                            </button>
                            <a href="/dashboard" class="flex-1 bg-gray-100 border border-gray-200 text-gray-700 font-bold py-3 rounded-xl hover:bg-gray-200 transition-all duration-300 text-center">
                                Cancel
                            </a>
                        </div>
                    </form>

                    </div>

                    <aside class="bg-white border border-gray-100 rounded-xl p-6 shadow-sm lg:sticky lg:top-24">
                        <h3 class="text-sm font-bold tracking-wide text-[#1D2A68] uppercase mb-4">Live Preview</h3>
                        <div class="rounded-xl border border-gray-200 p-5 bg-gray-50">
                            <h4 class="text-lg font-bold text-gray-900">{{ form.company_name || 'Your Business Name' }}</h4>
                            <p class="mt-2 text-sm text-gray-600">{{ form.short_description || 'Your business description will appear here as members browse the directory.' }}</p>

                            <div class="mt-3 flex flex-wrap gap-2">
                                <span v-if="form.member_type" class="inline-block px-3 py-1 bg-blue-100 text-blue-800 rounded-full text-xs font-bold">{{ form.member_type }}</span>
                                <span v-if="form.industry_sector" class="inline-block px-3 py-1 bg-indigo-100 text-indigo-800 rounded-full text-xs font-bold">{{ form.industry_sector }}</span>
                            </div>

                            <div class="mt-4 flex flex-wrap gap-2">
                                <span
                                    v-for="activity in form.selectedActivities"
                                    :key="activity"
                                    class="inline-flex px-2.5 py-1 rounded-full text-[11px] font-semibold bg-gray-200 text-gray-700"
                                >
                                    {{ activity }}
                                </span>
                            </div>
                        </div>
                    </aside>
                </div>
            </div>
        </div>
    </AuthenticatedLayout>
</template>