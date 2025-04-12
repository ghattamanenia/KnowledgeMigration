@isTest
private class Test_JP_QuotationConditionList {
    
     static testMethod void testQuotationConditionList() {
        // テストデータ作成

        List<JP_QuotationCondition__c> qc = new List<JP_QuotationCondition__c>();
        qc.add(new JP_QuotationCondition__c(Name='10001',JP_QuotationConditionCode__c='10001',JP_QuotationCondition__c='条件文１',JP_DisplayOrder__c=1));
        qc.add(new JP_QuotationCondition__c(Name='10002',JP_QuotationConditionCode__c='20001',JP_QuotationCondition__c='条件文２',JP_DisplayOrder__c=2));
        qc.add(new JP_QuotationCondition__c(Name='10003',JP_QuotationConditionCode__c='30001',JP_QuotationCondition__c='条件文３',JP_DisplayOrder__c=3));
        qc.add(new JP_QuotationCondition__c(Name='10004',JP_QuotationConditionCode__c='40001',JP_QuotationCondition__c='条件文４',JP_DisplayOrder__c=4));
        qc.add(new JP_QuotationCondition__c(Name='10005',JP_QuotationConditionCode__c='50001',JP_QuotationCondition__c='条件文５',JP_DisplayOrder__c=5));
        insert qc;

        JP_QuotationCondition__c rec = new JP_QuotationCondition__c();

        PageReference pref = Page.JP_QuotationConditionList;
        Test.setCurrentPage(pref);

        Test.startTest();

        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
        JP_QuotationConditionList jpQc = new JP_QuotationConditionList(sc);
        
        Test.stopTest();

        system.assertNotEquals(jpQc.QuotationConditionList.size(),0);
        
    }
    
}