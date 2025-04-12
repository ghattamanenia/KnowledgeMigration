import { LightningElement, api } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import AWS_SDK from '@salesforce/resourceUrl/aws';
import createSoftwareRecord from '@salesforce/apex/S3FilesHelper.createSoftwareRecord';
import getConfig from '@salesforce/apex/S3FilesHelper.getConfig';

export default class AmazonS3FetchDetails extends LightningElement {
    @api recordId;
    config = {};
    AWS;
    isLoading = false;

    connectedCallback() {
        this.initialize();
    }

    async initialize() {
        try {
            // Load AWS SDK
            await loadScript(this, AWS_SDK);
            this.config = await getConfig({ recordId: this.recordId });
            this.AWS = AWS;
            this.AWS.config.update(this.awsConfig);
        } catch (error) {
            this.showToast('Error', 'Failed to initialize AWS SDK.', 'error');
            console.error(error);
        }
    }

    get awsConfig() {
        return {
            accessKeyId: this.config?.accessKeyId,
            secretAccessKey: this.config?.secretAccessKey,
            region: this.config?.region
        };
    }

    async fetchFileDetails() {
        try {
            this.loading(true);

            const s3 = new this.AWS.S3();
            const params = {
                Prefix: this.config?.prefix,
                Bucket: this.config?.bucket,
            };

            s3.listObjects(params, async (err, data) => {
                if (err) {
                    console.error('Error fetching file details', err);
                    this.showToast('Error', 'Failed to fetch file details.', 'error');
                } else if (!data.Contents || data.Contents.length === 0) {
                    // No files found
                    this.showToast('Info', 'File not found on AWS.', 'info');
                } else {
                    const files = data.Contents.filter(item => item.Size > 0).map(item => ({
                        name: item.Key.substring(item.Key.lastIndexOf('/') + 1),
                        key: item.Key,
                        size: item.Size,
                        lastModified: item.LastModified,
                    }));

                    for (let file of files) {
                        const headParams = {
                            Bucket: this.config?.bucket,
                            Key: file.key,
                        };

                        s3.headObject(headParams, async (err, headData) => {
                            if (err) {
                                console.error('Error fetching metadata', err);
                            } else {
                                const etag = headData.ETag;
                                const createdDate = headData.LastModified.toISOString().split('T')[0];

                                // Call Apex to create/update the Salesforce record
                                await createSoftwareRecord({
                                    fileName: file.name,
                                    fileKey: file.key,
                                    fileUrl: this.getFileURL(file.key),
                                    fileSize: file.size,
                                    etag,
                                    createdDate,
                                    recId: this.recordId,
                                });
                            }
                        });
                    }

                    this.showToast('Success', 'File details have been updated.', 'success');
                }
            });
        } catch (error) {
            console.error('Error during fetch', error);
            this.showToast('Error', 'An error occurred while fetching file details.', 'error');
        } finally {
            this.loading(false);
        }
    }

    getFileURL(key) {
        try {
            const s3 = new this.AWS.S3();
            const params = {
                Bucket: this.config?.bucket,
                Expires: 60, // URL expiration in seconds
                Key: key,
            };

            return s3.getSignedUrl('getObject', params);
        } catch (error) {
            console.error('Error generating signed URL', error);
        }
    }

    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title,
                message,
                variant,
            })
        );
    }

    loading(isLoading) {
        this.isLoading = isLoading;
    }
}