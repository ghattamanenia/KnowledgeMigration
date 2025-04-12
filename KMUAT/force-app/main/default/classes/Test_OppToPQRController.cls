@isTest
private class Test_OppToPQRController {

    static testMethod void myUnitTest() {
    //Channelinsight.CI_TEST_TestUtils.createBaseInstallData();Neha commented for model n package uninstallation
        User u = JP_TestUtil.Create_User('011_OUT');
        List<Account> accList = JP_TestUtil.CreateAccount(2);
        Opportunity opp = JP_TestUtil.Create_Opportunity();
        JP_TestUtil.CreatePartner(opp.Id, accList[1].Id);
        JP_TestUtil.CreateOpportunityTeamMember(opp.Id, u.Id);
        PriceBookEntry pbe = JP_TestUtil.CreateProduct();
        JP_TestUtil.CreateOpportunityLineItem(opp.Id, pbe.Id);
        
        PageReference pref = Page.OpportunityToPQR;
        System.Test.setCurrentPage(pref);
        
        System.Test.startTest();
            
            Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(opp);
            OpportunityToPQRController otpqrc = new OpportunityToPQRController(sc);

        System.Test.stopTest();
    }
}