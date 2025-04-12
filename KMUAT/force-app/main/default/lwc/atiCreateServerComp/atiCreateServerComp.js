import { LightningElement, track } from 'lwc';

export default class AtiCreateServer extends LightningElement {
    @track licenseServerId = '';
    @track idType = '';
    @track deviceDescription = '';

    // Options for the ID Type picklist
    idTypeOptions = [
        { label: 'ETHERNET', value: 'ETHERNET' },
        { label: 'FLEXID_9', value: 'FLEXID_9' },
        { label: 'FLEXID_10', value: 'FLEXID_10' },
        { label: 'USER', value: 'USER' },
        { label: 'VM_UUID', value: 'VM_UUID' },
        { label: 'TOLERANT', value: 'TOLERANT' },
        { label: 'EXTENDED', value: 'EXTENDED' },
        { label: 'PUBLISHER_DEFINED', value: 'PUBLISHER_DEFINED' },
        { label: 'CONTAINER_ID', value: 'CONTAINER_ID' }
    ];

    // Handle input changes
    handleInputChange(event) {
        const field = event.target.dataset.field;
        this[field] = event.target.value;
    }

    // Handle Create Server button click
    handleCreateServer() {
        if (!this.licenseServerId) {
            // Show error if License Server ID is not provided
            alert('License Server ID is required.');
            return;
        }

        // Server creation logic
        const serverData = {
            licenseServerId: this.licenseServerId,
            idType: this.idType,
            deviceDescription: this.deviceDescription
        };

        console.log('Server Created:', serverData);
        alert('Server Created Successfully!');
    }
}