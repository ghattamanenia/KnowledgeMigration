import { api, wire, LightningElement } from 'lwc';
import getConfig from '@salesforce/apex/S3FilesHelper.getConfig';
import getFileKey from '@salesforce/apex/S3FilesHelper.getSoftwareFile';
import AWS_SDK from '@salesforce/resourceUrl/aws';
import { loadScript } from 'lightning/platformResourceLoader';
import { CurrentPageReference } from 'lightning/navigation';

const TIMELIMIT = 60; // URL expiry in seconds

export default class AmazonS3Download extends LightningElement {
    @api recordId;
    fileKey; // File key fetched from the record
    isUserEntitled = false; // Tracks if the user is entitled
    config = {};
    AWS;
    isLoading = false; // Added to manage loading state

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
    
    async connectedCallback() {
        try {
            await loadScript(this, AWS_SDK);
            await this.initializeConfig();
            await this.fetchFileKey(); // Fetch the file key after loading AWS SDK
            this.initializeAWS();
        } catch (error) {
            console.error('Error initializing AWS SDK:', error);
        }
    }
    async initializeConfig() {
        console.log('*****'+this.recordId);
        this.config = await getConfig({ recordId: this.recordId });
    }

    async fetchFileKey() {
        try {
            const softwareFile = await getFileKey({ recordId: this.recordId });
            if (softwareFile) {
                this.isUserEntitled = true;
                this.fileKey = softwareFile.File_Key__c; // Store the File Key
                console.log('Software File Record:', softwareFile);
            } else {
                this.isUserEntitled = false;
                this.fileKey = null;
            }
            console.log('File Key:', this.fileKey);
        } catch (error) {
            console.error('Error fetching software file record:', error);
            this.isUserEntitled = false;
            this.fileKey = null;
        }
    }
    

    initializeAWS() {
        this.AWS = AWS;
        this.AWS.config.update({
            accessKeyId: this.config.accessKeyId,
            secretAccessKey: this.config.secretAccessKey,
            region: this.config.region,
        });
    }

    getFileURL(key) {
        try {
            const s3 = new this.AWS.S3();
            const params = {
                Bucket: this.config?.bucket,
                Expires: TIMELIMIT,
                Key: key
            };
            return s3.getSignedUrl('getObject', params);
        } catch (error) {
            console.error('Error getting file URL:', error);
            return null; // Return null if there's an error
        }
    }

    getFileName(fileKey) {
        const fullFileName = fileKey.split('/').pop(); // This gives you 'SF_soap_api_cheatsheet_FINAL.pdf'
        return fullFileName; 
    }



    /* this is for same like browser Downlaod */
    async handleDownload() {
        if (!this.fileKey) {
            console.error('File key is not available');
            return;
        }
    
        this.loading(); // Start loading
    
        try {
            const key = this.fileKey;
            const name = this.getFileName(this.fileKey);
            const url = this.getFileURL(key);
    
            if (!url) {
                console.error('Could not retrieve file URL');
                return;
            }
    
            // Create an anchor element and set the URL as its href attribute
            const link = document.createElement("a");
            link.href = url; // Directly assign the signed URL
            link.download = name; // Set the filename
            link.target = "_blank"; // Opens download in a new tab, allowing background download
            document.body.appendChild(link);
    
            // Trigger the download
            link.click();
    
            // Clean up
            link.remove();
        } catch (error) {
            console.error('Download error:', error);
        } finally {
            this.loading(); // Stop loading
        }
    }
    


    // This is for Spinng loading the download on the page
    // async handleDownload() {
    //     if (!this.fileKey) {
    //         console.error('File key is not available');
    //         return;
    //     }

    //     this.loading(); // Start loading

    //     try {
    //         const key = this.fileKey;
    //         const name = this.getFileName(this.fileKey);
    //         const url = this.getFileURL(key);

    //         if (!url) {
    //             console.error('Could not retrieve file URL');
    //             return;
    //         }

    //         const response = await fetch(url);
    //         if (!response.ok) {
    //             throw new Error('Network response was not ok');
    //         }

    //         const buff = await response.arrayBuffer();
    //         const blob = new Blob([buff], { type: 'application/octet-stream' });
    //         const blobUrl = URL.createObjectURL(blob);

    //         const link = document.createElement("a");
    //         link.href = blobUrl;
    //         link.download = name;
    //         document.body.appendChild(link);
    //         link.click();
    //         link.remove();
    //     } catch (error) {
    //         console.error('Download error:', error);
    //     } finally {
    //         this.loading(); // Stop loading
    //     }
    // }




    loading() {
        this.isLoading = !this.isLoading; // Toggle loading state
    }
}