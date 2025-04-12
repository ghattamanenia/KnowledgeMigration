public with sharing class JP_DistributorPriceTriggerHandler{

     //多重起動防止
    public static Boolean isFirst = true;

    /*
    * 新規登録時処理
    * @param Trigger.new => List<JP_DistributorPrice__c> newList
    * @return void
    */
    public static void AfterInsert(List<JP_DistributorPrice__c> newList){
        JP_DistributorPriceTriggerAction.registPriceYearMonth(newList);
    }
    
    /*
    * 更新時処理
    * @param Trigger.new => List<JP_DistributorPrice__c> newList
    * @return void
    */
    public static void AfterUpdate(List<JP_DistributorPrice__c> newList){
        JP_DistributorPriceTriggerAction.registPriceYearMonth(newList);
    }    

}