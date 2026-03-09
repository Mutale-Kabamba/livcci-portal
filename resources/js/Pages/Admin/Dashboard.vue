<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { Head, useForm } from '@inertiajs/vue3';
import { ref } from 'vue';

const props = defineProps({
    profiles: Array,
    events: Array
});

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

// Event Posting Form
const showEventModal = ref(false);
const imagePreview = ref(null);
const eventForm = useForm({
    title: '',
    type: 'Meeting',
    event_date: '',
    description: '',
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

const submitEvent = () => {
    eventForm.post(route('admin.events.store'), {
        onSuccess: () => {
            showEventModal.value = false;
            eventForm.reset();
            imagePreview.value = null;
            alert('Event Published!');
        }
    });
};
</script>

<template>
    <Head title="Secretariat Command Center" />

    <AuthenticatedLayout>
        <template #header>
            <div class="flex justify-between items-center">
                <h2 class="font-semibold text-xl text-[#1D2A68] leading-tight">LiVCCI Secretariat Admin</h2>
                <button @click="showEventModal = true" class="bg-[#1876C3] text-white text-sm font-bold py-2 px-4 rounded hover:bg-[#1460A0] shadow-md transition">
                    + Post New Event
                </button>
            </div>
        </template>

        <div class="py-12">
            <div class="max-w-7xl mx-auto sm:px-6 lg:px-8 space-y-8">
                
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
                        <h3 class="text-lg font-bold text-[#1D2A68]">Published Events</h3>
                    </div>
                    <div v-if="events && events.length > 0" class="divide-y divide-gray-200">
                        <div v-for="event in events" :key="event.id" class="p-6 hover:bg-gray-50 transition">
                            <div class="flex items-start justify-between mb-3">
                                <div>
                                    <h4 class="text-lg font-bold text-[#1D2A68]">{{ event.title }}</h4>
                                    <p class="text-sm text-gray-600 mt-1">{{ event.description }}</p>
                                </div>
                                <span class="px-3 py-1 rounded-full text-xs font-bold"
                                      :class="event.type === 'Meeting' ? 'bg-blue-100 text-blue-700' : 
                                               event.type === 'Workshop' ? 'bg-purple-100 text-purple-700' :
                                               event.type === 'Expo' ? 'bg-green-100 text-green-700' :
                                               'bg-orange-100 text-orange-700'">
                                    {{ event.type }}
                                </span>
                            </div>
                            <div class="text-sm text-gray-500">
                                <span v-if="event.event_date">📅 {{ new Date(event.event_date).toLocaleDateString() }}</span>
                                <span v-else>No date set</span>
                            </div>
                        </div>
                    </div>
                    <div v-else class="p-6 text-center text-gray-500">
                        No events published yet.
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
                                              :class="profile.status === 'approved' ? 'bg-green-100 text-green-700' : 
                                                       profile.status === 'pending' ? 'bg-yellow-100 text-yellow-700' :
                                                       'bg-red-100 text-red-700'">
                                            {{ profile.status }}
                                        </span>
                                    </td>
                                    <td class="px-6 py-4 text-right space-x-2">
                                        <button @click="updateStatus(profile.id, 'approved')" class="text-green-600 font-bold text-sm hover:underline">Approve</button>
                                        <button @click="updateStatus(profile.id, 'suspended')" class="text-orange-600 font-bold text-sm hover:underline">Suspend</button>
                                        <button @click="updateStatus(profile.id, 'deactivated')" class="text-red-500 font-bold text-sm hover:underline">Deactivate</button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <div v-if="showEventModal" class="fixed inset-0 bg-black/60 flex items-center justify-center z-50 p-4 backdrop-blur-sm">
            <div class="bg-white rounded-xl shadow-2xl max-w-md w-full p-8 border border-gray-100">
                <h3 class="text-2xl font-extrabold text-[#1D2A68] mb-6">Create New Event</h3>
                <form @submit.prevent="submitEvent" class="space-y-5">
                    <div>
                        <label class="text-xs font-bold text-gray-500 uppercase tracking-wider">Event Title</label>
                        <input v-model="eventForm.title" type="text" class="w-full border-gray-200 rounded-lg p-3 mt-1 focus:ring-[#1876C3]" required>
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
                        </div>
                    </div>
                    <div>
                        <label class="text-xs font-bold text-gray-500 uppercase">Description</label>
                        <textarea v-model="eventForm.description" rows="3" class="w-full border-gray-200 rounded-lg p-3 mt-1" required></textarea>
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
                    </div>
                    <div class="flex justify-end items-center space-x-4 pt-4">
                        <button type="button" @click="showEventModal = false; imagePreview = null; eventForm.reset();" class="text-gray-400 font-bold hover:text-gray-600 transition">Cancel</button>
                        <button type="submit" class="bg-[#1D2A68] text-white px-8 py-3 rounded-lg font-bold shadow-lg hover:bg-[#1876C3] transition">
                            Publish to Portal
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </AuthenticatedLayout>
</template>