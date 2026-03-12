<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { Head, Link, useForm } from '@inertiajs/vue3';

const props = defineProps({
    businessProfiles: {
        type: Array,
        default: () => [],
    },
    totalOutstandingDues: {
        type: Number,
        default: 0,
    },
    unpaidProfileIds: {
        type: Array,
        default: () => [],
    },
});

const payAllForm = useForm({});

const payAllDues = () => {
    payAllForm.post(route('dashboard.pay-all'), {
        preserveScroll: true,
    });
};

const hasUnpaidInvoice = (profileId) => props.unpaidProfileIds.includes(profileId);

const normalizeActivities = (value) => {
    if (Array.isArray(value)) {
        return value.filter(Boolean);
    }

    if (typeof value === 'string' && value.trim() !== '') {
        try {
            const parsed = JSON.parse(value);
            if (Array.isArray(parsed)) {
                return parsed.filter(Boolean);
            }
        } catch {
            return value
                .split(',')
                .map((item) => item.trim())
                .filter(Boolean);
        }
    }

    return [];
};

const getActivities = (profile) => normalizeActivities(profile.business_activities);

const getCardStatus = (profile) => {
    if (
        profile.status === 'approved' &&
        profile.subscription_expiry &&
        new Date(profile.subscription_expiry) < new Date(new Date().toDateString())
    ) {
        return 'expired';
    }

    return profile.status || 'pending';
};

const getStatusBadgeClass = (status) => {
    const state = String(status).toLowerCase();

    if (state === 'approved') return 'text-green-800 bg-green-100';
    if (state === 'pending') return 'text-yellow-800 bg-yellow-100';
    if (state === 'expired') return 'text-red-800 bg-red-100';
    if (state === 'suspended') return 'text-orange-800 bg-orange-100';
    if (state === 'deactivated') return 'text-gray-800 bg-gray-200';
    return 'text-blue-800 bg-blue-100';
};

const formatStatus = (status) => {
    const state = String(status || 'pending').toLowerCase();
    return state.charAt(0).toUpperCase() + state.slice(1);
};

const getCompletionScore = (profile) => {
    const activities = getActivities(profile);
    const checks = [
        !!profile.company_name,
        !!profile.member_type,
        !!profile.industry_sector,
        !!profile.short_description,
        !!profile.tpin,
        !!profile.contact_email,
        !!profile.phone,
        !!profile.address,
        !!profile.website_url,
        !!profile.logo_url,
        activities.length > 0,
    ];

    const completed = checks.filter(Boolean).length;
    return Math.round((completed / checks.length) * 100);
};

const getCompletionBarClass = (score) => {
    if (score >= 80) return 'bg-green-500';
    if (score >= 60) return 'bg-[#1876C3]';
    return 'bg-yellow-500';
};
</script>

