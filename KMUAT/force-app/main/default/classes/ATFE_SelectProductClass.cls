public with sharing class ATFE_SelectProductClass {
    //private final User u; //User sobject
    private final OpportunityLineItem  oppLI;
    public String pricebook {
        get {
            if (System.currentPageReference().getParameters().get('pricebook') == null){
                //pricebook = '01s200000001sBQ';
            }
            else {
                pricebook = System.currentPageReference().getParameters().get('pricebook');             
            }
                return pricebook;
        } 
        
        set;
    }
    
    public Id oppID {
        get {
            if (System.currentPageReference().getParameters().get('oppID') == null){
                //oppID = '006P0000001wIxD';
            }
            else {
                oppID = System.currentPageReference().getParameters().get('oppID');             
            }
                return oppID;
        } 
        
        set;
    }
    
    public List<ATFE_SelectProductWrapper> selectedProducts {
        get {
            if (selectedProducts == null) selectedProducts = new List<ATFE_SelectProductWrapper>();
            return selectedProducts;
        }
        set;
    }     
 
    public String searchText { get; set; }
    public Double productQuanity { get; set; }
    public List<ATFE_SelectProductWrapper> dataList {get;set;}
    
    
    //initializes the private member variable u by using the getRecord method from the standard controller Child_Product_Line_Item__c
    public ATFE_SelectProductClass(ApexPages.StandardController stdController) {
        this.oppLI = (OpportunityLineItem )stdController.getRecord();
    }
    
    public ATFE_SelectProductClass(){}
    
    //builds a picklist of user names based on their profile
    public List<selectOption> getProducts() {
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        
        options.add(new selectOption('', '- None -')); //add the first option of '- None -' in case the user doesn't want to select a value or in case no values are returned from query below
        
        //for (User users : [SELECT Id, Name FROM User WHERE Profile.Name = :username]) { //query for User records with System Admin profile
        //  options.add(new selectOption(users.Id, users.Name)); //for all records found - add them to the picklist options
        //}
        
        for (PricebookEntry pb : [SELECT IsActive, CreatedById, CreatedDate, IsDeleted, LastModifiedById, LastModifiedDate, 
                UnitPrice, Id, Pricebook2Id, ProductCode, Product2Id, Name, SystemModstamp, UseStandardPrice 
                FROM PricebookEntry where Pricebook2Id = :pricebook]) {
            options.add(new selectOption(pb.Id, pb.Name));  
        }
        
        return options; //return the picklist options
    }
    
    public List<PricebookEntry> getProductData() {
        List<PricebookEntry> pbEntry = new List<PricebookEntry>();
        Boolean selected = false;
        pbEntry = [SELECT IsActive, CreatedById, CreatedDate, IsDeleted, LastModifiedById, LastModifiedDate, 
                UnitPrice, Id, Pricebook2Id, ProductCode, Product2Id, Name, Product2.Description, Product2.Family 
                FROM PricebookEntry where Pricebook2Id = :pricebook LIMIT 100]; 
        return pbEntry;
    }
    
    public PageReference search(){
        //List<PricebookEntry> pbEntry = new List<PricebookEntry>();
        //Boolean selected = false;
        if (dataList == null) {
            dataList = new List<ATFE_SelectProductWrapper>(); // init the list if it is null
        } else {
            dataList.clear(); // clear out the current results if they exist
        }   
        
        String qry = 'SELECT IsActive, CreatedById, CreatedDate, IsDeleted, LastModifiedById, LastModifiedDate, UnitPrice, Id, Pricebook2Id, ProductCode, Product2Id, Name, Product2.Description, Product2.Family FROM PricebookEntry where IsActive = true and Pricebook2Id = \'' + pricebook + '\' and Name like \'%' + searchText + '%\'';
        system.debug('qry: ' + qry);
        for(PricebookEntry p : Database.query(qry)) { 
            dataList.add(new ATFE_SelectProductWrapper(p));
        }
        return null;
    }
    
    public PageReference next() { 
        // clear out the currently selected categories
        selectedProducts.clear();
 
        // add the selected categories to a new List
        for (ATFE_SelectProductWrapper pd : dataList) {
            if (pd.selected)
                selectedProducts.add(new ATFE_SelectProductWrapper(pd.pbe));
        }
 
        // ensure they selected at least one category or show an error message.
        if (selectedProducts.size() > 0) {            
            return Page.ATFE_SelectProductDetail;//return null;
        } else {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select at least one product.'));
            return null;
        } 
    }       
 
    // fired when the back button is clicked
    public PageReference back() {
        return null; //Page.ATFE_SelectProduct;
    }
    
    public PageReference save(){
        //system.debug('selectedProducts: ' + selectedProducts);
        for (ATFE_SelectProductWrapper pd : selectedProducts) {          
            OpportunityLineItem oli2 = new OpportunityLineItem();
            system.debug('oppID: ' + oppID);
            
            //Opportunity opp3 = new Opportunity(Id = oppID);
            
            oli2.Quantity = productQuanity;
            oli2.UnitPrice = pd.pbe.UnitPrice;
            oli2.PricebookEntryId = pd.pbe.Id;
            //oli2.OpportunityId = opp3.Id;  
            oli2.OpportunityId = oppID;  
            
            insert oli2;
            
        }
        //Opportunity opportunity = new Opportunity(Id = oppID);

        //PageReference opportunityPage = new ApexPages.StandardController(opportunity).view();
        PageReference opportunityPage = new PageReference('/' + oppID);
        opportunityPage.setRedirect(true);
        return opportunityPage;
        //return null;
    }       
    
}