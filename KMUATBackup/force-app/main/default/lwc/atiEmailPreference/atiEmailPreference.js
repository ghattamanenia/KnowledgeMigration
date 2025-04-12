import { LightningElement, track } from 'lwc';
import saveEmailPreference from '@salesforce/apex/EmailPreferenceController.saveEmailPreference';
import getEmailPreference from '@salesforce/apex/EmailPreferenceController.getEmailPreference';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AtiEmailPreference extends LightningElement {
    @track value = ''; // Selected radio button value

    // Radio button options
    options = [
        { label: 'Send me all system emails including Update Notifications, New Order Notifications, Download Confirmations, and other administrative email messages.', value: 'Send_me_all_system_emails__c' },
        { label: 'Do not send me Update Notifications when products are updated, but do send me other system emails.', value: 'No_Product_Update_Only_System_emails__c' },
        { label: 'Do not send me any emails (other than Password Finder emails).', value: 'No_emails_only_Password_Finder_emails__c' }
    ];

    // Getter to display the label of the selected radio button
    get selectedLabel() {
        const selectedOption = this.options.find(option => option.value === this.value);
        return selectedOption ? selectedOption.label : '';
    }

    // Fetch the saved preference when the component loads
    connectedCallback() {
        this.loadPreference();
    }

    // Load the saved email preference from the server
    loadPreference() {
        getEmailPreference()
            .then((preference) => {
                this.value = preference;
                console.log('Loaded preference:', preference); // Debug log
            })
            .catch((error) => {
                console.error('Error loading preference:', error); // Debug log for error
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'Unable to load email preference: ' + (error.body.message || error.message),
                        variant: 'error',
                    })
                );
            });
    }

    // Handle radio button value change
    handleChange(event) {
        this.value = event.target.value;
        console.log('Selected preference:', this.value); // Debug log for preference
    }

    // Handle submit button click
    handleSubmit() {
        console.log('Submit button clicked.'); // Debug log for button click

        if (!this.value) {
            // Show error toast if no option is selected
            console.log('No preference selected.'); // Debug log for missing selection
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Please select an email preference before submitting.',
                    variant: 'error',
                })
            );
            return;
        }

        console.log('Saving preference:', this.value); // Debug log before Apex call

        // Call Apex method to save the preference
        saveEmailPreference({ preference: this.value })
            .then(() => {
                console.log('Preference saved successfully.'); // Debug log for success
                // Show success toast message
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Email preference saved successfully.',
                        variant: 'success',
                    })
                );
            })
            .catch((error) => {
                console.error('Error saving preference:', error); // Debug log for error
                // Show error toast message
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'An error occurred while saving the preference: ' + (error.body.message || error.message),
                        variant: 'error',
                    })
                );
            });
    }
}