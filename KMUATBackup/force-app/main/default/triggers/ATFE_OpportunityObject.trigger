trigger ATFE_OpportunityObject on Opportunity (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    User currentUser = [select Profile.Name, Price_Book_Region__c from User where id = :userinfo.getUserId()];
    //check if the current user has the "NA" or "EMEA" price book region
    Boolean hasValidRegion = ATFE_Utility.validateUserPriceBookRegion(currentUser, new Set<String>{'NA', 'EMEA','APAC'});
        
    if (hasValidRegion) {

        if (Trigger.isBefore) {
            
            if (Trigger.isInsert) {
                new ATFE_ValidateOpportunityCreator(Trigger.New);//this trigger checks whether the user creating an oppty is the related account owner or part of the account team, and throws an error if not 
                //The following method is updting approval hirarchy based upon region
              //  ATFE_OpportunityManager.UpdateApprovalHirarchy(Trigger.New);
                
            }
            if (Trigger.isUpdate) {
           //     ATFE_OpportunityManager.UpdateApprovalHirarchy(Trigger.New); 
                
                ATFE_OpportunityManager.UpdateRecordType(Trigger.New); 
                
           //     ATFE_OpportunityManager.ProductValidation (Trigger.New); 
                        
            }
            if (Trigger.isDelete) {
                
            }
        }
            
        if (Trigger.isAfter) {
            if (Trigger.isInsert) {
                
            }
            if (Trigger.isUpdate) {
            
            }
            if (Trigger.isDelete) {
                
            }
        }
    }
 }