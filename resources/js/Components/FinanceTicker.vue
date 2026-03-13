<script setup>
const props = defineProps({
    revenueCollectedToday: {
        type: Number,
        default: 0,
    },
    totalOutstandingReceivables: {
        type: Number,
        default: 0,
    },
    activationPipeline: {
        type: Number,
        default: 0,
    },
});
</script>

<template>
    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
        <div class="rounded-xl bg-white border border-gray-200 p-5 shadow-sm">
            <p class="text-xs uppercase font-bold text-gray-500">Revenue Collected (Today)</p>
            <div class="mt-2 flex items-center gap-2">
                <span class="h-2.5 w-2.5 rounded-full bg-emerald-500 animate-pulse"></span>
                <p class="text-2xl font-extrabold text-[#1D2A68]">ZMW {{ Number(revenueCollectedToday || 0).toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 }) }}</p>
            </div>
        </div>

        <div class="rounded-xl bg-white border border-gray-200 p-5 shadow-sm">
            <p class="text-xs uppercase font-bold text-gray-500">Total Outstanding Receivables</p>
            <p class="mt-2 text-2xl font-extrabold text-[#1D2A68]">ZMW {{ Number(totalOutstandingReceivables || 0).toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 }) }}</p>
        </div>

        <div class="rounded-xl bg-white border border-gray-200 p-5 shadow-sm">
            <p class="text-xs uppercase font-bold text-gray-500">Activation Pipeline</p>
            <p class="mt-2 text-2xl font-extrabold text-[#1D2A68]">{{ Number(activationPipeline || 0) }}</p>
            <p class="text-xs text-gray-500 mt-1">Members at 1%-49% paid</p>
        </div>
    </div>
</template>
