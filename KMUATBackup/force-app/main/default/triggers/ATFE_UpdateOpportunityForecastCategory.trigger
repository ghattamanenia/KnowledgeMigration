trigger ATFE_UpdateOpportunityForecastCategory on Opportunity (before insert, before update) {
       
   // User currentUser = [select Profile.Name, Price_Book_Region__c from User where id = :userinfo.getUserId()];
    //check if the current user has the "NA" or "EMEA" price book region
  //  Boolean hasValidRegion = ATFE_Utility.validateUserPriceBookRegion(currentUser, new Set<String>{'NA', 'EMEA','APAC'});
    
  //  if (hasValidRegion) {
        
        for(Opportunity o : Trigger.New){
            if((!o.ATFE_MasterOpportunity__c) && ((Trigger.isInsert && o.Previous_Forecast_Category__c != null) || (Trigger.isUpdate && Trigger.oldMap.get(o.id).ATFE_MasterOpportunity__c != o.ATFE_MasterOpportunity__c))){
                o.ForecastCategoryName = o.Previous_Forecast_Category__c;
            }
        }   
  //  } 
  
  // Below code is added by Neha Chinnachoudhary on 11th Nov 2019
  if(label.ATFE_UpdateOpportunityForecastCategory=='True')
  if(trigger.isupdate && trigger.isbefore)
  {
      OpportunityTriggerHandler.expiredQuoteValidation(trigger.oldMap,trigger.newMap);
  }
}