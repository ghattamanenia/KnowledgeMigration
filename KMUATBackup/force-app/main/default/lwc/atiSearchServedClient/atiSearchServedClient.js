import { LightningElement } from 'lwc';

export default class atiSearchServedClient extends LightningElement {
    serialNumber = '';            // Serial Number input value
    deviceDescription = '';       // Device Description input value
    licenseServerId = '';         // License Server ID input value
    featureName = '';             // Feature Name input value

    // Handle changes in input fields
    handleInputChange(event) {
        const field = event.target.dataset.id;
        if (field === 'serialNumber') {
            this.serialNumber = event.target.value;
        } else if (field === 'deviceDescription') {
            this.deviceDescription = event.target.value;
        } else if (field === 'licenseServerId') {
            this.licenseServerId = event.target.value;
        } else if (field === 'featureName') {
            this.featureName = event.target.value;
        }
    }

    // Handle the Filter button click
    handleFilterClick() {
        // Perform validation if needed
        if (!this.serialNumber && !this.deviceDescription && !this.licenseServerId && !this.featureName) {
            alert('Please provide at least one filter criteria.');
            return;
        }

        // Combine the data entered by the user
        const filterData = {
            serialNumber: this.serialNumber,
            deviceDescription: this.deviceDescription,
            licenseServerId: this.licenseServerId,
            featureName: this.featureName
        };

        console.log('Filter criteria:', filterData);

        // You can make an Apex call or perform another action to filter records based on this data
        // Example: Call an Apex method here to filter records
    }
}