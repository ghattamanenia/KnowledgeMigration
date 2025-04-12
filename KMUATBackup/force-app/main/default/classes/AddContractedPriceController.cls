public /*with sharing*/ class AddContractedPriceController {
    private Account account;
    private Id pricebookId;
    private Id pricebook2Id;
    public string accpricebookId {get;set;}
    
    public SBQQ__ContractedPrice__c target {get; private set;}
    public SBQQ__ContractedPrice__c template {get; private set;}
    
    public AddContractedPriceController(ApexPages.StandardController stdController) {
        template = new SBQQ__ContractedPrice__c();
        accpricebookId  = '';
        target = (SBQQ__ContractedPrice__c)stdController.getRecord();
        system.debug('Target::' + target );
        system.debug('target.SBQQ__Account__c ::' + target.SBQQ__Account__c);
         system.debug('target.id ::' + target.id);
        
        if(target.SBQQ__Account__c == null && target.Sales_Contract__c != null ){
        
         target.SBQQ__Account__c   =  [Select Accountid from Contract  where id = :target.Sales_Contract__c].Accountid ;
        }
        
        system.debug('Target::' + target );
        system.debug('target.SBQQ__Account__c ::' + target.SBQQ__Account__c);
        if ((target != null) && (target.SBQQ__Account__c != null)) {
            account = [SELECT ATFE_Price_Book__c,ATFE_Account_MRSP_PriceBook__c FROM Account WHERE Id = :target.SBQQ__Account__c];
            pricebookId = [SELECT Id FROM Pricebook2 WHERE Name = :account.ATFE_Price_Book__c].Id;
            
            pricebook2Id = [SELECT Id FROM Pricebook2 WHERE Name = :account.ATFE_Account_MRSP_PriceBook__c].Id;
            accpricebookId  = ''+pricebookId ;
        }   
    }
    
    public PageReference onCalculateListPrice() {
    
         system.debug('pricebookId ::' +pricebookId );
         system.debug('target ::' +target );
            system.debug('target.SBQQ__Product__c ::' + target.SBQQ__Product__c); 
        if ((pricebookId != null) && (target != null) && (target.SBQQ__Product__c != null)) {
            PricebookEntry[] entries = [SELECT UnitPrice,CurrencyIsoCode  FROM PricebookEntry WHERE Pricebook2Id = :pricebookId AND Product2Id = :target.SBQQ__Product__c];
              system.debug('entries ::' + entries ); 
            if (!entries.isEmpty()) {
            
          
            
                 system.debug('entries[0].UnitPrice::' + entries[0].UnitPrice); 
                template.PriceBook_Price__c = entries[0].UnitPrice;
                template.CurrencyIsoCode  = entries[0].CurrencyIsoCode;
                target.CurrencyIsoCode  = entries[0].CurrencyIsoCode;
                target.PriceBook_Price__c = entries[0].UnitPrice;
            }else{
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No Price Available'));  //Kranthi
            }
        }
        if ((pricebookId != null) && (target != null) && (target.SBQQ__Product__c != null)) {
            PricebookEntry[] entries = [SELECT UnitPrice FROM PricebookEntry WHERE Pricebook2Id = :pricebook2Id AND Product2Id = :target.SBQQ__Product__c];
              system.debug('entries ::' + entries ); 
            if (!entries.isEmpty()) {
            
          
            
                 system.debug('entries[0].UnitPrice::' + entries[0].UnitPrice); 
                target.ATFE_MSRP_Price__c = entries[0].UnitPrice;
            }
        }
        return null;
    }
    
     public PageReference onSaveMore() {
     
     List<SBQQ__ContractedPrice__c> AllRelContractPrices = new List<SBQQ__ContractedPrice__c>();
     AllRelContractPrices = [Select id,SBQQ__Product__c from SBQQ__ContractedPrice__c where Sales_Contract__c = :target.Sales_Contract__c and id != null];
     for(SBQQ__ContractedPrice__c CP : AllRelContractPrices){
         if(target.SBQQ__Product__c == CP.SBQQ__Product__c){
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Product already exist on this Sales Contract.'));  //Kranthi
              return null;
         }
     }
     
     if(target.SBQQ__Price__c == null){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You must enter Proposed Sales Price.'));  //Kranthi
          return null;
     }
     
     try{
      insert target;
      }catch(exception ex){
          //page error.
      }
       target.id = null;
       target.SBQQ__Product__c = null;
       target.PriceBook_Price__c = null; // check if causing any issue
       template.PriceBook_Price__c = null;
       target.SBQQ__Price__c = null;
      return null;
     }
     
      public PageReference onDone() {
      
     List<SBQQ__ContractedPrice__c> AllRelContractPrices = new List<SBQQ__ContractedPrice__c>();
     AllRelContractPrices = [Select id,SBQQ__Product__c from SBQQ__ContractedPrice__c where Sales_Contract__c = :target.Sales_Contract__c and id != null];
     for(SBQQ__ContractedPrice__c CP : AllRelContractPrices){
         if(target.SBQQ__Product__c == CP.SBQQ__Product__c){
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Product already exist on this Sales Contract.'));  //Kranthi
              return null;
         }
     }
     if(target.SBQQ__Price__c == null){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You must enter Proposed Sales Price.'));  //Kranthi
          return null;
     }
     
          try{
          system.debug('::target is:::' + target);
              insert target;
          }catch(exception ex){
            //  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Following exception occured while saving this record: ' + ex));  //Kranthi
           //   return null;
          }
          system.debug('#### target.Sales_Contract__c #### ' + target.Sales_Contract__c);
       return new PageReference ('/'+target.Sales_Contract__c);
      }
    
}