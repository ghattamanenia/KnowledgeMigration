import { LightningElement, track, api } from 'lwc';
import fetchSoftwareFileAllocations from '@salesforce/apex/PSPortalPageController.fetchSoftwareFileAllocations';

const COLS = [{"label":"Description","fieldName":"Name_URL","sortable":true,"type":"url","typeAttributes":{"label":{"fieldName":"Name"}}},{"label":"Version","fieldName":"Version__c","sortable":true},{"label":"Effective Date","fieldName":"Effective_Date__c","type":"date","sortable":true}];

const AVL_NOT_FOUND_MSG = 'There are no current products available at this time';
const ARCH_NOT_FOUND_MSG = 'There are no archived products available at this time';

export default class ProductSeriesPortalDetailPage extends LightningElement {
    @api recordId;

    @track availableData;
    @track archivedData;
    @track columns = COLS;
    @track sortBy = 'Version__c';
    @track sortDirection= 'desc';

    noAvlDataFound = false;
    noArchDataFound = false;
    avlNoDataFoundMsg = AVL_NOT_FOUND_MSG;
    archNoDataFoundMsg = ARCH_NOT_FOUND_MSG;

    connectedCallback(){
        fetchSoftwareFileAllocations({
            productSeriesId: this.recordId
        }).then(result => {
            if(result){
                let available = [];
                let archived = [];
                result.forEach(eachRecord =>{
                    eachRecord.Name = eachRecord.Software__r.Name;
                    eachRecord.Name_URL = '/detail/' + eachRecord.Software__c;
                    eachRecord.Effective_Date__c = eachRecord.Firmware__r.Effective_Date__c;
                    eachRecord.Uploaded_File_URL__c = eachRecord.Software__r.Uploaded_File_URL__c;
                    eachRecord.Version__c = eachRecord.Firmware__r.Version__c;
                    eachRecord.URL_Label = 'Download Log';
                    if(eachRecord.Firmware__r.Availability__c == 'Currently Available'){
                        available.push(eachRecord);
                    } else{
                        archived.push(eachRecord);
                    }
                });
                this.availableData = available;
                this.archivedData = archived;

                this.noAvlDataFound = this.availableData.length > 0 ? false : true;
                this.noArchDataFound = this.archivedData.length > 0 ? false : true;

                this.doDefaultSort();
            }
        }).catch(error => {

        });
    }

    doDefaultSort(){
        let evtAvl = {
            target : { dataset : { id: 'Current'}},
            detail : { fieldName : this.sortBy, sortDirection : this.sortDirection},
        }
        this.doSorting(evtAvl);

        let evtArch = {
            target : { dataset : { id: 'Archived'}},
            detail : { fieldName : this.sortBy, sortDirection : this.sortDirection},
        }
        this.doSorting(evtArch);
    }

    doSorting(event) {
        let table = event.target.dataset.id;
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortBy, this.sortDirection, table);
    }

    sortData(fieldname, direction, table) {
        this.columns.forEach(eachCol =>{
            if(eachCol.type == 'url' && eachCol.fieldName == fieldname){
                fieldname = eachCol.typeAttributes.label.fieldName;
            }
        });
        let parseData = table == 'Current' ? JSON.parse(JSON.stringify(this.availableData)) : JSON.parse(JSON.stringify(this.archivedData));
        let keyValue = (a) => {
            return a[fieldname];
        };
        let isReverse = direction === 'asc' ? 1: -1;
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : '';
            y = keyValue(y) ? keyValue(y) : '';
            x = (x && typeof x == 'string') ? x.toUpperCase() : x;
            y = (y && typeof y == 'string') ? y.toUpperCase() : x;
            return isReverse * ((x > y) - (y > x));
        });
        if(table == 'Current'){
            this.availableData = parseData;
        } else{
            this.archivedData = parseData;
        }
    }    

}