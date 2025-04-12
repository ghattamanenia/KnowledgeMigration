/**
 * TestClass JP_CopyManagementNo
 */

@IsTest
private class Test_JP_CopyManagementNo{

    // 正常1
    static testMethod void testNormal01(){

        List<Account> accList = JP_TestUtil.CreateAccount(1);
        JP_ContractInformation__c contractInfo = JP_TestUtilContract.createContractInformation(accList[0]);
        User user = JP_TestUtil.Create_User('011_OUT');
        JP_Management_No__c managementNo = JP_TestUtilContract.createManagementNo(contractInfo, user);
        JP_RequestInformation__c so = JP_TestUtilContract.CreateSo(managementNo);
        JP_SO_Detail__c sod = JP_TestUtilContract.CreateSod(managementNo);
        JP_ConsignmentInformation__c po = JP_TestUtilContract.CreatePo(managementNo);
        JP_PO_Detail__c pod = JP_TestUtilContract.CreatePod(po);
        JP_AlertMail__c alertMail1 = JP_TestUtilContract.CreatealertMail(managementNo.Id);

        Test.startTest();

        List<Id> idlist = new List<Id>();
        idList.add(managementNo.id);
        JP_CopyManagementNo.doAction(idlist);

        Test.stopTest();
        
    }

}