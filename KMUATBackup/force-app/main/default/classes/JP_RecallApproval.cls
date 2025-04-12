/**
 * レコードのロックを解除
 */
Global class JP_RecallApproval{

    @InvocableMethod
    public static List<Boolean> doAction(List<ID> idList){
    
        String StrId = idList[0];
        List<Boolean> isNormal = new List<Boolean>();

        // SOヘッダ
        if(StrId.startsWith('a2t')){
            List<JP_RequestInformation__c> upList = new List<JP_RequestInformation__c>();
            List<JP_RequestInformation__c> recList = [SELECT Id, JP_ApprovalStatus__c, JP_SO_Regist_Status__c, JP_Mail_Approval_Status__c
                                                          FROM   JP_RequestInformation__c
                                                          WHERE  Id =:StrId];

            for(JP_RequestInformation__c wk : recList){
                wk.JP_ApprovalStatus__c = '未承認';
                wk.JP_SO_Regist_Status__c = '';
                wk.JP_Mail_Approval_Status__c = '';
                upList.add(wk);
            }

            Savepoint sp = Database.setSavepoint();
            try {
                update upList;
                Approval.UnlockResult[] urList = Approval.unlock(recList, false);
            }catch(Exception e){
                System.debug('◆エラー');
                Database.rollback(sp);
                isNormal.add(false);
            }


        // POヘッダ
        }else if(StrId.startsWith('a2j')){
            List<JP_ConsignmentInformation__c> upList = new List<JP_ConsignmentInformation__c>();
            List<JP_ConsignmentInformation__c> recList = [SELECT Id
                                                          FROM   JP_ConsignmentInformation__c
                                                          WHERE  Id =:StrId];
            for(JP_ConsignmentInformation__c wk : recList){
                wk.JP_ApprovalStatus__c = '未承認';
                wk.JP_PO_RegistStatus__c = '';
                wk.JP_Mail_Approval_Status__c = '';
                upList.add(wk);
            }

            Savepoint sp = Database.setSavepoint();
            try {
                update upList;
                Approval.UnlockResult[] urList = Approval.unlock(recList, false);
            }catch(Exception e){
                System.debug('◆エラー');
                Database.rollback(sp);
                isNormal.add(false);
            }
        }
        isNormal.add(true);
        return isNormal;
    }
}