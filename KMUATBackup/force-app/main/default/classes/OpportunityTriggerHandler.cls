public class OpportunityTriggerHandler
{
    public static void expiredQuoteValidation(Map<Id,Opportunity> oldOppMap, Map<Id,Opportunity> newOppMap)
    {
        Set<Id> ExpiredOppIds = new set<Id>();
        
        for(Opportunity opp:[Select Id,Probability,(Select Id,SBQQ__ExpirationDate__c from SBQQ__Quotes2__r where SBQQ__Primary__c=true and SBQQ__ExpirationDate__c<TODAY limit 1) from Opportunity where isclosed=false and Id IN :newOppMap.keyset()])
        {
            if(!opp.SBQQ__Quotes2__r.isempty())
            ExpiredOppIds.add(opp.Id);
        }
        
        system.debug('@@@@ExpiredOppIds'+ExpiredOppIds);
        
        for(Opportunity opp:newOppMap.values())
        {
            if(Opp.stageName != oldOppMap.get(opp.Id).stageName && opp.Probability>=75 && opp.Probability<95 && ExpiredOppIds.contains(opp.Id) && (opp.Account_Region__c=='EMEA' || opp.Account_Region__c=='NA' || opp.Account_Region__c=='CSA' || opp.Account_Region__c=='APAC'))
            {
                opp.addError('***** Opportunity Stage Cannot Be Changed To Greater Than or Equal to 75% for the Expired Quote******');
            }
        }
    
    }
}