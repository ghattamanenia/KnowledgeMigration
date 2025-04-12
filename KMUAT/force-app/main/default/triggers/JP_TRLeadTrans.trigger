/*******************
Description:トランス通知機能
Developer: Hitachi Solutions, Ltd.
Date Created: 01/27/2012
Date Modified:01/27/2012
*****************/
trigger JP_TRLeadTrans on Lead (before update,after update) {

        System.debug('★★★JP_TRLeadTransStart★★★');

        List<RecordType> list_Rec = [select id,Name from RecordType where Name = 'JP_LeadsForItemTrans' limit 1];
        if(list_Rec.size() != 1) {
            System.debug('RecordType Error');
            return;
        }
        ID idRec = list_Rec[0].Id;

        //before updateの場合
        // Leadの所有権変更
        if( Trigger.isUpdate && Trigger.isBefore) {

            //トランス通知対象データを格納するリスト
            List<Lead> translst_New = new List<Lead>();

            for(Integer i=0 ;i<Trigger.New.size(); i++){
                //トランス通知対象を抽出する
                if(Trigger.New[i].RecordTypeId == idRec
                    && Trigger.old[i].JP_TransDate__c == null
                    && Trigger.New[i].JP_TransDate__c != null){
                        // 営業担当or拠点長が入力されていなければエラー
                        if (Trigger.New[i].JP_TransUser__c ==null){
                            Trigger.New[i].JP_TransUser__c.addError('営業担当or拠点長を入力して下さい');
                            continue;
                        }
                        translst_New.add(Trigger.New[i]);
                    }
            }
            if(translst_New.size() > 0){
                //リード所有者変更メソッド呼出
                JP_CLLeadTrans.LeadOwnerChange(idRec,translst_New);
            }
        }

        //after updateの場合
        // トランス通知メール送信
        if( Trigger.isUpdate && Trigger.isAfter ){

            //定義：トランス通知対象データを格納するリスト
            Map<Id,Lead> transMap_New = new Map<ID,Lead>();

            //一括更新処理(DataLoader)を考慮し、更新データ件数分ループ
            for(Integer i=0 ;i<Trigger.New.size(); i++){
                //トランス通知対象を抽出する
                if(Trigger.New[i].RecordTypeId == idRec
                    && Trigger.old[i].JP_TransDate__c == null
                    && Trigger.New[i].JP_TransDate__c != null){
                        // 営業担当or拠点長が入力されていなければエラー
                        if (Trigger.New[i].JP_TransUser__c ==null){
                            Trigger.New[i].JP_TransUser__c.addError('営業担当or拠点長を入力して下さい');
                            continue;
                        }
                        //トランス通知対象とし、listへ格納する
                        transMap_New.put(Trigger.New[i].id, Trigger.New[i]);
                }
            }
            
            if(transMap_New.size() > 0 ){
                //トランス通知クラスの呼び出し
                JP_CLLeadTrans.LeadTrans(transMap_New);
            }
        }
}