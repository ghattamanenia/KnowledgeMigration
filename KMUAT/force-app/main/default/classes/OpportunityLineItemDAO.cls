public without sharing class OpportunityLineItemDAO {
    public static List<OpportunityLineItem> getOppLineItem(Id oppId){
        return [select 
                    Id
                    ,PriceBookEntryId
                    ,Quantity
                    ,UnitPrice
                    ,Description
                    ,OpportunityId
                    ,ProductCode
                    ,Product2.Name
                    //,JP_PriceBookName__c
                    //,TotalPrice
                    //,PriceBookEntryId__c
                    //20200703 ALLIEDTELESIS-440 terrasky add start
                    ,JP_FixedPrice__c
                    ,JP_NoTriggerFlag__c
                    ,JP_PartitionPrice__c
                    ,JP_PricebookVersion__c
                    ,JP_SortOrder__c
                    ,JP_SPMSCooperationdate__c
                    ,JP_SPMSDetailsId__c
                    ,JP_SPMSProductName__c
                    ,JP_SPMSUser__c
                    //20220311 ALLIEDTELESIS-462 terrasky add start
                    ,JP_QuotationProductName__c
                    ,JP_QuotationDetailType__c
                    ,JP_CompletionScheduled__c
                    ,JP_WholesalePrice__c
                from 
                    OpportunityLineItem 
                where 
                    OpportunityId = :oppId
                ];
    }
}