trigger ContractedPriceBefore on SBQQ__ContractedPrice__c (before insert, before update) {
    Set<Id> contractIds = new Set<Id>();
    for (SBQQ__ContractedPrice__c price : Trigger.new) {
        if (Trigger.isInsert || (Trigger.oldMap.get(price.Id).Sales_Contract__c != price.Sales_Contract__c)) {
            if (price.Sales_Contract__c != null) {
                contractIds.add(price.Sales_Contract__c);
            }
        }
    }
    
    if (!contractIds.isEmpty()) {
        Map<Id,Contract> contractsById = new Map<Id,Contract>([SELECT StartDate, EndDate,CurrencyIsoCode FROM Contract WHERE Id IN :contractIds]);
        for (SBQQ__ContractedPrice__c price : Trigger.new) {
            Contract c = contractsById.get(price.Sales_Contract__c);
            if (c != null) {
                price.SBQQ__EffectiveDate__c = c.StartDate;
                price.SBQQ__ExpirationDate__c = c.EndDate;
                
                price.CurrencyIsoCode = c.CurrencyIsoCode;
            }
        }
    }
}