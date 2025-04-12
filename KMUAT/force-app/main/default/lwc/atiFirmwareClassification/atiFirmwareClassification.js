import { LightningElement, api, wire, track } from 'lwc';
import getFirmwareRecords from '@salesforce/apex/FirmwareClassificationController.getFirmwareRecords';
import getAssociatedSoftware from '@salesforce/apex/FirmwareClassificationController.getAssociatedSoftware';
import { NavigationMixin } from 'lightning/navigation';
import { CurrentPageReference } from 'lightning/navigation';

export default class AtiFirmwareClassification extends NavigationMixin(LightningElement) {
    @api recordId; // Catalog__c record ID
    currentFirmware = [];
    archivedFirmware = [];
    error;

    @wire(CurrentPageReference)
    getCurrentPageReference(currentPageRef) {
        if (currentPageRef) {
            // Check for recordId directly in CurrentPageReference attributes
            const urlPath = currentPageRef.attributes?.recordId || currentPageRef.attributes?.url || window.location.href;
            this.recordId = this.extractRecordId(urlPath);
            console.log('Extracted Record ID:', this.recordId);
        }
    }

    extractRecordId(urlPath) {
        // Regular expression to find Salesforce record IDs (15 or 18 characters)
        const recordIdPattern = /[a-zA-Z0-9]{15,18}/;

        // Match the first occurrence of the pattern in the URL
        const match = urlPath.match(recordIdPattern);

        return match ? match[0] : null; // Return the matched record ID or null
    }

    @wire(getFirmwareRecords, { catalogRecordId: '$recordId' })
    wiredFirmware({ data, error }) {
        if (data) {
            this.currentFirmware = [];
            this.archivedFirmware = [];

            data.forEach(item => {
                if (item.Firmware__r) {
                    const firmwareRecord = {
                        ...item.Firmware__r,
                        isExpanded: false, // Default not expanded
                        software: [], // Placeholder for associated software records
                        iconName: 'utility:add', // Default expand icon (+)
                        iconTitle: 'Expand' // Default title for expand
                    };

                    if (item.Firmware__r.Availability__c === 'Currently Available') {
                        this.currentFirmware.push(firmwareRecord);
                         console.log('**iconName'+firmwareRecord);
                    } else if (item.Firmware__r.Availability__c === 'Archived') {
                        this.archivedFirmware.push(firmwareRecord);
                    }
                }
            });

            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.currentFirmware = [];
            this.archivedFirmware = [];
        }
    }

    handleFirmwareClick(event) {
        const firmwareId = event.currentTarget.dataset.id;
    
        // Find the firmware record
        const allFirmware = [...this.currentFirmware, ...this.archivedFirmware];
        const firmwareRecord = allFirmware.find(fw => fw.Id === firmwareId);
    
        if (firmwareRecord) {
            // Toggle expanded state
            firmwareRecord.isExpanded = !firmwareRecord.isExpanded;
    
            // Update the icon and title based on expanded state
            firmwareRecord.iconName = firmwareRecord.isExpanded ? 'utility:dash' : 'utility:add';
            firmwareRecord.iconTitle = firmwareRecord.isExpanded ? 'Collapse' : 'Expand';
    
            // Fetch associated software records if expanded and not already loaded
            if (firmwareRecord.isExpanded && firmwareRecord.software.length === 0) {
                getAssociatedSoftware({ firmwareId })
                    .then(data => {
                        firmwareRecord.software = data;
    
                        // Refresh lists to trigger reactivity
                        this.refreshFirmwareLists();
                    })
                    .catch(error => {
                        console.error('Error fetching software records:', error);
                    });
            } else {
                // Refresh lists to reflect icon changes
                this.refreshFirmwareLists();
            }
        }
    }
    
    refreshFirmwareLists() {
        // Trigger UI reactivity by reassigning arrays
        this.currentFirmware = [...this.currentFirmware];
        this.archivedFirmware = [...this.archivedFirmware];
    }
    

    refreshFirmwareLists() {
        // Refresh firmware lists to trigger reactivity
        this.currentFirmware = [...this.currentFirmware];
        this.archivedFirmware = [...this.archivedFirmware];
    }

    handleSoftwareClick(event) {
        const softwareId = event.currentTarget.dataset.id;
        // Use NavigationMixin to navigate to the Software record page
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: softwareId,
                actionName: 'view',
            },
        });
    }
}