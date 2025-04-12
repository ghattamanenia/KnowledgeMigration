public with sharing class JP_QuotationConditionList {

    public List<JP_QuotationCondition__c> QuotationConditionList {get; set;}

    public JP_QuotationConditionList(ApexPages.StandardController stdController) {
        QuotationConditionList = new List<JP_QuotationCondition__c>();
        // レコード取得
        Map<Integer,JP_QuotationCondition__c> distributorConditionMap = new Map<Integer,JP_QuotationCondition__c>();
        
        List<JP_QuotationCondition__c> qc = [Select Id,Name,JP_QuotationConditionCode__c,JP_QuotationCondition__c,JP_DisplayOrder__c
                                             From JP_QuotationCondition__c
                                             Order by JP_DisplayOrder__c
                                            ];

        //表示ようにListにセットする
        for(JP_QuotationCondition__c rec : qc){
            if(Integer.valueOf(rec.JP_QuotationConditionCode__c) > 10000){
                QuotationConditionList.add(rec);
            }
        }


        
    }
}