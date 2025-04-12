/**
 * パートナーサイト連携トリガ
 **/
trigger IntegratePartnerSite on Contact (After insert, After update, Before update) {
    if(flg.firstRun == false){
        return;
    }
    flg.firstRun = false;
    Integer rowCnt = 0;
    for (Contact con: Trigger.New){
        // Insert時はパートナーサイトのユーザ作成は不可
        if (Trigger.isInsert){
            rowCnt++;
            if (con.JP_isPartnerSiteUser__c){
                con.addError('パートナーサイトへのユーザ作成は更新でお願いします。');
            }
            continue;
        }
        // パートナーサイトユーザフラグがtrueかつ、パートナーサイト招待済みフラグがfalseの場合
        if (Trigger.isUpdate && con.JP_isPartnerSiteUser__c && Trigger.Old[rowCnt].JP_isPartnerSiteUser__c == false && con.JP_isPartnerSiteInvited__c == false && Trigger.Old[rowCnt].JP_isPartnerSiteInvited__c == false){
            rowCnt++;
            if (con.AccountId == null){
                con.addError('パートナーサイトへのユーザ作成には会社が必須です。');
                continue;
            }
            if (String.isBlank(con.LastName)){
                con.addError('パートナーサイトへのユーザ作成には姓が必須です。');
                continue;
            }
            if (String.isBlank(con.FirstName)){
                con.addError('パートナーサイトへのユーザ作成には名が必須です。');
                continue;
            }
            if (String.isBlank(con.Email)){
                con.addError('パートナーサイトへのユーザ作成にはメールが必須です。');
                continue;
            }
            // ユーザを新規作成する
            if (Test.IsRunningTest() == false){
                IntegratePartnerSiteHandler.CreateUser(con.Id);
            }

        // パートナーサイトユーザフラグがtrueかつ、パートナーサイト招待済みフラグがtrueかつ、メールが削除または変更された場合エラーとする
        }else if (Trigger.isBefore && Trigger.isUpdate && con.JP_isPartnerSiteUser__c && con.JP_isPartnerSiteInvited__c){
            if (String.isBlank(con.Email) || con.Email != Trigger.Old[rowCnt].Email){
                rowCnt++;
                con.addError('パートナープログラム事務局までご連絡ください。');
                continue;
            }
            rowCnt++;

        // パートナーサイトユーザフラグがfalseかつ、パートナーサイト招待済みフラグがtrueの場合
        }else if (Trigger.isBefore && Trigger.isUpdate && ((con.JP_isPartnerSiteUser__c == false && Trigger.Old[rowCnt].JP_isPartnerSiteUser__c) || (con.JP_isPartnerSiteInvited__c == false && Trigger.Old[rowCnt].JP_isPartnerSiteInvited__c))){
            rowCnt++;
            con.JP_isPartnerSiteUser__c = false;
            con.JP_isPartnerSiteInvited__c = false;
            // ユーザを削除する
            if (Test.IsRunningTest() == false){
                IntegratePartnerSiteHandler.DeactivateUser(con.Id);
            }
        }else{
            rowCnt++;
        }
    }
}