import { LightningElement, track,api } from 'lwc';
import getRecords from '@salesforce/apex/DataTableWrapperController.getRecords';
import getFieldDetails from '@salesforce/apex/DataTableWrapperController.getFieldDetails';

export default class AtiDataTable extends LightningElement {

    @api objectName='';
    @api fieldsToQuery='';
    @api filter='';
    @track recordsPerPage = '10';
    @track disableSort = false;
    @track disableSearch = false;


    @track objectNameToSend;
    @track fieldNamesToSend;
    @track filtersToSend;
    @track recordsPerPageToSend;
    @track disableSortToSend;
    @track disableSearchToSend;

    @track searchTerm = '';
    @track sortBy = 'relevance';
//Sort Options
    get sortOptions() {
        return [
            { label: 'Relevance', value: 'relevance' },
            { label: 'Date', value: 'date' }
        ];
    }

    
    handleSortbyChange(event) {
        console.log(event.target.value);
        this.sortBy = event.target.value;
    }

    handleFilterChange(event) {
        this.filter = event.target.value;
    }
    

     connectedCallback() {
       this.objectNameToSend = this.objectName;
        this.fieldNamesToSend = this.fieldsToQuery;
        this.filtersToSend = this.filter;
        this.recordsPerPageToSend = this.recordsPerPage;
        this.disableSortToSend = this.disableSort;
        this.disableSearchToSend = this.disableSearch;
     }
     handleSearch(event) { 
        this.objectNameToSend = this.objectName;
        this.fieldNamesToSend = this.fieldsToQuery;
        this.filtersToSend = "ProductCode like '%"+this.filter+"%'";
        //this.filtersToSend = this.filter;
        this.recordsPerPageToSend = this.recordsPerPage;
        this.disableSortToSend = this.disableSort;
        this.disableSearchToSend = this.disableSearch;
        console.log(this.objectNameToSend + '<br/>' + this.fieldNamesToSend + '<br/>' + this.filtersToSend + '<br/>' + this.recordsPerPageToSend + '<br/>' + this.disableSortToSend + '<br/>' + this.disableSearchToSend );
    }

   
     getRowActions( row, doneCallback ) {
         const actions = [];
         actions.push( {
             'label': 'View',
             'name': 'view'
         } );
         setTimeout( () => {
             doneCallback( actions );
         }, 200 );
 
     }  

}