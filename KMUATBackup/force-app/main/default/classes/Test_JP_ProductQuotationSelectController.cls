@isTest
public class Test_JP_ProductQuotationSelectController{

    private static testMethod void  testWithinFourteen(){
        JP_ApprovalProcessMaster__c apm = JP_TestUtil.Create_JP_ApprovalProcessMaster(1);
        JP_DecideApprovalProcess__c ap = new JP_DecideApprovalProcess__c();
        ap.JP_ApprovalProcessMaster__c = apm.Id;
        ap.JP_ChkTotalAmountCD__c = 'A1';
        ap.JP_ChkWholeSaleCD__c = 'B3';
        ap.JP_ChkLimitDiscountCD__c = 'C1';
        ap.JP_ChkRegisteredProductCD__c = 'D1';
        ap.JP_ChkQuotationExpiryDateCD__c = 'E1';
        ap.JP_ChkPreReleaseCD__c = 'F1';
        ap.JP_ChkkProductResponsibleCD__c = 'G1';
        insert ap;

        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
            Pagereference pageref = Page.JP_ProductQuotationSelect;

            JP_QuotationHeader__c qh = JP_TestUtil.Create_JP_QuotationHeaderForTrigger(-5);    
            List<JP_QuotationDistributor__c> qdList = JP_TestUtil.Create_JP_QuotationDistributor();
            List<JP_QuotationDistributor__c> qdSelectedList = [SELECT ID FROM JP_QuotationDistributor__c WHERE ID IN :qdList];
            qh.JP_QuotationDistCD__c = qdSelectedList[0].Id;
            qh.JP_IncludingSalesTax__c = true;
            qh.JP_OpenPrice__c = 'オープン表示あり';
            qh.JP_RoundingSalesTax__c = '切り捨て';
            qh.JP_DisplayCorporationSeal__c = false;
            insert qh;

            List<JP_QuotationDetail__c> details = JP_TestUtil.Create_JP_QuotationDetail(qh.Id,1);
            for(JP_QuotationDetail__c qd : details){
                qd.JP_QuotationHeader__c = qh.Id;
                qd.JP_AppGroupID__c = 'G1';
                qd.JP_SpecialUnitPrice__c = 200000;
                qd.JP_5PercentDiscount__c = 227430;
                qd.JP_OverLimitDiscount__c = false;
                qd.JP_ProductCode__c = '9998';
                qd.JP_ProductCatalogCode__c = '1111';
                qd.JP_PreRelease__c = false;
                qd.JP_ProductName__c = 'テスト商品1';
                qd.JP_Sort__c = 1;
                qd.JP_Quantity__c = 1;
                qd.JP_DetailsNo__c = 1;
                qd.JP_WholeSaleRate__c  = 0.6;
                qd.JP_UnitPrice__c = 239400;
                qd.JP_SpecialWholeSaleTRate__c = NULL;
                qd.JP_DiscountLimitPrice__c = 205884;
                qd.JP_SalesStatus__c = '1';
                qd.JP_WholeSalePriceMulQuantity__c = qd.JP_UnitPrice__c * qd.JP_WholeSaleRate__c;
                qd.JP_SpecialUnitPriceMulQuantity__c = 0;
                qd.JP_StandardMinusSpecial__c = 0;
                qd.JP_DeterminedAmount__c = 239400;
                qd.JP_PriceYearMonth__c = 'JP 2015/09';
                qd.JP_PreSave__c = false;
            }
            insert details;

            List<JP_QuotationHeader__c> qhList = [SELECT ID,JP_QuotationNo__c FROM JP_QuotationHeader__c];
            System.assertEquals(1,qhList.size());
            JP_TestUtil.Create_JP_QuotationTemplate();

            Test.setCurrentPage(pageRef);

            ApexPages.StandardController stdController = new ApexPages.StandardController(qh);
            JP_ProductQuotationSelectController extController = new JP_ProductQuotationSelectController(stdController);

            extController.doExecute();
        }
    } 

    private static testMethod void  testOverFourteen(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        JP_ApprovalProcessMaster__c apm = JP_TestUtil.Create_JP_ApprovalProcessMaster(1);
        JP_DecideApprovalProcess__c ap = new JP_DecideApprovalProcess__c();
        ap.JP_ApprovalProcessMaster__c = apm.Id;
        ap.JP_ChkTotalAmountCD__c = 'A1';
        ap.JP_ChkWholeSaleCD__c = 'B3';
        ap.JP_ChkLimitDiscountCD__c = 'C1';
        ap.JP_ChkRegisteredProductCD__c = 'D1';
        ap.JP_ChkQuotationExpiryDateCD__c = 'E1';
        ap.JP_ChkPreReleaseCD__c = 'F1';
        ap.JP_ChkkProductResponsibleCD__c = 'G1';
        insert ap;

        System.runAs(testUsr){
            Pagereference pageref = Page.JP_ProductQuotationSelect;

            JP_QuotationHeader__c qh = JP_TestUtil.Create_JP_QuotationHeaderForTrigger(-30);    
            List<JP_QuotationDistributor__c> qdList = JP_TestUtil.Create_JP_QuotationDistributor();
            List<JP_QuotationDistributor__c> qdSelectedList = [SELECT ID FROM JP_QuotationDistributor__c WHERE ID IN :qdList];
            qh.JP_QuotationDistCD__c = qdSelectedList[0].Id;
            insert qh;

            List<JP_QuotationDetail__c> details = JP_TestUtil.Create_JP_QuotationDetail(qh.Id,1);
            for(JP_QuotationDetail__c qd : details){
                qd.JP_QuotationHeader__c = qh.Id;
                qd.JP_AppGroupID__c = 'G1';
                qd.JP_SpecialUnitPrice__c = 200000;
                qd.JP_5PercentDiscount__c = 227430;
                qd.JP_OverLimitDiscount__c = false;
                qd.JP_ProductCode__c = '9998';
                qd.JP_ProductCatalogCode__c = '1111';
                qd.JP_PreRelease__c = false;
                qd.JP_ProductName__c = 'テスト商品1';
                qd.JP_Sort__c = 1;
                qd.JP_Quantity__c = 1;
                qd.JP_DetailsNo__c = 1;
                qd.JP_WholeSaleRate__c  = 0.6;
                qd.JP_UnitPrice__c = 239400;
                qd.JP_SpecialWholeSaleTRate__c = NULL;
                qd.JP_DiscountLimitPrice__c = 205884;
                qd.JP_SalesStatus__c = '1';
                qd.JP_WholeSalePriceMulQuantity__c = qd.JP_UnitPrice__c * qd.JP_WholeSaleRate__c;
                qd.JP_SpecialUnitPriceMulQuantity__c = 0;
                qd.JP_StandardMinusSpecial__c = 0;
                qd.JP_DeterminedAmount__c = 239400;
                qd.JP_PriceYearMonth__c = 'JP 2015/09';
                qd.JP_PreSave__c = false;
            }
            insert details;

            List<JP_QuotationHeader__c> qhList = [SELECT ID,JP_QuotationNo__c FROM JP_QuotationHeader__c];
            System.assertEquals(1,qhList.size());
            JP_TestUtil.Create_JP_QuotationTemplate();

            Test.setCurrentPage(pageRef);

            ApexPages.StandardController stdController = new ApexPages.StandardController(qh);
            JP_ProductQuotationSelectController extController = new JP_ProductQuotationSelectController(stdController);

            extController.doExecute();            
        }
    } 

    private static testMethod void  testBadParam(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
            Pagereference pageref = Page.JP_ProductQuotationSelect;
            
            JP_QuotationHeader__c qh = JP_TestUtil.Create_JP_QuotationHeaderForTrigger(-5);    
            List<JP_QuotationDistributor__c> qdList = JP_TestUtil.Create_JP_QuotationDistributor();
            List<JP_QuotationDistributor__c> qdSelectedList = [SELECT ID FROM JP_QuotationDistributor__c WHERE ID IN :qdList];
            qh.JP_QuotationDistCD__c = qdSelectedList[0].Id;
            insert qh;
            List<JP_QuotationHeader__c> qhList = [SELECT ID,JP_QuotationNo__c FROM JP_QuotationHeader__c];
            JP_TestUtil.Create_JP_QuotationTemplate();

            Test.setCurrentPage(pageRef);
            ApexPages.StandardController stdController = new ApexPages.StandardController(qh);
            JP_ProductQuotationSelectController extController = new JP_ProductQuotationSelectController(stdController);
        }
    } 

    /**
     * 仮保存見積（JP_QuotationNo__cがNullのケース）
     */
    private static testMethod void  testBadParam2(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
            Pagereference pageref = Page.JP_ProductQuotationSelect;

            JP_QuotationHeader__c qh = JP_TestUtil.Create_PreJP_QuotationHeader(-5);    
            insert qh;
            List<JP_QuotationHeader__c> qhList = [SELECT ID,JP_QuotationNo__c FROM JP_QuotationHeader__c];
            JP_TestUtil.Create_JP_QuotationTemplate();

            Test.setCurrentPage(pageRef);

            ApexPages.StandardController stdController = new ApexPages.StandardController(qh);
            JP_ProductQuotationSelectController extController = new JP_ProductQuotationSelectController(stdController);

            extController.doExecute();
        }
    } 

}