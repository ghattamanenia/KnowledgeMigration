/**
 * TestClass JP_Matter_ViewCase
 */

@IsTest
private class Test_JP_Matter_ViewCase{
    // 初回リリース用
    static testMethod void testNew1(){

        List<Account> accList = JP_TestUtil.CreateAccount(1);
        Contact con = JP_TestUtilContract.createCon(accList[0]);
//        JP_ContractInformation__c contractInfo = JP_TestUtilContract.createContractInformation(accList[0]);
//        User user = JP_TestUtil.Create_User('011_OUT');
//        JP_Management_No__c managementNo = JP_TestUtilContract.createManagementNo(contractInfo, user);
        JP_Matter__c matter = JP_TestUtilContract.CreateMatter(con);

        Test.startTest();

        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(matter);
        JP_Matter_ViewCase ConClass = new JP_Matter_ViewCase(sc);
//        List<Case> caseList = ConClass.getCase(con.Id);

//        List<Id> idlist = new List<Id>();
//        idList.add(managementNo.id);
//        JP_Matter_ViewCaseJP_Matter_ViewCase.doAction(idlist);


        Test.stopTest();
        
    }

}