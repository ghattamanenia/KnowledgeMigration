@isTest
private class Test_JP_QuotationHeaderDAO{
    
    static List<JP_QuotationDistributor__c> distibutors = JP_TestUtil.Create_JP_QuotationDistributor();
    static List<JP_QuotationContact__c> qcList = [Select Id,Name From JP_QuotationContact__c Where JP_QuotationDistributor__c=:distibutors[0].id Order by Name];
    
    static testMethod void testGetRecByQuotationNoMax(){
    
        DateTime dtNow = System.Now();
        String jstYYMM = dtNow.format('yyMM', 'JST');
    
        JP_QuotationHeader__c rec;
        JP_QuotationHeader__c rec2;

        rec = new JP_QuotationHeader__c();
        rec.JP_TotalAmount__c = 1;
        rec.JP_QuotationDistCD__c = distibutors[0].Id;
        insert rec;
        
        System.debug('jstYYMM:' + jstYYMM);
        rec = JP_QuotationHeaderDAO.getRecByQuotationNoMax(jstYYMM);
        System.debug('rec:' + rec.JP_QuotationNo__c);
        
        rec = new JP_QuotationHeader__c();
        rec.JP_TotalAmount__c = 1;
        rec.JP_QuotationDistCD__c = distibutors[0].Id;
        insert rec;
        rec = null;
        
        Test.startTest();
        rec = JP_QuotationHeaderDAO.getRecByQuotationNoMax(jstYYMM);
        rec2 = JP_QuotationHeaderDAO.getRecByQuotationNoMax('999912');
        Test.stopTest();
        
        System.assertEquals(jstYYMM + '0002A', rec.JP_QuotationNo__c);
        
        System.assertEquals(null, rec2);
    }
    
    static testMethod void testGetRecById(){
    
        JP_QuotationHeader__c rec;
        JP_QuotationHeader__c rec2;

        rec = new JP_QuotationHeader__c();
        rec.JP_TotalAmount__c = 1;
        rec.JP_QuotationDistCD__c = distibutors[0].Id;
        insert rec;
        
        String strId = rec.Id;
        
        Test.startTest();
        rec = JP_QuotationHeaderDAO.getRecById(rec.Id);
        rec2 = JP_QuotationHeaderDAO.getRecById(strId.substring(0,3) + '000000000000');
        Test.stopTest();
        
        System.assertNotEquals(null, rec);
        System.assertEquals(null, rec2);
    } 

    static testMethod void testGetRecByIdUseFieldSet(){
    
        JP_QuotationHeader__c rec;
        JP_QuotationHeader__c rec2;

        rec = new JP_QuotationHeader__c();
        rec.JP_TotalAmount__c = 1;
        rec.JP_QuotationDistCD__c = distibutors[0].Id;
        insert rec;
        
        String strId = rec.Id;
        
        Test.startTest();
        rec = JP_QuotationHeaderDAO.getRecByIdUseFieldSet(rec.Id);
        Test.stopTest();
    } 

    static testMethod void testGetQuoteOutPutDate(){
    
        JP_QuotationHeader__c rec;
        JP_QuotationHeader__c rec2;

        rec = new JP_QuotationHeader__c();
        rec.JP_TotalAmount__c = 1;
        rec.JP_QuotationDistCD__c = distibutors[0].Id;
        insert rec;
        
        String strId = rec.Id;
        
        Test.startTest();
        rec = JP_QuotationHeaderDAO.getQuoteOutPutDate(rec.Id);
        Test.stopTest();
    } 

    static testMethod void testGetRecByQuotationNo(){
    
        JP_QuotationHeader__c rec;
        JP_QuotationHeader__c rec2;

        rec = new JP_QuotationHeader__c();
        rec.JP_TotalAmount__c = 1;
        rec.JP_QuotationDistCD__c = distibutors[0].Id;
        insert rec;
        
        JP_QuotationHeader__c result = [select Id,JP_QuotationNo__c from JP_QuotationHeader__c where Id = :rec.Id limit 1];
        
        Test.startTest();
        List<JP_QuotationHeader__c> recs = JP_QuotationHeaderDAO.getRecByQuotationNo(result.JP_QuotationNo__c);
        Test.stopTest();
    } 
}