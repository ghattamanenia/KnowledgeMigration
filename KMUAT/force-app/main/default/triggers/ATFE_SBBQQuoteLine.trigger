trigger ATFE_SBBQQuoteLine on SBQQ__QuoteLine__c (after insert , before update /*,after update*/, before delete) {

    if(ATFE_PLMUpdateOnQuickQuoteHelper.DoNotRunATFE_SBBQQuoteLineTrigger)
        return;
   
    Set<Id> quoteIds = new Set<id>();
    Set<Id> qliIds = new Set<id>();
          
 
     if(trigger.isUpdate){
      
          for(SBQQ__QuoteLine__c qli : trigger.new){
                //if(qli.ATFE_Discount__c <> trigger.oldMap.get(qli.Id).ATFE_Discount__c)
                    quoteIds.add(qli.ATFE_QuoteId__c);
        }
      }
   
       if(!trigger.isDelete){
   
            System.debug('quoteIds:'+quoteIds);
        // Adding code for populating PLM on Quote
            if(quoteIds != null && quoteIds.size() > 0)
                ATFE_PLMUpdateOnQuickQuoteHelper.updateQuickQuotePLMOnInsert(quoteIds);
      }
      
      
      
      
      
        if(trigger.isDelete){
        
            for(SBQQ__QuoteLine__c qli : Trigger.old){
                    qliIds.add(qli.id);
                    quoteIds.add(qli.ATFE_QuoteId__c);
            }
                System.debug('quoteIds:'+quoteIds);
            // Adding code for populating PLM on Quote
            if(quoteIds != null && quoteIds.size() > 0){
                System.debug(':::::::::::ATFE_PLMUpdateOnQuoteHelper:::::::::::::'+quoteIds);
                ATFE_PLMUpdateOnQuickQuoteHelper.updateQuickQuotePLMAysncOnDelete(quoteIds,qliIds);  
                
                }
    
        }
        
   
    
}