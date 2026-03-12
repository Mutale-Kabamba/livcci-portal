<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { Head, router } from '@inertiajs/vue3';
import { reactive, ref, watch } from 'vue';

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

const reportCards = [
    {
        type: 'revenue_summary',
        title: 'Financial Report',
        description: 'Paid revenue totals and contribution by membership type.',
    },
    {
        type: 'membership_list',
        title: 'Member Directory Report',
        description: 'Approved member listing filtered by date, type, and sector.',
    },
    {
        type: 'sector_analysis',
        title: 'Sector Growth Report',
        description: 'Members by sector and top business activities.',
    },
];

const sectors = [
    'Tourism & Hospitality',
    'Trade & Commerce',
    'Financial Services',
    'Construction & Engineering',
    'Agriculture & Manufacturing',
    'IT & Creative Media',
    'Cooperatives & Social Enterprise',
];

const memberTypes = ['Corporate', 'Ordinary', 'Associate', 'Cooperative'];

const selectedReportType = ref(props.reportType || 'revenue_summary');
const previewLoading = ref(false);
const filtersForm = reactive({
    sector: props.filters?.sector || '',
    member_type: props.filters?.member_type || '',
    start_date: props.filters?.start_date || '',
    end_date: props.filters?.end_date || '',
});

let previewTimer = null;

const fetchPreview = () => {
    if (!selectedReportType.value) return;

    previewLoading.value = true;
    router.post(
        route('admin.reports.generate'),
        {
            report_type: selectedReportType.value,
            filters: {
                sector: filtersForm.sector || null,
                member_type: filtersForm.member_type || null,
                start_date: filtersForm.start_date || null,
                end_date: filtersForm.end_date || null,
            },
        },
        {
            preserveScroll: true,
            preserveState: true,
            replace: true,
            only: ['reportType', 'filters', 'reportData'],
            onFinish: () => {
                previewLoading.value = false;
            },
        }
    );
};

const queuePreview = () => {
    clearTimeout(previewTimer);
    previewTimer = setTimeout(fetchPreview, 250);
};

watch(
    () => selectedReportType.value,
    () => {
        queuePreview();
    }
);

watch(
    () => [filtersForm.sector, filtersForm.member_type, filtersForm.start_date, filtersForm.end_date],
    () => {
        queuePreview();
    }
);

const selectCard = (reportType) => {
    selectedReportType.value = reportType;
};

