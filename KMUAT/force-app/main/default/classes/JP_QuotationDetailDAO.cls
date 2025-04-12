/**
 * 見積明細オブジェクトのDAOクラス 
 */

public with sharing class JP_QuotationDetailDAO {
    
    public static List<JP_QuotationDetail__c> getRecByParentId(Id parentId){
        return [SELECT 
                        id,
                        Name,
                        JP_5PercentDiscount__c,
                        JP_AppGroupID__c,
                        JP_CampaignDecision__c,
                        JP_DetailAppClassificationCode__c,
                        JP_DetailsID__c,
                        JP_DetailsNo__c,
                        JP_DeterminedAmount__c,
                        JP_DiscountLimitPrice__c,
                        JP_DistributorProCode__c,
                        JP_IsSpecialDistributorProduct__c,
                        JP_OverLimitDiscount__c,
                        JP_PriceYearMonth__c,
                        JP_ProductCatalogCode__c,
                        JP_ProductCode__c,
                        JP_ProductName__c,
                        JP_Quantity__c,
                        JP_QuotationHeader__c,
                        JP_QuotationNo__c,
                        JP_QuotationRemarks__c,
                        JP_ReleaseScheduled__c,
                        JP_RequiredMaintenanceFlag__c,
                        JP_SalesEndScheduled__c,
                        JP_SalesStatus__c,
                        JP_Sort__c,
                        JP_SpecialPriceDecision__c,
                        JP_SpecialUnitPriceMulQuantity__c,
                        JP_SpecialWholeSaleTRate__c,
                        JP_SpecialUnitPrice__c,
                        JP_StandardMinusSpecial__c,
                        JP_StandardPrice__c,
                        JP_TotalStandardAmount__c,
                        JP_Unit__c,
                        JP_UnitPrice__c,
                        JP_WholeSalePriceMulQuantity__c,
                        JP_WholeSaleRate__c,
                        JP_SupportTicketCode__c,
                        JP_PiStock__c,
                        JP_PriceBookEntryId__c,
                        JP_Category1__c,
                        JP_Category2__c,
                        JP_Maker__c,
                        JP_PreSave__c,
                        JP_PreRelease__c,
                        JP_OpenPriceFlag__c,
                        JP_LoweLimitPrice__c,
                        JP_IsProductError__c,
                        JP_QuotationDescription__c, //20160330追加
                        JP_QuotationDetailType__c,  //20210806追加
                        JP_MOQ__c,                  //20171017追加
                        //JP_CompletionScheduled__c,    //20220208追加 見積明細の完了予定日は保留
                        JP_WholesalePrice__c        //20220208追加
                FROM 
                      JP_QuotationDetail__c 
                WHERE 
                      JP_QuotationHeader__c =:parentId
                order by 
                      JP_Sort__c asc
            ];
    }
    
    public static Map<ID,List<JP_QuotationDetail__c>> getChildrenByParentIds(Set<ID> parentIds){
        system.debug('◆parentIds ： ' + parentIds);
        Map<ID,List<JP_QuotationDetail__c>> detailMap = new Map<ID,List<JP_QuotationDetail__c>>();
        
        List<JP_QuotationHeader__c> parents = [SELECT
            Id,
            (Select 
                Id,
                JP_5PercentDiscount__c,
                JP_SpecialUnitPrice__c,
                JP_UnitPrice__c,
                JP_OverLimitDiscount__c,
                JP_AppGroupID__c,
                JP_ProductCode__c,
                JP_ProductCatalogCode__c,
                JP_PreRelease__c,
                JP_PreSave__c
            From 
                JP_QuotationDetail__r)
        From
            JP_QuotationHeader__c
        Where
            Id IN :parentIds];
            
        for(JP_QuotationHeader__c header : parents){
            if(!detailMap.containsKey(header.Id)){
                detailMap.put(header.Id, header.JP_QuotationDetail__r);
            }
        }  
        
        return detailMap;
    }

    public static List<JP_QuotationDetail__c> getRecByIdUseFieldSet(Id recId){
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : SObjectType.JP_QuotationDetail__c.FieldSets.CopyItemToQuotation.getFields()) {
            query += f.getFieldPath() + ', ';
        }
        
        query += 'Id FROM JP_QuotationDetail__c ';
        query += 'where JP_QuotationHeader__c = \'' + recId + '\' ';
        
        system.debug('★query : ' + query);
        return Database.query(query);
    }
    
    public static List<AggregateResult> getRecForGId(String qId){
        return [SELECT JP_AppGroupID__c, COUNT(Name) gId
                FROM JP_QuotationDetail__c
                where JP_QuotationHeader__c = :qId
                GROUP BY JP_AppGroupID__c];
    }
    
    
}