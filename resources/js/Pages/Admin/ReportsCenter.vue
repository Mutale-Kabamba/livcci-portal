<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { Head, useForm } from '@inertiajs/vue3';

const props = defineProps({
    reportType: {
        type: String,
        default: null,
    },
    filters: {
        type: Object,
        default: () => ({}),
    },
    reportData: {
        type: Object,
        default: null,
    },
});

const form = useForm({
    report_type: props.reportType || 'membership_list',
    filters: {
        sector: props.filters?.sector || '',
        start_date: props.filters?.start_date || '',
        end_date: props.filters?.end_date || '',
        member_type: props.filters?.member_type || '',
    },
});

const generateReport = () => {
    form.post(route('admin.reports.generate'), {
        preserveScroll: true,
    });
};
</script>

<template>
    <Head title="Reports Center" />

    <AuthenticatedLayout>
        <template #header>
            <h2 class="font-semibold text-xl text-[#1D2A68] leading-tight">Reports Center</h2>
        </template>

        <div class="py-10">
            <div class="max-w-7xl mx-auto sm:px-6 lg:px-8 space-y-6">
                <div class="bg-white shadow sm:rounded-lg p-6">
                    <h3 class="text-lg font-bold text-[#1D2A68] mb-4">Generate Administrative Report</h3>

                    <form @submit.prevent="generateReport" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-4">
                        <div class="lg:col-span-1">
                            <label class="text-xs font-bold text-gray-500 uppercase">Report Type</label>
                            <select v-model="form.report_type" class="w-full mt-1 border-gray-300 rounded-md">
                                <option value="membership_list">Membership List</option>
                                <option value="revenue_summary">Revenue Summary</option>
                                <option value="sector_analysis">Sector Analysis</option>
                            </select>
                        </div>

                        <div>
                            <label class="text-xs font-bold text-gray-500 uppercase">Sector</label>
                            <input v-model="form.filters.sector" type="text" placeholder="e.g. Tourism & Hospitality" class="w-full mt-1 border-gray-300 rounded-md" />
                        </div>

                        <div>
                            <label class="text-xs font-bold text-gray-500 uppercase">Member Type</label>
                            <input v-model="form.filters.member_type" type="text" placeholder="e.g. Corporate" class="w-full mt-1 border-gray-300 rounded-md" />
                        </div>

                        <div>
                            <label class="text-xs font-bold text-gray-500 uppercase">Start Date</label>
                            <input v-model="form.filters.start_date" type="date" class="w-full mt-1 border-gray-300 rounded-md" />
                        </div>

                        <div>
                            <label class="text-xs font-bold text-gray-500 uppercase">End Date</label>
                            <input v-model="form.filters.end_date" type="date" class="w-full mt-1 border-gray-300 rounded-md" />
                        </div>

                        <div class="lg:col-span-5 flex justify-end">
                            <button type="submit" :disabled="form.processing" class="bg-[#1D2A68] text-white font-bold px-5 py-2.5 rounded-md hover:bg-[#1876C3] disabled:opacity-50">
                                {{ form.processing ? 'Generating...' : 'Generate Report' }}
                            </button>
                        </div>
                    </form>
                </div>

                <div class="bg-white shadow sm:rounded-lg p-6">
                    <h3 class="text-lg font-bold text-[#1D2A68] mb-4">Report Output</h3>

                    <div v-if="!reportType" class="text-sm text-gray-500">
                        Select a report type and filters, then click Generate Report.
                    </div>

                    <div v-else-if="reportType === 'revenue_summary'" class="space-y-3">
                        <p class="text-sm text-gray-600">Total Paid Revenue</p>
                        <p class="text-2xl font-extrabold text-[#1D2A68]">ZMW {{ Number(reportData?.total_paid || 0).toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 }) }}</p>
                        <div class="overflow-x-auto">
                            <table class="min-w-full divide-y divide-gray-200 text-sm">
                                <thead class="bg-gray-50">
                                    <tr>
                                        <th class="px-4 py-2 text-left font-bold text-gray-500 uppercase text-xs">Membership Type</th>
                                        <th class="px-4 py-2 text-left font-bold text-gray-500 uppercase text-xs">Invoices</th>
                                        <th class="px-4 py-2 text-left font-bold text-gray-500 uppercase text-xs">Amount</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-gray-100">
                                    <tr v-for="row in reportData?.breakdown || []" :key="row.membership_type">
                                        <td class="px-4 py-2">{{ row.membership_type }}</td>
                                        <td class="px-4 py-2">{{ row.invoices_count }}</td>
                                        <td class="px-4 py-2">ZMW {{ Number(row.total_amount).toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 }) }}</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div v-else-if="reportType === 'membership_list'" class="space-y-3">
                        <p class="text-sm text-gray-600">Approved Members: <span class="font-bold text-[#1D2A68]">{{ reportData?.count || 0 }}</span></p>
                        <div class="overflow-x-auto">
                            <table class="min-w-full divide-y divide-gray-200 text-sm">
                                <thead class="bg-gray-50">
                                    <tr>
                                        <th class="px-4 py-2 text-left font-bold text-gray-500 uppercase text-xs">Company</th>
                                        <th class="px-4 py-2 text-left font-bold text-gray-500 uppercase text-xs">Sector</th>
                                        <th class="px-4 py-2 text-left font-bold text-gray-500 uppercase text-xs">Membership</th>
                                        <th class="px-4 py-2 text-left font-bold text-gray-500 uppercase text-xs">Date Joined</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-gray-100">
                                    <tr v-for="member in reportData?.members || []" :key="member.id">
                                        <td class="px-4 py-2">{{ member.company_name }}</td>
                                        <td class="px-4 py-2">{{ member.industry_sector }}</td>
                                        <td class="px-4 py-2">{{ member.membership_type || 'N/A' }}</td>
                                        <td class="px-4 py-2">{{ new Date(member.created_at).toLocaleDateString() }}</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div v-else-if="reportType === 'sector_analysis'" class="space-y-4">
                        <p class="text-sm text-gray-600">Total Members in Analysis: <span class="font-bold text-[#1D2A68]">{{ reportData?.total_members || 0 }}</span></p>
                        <div class="space-y-4">
                            <div v-for="sector in reportData?.sectors || []" :key="sector.sector" class="border border-gray-200 rounded-lg p-4">
                                <div class="flex justify-between items-center mb-2">
                                    <h4 class="font-bold text-[#1D2A68]">{{ sector.sector }}</h4>
                                    <span class="text-xs font-semibold bg-blue-100 text-blue-700 px-2 py-1 rounded-full">{{ sector.members_count }} members</span>
                                </div>
                                <ul class="text-sm text-gray-700 space-y-1">
                                    <li v-for="activity in sector.top_activities" :key="activity.activity" class="flex justify-between">
                                        <span>{{ activity.activity }}</span>
                                        <span class="font-semibold">{{ activity.count }}</span>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </AuthenticatedLayout>
</template>
