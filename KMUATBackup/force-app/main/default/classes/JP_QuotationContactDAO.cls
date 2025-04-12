public with sharing class JP_QuotationContactDAO {
    public static List<JP_QuotationContact__c> getRecBySfId(Id sfId){
        return [SELECT 
                        Id,
                        Name,
                        JP_CustomerAddress1__c,
                        JP_CustomerAddress2__c,
                        JP_CustomerBuilding__c,
                        JP_CustomerDept1__c,
                        JP_CustomerDept2__c,
                        JP_CustomerFaxNo__c,
                        JP_CustomerPostcode__c,
                        JP_CustomerTelNo__c,
                        toLabel(JP_Title_Position__c)
                From 
                        JP_QuotationContact__c
                WHERE 
                      Id =:sfId
            ];
    }



}