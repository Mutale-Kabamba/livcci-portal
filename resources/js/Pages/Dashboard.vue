<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import FinancialHealth from '@/Components/FinancialHealth.vue';
import { Head, Link, useForm, usePage } from '@inertiajs/vue3';
import { computed } from 'vue';

const page = usePage();

const props = defineProps({
    businessProfiles: { type: Array, default: () => [] },
    totalOutstandingDues: { type: Number, default: 0 },
    unpaidProfileIds: { type: Array, default: () => [] },
    upcomingEvents: { type: Array, default: () => [] },
});

const flash = computed(() => page.props?.flash || {});
const userName = computed(() => page.props?.auth?.user?.name || 'Member');

const payAllForm = useForm({});
const payAllDues = () => payAllForm.post(route('dashboard.pay-all'), { preserveScroll: true });
const hasUnpaidInvoice = (profileId) => props.unpaidProfileIds.includes(profileId);

const normalizeActivities = (value) => {
    if (Array.isArray(value)) return value.filter(Boolean);
    if (typeof value === 'string' && value.trim()) {
        try { const p = JSON.parse(value); if (Array.isArray(p)) return p.filter(Boolean); } catch {}
        return value.split(',').map(i => i.trim()).filter(Boolean);
    }
    return [];
};
const getActivities = (p) => normalizeActivities(p.business_activities);
const getCardStatus = (p) => {
    if (p.status === 'approved' && p.subscription_expiry && new Date(p.subscription_expiry) < new Date(new Date().toDateString())) return 'expired';
    return p.status || 'pending';
};
const getStatusBadgeClass = (s) => {
    const st = String(s).toLowerCase();
    if (st === 'approved') return 'text-green-800 bg-green-100';
    if (st === 'pending') return 'text-yellow-800 bg-yellow-100';
    if (st === 'expired') return 'text-red-800 bg-red-100';
    if (st === 'suspended') return 'text-orange-800 bg-orange-100';
    if (st === 'deactivated') return 'text-gray-800 bg-gray-200';
    return 'text-blue-800 bg-blue-100';
};
const formatStatus = (s) => { const st = String(s||'pending').toLowerCase(); return st.charAt(0).toUpperCase()+st.slice(1); };
const getCompletionScore = (p) => {
    const acts = getActivities(p);
    const checks = [!!p.company_name,!!p.member_type,!!p.industry_sector,!!p.short_description,!!p.tpin,!!p.contact_email,!!p.phone,!!p.address,!!p.website_url,!!p.logo_url,acts.length>0];
    return Math.round((checks.filter(Boolean).length/checks.length)*100);
};
const getCompletionBarClass = (sc) => sc >= 80 ? 'bg-green-500' : sc >= 60 ? 'bg-[#1876C3]' : 'bg-yellow-500';
const approvedCount = computed(() => props.businessProfiles.filter(p => p.status === 'approved').length);
const pendingCount = computed(() => props.businessProfiles.filter(p => p.status === 'pending').length);
</script>

