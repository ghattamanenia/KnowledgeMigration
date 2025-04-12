import { LightningElement, api, track } from 'lwc';

export default class RunCustomDataTable extends LightningElement {

    @api objectName;
    @api fieldsToQuery='';
    @api filter='';
    @track recordsPerPage = 10;
    @track disableSort = false;
    @track disableSearch = false;


    @track objectNameToSend;
    @track fieldNamesToSend;
    @track filtersToSend;
    @track recordsPerPageToSend;
    @track disableSortToSend;
    @track disableSearchToSend;
    rating = 'Hot';
    fromDatte;
    toDate;




    get ratingOptions() {
        return [
            { label: 'Hot', value: 'Hot' },
            { label: 'Cold', value: 'Cold' },
            { label: 'Warm', value: 'Warm' },
        ];
    }

    connectedCallback() {
        this.objectNameToSend = this.objectName;
        this.fieldNamesToSend = this.fieldsToQuery;
        this.filtersToSend = this.filter;
        this.recordsPerPageToSend = this.recordsPerPage;
        this.disableSortToSend = this.disableSort;
        this.disableSearchToSend = this.disableSearch;
    }
   

    // handleObjectNameChange(event) {
    //     this.objectName = event.target.value;
    // }

    // handleObjectFieldsChange(event) {
    //     this.fieldsToQuery = event.target.value;
    // }

    

    handleFilterChange(event) {
        this.filter = event.target.value;
    }

    handleRatingChange(event) {
        this.rating = event.detail.value;
    }

    handleFromDateChange(event) {
        this.fromDate = event.detail.value;
    }

    handleToDateChange(event) {
        this.toDate = event.detail.value;
    }

    handleRecordsPerPageChange(event) {
        this.recordsPerPage = event.target.value;
    }
    handleSortChange(event) {
        console.log(event.target.checked);
        this.disableSort = event.target.checked;
    }
    handleSearchChange(event) {
        this.disableSearch = event.target.checked;
        console.log(event.target.checked);
    }

    handleClick(event) {
        console.log('inside handleClick');
        console.log(this.objectName + '<br/>' + this.fieldsToQuery + '<br/>' + this.filtersToSend + '<br/>' + this.recordsPerPageToSend + '<br/>' + this.disableSortToSend + '<br/>' + this.disableSearchToSend );
        this.objectNameToSend = this.objectName;
        this.fieldNamesToSend = this.fieldsToQuery;
        this.filtersToSend = "Name like '%"+this.filter+"%'";
        // this.filtersToSend = this.filter;
        this.recordsPerPageToSend = this.recordsPerPage;
        this.disableSortToSend = this.disableSort;
        this.disableSearchToSend = this.disableSearch;
        console.log(this.objectNameToSend + '<br/>' + this.fieldNamesToSend + '<br/>' + this.filtersToSend + '<br/>' + this.recordsPerPageToSend + '<br/>' + this.disableSortToSend + '<br/>' + this.disableSearchToSend );
    }

}