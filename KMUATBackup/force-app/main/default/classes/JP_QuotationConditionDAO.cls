public with sharing class JP_QuotationConditionDAO {

    public static List<JP_QuotationCondition__c> getRecByCondCode(String conditionCd){
        return [Select Id,
                       Name,
                       JP_QuotationConditionCode__c,
                       JP_QuotationCondition__c,
                       JP_DisplayOrder__c
                From JP_QuotationCondition__c 
                Where JP_QuotationConditionCode__c =:conditionCd
                Order by JP_DisplayOrder__c
               ];

    }
    
    public static List<JP_QuotationCondition__c> getRecByCondCDs(Set<String> conditionCd){
        return [Select Id,
                       Name,
                       JP_QuotationConditionCode__c,
                       JP_QuotationCondition__c,
                       JP_DisplayOrder__c
                From JP_QuotationCondition__c 
                Where JP_QuotationConditionCode__c IN:conditionCd
                Order by JP_DisplayOrder__c
               ];

    }

    public static List<JP_QuotationCondition__c> getAllRec(){
        return [Select Name,
                       JP_QuotationConditionCode__c,
                       JP_DisplayOrder__c
                From JP_QuotationCondition__c 
                Order by JP_DisplayOrder__c
                ];
    }

    

    
}