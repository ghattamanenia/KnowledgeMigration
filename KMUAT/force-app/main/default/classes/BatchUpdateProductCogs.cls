/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This Batch Apex is used to update the Quote line item based on the Product COgs info changes 
* 
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author            FusionGS
* @version           1.0
* @createDate        2023 -March - 1
* @systemLayer       Apex Class
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* v1.0             FusionGS
* YYYY-MMM-DD      2023 - March - 1
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
global class BatchUpdateProductCogs implements Database.Batchable<sObject> {
    
    //set of Products Ids
    Set<Id> productIds = new Set<Id>();
    global BatchUpdateProductCogs(Set<Id> pIds) {
        productIds = pIds;
    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        return DataBase.getQueryLocator([SELECT Id, Region_COGS__c,COGS_Sync__c,SBQQ__Quote__r.SBQQ__Primary__c,
                                                  SBQQ__Quote__r.ATFE_Approval_required__c,SBQQ__Quote__r.ATFE_SPQ_Approved__c,
                                                  SBQQ__Quote__r.Quote_To_Region__c, SBQQ__Product__r.ATFE_Cost__c,
                                                  SBQQ__Product__r.Total_APAC__c,SBQQ__Product__r.Total_CSA__c,
                                                  SBQQ__Product__r.Total_EMEA__c,SBQQ__Product__r.Total_NA__c 
                                                  FROM SBQQ__QuoteLine__c WHERE SBQQ__Product__r.Id IN :productIds AND SBQQ__Quote__r.SBQQ__Opportunity2__r.IsClosed=FALSE AND COGS_Sync__c =TRUE limit 50000]);
    }
    
    global void execute(Database.BatchableContext BC,List<SBQQ__QuoteLine__c> scopequoteProduct) {
        
        List<SBQQ__QuoteLine__c> newListQuoteLineItem = new List<SBQQ__QuoteLine__c>();
        for(SBQQ__QuoteLine__c quoteProduct : scopequoteProduct) {
                
            system.debug('****Region'+quoteProduct.SBQQ__Quote__r.Quote_To_Region__c);
            SBQQ__QuoteLine__c newQuoteLineItem = new SBQQ__QuoteLine__c();
            newQuoteLineItem.id = quoteProduct.id;
            if(quoteProduct.SBQQ__Quote__r.Quote_To_Region__c=='NA')
                newQuoteLineItem.Region_COGS__c = quoteProduct.SBQQ__Product__r.Total_NA__c ;
            if(quoteProduct.SBQQ__Quote__r.Quote_To_Region__c=='EMEA')
                newQuoteLineItem.Region_COGS__c = quoteProduct.SBQQ__Product__r.Total_EMEA__c ;
            if(quoteProduct.SBQQ__Quote__r.Quote_To_Region__c=='CSA')
                newQuoteLineItem.Region_COGS__c = quoteProduct.SBQQ__Product__r.Total_CSA__c ;
            if(quoteProduct.SBQQ__Quote__r.Quote_To_Region__c=='APAC')
                newQuoteLineItem.Region_COGS__c = quoteProduct.SBQQ__Product__r.Total_APAC__c ;
            newListQuoteLineItem.add(newQuoteLineItem);
        }
        
        ATFE_PLMUpdateOnQuickQuoteHelper.DoNotRunATFE_SBBQQuoteLineTrigger =true;
        update newListQuoteLineItem;
    }
    global void finish(Database.BatchableContext BC) 
    {
        //Query the AsyncApexJob object to retrieve the current job's information.
        AsyncApexJob apexJob = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
                                FROM AsyncApexJob WHERE Id =: BC.getJobId()];
        
        //Send an email to the Apex job's submitter notifying of job completion.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        system.debug('apexJob.CreatedBy.Email : '+apexJob.CreatedBy.Email);
        String[] toAddress = new String[] {apexJob.CreatedBy.Email};
       // String[] toAddresses = new String[] {'sampath@fusiongs.com'};
        mail.setToAddresses(toAddress);
        mail.setSubject('Apex Job status is ' + apexJob.Status);
        mail.setPlainTextBody('The batch Apex job processed ' + apexJob.TotalJobItems + ' batches with '+ apexJob.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}