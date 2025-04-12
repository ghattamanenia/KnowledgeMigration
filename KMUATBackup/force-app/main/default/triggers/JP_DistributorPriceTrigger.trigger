/*******************
Description:JP_DistributorPriceTrigger
Developer: TerraSky Co.,Ltd.
Date Created: 09/03/2015
Date Modified:09/03/2015
*****************/
trigger JP_DistributorPriceTrigger on JP_DistributorPrice__c (after insert,after update) {

    //カスタム表示ラベル：false==全処理Skip、false以外==処理実行
    if(System.Label.JP_TriggerAllSkipFLG.equals('false')){
        
        //多重起動防止フラグ
        if(JP_DistributorPriceTriggerHandler.isFirst){
        
            //新規登録時
            if(Trigger.IsAfter && Trigger.IsInsert){
                JP_DistributorPriceTriggerHandler.AfterInsert(Trigger.New);
            }
        
            //更新時
            if(Trigger.IsAfter && Trigger.IsUpdate){
                JP_DistributorPriceTriggerHandler.AfterUpdate(Trigger.New);
            }

            //JP_DistributorPriceTriggerHandler.isFirst = false;
        
        }
    }
}