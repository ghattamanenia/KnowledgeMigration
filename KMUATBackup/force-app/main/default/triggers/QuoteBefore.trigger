trigger QuoteBefore on SBQQ__Quote__c (before insert, before update) {
    for (SBQQ__Quote__c quote : Trigger.new) {
        if ((quote.MSRP_Pricebook__c == null) && (quote.Quote_To_Region__c != null)) {
            if (quote.Quote_To_Region__c == 'NA') {
                quote.MSRP_Pricebook__c = '01s200000001sBL';
              }   else if (quote.Quote_To_Region__c == 'ATCC') {
                quote.MSRP_Pricebook__c = '01s200000001sBL';
              }  else if (quote.Quote_To_Region__c == 'APAC') {
                quote.MSRP_Pricebook__c = '01sw00000002GlY';
            } else if (quote.Quote_To_Region__c == 'CSA') {
                quote.MSRP_Pricebook__c = '01s20000000256O';
            } else if (quote.Quote_To_Region__c == 'EMEA') {
                if (quote.Quote_To_Currency__c == 'USD') {
                    quote.MSRP_Pricebook__c = '01s20000000220D';
                } else if (quote.Quote_To_Currency__c == 'EUR') {
                    quote.MSRP_Pricebook__c = '01s200000002208';
                }
            }
            
        }
    }
}