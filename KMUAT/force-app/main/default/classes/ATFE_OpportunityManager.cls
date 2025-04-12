public with sharing class ATFE_OpportunityManager {

  /*
      The following method is used for updating Approval Hierarchy on Opportunity
  */
  public static void UpdateApprovalHirarchy(List<Opportunity> newOpps){
  
      Map<String,ATFE_Regions__c> regionsMap = ATFE_Regions__c.getAll();
      Map<Id,String> accRegionsMap = new Map<Id,String>();
      Set<Id> accIds = new Set<Id>();
      for(Opportunity opp : newOpps){
          if(opp.AccountId != null && opp.ATFE_ApprovalHierarchy__c == null)
              accIds.add(opp.AccountId);
      }
      if (accIds != null && accIds.size() > 0) {
        for(Account acc : [select id,Region__c , Sub_Region__c from Account where id in :accIds]){
            accRegionsMap.put(acc.id,acc.Region__c + ' - ' + acc.Sub_Region__c );
        }
        for(Opportunity opp : newOpps){
            String regionKey = accRegionsMap.get(opp.AccountId);
            System.debug('regionKey:'+regionKey);
            if(regionsMap.containsKey(regionKey))
                opp.ATFE_ApprovalHierarchy__c = regionsMap.get(regionKey).Approval_Hirarchy__c ;
        }
      }
  }
  
  /*
      The following method is used for updating RecordType on Opportunity
  */
  
 public static void UpdateRecordType(List<Opportunity> newOpps){ 
  
  list<RecordType> lstRecord = [Select r.SobjectType, r.Name, r.IsActive, r.Id From RecordType r where r.IsActive = true AND r.SobjectType = 'Opportunity' AND r.Id = '01220000000AIqz'];
  Id EnvigilantRecTypeId= Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Envigilant').getRecordTypeId(); 
  // string AccountEnvigilantRecTypeName = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Envigilant Accounts').getRecordTypeName();   
        list<Opportunity> lstOpportunity = new list<Opportunity>();
        // system.debug('@@@@EnvigilantRecTypeName'+EnvigilantRecTypeName);
        
        for(Opportunity opp : newOpps){
    
            system.debug('@@@Opp.RecordTypeId'+opp.RecordTypeId);
            system.debug('@@@lstRecord[0].Id'+lstRecord[0].Id);
            system.debug('@@@@opp.Lead_Record_Type_Name__c'+opp.Lead_Record_Type_Name__c);
            system.debug('@@@@opp.Account_Record_Type_Name__c'+opp.Account_Record_Type_Name__c);
            // system.debug('@@@AccountEnvigilantRecTypeName'+AccountEnvigilantRecTypeName);
            if(lstRecord != null && lstRecord.size()>0) 
            {

                if(opp.Probability == 25 && opp.RecordTypeId != lstRecord[0].Id && opp.RecordTypeId !='012200000005ttF')
                {
                    opp.RecordTypeId =  lstRecord[0].Id;
                 }
                 else if(opp.Probability != 25  && opp.RecordTypeId == lstRecord[0].Id && (opp.Lead_Record_Type_Name__c !='Envigilant Leads' && opp.Account_Record_Type_Name__c!='Envigilant Accounts'))
                 {
                     opp.RecordTypeId = '01220000000HW6Q';
                 }
                 else if (opp.Probability != 25  && opp.RecordTypeId == lstRecord[0].Id && (opp.Lead_Record_Type_Name__c =='Envigilant Leads' || opp.Account_Record_Type_Name__c=='Envigilant Accounts'))
                 {
                     opp.RecordTypeId=EnvigilantRecTypeId;
                 }

            }
        }
    }  
  
 /*
      The following method is used for Product Validation on Opportunity
  */ 
  
   public static void ProductValidation (List<Opportunity> newOpps){
    
    //  Id RecordTypeId = trigger.new[0].RecordTypeId;
      
      for(Opportunity opp : newOpps){
        
        if(opp.Probability>0.25 && opp.Amount != null && opp.Total_Quantity__c == 0 && opp.RecordTypeId != '01220000000AIqz' && 
        (opp.RecordTypeId == '01220000000HUnj' || opp.RecordTypeId == '01220000000HW6Q' || opp.RecordTypeId == '01220000000AIqz' ))
        {
            opp.addError('Product Is Required');
        }

    }  
 }
}