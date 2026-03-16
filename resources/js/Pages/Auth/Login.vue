<script setup>
import Checkbox from '@/Components/Checkbox.vue';
import GuestLayout from '@/Layouts/GuestLayout.vue';
import InputError from '@/Components/InputError.vue';
import InputLabel from '@/Components/InputLabel.vue';
import PrimaryButton from '@/Components/PrimaryButton.vue';
import TextInput from '@/Components/TextInput.vue';
import { Head, Link, useForm } from '@inertiajs/vue3';
import { computed, ref } from 'vue';

defineProps({
    canResetPassword: {
        type: Boolean,
    },
    canGoogleAuth: {
        type: Boolean,
        default: false,
    },
    status: {
        type: String,
    },
});

const form = useForm({
    email: '',
    password: '',
    remember: false,
});

const showPassword = ref(false);

const passwordChecks = computed(() => {
    const value = form.password || '';
    return [
        { label: 'At least 8 characters', ok: value.length >= 8 },
        { label: 'At least 1 uppercase letter', ok: /[A-Z]/.test(value) },
        { label: 'At least 1 number', ok: /\d/.test(value) },
        { label: 'At least 1 special character', ok: /[^A-Za-z0-9]/.test(value) },
    ];
});

const submit = () => {
    form.post(route('login'), {
        onFinish: () => form.reset('password'),
    });
};
</script>

<template>
    <GuestLayout>
        <Head title="Log in" />

        <div class="mx-auto w-full max-w-md overflow-hidden rounded-2xl border border-[#dbe5f6] bg-white shadow-2xl shadow-[#1D2A68]/10">
            <div class="bg-gradient-to-r from-[#1D2A68] to-[#1876C3] px-6 py-8 text-white">
                <h1 class="text-2xl font-black tracking-tight">Welcome Back</h1>
                <p class="mt-1 text-sm text-blue-100">Sign in to access your LiVCCI member portal.</p>
            </div>

            <div class="px-6 py-6">
                <div v-if="status" class="mb-4 rounded-lg border border-green-200 bg-green-50 px-3 py-2 text-sm font-medium text-green-700">
                    {{ status }}
                </div>

                <form @submit.prevent="submit" class="space-y-5">
                    <a
                        v-if="canGoogleAuth"
                        :href="route('auth.google.redirect')"
                        class="inline-flex w-full items-center justify-center gap-2 rounded-lg border border-gray-300 bg-white px-4 py-3 text-sm font-semibold text-gray-700 transition hover:bg-gray-50"
                    >
                        <svg class="h-5 w-5" viewBox="0 0 24 24" aria-hidden="true">
                            <path fill="#EA4335" d="M12 10.2v3.9h5.5c-.2 1.3-1.5 3.9-5.5 3.9-3.3 0-6-2.7-6-6s2.7-6 6-6c1.9 0 3.2.8 3.9 1.5l2.7-2.6C17 3.3 14.8 2.4 12 2.4 6.8 2.4 2.6 6.6 2.6 11.8S6.8 21.2 12 21.2c6.9 0 9.1-4.8 9.1-7.3 0-.5 0-.8-.1-1.1H12z"/>
                        </svg>
                        Continue with Google
                    </a>

                    <div v-if="canGoogleAuth" class="relative">
                        <div class="absolute inset-0 flex items-center">
                            <div class="w-full border-t border-gray-200"></div>
                        </div>
                        <div class="relative flex justify-center text-xs uppercase">
                            <span class="bg-white px-2 text-gray-400">Or sign in with email</span>
                        </div>
                    </div>

                    <div>
                        <InputLabel for="email" value="Email" />

                        <TextInput
                            id="email"
                            type="email"
                            class="mt-1 block w-full rounded-lg border-gray-300 focus:border-[#1876C3] focus:ring-[#1876C3]"
                            v-model="form.email"
                            required
                            autofocus
                            autocomplete="username"
                        />

                        <InputError class="mt-2" :message="form.errors.email" />
                    </div>

                    <div>
                        <InputLabel for="password" value="Password" />

                        <div class="relative mt-1">
                            <TextInput
                                id="password"
                                :type="showPassword ? 'text' : 'password'"
                                class="block w-full rounded-lg border-gray-300 pr-11 focus:border-[#1876C3] focus:ring-[#1876C3]"
                                v-model="form.password"
                                required
                                autocomplete="current-password"
                            />
                            <button
                                type="button"
                                @click="showPassword = !showPassword"
                                class="absolute inset-y-0 right-0 flex items-center px-3 text-gray-500 hover:text-[#1876C3]"
                                :aria-label="showPassword ? 'Hide password' : 'Show password'"
                            >
                                <svg v-if="!showPassword" xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                                </svg>
                                <svg v-else xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.477 0-8.268-2.943-9.542-7a9.955 9.955 0 012.084-3.368m2.228-1.894A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.542 7a9.967 9.967 0 01-4.293 5.272M15 12a3 3 0 00-3-3m0 0a2.99 2.99 0 00-2.346 1.131M12 9l0 0m0 0l0 0M3 3l18 18" />
                                </svg>
                            </button>
                        </div>

                        <InputError class="mt-2" :message="form.errors.password" />

                        <div class="mt-3 rounded-lg border border-gray-200 bg-gray-50 p-3">
                            <p class="text-xs font-bold uppercase tracking-wide text-gray-500">Password Requirements</p>
                            <ul class="mt-2 space-y-1">
                                <li
                                    v-for="rule in passwordChecks"
                                    :key="rule.label"
                                    class="text-xs font-medium"
                                    :class="rule.ok ? 'text-green-700' : 'text-gray-500'"
                                >
                                    {{ rule.ok ? '✓' : '•' }} {{ rule.label }}
                                </li>
                            </ul>
                        </div>
                    </div>

                    <div class="flex items-center justify-between">
                        <label class="flex items-center">
                            <Checkbox name="remember" v-model:checked="form.remember" />
                            <span class="ms-2 text-sm text-gray-600">Remember me</span>
                        </label>

                        <Link
                            v-if="canResetPassword"
                            :href="route('password.request')"
                            class="text-sm font-semibold text-[#1D2A68] underline decoration-[#1876C3]/60 underline-offset-2 hover:text-[#1876C3]"
                        >
                            Forgot password?
                        </Link>
                    </div>

                    <PrimaryButton
                        class="w-full justify-center rounded-lg bg-[#1D2A68] py-3 text-sm font-bold uppercase tracking-wide hover:bg-[#15204f]"
                        :class="{ 'opacity-25': form.processing }"
                        :disabled="form.processing"
                    >
                        Log in
                    </PrimaryButton>
                </form>
            </div>
        </div>
    </GuestLayout>
</template>
