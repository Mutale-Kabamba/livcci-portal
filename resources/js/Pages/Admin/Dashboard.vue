<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { Head, Link, useForm } from '@inertiajs/vue3';
import { ref } from 'vue';

const props = defineProps({
    profiles: Array,
    events: Array,
    invoices: Array,
    strategicPlan: Object
});

const activeTab = ref('member-management');

// Member Status Form
const statusForm = useForm({
    status: ''
});

const updateStatus = (profileId, newStatus) => {
    statusForm.status = newStatus;
    statusForm.patch(route('admin.members.status', profileId), {
        preserveScroll: true,
        onSuccess: () => alert('Status successfully updated to ' + newStatus)
    });
};

const paymentForm = useForm({});

const confirmPayment = (invoiceId) => {
    paymentForm.patch(route('admin.invoices.paid', invoiceId), {
        preserveScroll: true,
        onSuccess: () => alert('Payment confirmed and subscription updated.'),
        onError: () => alert('Failed to confirm payment.'),
    });
};

const strategicGoals = [
    { key: 'goal_1', label: 'Strategic Goal 1: Membership Growth' },
    { key: 'goal_2', label: 'Strategic Goal 2: SME Support and Advocacy' },
    { key: 'goal_3', label: 'Strategic Goal 3: Tourism and Trade Expansion' },
    { key: 'goal_4', label: 'Strategic Goal 4: Skills and Innovation' },
    { key: 'goal_5', label: 'Strategic Goal 5: Institutional Strengthening' }
];

const strategicPlanForm = useForm({
    goal_1: props.strategicPlan?.goal_1 ?? 0,
    goal_2: props.strategicPlan?.goal_2 ?? 0,
    goal_3: props.strategicPlan?.goal_3 ?? 0,
    goal_4: props.strategicPlan?.goal_4 ?? 0,
    goal_5: props.strategicPlan?.goal_5 ?? 0,
});

const clampPercentage = (value) => {
    const numericValue = Number.parseInt(value, 10);
    if (Number.isNaN(numericValue)) return 0;
    return Math.max(0, Math.min(100, numericValue));
};

const setGoalValue = (key, value) => {
    strategicPlanForm[key] = clampPercentage(value);
};

const saveStrategicPlan = () => {
    strategicPlanForm.post(route('admin.strategic-plan.save'), {
        preserveScroll: true,
        onSuccess: () => alert('Strategic plan tracker updated.'),
        onError: () => alert('Failed to save strategic plan tracker.'),
    });
};

// Event Posting Form
const showEventModal = ref(false);
const imagePreview = ref(null);
const eventError = ref('');
const editingEventId = ref(null);
const eventForm = useForm({
    title: '',
    type: 'Meeting',
    event_date: '',
    description: '',
    external_link: '',
    image: null
});

const handleImageUpload = (event) => {
    const file = event.target.files[0];
    if (file) {
        eventForm.image = file;
        const reader = new FileReader();
        reader.onload = (e) => {
            imagePreview.value = e.target.result;
        };
        reader.readAsDataURL(file);
    }
};

const resetEventForm = () => {
    showEventModal.value = false;
    imagePreview.value = null;
    eventError.value = '';
    editingEventId.value = null;
    eventForm.image = null;
    eventForm.clearErrors();
    eventForm.reset();
    // Clear file input
    const fileInput = document.getElementById('imageInput');
    if (fileInput) fileInput.value = '';
};

const openEventModal = () => {
    resetEventForm();
    showEventModal.value = true;
};

const editEvent = (event) => {
    // Reset form first to ensure clean state
    eventForm.reset();
    eventForm.clearErrors();
    
    // Now populate with event data
    eventForm.title = event.title;
    eventForm.type = event.type;
    eventForm.event_date = event.event_date;
    eventForm.description = event.description;
    eventForm.external_link = event.external_link || '';
    
    // Set the editing ID
    editingEventId.value = event.id;
    
    // Show preview of existing image
    imagePreview.value = event.image_url ? `/storage/${event.image_url}` : null;
    showEventModal.value = true;
};

