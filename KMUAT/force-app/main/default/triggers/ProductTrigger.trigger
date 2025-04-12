trigger ProductTrigger on Product2 (after update) 
{
    Set<Id> productids = new set<Id>();
    if(Trigger.isAfter && Trigger.isUpdate){
        for (Product2 p : Trigger.new) {
           if(p.RecordTypeId==null)
           {
                if(p.ATFE_Cost__c != Trigger.oldMap.get(p.Id).ATFE_Cost__c 
                   || p.Total_NA__c  != Trigger.oldMap.get(p.Id).Total_NA__c 
                   || p.Total_EMEA__c  != Trigger.oldMap.get(p.Id).Total_EMEA__c 
                   || p.Total_APAC__c  != Trigger.oldMap.get(p.Id).Total_APAC__c 
                   || p.Total_CSA__c  != Trigger.oldMap.get(p.Id).Total_CSA__c)
                   {
                     return;
                   }  
                 else{
                     productids.add(p.id);
                 }  
          }
        }
        // chek the product size
        if(productids.size()>0){
            //ProductTriggerHandler.EOSProductHandler(trigger.newmap.keyset());
            ProductTriggerHandler.EOSProductHandler(productids);
        }
    }

}