<template>
    <Head title="Member Dashboard" />
    <AuthenticatedLayout>
        <template #header>
            <h2 class="font-semibold text-xl text-gray-800 leading-tight">LiVCCI Member Dashboard</h2>
        </template>

        <div class="py-8">
            <div class="max-w-7xl mx-auto sm:px-6 lg:px-8 space-y-6">

                <!-- Flash Messages -->
                <div v-if="flash.success" class="rounded-lg bg-green-50 border border-green-200 px-4 py-3 text-sm text-green-800 font-medium flex items-center gap-2">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 flex-shrink-0 text-green-500" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" /></svg>
                    {{ flash.success }}
                </div>
                <div v-if="flash.error" class="rounded-lg bg-red-50 border border-red-200 px-4 py-3 text-sm text-red-800 font-medium flex items-center gap-2">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 flex-shrink-0 text-red-500" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clip-rule="evenodd" /></svg>
                    {{ flash.error }}
                </div>

                <!-- Welcome Banner -->
                <div class="bg-gradient-to-r from-[#1D2A68] to-[#1876C3] text-white rounded-xl shadow p-6">
                    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
                        <div>
                            <p class="text-blue-100 text-sm font-medium">Welcome back,</p>
                            <h1 class="text-2xl font-extrabold mt-0.5">{{ userName }}</h1>
                            <p class="text-blue-200 text-sm mt-1">Livingstone Chamber of Commerce &amp; Industry Portal</p>
                        </div>
                        <div class="flex gap-3 flex-wrap">
                            <div class="text-center bg-white/10 rounded-lg px-4 py-2 min-w-[70px]">
                                <p class="text-2xl font-extrabold">{{ businessProfiles.length }}</p>
                                <p class="text-xs text-blue-200 mt-0.5">Business{{ businessProfiles.length !== 1 ? 'es' : '' }}</p>
                            </div>
                            <div class="text-center bg-white/10 rounded-lg px-4 py-2 min-w-[70px]">
                                <p class="text-2xl font-extrabold text-green-300">{{ approvedCount }}</p>
                                <p class="text-xs text-blue-200 mt-0.5">Approved</p>
                            </div>
                            <div v-if="pendingCount > 0" class="text-center bg-white/10 rounded-lg px-4 py-2 min-w-[70px]">
                                <p class="text-2xl font-extrabold text-yellow-300">{{ pendingCount }}</p>
                                <p class="text-xs text-blue-200 mt-0.5">Pending</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Quick Actions -->
                <div>
                    <h2 class="text-sm font-bold text-gray-500 uppercase tracking-wide mb-3">Quick Actions</h2>
                    <div class="grid grid-cols-2 sm:grid-cols-4 gap-4">
                        <Link :href="route('profile.business.create')" class="flex flex-col items-center justify-center gap-2 bg-white rounded-xl border border-gray-200 shadow-sm p-4 hover:shadow-md hover:border-[#1876C3] transition group">
                            <div class="h-10 w-10 rounded-full bg-[#1D2A68]/10 flex items-center justify-center group-hover:bg-[#1876C3]/20 transition">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-[#1D2A68]" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M12 4v16m8-8H4" /></svg>
                            </div>
                            <span class="text-xs font-semibold text-gray-700 text-center">Add Business</span>
                        </Link>
                        <Link :href="route('directory.index')" class="flex flex-col items-center justify-center gap-2 bg-white rounded-xl border border-gray-200 shadow-sm p-4 hover:shadow-md hover:border-[#1876C3] transition group">
                            <div class="h-10 w-10 rounded-full bg-[#1876C3]/10 flex items-center justify-center group-hover:bg-[#1876C3]/20 transition">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-[#1876C3]" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M17 20h5v-2a4 4 0 00-4-4h-1M9 20H4v-2a4 4 0 014-4h1m4-4a4 4 0 100-8 4 4 0 000 8zm6 0a2 2 0 100-4 2 2 0 000 4zM3 10a2 2 0 100-4 2 2 0 000 4z" /></svg>
                            </div>
                            <span class="text-xs font-semibold text-gray-700 text-center">Member Directory</span>
                        </Link>
                        <Link :href="route('profile.edit')" class="flex flex-col items-center justify-center gap-2 bg-white rounded-xl border border-gray-200 shadow-sm p-4 hover:shadow-md hover:border-[#1876C3] transition group">
                            <div class="h-10 w-10 rounded-full bg-purple-100 flex items-center justify-center group-hover:bg-purple-200 transition">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-purple-700" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M5.121 17.804A9.003 9.003 0 0112 15a9.003 9.003 0 016.879 2.804M15 11a3 3 0 11-6 0 3 3 0 016 0z" /></svg>
                            </div>
                            <span class="text-xs font-semibold text-gray-700 text-center">Account Settings</span>
                        </Link>
                        <Link :href="route('membership')" class="flex flex-col items-center justify-center gap-2 bg-white rounded-xl border border-gray-200 shadow-sm p-4 hover:shadow-md hover:border-[#1876C3] transition group">
                            <div class="h-10 w-10 rounded-full bg-amber-100 flex items-center justify-center group-hover:bg-amber-200 transition">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-amber-700" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" /></svg>
                            </div>
                            <span class="text-xs font-semibold text-gray-700 text-center">Membership Benefits</span>
                        </Link>
                    </div>
                </div>

                <!-- Financial Overview -->
                <div class="bg-[#1D2A68] text-white rounded-xl shadow-sm p-5 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
                    <div>
                        <p class="text-xs uppercase tracking-wide text-blue-100 font-semibold">Financial Overview</p>
                        <p class="text-sm text-blue-100 mt-1">Total Outstanding Dues across all businesses</p>
                        <p class="text-3xl font-extrabold mt-2">ZMW {{ Number(totalOutstandingDues || 0).toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 }) }}</p>
                    </div>
                    <div class="flex flex-col gap-2 items-start sm:items-end">
                        <button
                            @click="payAllDues"
                            :disabled="payAllForm.processing || Number(totalOutstandingDues || 0) <= 0"
                            class="bg-[#1876C3] hover:bg-[#1460A0] transition text-white font-bold py-2.5 px-6 rounded-lg disabled:opacity-50 disabled:cursor-not-allowed w-full sm:w-auto"
                        >{{ payAllForm.processing ? 'Processing…' : 'Pay All Dues' }}</button>
                        <p v-if="Number(totalOutstandingDues || 0) <= 0" class="text-xs text-green-300 font-semibold">✓ All dues are settled</p>
                    </div>
                </div>

                <!-- Business Profiles -->
                <div>
                    <h2 class="text-sm font-bold text-gray-500 uppercase tracking-wide mb-3">My Business Profiles</h2>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div v-for="profile in businessProfiles" :key="profile.id" class="rounded-xl bg-white border-t-4 border-[#1D2A68] p-6 shadow-sm hover:shadow-lg transition">

                            <!-- Card Header -->
                            <div class="flex items-start justify-between gap-3">
                                <div class="flex items-center gap-3 min-w-0">
                                    <img v-if="profile.logo_url" :src="profile.logo_url" :alt="profile.company_name" class="h-10 w-10 rounded-full object-cover border border-gray-200 flex-shrink-0" />
                                    <div v-else class="h-10 w-10 rounded-full bg-[#1D2A68]/10 flex items-center justify-center flex-shrink-0">
                                        <span class="text-sm font-bold text-[#1D2A68]">{{ (profile.company_name || '?')[0].toUpperCase() }}</span>
                                    </div>
                                    <h3 class="text-base font-bold text-gray-900 leading-tight truncate">{{ profile.company_name }}</h3>
                                </div>
                                <span class="px-2.5 py-1 text-xs font-semibold rounded-full flex-shrink-0" :class="getStatusBadgeClass(getCardStatus(profile))">{{ formatStatus(getCardStatus(profile)) }}</span>
                            </div>

                            <p class="mt-3 text-sm text-gray-600 line-clamp-2">{{ profile.short_description || 'No description provided.' }}</p>
                            <p v-if="profile.industry_sector" class="mt-2 text-xs font-semibold text-gray-500 uppercase tracking-wide">{{ profile.industry_sector }}</p>

                            <div class="mt-3">
                                <span class="inline-block px-3 py-1 bg-blue-100 text-blue-800 rounded-full text-xs font-bold">{{ profile.member_type || 'N/A' }}</span>
                            </div>

                            <div class="mt-3 flex flex-wrap gap-1.5">
                                <span v-for="act in getActivities(profile)" :key="act" class="inline-flex px-2 py-0.5 rounded-full text-[11px] font-semibold bg-gray-100 text-gray-700">{{ act }}</span>
                                <span v-if="getActivities(profile).length === 0" class="text-xs text-gray-400">No activities listed</span>
                            </div>

                            <!-- Completion Bar -->
                            <div class="mt-4">
                                <div class="flex justify-between items-center mb-1">
                                    <span class="text-xs font-semibold text-gray-500 uppercase">Profile Completion</span>
                                    <span class="text-xs font-bold text-[#1D2A68]">{{ getCompletionScore(profile) }}%</span>
                                </div>
                                <div class="w-full h-2 rounded-full bg-gray-200 overflow-hidden">
                                    <div class="h-full transition-all" :class="getCompletionBarClass(getCompletionScore(profile))" :style="{ width: getCompletionScore(profile) + '%' }"></div>
                                </div>
                            </div>

                            <!-- Contact Info -->
                            <div class="mt-4 grid grid-cols-2 gap-x-4 gap-y-1 text-xs text-gray-600">
                                <div v-if="profile.contact_email"><span class="font-semibold">Email:</span> {{ profile.contact_email }}</div>
                                <div v-if="profile.phone"><span class="font-semibold">Phone:</span> {{ profile.phone }}</div>
                                <div v-if="profile.tpin"><span class="font-semibold">TPIN:</span> {{ profile.tpin }}</div>
                                <div v-if="profile.subscription_expiry"><span class="font-semibold">Expires:</span> {{ profile.subscription_expiry }}</div>
                            </div>

                            <FinancialHealth :profile="profile" />

                            <!-- Unpaid Warning -->
                            <div v-if="hasUnpaidInvoice(profile.id)" class="mt-4 rounded-lg border border-yellow-200 bg-yellow-50 px-3 py-2 text-xs text-yellow-800 font-semibold flex items-center gap-2">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M12 9v2m0 4h.01M4.93 19h14.14c1.54 0 2.5-1.67 1.73-3L13.73 4c-.77-1.33-2.69-1.33-3.46 0L3.2 16c-.77 1.33.19 3 1.73 3z" /></svg>
                                Action Required: Annual Dues unpaid.
                            </div>

                            <!-- Action Buttons -->
                            <div class="mt-5 pt-4 border-t border-gray-100 flex flex-wrap gap-2">
                                <Link :href="route('profile.business.edit')" class="inline-flex items-center gap-1.5 px-3 py-1.5 text-xs font-semibold rounded-lg bg-[#1D2A68] text-white hover:bg-[#15204f] transition">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-3.5 w-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" /></svg>
                                    Edit Profile
                                </Link>
                                <Link :href="route('directory.show', profile.slug || profile.id)" class="inline-flex items-center gap-1.5 px-3 py-1.5 text-xs font-semibold rounded-lg bg-gray-100 text-gray-700 hover:bg-gray-200 transition">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-3.5 w-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" /><path stroke-linecap="round" stroke-linejoin="round" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" /></svg>
                                    View Listing
                                </Link>
                                <a v-if="profile.invoice_pdf_path" :href="route('profile.business.invoice.download', profile.id)" class="inline-flex items-center gap-1.5 px-3 py-1.5 text-xs font-semibold rounded-lg bg-blue-50 text-blue-700 hover:bg-blue-100 transition">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-3.5 w-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" /></svg>
                                    Invoice
                                </a>
                                <a v-if="String(getCardStatus(profile)).toLowerCase() === 'approved'" :href="route('profile.business.certificate.download', profile.id)" class="inline-flex items-center gap-1.5 px-3 py-1.5 text-xs font-semibold rounded-lg bg-green-50 text-green-700 hover:bg-green-100 transition">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-3.5 w-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4M7.835 4.697a3.42 3.42 0 001.946-.806 3.42 3.42 0 014.438 0 3.42 3.42 0 001.946.806 3.42 3.42 0 013.138 3.138 3.42 3.42 0 00.806 1.946 3.42 3.42 0 010 4.438 3.42 3.42 0 00-.806 1.946 3.42 3.42 0 01-3.138 3.138 3.42 3.42 0 00-1.946.806 3.42 3.42 0 01-4.438 0 3.42 3.42 0 00-1.946-.806 3.42 3.42 0 01-3.138-3.138 3.42 3.42 0 00-.806-1.946 3.42 3.42 0 010-4.438 3.42 3.42 0 00.806-1.946 3.42 3.42 0 013.138-3.138z" /></svg>
                                    Certificate
                                </a>
                            </div>
                        </div>

                        <!-- Add New Business -->
                        <div v-if="businessProfiles.length < 4" class="rounded-xl bg-white border-2 border-dashed border-[#1D2A68]/30 p-6 shadow-sm hover:border-[#1876C3]/50 transition flex flex-col items-center justify-center text-center gap-3">
                            <div class="h-14 w-14 rounded-full bg-[#1D2A68]/10 flex items-center justify-center">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-7 w-7 text-[#1D2A68]" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5"><path stroke-linecap="round" stroke-linejoin="round" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" /></svg>
                            </div>
                            <div>
                                <h3 class="text-base font-bold text-[#1D2A68]">Add New Business</h3>
                                <p class="mt-1 text-xs text-gray-500">Register another business ({{ businessProfiles.length }}/4 used)</p>
                            </div>
                            <Link :href="route('profile.business.create')" class="inline-flex items-center gap-1.5 bg-[#1D2A68] hover:bg-[#15204f] text-white font-bold py-2 px-5 rounded-lg shadow text-sm transition">
                                + Create Business Profile
                            </Link>
                        </div>
                    </div>
                </div>

                <!-- Upcoming Events -->
                <div v-if="upcomingEvents.length > 0">
                    <div class="flex items-center justify-between mb-3">
                        <h2 class="text-sm font-bold text-gray-500 uppercase tracking-wide">Upcoming Events</h2>
                        <Link :href="route('news')" class="text-xs text-[#1876C3] font-semibold hover:underline">View All →</Link>
                    </div>
                    <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
                        <div v-for="event in upcomingEvents" :key="event.id" class="bg-white rounded-xl border border-gray-200 shadow-sm p-4 hover:shadow-md transition">
                            <div class="flex items-start gap-3">
                                <div class="flex-shrink-0 w-12 text-center bg-[#1D2A68] text-white rounded-lg py-1.5 px-2">
                                    <p class="text-lg font-extrabold leading-none">{{ new Date(event.event_date).getDate() }}</p>
                                    <p class="text-[10px] uppercase font-semibold">{{ new Date(event.event_date).toLocaleString('default', { month: 'short' }) }}</p>
                                </div>
                                <div class="min-w-0">
                                    <p class="text-sm font-bold text-gray-900 leading-tight">{{ event.title }}</p>
                                    <p class="text-xs text-[#1876C3] font-semibold mt-0.5">{{ event.type }}</p>
                                    <p v-if="event.event_end_date" class="text-xs text-gray-500 mt-0.5">
                                        {{ new Date(event.event_date).toLocaleDateString('en-ZM', { day: 'numeric', month: 'short' }) }} – {{ new Date(event.event_end_date).toLocaleDateString('en-ZM', { day: 'numeric', month: 'short', year: 'numeric' }) }}
                                    </p>
                                    <p v-if="event.description" class="text-xs text-gray-500 mt-1 line-clamp-2">{{ event.description }}</p>
                                </div>
                            </div>
                            <a v-if="event.external_link" :href="event.external_link" target="_blank" rel="noopener noreferrer" class="mt-3 inline-flex items-center text-xs text-[#1876C3] font-semibold hover:underline">Learn More →</a>
                        </div>
                    </div>
                </div>

                <!-- Member Resources -->
                <div class="bg-white rounded-xl border border-gray-200 shadow-sm p-6">
                    <h2 class="text-sm font-bold text-gray-500 uppercase tracking-wide mb-4">Member Resources</h2>
                    <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-3">
                        <Link :href="route('about')" class="flex items-center gap-3 p-3 rounded-lg hover:bg-gray-50 border border-gray-100 transition">
                            <div class="h-8 w-8 rounded-full bg-[#1D2A68]/10 flex items-center justify-center flex-shrink-0"><svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-[#1D2A68]" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" /></svg></div>
                            <div><p class="text-xs font-bold text-gray-800">About LiVCCI</p><p class="text-[11px] text-gray-500">Chamber overview &amp; mission</p></div>
                        </Link>
                        <Link :href="route('strategic-goals')" class="flex items-center gap-3 p-3 rounded-lg hover:bg-gray-50 border border-gray-100 transition">
                            <div class="h-8 w-8 rounded-full bg-amber-100 flex items-center justify-center flex-shrink-0"><svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-amber-700" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" /></svg></div>
                            <div><p class="text-xs font-bold text-gray-800">Strategic Goals</p><p class="text-[11px] text-gray-500">Chamber vision &amp; strategy</p></div>
                        </Link>
                        <Link :href="route('sectors')" class="flex items-center gap-3 p-3 rounded-lg hover:bg-gray-50 border border-gray-100 transition">
                            <div class="h-8 w-8 rounded-full bg-green-100 flex items-center justify-center flex-shrink-0"><svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-green-700" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M4 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2V6zM14 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2v-2zM14 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2v-2z" /></svg></div>
                            <div><p class="text-xs font-bold text-gray-800">Business Sectors</p><p class="text-[11px] text-gray-500">Explore industry sectors</p></div>
                        </Link>
                        <Link :href="route('leadership')" class="flex items-center gap-3 p-3 rounded-lg hover:bg-gray-50 border border-gray-100 transition">
                            <div class="h-8 w-8 rounded-full bg-indigo-100 flex items-center justify-center flex-shrink-0"><svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-indigo-700" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" /></svg></div>
                            <div><p class="text-xs font-bold text-gray-800">Leadership</p><p class="text-[11px] text-gray-500">Meet the leadership team</p></div>
                        </Link>
                        <Link :href="route('news')" class="flex items-center gap-3 p-3 rounded-lg hover:bg-gray-50 border border-gray-100 transition">
                            <div class="h-8 w-8 rounded-full bg-rose-100 flex items-center justify-center flex-shrink-0"><svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-rose-700" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M19 20H5a2 2 0 01-2-2V6a2 2 0 012-2h10a2 2 0 012 2v1m2 13a2 2 0 01-2-2V7m2 13a2 2 0 002-2V9a2 2 0 00-2-2h-2m-4-3H9M7 16h6M7 8h6v4H7V8z" /></svg></div>
                            <div><p class="text-xs font-bold text-gray-800">News &amp; Updates</p><p class="text-[11px] text-gray-500">Latest chamber news</p></div>
                        </Link>
                        <Link :href="route('membership')" class="flex items-center gap-3 p-3 rounded-lg hover:bg-gray-50 border border-gray-100 transition">
                            <div class="h-8 w-8 rounded-full bg-teal-100 flex items-center justify-center flex-shrink-0"><svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-teal-700" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M5 3v4M3 5h4M6 17v4m-2-2h4m5-16l2.286 6.857L21 12l-5.714 2.143L13 21l-2.286-6.857L5 12l5.714-2.143L13 3z" /></svg></div>
                            <div><p class="text-xs font-bold text-gray-800">Membership Tiers</p><p class="text-[11px] text-gray-500">View membership options</p></div>
                        </Link>
                    </div>
                </div>

            </div>
        </div>
    </AuthenticatedLayout>
</template>