trigger ATFE_QuickQuoteObject on SBQQ__Quote__c (after insert, after update) {

      
        system.debug('#################ATFE_QuickQuoteObject ::: Start ##############');
        if(Clone_QuickQuoteHelper.recurssion){
         system.debug('#################ATFE_QuickQuoteObject ::: returning already done ##############');
            return;
        }
            
        Clone_QuickQuoteHelper.recurssion = true;
        if (Trigger.isAfter && Trigger.isInsert ) 
        {  
                 system.debug('#################Clone_QuickQuoteHelper.OriginalQuoteClone ::: isinsert ############## ->' );                            
                Clone_QuickQuoteHelper.OriginalQuoteClone(trigger.new); 
        }
        
        system.debug('#################ATFE_QuickQuoteObject ::: End ##############');
   
}