/**
 * Sunrise Dental Clinic - Notifications & Confirmations System
 * Provides modern animated Toast notifications & SweetAlert-style confirmation modals
 */

(function () {
    // 1. Ensure Toast Container Exists
    function getToastContainer() {
        let container = document.querySelector('.toast-notifications-container');
        if (!container) {
            container = document.createElement('div');
            container.className = 'toast-notifications-container';
            document.body.appendChild(container);
        }
        return container;
    }

    // 2. Global Toast Function
    window.showToast = function (type, title, message, duration) {
        if (!type) type = 'success';
        if (!duration) duration = 4500;

        const container = getToastContainer();
        const toast = document.createElement('div');
        toast.className = 'toast-card toast-' + type;

        let iconClass = 'bi-check-circle-fill';
        if (type === 'error') iconClass = 'bi-x-circle-fill';
        else if (type === 'warning') iconClass = 'bi-exclamation-triangle-fill';
        else if (type === 'info') iconClass = 'bi-info-circle-fill';

        toast.innerHTML = `
            <div class="toast-icon">
                <i class="bi ${iconClass}"></i>
            </div>
            <div class="toast-body">
                <div class="toast-title">${escapeHtml(title || capitalize(type))}</div>
                <div class="toast-message">${message || ''}</div>
            </div>
            <button type="button" class="toast-close" title="Close">✕</button>
            <div class="toast-progress" style="animation-duration: ${duration}ms;"></div>
        `;

        container.appendChild(toast);

        // Force reflow for CSS animation
        setTimeout(() => toast.classList.add('show'), 10);

        // Dismiss logic
        const dismiss = () => {
            toast.classList.remove('show');
            toast.classList.add('hide');
            setTimeout(() => {
                if (toast.parentElement) toast.parentElement.removeChild(toast);
            }, 350);
        };

        const closeBtn = toast.querySelector('.toast-close');
        if (closeBtn) closeBtn.addEventListener('click', dismiss);

        const timer = setTimeout(dismiss, duration);
        toast.addEventListener('mouseenter', () => clearTimeout(timer));
    };

    // 3. Global Confirmation Dialog Function
    window.showConfirmDialog = function (options) {
        const title = options.title || "Confirm Action";
        const message = options.message || "Are you sure you want to proceed with this action?";
        const confirmText = options.confirmText || "Confirm";
        const cancelText = options.cancelText || "Cancel";
        const type = options.type || "danger"; // 'danger', 'primary', 'warning', 'info', 'success'
        const onConfirm = options.onConfirm || function () {};
        const onCancel = options.onCancel || function () {};

        // Remove any existing confirm dialog
        const existing = document.querySelector('.custom-confirm-overlay');
        if (existing) existing.remove();

        const overlay = document.createElement('div');
        overlay.className = 'custom-confirm-overlay';

        let iconMarkup = '<i class="bi bi-exclamation-triangle-fill"></i>';
        if (type === 'danger') iconMarkup = '<i class="bi bi-trash3-fill"></i>';
        else if (type === 'primary') iconMarkup = '<i class="bi bi-question-circle-fill"></i>';
        else if (type === 'success') iconMarkup = '<i class="bi bi-check2-circle"></i>';

        overlay.innerHTML = `
            <div class="custom-confirm-box">
                <div class="confirm-icon-wrap ${type}">
                    ${iconMarkup}
                </div>
                <h3>${escapeHtml(title)}</h3>
                <p>${escapeHtml(message)}</p>
                <div class="confirm-actions">
                    <button type="button" class="confirm-btn cancel" id="btnConfirmCancel">${escapeHtml(cancelText)}</button>
                    <button type="button" class="confirm-btn ${type}" id="btnConfirmOk">${escapeHtml(confirmText)}</button>
                </div>
            </div>
        `;

        document.body.appendChild(overlay);
        setTimeout(() => overlay.classList.add('show'), 10);

        const closeDialog = () => {
            overlay.classList.remove('show');
            setTimeout(() => overlay.remove(), 250);
        };

        overlay.querySelector('#btnConfirmCancel').addEventListener('click', () => {
            closeDialog();
            onCancel();
        });

        overlay.querySelector('#btnConfirmOk').addEventListener('click', () => {
            closeDialog();
            onConfirm();
        });

        overlay.addEventListener('click', (e) => {
            if (e.target === overlay) {
                closeDialog();
                onCancel();
            }
        });
    };

    // Helper functions
    function capitalize(str) {
        if (!str) return '';
        return str.charAt(0).toUpperCase() + str.slice(1);
    }

    function escapeHtml(text) {
        if (!text) return '';
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    // 4. Auto-attach to forms / links with data-confirm & Parse page alerts
    document.addEventListener('DOMContentLoaded', () => {
        // Intercept data-confirm forms
        document.querySelectorAll('form[data-confirm]').forEach((form) => {
            form.addEventListener('submit', function (e) {
                if (form.getAttribute('data-confirmed') === 'true') {
                    form.removeAttribute('data-confirmed');
                    return true;
                }
                e.preventDefault();
                const msg = form.getAttribute('data-confirm') || "Are you sure you want to proceed?";
                const title = form.getAttribute('data-confirm-title') || "Please Confirm";
                const type = form.getAttribute('data-confirm-type') || "danger";
                const btnText = form.getAttribute('data-confirm-btn') || "Yes, Proceed";

                window.showConfirmDialog({
                    title: title,
                    message: msg,
                    confirmText: btnText,
                    type: type,
                    onConfirm: () => {
                        form.setAttribute('data-confirmed', 'true');
                        form.submit();
                    }
                });
            });
        });

        // 5. Automatic In-Page Server Flash Alerts Scanner
        let foundPageAlert = false;
        document.querySelectorAll('.alert-box.success, .alert.success-alert, .alert.alert-success, .alert-banner.success').forEach((el) => {
            const txt = (el.innerText || el.textContent || '').trim();
            if (txt && !foundPageAlert) {
                foundPageAlert = true;
                window.showToast('success', 'Operation Successful', txt, 4500);
            }
        });

        document.querySelectorAll('.alert-box.error, .alert.error-alert, .alert.alert-error, .alert-banner.error, .alert.error').forEach((el) => {
            const txt = (el.innerText || el.textContent || '').trim();
            if (txt && !foundPageAlert) {
                foundPageAlert = true;
                window.showToast('error', 'Operation Alert', txt, 5500);
            }
        });

        // 6. Automatic URL Query Parameter Scanner
        if (!foundPageAlert) {
            const urlParams = new URLSearchParams(window.location.search);
            const success = urlParams.get('success');
            const error = urlParams.get('error');
            const msg = urlParams.get('msg') || urlParams.get('message');
            const email = urlParams.get('email');

            if (success) {
                let title = "Action Successful!";
                let message = "Your request was completed successfully.";

                switch (success.toLowerCase()) {
                    case 'updated':
                        title = "Update Successful";
                        message = msg || "The record details have been updated successfully.";
                        break;
                    case 'saved':
                        title = "Changes Saved";
                        message = msg || "Your updates have been saved to the system.";
                        break;
                    case 'registered':
                    case 'created':
                        title = "Registration Complete";
                        message = msg || "New record has been registered successfully.";
                        break;
                    case 'booked':
                        title = "Appointment Confirmed";
                        message = msg || "The appointment has been successfully scheduled.";
                        break;
                    case 'rescheduled':
                        title = "Appointment Rescheduled";
                        message = msg || "The appointment date and time slot have been updated.";
                        break;
                    case 'cancelled':
                        title = "Appointment Cancelled";
                        message = "The appointment was cancelled and the time slot is now available.";
                        break;
                    case 'resent':
                        title = "Email Resent Successfully";
                        message = "Confirmation details have been sent to " + (email ? decodeURIComponent(email) : "the patient") + ".";
                        break;
                    case 'resetpassword':
                    case 'reset':
                    case 'passwordreset':
                        title = "Password Reset Successful";
                        message = "The staff member's password has been updated successfully.";
                        break;
                    case 'deleted':
                    case 'removed':
                        title = "Record Removed";
                        message = msg || "The item has been removed from the system.";
                        break;
                    case 'billgenerated':
                    case 'paid':
                        title = "Invoice & Payment Recorded";
                        message = msg || "Billing transaction has been finalized successfully.";
                        break;
                    default:
                        message = msg || ("Operation '" + success + "' completed successfully.");
                }

                window.showToast('success', title, message, 5000);
                cleanUrlParams(['success', 'msg', 'message', 'email']);
            } else if (error) {
                let title = "Operation Failed";
                let message = "An error occurred while processing your request.";

                switch (error.toLowerCase()) {
                    case 'invalid':
                    case 'invalid_input':
                        title = "Invalid Input";
                        message = msg || "Please check the information provided and try again.";
                        break;
                    case 'notfound':
                        title = "Record Not Found";
                        message = "The requested appointment or patient record could not be found.";
                        break;
                    case 'noemail':
                        title = "No Email Address";
                        message = "Patient does not have an email address on file. Please update their profile first.";
                        break;
                    case 'email_failed':
                    case 'emailfailed':
                        title = "Email Delivery Failed";
                        message = "Failed to send email. Please check network and mail settings.";
                        break;
                    case 'duplicate':
                        title = "Duplicate Record";
                        message = msg || "A record with this identifier or email already exists.";
                        break;
                    case 'cancel':
                        title = "Cancellation Failed";
                        message = "Could not cancel the appointment. Please try again.";
                        break;
                    case 'server':
                        title = "System Error";
                        message = "A server error occurred. Please contact the administrator.";
                        break;
                    default:
                        message = msg || ("Error: " + error);
                }

                window.showToast('error', title, message, 6000);
                cleanUrlParams(['error', 'msg', 'message']);
            }
        }
    });

    function cleanUrlParams(keys) {
        if (!window.history || !window.history.replaceState) return;
        const url = new URL(window.location.href);
        let changed = false;
        keys.forEach(k => {
            if (url.searchParams.has(k)) {
                url.searchParams.delete(k);
                changed = true;
            }
        });
        if (changed) {
            const cleanUrl = url.pathname + (url.searchParams.toString() ? '?' + url.searchParams.toString() : '') + url.hash;
            window.history.replaceState({}, document.title, cleanUrl);
        }
    }
})();
