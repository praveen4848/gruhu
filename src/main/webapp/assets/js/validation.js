/**
 * Gruhu Atelier - Form Validation & Client Verification
 */

const GruhuValidation = {
    isValidEmail: (email) => {
        return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
    },

    isValidPhone: (phone) => {
        return /^[6-9]\d{9}$/.test(phone.replace(/\D/g, ''));
    },

    isValidPincode: (pin) => {
        return /^\d{6}$/.test(pin.trim());
    },

    markError: (input, message) => {
        input.classList.add('input-error');
        let msgElement = input.parentNode.querySelector('.form-error-msg');
        if (!msgElement) {
            msgElement = document.createElement('small');
            msgElement.className = 'form-error-msg';
            msgElement.style.color = '#a82a2a';
            msgElement.style.fontSize = '0.75rem';
            msgElement.style.marginTop = '4px';
            msgElement.style.display = 'block';
            input.parentNode.appendChild(msgElement);
        }
        msgElement.textContent = message;
    },

    clearError: (input) => {
        input.classList.remove('input-error');
        const msgElement = input.parentNode.querySelector('.form-error-msg');
        if (msgElement) {
            msgElement.remove();
        }
    }
};

document.addEventListener('DOMContentLoaded', () => {
    // Phone input restriction to numbers
    const phoneInputs = document.querySelectorAll('input[type="tel"], input[name="phone"]');
    phoneInputs.forEach(input => {
        input.addEventListener('input', (e) => {
            e.target.value = e.target.value.replace(/\D/g, '').slice(0, 10);
            if (e.target.value.length === 10) {
                GruhuValidation.clearError(e.target);
            }
        });
    });

    // Pincode input restriction to 6 digits
    const pinInputs = document.querySelectorAll('input[name="pincode"]');
    pinInputs.forEach(input => {
        input.addEventListener('input', (e) => {
            e.target.value = e.target.value.replace(/\D/g, '').slice(0, 6);
            if (e.target.value.length === 6) {
                GruhuValidation.clearError(e.target);
            }
        });
    });

    // Password confirmation checker
    const registerForm = document.querySelector('form[action*="register"]');
    if (registerForm) {
        const passwordInput = registerForm.querySelector('input[name="password"]');
        const confirmInput = registerForm.querySelector('input[name="confirmPassword"]');

        if (passwordInput && confirmInput) {
            confirmInput.addEventListener('input', () => {
                if (confirmInput.value !== passwordInput.value) {
                    GruhuValidation.markError(confirmInput, 'Passphrases do not match.');
                } else {
                    GruhuValidation.clearError(confirmInput);
                }
            });
        }
    }
});
