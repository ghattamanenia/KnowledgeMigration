global class InactiveProductsOpptysNotificationBatch implements Database.Batchable<sObject>,database.stateful
{
   
  //string query='Select Id,Name,OwnerId,Owner.Name,Owner.Email,Account_Region__c from Opportunity where isclosed=false and Id IN (Select OpportunityId from OpportunityLineItem where Product2.ATFE_ProdAvailCode__c=\'EOS\')';
    string query='';
   global integer currentYear;
   Map<Id,list<Opportunity>> OwnerIdOpptyList = new Map<Id,List<Opportunity>>();
   Map<Id,string> OppIdInactivePrdNames = new Map<Id,string>();
   Set<Id> OppIds = new Set<Id>();
   
    global InactiveProductsOpptysNotificationBatch()
   {
     
      // query='Select Id,Name,OwnerId,Owner.Name,Owner.Email,Account_Region__c from Opportunity where isclosed=false and closedate>:dt and Id IN (Select OpportunityId from OpportunityLineItem where Product2.ATFE_ProdAvailCode__c=\'EOS\')'; 
     currentYear=system.today().year();
     system.debug('@@@Limits.getLimitAggregateQueries in constuctor'+Limits.getLimitAggregateQueries());
     system.debug('@@@Limits.getLimitQueries in constuctor'+Limits.getLimitQueries());
     system.debug('@@@Limits.getQueryLocatorRows in constuctor'+Limits.getQueryLocatorRows());
     system.debug('@@@Limits.getLimitQueryLocatorRows in constuctor'+Limits.getLimitQueryLocatorRows());
     
     for(OpportunityLineItem olm:[Select OpportunityId from OpportunityLineItem where (Createddate=LAST_N_YEARS:1 OR CALENDAR_YEAR(Createddate) =:currentYear) and (Opportunity.Account_Region__c='EMEA' OR Opportunity.Account_Region__c='NA' OR Opportunity.Account_Region__c='CSA' OR Opportunity.Account_Region__c='APAC')  and Product2.ATFE_ProdAvailCode__c='EOS'])
     {
         if(olm.OpportunityId!=null)
         OppIds.add(olm.OpportunityId);
     }
     system.debug('@@@@OppIds'+OppIds);
     
     // query='Select Id,Name,OwnerId,Owner.Name,Owner.Email,Account_Region__c from Opportunity where isclosed=false and (closedate= LAST_N_YEARS:1 OR CALENDAR_YEAR(closedate) =:currentYear ) and (Account_Region__c=\'EMEA\' OR Account_Region__c=\'NA\' OR Account_Region__c=\'CSA\' OR Account_Region__c=\'APAC\') and Id IN (Select OpportunityId from OpportunityLineItem where (Createddate=LAST_N_YEARS:1 OR CALENDAR_YEAR(Createddate) =:currentYear) and (Opportunity.Account_Region__c=\'EMEA\' OR Opportunity.Account_Region__c=\'NA\' OR Opportunity.Account_Region__c=\'CSA\' OR Opportunity.Account_Region__c=\'APAC\')  and Product2.ATFE_ProdAvailCode__c=\'EOS\')';

    query='Select Id,Name,OwnerId,Owner.Name,Owner.Email,Account_Region__c from Opportunity where Id IN :OppIds and isclosed=false and (closedate= LAST_N_YEARS:1 OR CALENDAR_YEAR(closedate) =:currentYear ) and (Account_Region__c=\'EMEA\' OR Account_Region__c=\'NA\' OR Account_Region__c=\'CSA\' OR Account_Region__c=\'APAC\')';

   }
   global Database.QueryLocator start(Database.BatchableContext BC)
   {
        return Database.getQueryLocator(query) ;
   }

   global void execute(Database.BatchableContext BC,List<sObject> scope)
   {
     system.debug('@@@Limits.getLimitAggregateQueries in execute method'+Limits.getLimitAggregateQueries());
     system.debug('@@@Limits.getLimitQueries in execute method'+Limits.getLimitQueries());
     system.debug('@@@Limits.getQueryLocatorRows in execute method'+Limits.getQueryLocatorRows());
     system.debug('@@@Limits.getLimitQueryLocatorRows in execute method'+Limits.getLimitQueryLocatorRows());
     
      // string oppId='';
      Set<Id> OppIds = new Set<Id>();
      for(Sobject s : scope)
      {
        opportunity opp = new Opportunity();
        opp=(opportunity)s;
        system.debug('@@@@@opp'+opp);
        // oppId=opp.Id;
        OppIds.add(opp.Id);
        list<Opportunity> opptys = new list<Opportunity>();
        if(OwnerIdOpptyList.keyset().contains(opp.OwnerId))
        {
            opptys=OwnerIdOpptyList.get(opp.ownerId);
        }
        opptys.add(opp);
        OwnerIdOpptyList.put(Opp.OwnerId,opptys);
        
      }   

       system.debug('@@@@@ final map of OwnerIdOpptyList'+OwnerIdOpptyList);
       system.debug('@@@@@OppIds'+OppIds);
       
       //   here you go 
        string str='';
        for(OpportunityLineItem ol:[Select OpportunityId,Product2.Name from OpportunityLineItem where OpportunityId IN :OppIds and (Createddate=LAST_N_YEARS:1 OR CALENDAR_YEAR(Createddate) =:currentYear) and (Opportunity.Account_Region__c='EMEA' OR Opportunity.Account_Region__c='NA' OR Opportunity.Account_Region__c='CSA' OR Opportunity.Account_Region__c='APAC') and Product2.ATFE_ProdAvailCode__c='EOS'])
        {
            if(OppIdInactivePrdNames.keyset().contains(ol.OpportunityId))
            {
                str=OppIdInactivePrdNames.get(ol.OpportunityId)+','+ol.Product2.Name;
            }    
            else
            str=ol.Product2.Name;
            
            OppIdInactivePrdNames.put(ol.OpportunityId,str);
        }
        
              
   }

   global void finish(Database.BatchableContext BC)
   {
        system.debug('@@@@@@OwnerIdOpptyList in finish'+OwnerIdOpptyList);
        system.debug('@@@@@@OppIdInactivePrdNames in finish'+OppIdInactivePrdNames);
        if(!OwnerIdOpptyList.isempty())
        InactiveProductsOpptysNotificationHelper.sendNotification(OwnerIdOpptyList,OppIdInactivePrdNames);
   }

}