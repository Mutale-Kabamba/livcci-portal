<script setup>
import GuestLayout from '@/Layouts/GuestLayout.vue';
import { Head, Link } from '@inertiajs/vue3';

defineProps({
    role: {
        type: String,
        default: '',
    },
});
</script>

<template>
    <GuestLayout>
        <Head title="Choose Portal Mode" />

        <div class="mx-auto max-w-xl rounded-xl border border-gray-200 bg-white p-8 shadow-sm">
            <h1 class="text-2xl font-extrabold text-[#1D2A68]">Choose Login Mode</h1>
            <p class="mt-2 text-sm text-gray-600">
                This account has admin privileges.
                Choose how you want to continue for this session.
            </p>
            <p v-if="role" class="mt-1 text-xs font-semibold uppercase tracking-wide text-[#1876C3]">
                Assigned Role: {{ role }}
            </p>

            <div class="mt-6 grid gap-3 sm:grid-cols-2">
                <Link
                    :href="route('portal.mode.set')"
                    method="post"
                    as="button"
                    :data="{ mode: 'admin' }"
                    class="rounded-lg bg-[#1D2A68] px-4 py-3 text-sm font-bold text-white hover:bg-[#15204f] transition"
                >
                    Login As Admin
                </Link>
                <Link
                    :href="route('portal.mode.set')"
                    method="post"
                    as="button"
                    :data="{ mode: 'ordinary' }"
                    class="rounded-lg border border-[#1D2A68] bg-white px-4 py-3 text-sm font-bold text-[#1D2A68] hover:bg-gray-50 transition"
                >
                    Login As Ordinary User
                </Link>
            </div>
        </div>
    </GuestLayout>
</template>
