public with sharing class JP_CustomerInfo2Dao {

    public static List<JP_CustomerInfo2__c> getRecsByQuoteId(String quoteId){
        return [select 
                    Name,
                    JP_Address1__c,
                    JP_Address2__c,
                    JP_Building__c,
                    JP_ChangeAddresses__c,
                    JP_Department1__c,
                    JP_Department2__c,
                    JP_FaxNo__c,
                    JP_PostalCode__c,
                    JP_TelNo__c,
                    JP_Title__c
                from 
                    JP_CustomerInfo2__c
                where 
                    JP_QuotationHeader__c = :quoteId
                ];
    }
}