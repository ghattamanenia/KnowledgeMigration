/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This Trigger is used to Send the Product Id to the Handlers
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author            FusionGS
* @version           1.0
* @createDate        2022-Dec-25
* @systemLayer       Apex Trigger
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* v1.0             FusionGS
* YYYY-MMM-DD      2022-Dec-25
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
trigger ProductCogsTrigger on Product2 (after update) {
    Set<Id> productids = new set<Id>();
    if(Trigger.isAfter && Trigger.isUpdate){
        for (Product2 p : Trigger.new) {
            system.debug('&&&'+P);
           // if(p.RecordTypeId=='' || p.RecordTypeId==null){
           if(p.RecordTypeId==null){
                if(p.ATFE_Cost__c != Trigger.oldMap.get(p.Id).ATFE_Cost__c 
               || p.Total_NA__c  != Trigger.oldMap.get(p.Id).Total_NA__c 
               || p.Total_EMEA__c  != Trigger.oldMap.get(p.Id).Total_EMEA__c 
               || p.Total_APAC__c  != Trigger.oldMap.get(p.Id).Total_APAC__c 
               || p.Total_CSA__c  != Trigger.oldMap.get(p.Id).Total_CSA__c) {
                 productids.add(p.id);
                 system.debug('***'+productids);
             }  
          }
        }
        if(productids.size()>0){
            //UpdateProductCogs.updateCPQQuoteProductCods(productids);
            Database.executeBatch(new BatchUpdateProductCogs(productids),Integer.valueOf(System.Label.Cogs_Batch_Size));
        }
    }
    
}