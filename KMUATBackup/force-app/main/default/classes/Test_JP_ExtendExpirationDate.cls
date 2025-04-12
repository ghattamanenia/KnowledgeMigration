@isTest
private class Test_JP_ExtendExpirationDate {
    private static User user;
    private static List<JP_QuotationDistributor__c> qdList;
    private final static String SYSTEM_ADMIN = system.label.JP_SystemAdministrator_ProfileName;

    //正常系
    static testMethod void myUnitTest1() {
        Map<String, JP_DistributorPrice__c> dpMap = new Map<String, JP_DistributorPrice__c>();
        List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
        List<JP_CustomerInfo2__c> ci2List = new List<JP_CustomerInfo2__c>();
        Date day = system.today();
        List<JP_SpecailPriceApprove__c> spaList = new List<JP_SpecailPriceApprove__c>();
        List<String> pcList = new List<String>();
        pcList.add('JP_ATKK_Product');
        pcList.add('JP_PartnerProduct');
        pcList.add('JP_MaintenanceProduct');

        // テストデータ作成
        createData();
        List<JP_QuotationDistributor__c> qd = JP_TestUtil.Create_JP_QuotationDistributor();
        List<JP_QuotationHeader__c> qhlist = JP_TestUtil.Create_JP_QuotationHeader(1);
        qhlist[0].JP_QuotationDistCD__c = qd[0].Id;
        //qhlist[0].JP_QuotationNo__c = '789456';
        insert qhlist;
        
        spaList = JP_TestUtil.Create_JP_SpecailPriceApprove(qhList[0],3);
        for(Integer i=0; i < spaList.size(); i++){
            spaList[i].JP_SpecailPriceEndDate__c = system.today().addDays(60-i);
            spaList[i].JP_ProductClassification__c = pcList[i];
        }
        insert spaList;
        
        JP_ApprovalProcessMaster__c apm = JP_TestUtil.Create_JP_ApprovalProcessMaster(1);
        JP_DecideApprovalProcess__c dap = new JP_DecideApprovalProcess__c();
        dap.JP_ApprovalProcessMaster__c = apm.Id;
        dap.JP_ChkTotalAmountCD__c = 'A1';
        dap.JP_ChkWholeSaleCD__c = 'B3';
        dap.JP_ChkLimitDiscountCD__c = 'C1';
        dap.JP_ChkRegisteredProductCD__c = 'D1';
        dap.JP_ChkQuotationExpiryDateCD__c = 'E1';
        dap.JP_ChkPreReleaseCD__c = 'F1';
        dap.JP_ChkkProductResponsibleCD__c = 'G1';
        insert dap;

        List<JP_DistributorPrice__c> dpList = JP_TestUtil.Create_JP_DistributorPrice(1);
        dpList[0].Name = '12345';
        dpList[0].JP_ProductCatalogCode__c = '20000';
        insert dpList;

        List<JP_QuotationDetail__c> detailList = JP_TestUtil.Create_JP_QuotationDetail(qhlist[0].Id,3);
        detailList[0].JP_ProductCatalogCode__c = dpList[0].JP_ProductCatalogCode__c;
        detailList[0].JP_ProductName__c = 'testProduct';
        detailList[0].JP_Sort__c = 1;
        detailList[0].JP_Quantity__c = 1;
        detailList[0].JP_SpecialUnitPrice__c = 1000;
        detailList[0].JP_WholeSalePriceMulQuantity__c = 1000;
        detailList[0].JP_SpecialUnitPriceMulQuantity__c = 1000;
        detailList[0].JP_StandardMinusSpecial__c = 1000;
        detailList[0].JP_DeterminedAmount__c = 1000;
        detailList[0].JP_PriceYearMonth__c = '201508';
        detailList[0].JP_AppGroupID__c = 'G1';
        detailList[0].JP_5PercentDiscount__c = 1200;
        detailList[0].JP_OverLimitDiscount__c = false;
        detailList[0].JP_ProductCode__c = '9999';
        detailList[0].JP_PreRelease__c = false;
        detailList[0].JP_WholeSaleRate__c = 1;
        detailList[0].JP_UnitPrice__c = 1500;
        detailList[0].JP_SpecialWholeSaleTRate__c = 0.8;
        detailList[0].JP_DiscountLimitPrice__c = 800;
        detailList[0].JP_WholeSalePriceMulQuantity__c = detailList[0].JP_UnitPrice__c * detailList[0].JP_WholeSaleRate__c;
        detailList[0].JP_SpecialUnitPriceMulQuantity__c = detailList[0].JP_SpecialUnitPrice__c * detailList[0].JP_Quantity__c;
        detailList[0].JP_StandardMinusSpecial__c = detailList[0].JP_WholeSalePriceMulQuantity__c - detailList[0].JP_SpecialUnitPriceMulQuantity__c;
        detailList[0].JP_DeterminedAmount__c = detailList[0].JP_SpecialUnitPriceMulQuantity__c;
        detailList[0].JP_PreSave__c = true;

        detailList[1].JP_ProductCatalogCode__c = dpList[0].JP_ProductCatalogCode__c;
        detailList[1].JP_ProductName__c = 'testProduct';
        detailList[1].JP_Sort__c = 2;
        detailList[1].JP_Quantity__c = 1;
        detailList[1].JP_SpecialUnitPrice__c = 1000;
        detailList[1].JP_WholeSalePriceMulQuantity__c = 1000;
        detailList[1].JP_SpecialUnitPriceMulQuantity__c = 1000;
        detailList[1].JP_StandardMinusSpecial__c = 1000;
        detailList[1].JP_DeterminedAmount__c = 1000;
        detailList[1].JP_PriceYearMonth__c = '201508';
        detailList[1].JP_AppGroupID__c = 'G1';
        detailList[1].JP_5PercentDiscount__c = 1200;
        detailList[1].JP_OverLimitDiscount__c = false;
        detailList[1].JP_ProductCode__c = '9999';
        detailList[1].JP_PreRelease__c = false;
        detailList[1].JP_WholeSaleRate__c = 1;
        detailList[1].JP_UnitPrice__c = 1500;
        detailList[1].JP_SpecialWholeSaleTRate__c = 0.8;
        detailList[1].JP_DiscountLimitPrice__c = 800;
        detailList[1].JP_WholeSalePriceMulQuantity__c = detailList[0].JP_UnitPrice__c * detailList[0].JP_WholeSaleRate__c;
        detailList[1].JP_SpecialUnitPriceMulQuantity__c = detailList[0].JP_SpecialUnitPrice__c * detailList[0].JP_Quantity__c;
        detailList[1].JP_StandardMinusSpecial__c = detailList[0].JP_WholeSalePriceMulQuantity__c - detailList[0].JP_SpecialUnitPriceMulQuantity__c;
        detailList[1].JP_DeterminedAmount__c = detailList[0].JP_SpecialUnitPriceMulQuantity__c;
        detailList[1].JP_PreSave__c = true;

        detailList[2].JP_ProductCatalogCode__c = dpList[0].JP_ProductCatalogCode__c;
        detailList[2].JP_ProductName__c = 'testProduct';
        detailList[2].JP_Sort__c = 3;
        detailList[2].JP_Quantity__c = 1;
        detailList[2].JP_SpecialUnitPrice__c = 1000;
        detailList[2].JP_WholeSalePriceMulQuantity__c = 1000;
        detailList[2].JP_SpecialUnitPriceMulQuantity__c = 1000;
        detailList[2].JP_StandardMinusSpecial__c = 1000;
        detailList[2].JP_DeterminedAmount__c = 1000;
        detailList[2].JP_PriceYearMonth__c = '201508';
        detailList[2].JP_AppGroupID__c = 'G1';
        detailList[2].JP_5PercentDiscount__c = 1200;
        detailList[2].JP_OverLimitDiscount__c = false;
        detailList[2].JP_ProductCode__c = '9999';
        detailList[2].JP_PreRelease__c = false;
        detailList[2].JP_WholeSaleRate__c = 1;
        detailList[2].JP_UnitPrice__c = 1500;
        detailList[2].JP_SpecialWholeSaleTRate__c = 0.8;
        detailList[2].JP_DiscountLimitPrice__c = 800;
        detailList[2].JP_WholeSalePriceMulQuantity__c = detailList[0].JP_UnitPrice__c * detailList[0].JP_WholeSaleRate__c;
        detailList[2].JP_SpecialUnitPriceMulQuantity__c = detailList[0].JP_SpecialUnitPrice__c * detailList[0].JP_Quantity__c;
        detailList[2].JP_StandardMinusSpecial__c = detailList[0].JP_WholeSalePriceMulQuantity__c - detailList[0].JP_SpecialUnitPriceMulQuantity__c;
        detailList[2].JP_DeterminedAmount__c = detailList[0].JP_SpecialUnitPriceMulQuantity__c;
        detailList[2].JP_PreSave__c = true;
        insert detailList;
        
        Test.startTest();
        system.debug('=== start test ===');
        JP_ExtendExpirationDateOfQuotation.CheckChange(qhList[0].Id);
        JP_ExtendExpirationDateOfQuotation.JP_ExtendExpirationDate(qhList[0].Id);
        system.debug('=== end test ===');
        Test.StopTest();
    }
    
