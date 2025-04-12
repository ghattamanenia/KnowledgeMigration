trigger ATFE_AddMSRPPriceBook on QuoteLineItem (after insert , before update ,after update, before delete) {

    //User u = [select Profile.Name , Price_Book_Region__c from User where id = :userinfo.getUserId()];
    //if(u.Price_Book_Region__c=='NA' || u.Price_Book_Region__c=='EMEA' || u.Profile.Name == 'System Administrator'){   
    //user Obj = [select id,Price_Book_Region__c ,Profile.Name from User where id =: userInfo.getUserID()];
    //String userRegion = Obj.Price_Book_Region__c ;
    //userRegion = userRegion.toLowerCase();
    //if( userRegion.contains('na') || userRegion.contains('emea') || Obj.Profile.Name == 'System Administrator'){
       
    User currentUser = [select Profile.Name, Price_Book_Region__c from User where id = :userinfo.getUserId()];
    //check if the current user has the "NA" or "EMEA" price book region
    Boolean hasValidRegion = ATFE_Utility.validateUserPriceBookRegion(currentUser, new Set<String>{'NA', 'EMEA'});
    Set<Id> quoteIds = new Set<id>();
       Set<Id> qliIds = new Set<id>();
    
    if (hasValidRegion ) {
       
      if(trigger.isInsert) {
          System.debug('Entering into ATFE_AddMSRPPriceBook : '+userInfo.getUserName());
        ID QutID;
        Set<Id> priceBookEntryId = new Set<id>();
        List<QuoteLineItem> qliToUpdate = new List<QuoteLineItem>();
        Map<String,String> prodCodeMap = new Map<String,String>();
        Map<String,Decimal> stdPriceMap = new Map<String,Decimal>();
        
        for(QuoteLineItem qli : trigger.new){
            priceBookEntryId.add(qli.PricebookEntryId);   
            quoteIds.add(qli.quoteId);
        }
        System.debug('priceBookEntryId:'+priceBookEntryId);
        for(PricebookEntry objprbook : [select UnitPrice,Pricebook2Id,product2.Name,Product2Id, product2.ProductCode,CurrencyIsoCode 
                                        from PricebookEntry
                                        where id in :priceBookEntryId]){
            prodCodeMap.put(objprbook.product2.ProductCode,objprbook.CurrencyIsoCode);
        }
        System.debug('prodCodeMap:'+prodCodeMap);
        for(PricebookEntry stdPb : [select UnitPrice,Pricebook2Id,product2.Name, product2.ProductCode 
                                    from PricebookEntry 
                                    where Pricebook2.id = '01s20000000HSJz' 
                                    and product2.ProductCode in :prodCodeMap.keySet() 
                                    and CurrencyIsoCode in :prodCodeMap.values() 
                                    and isActive = true 
                                    and (Product2.ATFE_NA__c=true Or Product2.ATFE_EMEA__c=true)]){
            stdPriceMap.put(stdPb.product2.ProductCode,stdPb.UnitPrice);
        } 
        System.debug('stdPriceMap:'+stdPriceMap);    
        for(QuoteLineItem qli : [select id,ATFE_MSRP__c,PricebookEntry.ProductCode 
                                 from QuoteLineItem 
                                 where id in :trigger.new]){
            System.debug('PricebookEntry.ProductCode:'+qli.PricebookEntry.ProductCode);
            if(stdPriceMap.containsKey(qli.PricebookEntry.ProductCode) && stdPriceMap.get(qli.PricebookEntry.ProductCode) != null)
                qliToUpdate.add(new QuoteLineItem(id = qli.id, ATFE_MSRP__c = stdPriceMap.get(qli.PricebookEntry.ProductCode)));
        }
        if(qliToUpdate != null && qliToUpdate.size() > 0){
            try {
                update qliToUpdate ;
            }
            catch(Exception e){
                System.debug('Exception occured while upating qlis :'+e.getMessage());
            }
        }
            
      }
      if(trigger.isUpdate){
          for(QuoteLineItem qli : trigger.new){
                //if(qli.ATFE_Discount__c <> trigger.oldMap.get(qli.Id).ATFE_Discount__c)
                    quoteIds.add(qli.quoteId);
        }
      }
      if(!trigger.isDelete){
            System.debug('quoteIds:'+quoteIds);
        // Adding code for populating PLM on Quote
            if(quoteIds != null && quoteIds.size() > 0)
                ATFE_PLMUpdateOnQuoteHelper.updatePLMOnInsert(quoteIds);
      }
 
        if(trigger.isDelete){
            for(QuoteLineItem qli : Trigger.old){
                    qliIds.add(qli.id);
                    quoteIds.add(qli.quoteId);
            }
                System.debug('quoteIds:'+quoteIds);
            // Adding code for populating PLM on Quote
            if(quoteIds != null && quoteIds.size() > 0)
                ATFE_PLMUpdateOnQuoteHelper.updatePLMAysncOnDelete(quoteIds,qliIds);  
    
        }
        
    }
    
}