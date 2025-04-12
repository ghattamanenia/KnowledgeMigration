@isTest
private class Test_JP_QuoteToDISController {

    static testMethod void myUnitTest() {

        List<JP_QuotationDistributor__c> qdlist = JP_testUtil.Create_JP_QuotationDistributor();
        System.debug('-------');
        System.debug(qdlist);
        System.debug('-------');
        JP_QuotationHeader__c quote = JP_testUtil.Create_JP_QuotationHeader(1)[0];

        JP_QuotationDistributor__c qd = [Select id from JP_QuotationDistributor__c][0];
        quote.JP_QuotationDistCD__c = qd.id;
        //quote.JP_QuotationEffectiveTerm__c='30';
        //quote.JP_QuoteOutputDate__c=Date.today();
        insert quote;
        
        PageReference pref = Page.JP_QuouteToDIS;
        System.Test.setCurrentPage(pref);
        
        System.Test.startTest();

        System.debug('-------');
        System.debug(quote);
        System.debug(quote.Id);
        System.debug(quote.JP_QuotationEffectiveTerm__c);
        System.debug(quote.JP_EstimatesExpirationDate__c);
        System.debug('-------');
            
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(quote);
        JP_QuoteToDISController cc = new JP_QuoteToDISController(sc);

        System.Test.stopTest();
    }

     static testMethod void myTest02() {
        System.debug('-------');
        System.debug('test02');
        System.debug(JP_QuoteToDISController.dateformat('2018/2/9'));
        System.debug('-------');
     }

     static testMethod void myTest03() {
        System.debug('-------');
        System.debug('test03');
        System.debug(JP_QuoteToDISController.dateformat('2018年 2月 9日'));
        System.debug('-------');
     }

     static testMethod void myTest04() {
        System.debug('-------');
        System.debug('test04');
        System.debug(JP_QuoteToDISController.dateformat('2018年2月9日'));
        System.debug('-------');
     }

     static testMethod void myTest05() {
        System.debug('-------');
        System.debug('test05');
        System.debug(JP_QuoteToDISController.dateformat(null));
        System.debug('-------');
     }

}