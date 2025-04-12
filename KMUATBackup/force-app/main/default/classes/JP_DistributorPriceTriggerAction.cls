public with sharing class JP_DistributorPriceTriggerAction {
    
    /*
    * 価格年月レコード登録処理
    * @param 
    * @return
    */
    public static void registPriceYearMonth(List<JP_DistributorPrice__c> newList){
        //価格年月管理List
        Map<String,JP_DistributorPrice__c> dpMap = new Map<String,JP_DistributorPrice__c>();  //キー、データのMap
        List<JP_PriceYearMonth__c> pymList = new List<JP_PriceYearMonth__c>();    //Upsert対象List
     
        //代理店仕切価格表データでroop
        for(JP_DistributorPrice__c dp : newList){
            dpMap.put(dp.JP_Price_List_Type__c + '_' + dp.JP_PriceYearMonth__c,dp);       
        }   
        //Upsert対象List作成
        for(String key: dpMap.keySet()){
            JP_PriceYearMonth__c pym = new JP_PriceYearMonth__c();
            pym.JP_Price_List_Type__c = dpMap.get(key).JP_Price_List_Type__c;  //price_list_type
            pym.JP_PriceYearMonth__c = dpMap.get(key).JP_PriceYearMonth__c;    //価格年月
            pym.JP_UpsertKey__c = dpMap.get(key).JP_Price_List_Type__c + '_' + dpMap.get(key).JP_PriceYearMonth__c;    //連携更新キー
            pymList.add(pym);
        }
        //Upsert
        upsert pymList JP_UpsertKey__c;    
    }

}