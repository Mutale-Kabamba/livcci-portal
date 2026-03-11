<script setup>
import { Head, Link } from '@inertiajs/vue3';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { computed } from 'vue';

const props = defineProps({
    businessProfile: Object,
});

const profile = computed(() => props.businessProfile);
const user = computed(() => profile.value?.user || {});

const memberStatusColors = {
    'Individual': 'bg-blue-100 text-blue-800',
    'Co-operative': 'bg-green-100 text-green-800',
    'Business': 'bg-purple-100 text-purple-800',
    'Academia': 'bg-yellow-100 text-yellow-800',
    'Corporate': 'bg-red-100 text-red-800',
    'Affiliate': 'bg-indigo-100 text-indigo-800',
};

const getStatusColor = (type) => memberStatusColors[type] || 'bg-gray-100 text-gray-800';

const getStatusDisplay = (status) => {
    const statusMap = {
        'pending': { label: 'Pending Review', color: 'bg-yellow-100 text-yellow-800' },
        'approved': { label: 'Approved', color: 'bg-green-100 text-green-800' },
        'suspended': { label: 'Suspended', color: 'bg-red-100 text-red-800' },
        'deactivated': { label: 'Deactivated', color: 'bg-gray-100 text-gray-800' },
    };
    return statusMap[status] || { label: status, color: 'bg-gray-100 text-gray-800' };
};

const statusDisplay = computed(() => getStatusDisplay(profile.value?.status));
</script>

<template>
    <Head :title="profile.company_name + ' - Business Profile'" />

    <AuthenticatedLayout>
        <template #header>
            <div class="flex justify-between items-center">
                <h2 class="font-semibold text-xl text-gray-800 leading-tight">{{ profile.company_name }}</h2>
                <Link href="/directory" class="text-blue-600 hover:text-blue-800 text-sm">
                    ← Back to Directory
                </Link>
            </div>
        </template>

        <div class="py-12">
            <div class="max-w-4xl mx-auto sm:px-6 lg:px-8">
                <div class="bg-white overflow-hidden shadow-sm sm:rounded-lg">
                    <div class="p-6 text-gray-900">
                        <!-- Logo and Header Section -->
                        <div class="mb-8">
                            <div class="flex flex-col md:flex-row gap-6">
                                <!-- Logo -->
                                <div class="md:w-1/3">
                                    <div v-if="profile.logo_url" class="w-full bg-gray-100 rounded-lg overflow-hidden">
                                        <img :src="profile.logo_url" :alt="profile.company_name" class="w-full h-auto object-cover">
                                    </div>
                                    <div v-else class="w-full h-48 bg-gray-200 rounded-lg flex items-center justify-center">
                                        <span class="text-gray-400">No logo</span>
                                    </div>
                                </div>

                                <!-- Header Info -->
                                <div class="md:w-2/3">
                                    <div class="mb-4">
                                        <div class="flex flex-wrap gap-2 mb-4">
                                            <span :class="['px-3 py-1 rounded-full text-sm font-semibold', getStatusColor(profile.member_type)]">
                                                {{ profile.member_type }}
                                            </span>
                                            <span :class="['px-3 py-1 rounded-full text-sm font-semibold', statusDisplay.color]">
                                                {{ statusDisplay.label }}
                                            </span>
                                        </div>
                                        <h3 class="text-2xl font-bold text-gray-800 mb-2">{{ profile.company_name }}</h3>
                                        <p class="text-gray-600 text-sm mb-6">{{ profile.member_category }}</p>
                                        <p class="text-gray-700 mb-4">{{ profile.short_description }}</p>
                                    </div>

                                    <!-- Quick Contact -->
                                    <div class="bg-gray-50 border border-gray-200 rounded-lg p-4">
                                        <h4 class="font-semibold text-gray-800 mb-3">Quick Contact</h4>
                                        <div class="space-y-2 text-sm">
                                            <div>
                                                <span class="text-gray-600">Email:</span>
                                                <a :href="`mailto:${profile.contact_email}`" class="text-blue-600 hover:underline ml-2">
                                                    {{ profile.contact_email }}
                                                </a>
                                            </div>
                                            <div>
                                                <span class="text-gray-600">Phone:</span>
                                                <a :href="`tel:${profile.phone}`" class="text-blue-600 hover:underline ml-2">
                                                    {{ profile.phone }}
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Detailed Information -->
                        <div class="grid md:grid-cols-2 gap-8">
                            <!-- Business Details -->
                            <div>
                                <h4 class="text-lg font-semibold text-gray-800 mb-4">Business Details</h4>
                                <div class="space-y-4">
                                    <div>
                                        <label class="text-sm text-gray-600 font-semibold">Industry Sector</label>
                                        <p class="text-gray-800">{{ profile.industry_sector }}</p>
                                    </div>
                                    <div>
                                        <label class="text-sm text-gray-600 font-semibold">Membership Type</label>
                                        <p class="text-gray-800">{{ profile.member_type }}</p>
                                    </div>
                                    <div>
                                        <label class="text-sm text-gray-600 font-semibold">Category</label>
                                        <p class="text-gray-800">{{ profile.member_category }}</p>
                                    </div>
                                    <div>
                                        <label class="text-sm text-gray-600 font-semibold">Address</label>
                                        <p class="text-gray-800">{{ profile.address || 'Not provided' }}</p>
                                    </div>
                                </div>
                            </div>

                            <!-- Registration Details -->
                            <div>
                                <h4 class="text-lg font-semibold text-gray-800 mb-4">Registration Details</h4>
                                <div class="space-y-4">
                                    <div>
                                        <label class="text-sm text-gray-600 font-semibold">TPIN</label>
                                        <p class="text-gray-800 font-mono">{{ profile.tpin }}</p>
                                    </div>
                                    <div v-if="profile.pacra_reg_no">
                                        <label class="text-sm text-gray-600 font-semibold">PACRA Registration</label>
                                        <p class="text-gray-800 font-mono">{{ profile.pacra_reg_no }}</p>
                                    </div>
                                    <div v-if="profile.website_url">
                                        <label class="text-sm text-gray-600 font-semibold">Website</label>
                                        <a :href="profile.website_url" target="_blank" rel="noopener noreferrer" class="text-blue-600 hover:underline break-all">
                                            {{ profile.website_url }}
                                        </a>
                                    </div>
                                    <div>
                                        <label class="text-sm text-gray-600 font-semibold">Member Since</label>
                                        <p class="text-gray-800">{{ new Date(profile.created_at).toLocaleDateString() }}</p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Contact Details Section -->
                        <div class="mt-8 pt-8 border-t border-gray-200">
                            <h4 class="text-lg font-semibold text-gray-800 mb-4">Contact Information</h4>
                            <div class="grid md:grid-cols-2 gap-6">
                                <div>
                                    <label class="text-sm text-gray-600 font-semibold">Contact Email</label>
                                    <a :href="`mailto:${profile.contact_email}`" class="text-blue-600 hover:underline">
                                        {{ profile.contact_email }}
                                    </a>
                                </div>
                                <div>
                                    <label class="text-sm text-gray-600 font-semibold">Phone Number</label>
                                    <a :href="`tel:${profile.phone}`" class="text-blue-600 hover:underline">
                                        {{ profile.phone }}
                                    </a>
                                </div>
                            </div>
                        </div>

                        <!-- Footer Info -->
                        <div class="mt-8 pt-8 border-t border-gray-200 text-xs text-gray-500">
                            <p>Last updated: {{ new Date(profile.updated_at).toLocaleDateString() }}</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </AuthenticatedLayout>
</template>
