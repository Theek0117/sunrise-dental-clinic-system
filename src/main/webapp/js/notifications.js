/**
 * Sunrise Dental Clinic - Notifications & Confirmations System
 * Provides modern animated Toast notifications & SweetAlert-style confirmation modals
 */

(function () {
    // 1. Inject Toast & Modal Styles directly to guarantee display on ALL pages
    function injectStyles() {
        if (document.getElementById('sunrise-notification-styles')) return;
        const style = document.createElement('style');
        style.id = 'sunrise-notification-styles';
        style.textContent = `
            .toast-notifications-container {
                position: fixed;
                top: 24px;
                right: 24px;
                z-index: 9999999;
                display: flex;
                flex-direction: column;
                gap: 12px;
                pointer-events: none;
                max-width: 420px;
                width: calc(100vw - 48px);
                font-family: 'Poppins', sans-serif;
            }
            .toast-card {
                pointer-events: auto;
                background: #ffffff;
                border-radius: 16px;
                padding: 16px 18px;
                box-shadow: 0 15px 40px rgba(7, 43, 56, 0.18), 0 2px 8px rgba(0, 0, 0, 0.06);
                border: 1px solid #eef4f7;
                display: flex;
                align-items: flex-start;
                gap: 14px;
                position: relative;
                overflow: hidden;
                transform: translateX(120%);
                opacity: 0;
                transition: all 0.35s cubic-bezier(0.16, 1, 0.3, 1);
            }
            .toast-card.show { transform: translateX(0); opacity: 1; }
            .toast-card.hide { transform: translateX(120%); opacity: 0; }
            .toast-card.toast-success { border-left: 5px solid #10b981; }
            .toast-card.toast-success .toast-icon { background: #ecfdf5; color: #10b981; }
            .toast-card.toast-error { border-left: 5px solid #ef4444; }
            .toast-card.toast-error .toast-icon { background: #fef2f2; color: #ef4444; }
            .toast-card.toast-warning { border-left: 5px solid #f59e0b; }
            .toast-card.toast-warning .toast-icon { background: #fffbeb; color: #f59e0b; }
            .toast-card.toast-info { border-left: 5px solid #0ea5b4; }
            .toast-card.toast-info .toast-icon { background: #e0f7fa; color: #0ea5b4; }
            .toast-icon {
                width: 36px;
                height: 36px;
                border-radius: 10px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 18px;
                flex-shrink: 0;
            }
            .toast-body { flex: 1; }
            .toast-title { font-size: 14px; font-weight: 700; color: #0f172a; margin-bottom: 3px; }
            .toast-message { font-size: 12.5px; color: #475569; line-height: 1.5; }
            .toast-close {
                background: transparent;
                border: none;
                color: #94a3b8;
                font-size: 16px;
                cursor: pointer;
                padding: 0;
                line-height: 1;
                transition: color 0.2s;
                margin-left: 6px;
            }
            .toast-close:hover { color: #0f172a; }
            .toast-progress {
                position: absolute;
                bottom: 0;
                left: 0;
                height: 3px;
                background: #10b981;
                width: 100%;
                animation: toastProgress linear forwards;
            }
            .toast-error .toast-progress { background: #ef4444; }
            .toast-warning .toast-progress { background: #f59e0b; }
            .toast-info .toast-progress { background: #0ea5b4; }
            @keyframes toastProgress { from { width: 100%; } to { width: 0%; } }

            /* CONFIRMATION POPUP MODAL (SWEETALERT STYLE) */
            .custom-confirm-overlay {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: rgba(7, 43, 56, 0.65);
                backdrop-filter: blur(6px);
                display: none;
                align-items: center;
                justify-content: center;
                z-index: 99999999;
                padding: 20px;
                animation: confirmFadeIn 0.2s ease;
                font-family: 'Poppins', sans-serif;
            }
            .custom-confirm-overlay.show { display: flex; }
            .custom-confirm-box {
                background: #ffffff;
                border-radius: 24px;
                width: 100%;
                max-width: 440px;
                box-shadow: 0 25px 60px rgba(0, 0, 0, 0.25);
                padding: 32px 28px;
                text-align: center;
                animation: confirmPop 0.3s cubic-bezier(0.16, 1, 0.3, 1);
                border: 1px solid #eef4f7;
            }
            @keyframes confirmFadeIn { from { opacity: 0; } to { opacity: 1; } }
            @keyframes confirmPop {
                from { opacity: 0; transform: scale(0.9) translateY(15px); }
                to { opacity: 1; transform: scale(1) translateY(0); }
            }
            .confirm-icon-wrap {
                width: 70px;
                height: 70px;
                border-radius: 50%;
                margin: 0 auto 18px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 32px;
            }
            .confirm-icon-wrap.danger { background: #fee2e2; color: #dc2626; }
            .confirm-icon-wrap.warning { background: #fef3c7; color: #d97706; }
            .confirm-icon-wrap.info { background: #e0f2fe; color: #0284c7; }
            .confirm-icon-wrap.success { background: #d1fae5; color: #059669; }
            .custom-confirm-box h3 { font-size: 19px; font-weight: 700; color: #0f172a; margin-bottom: 8px; }
            .custom-confirm-box p { font-size: 13.5px; color: #64748b; line-height: 1.6; margin-bottom: 24px; }
            .confirm-actions { display: flex; gap: 12px; justify-content: center; }
            .confirm-btn {
                flex: 1;
                padding: 12px 18px;
                border-radius: 12px;
                font-size: 13.5px;
                font-weight: 600;
                border: none;
                cursor: pointer;
                transition: all 0.2s ease;
            }
            .confirm-btn.cancel { background: #f1f5f9; color: #475569; }
            .confirm-btn.cancel:hover { background: #e2e8f0; }
            .confirm-btn.danger { background: #dc2626; color: #ffffff; box-shadow: 0 4px 14px rgba(220, 38, 38, 0.3); }
            .confirm-btn.danger:hover { background: #b91c1c; transform: translateY(-1px); }
            .confirm-btn.primary { background: #0ea5b4; color: #ffffff; box-shadow: 0 4px 14px rgba(14, 165, 180, 0.3); }
            .confirm-btn.primary:hover { background: #087f8c; transform: translateY(-1px); }
        `;
        document.head.appendChild(style);
    }

    // 2. Ensure Toast Container Exists
    function getToastContainer() {
        injectStyles();
        let container = document.querySelector('.toast-notifications-container');
        if (!container) {
            container = document.createElement('div');
            container.className = 'toast-notifications-container';
            document.body.appendChild(container);
        }
        return container;
    }

    // 3. Global Toast Function
    window.showToast = function (type, title, message, duration) {
        injectStyles();
        if (!type) type = 'success';
        if (!duration) duration = 4500;

        const container = getToastContainer();
        const toast = document.createElement('div');
        toast.className = 'toast-card toast-' + type;

        let iconMarkup = '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>';
        if (type === 'error') {
            iconMarkup = '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="15" y1="9" x2="9" y2="15"></line><line x1="9" y1="9" x2="15" y2="15"></line></svg>';
        } else if (type === 'warning') {
            iconMarkup = '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path><line x1="12" y1="9" x2="12" y2="13"></line><line x1="12" y1="17" x2="12.01" y2="17"></line></svg>';
        } else if (type === 'info') {
            iconMarkup = '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12.01" y2="8"></line></svg>';
        }

        toast.innerHTML = `
            <div class="toast-icon">
                ${iconMarkup}
            </div>
            <div class="toast-body">
                <div class="toast-title">${escapeHtml(title || capitalize(type))}</div>
                <div class="toast-message">${message || ''}</div>
            </div>
            <button type="button" class="toast-close" title="Close">✕</button>
            <div class="toast-progress" style="animation-duration: ${duration}ms;"></div>
        `;

        container.appendChild(toast);

        setTimeout(() => toast.classList.add('show'), 10);

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

    // 4. Global Confirmation Dialog Function
    window.showConfirmDialog = function (options) {
        injectStyles();
        const title = options.title || "Confirm Action";
        const message = options.message || "Are you sure you want to proceed with this action?";
        const confirmText = options.confirmText || "Confirm";
        const cancelText = options.cancelText || "Cancel";
        const type = options.type || "danger";
        const onConfirm = options.onConfirm || function () {};
        const onCancel = options.onCancel || function () {};

        const existing = document.querySelector('.custom-confirm-overlay');
        if (existing) existing.remove();

        const overlay = document.createElement('div');
        overlay.className = 'custom-confirm-overlay';

        let iconMarkup = '<svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path><polyline points="16 17 21 12 16 7"></polyline><line x1="21" y1="12" x2="9" y2="12"></line></svg>';

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

    document.addEventListener('DOMContentLoaded', () => {
        injectStyles();

        // 5. Intercept logout clicks across all navigation links
        document.querySelectorAll('.logout-item, a[href*="/logout"], a[href$="/logout"], a[href*="logout"]').forEach((link) => {
            link.addEventListener('click', function (e) {
                e.preventDefault();
                const targetUrl = this.getAttribute('href');
                window.showConfirmDialog({
                    title: "Confirm Sign Out",
                    message: "Are you sure you want to end your current session and sign out?",
                    confirmText: "Yes, Log Out",
                    cancelText: "Stay Logged In",
                    type: "danger",
                    onConfirm: () => {
                        window.location.href = targetUrl;
                    }
                });
            });
        });

        // 6. PRIORITY 1: Check for explicit ?logout parameter
        const urlParams = new URLSearchParams(window.location.search);
        const logoutParam = urlParams.get('logout');
        if (logoutParam) {
            window.showToast('success', 'Logged Out Successfully', 'You have been safely signed out of Sunrise Dental Clinic.', 5000);
            cleanUrlParams(['logout']);
            return;
        }

        // 7. Automatic In-Page Server Flash Alerts Scanner
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
                window.showToast('error', 'Notice', txt, 5500);
            }
        });

        // 8. Automatic URL Query Parameter Scanner
        if (!foundPageAlert) {
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
