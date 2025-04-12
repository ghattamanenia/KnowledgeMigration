trigger QuoteLineTrigger on SBQQ__QuoteLine__c (after insert,after update,after delete) 
{
    if(ATFE_PLMUpdateOnQuickQuoteHelper.DoNotRunATFE_SBBQQuoteLineTrigger)
        	return;
    
    ATFE_SBBQQuoteLineTriggerHandler.EOSProductAvailbility(trigger.oldmap,trigger.newmap);
}