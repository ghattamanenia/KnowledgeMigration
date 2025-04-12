@isTest
private class Test_JP_QuotationDetailSelect{
    static testMethod void test(){
        JP_QuotationDetail__c qd1 = new JP_QuotationDetail__c(JP_Sort__c = 1);
        JP_QuotationDetail__c qd2 = new JP_QuotationDetail__c(JP_Sort__c = 3);
        JP_QuotationDetail__c qd3 = new JP_QuotationDetail__c(JP_Sort__c = 2);
        JP_QuotationDetailSelect qds1 = new JP_QuotationDetailSelect(qd1);
        JP_QuotationDetailSelect qds2 = new JP_QuotationDetailSelect(qd2);
        JP_QuotationDetailSelect qds3 = new JP_QuotationDetailSelect(qd3);
        List<JP_QuotationDetailSelect> listQDS = new  List<JP_QuotationDetailSelect>{qds1, qds2, qds3};
        
        Test.startTest();
        listQDS.sort();
        Test.stopTest();
        
        System.assertEquals(1, listQDS[0].obj.JP_Sort__c);
        System.assertEquals(2, listQDS[1].obj.JP_Sort__c);
        System.assertEquals(3, listQDS[2].obj.JP_Sort__c);
    }
}