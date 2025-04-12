global class ATFE_NotifyAboutQuoteExpiration implements Schedulable  {
/* This class notifies the quote owner 2 weeks before and 1 week before their quote expires */      
    
    global void execute(SchedulableContext sc){
        /*
        Schema.DescribeSObjectResult quoteDescribe = Schema.SObjectType.Quote; 
        Map<String,Schema.RecordTypeInfo> quoteRtMapByName = quoteDescribe.getRecordTypeInfosByName();
        Id quoteAfterRTId =  quoteRtMapByName.get('ATFE_Quote After Approval').getRecordTypeId();
        
        Quote[] quotesToNotify = new Quote[]{};
        
        for (Quote expiringQuote : [SELECT ATFE_Send_14_Day_Expiration_Notice__c, ATFE_Send_7_Day_Expiration_Notice__c, ExpirationDate, RecordTypeId 
                                    FROM Quote WHERE RecordTypeId = :quoteAfterRTId AND ExpirationDate = NEXT_n_DAYS:15]) {
            
            Date fourteenDaysBeforeExp = expiringQuote.ExpirationDate.addDays(-14);
            Date sevenDaysBeforeExp = expiringQuote.ExpirationDate.addDays(-7);                         
                                        
            if (Date.Today() == fourteenDaysBeforeExp) {
                expiringQuote.ATFE_Send_14_Day_Expiration_Notice__c = true;
                quotesToNotify.add(expiringQuote);
            }
            else if (Date.Today() == sevenDaysBeforeExp) {
                expiringQuote.ATFE_Send_7_Day_Expiration_Notice__c = true;
                quotesToNotify.add(expiringQuote);
            }
            
        }
        
        if (quotesToNotify.size() > 0) {
            
            try {
                update quotesToNotify;
            } catch (Exception ex) {
                
            }   
        } */
    }
}