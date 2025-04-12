import { LightningElement, track } from 'lwc';

export default class searchServersComp extends LightningElement {
    @track licenseServerId = '';
    @track idType = '';
    @track deviceDescription = '';
    @track rememberPassword = false;

    // Picklist options for ID Type
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
        const field = event.target.dataset.id;
        if (field === 'licenseServerId') {
            this.licenseServerId = event.target.value;
        } else if (field === 'idType') {
            this.idType = event.target.value;
        } else if (field === 'deviceDescription') {
            this.deviceDescription = event.target.value;
        }
    }

    // Handle Remember Password option
    handleRememberPassword(event) {
        this.rememberPassword = event.target.checked;
        if (this.rememberPassword) {
            console.log("Password will be remembered until logout");
        } else {
            console.log("Password will not be remembered");
        }
    }

    // Handle the Filter button click
    handleFilter() {
        console.log('License Server ID:', this.licenseServerId);
        console.log('ID Type:', this.idType);
        console.log('Device Description:', this.deviceDescription);

        if (this.rememberPassword) {
            console.log("Remember my password option is enabled");
        }
    }
}