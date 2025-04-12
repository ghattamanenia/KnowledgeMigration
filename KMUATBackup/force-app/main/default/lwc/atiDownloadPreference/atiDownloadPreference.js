import { LightningElement, track } from 'lwc';
import getDownloadPreference from '@salesforce/apex/DownloadPreferenceController.getDownloadPreference';
import updateDownloadPreference from '@salesforce/apex/DownloadPreferenceController.updateDownloadPreference';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AtiDownloadPreference extends LightningElement {
    @track downloadPreference = false;
    @track isLoading = false;

    connectedCallback() {
        this.loadDownloadPreference();
    }

    // Fetch the current preference
    async loadDownloadPreference() {
        this.isLoading = true;
        try {
            const result = await getDownloadPreference();
            this.downloadPreference = result || false;
        } catch (error) {
            this.showToast('Error', this.getErrorMessage(error), 'error');
        } finally {
            this.isLoading = false;
        }
    }

    // Handle checkbox change
    handlePreferenceChange(event) {
        this.downloadPreference = event.target.checked;
    }

    // Save the updated preference
    async handleSave() {
        this.isLoading = true;
        try {
            await updateDownloadPreference({ downloadPreference: this.downloadPreference });
            this.showToast('Success', 'Preference updated successfully!', 'success');
        } catch (error) {
            this.showToast('Error', this.getErrorMessage(error), 'error');
        } finally {
            this.isLoading = false;
        }
    }

    // Extract error messages
    getErrorMessage(error) {
        if (error.body) {
            if (error.body.message) {
                return error.body.message; // Apex error message
            } else if (error.body.pageErrors && error.body.pageErrors.length > 0) {
                return error.body.pageErrors[0].message; // Page-level errors
            } else if (error.body.fieldErrors) {
                const fieldErrors = Object.values(error.body.fieldErrors);
                if (fieldErrors.length > 0 && fieldErrors[0].length > 0) {
                    return fieldErrors[0][0].message; // Field-specific error message
                }
            }
        }
        return 'An unexpected error occurred.';
    }

    // Utility to show toast messages
    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title,
            message,
            variant, // 'success', 'error', or 'warning'
        });
        this.dispatchEvent(event);
    }
}