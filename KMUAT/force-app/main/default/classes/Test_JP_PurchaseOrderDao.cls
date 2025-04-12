@isTest
private class Test_JP_PurchaseOrderDao {

    static testMethod void test01(){
        List<Document> docList = JP_PurchaseOrderDao.getDocuments();
    }
    
    static testMethod void test02(){
        List<JP_Order010PurchaseOrder__c> poList = JP_PurchaseOrderDao.getPurchaseOrder('test');
    }
}