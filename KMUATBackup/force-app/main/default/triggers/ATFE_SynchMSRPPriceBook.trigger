trigger ATFE_SynchMSRPPriceBook on OpportunityLineItem (after insert) {
       
    User currentUser = [select Profile.Name, Price_Book_Region__c from User where id = :userinfo.getUserId()];
   // check if the current user has the "NA" or "EMEA" price book region
    Boolean hasValidRegion = ATFE_Utility.validateUserPriceBookRegion(currentUser, new Set<String>{'NA', 'EMEA','APAC'});
    
    if (hasValidRegion) {
      
      ID oliID;
    
      //System.debug('Entering into ATFE_AddMSRPPriceBook : '+userInfo.getUserName());
      Set<Id> priceBookEntryId = new Set<id>();
      Set<Id> priceBookIds = new Set<id>();
      List<OpportunityLineItem> oliToUpdate = new List<OpportunityLineItem>();
      Map<String,String> prodCodeMap = new Map<String,String>();
      Map<String,Decimal> stdPriceMap = new Map<String,Decimal>();
      
    for(OpportunityLineItem oli : trigger.new){
        priceBookEntryId.add(oli.PricebookEntryId); 
        priceBookIds.add(oli.MSRP_Pricebook_ID__c) ;        
      }
      //System.debug('priceBookEntryId:'+priceBookEntryId);
      List<PricebookEntry> objprbooks = [select UnitPrice,Pricebook2Id,product2.Name,Product2Id, product2.ProductCode,CurrencyIsoCode from PricebookEntry
           where id in :priceBookEntryId ];
      for(PricebookEntry objprbook :objprbooks ){
             prodCodeMap.put(objprbook.product2.ProductCode,objprbook.CurrencyIsoCode);
      }
    //System.debug('prodCodeMap:'+prodCodeMap);
    List<PricebookEntry> stdPbs = [select UnitPrice,Pricebook2Id,product2.Name, product2.ProductCode from PricebookEntry where
           Pricebook2.id IN :priceBookIds and product2.ProductCode in :prodCodeMap.keySet() and CurrencyIsoCode in :prodCodeMap.values() 
            and isActive = true ];
      for(PricebookEntry stdPb : stdPbs ){
              stdPriceMap.put(stdPb.product2.ProductCode,stdPb.UnitPrice);
    } 
        //System.debug('stdPriceMap:'+stdPriceMap);  
        List<OpportunityLineItem> olis = [select id,ATFE_MSRP__c,PricebookEntry.ProductCode from OpportunityLineItem where id in :trigger.new];
       for(OpportunityLineItem oli : olis){
      //System.debug('PricebookEntry.ProductCode:'+oli.PricebookEntry.ProductCode);
          if(stdPriceMap.containsKey(oli.PricebookEntry.ProductCode) && stdPriceMap.get(oli.PricebookEntry.ProductCode) != null)
            oliToUpdate.add(new OpportunityLineItem( id = oli.id , ATFE_MSRP__c = stdPriceMap.get(oli.PricebookEntry.ProductCode)));
      }
      if(oliToUpdate != null && oliToUpdate.size() > 0){
      try {
            update oliToUpdate ;
          } catch(Exception e){
            System.debug('Exception occured while upating qlis :'+e.getMessage());
          }
      }
  }
}