const submitEvent = () => {
    eventError.value = '';

    if (editingEventId.value) {
        // For PATCH requests, we'll use fetch with FormData
        const formData = new FormData();
        formData.append('_method', 'PATCH');
        formData.append('title', eventForm.title);
        formData.append('type', eventForm.type);
        formData.append('event_date', eventForm.event_date || null);
        formData.append('description', eventForm.description);
        // Only append external_link if it has a value
        if (eventForm.external_link && eventForm.external_link.trim()) {
            formData.append('external_link', eventForm.external_link.trim());
        }
        
        if (eventForm.image && eventForm.image instanceof File) {
            formData.append('image', eventForm.image);
        }

        const csrfToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content') || '';

        console.log('Submitting update with event ID:', editingEventId.value);
        console.log('CSRF Token found:', csrfToken ? 'Yes' : 'No');
        console.log('Route:', route('admin.events.update', editingEventId.value));

        fetch(route('admin.events.update', editingEventId.value), {
            method: 'POST',
            headers: {
                'X-Requested-With': 'XMLHttpRequest',
                'Accept': 'application/json',
                'X-CSRF-TOKEN': csrfToken,
            },
            body: formData,
            redirect: 'follow',
        })
        .then(response => {
            console.log('Response status:', response.status);
            console.log('Response ok:', response.ok);
            console.log('Response headers:', response.headers);
            
            // Success: status 200, 201, 204, or 2xx range
            if (response.ok) {
                alert('Event updated!');
                resetEventForm();
                showEventModal.value = false;
                location.reload();
                return;
            }
            
            // CSRF Token error
            if (response.status === 419) {
                eventError.value = 'Session expired. Please refresh the page and try again.';
                return;
            }
            
            // Validation errors: 422
            if (response.status === 422) {
                return response.json().then(data => {
                    console.log('Validation errors:', data);
                    eventError.value = Object.values(data.errors || {}).flat().join(', ') || 'Validation failed.';
                }).catch(err => {
                    console.error('Error parsing validation response:', err);
                    eventError.value = 'Validation failed.';
                });
            }
            
            // Server errors: 500, etc
            if (response.status >= 500) {
                return response.text().then(text => {
                    console.error('Server error:', text);
                    eventError.value = 'Server error (Status ' + response.status + '). Please contact support.';
                });
            }
            
            // Other errors
            return response.text().then(text => {
                console.error('Response text:', text);
                console.error('Response status code:', response.status);
                eventError.value = 'Failed to update event (Status: ' + response.status + '). Please try again.';
            });
        })
        .catch(error => {
            console.error('Update fetch error:', error);
            eventError.value = 'Network error: ' + error.message;
        });
    } else {
        eventForm.post(route('admin.events.store'), {
            onSuccess: () => {
                resetEventForm();
                showEventModal.value = false;
                alert('Event Published!');
                location.reload();
            },
            onError: (errors) => {
                console.log('Event submission errors:', errors);
                eventError.value = Object.values(errors).flat().join(', ') || 'Failed to publish event. Please try again.';
            }
        });
    }
};

const deleteEvent = (eventId) => {
    if (confirm('Are you sure you want to delete this event?')) {
        const deleteForm = useForm({});
        deleteForm.delete(route('admin.events.destroy', eventId), {
            onSuccess: () => {
                alert('Event deleted!');
                location.reload();
            },
            onError: (error) => {
                alert('Failed to delete event');
                console.log(error);
            }
        });
    }
};

</script>

