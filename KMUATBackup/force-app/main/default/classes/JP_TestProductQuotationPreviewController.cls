@isTest
public class JP_TestProductQuotationPreviewController{

    private static testMethod void  testSuccess01(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
            Pagereference pageref = Page.JP_ProductQuotationSelectPreview;

            JP_QuotationHeader__c qh = JP_TestUtil.Create_JP_QuotationHeaderForTrigger(-5);    
            List<JP_QuotationDistributor__c> qdList = JP_TestUtil.Create_JP_QuotationDistributor();
            List<JP_QuotationDistributor__c> qdSelectedList = [SELECT ID FROM JP_QuotationDistributor__c WHERE ID IN :qdList];
            qh.JP_QuotationDistCD__c = qdSelectedList[0].Id;
            insert qh;
            List<JP_QuotationHeader__c> qhList = [SELECT ID,JP_QuotationNo__c FROM JP_QuotationHeader__c];
            System.assertEquals(1,qhList.size());
            JP_TestUtil.Create_JP_QuotationTemplate();

            Pageref.getparameters().put('id',qhList[0].Id);
            Pageref.getparameters().put('qhno',qhList[0].JP_QuotationNo__c);
            Test.setCurrentPage(pageRef);

            ApexPages.StandardController stdController = new ApexPages.StandardController(qh);
            JP_ProductQuotationPreviewController extController = new JP_ProductQuotationPreviewController(stdController);

            extController.doExecute();
        }
    }
}