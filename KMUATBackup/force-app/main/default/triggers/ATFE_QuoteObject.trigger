trigger ATFE_QuoteObject on Quote (after delete, after insert, after update, before delete, before insert, before update) {

   User currentUser = [select Profile.Name, Price_Book_Region__c from User where id = :userinfo.getUserId()];
   //check if the current user has the "NA" or "EMEA" price book region
   Boolean hasValidRegion = ATFE_Utility.validateUserPriceBookRegion(currentUser, new Set<String>{'NA', 'EMEA'});
        
    if (hasValidRegion && !ATFE_QuoteEmailHelper.byPassCode) {

        if (Trigger.isBefore) {
            
            if (Trigger.isInsert) {
                
            }
            if (Trigger.isUpdate) {
                ATFE_UpdateQuotePriceBookOnQuoteToChange uqpb = new ATFE_UpdateQuotePriceBookOnQuoteToChange(Trigger.old, Trigger.New);
                //For Sending mail once the quote is submitted for approval
                ATFE_QuoteEmailHelper.SendEmailForOppOwner(Trigger.New, Trigger.oldMap);
            }
            if (Trigger.isDelete) {
                
            }
        }
        
        if (Trigger.isAfter) {
            if (Trigger.isInsert) {
                
            }
            if (Trigger.isUpdate && !ATFE_UpdateOpportunityFromSyncedQuote.byPassCode) {
               // ATFE_UpdateOpportunityFromSyncedQuote uofsq = new ATFE_UpdateOpportunityFromSyncedQuote(Trigger.Old, Trigger.New);
            }
            if (Trigger.isDelete) {
                
            }
        }
    }
}