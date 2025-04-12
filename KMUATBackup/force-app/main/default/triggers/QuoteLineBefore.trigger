trigger QuoteLineBefore on SBQQ__QuoteLine__c (before insert, before update) {
    
    if(ATFE_PLMUpdateOnQuickQuoteHelper.DoNotRunATFE_SBBQQuoteLineTrigger)
        return;
        
        
    Set<Id> productIds = new Set<Id>();
    Set<String> currencies = new Set<String>();
    Set<Id> pricebookIds = new Set<Id>();
    SBQQ__QuoteLine__c[] newProducts = new SBQQ__QuoteLine__c[0];
    for (SBQQ__QuoteLine__c line : Trigger.new) {
        if (Trigger.isInsert || (line.MSRP_Price__c == null) || (Trigger.oldMap.get(line.Id).SBQQ__Product__c == line.SBQQ__Product__c)) {
            productIds.add(line.SBQQ__Product__c);
            currencies.add(line.CurrencyIsoCode);
            pricebookIds.add(line.MSRP_Pricebook_ID__c);
            newProducts.add(line);
        }
    }
    
    if (!productIds.isEmpty()) {
        Map<String,PricebookEntry> entriesIdx = new Map<String,PricebookEntry>();
        for (PricebookEntry entry : [SELECT UnitPrice, CurrencyIsoCode, Pricebook2Id, Product2Id FROM PricebookEntry WHERE Product2Id IN :productIds AND Pricebook2Id IN :pricebookIds AND CurrencyIsoCode IN :currencies AND IsActive = true]) {
            entriesIdx.put(entry.Product2Id + '-' + entry.Pricebook2Id + '-' + entry.CurrencyIsoCode, entry);
        }
        
        for (SBQQ__QuoteLine__c line : newProducts) {
            PricebookEntry entry = entriesIdx.get(line.SBQQ__Product__c + '-' + (Id)line.MSRP_Pricebook_ID__c + '-' + line.CurrencyIsoCode);
            line.MSRP_Price__c = (entry != null) ? entry.UnitPrice : null;
        }
    }
}