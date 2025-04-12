trigger ATFE_OpportunityAmountEditable on Opportunity (before update) {

    /* this trigger is for to  make amount field editable only if the user's pricebook region is "NA" or "EMEA" and Probability is 25
       nor for any other values  after saving the record .
       Note : Here amount is formula field 
    */
    /*
    list<RecordType> lstRecord = [Select r.SobjectType, r.Name, r.IsActive, r.Id From RecordType r where r.IsActive = true AND r.SobjectType = 'Opportunity' AND r.Id = '01220000000AIqz'];
    User currentUser = [select Profile.Name, Price_Book_Region__c from User where id = :userinfo.getUserId()];
    //check if the current user has the "NA" or "EMEA" price book region
    Boolean hasValidRegion = ATFE_Utility.validateUserPriceBookRegion(currentUser, new Set<String>{'NA', 'EMEA'});
    
    if (hasValidRegion) {
    
        //if (Trigger.isUpdate) {
        list<Opportunity> lstOpportunity = new list<Opportunity>();
        for(Opportunity o : Trigger.new){
    
            // Only if profile is NA_SalesOperations  and Probability is 25% 
            if(lstRecord != null && lstRecord.size()>0) 
            {
                system.debug('========== o.RecordType Outside : '+ o.RecordTypeId);
                system.debug('========== lstRecord[0] Outside : '+ lstRecord[0]);
                if(o.Probability == 25 && (currentUser.Profile.Name.startsWith('NA')|| currentUser.Profile.Name.startsWith('EMEA')) && o.RecordTypeId != lstRecord[0].Id && o.RecordTypeId !='012200000005ttF')//&& o.RecordType != lstRecord[0])
                {
                    //Opportunity objOpp = new Opportunity (id=o.id);
                    //objOpp.RecordTypeId =  lstRecord[0].Id;
                    //objOpp.Description = lstRecord[0].Name;
                    
                    o.RecordTypeId =  lstRecord[0].Id;
                    //o.Description = lstRecord[0].Name;
                    system.debug('========== o.RecordType Inside: '+ o.RecordTypeId);
                    system.debug('========== lstRecord[0] Inside: '+ lstRecord[0]);
                    //lstOpportunity.add(objOpp);
                 }
                 else if(o.Probability != 25 && currentUser.Profile.Name.startsWith('NA') && o.RecordTypeId == lstRecord[0].Id)
                 {
                     o.RecordTypeId = '01220000000HW6Q';
                 }
                 else if(o.Probability != 25 && currentUser.Profile.Name.startsWith('EMEA') && o.RecordTypeId == lstRecord[0].Id)
                 {
                     o.RecordTypeId = '01220000000HUnj'; 
                 }    
                
            }
        }
    }  
    
    */
}