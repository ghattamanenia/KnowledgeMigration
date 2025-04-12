/*******************
Description:顧客情報コピー機能
Developer: Hitachi Solutions, Ltd.
DateCreated: 01/31/2013
DateModified:01/31/2013
*****************/
trigger JP_TRCopyContactInfo on JP_RepairItem__c (before insert, before update) {
    List<JP_RepairItem__c> JP_nList = new List<JP_RepairItem__c>();
    
    //配送先同一フラグがTrueのレコードを対象に加える
    for(Integer i=0; i< Trigger.new.size(); i++){
        if(Trigger.new[i].JP_SendToEqualsFlag__c == true){
            JP_nList.add(Trigger.new[i]);
        }
    }
    
    //対象がある場合にクラスを呼び出す
    if(JP_nList.size()>0){
        JP_CLCopyContactInfo conInfo = new JP_CLCopyContactInfo();
        conInfo.copy(JP_nList);
    }
}