<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { computed, ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    goal: {
        type: Object,
        required: true,
    },
    allGoals: {
        type: Array,
        default: () => [],
    },
});

const scrollY = ref(0);

const handleScroll = () => {
    scrollY.value = window.scrollY;
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});

const otherGoals = computed(() => {
    return (props.allGoals || []).filter((item) => item.slug !== props.goal.slug);
});
</script>

<template>
    <Head :title="`Strategic Goal ${goal.number} - LiVCCI`" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900">
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('strategic-goals')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3]">Back to Goals</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <section class="relative bg-[#0f1f5a] text-white overflow-hidden">
            <img :src="goal.heroImage" :alt="goal.title" class="absolute inset-0 w-full h-full object-cover opacity-30">
            <div class="absolute inset-0 bg-gradient-to-r from-[#0f1f5a] via-[#173a7a]/90 to-[#1876C3]/70"></div>

            <div class="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16 sm:py-24">
                <p class="text-xs uppercase tracking-[0.22em] text-[#F4B223] font-bold">Strategic Goal {{ goal.number }}</p>
                <h1 class="mt-3 text-4xl sm:text-5xl font-black max-w-4xl leading-tight">{{ goal.title }}</h1>
                <p class="mt-6 text-lg text-blue-100 max-w-3xl">{{ goal.tagline }}</p>
                <Link :href="route('strategic-goals')" class="inline-flex mt-8 bg-white/20 hover:bg-white/30 text-white px-5 py-2.5 rounded-md font-bold transition">
                    View All Strategic Goals
                </Link>
            </div>
        </section>

        <section class="py-14 bg-white">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
                    <div class="lg:col-span-2 bg-white rounded-xl border border-gray-200 shadow-sm p-8">
                        <h2 class="text-2xl font-extrabold text-[#1D2A68] mb-4">Strategic Overview</h2>
                        <p class="text-gray-700 leading-8 text-[1.05rem]">{{ goal.overview }}</p>
                    </div>

                    <div class="bg-gradient-to-br from-[#1D2A68] to-[#1876C3] rounded-xl p-6 text-white shadow-lg">
                        <h3 class="text-lg font-bold mb-4">Success Metrics</h3>
                        <div class="space-y-4">
                            <div v-for="(kpi, index) in goal.kpis || []" :key="index" class="bg-white/10 rounded-lg p-3">
                                <p class="text-xs uppercase tracking-wide text-blue-100">{{ kpi.label }}</p>
                                <p class="text-xl font-black mt-1">{{ kpi.target }}</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section class="py-14 bg-gray-50 border-y border-gray-200">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <h2 class="text-2xl sm:text-3xl font-extrabold text-[#1D2A68] mb-8">Expected Outcomes</h2>
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                    <div v-for="(outcome, index) in goal.outcomes || []" :key="index" class="bg-white border border-gray-200 rounded-xl p-6 shadow-sm">
                        <div class="w-10 h-10 rounded-full bg-[#e8f1fb] text-[#1876C3] flex items-center justify-center font-black mb-4">{{ index + 1 }}</div>
                        <p class="text-gray-700 leading-7">{{ outcome }}</p>
                    </div>
                </div>
            </div>
        </section>

        <section class="py-14 bg-white">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <h2 class="text-2xl sm:text-3xl font-extrabold text-[#1D2A68] mb-8">Priority Initiatives</h2>
                <div class="space-y-4">
                    <div v-for="(initiative, index) in goal.initiatives || []" :key="index" class="bg-[#f8fbff] border border-[#d8e7fb] rounded-xl p-6">
                        <div class="flex items-start gap-4">
                            <div class="w-8 h-8 rounded-full bg-[#1876C3] text-white font-bold flex items-center justify-center flex-shrink-0">{{ index + 1 }}</div>
                            <div>
                                <h3 class="text-lg font-bold text-[#1D2A68]">{{ initiative.title }}</h3>
                                <p class="mt-2 text-gray-700 leading-7">{{ initiative.description }}</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section class="py-14 bg-gray-50">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex items-center justify-between mb-6 flex-wrap gap-3">
                    <h2 class="text-2xl font-extrabold text-[#1D2A68]">Explore Other Goals</h2>
                    <Link :href="route('strategic-goals')" class="text-[#1876C3] font-bold hover:underline">Back to Goal Cards</Link>
                </div>
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                    <Link
                        v-for="item in otherGoals"
                        :key="item.slug"
                        :href="route('strategic-goals.detail', item.slug)"
                        class="bg-white rounded-lg border border-gray-200 p-4 hover:border-[#1876C3] hover:shadow-md transition"
                    >
                        <p class="text-xs uppercase tracking-wide text-[#1876C3] font-bold">Goal {{ item.number }}</p>
                        <p class="text-sm font-bold text-[#1D2A68] mt-2 leading-snug">{{ item.title }}</p>
                    </Link>
                </div>
            </div>
        </section>
    </div>
</template>
