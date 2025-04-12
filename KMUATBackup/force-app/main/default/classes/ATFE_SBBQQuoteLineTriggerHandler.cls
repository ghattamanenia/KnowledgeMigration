public class ATFE_SBBQQuoteLineTriggerHandler 
{
    public static void EOSProductAvailbility(map<Id,SBQQ__QuoteLine__c> oldquotelines, map<Id,SBQQ__QuoteLine__c> newquotelines)
    {
        Set<Id> QuoteIds = new Set<Id>();
        if(trigger.isinsert || trigger.isupdate)
        for(SBQQ__QuoteLine__c ql:newquotelines.values())
        {
            if(ql.SBQQ__Quote__c!=null)
            QuoteIds.add(ql.SBQQ__Quote__c);
        }
        
        if(trigger.isdelete || trigger.isupdate)
        for(SBQQ__QuoteLine__c ql:oldquotelines.values())
        {
            if(ql.SBQQ__Quote__c!=null)
            QuoteIds.add(ql.SBQQ__Quote__c);
        }
        
        System.debug('@@@@@QuoteIds--->'+QuoteIds);
        
        EOSupdatesOnQuote(QuoteIds);
        
     }   
        public static void EOSupdatesOnQuote(set<Id> QuoteIds)
        {
            list<SBQQ__Quote__c> quotesToupdate = new list<SBQQ__Quote__c>();
        
            for(SBQQ__Quote__c quote:[Select Id,Contains_EOS_Product__c,(select Id,Product_Availability__c from SBQQ__LineItems__r where Product_Availability__c=false limit 1) from SBQQ__Quote__c where Id IN :QuoteIds])
            {
            
                if(quote.SBQQ__LineItems__r.size()>0)
                {
                    if(quote.Contains_EOS_Product__c==false)
                    quote.Contains_EOS_Product__c=true;
                    quotesToupdate.add(quote);
                }
            
                else
                {
                    if(quote.Contains_EOS_Product__c==true)
                    quote.Contains_EOS_Product__c=false;
                    quotesToupdate.add(quote);
                
                }
            }
        
            if(!quotesToupdate.isempty())
            update quotesToupdate;
        
        }
        
    
}