    //チェック1テスト
    static testMethod void myUnitTest2() {
        Map<String, JP_DistributorPrice__c> dpMap = new Map<String, JP_DistributorPrice__c>();
        List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
        List<JP_CustomerInfo2__c> ci2List = new List<JP_CustomerInfo2__c>();
        Date day = system.today();
        List<JP_SpecailPriceApprove__c> spaList = new List<JP_SpecailPriceApprove__c>();
        List<String> pcList = new List<String>();
        pcList.add('JP_ATKK_Product');
        pcList.add('JP_PartnerProduct');
        pcList.add('JP_MaintenanceProduct');

        // テストデータ作成
        createData();
        List<JP_QuotationDistributor__c> qd = JP_TestUtil.Create_JP_QuotationDistributor();
        List<JP_QuotationHeader__c> qhlist = JP_TestUtil.Create_JP_QuotationHeader(1);
        qhlist[0].JP_QuotationDistCD__c = qd[0].Id;
        qhList[0].JP_QuoteOutputDate__c = Date.newInstance(2017,4,1);
        qhList[0].JP_TriggerSkipFLG__c = true;
        insert qhlist;
        
        spaList = JP_TestUtil.Create_JP_SpecailPriceApprove(qhList[0],3);
        for(Integer i=0; i < spaList.size(); i++){
            spaList[i].JP_SpecailPriceEndDate__c = Date.newInstance(2999,12,31);
            spaList[i].JP_ProductClassification__c = pcList[i];
        }
        insert spaList;
        
        JP_ApprovalProcessMaster__c apm = JP_TestUtil.Create_JP_ApprovalProcessMaster(1);
        JP_DecideApprovalProcess__c dap = new JP_DecideApprovalProcess__c();
        dap.JP_ApprovalProcessMaster__c = apm.Id;
        dap.JP_ChkTotalAmountCD__c = 'A1';
        dap.JP_ChkWholeSaleCD__c = 'B3';
        dap.JP_ChkLimitDiscountCD__c = 'C1';
        dap.JP_ChkRegisteredProductCD__c = 'D1';
        dap.JP_ChkQuotationExpiryDateCD__c = 'E1';
        dap.JP_ChkPreReleaseCD__c = 'F1';
        dap.JP_ChkkProductResponsibleCD__c = 'G1';
        insert dap;

        List<JP_DistributorPrice__c> dpList = JP_TestUtil.Create_JP_DistributorPrice(1);
        dpList[0].Name = '12345';
        dpList[0].JP_ProductCatalogCode__c = '20000';
        insert dpList;

        List<JP_QuotationDetail__c> detailList = JP_TestUtil.Create_JP_QuotationDetail(qhlist[0].Id,3);
        detailList[0].JP_ProductCatalogCode__c = dpList[0].JP_ProductCatalogCode__c;
        detailList[0].JP_ProductName__c = 'testProduct';
        detailList[0].JP_Sort__c = 1;
        detailList[0].JP_Quantity__c = 1;
        detailList[0].JP_SpecialUnitPrice__c = 1000;
        detailList[0].JP_WholeSalePriceMulQuantity__c = 1000;
        detailList[0].JP_SpecialUnitPriceMulQuantity__c = 1000;
        detailList[0].JP_StandardMinusSpecial__c = 1000;
        detailList[0].JP_DeterminedAmount__c = 1000;
        detailList[0].JP_PriceYearMonth__c = '201508';
        detailList[0].JP_AppGroupID__c = 'G1';
        detailList[0].JP_5PercentDiscount__c = 1200;
        detailList[0].JP_OverLimitDiscount__c = false;
        detailList[0].JP_ProductCode__c = '9999';
        detailList[0].JP_PreRelease__c = false;
        detailList[0].JP_WholeSaleRate__c = 1;
        detailList[0].JP_UnitPrice__c = 1500;
        detailList[0].JP_SpecialWholeSaleTRate__c = 0.8;
        detailList[0].JP_DiscountLimitPrice__c = 800;
        detailList[0].JP_WholeSalePriceMulQuantity__c = detailList[0].JP_UnitPrice__c * detailList[0].JP_WholeSaleRate__c;
        detailList[0].JP_SpecialUnitPriceMulQuantity__c = detailList[0].JP_SpecialUnitPrice__c * detailList[0].JP_Quantity__c;
        detailList[0].JP_StandardMinusSpecial__c = detailList[0].JP_WholeSalePriceMulQuantity__c - detailList[0].JP_SpecialUnitPriceMulQuantity__c;
        detailList[0].JP_DeterminedAmount__c = detailList[0].JP_SpecialUnitPriceMulQuantity__c;
        detailList[0].JP_PreSave__c = true;

        detailList[1].JP_ProductCatalogCode__c = dpList[0].JP_ProductCatalogCode__c;
        detailList[1].JP_ProductName__c = 'testProduct';
        detailList[1].JP_Sort__c = 2;
        detailList[1].JP_Quantity__c = 1;
        detailList[1].JP_SpecialUnitPrice__c = 1000;
        detailList[1].JP_WholeSalePriceMulQuantity__c = 1000;
        detailList[1].JP_SpecialUnitPriceMulQuantity__c = 1000;
        detailList[1].JP_StandardMinusSpecial__c = 1000;
        detailList[1].JP_DeterminedAmount__c = 1000;
        detailList[1].JP_PriceYearMonth__c = '201508';
        detailList[1].JP_AppGroupID__c = 'G1';
        detailList[1].JP_5PercentDiscount__c = 1200;
        detailList[1].JP_OverLimitDiscount__c = false;
        detailList[1].JP_ProductCode__c = '9999';
        detailList[1].JP_PreRelease__c = false;
        detailList[1].JP_WholeSaleRate__c = 1;
        detailList[1].JP_UnitPrice__c = 1500;
        detailList[1].JP_SpecialWholeSaleTRate__c = 0.8;
        detailList[1].JP_DiscountLimitPrice__c = 800;
        detailList[1].JP_WholeSalePriceMulQuantity__c = detailList[0].JP_UnitPrice__c * detailList[0].JP_WholeSaleRate__c;
        detailList[1].JP_SpecialUnitPriceMulQuantity__c = detailList[0].JP_SpecialUnitPrice__c * detailList[0].JP_Quantity__c;
        detailList[1].JP_StandardMinusSpecial__c = detailList[0].JP_WholeSalePriceMulQuantity__c - detailList[0].JP_SpecialUnitPriceMulQuantity__c;
        detailList[1].JP_DeterminedAmount__c = detailList[0].JP_SpecialUnitPriceMulQuantity__c;
        detailList[1].JP_PreSave__c = true;

        detailList[2].JP_ProductCatalogCode__c = dpList[0].JP_ProductCatalogCode__c;
        detailList[2].JP_ProductName__c = 'testProduct';
        detailList[2].JP_Sort__c = 3;
        detailList[2].JP_Quantity__c = 1;
        detailList[2].JP_SpecialUnitPrice__c = 1000;
        detailList[2].JP_WholeSalePriceMulQuantity__c = 1000;
        detailList[2].JP_SpecialUnitPriceMulQuantity__c = 1000;
        detailList[2].JP_StandardMinusSpecial__c = 1000;
        detailList[2].JP_DeterminedAmount__c = 1000;
        detailList[2].JP_PriceYearMonth__c = '201508';
        detailList[2].JP_AppGroupID__c = 'G1';
        detailList[2].JP_5PercentDiscount__c = 1200;
        detailList[2].JP_OverLimitDiscount__c = false;
        detailList[2].JP_ProductCode__c = '9999';
        detailList[2].JP_PreRelease__c = false;
        detailList[2].JP_WholeSaleRate__c = 1;
        detailList[2].JP_UnitPrice__c = 1500;
        detailList[2].JP_SpecialWholeSaleTRate__c = 0.8;
        detailList[2].JP_DiscountLimitPrice__c = 800;
        detailList[2].JP_WholeSalePriceMulQuantity__c = detailList[0].JP_UnitPrice__c * detailList[0].JP_WholeSaleRate__c;
        detailList[2].JP_SpecialUnitPriceMulQuantity__c = detailList[0].JP_SpecialUnitPrice__c * detailList[0].JP_Quantity__c;
        detailList[2].JP_StandardMinusSpecial__c = detailList[0].JP_WholeSalePriceMulQuantity__c - detailList[0].JP_SpecialUnitPriceMulQuantity__c;
        detailList[2].JP_DeterminedAmount__c = detailList[0].JP_SpecialUnitPriceMulQuantity__c;
        detailList[2].JP_PreSave__c = true;
        insert detailList;
        
        Test.startTest();
        system.debug('=== start test ===');
        JP_ExtendExpirationDateOfQuotation.CheckChange(qhList[0].Id);
        JP_ExtendExpirationDateOfQuotation.JP_ExtendExpirationDate(qhList[0].Id);
        system.debug('=== end test ===');
        Test.StopTest();
    }
    
