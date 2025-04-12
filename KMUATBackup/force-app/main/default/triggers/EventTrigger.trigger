trigger EventTrigger on Event (before delete) {

    //カスタム表示ラベル：false==全処理Skip、false以外==処理実行
    if(System.Label.JP_TriggerAllSkipFLG.equals('false')){
        //削除時
        if(Trigger.IsBefore && Trigger.IsDelete){
            EventTriggerHandler.BeforeDelete(Trigger.Old);
        }
    }
}