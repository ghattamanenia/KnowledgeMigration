global class ATFE_ChangeQuoteQuicklyRecordType implements Schedulable {
/* This class updates SBQQ__Quote__c record types to "ATFE_Quote Before Approval" if it is their expiration date */      
    /*
    global void execute(SchedulableContext sc){
        
        Schema.DescribeSObjectResult quoteDescribe = Schema.SObjectType.SBQQ__Quote__c; 
        Map<String,Schema.RecordTypeInfo> quoteRtMapByName = quoteDescribe.getRecordTypeInfosByName();
        Id quoteBeforeRTId =  quoteRtMapByName.get('ATFE_Quote Before Approval').getRecordTypeId();
        Id quoteAfterRTId =  quoteRtMapByName.get('ATFE_Quote After Approval').getRecordTypeId();
        
        SBQQ__Quote__c[] quotesToUpdate = new SBQQ__Quote__c[]{};
        
        for (SBQQ__Quote__c expiredQuote : [SELECT SBQQ__ExpirationDate__c, RecordTypeId FROM SBQQ__Quote__c WHERE SBQQ__ExpirationDate__c <= TODAY AND RecordTypeId = :quoteAfterRTId]) {
            expiredQuote.RecordTypeId = quoteBeforeRTId;
            quotesToUpdate.add(expiredQuote);
        }
        
        if (quotesToUpdate.size() > 0) {
            
            try {
                update quotesToUpdate;
            } catch (Exception ex) {
                
            }   
        }
    }   */
    
    global void execute(SchedulableContext sc)
    {
        
        Id i=database.executebatch(new ATFE_ChangeQuoteQuicklyRecordTypeBatch());
        
        
    }

}