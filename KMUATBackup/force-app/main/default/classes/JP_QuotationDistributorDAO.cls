/**
 * 代理店オブジェクトのDAOクラス 
 */

public with sharing class JP_QuotationDistributorDAO {

    public static List<JP_QuotationDistributor__c> getRecByDistId(String distributorId){
        return [Select Id
                  ,Name
                  ,JP_DistributorCode__c
                  ,JP_PaymentCondition__c
                  ,JP_MainDistributorName__c
                  ,JP_SubjectAutoSetFlag__c
                  ,JP_DeafultQuotationCondition__c
                  ,JP_SpotDistributor__c
                  ,JP_Price_List_Type__c
                  ,JP_MainDistributorCode__c
                  ,JP_QuotationCreatableFlag__c //20181120 Add LEX化対応
                  ,JP_DistributorActiveFlag__c  //20181120 Add LEX化対応
                  ,JP_EffectiveFlagForMainDistributor__c    //20181120 Add LEX化対応
                 From 
                       JP_QuotationDistributor__c 
                 Where 
                       Id =:distributorId
                ];

    }
}