global class ATFE_ChangeQuoteQuicklyRecordTypeBatch implements Database.Batchable<sObject> 
{
 
  public String query;
  
  public list<SBQQ__Quote__c> Quotes = new list<SBQQ__Quote__c>();
  
  public  string quoteAfterRTId;
  
  public string quoteBeforeRTId;
  
  global ATFE_ChangeQuoteQuicklyRecordTypeBatch()
  {
     Schema.DescribeSObjectResult quoteDescribe = Schema.SObjectType.SBQQ__Quote__c; 
     Map<String,Schema.RecordTypeInfo> quoteRtMapByName = quoteDescribe.getRecordTypeInfosByName();
     quoteBeforeRTId =  quoteRtMapByName.get('ATFE_Quote Before Approval').getRecordTypeId();
     quoteAfterRTId =  quoteRtMapByName.get('ATFE_Quote After Approval').getRecordTypeId();
     if(!Test.isRunningTest())
     query='SELECT SBQQ__ExpirationDate__c, RecordTypeId FROM SBQQ__Quote__c WHERE SBQQ__ExpirationDate__c <= TODAY AND RecordTypeId =\''+quoteAfterRTId+'\'';
     if(Test.isrunningTest())
     query='SELECT SBQQ__ExpirationDate__c, RecordTypeId FROM SBQQ__Quote__c WHERE SBQQ__ExpirationDate__c <= TODAY AND RecordTypeId =\''+quoteAfterRTId+'\' LIMIT 100';
     
     
  }
  
  global Database.QueryLocator start(Database.BatchableContext BC) 
  {
     return Database.getQueryLocator(query);
  }

  global void execute(Database.BatchableContext BC, List<sObject> batch) 
  {
    SBQQ__Quote__c[] quotesToUpdate = new SBQQ__Quote__c[]{};
    
    for (sobject rec:batch) 
    {
           SBQQ__Quote__c sq = new SBQQ__Quote__c();
           sq=(SBQQ__Quote__c)rec;
           sq.RecordTypeId = quoteBeforeRTId;
            quotesToUpdate.add(sq);
    }
        
        if (quotesToUpdate.size() > 0) {
            
            try {
                update quotesToUpdate;
            } catch (Exception ex) {
                
            }   
        }
    
  }

  global void finish(Database.BatchableContext BC) 
  {
    
  }
}