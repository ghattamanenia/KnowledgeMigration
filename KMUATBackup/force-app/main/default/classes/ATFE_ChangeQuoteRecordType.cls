global class ATFE_ChangeQuoteRecordType implements Schedulable {
/* This class updates quote record types to "ATFE_Quote Before Approval" if it is their expiration date */      
    
    global void execute(SchedulableContext sc){
        
        Schema.DescribeSObjectResult quoteDescribe = Schema.SObjectType.Quote; 
        Map<String,Schema.RecordTypeInfo> quoteRtMapByName = quoteDescribe.getRecordTypeInfosByName();
        Id quoteBeforeRTId =  quoteRtMapByName.get('ATFE_Quote Before Approval').getRecordTypeId();
        Id quoteAfterRTId =  quoteRtMapByName.get('ATFE_Quote After Approval').getRecordTypeId();
        
        Quote[] quotesToUpdate = new Quote[]{};
        
        for (Quote expiredQuote : [SELECT ExpirationDate, RecordTypeId FROM Quote WHERE ExpirationDate <= TODAY AND RecordTypeId = :quoteAfterRTId]) {
            expiredQuote.RecordTypeId = quoteBeforeRTId;
            quotesToUpdate.add(expiredQuote);
        }
        
        if (quotesToUpdate.size() > 0) {
            
            try {
                update quotesToUpdate;
            } catch (Exception ex) {
                
            }   
        }
    }

}