/**
 * アラートメールの基準日が更新されたときプロセスビルダーから呼び出される
 */
global class JP_AlertMailFlgOff{

    // 紐づく予約済みアラートメールのフラグをOFFに更新
    @InvocableMethod
    global static void doAction(List<ID> idList){//18

        String StrId = idList[0];
        
        // 管理番号ならSOとPOも
        if(StrId.startsWith('a2p')){
            // SO
            List<JP_RequestInformation__c> soList = [SELECT Id
                                                     FROM   JP_RequestInformation__c
                                                     WHERE  JP_Management_Number__c =:idList];

            // PO
            List<JP_ConsignmentInformation__c> poList = [SELECT Id
                                                         FROM   JP_ConsignmentInformation__c
                                                         WHERE  JP_Management_No__c =:idList];

            for(JP_RequestInformation__c wk : soList){
                idList.add(wk.Id);
            }

            for(JP_ConsignmentInformation__c wk : poList){
                idList.add(wk.Id);
            }
        }

        List<String> parentIdList = new List<String>();
        for(Id wk : idList){
            parentIdList.add(String.valueOf(wk).substring(0,15));
        }

        List<JP_AlertMail__c> recList = [SELECT Id, Name, JP_shouldSend__c, JP_SendDate__c
                                         FROM   JP_AlertMail__c
                                         WHERE  JP_ParentId__c IN :parentIdList
                                                AND JP_shouldSend__c = TRUE
                                                AND JP_Status__c = '予約'];

        for(JP_AlertMail__c rec : recList){
            rec.JP_shouldSend__c = FALSE;
            rec.JP_Status__c = '未設定';
            rec.JP_SendDate__c = null;
        }

        if(recList.size() > 0){
            update recList;
        }

    }
}