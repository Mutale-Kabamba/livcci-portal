<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { Head, Link } from '@inertiajs/vue3';

// Expect the businessProfile data we passed from the route
defineProps({
    businessProfile: Object,
});
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

                <div v-if="!businessProfile" class="bg-indigo-50 border border-indigo-200 overflow-hidden shadow-sm sm:rounded-lg p-8 text-center">
                    <h3 class="text-lg font-bold text-indigo-900 mb-2">You aren't listed in the directory!</h3>
                    <p class="text-indigo-700 mb-6">Complete your business profile to unlock networking opportunities and increase your visibility in Livingstone.</p>
                    <Link :href="route('profile.business.create')" class="bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-2 px-6 rounded shadow">
                        Create Business Profile
                    </Link>
                </div>

                <div v-else class="bg-white overflow-hidden shadow-sm sm:rounded-lg">
                    <div class="p-6 border-b border-gray-200 bg-gray-50 flex justify-between items-center">
                        <h3 class="text-lg font-bold text-gray-800">Your Directory Listing</h3>
                        
                        <div class="flex items-center space-x-4">
                            <Link :href="route('profile.business.edit')" class="text-sm text-indigo-600 hover:text-indigo-900 font-medium underline">
                                Edit Profile
                            </Link>
                            <span class="px-3 py-1 text-xs font-semibold text-green-800 bg-green-100 rounded-full">Active Member</span>
                        </div>
                    </div>
                    
                    <div class="p-6">
                        <dl class="grid grid-cols-1 md:grid-cols-2 gap-x-4 gap-y-8">
                            
                            <div class="sm:col-span-1">
                                <dt class="text-sm font-medium text-gray-500">NAME</dt>
                                <dd class="mt-1 text-lg font-semibold text-gray-900">{{ businessProfile.company_name }}</dd>
                            </div>

                            <div class="sm:col-span-1">
                                <dt class="text-sm font-medium text-gray-500">MEMBER TYPE</dt>
                                <dd class="mt-1 text-lg font-semibold text-gray-900">
                                    <span class="inline-block px-3 py-1 bg-blue-100 text-blue-800 rounded-full text-sm font-bold">
                                        {{ businessProfile.member_type }}
                                    </span>
                                </dd>
                            </div>

                            <div class="sm:col-span-1">
                                <dt class="text-sm font-medium text-gray-500">MEMBER CATEGORY</dt>
                                <dd class="mt-1 text-lg font-semibold text-gray-900">
                                    <span class="inline-block px-3 py-1 bg-orange-100 text-orange-800 rounded-full text-sm font-bold">
                                        {{ businessProfile.member_category }}
                                    </span>
                                </dd>
                            </div>

                            <div class="sm:col-span-2">
                                <dt class="text-sm font-medium text-gray-500">SHORT DESCRIPTION</dt>
                                <dd class="mt-1 text-base text-gray-900">{{ businessProfile.short_description || 'No description provided.' }}</dd>
                            </div>

                            <div class="sm:col-span-1">
                                <dt class="text-sm font-medium text-gray-500">TPIN</dt>
                                <dd class="mt-1 text-base font-mono text-gray-900">{{ businessProfile.tpin }}</dd>
                            </div>

                            <div v-if="businessProfile.pacra_reg_no" class="sm:col-span-1">
                                <dt class="text-sm font-medium text-gray-500">PACRA REG NO.</dt>
                                <dd class="mt-1 text-base font-mono text-gray-900">{{ businessProfile.pacra_reg_no }}</dd>
                            </div>

                            <div class="sm:col-span-1">
                                <dt class="text-sm font-medium text-gray-500">EMAIL</dt>
                                <dd class="mt-1 text-base text-gray-900">{{ businessProfile.contact_email }}</dd>
                            </div>

                            <div class="sm:col-span-1">
                                <dt class="text-sm font-medium text-gray-500">PHONE</dt>
                                <dd class="mt-1 text-base text-gray-900">{{ businessProfile.phone }}</dd>
                            </div>

                            <div v-if="businessProfile.address" class="sm:col-span-2">
                                <dt class="text-sm font-medium text-gray-500">ADDRESS</dt>
                                <dd class="mt-1 text-base text-gray-900">{{ businessProfile.address }}</dd>
                            </div>

                            <div v-if="businessProfile.website_url" class="sm:col-span-1">
                                <dt class="text-sm font-medium text-gray-500">WEBSITE</dt>
                                <dd class="mt-1 text-base text-gray-900">
                                    <a :href="businessProfile.website_url" target="_blank" class="text-indigo-600 hover:text-indigo-900 underline">
                                        Visit Website
                                    </a>
                                </dd>
                            </div>

                            <div v-if="businessProfile.logo_url" class="sm:col-span-1">
                                <dt class="text-sm font-medium text-gray-500">LOGO</dt>
                                <dd class="mt-1">
                                    <img :src="businessProfile.logo_url" :alt="businessProfile.company_name" class="h-16 w-auto rounded border border-gray-300 p-2">
                                </dd>
                            </div>

                        </dl>
                    </div>
                </div>

            </div>
        </div>
    </AuthenticatedLayout>
</template>