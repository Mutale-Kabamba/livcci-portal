import Swal from 'sweetalert2';

const BRAND = {
    confirmButtonColor: '#1D2A68',
    cancelButtonColor: '#6b7280',
};

export const showSuccess = (text, title = 'Success') =>
    Swal.fire({
        title,
        text,
        icon: 'success',
        confirmButtonColor: BRAND.confirmButtonColor,
    });

export const showError = (text, title = 'Something went wrong') =>
    Swal.fire({
        title,
        text,
        icon: 'error',
        confirmButtonColor: '#b91c1c',
    });

export const showInfo = (text, title = 'Notice') =>
    Swal.fire({
        title,
        text,
        icon: 'info',
        confirmButtonColor: BRAND.confirmButtonColor,
    });

export const confirmAction = async ({
    title = 'Are you sure?',
    text = '',
    confirmText = 'Yes, continue',
    cancelText = 'Cancel',
    icon = 'warning',
} = {}) => {
    const result = await Swal.fire({
        title,
        text,
        icon,
        showCancelButton: true,
        confirmButtonText: confirmText,
        cancelButtonText: cancelText,
        confirmButtonColor: BRAND.confirmButtonColor,
        cancelButtonColor: BRAND.cancelButtonColor,
        reverseButtons: true,
    });

    return result.isConfirmed;
};

export const promptSelect = async ({
    title,
    inputPlaceholder = 'Select an option',
    options = {},
    confirmText = 'Continue',
    cancelText = 'Cancel',
    icon = 'question',
} = {}) => {
    const result = await Swal.fire({
        title,
        icon,
        input: 'select',
        inputOptions: options,
        inputPlaceholder,
        showCancelButton: true,
        confirmButtonText: confirmText,
        cancelButtonText: cancelText,
        confirmButtonColor: BRAND.confirmButtonColor,
        cancelButtonColor: BRAND.cancelButtonColor,
        inputValidator: (value) => (!value ? 'Please select a role.' : undefined),
    });

    if (!result.isConfirmed) return null;
    return result.value;
};