    //チェック2テスト
    static testMethod void myUnitTest3() {
        Map<String, JP_DistributorPrice__c> dpMap = new Map<String, JP_DistributorPrice__c>();
        List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
        List<JP_CustomerInfo2__c> ci2List = new List<JP_CustomerInfo2__c>();
        Date day = system.today();
        List<JP_SpecailPriceApprove__c> spaList = new List<JP_SpecailPriceApprove__c>();
        List<String> pcList = new List<String>();
        pcList.add('JP_ATKK_Product');
        pcList.add('JP_PartnerProduct');
        pcList.add('JP_MaintenanceProduct');

        // テストデータ作成
        createData();
        List<JP_QuotationDistributor__c> qd = JP_TestUtil.Create_JP_QuotationDistributor();
        List<JP_QuotationHeader__c> qhlist = JP_TestUtil.Create_JP_QuotationHeader(1);
        qhlist[0].JP_QuotationDistCD__c = qd[0].Id;
        qhList[0].JP_QuoteOutputDate__c = system.today();
        qhList[0].JP_TriggerSkipFLG__c = true;
        insert qhlist;
        
        spaList = JP_TestUtil.Create_JP_SpecailPriceApprove(qhList[0],3);
        for(Integer i=0; i < spaList.size(); i++){
            spaList[i].JP_SpecailPriceEndDate__c = system.today().addDays(30-i);
            spaList[i].JP_ProductClassification__c = pcList[i];
        }
        insert spaList;
        
        JP_ApprovalProcessMaster__c apm = JP_TestUtil.Create_JP_ApprovalProcessMaster(1);
        JP_DecideApprovalProcess__c dap = new JP_DecideApprovalProcess__c();
        dap.JP_ApprovalProcessMaster__c = apm.Id;
        dap.JP_ChkTotalAmountCD__c = 'A1';
        dap.JP_ChkWholeSaleCD__c = 'B3';
        dap.JP_ChkLimitDiscountCD__c = 'C1';
        dap.JP_ChkRegisteredProductCD__c = 'D1';
        dap.JP_ChkQuotationExpiryDateCD__c = 'E1';
        dap.JP_ChkPreReleaseCD__c = 'F1';
        dap.JP_ChkkProductResponsibleCD__c = 'G1';
        insert dap;

        List<JP_DistributorPrice__c> dpList = JP_TestUtil.Create_JP_DistributorPrice(1);
        dpList[0].Name = '12345';
        dpList[0].JP_ProductCatalogCode__c = '20000';
        insert dpList;

        List<JP_QuotationDetail__c> detailList = JP_TestUtil.Create_JP_QuotationDetail(qhlist[0].Id,3);
        detailList[0].JP_ProductCatalogCode__c = dpList[0].JP_ProductCatalogCode__c;
        detailList[0].JP_ProductName__c = 'testProduct';
        detailList[0].JP_Sort__c = 1;
        detailList[0].JP_Quantity__c = 1;
        detailList[0].JP_SpecialUnitPrice__c = 1000;
        detailList[0].JP_WholeSalePriceMulQuantity__c = 1000;
        detailList[0].JP_SpecialUnitPriceMulQuantity__c = 1000;
        detailList[0].JP_StandardMinusSpecial__c = 1000;
        detailList[0].JP_DeterminedAmount__c = 1000;
        detailList[0].JP_PriceYearMonth__c = '201508';
        detailList[0].JP_AppGroupID__c = 'G1';
        detailList[0].JP_5PercentDiscount__c = 1200;
        detailList[0].JP_OverLimitDiscount__c = false;
        detailList[0].JP_ProductCode__c = '9999';
        detailList[0].JP_PreRelease__c = false;
        detailList[0].JP_WholeSaleRate__c = 1;
        detailList[0].JP_UnitPrice__c = 1500;
        detailList[0].JP_SpecialWholeSaleTRate__c = 0.8;
        detailList[0].JP_DiscountLimitPrice__c = 800;
        detailList[0].JP_WholeSalePriceMulQuantity__c = detailList[0].JP_UnitPrice__c * detailList[0].JP_WholeSaleRate__c;
        detailList[0].JP_SpecialUnitPriceMulQuantity__c = detailList[0].JP_SpecialUnitPrice__c * detailList[0].JP_Quantity__c;
        detailList[0].JP_StandardMinusSpecial__c = detailList[0].JP_WholeSalePriceMulQuantity__c - detailList[0].JP_SpecialUnitPriceMulQuantity__c;
        detailList[0].JP_DeterminedAmount__c = detailList[0].JP_SpecialUnitPriceMulQuantity__c;
        detailList[0].JP_PreSave__c = true;

        detailList[1].JP_ProductCatalogCode__c = dpList[0].JP_ProductCatalogCode__c;
        detailList[1].JP_ProductName__c = 'testProduct';
        detailList[1].JP_Sort__c = 2;
        detailList[1].JP_Quantity__c = 1;
        detailList[1].JP_SpecialUnitPrice__c = 1000;
        detailList[1].JP_WholeSalePriceMulQuantity__c = 1000;
        detailList[1].JP_SpecialUnitPriceMulQuantity__c = 1000;
        detailList[1].JP_StandardMinusSpecial__c = 1000;
        detailList[1].JP_DeterminedAmount__c = 1000;
        detailList[1].JP_PriceYearMonth__c = '201508';
        detailList[1].JP_AppGroupID__c = 'G1';
        detailList[1].JP_5PercentDiscount__c = 1200;
        detailList[1].JP_OverLimitDiscount__c = false;
        detailList[1].JP_ProductCode__c = '9999';
        detailList[1].JP_PreRelease__c = false;
        detailList[1].JP_WholeSaleRate__c = 1;
        detailList[1].JP_UnitPrice__c = 1500;
        detailList[1].JP_SpecialWholeSaleTRate__c = 0.8;
        detailList[1].JP_DiscountLimitPrice__c = 800;
        detailList[1].JP_WholeSalePriceMulQuantity__c = detailList[0].JP_UnitPrice__c * detailList[0].JP_WholeSaleRate__c;
        detailList[1].JP_SpecialUnitPriceMulQuantity__c = detailList[0].JP_SpecialUnitPrice__c * detailList[0].JP_Quantity__c;
        detailList[1].JP_StandardMinusSpecial__c = detailList[0].JP_WholeSalePriceMulQuantity__c - detailList[0].JP_SpecialUnitPriceMulQuantity__c;
        detailList[1].JP_DeterminedAmount__c = detailList[0].JP_SpecialUnitPriceMulQuantity__c;
        detailList[1].JP_PreSave__c = true;

        detailList[2].JP_ProductCatalogCode__c = dpList[0].JP_ProductCatalogCode__c;
        detailList[2].JP_ProductName__c = 'testProduct';
        detailList[2].JP_Sort__c = 3;
        detailList[2].JP_Quantity__c = 1;
        detailList[2].JP_SpecialUnitPrice__c = 1000;
        detailList[2].JP_WholeSalePriceMulQuantity__c = 1000;
        detailList[2].JP_SpecialUnitPriceMulQuantity__c = 1000;
        detailList[2].JP_StandardMinusSpecial__c = 1000;
        detailList[2].JP_DeterminedAmount__c = 1000;
        detailList[2].JP_PriceYearMonth__c = '201508';
        detailList[2].JP_AppGroupID__c = 'G1';
        detailList[2].JP_5PercentDiscount__c = 1200;
        detailList[2].JP_OverLimitDiscount__c = false;
        detailList[2].JP_ProductCode__c = '9999';
        detailList[2].JP_PreRelease__c = false;
        detailList[2].JP_WholeSaleRate__c = 1;
        detailList[2].JP_UnitPrice__c = 1500;
        detailList[2].JP_SpecialWholeSaleTRate__c = 0.8;
        detailList[2].JP_DiscountLimitPrice__c = 800;
        detailList[2].JP_WholeSalePriceMulQuantity__c = detailList[0].JP_UnitPrice__c * detailList[0].JP_WholeSaleRate__c;
        detailList[2].JP_SpecialUnitPriceMulQuantity__c = detailList[0].JP_SpecialUnitPrice__c * detailList[0].JP_Quantity__c;
        detailList[2].JP_StandardMinusSpecial__c = detailList[0].JP_WholeSalePriceMulQuantity__c - detailList[0].JP_SpecialUnitPriceMulQuantity__c;
        detailList[2].JP_DeterminedAmount__c = detailList[0].JP_SpecialUnitPriceMulQuantity__c;
        detailList[2].JP_PreSave__c = true;
        insert detailList;
        
        Test.startTest();
        system.debug('=== start test ===');
        JP_ExtendExpirationDateOfQuotation.CheckChange(qhList[0].Id);
        JP_ExtendExpirationDateOfQuotation.JP_ExtendExpirationDate(qhList[0].Id);
        system.debug('=== end test ===');
        Test.StopTest();
    }
    
