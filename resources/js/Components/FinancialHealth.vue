<script setup>
import { computed } from 'vue';

const props = defineProps({
    profile: {
        type: Object,
        required: true,
    },
});

const annualFee = computed(() => Number(props.profile?.annual_fee || 0));
const totalPaid = computed(() => Number(props.profile?.total_paid || 0));
const percentage = computed(() => {
    if (annualFee.value <= 0) return 0;
    return Math.max(0, Math.min(100, (totalPaid.value / annualFee.value) * 100));
});
const remainingToActivate = computed(() => {
    const target = annualFee.value * 0.5;
    return Math.max(0, target - totalPaid.value);
});
const isActive = computed(() => Boolean(props.profile?.is_active) || percentage.value >= 50);
</script>

<template>
    <div class="mt-4 rounded-xl border border-gray-200 bg-gray-50 p-4">
        <div class="flex items-center justify-between mb-2">
            <p class="text-xs font-bold uppercase text-gray-500">Financial Health</p>
            <p class="text-xs font-bold text-[#1D2A68]">{{ percentage.toFixed(1) }}%</p>
        </div>

        <div class="h-2.5 rounded-full bg-gray-200 overflow-hidden">
            <div class="h-full transition-all duration-300" :class="isActive ? 'bg-green-500' : 'bg-amber-500'" :style="{ width: percentage + '%' }"></div>
        </div>

        <p v-if="!isActive" class="text-xs text-amber-700 font-semibold mt-2">
            Incomplete: Pay K{{ remainingToActivate.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 }) }} more to go live in the directory.
        </p>
        <p v-else class="text-xs text-green-700 font-semibold mt-2">
            Active: Your business is now visible to the public.
        </p>

        <div class="mt-3 overflow-x-auto">
            <table class="min-w-full text-xs">
                <thead>
                    <tr class="text-gray-500 uppercase border-b border-gray-200">
                        <th class="text-left py-1.5">Document</th>
                        <th class="text-left py-1.5">Date</th>
                        <th class="text-left py-1.5">Download</th>
                    </tr>
                </thead>
                <tbody>
                    <tr class="border-b border-gray-100">
                        <td class="py-1.5">Auto-Invoice</td>
                        <td class="py-1.5">-</td>
                        <td class="py-1.5">
                            <a v-if="profile.invoice_pdf_path" :href="route('profile.business.invoice.download', profile.id)" class="text-[#1876C3] font-semibold hover:underline">Download</a>
                            <span v-else class="text-gray-400">Not available</span>
                        </td>
                    </tr>
                    <tr v-for="payment in profile.payments || []" :key="`receipt-${payment.id}`" class="border-b border-gray-100">
                        <td class="py-1.5">Receipt #{{ payment.id }}</td>
                        <td class="py-1.5">{{ payment.payment_date ? new Date(payment.payment_date).toLocaleDateString() : '-' }}</td>
                        <td class="py-1.5">
                            <a v-if="payment.receipt_pdf_path" :href="route('profile.business.receipt.download', payment.id)" class="text-[#1876C3] font-semibold hover:underline">Download</a>
                            <span v-else class="text-gray-400">Not available</span>
                        </td>
                    </tr>
                    <tr v-if="!profile.payments || profile.payments.length === 0">
                        <td class="py-2 text-gray-400" colspan="3">No receipts yet.</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</template>
