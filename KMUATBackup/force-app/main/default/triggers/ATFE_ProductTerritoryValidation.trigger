trigger ATFE_ProductTerritoryValidation on Opportunity (before update)
{
/*
    // This Trigger is to replace the Product & Territory Validations 
    // user Obj = [select id,Price_Book_Region__c ,Profile.Name from User where id =: userInfo.getUserID()];
    //String userRegion = Obj.Price_Book_Region__c ;
    //userRegion = userRegion.toLowerCase();
    //if( userRegion.contains('na') || userRegion.contains('emea') || Obj.Profile.Name == 'System Administrator'){
       
    User currentUser = [select Profile.Name, Price_Book_Region__c from User where id = :userinfo.getUserId()];
    //check if the current user has the "NA" or "EMEA" price book region
    Boolean hasValidRegion = ATFE_Utility.validateUserPriceBookRegion(currentUser, new Set<String>{'NA', 'EMEA'});
    
    if (hasValidRegion) {
        Id RecordTypeId = trigger.new[0].RecordTypeId;
        if(trigger.new[0].Probability>0.25 && trigger.new[0].Amount != null && trigger.new[0].Total_Quantity__c == 0 && trigger.new[0].Probability != trigger.old[0].Probability && 
        (RecordTypeId == '012200000005ttF' || RecordTypeId == '01220000000HUnj' || RecordTypeId == '01220000000HW6Q' || RecordTypeId == '01220000000AIqz' ))
        {
            trigger.new[0].addError('Product Is Required');
        }
    
        system.debug('===== Opp : '+trigger.new[0]);
    
        // if(trigger.new[0].TerritoryId == null && trigger.new[0].Amount != trigger.old[0].Amount && 
        //  (RecordTypeId == '012200000005ttF' || RecordTypeId == '01220000000HUnj' || RecordTypeId == '01220000000HW6Q' || RecordTypeId == '01220000000AIqz'))
        // {
        //     trigger.new[0].addError('Territory Is Requried');
        // }
    }  */
}