/**
 * TestClass JP_SO_Detail
 */

@IsTest
private class Test_JP_SO_Detail{

    static testMethod void test1(){

        List<Account> accList = JP_TestUtil.CreateAccount(1);
        JP_ContractInformation__c contractInfo = JP_TestUtilContract.createContractInformation(accList[0]);
        User user = JP_TestUtil.Create_User('011_OUT');
        JP_Management_No__c managementNo = JP_TestUtilContract.createManagementNo(contractInfo, user);
        JP_RequestInformation__c so = JP_TestUtilContract.CreateSo(managementNo);
        JP_SO_Detail__c sod = JP_TestUtilContract.CreateSod(managementNo);

        Test.startTest();

        Apexpages.Standardcontroller scon = new Apexpages.Standardcontroller(so);
        JP_SO_Detail ConClass = new JP_SO_Detail(scon);

        Test.stopTest();
        
    }

}