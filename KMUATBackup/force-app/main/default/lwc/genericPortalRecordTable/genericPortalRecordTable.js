import { api, LightningElement, track } from 'lwc';
import getRecordData from '@salesforce/apex/GenericPortalRecordTableController.getRecordData';

export default class GenericPortalRecordTable extends LightningElement {
    @api objectApiName;
    @api fieldsToDisplay;
    @api columnsJson;
    @api sortBy;
    @api sortDirection;

    @track data;
    @track columns;
    @track fullDataList;

    connectedCallback(){
        this.columns = JSON.parse(this.columnsJson);
        this.fetchData();
    }

    fetchData(){
        getRecordData({
            objectName: this.objectApiName,
            fields: this.fieldsToDisplay
        }).then(result => {
            if(result){
                this.data = result;
                this.fullDataList = result;
                this.processColumns();
            }
        }).catch(error => {

        });
    }

    processColumns(){
        let cols = JSON.parse(this.columnsJson);
        var self = this;
        cols.forEach(eachCol =>{
            if(eachCol.type == 'url'){
                let fieldName = eachCol.typeAttributes.label.fieldName;
                let urlFieldName = eachCol.fieldName;
                let idField = eachCol.typeAttributes.label.fieldId;
                let relationships = fieldName.split('.');
                let fieldData;
                self.data.forEach(eachRow => {
                    fieldData = eachRow;
                    relationships.forEach(eachRel => {
                        if(fieldData){
                            fieldData = fieldData[eachRel];
                        }
                    });
                    eachRow[fieldName] = fieldData ? fieldData : '';
                    eachRow[urlFieldName] = fieldData ? '/detail/' + eachRow[idField] : '';
                });
            }
        });
        this.doDefaultSort();
    }

    handleSearch(event){
        let searchedValue = event.detail.value;
        let dataToIterate;
        if (this.data && this.data.length == 0) {
            dataToIterate = JSON.parse(JSON.stringify(this.fullDataList));
        } else {
            dataToIterate = JSON.parse(JSON.stringify(this.data));
        }
        if (searchedValue && searchedValue != '') {
            let newData = [];
            dataToIterate.forEach(eachRow => {
                for(var key in eachRow){
                    if(eachRow[key] && typeof eachRow[key] == 'string' && eachRow[key].toUpperCase().includes(searchedValue.toUpperCase())){
                        newData.push(eachRow);
                        break;
                    } else if(eachRow[key] && (typeof eachRow[key] == 'boolean' || typeof eachRow[key] == 'number') && eachRow[key].toString().includes(searchedValue)){
                        newData.push(eachRow);
                        break;
                    }
                }
            });
            this.data = newData;
        }else {
            this.data = JSON.parse(JSON.stringify(this.fullDataList));
        }
    }

    doDefaultSort(){
        let evt = {
            detail : { fieldName : this.sortBy, sortDirection : this.sortDirection},
        }
        this.doSorting(evt);
    }

    doSorting(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortBy, this.sortDirection);
    }

    sortData(fieldname, direction) {
        this.columns.forEach(eachCol =>{
            if(eachCol.type == 'url' && eachCol.fieldName == fieldname){
                fieldname = eachCol.typeAttributes.label.fieldName;
            }
        });

        let parseData = JSON.parse(JSON.stringify(this.data));
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
        this.data = parseData;
    }
}