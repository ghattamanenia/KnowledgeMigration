public class ProductTriggerHandler 
{
    @Future
    public static void EOSProductHandler(set<ID> prodids)
    {
        list<SBQQ__QuoteLine__c> quoteLines = new list<SBQQ__QuoteLine__c>();
        set<Id> quoteIdsToConsider = new set<Id>();
        list<SBQQ__Quote__c> quotesToupdate = new list<SBQQ__Quote__c>();
        
        for(SBQQ__QuoteLine__c ql:[Select Id,SBQQ__Product__c,SBQQ__Product__r.ATFE_ProdAvailCode__c,SBQQ__Quote__c from SBQQ__QuoteLine__c where SBQQ__Product__c IN (select Id from Product2 where Id IN :prodids)])
        {
            quoteIdsToConsider.add(ql.SBQQ__Quote__c);
        }
        
        System.debug('@@@@quoteIdsToConsider------>'+quoteIdsToConsider);
        
        ATFE_SBBQQuoteLineTriggerHandler.EOSupdatesOnQuote(quoteIdsToConsider);
        
        
    }
}