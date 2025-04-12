import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import changePassword from '@salesforce/apex/ATChangePasswordController.changePassword';

export default class AtiChangePasswordComp extends LightningElement {
    @track currentPassword = '';
    @track newPassword = '';
    @track verifyNewPassword = '';
    @track errorMessage = '';

    handleInputChange(event) {
        const field = event.target.dataset.field;
        this[field] = event.target.value;
    }

    async handleChangePassword() {
        this.errorMessage = '';

        if (!this.validatePasswords()) {
            this.showToast('Error', this.errorMessage, 'error');
            return;
        }

        try {
            await changePassword({
                currentPassword: this.currentPassword,
                newPassword: this.newPassword,
                verifyNewPassword: this.verifyNewPassword
            });
            this.clearFields();
            this.showToast('Success', 'Password changed successfully!', 'success');
        } catch (error) {
            const message = error.body && error.body.message ? error.body.message : 'An error occurred.';
            this.showToast('Error', message, 'error');
        }
    }

    validatePasswords() {
        if (this.newPassword !== this.verifyNewPassword) {
            this.errorMessage = 'New Password and Verify Password must match.';
            return false;
        }

        const passwordPattern = /^(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&*()_+\-={}[\]|\\:;"',.?/`~><]).{8,}$/;
        if (!passwordPattern.test(this.newPassword)) {
            this.errorMessage =
                'Your password must be at least 8 characters long and include letters, numbers, and a special character.';
            return false;
        }

        return true;
    }

    clearFields() {
        this.currentPassword = '';
        this.newPassword = '';
        this.verifyNewPassword = '';
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title,
            message,
            variant,
        });
        this.dispatchEvent(event);
    }
}