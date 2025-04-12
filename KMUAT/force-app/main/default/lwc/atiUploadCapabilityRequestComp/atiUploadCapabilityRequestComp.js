import { LightningElement, api } from 'lwc';

export default class atiUploadCapabilityRequestComp extends LightningElement {
    @api recordId;  // The Salesforce record ID to associate the files with (like Account, Opportunity, etc.)
    acceptedFormats = ['.pdf', '.png', '.jpg', '.jpeg', '.docx', '.xlsx'];  // File types that are allowed to upload
    choosefile = [];  // Array to store details of uploaded files

    // This handler is triggered once the file upload is finished
    handleUploadFinished(event) {
        const choosefile = event.detail.files;
        this.choosefile = choosefile;
    }
        // Handler for button click
    handleButtonClick() {
        // Add your button click logic here
        console.log('Button clicked');
        console.log('Checkbox state on save:', this.isChecked);  // Log checkbox state on button click
        
        // Example: Call a method, update a field, etc.
        if (this.isChecked) {
            alert('Success');
        } else {
            alert('Error');
        }
    }
}