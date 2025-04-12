public with sharing class ATFE_Services {
	List<productWrapper> lstServices;
    public List<productWrapper> SelectedServices{get;set;}
    public List<QuoteLineItem> lineItems{get;set;}
    Set<ID> PricebookEntryIds = new Set<ID>();
    Set<ID> setProducts = new Set<ID>();
    public String expression {get;set;}
    public String searchExpr{get;set;}
    public String searchValue{get;set;}
    public List<ProductWrapper> services {get;set;}
    public Integer prodQuantity {get;set;}
    public String lineItemDesc {get;set;}
    public Id quoteID {get;set;}
    String qliItems = '';
   
    public pageReference GetProductDetails(){
        services = new List<ProductWrapper>();
        qliItems = Apexpages.currentpage().getparameters().get('qliItems');
        Set<String> qliIdsSet = new Set<String>();
        // List<QuoteLineItem> lstQuoteItems = new List<QuoteLineItem>();
        Map<String,Id> prodcutMap = new Map<String,id>();
        //System.debug('Quote Line Items:'+qliItems);
        
        if(qliItems != null && qliItems.length() > 0){
            for(String qliId : qliItems.split(',') ){
                qliIdsSet.add(qliId);
            }
        }
        //System.debug('qliIdsSet:'+qliIdsSet);
        for(QuoteLineItem qli : [Select QuoteId, PricebookEntry.ProductCode, PricebookEntry.Pricebook2Id,PricebookEntry.UnitPrice, 
                                        PricebookEntry.Product2Id, PricebookEntry.Name, PricebookEntryId 
                                 From QuoteLineItem 
                                 where id in: qliIdsSet]){
            //lstQuoteItems.add(qli);
            quoteID = qli.QuoteId;
            prodcutMap.put(qli.PricebookEntry.Product2Id,qli.PricebookEntry.Pricebook2Id);
        }   
        if(prodcutMap != null && prodcutMap.size() == 0){
            Apexpages.addmessage(new Apexpages.message(Apexpages.Severity.Error,'No Quote line items.'));
            return null;
        }  
        
        for(PricebookEntry pb : [SELECT IsActive, IsDeleted,UnitPrice, Id, Pricebook2Id,ProductCode, Product2Id, Name,Product2.ProductCode, 
                  Product2.Description, Product2.Family , Product2.Name FROM PricebookEntry 
                              where Pricebook2Id in :prodcutMap.values() and 
                 // Product2.RelatedProduct__c in :prodcutMap.KeySet() ]){
                          Product2Id IN (SELECT ATFE_Service_Id__c FROM ATFE_Product_Service__c WHERE ATFE_Product_Id__c IN :prodcutMap.KeySet())
        ]){
	        Services.add(new ProductWrapper(pb));
	        //System.debug('$$$' + pb);
        }
        if(services != null && services.size() == 0){
            Apexpages.addmessage(new Apexpages.message(Apexpages.Severity.Info,'No Services found ..!'));
            return null;
        }                               
        return null ;
    }

    /*
        The following method for logical Select Option
    */
    public List<SelectOption> getLogicalOptions(){
        List<SelectOption> logicalOptions = new List<SelectOption>();
        logicalOptions.add(new SelectOption('' ,'--- None ---'));
        logicalOptions.add(new SelectOption('equals' ,'equals'));
        logicalOptions.add(new SelectOption('not equal to' ,'not equal to'));
        logicalOptions.add(new SelectOption('starts with' ,'starts with'));
        logicalOptions.add(new SelectOption('contains' ,'contains'));
        logicalOptions.add(new SelectOption('does not contain' ,'does not contain'));
        logicalOptions.add(new SelectOption('less than' ,'less than'));
        logicalOptions.add(new SelectOption('greater than' ,'greater than'));
        logicalOptions.add(new SelectOption('less or equal' ,'less or equal'));
        logicalOptions.add(new SelectOption('includes' ,'includes'));
        logicalOptions.add(new SelectOption('excludes' ,'excludes'));
        logicalOptions.add(new SelectOption('within' ,'within'));
        return logicalOptions ;
        
    }
    /*
        The following method is for getting field details from the Products
    */
    public list<SelectOption> getProductFieldDetails(){
        List<SelectOption> options = new List<SelectOption>();
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get('product2').getDescribe().fields.getMap();
        options.add(new SelectOption('', '-- None --'));
        options.add(new SelectOption('', '-- None --'));
        options.add(new SelectOption('', '-- None --'));
        options.add(new SelectOption('', '-- None --')); 
        for (String fieldName: fieldMap.keySet()) {
            System.debug('fieldName:'+fieldName);
            SObjectField fieldToken = fieldMap.get(fieldName);
            DescribeFieldResult selectedField = fieldToken.getDescribe();
            options.add(new SelectOption(fieldName, selectedField.getLabel())); 
        }
        return options;    
    }
    
    public PageReference cancel() {
        //  setCon.cancel();
        return new PageReference('/' + quoteID);
    }
    
    public PageReference process() {
        SelectedServices=  new List<productWrapper>();
        for (productWrapper pw: services) {
            if (pw.checked)
                SelectedServices.add(pw); 
        }
        
        //PricebookEntry pbe = new PricebookEntry(pricebook2id = stdPb.id, product2id = p.id,unitprice=1.0,isActive=true);
        //setCon.setSelected(lstSelectedServices);
        //  return page.lineItems;
        return new Pagereference('/apex/ATFE_AddServiceQuantity');
    }
    
     public PageReference createLineItems() {
        return null;
    }
    public pageReference saveLineItem(){
        QuoteLineItem  qli ;
        List<QuoteLineItem > qliList = new List<QuoteLineItem >();
        for(productWrapper pw: SelectedServices) {
        	System.debug('$$$: ' + pw.Quantity);
        	if(pw.Quantity == null || pw.Quantity == 0) {
               	ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please enter a Quantity for all items.'));
               	return null;
           	}
            qli = new QuoteLineItem ();
            qli.QuoteId  = quoteID ;
            qli.PricebookEntryId  = pw.prod.id ;
            qli.PriceBook_Price_Amount__c = pw.prod.UnitPrice ;
            qli.UnitPrice = pw.prod.UnitPrice ;
            qli.Quantity = pw.Quantity ;      
            qliList.add(qli);
        }
        
        try {
			insert qliList ;
        }catch(exception e){
            System.debug('Exception occured :'+e.getMessage());
        }
        
		return new PageReference('/' + quoteID);
    }
      
    public class ProductWrapper {
 
        public Boolean checked{ get; set; }
        public PricebookEntry prod{ get; set;}
        public Integer Quantity {get;set;}
        public String lineItemDesc {get;set;}
     
        public ProductWrapper (){
            prod = new PricebookEntry();
            checked = false;
          
        }
        public ProductWrapper (PricebookEntry p){
            prod = p;
            checked = false;
           
        }
    }
    
    //**** CODE DUMP ****//
    /*     
    public ApexPages.StandardSetController setCon {
        get {  
            if(setCon == null) {
                List<QuoteLineItem> lstQuoteItems = [select PricebookEntryId from QuoteLineItem where QuoteID =: quoteID];
                for(QuoteLineItem item : lstQuoteItems)
                    PricebookEntryIds.add(item.PricebookEntryId);
                    if(lstQuoteItems.isEmpty()){
                        Apexpages.addmessage(new Apexpages.message(Apexpages.Severity.Error,'No Quote line items.'));
                    }{    
               
                    setCon = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT IsActive, IsDeleted,UnitPrice, Id, Pricebook2Id, 
                    ProductCode, Product2Id, Name, Product2.Description, Product2.Family , Product2.Name  
                    FROM PricebookEntry where Pricebook2Id in :PricebookEntryIds ]));
                    
                  setCon.setPageSize(20);
                }
            }
            return setCon;
        }
        set;
    }
    */
	  /*
	    SELECT IsActive, IsDeleted,UnitPrice, Id, Pricebook2Id,
	    ProductCode, Product2Id, Name, Product2.Description, Product2.Family , Product2.Name
	    FROM PricebookEntry where Pricebook2Id in :PricebookEntryIds and Product2.RelatedProduct__c = “AT-210TS-05D” ( Quote line item Product )
	    
	    Select Id, Name, Pricebook2Id, Product2Id, CurrencyIsoCode, UnitPrice, IsActive, UseStandardPrice, ProductCode, IsDeleted FROM PricebookEntry 
	    where IsActive = true and Pricebook2Id in ('01s200000001sBL') and Product2.RelatedProduct__c in ('01t20000001lOFJ')
	    */
	    
	    //System.debug('PricebookEntryIds:'+prodcutMap.keySet());
	    //System.debug('PricebookEntryIds:'+prodcutMap.values());  
		/*    
	    for(PricebookEntry pb : [SELECT IsActive, IsDeleted,UnitPrice, Id, Pricebook2Id,ProductCode, Product2Id, Name,Product2.ProductCode, 
	                                    Product2.Description, Product2.Family , Product2.Name FROM PricebookEntry 
	                             where Pricebook2Id in :prodcutMap.values() 
	                             and Product2.RelatedProduct__c in :prodcutMap.keySet()]){
	        services.add(new ProductWrapper(pb));      
	    */
    /*
    The following method is used for searching results
    
    public pageReference SearchResults(){
        
        System.debug('Entering into search :expression :'+expression);
        System.debug('Entering into search :searchExpr:'+searchExpr);
        String query = 'SELECT id,Name,ProductCode,Description,Family FROM Product2 where family = \'Service\' and isActive = true and  ';
        if(expression != null && expression.contains('contains')
            //query =  query + searchExpr + ' like %'+searchValue+'%' ;
        System.debug('Query :'+query);                                    
        if(searchExpr != null && expression != null ){
            if(searchValue!= null && searchValue.length() > 0){
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(query));
                   
            }
        }
    
    return null ;
    }
    // Initialize setCon and return a list of records 
    
    public List<ProductWrapper> getServices() {
        lstServices = new List<ProductWrapper>();
        for(PricebookEntry service : (List<PricebookEntry>)setCon.getRecords())
            lstServices.add(new ProductWrapper(service));
        return lstServices;
    }
       
    public boolean getHasnext() {
        return setCon.getHasNext();
    }
    
    public boolean getHasPrevious() {
        return setCon.getHasPrevious();
    }
    
    public void Previous() {
        if(setCon.getHasPrevious())
            setCon.Previous();
    }
    
     public void Next() {
        if(setCon.getHasNext())
            setCon.next();
    }*/
}