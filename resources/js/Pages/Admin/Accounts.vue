<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { Head, Link, useForm } from '@inertiajs/vue3';

const props = defineProps({
    users: Array,
});

const roleForm = useForm({
    is_admin: false,
});

const setAdminStatus = (user, isAdmin) => {
    const actionLabel = isAdmin ? 'grant admin access to' : 'remove admin access from';
    if (!confirm(`Are you sure you want to ${actionLabel} ${user.name}?`)) return;

    roleForm.is_admin = isAdmin;
    roleForm.patch(route('admin.accounts.role', user.id), {
        preserveScroll: true,
    });
};

const removeForm = useForm({});
const deleteAccount = (user) => {
    if (!confirm(`Delete account for ${user.name}? This cannot be undone.`)) return;

    removeForm.delete(route('admin.accounts.delete', user.id), {
        preserveScroll: true,
    });
};
</script>

<template>
    <Head title="Account Management" />

    <AuthenticatedLayout>
        <template #header>
            <div class="flex items-center justify-between gap-4">
                <div>
                    <h2 class="font-semibold text-xl text-[#1D2A68] leading-tight">Admin Account Management</h2>
                    <p class="text-sm text-gray-500 mt-1">Manage platform user accounts and admin privileges.</p>
                </div>
                <Link :href="route('admin.dashboard')" class="bg-[#1D2A68] text-white text-sm font-bold py-2 px-4 rounded hover:bg-[#1876C3] transition shadow-md">
                    Back to Admin Dashboard
                </Link>
            </div>
        </template>

        <div class="py-12">
            <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
                <div class="bg-white shadow sm:rounded-lg overflow-hidden">
                    <div class="px-6 py-4 border-b border-gray-100 bg-gray-50/50">
                        <h3 class="text-lg font-bold text-[#1D2A68]">All Accounts</h3>
                    </div>

                    <div class="overflow-x-auto">
                        <table class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase">Name</th>
                                    <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase">Email</th>
                                    <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase">Role</th>
                                    <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase">Verified</th>
                                    <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase">Created</th>
                                    <th class="px-6 py-3 text-right text-xs font-bold text-gray-500 uppercase">Actions</th>
                                </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-100">
                                <tr v-for="user in users" :key="user.id" class="hover:bg-gray-50">
                                    <td class="px-6 py-4 text-sm font-semibold text-gray-900">{{ user.name }}</td>
                                    <td class="px-6 py-4 text-sm text-gray-700">{{ user.email }}</td>
                                    <td class="px-6 py-4">
                                        <span class="px-2 py-1 text-[10px] font-bold rounded-full uppercase" :class="user.is_admin ? 'bg-blue-100 text-blue-700' : 'bg-gray-200 text-gray-700'">
                                            {{ user.is_admin ? 'Admin' : 'User' }}
                                        </span>
                                    </td>
                                    <td class="px-6 py-4 text-sm text-gray-700">
                                        <span v-if="user.email_verified_at">Verified</span>
                                        <span v-else class="text-orange-600 font-medium">Unverified</span>
                                    </td>
                                    <td class="px-6 py-4 text-sm text-gray-500">{{ new Date(user.created_at).toLocaleDateString() }}</td>
                                    <td class="px-6 py-4 text-right space-x-3">
                                        <button
                                            v-if="!user.is_admin"
                                            @click="setAdminStatus(user, true)"
                                            class="text-[#1876C3] font-bold text-sm hover:underline"
                                        >
                                            Make Admin
                                        </button>
                                        <button
                                            v-else
                                            @click="setAdminStatus(user, false)"
                                            class="text-orange-600 font-bold text-sm hover:underline"
                                        >
                                            Remove Admin
                                        </button>
                                        <button
                                            @click="deleteAccount(user)"
                                            class="text-red-500 font-bold text-sm hover:underline"
                                        >
                                            Delete
                                        </button>
                                    </td>
                                </tr>
                                <tr v-if="!users || users.length === 0">
                                    <td colspan="6" class="px-6 py-8 text-center text-sm text-gray-500">No accounts found.</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </AuthenticatedLayout>
</template>
