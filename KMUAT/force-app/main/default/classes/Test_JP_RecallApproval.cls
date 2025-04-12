/**
 * TestClass JP_RecallApproval
 */

@IsTest
private class Test_JP_RecallApproval{

    // SO
    static testMethod void testSo(){

        List<Account> accList = JP_TestUtil.CreateAccount(1);
        JP_ContractInformation__c contractInfo = JP_TestUtilContract.createContractInformation(accList[0]);
        User user = JP_TestUtil.Create_User('011_OUT');
        JP_Management_No__c managementNo = JP_TestUtilContract.createManagementNo(contractInfo, user);
        JP_RequestInformation__c so = JP_TestUtilContract.CreateSo(managementNo);

        Test.startTest();

        List<Id> idlist = new List<Id>();
        idList.add(so.id);
        JP_RecallApproval.doAction(idlist);

        Test.stopTest();
        
    }

    // PO
    static testMethod void testPo(){

        List<Account> accList = JP_TestUtil.CreateAccount(1);
        JP_ContractInformation__c contractInfo = JP_TestUtilContract.createContractInformation(accList[0]);
        User user = JP_TestUtil.Create_User('011_OUT');
        JP_Management_No__c managementNo = JP_TestUtilContract.createManagementNo(contractInfo, user);
        JP_ConsignmentInformation__c po = JP_TestUtilContract.CreatePo(managementNo);

        Test.startTest();

        List<Id> idlist = new List<Id>();
        idList.add(po.id);
        JP_RecallApproval.doAction(idlist);

        Test.stopTest();
        
    }

}