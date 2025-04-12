trigger JP_QuotationDetailTrigger on JP_QuotationDetail__c (before insert,after insert,after delete) {

    //カスタム表示ラベル：false==全処理Skip、false以外==処理実行
    system.debug('トリガスキップフラグ（カスタム表示ラベル）' + System.Label.JP_TriggerAllSkipFLG);
    if(System.Label.JP_TriggerAllSkipFLG.equals('false')){
            //新規登録時Before
            if(Trigger.IsBefore && Trigger.IsInsert){
                system.debug('******BeforeInsert');
                JP_QuotationDetailTriggerHandler.BeforeInsert(Trigger.New);
            }
            //新規登録時After
            if(Trigger.IsAfter && Trigger.IsInsert){
                System.debug('DetailTrigger AfterInsert');
                JP_QuotationDetailTriggerHandler.AfterInsert(Trigger.New);
            }
            //削除時
            if(Trigger.IsAfter && Trigger.IsDelete){
                JP_QuotationDetailTriggerHandler.AfterDelete(Trigger.Old);
            }
    }

}