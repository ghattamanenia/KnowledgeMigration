import { LightningElement } from 'lwc';
export default class AtiRegisterAddLicTokensComp extends LightningElement {
    // Define properties for each input field
    field1 = '';
    field2 = '';
    field3 = '';
    field4 = '';
    field5 = '';

    // Handler for input field changes
    handleInputChange(event) {
        const fieldName = event.target.dataset.id;
        this[fieldName] = event.target.value;
    }

    // Handler for submit button
    handleSubmit() {
        const inputData = {
            field1: this.field1,
            field2: this.field2,
            field3: this.field3,
            field4: this.field4,
            field5: this.field5
        };
        // Log the data to console or handle accordingly
        console.log('Submitted Data: ', inputData);
        // You can call an Apex method or process the data as needed here
    }

}