<template>
    <Head title="Member Dashboard" />

    <AuthenticatedLayout>
        <template #header>
            <h2 class="font-semibold text-xl text-gray-800 leading-tight">LiVCCI Member Dashboard</h2>
        </template>

        <div class="py-12">
            <div class="max-w-7xl mx-auto sm:px-6 lg:px-8 space-y-6">
                
                <div class="bg-white overflow-hidden shadow-sm sm:rounded-lg">
                    <div class="p-6 text-gray-900">
                        Welcome to the Livingstone Chamber of Commerce Portal. Manage your membership and business listing here.
                    </div>
                </div>

                <div class="bg-[#1D2A68] text-white rounded-xl shadow-sm p-5 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
                    <div>
                        <p class="text-xs uppercase tracking-wide text-blue-100 font-semibold">Financial Overview</p>
                        <p class="text-sm text-blue-100 mt-1">Total Outstanding Dues across all businesses</p>
                        <p class="text-2xl font-extrabold mt-2">ZMW {{ Number(totalOutstandingDues || 0).toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 }) }}</p>
                    </div>
                    <button
                        @click="payAllDues"
                        :disabled="payAllForm.processing || Number(totalOutstandingDues || 0) <= 0"
                        class="bg-[#1876C3] hover:bg-[#1460A0] transition-all duration-300 text-white font-bold py-2.5 px-5 rounded-lg disabled:opacity-50 disabled:cursor-not-allowed"
                    >
                        {{ payAllForm.processing ? 'Processing...' : 'Pay All' }}
                    </button>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div
                        v-for="profile in businessProfiles"
                        :key="profile.id"
                        class="rounded-xl bg-white border-t-4 border-[#1D2A68] p-6 shadow-sm hover:shadow-lg transition"
                    >
                        <div class="flex items-start justify-between gap-3">
                            <h3 class="text-lg font-bold text-gray-900">{{ profile.company_name }}</h3>
                            <div class="flex items-start gap-2">
                                <span class="px-3 py-1 text-xs font-semibold rounded-full" :class="getStatusBadgeClass(getCardStatus(profile))">
                                    {{ formatStatus(getCardStatus(profile)) }}
                                </span>
                                <details class="relative">
                                    <summary class="list-none cursor-pointer rounded-full p-1.5 hover:bg-gray-100 text-gray-500">
                                        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                                            <path d="M10 6a1.5 1.5 0 110-3 1.5 1.5 0 010 3zm0 5a1.5 1.5 0 110-3 1.5 1.5 0 010 3zm0 5a1.5 1.5 0 110-3 1.5 1.5 0 010 3z" />
                                        </svg>
                                    </summary>
                                    <div class="absolute right-0 mt-2 w-44 rounded-lg border border-gray-200 bg-white shadow-lg z-20 p-1">
                                        <Link :href="route('profile.business.edit')" class="block rounded-md px-3 py-2 text-xs font-semibold text-[#1D2A68] hover:bg-[#1D2A68]/10">
                                            Edit Profile
                                        </Link>
                                        <Link :href="route('directory.show', profile.id)" class="block rounded-md px-3 py-2 text-xs font-semibold text-[#1876C3] hover:bg-[#1876C3]/10">
                                            View Public Page
                                        </Link>
                                        <a
                                            v-if="String(getCardStatus(profile)).toLowerCase() === 'approved'"
                                            :href="route('admin.members.certificate', profile.id)"
                                            class="block rounded-md px-3 py-2 text-xs font-semibold text-green-700 hover:bg-green-50"
                                        >
                                            Download Certificate
                                        </a>
                                        <span
                                            v-else
                                            class="block rounded-md px-3 py-2 text-xs font-semibold text-gray-400"
                                        >
                                            Download Certificate
                                        </span>
                                    </div>
                                </details>
                            </div>
                        </div>

                        <p class="mt-3 text-sm text-gray-600">{{ profile.short_description || 'No description provided.' }}</p>

                        <p v-if="profile.industry_sector" class="mt-3 text-xs font-medium text-gray-500 uppercase tracking-wide">
                            Industry: {{ profile.industry_sector }}
                        </p>

                        <div class="mt-4 flex flex-wrap gap-2">
                            <span class="inline-block px-3 py-1 bg-blue-100 text-blue-800 rounded-full text-xs font-bold">{{ profile.member_type || 'N/A' }}</span>
                        </div>

                        <div class="mt-3 flex flex-wrap gap-2">
                            <span
                                v-for="activity in getActivities(profile)"
                                :key="activity"
                                class="inline-flex px-2.5 py-1 rounded-full text-[11px] font-semibold bg-gray-100 text-gray-700"
                            >
                                {{ activity }}
                            </span>
                            <span v-if="getActivities(profile).length === 0" class="text-xs text-gray-400">No activities added</span>
                        </div>

                        <div class="mt-5">
                            <div class="flex justify-between items-center mb-1">
                                <span class="text-xs font-semibold text-gray-500 uppercase">Completion Score</span>
                                <span class="text-xs font-bold text-[#1D2A68]">{{ getCompletionScore(profile) }}%</span>
                            </div>
                            <div class="w-full h-2.5 rounded-full bg-gray-200 overflow-hidden">
                                <div
                                    class="h-full transition-all duration-300"
                                    :class="getCompletionBarClass(getCompletionScore(profile))"
                                    :style="{ width: getCompletionScore(profile) + '%' }"
                                ></div>
                            </div>
                        </div>

                        <div class="mt-5 space-y-1 text-sm text-gray-700">
                            <div><span class="font-semibold">Email:</span> {{ profile.contact_email }}</div>
                            <div><span class="font-semibold">Phone:</span> {{ profile.phone }}</div>
                            <div><span class="font-semibold">TPIN:</span> {{ profile.tpin }}</div>
                        </div>

                        <div v-if="hasUnpaidInvoice(profile.id)" class="mt-4 rounded-lg border border-yellow-200 bg-yellow-50 px-3 py-2 text-xs text-yellow-800 font-semibold flex items-center gap-2">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v2m0 4h.01M4.93 19h14.14c1.54 0 2.5-1.67 1.73-3L13.73 4c-.77-1.33-2.69-1.33-3.46 0L3.2 16c-.77 1.33.19 3 1.73 3z" />
                            </svg>
                            <span>Action Required: Annual Dues unpaid.</span>
                        </div>
                    </div>

                    <div
                        v-if="businessProfiles.length < 4"
                        class="rounded-xl bg-white border-2 border-dashed border-[#1D2A68]/40 p-6 shadow-sm hover:shadow-lg transition flex flex-col justify-center"
                    >
                        <h3 class="text-lg font-bold text-[#1D2A68]">Create New Business</h3>
                        <p class="mt-2 text-sm text-gray-600">Add another business profile to your member account.</p>
                        <div class="mt-4">
                            <Link :href="route('profile.business.create')" class="inline-flex bg-[#1D2A68] hover:bg-[#15204f] text-white font-bold py-2 px-4 rounded shadow">
                                + Create Business Profile
                            </Link>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </AuthenticatedLayout>
</template>