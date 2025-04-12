/**
 * TestClass JP_AlertMailFlgOff
 */

@IsTest
private class Test_JP_AlertMailFlgOff{
    // 初回リリース用
    static testMethod void testNew1(){

        List<Account> accList = JP_TestUtil.CreateAccount(1);
        JP_ContractInformation__c contractInfo = JP_TestUtilContract.createContractInformation(accList[0]);
        User user = JP_TestUtil.Create_User('011_OUT');
        JP_Management_No__c managementNo = JP_TestUtilContract.createManagementNo(contractInfo, user);
        JP_AlertMail__c alertMail = JP_TestUtilContract.CreatealertMail(managementNo.Id);

        Test.startTest();

        List<Id> idlist = new List<Id>();
        idList.add(managementNo.id);
        JP_AlertMailFlgOff.doAction(idlist);


        Test.stopTest();
        
    }
    // 管理番号
    static testMethod void testManagement_No(){

        List<Account> accList = JP_TestUtil.CreateAccount(1);
        JP_ContractInformation__c contractInfo = JP_TestUtilContract.createContractInformation(accList[0]);
        User user = JP_TestUtil.Create_User('011_OUT');
        JP_Management_No__c managementNo = JP_TestUtilContract.createManagementNo(contractInfo, user);
        JP_AlertMail__c alertMail = JP_TestUtilContract.CreatealertMail(managementNo.Id);

        Test.startTest();

        // 基準日を変更
        managementNo.JP_EndYmd__c = Date.Today()+1;
        update managementNo;

        Test.stopTest();
        
    }
}