   /*  //チェック3テスト
    static testMethod void myUnitTest4() {
        Map<String, JP_DistributorPrice__c> dpMap = new Map<String, JP_DistributorPrice__c>();
        List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
        List<JP_CustomerInfo2__c> ci2List = new List<JP_CustomerInfo2__c>();
        Date day = system.today();
        List<JP_SpecailPriceApprove__c> spaList = new List<JP_SpecailPriceApprove__c>();
        List<String> pcList = new List<String>();
        pcList.add('JP_ATKK_Product');
        pcList.add('JP_PartnerProduct');
        pcList.add('JP_MaintenanceProduct');

        // テストデータ作成
        createData();
        List<JP_QuotationDistributor__c> qd = JP_TestUtil.Create_JP_QuotationDistributor();
        List<JP_QuotationHeader__c> qhlist = JP_TestUtil.Create_JP_QuotationHeader(1);
        qhlist[0].JP_QuotationDistCD__c = qd[0].Id;
        qhList[0].JP_QuoteOutputDate__c = system.today();
        qhList[0].JP_TriggerSkipFLG__c = true;
        insert qhlist;
        
        spaList = JP_TestUtil.Create_JP_SpecailPriceApprove(qhList[0],3);
        for(Integer i=0; i < spaList.size(); i++){
            spaList[i].JP_SpecailPriceEndDate__c = system.today().addDays(60-i);
            spaList[i].JP_ProductClassification__c = pcList[i];
        }
        insert spaList;
        
        JP_ApprovalProcessMaster__c apm = JP_TestUtil.Create_JP_ApprovalProcessMaster(1);
        JP_DecideApprovalProcess__c dap = new JP_DecideApprovalProcess__c();
        dap.JP_ApprovalProcessMaster__c = apm.Id;
        dap.JP_ChkTotalAmountCD__c = 'A1';
        dap.JP_ChkWholeSaleCD__c = 'B3';
        dap.JP_ChkLimitDiscountCD__c = 'C1';
        dap.JP_ChkRegisteredProductCD__c = 'D1';
        dap.JP_ChkQuotationExpiryDateCD__c = 'E1';
        dap.JP_ChkPreReleaseCD__c = 'F1';
        dap.JP_ChkkProductResponsibleCD__c = 'G1';
        insert dap;

        List<JP_DistributorPrice__c> dpList = JP_TestUtil.Create_JP_DistributorPrice(1);
        dpList[0].Name = '12345';
        dpList[0].JP_ProductCatalogCode__c = '20000';
        dpList[0].JP_WholeSalePrice__c = 1800;
        dpList[0].JP_Price_List_Type__c = '11';
        dpList[0].JP_PriceYearMonth__c = 'JP ' + String.valueOf(system.today().year()) + '/0' + String.valueOf(system.today().month());
        dpList[0].JP_SearchItemKey1__c = dpList[0].JP_Price_List_Type__c + '_' + dpList[0].JP_ProductCatalogCode__c;
        dpList[0].JP_SearchItemKey2__c = dpList[0].JP_Price_List_Type__c + '_' + dpList[0].JP_PriceYearMonth__c;
        dpList[0].JP_OutputableQuotation__c = true;
        insert dpList;

        List<JP_QuotationDetail__c> detailList = JP_TestUtil.Create_JP_QuotationDetail(qhlist[0].Id,3);
        detailList[0].JP_ProductCatalogCode__c = dpList[0].JP_ProductCatalogCode__c;
        detailList[0].JP_ProductName__c = 'testProduct';
        detailList[0].JP_Sort__c = 1;
        detailList[0].JP_Quantity__c = 1;
        detailList[0].JP_SpecialUnitPrice__c = 1000;
        detailList[0].JP_WholeSalePriceMulQuantity__c = 1000;
        detailList[0].JP_SpecialUnitPriceMulQuantity__c = 1000;
        detailList[0].JP_StandardMinusSpecial__c = 1000;
        detailList[0].JP_DeterminedAmount__c = 1000;
        detailList[0].JP_PriceYearMonth__c = '201508';
        detailList[0].JP_AppGroupID__c = 'G1';
        detailList[0].JP_5PercentDiscount__c = 1200;
        detailList[0].JP_OverLimitDiscount__c = false;
        detailList[0].JP_ProductCode__c = '9999';
        detailList[0].JP_PreRelease__c = false;
        detailList[0].JP_WholeSaleRate__c = 1;
        detailList[0].JP_UnitPrice__c = 1500;
        detailList[0].JP_SpecialWholeSaleTRate__c = 0.8;
        detailList[0].JP_DiscountLimitPrice__c = 800;
        detailList[0].JP_WholeSalePriceMulQuantity__c = detailList[0].JP_UnitPrice__c * detailList[0].JP_WholeSaleRate__c;
        detailList[0].JP_SpecialUnitPriceMulQuantity__c = detailList[0].JP_SpecialUnitPrice__c * detailList[0].JP_Quantity__c;
        detailList[0].JP_StandardMinusSpecial__c = detailList[0].JP_WholeSalePriceMulQuantity__c - detailList[0].JP_SpecialUnitPriceMulQuantity__c;
        detailList[0].JP_DeterminedAmount__c = detailList[0].JP_SpecialUnitPriceMulQuantity__c;
        detailList[0].JP_PreSave__c = true;

        detailList[1].JP_ProductCatalogCode__c = dpList[0].JP_ProductCatalogCode__c;
        detailList[1].JP_ProductName__c = 'testProduct';
        detailList[1].JP_Sort__c = 2;
        detailList[1].JP_Quantity__c = 1;
        detailList[1].JP_SpecialUnitPrice__c = 1000;
        detailList[1].JP_WholeSalePriceMulQuantity__c = 1000;
        detailList[1].JP_SpecialUnitPriceMulQuantity__c = 1000;
        detailList[1].JP_StandardMinusSpecial__c = 1000;
        detailList[1].JP_DeterminedAmount__c = 1000;
        detailList[1].JP_PriceYearMonth__c = '201508';
        detailList[1].JP_AppGroupID__c = 'G1';
        detailList[1].JP_5PercentDiscount__c = 1200;
        detailList[1].JP_OverLimitDiscount__c = false;
        detailList[1].JP_ProductCode__c = '9999';
        detailList[1].JP_PreRelease__c = false;
        detailList[1].JP_WholeSaleRate__c = 1;
        detailList[1].JP_UnitPrice__c = 1500;
        detailList[1].JP_SpecialWholeSaleTRate__c = 0.8;
        detailList[1].JP_DiscountLimitPrice__c = 800;
        detailList[1].JP_WholeSalePriceMulQuantity__c = detailList[0].JP_UnitPrice__c * detailList[0].JP_WholeSaleRate__c;
        detailList[1].JP_SpecialUnitPriceMulQuantity__c = detailList[0].JP_SpecialUnitPrice__c * detailList[0].JP_Quantity__c;
        detailList[1].JP_StandardMinusSpecial__c = detailList[0].JP_WholeSalePriceMulQuantity__c - detailList[0].JP_SpecialUnitPriceMulQuantity__c;
        detailList[1].JP_DeterminedAmount__c = detailList[0].JP_SpecialUnitPriceMulQuantity__c;
        detailList[1].JP_PreSave__c = true;

        detailList[2].JP_ProductCatalogCode__c = dpList[0].JP_ProductCatalogCode__c;
        detailList[2].JP_ProductName__c = 'testProduct';
        detailList[2].JP_Sort__c = 3;
        detailList[2].JP_Quantity__c = 1;
        detailList[2].JP_SpecialUnitPrice__c = 1000;
        detailList[2].JP_WholeSalePriceMulQuantity__c = 1000;
        detailList[2].JP_SpecialUnitPriceMulQuantity__c = 1000;
        detailList[2].JP_StandardMinusSpecial__c = 1000;
        detailList[2].JP_DeterminedAmount__c = 1000;
        detailList[2].JP_PriceYearMonth__c = '201508';
        detailList[2].JP_AppGroupID__c = 'G1';
        detailList[2].JP_5PercentDiscount__c = 1200;
        detailList[2].JP_OverLimitDiscount__c = false;
        detailList[2].JP_ProductCode__c = '9999';
        detailList[2].JP_PreRelease__c = false;
        detailList[2].JP_WholeSaleRate__c = 1;
        detailList[2].JP_UnitPrice__c = 1500;
        detailList[2].JP_SpecialWholeSaleTRate__c = 0.8;
        detailList[2].JP_DiscountLimitPrice__c = 800;
        detailList[2].JP_WholeSalePriceMulQuantity__c = detailList[0].JP_UnitPrice__c * detailList[0].JP_WholeSaleRate__c;
        detailList[2].JP_SpecialUnitPriceMulQuantity__c = detailList[0].JP_SpecialUnitPrice__c * detailList[0].JP_Quantity__c;
        detailList[2].JP_StandardMinusSpecial__c = detailList[0].JP_WholeSalePriceMulQuantity__c - detailList[0].JP_SpecialUnitPriceMulQuantity__c;
        detailList[2].JP_DeterminedAmount__c = detailList[0].JP_SpecialUnitPriceMulQuantity__c;
        detailList[2].JP_PreSave__c = true;
        insert detailList;
        
        Test.startTest();
        system.debug('=== start test ===');
        JP_ExtendExpirationDateOfQuotation.CheckChange(qhList[0].Id);
        JP_ExtendExpirationDateOfQuotation.JP_ExtendExpirationDate(qhList[0].Id);
        system.debug('=== end test ===');
        Test.StopTest();
    }
    
    //チェック3テスト
    static testMethod void myUnitTest5() {
        Map<String, JP_DistributorPrice__c> dpMap = new Map<String, JP_DistributorPrice__c>();
        List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
        List<JP_CustomerInfo2__c> ci2List = new List<JP_CustomerInfo2__c>();
        Date day = system.today();
        List<JP_SpecailPriceApprove__c> spaList = new List<JP_SpecailPriceApprove__c>();
        List<String> pcList = new List<String>();
        pcList.add('JP_ATKK_Product');
        pcList.add('JP_PartnerProduct');
        pcList.add('JP_MaintenanceProduct');

        // テストデータ作成
        createData();
        List<JP_QuotationDistributor__c> qd = JP_TestUtil.Create_JP_QuotationDistributor();
        List<JP_QuotationHeader__c> qhlist = JP_TestUtil.Create_JP_QuotationHeader(1);
        qhlist[0].JP_QuotationDistCD__c = qd[0].Id;
        qhList[0].JP_QuoteOutputDate__c = system.today();
        qhList[0].JP_TriggerSkipFLG__c = true;
        insert qhlist;
        
        spaList = JP_TestUtil.Create_JP_SpecailPriceApprove(qhList[0],3);
        for(Integer i=0; i < spaList.size(); i++){
            spaList[i].JP_SpecailPriceEndDate__c = system.today().addDays(60-i);
            spaList[i].JP_ProductClassification__c = pcList[i];
        }
        insert spaList;
        
        JP_ApprovalProcessMaster__c apm = JP_TestUtil.Create_JP_ApprovalProcessMaster(1);
        JP_DecideApprovalProcess__c dap = new JP_DecideApprovalProcess__c();
        dap.JP_ApprovalProcessMaster__c = apm.Id;
        dap.JP_ChkTotalAmountCD__c = 'A1';
        dap.JP_ChkWholeSaleCD__c = 'B3';
        dap.JP_ChkLimitDiscountCD__c = 'C1';
        dap.JP_ChkRegisteredProductCD__c = 'D1';
        dap.JP_ChkQuotationExpiryDateCD__c = 'E1';
        dap.JP_ChkPreReleaseCD__c = 'F1';
        dap.JP_ChkkProductResponsibleCD__c = 'G1';
        insert dap;

        List<JP_DistributorPrice__c> dpList = JP_TestUtil.Create_JP_DistributorPrice(1);
        dpList[0].Name = '12345';
        dpList[0].JP_ProductCatalogCode__c = '20000';
        dpList[0].JP_WholeSalePrice__c = 1800;
        dpList[0].JP_Price_List_Type__c = '11';
        dpList[0].JP_PriceYearMonth__c = 'JP ' + String.valueOf(system.today().year()) + '/0' + String.valueOf(system.today().month());
        dpList[0].JP_SearchItemKey1__c = dpList[0].JP_Price_List_Type__c + '_' + dpList[0].JP_ProductCatalogCode__c;
        dpList[0].JP_SearchItemKey2__c = dpList[0].JP_Price_List_Type__c + '_' + dpList[0].JP_PriceYearMonth__c;
        dpList[0].JP_OutputableQuotation__c = true;
        insert dpList;

        List<JP_QuotationDetail__c> detailList = JP_TestUtil.Create_JP_QuotationDetail(qhlist[0].Id,3);
        detailList[0].JP_ProductCatalogCode__c = dpList[0].JP_ProductCatalogCode__c;
        detailList[0].JP_ProductName__c = 'testProduct';
        detailList[0].JP_Sort__c = 1;
        detailList[0].JP_Quantity__c = 1;
        detailList[0].JP_SpecialUnitPrice__c = 1000;
        detailList[0].JP_WholeSalePriceMulQuantity__c = 1000;
        detailList[0].JP_SpecialUnitPriceMulQuantity__c = 1000;
        detailList[0].JP_StandardMinusSpecial__c = 1000;
        detailList[0].JP_DeterminedAmount__c = 1000;
        detailList[0].JP_PriceYearMonth__c = '201508';
        detailList[0].JP_AppGroupID__c = 'G1';
        detailList[0].JP_5PercentDiscount__c = 1200;
        detailList[0].JP_OverLimitDiscount__c = false;
        detailList[0].JP_ProductCode__c = '9999';
        detailList[0].JP_PreRelease__c = false;
        detailList[0].JP_WholeSaleRate__c = 1;
        detailList[0].JP_UnitPrice__c = 1500;
        detailList[0].JP_SpecialWholeSaleTRate__c = 0.8;
        detailList[0].JP_DiscountLimitPrice__c = 800;
        detailList[0].JP_WholeSalePriceMulQuantity__c = detailList[0].JP_UnitPrice__c * detailList[0].JP_WholeSaleRate__c;
        detailList[0].JP_SpecialUnitPriceMulQuantity__c = detailList[0].JP_SpecialUnitPrice__c * detailList[0].JP_Quantity__c;
        detailList[0].JP_StandardMinusSpecial__c = detailList[0].JP_WholeSalePriceMulQuantity__c - detailList[0].JP_SpecialUnitPriceMulQuantity__c;
        detailList[0].JP_DeterminedAmount__c = detailList[0].JP_SpecialUnitPriceMulQuantity__c;
        detailList[0].JP_PreSave__c = true;

        detailList[1].JP_ProductCatalogCode__c = dpList[0].JP_ProductCatalogCode__c;
        detailList[1].JP_ProductName__c = 'testProduct';
        detailList[1].JP_Sort__c = 2;
        detailList[1].JP_Quantity__c = 1;
        detailList[1].JP_SpecialUnitPrice__c = 1000;
        detailList[1].JP_WholeSalePriceMulQuantity__c = 1000;
        detailList[1].JP_SpecialUnitPriceMulQuantity__c = 1000;
        detailList[1].JP_StandardMinusSpecial__c = 1000;
        detailList[1].JP_DeterminedAmount__c = 1000;
        detailList[1].JP_PriceYearMonth__c = '201508';
        detailList[1].JP_AppGroupID__c = 'G1';
        detailList[1].JP_5PercentDiscount__c = 1200;
        detailList[1].JP_OverLimitDiscount__c = false;
        detailList[1].JP_ProductCode__c = '9999';
        detailList[1].JP_PreRelease__c = false;
        detailList[1].JP_WholeSaleRate__c = 1;
        detailList[1].JP_UnitPrice__c = 1500;
        detailList[1].JP_SpecialWholeSaleTRate__c = 0.8;
        detailList[1].JP_DiscountLimitPrice__c = 800;
        detailList[1].JP_WholeSalePriceMulQuantity__c = detailList[0].JP_UnitPrice__c * detailList[0].JP_WholeSaleRate__c;
        detailList[1].JP_SpecialUnitPriceMulQuantity__c = detailList[0].JP_SpecialUnitPrice__c * detailList[0].JP_Quantity__c;
        detailList[1].JP_StandardMinusSpecial__c = detailList[0].JP_WholeSalePriceMulQuantity__c - detailList[0].JP_SpecialUnitPriceMulQuantity__c;
        detailList[1].JP_DeterminedAmount__c = detailList[0].JP_SpecialUnitPriceMulQuantity__c;
        detailList[1].JP_PreSave__c = true;

        detailList[2].JP_ProductCatalogCode__c = dpList[0].JP_ProductCatalogCode__c;
        detailList[2].JP_ProductName__c = 'testProduct';
        detailList[2].JP_Sort__c = 3;
        detailList[2].JP_Quantity__c = 1;
        detailList[2].JP_SpecialUnitPrice__c = 1000;
        detailList[2].JP_WholeSalePriceMulQuantity__c = 1000;
        detailList[2].JP_SpecialUnitPriceMulQuantity__c = 1000;
        detailList[2].JP_StandardMinusSpecial__c = 1000;
        detailList[2].JP_DeterminedAmount__c = 1000;
        detailList[2].JP_PriceYearMonth__c = '201508';
        detailList[2].JP_AppGroupID__c = 'G1';
        detailList[2].JP_5PercentDiscount__c = 1200;
        detailList[2].JP_OverLimitDiscount__c = false;
        detailList[2].JP_ProductCode__c = '9999';
        detailList[2].JP_PreRelease__c = false;
        detailList[2].JP_WholeSaleRate__c = 1;
        detailList[2].JP_UnitPrice__c = 1500;
        detailList[2].JP_SpecialWholeSaleTRate__c = 0.8;
        detailList[2].JP_DiscountLimitPrice__c = 800;
        detailList[2].JP_WholeSalePriceMulQuantity__c = detailList[0].JP_UnitPrice__c * detailList[0].JP_WholeSaleRate__c;
        detailList[2].JP_SpecialUnitPriceMulQuantity__c = detailList[0].JP_SpecialUnitPrice__c * detailList[0].JP_Quantity__c;
        detailList[2].JP_StandardMinusSpecial__c = detailList[0].JP_WholeSalePriceMulQuantity__c - detailList[0].JP_SpecialUnitPriceMulQuantity__c;
        detailList[2].JP_DeterminedAmount__c = detailList[0].JP_SpecialUnitPriceMulQuantity__c;
        detailList[2].JP_PreSave__c = true;
        insert detailList;
        
        Integer revision;
        
        JP_QuotationHeader__c qh = [select Id,Name,JP_QuotationNo__c from JP_QuotationHeader__c where Id = :qhlist[0].Id];
        
        String strPrefix = qh.JP_QuotationNo__c;
        List<JP_QuoationChangesEexpirationDate__c> qcedList = new List<JP_QuoationChangesEexpirationDate__c>();
        
        for(Integer i = 0; i < 90; i++){
            JP_QuoationChangesEexpirationDate__c qce = new JP_QuoationChangesEexpirationDate__c();
            if(qcedList.size() > 0){
                system.debug('*** 既存 ***');
                revision = qh.Name.charAt(11);
                revision++;
                system.debug('*** revision : ' + revision);
                
                if(revision > 90){
                    // リビジョンが Z を超える場合
                    //エラーメッセージ JP_QuotationNo over Z
                    qce.addError(System.Label.JP_ErrorMessageQuotationHeaderOverZ);     
                           
                } else {
                    String strRevision = String.fromCharArray( new List<integer> { revision } );
                    qce.Name = strPrefix + strRevision;
                }
            }else{
                system.debug('*** 新規 ***');
                qce.Name = strPrefix + 'A';
            }
            
            qcedList.add(qce);
        }
        insert qcedList;
        
        Test.startTest();
        system.debug('=== start test ===');
        JP_ExtendExpirationDateOfQuotation.CheckChange(qhList[0].Id);
        JP_ExtendExpirationDateOfQuotation.JP_ExtendExpirationDate(qhList[0].Id);
        system.debug('=== end test ===');
        Test.StopTest();
    } */
        
    /*テストデータ作成*/
    public static void createData(){
        //ユーザ作成
        Profile profile = [Select Id, Name From Profile Where Name = :SYSTEM_ADMIN Limit 1];
        user = new User(
                  Lastname = 'tstest'
                , Username = 'tstest@terrasky.atkk'
                , Email = 'tstest@terrasky.atkktesting'
                , ProfileId = profile.Id
                , Alias = 'tstest'
                , TimeZoneSidKey = UserInfo.getTimeZone().getID()
                , LocaleSidKey = UserInfo.getLocale()
                , EmailEncodingKey = 'UTF-8'
                , LanguageLocaleKey = 'ja'
                , JP_DeptCode__c = '00001'
        );
        insert user;

        JP_TestUtil.Create_JP_Department();
        JP_TestUtil.Create_JP_QuotationCondition();
    }
    
    private static Pagereference getPageReference(){
        return new PageReference('JP_QuotationEdit');
    }
}