<template>
    <Head title="Secretariat Command Center" />

    <AuthenticatedLayout>
        <template #header>
            <div class="flex justify-between items-center">
                <h2 class="font-semibold text-xl text-[#1D2A68] leading-tight">LiVCCI Secretariat Admin</h2>
                <div class="flex items-center gap-3">
                    <Link :href="route('admin.accounts.index')" class="bg-white border border-[#1D2A68] text-[#1D2A68] text-sm font-bold py-2 px-4 rounded hover:bg-gray-50 shadow-sm transition">
                        Manage Accounts
                    </Link>
                    <button @click="openEventModal()" class="bg-[#1876C3] text-white text-sm font-bold py-2 px-4 rounded hover:bg-[#1460A0] shadow-md transition">
                        + Post New Event
                    </button>
                </div>
            </div>
        </template>

        <div class="py-12">
            <div class="max-w-7xl mx-auto sm:px-6 lg:px-8 space-y-8">
                <div class="bg-white shadow sm:rounded-lg p-2">
                    <div class="grid grid-cols-1 sm:grid-cols-3 gap-2">
                        <button
                            @click="activeTab = 'member-management'"
                            class="px-4 py-3 rounded-lg text-sm font-bold transition"
                            :class="activeTab === 'member-management' ? 'bg-[#1D2A68] text-white shadow' : 'bg-white text-[#1D2A68] border border-[#1876C3] hover:bg-[#1876C3]/10'"
                        >
                            Member Management
                        </button>
                        <button
                            @click="activeTab = 'financials'"
                            class="px-4 py-3 rounded-lg text-sm font-bold transition"
                            :class="activeTab === 'financials' ? 'bg-[#1D2A68] text-white shadow' : 'bg-white text-[#1D2A68] border border-[#1876C3] hover:bg-[#1876C3]/10'"
                        >
                            Financials
                        </button>
                        <button
                            @click="activeTab = 'settings'"
                            class="px-4 py-3 rounded-lg text-sm font-bold transition"
                            :class="activeTab === 'settings' ? 'bg-[#1D2A68] text-white shadow' : 'bg-white text-[#1D2A68] border border-[#1876C3] hover:bg-[#1876C3]/10'"
                        >
                            News & Events
                        </button>
                    </div>
                </div>

                <template v-if="activeTab === 'member-management'">
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                        <div class="bg-white shadow sm:rounded-lg p-6 border-l-4 border-[#1876C3]">
                            <div class="text-xs font-bold text-gray-400 uppercase">Total Applications</div>
                            <div class="mt-1 text-3xl font-bold text-[#1D2A68]">{{ profiles.length }}</div>
                        </div>
                        <div class="bg-white shadow sm:rounded-lg p-6 border-l-4 border-green-500">
                            <div class="text-xs font-bold text-gray-400 uppercase">Active Members</div>
                            <div class="mt-1 text-3xl font-bold text-green-600">{{ profiles.filter(p => p.status === 'approved').length }}</div>
                        </div>
                        <div class="bg-white shadow sm:rounded-lg p-6 border-l-4 border-yellow-500">
                            <div class="text-xs font-bold text-gray-400 uppercase">Pending Review</div>
                            <div class="mt-1 text-3xl font-bold text-yellow-600">{{ profiles.filter(p => p.status === 'pending').length }}</div>
                        </div>
                    </div>

                    <div class="bg-white shadow sm:rounded-lg overflow-hidden">
                        <div class="px-6 py-4 border-b border-gray-100 bg-gray-50/50">
                            <h3 class="text-lg font-bold text-[#1D2A68]">Manage Member Directory</h3>
                        </div>
                        <div class="overflow-x-auto">
                            <table class="min-w-full divide-y divide-gray-200">
                                <thead class="bg-gray-50">
                                    <tr>
                                        <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase">Company</th>
                                        <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase">Type/Category</th>
                                        <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase">Contact</th>
                                        <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase">TPIN/PACRA</th>
                                        <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase">Status</th>
                                        <th class="px-6 py-3 text-right text-xs font-bold text-gray-500 uppercase">Actions</th>
                                    </tr>
                                </thead>
                                <tbody class="bg-white divide-y divide-gray-100">
                                    <tr v-for="profile in profiles" :key="profile.id" class="hover:bg-gray-50">
                                        <td class="px-6 py-4">
                                            <div class="text-sm font-bold text-gray-900">{{ profile.company_name }}</div>
                                            <div class="text-xs text-gray-500 max-w-xs truncate">{{ profile.short_description }}</div>
                                        </td>
                                        <td class="px-6 py-4">
                                            <div class="text-sm text-gray-900">
                                                <span class="font-medium">{{ profile.member_type }}</span>
                                            </div>
                                            <div class="text-xs text-gray-500">{{ profile.member_category }}</div>
                                        </td>
                                        <td class="px-6 py-4">
                                            <div class="text-sm text-gray-900">{{ profile.contact_email }}</div>
                                            <div class="text-xs text-gray-500">{{ profile.phone }}</div>
                                            <div v-if="profile.address" class="text-xs text-gray-500 max-w-xs truncate">{{ profile.address }}</div>
                                        </td>
                                        <td class="px-6 py-4">
                                            <div class="text-sm text-gray-900">{{ profile.tpin }}</div>
                                            <div v-if="profile.pacra_reg_no" class="text-xs text-gray-500">{{ profile.pacra_reg_no }}</div>
                                        </td>
                                        <td class="px-6 py-4">
                                            <span class="px-2 py-1 text-[10px] font-bold rounded-full uppercase"
                                                  :class="profile.status === 'approved' ? 'bg-green-100 text-green-700' : profile.status === 'pending' ? 'bg-yellow-100 text-yellow-700' : 'bg-red-100 text-red-700'">
                                                {{ profile.status }}
                                            </span>
                                        </td>
                                        <td class="px-6 py-4 text-right space-x-2">
                                            <a
                                                v-if="profile.status === 'approved'"
                                                :href="route('admin.members.certificate', profile.id)"
                                                class="text-[#1876C3] font-bold text-sm hover:underline"
                                            >
                                                Download Certificate
                                            </a>
                                            <button @click="updateStatus(profile.id, 'approved')" class="text-green-600 font-bold text-sm hover:underline">Approve</button>
                                            <button @click="updateStatus(profile.id, 'suspended')" class="text-orange-600 font-bold text-sm hover:underline">Suspend</button>
                                            <button @click="updateStatus(profile.id, 'deactivated')" class="text-red-500 font-bold text-sm hover:underline">Deactivate</button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </template>

                <template v-if="activeTab === 'financials'">
                    <div class="bg-white shadow sm:rounded-lg overflow-hidden">
                        <div class="px-6 py-4 border-b border-gray-100 bg-gray-50/50">
                            <h3 class="text-lg font-bold text-[#1D2A68]">Invoices</h3>
                        </div>
                        <div class="overflow-x-auto">
                            <table class="min-w-full divide-y divide-gray-200">
                                <thead class="bg-gray-50">
                                    <tr>
                                        <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase">Invoice #</th>
                                        <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase">Company</th>
                                        <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase">Membership</th>
                                        <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase">Amount</th>
                                        <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase">Due Date</th>
                                        <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase">Status</th>
                                        <th class="px-6 py-3 text-right text-xs font-bold text-gray-500 uppercase">Actions</th>
                                    </tr>
                                </thead>
                                <tbody class="bg-white divide-y divide-gray-100">
                                    <tr v-for="invoice in invoices" :key="invoice.id" class="hover:bg-gray-50">
                                        <td class="px-6 py-4 text-sm font-semibold text-gray-900">{{ invoice.invoice_number }}</td>
                                        <td class="px-6 py-4 text-sm text-gray-900">{{ invoice.profile?.company_name || 'N/A' }}</td>
                                        <td class="px-6 py-4 text-sm text-gray-600">{{ invoice.profile?.membership_type || 'N/A' }}</td>
                                        <td class="px-6 py-4 text-sm font-medium text-[#1D2A68]">ZMW {{ Number(invoice.amount).toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 }) }}</td>
                                        <td class="px-6 py-4 text-sm text-gray-600">{{ new Date(invoice.due_date).toLocaleDateString() }}</td>
                                        <td class="px-6 py-4">
                                            <span class="px-2 py-1 text-[10px] font-bold rounded-full uppercase" :class="invoice.status === 'Paid' ? 'bg-green-100 text-green-700' : 'bg-yellow-100 text-yellow-700'">
                                                {{ invoice.status }}
                                            </span>
                                        </td>
                                        <td class="px-6 py-4 text-right">
                                            <button
                                                v-if="invoice.status === 'Unpaid'"
                                                @click="confirmPayment(invoice.id)"
                                                :disabled="paymentForm.processing"
                                                class="bg-[#1876C3] text-white text-xs px-3 py-1.5 rounded hover:bg-[#1460A0] transition font-bold disabled:opacity-50 disabled:cursor-not-allowed"
                                            >
                                                Confirm Payment
                                            </button>
                                            <span v-else class="text-xs font-semibold text-green-600">Completed</span>
                                        </td>
                                    </tr>
                                    <tr v-if="!invoices || invoices.length === 0">
                                        <td colspan="7" class="px-6 py-8 text-center text-sm text-gray-500">No invoices found.</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </template>

                <template v-if="activeTab === 'settings'">
                    <div class="bg-white shadow sm:rounded-lg overflow-hidden">
                        <div class="px-6 py-4 border-b border-gray-100 bg-gray-50/50">
                            <h3 class="text-lg font-bold text-[#1D2A68]">Strategic Plan Tracker</h3>
                            <p class="text-sm text-gray-500 mt-1">Drag the slider or enter percentages for each LiVCCI strategic goal.</p>
                        </div>
                        <div class="p-6 space-y-5">
                            <div v-for="goal in strategicGoals" :key="goal.key" class="rounded-lg border border-gray-200 p-4">
                                <div class="flex items-center justify-between gap-4 mb-3">
                                    <div class="text-sm font-bold text-[#1D2A68]">{{ goal.label }}</div>
                                    <div class="flex items-center gap-2">
                                        <input
                                            :value="strategicPlanForm[goal.key]"
                                            @input="setGoalValue(goal.key, $event.target.value)"
                                            type="number"
                                            min="0"
                                            max="100"
                                            class="w-20 border-gray-200 rounded-lg p-2 text-sm text-right"
                                        >
                                        <span class="text-sm font-semibold text-gray-500">%</span>
                                    </div>
                                </div>

                                <div class="w-full bg-gray-200 rounded-full h-3 overflow-hidden">
                                    <div class="h-full bg-[#1876C3] transition-all duration-200" :style="{ width: strategicPlanForm[goal.key] + '%' }"></div>
                                </div>

                                <input
                                    :value="strategicPlanForm[goal.key]"
                                    @input="setGoalValue(goal.key, $event.target.value)"
                                    type="range"
                                    min="0"
                                    max="100"
                                    class="w-full mt-3 accent-[#1D2A68]"
                                >
                            </div>

                            <div class="flex justify-end">
                                <button
                                    @click="saveStrategicPlan"
                                    :disabled="strategicPlanForm.processing"
                                    class="bg-[#1D2A68] text-white text-sm font-bold px-6 py-2.5 rounded-lg hover:bg-[#1876C3] transition disabled:opacity-50 disabled:cursor-not-allowed"
                                >
                                    <span v-if="strategicPlanForm.processing">Saving...</span>
                                    <span v-else>Save Strategic Progress</span>
                                </button>
                            </div>
                        </div>
                    </div>

                    <div class="bg-white shadow sm:rounded-lg overflow-hidden">
                        <div class="px-6 py-4 border-b border-gray-100 bg-gray-50/50">
                            <h3 class="text-lg font-bold text-[#1D2A68]">Published Events</h3>
                        </div>
                        <div v-if="events && events.length > 0" class="divide-y divide-gray-200">
                            <div v-for="event in events" :key="event.id" class="p-6 hover:bg-gray-50 transition">
                                <div class="flex items-start justify-between mb-3">
                                    <div class="flex-1">
                                        <h4 class="text-lg font-bold text-[#1D2A68]">{{ event.title }}</h4>
                                        <p class="text-sm text-gray-600 mt-1">{{ event.description }}</p>
                                        <div v-if="event.external_link" class="mt-2">
                                            <a :href="event.external_link" target="_blank" rel="noopener noreferrer" class="text-[#1876C3] hover:underline text-sm font-medium inline-flex items-center gap-1">
                                                External Link →
                                            </a>
                                        </div>
                                    </div>
                                    <span class="px-3 py-1 rounded-full text-xs font-bold ml-4"
                                          :class="event.type === 'Meeting' ? 'bg-blue-100 text-blue-700' : event.type === 'Workshop' ? 'bg-purple-100 text-purple-700' : event.type === 'Expo' ? 'bg-green-100 text-green-700' : 'bg-orange-100 text-orange-700'">
                                        {{ event.type }}
                                    </span>
                                </div>
                                <div class="flex items-center justify-between mt-3 pt-3 border-t border-gray-200">
                                    <div class="text-sm text-gray-500">
                                        <span v-if="event.event_date">📅 {{ new Date(event.event_date).toLocaleDateString() }}</span>
                                        <span v-else>No date set</span>
                                    </div>
                                    <div class="flex gap-2">
                                        <button @click="editEvent(event)" class="bg-[#1876C3] text-white text-xs px-3 py-1.5 rounded hover:bg-[#1460A0] transition font-medium">
                                            Edit
                                        </button>
                                        <button @click="deleteEvent(event.id)" class="bg-red-500 text-white text-xs px-3 py-1.5 rounded hover:bg-red-600 transition font-medium">
                                            Delete
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div v-else class="p-6 text-center text-gray-500">
                            No events published yet.
                        </div>
                    </div>
                </template>
            </div>
        </div>

        <div v-if="showEventModal" class="fixed inset-0 bg-black/60 flex items-center justify-center z-50 p-4 backdrop-blur-sm">
            <div class="bg-white rounded-xl shadow-2xl max-w-md w-full p-8 border border-gray-100">
                <h3 class="text-2xl font-extrabold text-[#1D2A68] mb-6">{{ editingEventId ? 'Edit Event' : 'Create New Event' }}</h3>
                
                <div v-if="eventError" class="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg mb-4 text-sm">
                    {{ eventError }}
                </div>

                <form @submit.prevent="submitEvent" class="space-y-5">
                    <div>
                        <label class="text-xs font-bold text-gray-500 uppercase tracking-wider">Event Title</label>
                        <input v-model="eventForm.title" type="text" class="w-full border-gray-200 rounded-lg p-3 mt-1 focus:ring-[#1876C3]" required>
                        <span v-if="eventForm.errors.title" class="text-red-500 text-xs mt-1">{{ eventForm.errors.title }}</span>
                    </div>
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="text-xs font-bold text-gray-500 uppercase">Type</label>
                            <select v-model="eventForm.type" class="w-full border-gray-200 rounded-lg p-3 mt-1">
                                <option>Meeting</option><option>Workshop</option><option>Expo</option><option>News</option>
                            </select>
                        </div>
                        <div>
                            <label class="text-xs font-bold text-gray-500 uppercase">Date</label>
                            <input v-model="eventForm.event_date" type="date" class="w-full border-gray-200 rounded-lg p-3 mt-1">
                            <span v-if="eventForm.errors.event_date" class="text-red-500 text-xs mt-1">{{ eventForm.errors.event_date }}</span>
                        </div>
                    </div>
                    <div>
                        <label class="text-xs font-bold text-gray-500 uppercase">Description</label>
                        <textarea v-model="eventForm.description" rows="3" class="w-full border-gray-200 rounded-lg p-3 mt-1" required></textarea>
                        <span v-if="eventForm.errors.description" class="text-red-500 text-xs mt-1">{{ eventForm.errors.description }}</span>
                    </div>
                    <div>
                        <label class="text-xs font-bold text-gray-500 uppercase">External Link (Optional)</label>
                        <input v-model="eventForm.external_link" type="url" placeholder="https://example.com" class="w-full border-gray-200 rounded-lg p-3 mt-1">
                        <span v-if="eventForm.errors.external_link" class="text-red-500 text-xs mt-1">{{ eventForm.errors.external_link }}</span>
                    </div>
                    <div>
                        <label class="text-xs font-bold text-gray-500 uppercase">Event Image</label>
                        <div class="mt-2 border-2 border-dashed border-gray-300 rounded-lg p-4">
                            <input 
                                type="file" 
                                accept="image/*" 
                                @change="handleImageUpload"
                                class="hidden"
                                id="imageInput"
                            >
                            <label for="imageInput" class="cursor-pointer">
                                <div v-if="imagePreview" class="relative">
                                    <img :src="imagePreview" alt="Preview" class="w-full h-32 object-cover rounded">
                                    <p class="text-xs text-gray-500 text-center mt-2">Click to change image</p>
                                </div>
                                <div v-else class="text-center py-4">
                                    <svg class="mx-auto h-8 w-8 text-gray-400" stroke="currentColor" fill="none" viewBox="0 0 48 48">
                                        <path d="M28 8H12a4 4 0 00-4 4v20a4 4 0 004 4h24a4 4 0 004-4V20" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path>
                                        <circle cx="34" cy="14" r="4" stroke-width="2"></circle>
                                        <path d="M9 37L19 27l8 8 12-12" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path>
                                    </svg>
                                    <p class="text-xs text-gray-600 mt-2">Click to upload image</p>
                                </div>
                            </label>
                        </div>
                        <span v-if="eventForm.errors.image" class="text-red-500 text-xs mt-1">{{ eventForm.errors.image }}</span>
                    </div>
                    <div class="flex justify-end items-center space-x-4 pt-4">
                        <button type="button" @click="resetEventForm()" class="text-gray-400 font-bold hover:text-gray-600 transition">Cancel</button>
                        <button type="submit" :disabled="eventForm.processing" class="bg-[#1D2A68] text-white px-8 py-3 rounded-lg font-bold shadow-lg hover:bg-[#1876C3] transition disabled:opacity-50 disabled:cursor-not-allowed">
                            <span v-if="eventForm.processing">{{ editingEventId ? 'Updating...' : 'Publishing...' }}</span>
                            <span v-else>{{ editingEventId ? 'Update Event' : 'Publish to Portal' }}</span>
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </AuthenticatedLayout>
</template>