const downloadPdfReport = () => {
    const csrfToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content') || '';
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = route('admin.reports.generate');
    form.style.display = 'none';

    const fields = {
        _token: csrfToken,
        download: '1',
        report_type: selectedReportType.value,
        'filters[sector]': filtersForm.sector || '',
        'filters[member_type]': filtersForm.member_type || '',
        'filters[start_date]': filtersForm.start_date || '',
        'filters[end_date]': filtersForm.end_date || '',
    };

    Object.entries(fields).forEach(([name, value]) => {
        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = name;
        input.value = value;
        form.appendChild(input);
    });

    document.body.appendChild(form);
    form.submit();
    document.body.removeChild(form);
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
                    <h3 class="text-lg font-bold text-[#1D2A68] mb-4">Select Report Type</h3>
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                        <button
                            v-for="card in reportCards"
                            :key="card.type"
                            @click="selectCard(card.type)"
                            class="text-left rounded-lg border p-4 transition"
                            :class="selectedReportType === card.type ? 'border-[#1D2A68] bg-[#1D2A68] text-white shadow' : 'border-gray-200 bg-white hover:border-[#1876C3] hover:bg-[#1876C3]/5'"
                        >
                            <div class="font-bold text-base">{{ card.title }}</div>
                            <div class="text-sm mt-1" :class="selectedReportType === card.type ? 'text-blue-100' : 'text-gray-600'">{{ card.description }}</div>
                        </button>
                    </div>
                </div>

                <div class="bg-white shadow sm:rounded-lg p-6">
                    <h3 class="text-lg font-bold text-[#1D2A68] mb-4">Filters</h3>
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                        <div>
                            <label class="text-xs font-bold text-gray-500 uppercase">Industry Sector</label>
                            <select v-model="filtersForm.sector" class="w-full mt-1 border-gray-300 rounded-md">
                                <option value="">All Sectors</option>
                                <option v-for="sector in sectors" :key="sector" :value="sector">{{ sector }}</option>
                            </select>
                        </div>

                        <div>
                            <label class="text-xs font-bold text-gray-500 uppercase">Member Type</label>
                            <select v-model="filtersForm.member_type" class="w-full mt-1 border-gray-300 rounded-md">
                                <option value="">All Member Types</option>
                                <option v-for="type in memberTypes" :key="type" :value="type">{{ type }}</option>
                            </select>
                        </div>

                        <div>
                            <label class="text-xs font-bold text-gray-500 uppercase">From</label>
                            <input v-model="filtersForm.start_date" type="date" class="w-full mt-1 border-gray-300 rounded-md" />
                        </div>

                        <div>
                            <label class="text-xs font-bold text-gray-500 uppercase">To</label>
                            <input v-model="filtersForm.end_date" type="date" class="w-full mt-1 border-gray-300 rounded-md" />
                        </div>
                    </div>
                </div>

                <div class="bg-white shadow sm:rounded-lg p-6">
                    <div class="flex items-center justify-between mb-4">
                        <h3 class="text-lg font-bold text-[#1D2A68]">Preview</h3>
                        <span v-if="previewLoading" class="text-xs font-semibold text-[#1876C3]">Updating preview...</span>
                    </div>

                    <div v-if="selectedReportType === 'revenue_summary'" class="space-y-3">
                        <div class="text-sm text-gray-600">Total Paid Revenue</div>
                        <div class="text-2xl font-extrabold text-[#1D2A68]">
                            ZMW {{ Number(reportData?.total_paid || 0).toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 }) }}
                        </div>
                        <div class="overflow-x-auto">
                            <table class="min-w-full divide-y divide-gray-200 text-sm">
                                <thead class="bg-[#1D2A68] text-white">
                                    <tr>
                                        <th class="px-4 py-2 text-left text-xs uppercase">Membership Type</th>
                                        <th class="px-4 py-2 text-left text-xs uppercase">Invoices</th>
                                        <th class="px-4 py-2 text-left text-xs uppercase">Amount</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-gray-100">
                                    <tr v-for="row in reportData?.breakdown || []" :key="row.membership_type">
                                        <td class="px-4 py-2">{{ row.membership_type }}</td>
                                        <td class="px-4 py-2">{{ row.invoices_count }}</td>
                                        <td class="px-4 py-2">ZMW {{ Number(row.total_amount).toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 }) }}</td>
                                    </tr>
                                    <tr v-if="!reportData?.breakdown || reportData.breakdown.length === 0">
                                        <td class="px-4 py-3 text-gray-500" colspan="3">No data for selected filters.</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div v-else-if="selectedReportType === 'membership_list'" class="overflow-x-auto">
                        <table class="min-w-full divide-y divide-gray-200 text-sm">
                            <thead class="bg-[#1D2A68] text-white">
                                <tr>
                                    <th class="px-4 py-2 text-left text-xs uppercase">Company</th>
                                    <th class="px-4 py-2 text-left text-xs uppercase">Sector</th>
                                    <th class="px-4 py-2 text-left text-xs uppercase">Membership</th>
                                    <th class="px-4 py-2 text-left text-xs uppercase">Date Joined</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-gray-100">
                                <tr v-for="member in reportData?.members || []" :key="member.id">
                                    <td class="px-4 py-2">{{ member.company_name }}</td>
                                    <td class="px-4 py-2">{{ member.industry_sector }}</td>
                                    <td class="px-4 py-2">{{ member.membership_type || 'N/A' }}</td>
                                    <td class="px-4 py-2">{{ new Date(member.created_at).toLocaleDateString() }}</td>
                                </tr>
                                <tr v-if="!reportData?.members || reportData.members.length === 0">
                                    <td class="px-4 py-3 text-gray-500" colspan="4">No approved members for selected filters.</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <div v-else class="space-y-4">
                        <div class="text-sm text-gray-600">Members in Analysis: <span class="font-bold text-[#1D2A68]">{{ reportData?.total_members || 0 }}</span></div>
                        <div class="overflow-x-auto">
                            <table class="min-w-full divide-y divide-gray-200 text-sm">
                                <thead class="bg-[#1D2A68] text-white">
                                    <tr>
                                        <th class="px-4 py-2 text-left text-xs uppercase">Industry Sector</th>
                                        <th class="px-4 py-2 text-left text-xs uppercase">Members</th>
                                        <th class="px-4 py-2 text-left text-xs uppercase">Top Activities</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-gray-100">
                                    <tr v-for="row in reportData?.sectors || []" :key="row.sector">
                                        <td class="px-4 py-2">{{ row.sector }}</td>
                                        <td class="px-4 py-2">{{ row.members_count }}</td>
                                        <td class="px-4 py-2">
                                            <span v-if="row.top_activities?.length">
                                                {{ row.top_activities.map(a => `${a.activity} (${a.count})`).join(', ') }}
                                            </span>
                                            <span v-else class="text-gray-500">No activities recorded</span>
                                        </td>
                                    </tr>
                                    <tr v-if="!reportData?.sectors || reportData.sectors.length === 0">
                                        <td class="px-4 py-3 text-gray-500" colspan="3">No sector data for selected filters.</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="mt-6">
                        <button
                            @click="downloadPdfReport"
                            class="w-full md:w-auto bg-[#1876C3] hover:bg-[#1460A0] text-white font-extrabold text-sm px-8 py-3 rounded-md shadow-md"
                        >
                            Download PDF Report
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </AuthenticatedLayout>
</template>
