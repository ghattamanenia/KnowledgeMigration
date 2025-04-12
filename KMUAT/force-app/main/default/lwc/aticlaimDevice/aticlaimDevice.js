import { LightningElement, track } from 'lwc';

export default class aticlaimDeviceComp extends LightningElement {
    @track serialNumber = ''; // Store the serial number entered by the user
    @track idType = ''; // Store the selected ID Type from the dropdown
    @track isClaimed = false; // Flag to display success message

    // Options for the ID Type dropdown
      idTypeOptions = [
        { label: 'ETHERNET', value: 'ethernet' },
        { label: 'INTERNET', value: 'internet' },
        { label: 'INTERNET_6', value: 'internet_6' },
        { label: 'FLEXID_9', value: 'flexid_9' },
        { label: 'FLEXID_10', value: 'flexid_10' },
        { label: 'STRING', value: 'string' },
        { label: 'VM_UUID', value: 'vm_uuid' },
        { label: 'CONTAINER_ID', value: 'container_id' }
    ];

    // Handle input change for Serial Number
    handleInputChange(event) {
        this.serialNumber = event.target.value;
    }

    // Handle change for ID Type dropdown
    handleIdTypeChange(event) {
        this.idType = event.target.value;
    }

    // Handle Claim Device button click
    handleClaimDevice() {
        // You can add logic here to validate, save, or call an Apex method

        // Simulate the success of the claim device process
        if (this.serialNumber && this.idType) {
            this.isClaimed = true;
            // Optionally, reset the form after successful submission
            this.resetForm();
        } else {
            this.isClaimed = false;
            // Optionally, you could add an error message or some validation here
            alert('Please fill in all required fields.');
        }
    }

    // Reset the form fields
    resetForm() {
        this.serialNumber = '';
        this.idType = '';
    }
}