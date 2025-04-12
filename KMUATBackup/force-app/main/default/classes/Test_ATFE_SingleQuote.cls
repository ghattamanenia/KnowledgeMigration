@isTest (SeeAllData=true)
private class Test_ATFE_SingleQuote {

    static testMethod void myUnitTest() {
        Opportunity[] myTestOpp = [Select Id from Opportunity limit 1];
        Quote myQuote = new Quote(name = 'classTest', OpportunityId = myTestOpp[0].Id);
        
        Test.startTest();
            insert myQuote;
        Test.stopTest();
    }
}