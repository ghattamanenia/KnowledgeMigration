/*******************
Description:JP_QuotationHeaderTrigger
Developer: TerraSky Co.,Ltd.
Date Created: 08/20/2015
Date Modified:08/20/2015
*****************/
trigger JP_QuotationHeaderTrigger on JP_QuotationHeader__c (before insert,before update) {

    //カスタム表示ラベル：false==全処理Skip、false以外==処理実行
    if(System.Label.JP_TriggerAllSkipFLG.equals('false')){
        if(JP_QuotationHeaderTriggerHandler.isFirst){                
            //新規登録時
            if(Trigger.IsBefore && Trigger.IsInsert){
                JP_QuotationHeaderTriggerHandler.BeforeInsert(Trigger.New);
            }
        
            //更新時
            if(Trigger.IsBefore && Trigger.IsUpdate){
                JP_QuotationHeaderTriggerHandler.BeforeUpdate(Trigger.OldMap,Trigger.New);
            }
       }
    
    }
    
    
    
}