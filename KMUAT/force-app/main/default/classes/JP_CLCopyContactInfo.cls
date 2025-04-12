public class JP_CLCopyContactInfo {

    public void copy(List<JP_RepairItem__c> nlist){
        //住所2に入力がある場合のみ改行を半角スペースに置換
        for(Integer i=0; i< nlist.size(); i++){
            if(nlist[i].JP_ContactAddress2__c != null){
            system.debug('★顧客住所2：'+nlist[i].JP_ContactAddress2__c);
                String Address2=nlist[i].JP_ContactAddress2__c.replaceAll('\r\n',' ');
            system.debug('★￥r￥n置換後 変数に保持する文字列：'+Address2);
                nlist[i].JP_SendToAddress2__c=Address2.replaceAll('\n',' ');
            system.debug('★￥n置換後 配送先住所2に入れる文字列：'+nlist[i].JP_SendToAddress2__c);
            }else{
                nlist[i].JP_SendToAddress2__c=nlist[i].JP_ContactAddress2__c;
            }
            //顧客情報コピー
            nlist[i].JP_SendToAddress1__c = nlist[i].JP_ContactAdress1__c;
            nlist[i].JP_SendToCompanyName__c = nlist[i].JP_CompanyName__c;
            nlist[i].JP_SendToContactName__c = nlist[i].JP_ContactName__c;
            nlist[i].JP_SendToDepartment1__c = nlist[i].JP_ContactDepartment1__c;
            nlist[i].JP_SendToDepartment2__c = nlist[i].JP_ContactDepartment2__c;
            nlist[i].JP_SendToFAXNumber__c = nlist[i].JP_ContactFAXNumber__c;
            nlist[i].JP_SendToMobilePhoneNumber__c = nlist[i].JP_ContactMobilePhoneNumber__c;
            nlist[i].JP_SendToPhoneNumber__c = nlist[i].JP_ContactPhoneNumber__c;
            nlist[i].JP_SendToPostalCode__c = nlist[i].JP_ContactPostalCode__c;
            //配送先同一フラグをFalseに更新
            nlist[i].JP_SendToEqualsFlag__c = false;
        }
    }
}