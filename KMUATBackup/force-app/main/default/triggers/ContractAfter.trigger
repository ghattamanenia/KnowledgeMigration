trigger ContractAfter on Contract (after update) {

  if(!utils.DoNotRunContractTrigger){
       system.debug('::inside trigger:::'  );
        if (Trigger.isUpdate) {
            SBQQ__ContractedPrice__c[] prices = [SELECT Sales_Contract__c FROM SBQQ__ContractedPrice__c WHERE Sales_Contract__c IN :Trigger.newMap.keySet()];
            for (SBQQ__ContractedPrice__c price : prices) {
                Contract c = Trigger.newMap.get(price.Sales_Contract__c);
                price.SBQQ__EffectiveDate__c = c.StartDate;
                price.SBQQ__ExpirationDate__c = c.EndDate;
            }
            
            utils.DoNotRunContractpriceTrigger = true;
            update prices;
        }
        
    }
    
   
  
}