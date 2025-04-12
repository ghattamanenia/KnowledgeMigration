@isTest
private class Test_JP_QuotationHeaderController {
    private static User user;
    private static List<JP_QuotationDistributor__c> qdList;
    private final static String SYSTEM_ADMIN = system.label.JP_SystemAdministrator_ProfileName;

    /*コントローラの初期表示１*/
    private static testMethod void testJP_QuotationHeaderController1(){
        // テストデータ作成
        createData();
        qdList = JP_TestUtil.Create_JP_QuotationDistributor();

        system.runAs(user){
            JP_QuotationHeader__c rec = new JP_QuotationHeader__c();

            PageReference pref = getPageReference();
            System.Test.setCurrentPage(pref);
            ApexPages.currentPage().getParameters().put('retURL',qdList[0].id);
            ApexPages.currentPage().getParameters().put('distributorId',qdList[0].id);
            ApexPages.currentPage().getParameters().put('spotflg', '0');

            System.Test.startTest();

            Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
            JP_QuotationHeaderController jph = new JP_QuotationHeaderController(sc);

            System.Test.stopTest();
        }
    }

    /*コントローラの初期表示２*/
    private static testMethod void testJP_QuotationHeaderController2(){
        // テストデータ作成
        createData();
        qdList = JP_TestUtil.Create_JP_QuotationDistributor();

        system.runAs(user){
            JP_QuotationHeader__c rec = new JP_QuotationHeader__c();

            PageReference pref = Page.JP_QuotationEdit;
            System.Test.setCurrentPage(pref);

            ApexPages.currentPage().getParameters().put('retURL',qdList[0].id);
            ApexPages.currentPage().getParameters().put('distributorId',qdList[0].id);
            ApexPages.currentPage().getParameters().put('spotflg', '1');

            System.Test.startTest();

            Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
            JP_QuotationHeaderController jph = new JP_QuotationHeaderController(sc);

            System.Test.stopTest();
        }

    }

    /*コントローラの初期表示3*/
    private static testMethod void testJP_QuotationHeaderController3(){
        // テストデータ作成
        createData();
        List<JP_QuotationDistributor__c> qd = JP_TestUtil.Create_JP_QuotationDistributor();
        List<JP_QuotationHeader__c> qhlist = JP_TestUtil.Create_JP_QuotationHeader(1);
        qhlist[0].JP_QuotationDistCD__c = qd[0].Id;
        qhList[0].JP_QuotationEffectiveTerm__c = '999';
        qhList[0].JP_AllowMixOfPriceYearMonth__c = false;
        //qhlist[0].JP_QuotationNo__c = '789456';
        insert qhlist;
        
        JP_ApprovalProcessMaster__c apm = JP_TestUtil.Create_JP_ApprovalProcessMaster(1);
        JP_DecideApprovalProcess__c dap = new JP_DecideApprovalProcess__c();
        dap.JP_ApprovalProcessMaster__c = apm.Id;
        dap.JP_ChkTotalAmountCD__c = 'A1';
        dap.JP_ChkWholeSaleCD__c = 'B3';
        dap.JP_ChkLimitDiscountCD__c = 'C1';
        dap.JP_ChkRegisteredProductCD__c = 'D1';
        dap.JP_ChkQuotationExpiryDateCD__c = 'E2';
        dap.JP_ChkPreReleaseCD__c = 'F2';
        dap.JP_ChkkProductResponsibleCD__c = 'G1G2G3';
        insert dap;

        List<JP_DistributorPrice__c> dpList = new List<JP_DistributorPrice__c>();
        JP_DistributorPrice__c dp = new JP_DistributorPrice__c();
        dp.Name = '12345';
        dp.JP_ProductCatalogCode__c = '20000';
        dp.JP_Price_List_Type__c  = '01';
        dp.JP_PriceYearMonth__c = 'JP 2015/10';
        dp.JP_WholeSaleKey__c = dp.JP_Price_List_Type__c + '_' + dp.JP_ProductCatalogCode__c + '_' + dp.JP_PriceYearMonth__c;
        dpList.add(dp);
        insert dpList;

        List<JP_QuotationDetail__c> detailList = JP_TestUtil.Create_JP_QuotationDetail(qhlist[0].Id,3);
        detailList[0].JP_QuotationHeader__c = qhList[0].Id;
        detailList[0].JP_ProductCatalogCode__c = dpList[0].JP_ProductCatalogCode__c;
        detailList[0].JP_ProductName__c = 'testProduct';
        detailList[0].JP_Sort__c = 1;
        detailList[0].JP_Quantity__c = 1;
        detailList[0].JP_SpecialUnitPrice__c = 1000;
        detailList[0].JP_WholeSalePriceMulQuantity__c = 1000;
        detailList[0].JP_SpecialUnitPriceMulQuantity__c = 1000;
        detailList[0].JP_StandardMinusSpecial__c = 1000;
        detailList[0].JP_DeterminedAmount__c = 1000;
        detailList[0].JP_PriceYearMonth__c = 'JP 2015/10';
        detailList[0].JP_AppGroupID__c = 'G1';
        detailList[0].JP_5PercentDiscount__c = 1200;
        detailList[0].JP_OverLimitDiscount__c = false;
        detailList[0].JP_ProductCode__c = '9999';
        detailList[0].JP_PreRelease__c = true;
        detailList[0].JP_RequiredMaintenanceFlag__c = true;
        detailList[0].JP_CampaignDecision__c = true;
        detailList[0].JP_PiStock__c = true;
        detailList[0].JP_WholeSaleRate__c = 1;
        detailList[0].JP_UnitPrice__c = 1500;
        detailList[0].JP_SpecialWholeSaleTRate__c = 0.8;
        detailList[0].JP_DiscountLimitPrice__c = 800;
        detailList[0].JP_WholeSalePriceMulQuantity__c = detailList[0].JP_UnitPrice__c * detailList[0].JP_WholeSaleRate__c;
        detailList[0].JP_SpecialUnitPriceMulQuantity__c = detailList[0].JP_SpecialUnitPrice__c * detailList[0].JP_Quantity__c;
        detailList[0].JP_StandardMinusSpecial__c = detailList[0].JP_WholeSalePriceMulQuantity__c - detailList[0].JP_SpecialUnitPriceMulQuantity__c;
        detailList[0].JP_DeterminedAmount__c = detailList[0].JP_SpecialUnitPriceMulQuantity__c;
        detailList[0].JP_PreSave__c = true;
        
        detailList[1].JP_QuotationHeader__c = qhList[0].Id;
        detailList[1].JP_ProductCatalogCode__c = dpList[0].JP_ProductCatalogCode__c;
        detailList[1].JP_5PercentDiscount__c = 1200;
        detailList[1].JP_ProductName__c = 'testProduct';
        detailList[1].JP_Sort__c = 2;
        detailList[1].JP_Quantity__c = 1;
        detailList[1].JP_SpecialUnitPrice__c = 1000;
        detailList[1].JP_WholeSalePriceMulQuantity__c = 1000;
        detailList[1].JP_SpecialUnitPriceMulQuantity__c = 1000;
        detailList[1].JP_StandardMinusSpecial__c = 1000;
        detailList[1].JP_DeterminedAmount__c = 1000;
        detailList[1].JP_PriceYearMonth__c = 'JP 2015/10';
        detailList[1].JP_AppGroupID__c = 'G2';
        detailList[1].JP_OverLimitDiscount__c = false;
        detailList[1].JP_ProductCode__c = '9999';
        detailList[1].JP_PreRelease__c = false;
        detailList[1].JP_WholeSaleRate__c = 1;
        detailList[1].JP_UnitPrice__c = 1500;
        detailList[1].JP_SpecialWholeSaleTRate__c = 0.8;
        detailList[1].JP_DiscountLimitPrice__c = 800;
        detailList[1].JP_WholeSalePriceMulQuantity__c = detailList[1].JP_UnitPrice__c * detailList[1].JP_WholeSaleRate__c;
        detailList[1].JP_SpecialUnitPriceMulQuantity__c = detailList[1].JP_SpecialUnitPrice__c * detailList[1].JP_Quantity__c;
        detailList[1].JP_StandardMinusSpecial__c = detailList[1].JP_WholeSalePriceMulQuantity__c - detailList[1].JP_SpecialUnitPriceMulQuantity__c;
        detailList[1].JP_DeterminedAmount__c = detailList[1].JP_SpecialUnitPriceMulQuantity__c;
        detailList[1].JP_PreSave__c = true;

        detailList[2].JP_QuotationHeader__c = qhList[0].Id;
        detailList[2].JP_ProductCatalogCode__c = dpList[0].JP_ProductCatalogCode__c;
        detailList[2].JP_5PercentDiscount__c = 1200;
        detailList[2].JP_ProductName__c = 'testProduct';
        detailList[2].JP_Sort__c = 3;
        detailList[2].JP_Quantity__c = 1;
        detailList[2].JP_SpecialUnitPrice__c = 1000;
        detailList[2].JP_WholeSalePriceMulQuantity__c = 1000;
        detailList[2].JP_SpecialUnitPriceMulQuantity__c = 1000;
        detailList[2].JP_StandardMinusSpecial__c = 1000;
        detailList[2].JP_DeterminedAmount__c = 1000;
        detailList[2].JP_PriceYearMonth__c = 'JP 2015/10';
        detailList[2].JP_AppGroupID__c = 'G3';
        detailList[2].JP_OverLimitDiscount__c = false;
        detailList[2].JP_ProductCode__c = '9999';
        detailList[2].JP_PreRelease__c = false;
        detailList[2].JP_WholeSaleRate__c = 1;
        detailList[2].JP_UnitPrice__c = 1500;
        detailList[2].JP_SpecialWholeSaleTRate__c = 0.8;
        detailList[2].JP_DiscountLimitPrice__c = 800;
        detailList[2].JP_WholeSalePriceMulQuantity__c = detailList[2].JP_UnitPrice__c * detailList[2].JP_WholeSaleRate__c;
        detailList[2].JP_SpecialUnitPriceMulQuantity__c = detailList[2].JP_SpecialUnitPrice__c * detailList[2].JP_Quantity__c;
        detailList[2].JP_StandardMinusSpecial__c = detailList[2].JP_WholeSalePriceMulQuantity__c - detailList[2].JP_SpecialUnitPriceMulQuantity__c;
        detailList[2].JP_DeterminedAmount__c = detailList[2].JP_SpecialUnitPriceMulQuantity__c;
        detailList[2].JP_PreSave__c = true;
        insert detailList;

        system.runAs(user){
            JP_QuotationHeader__c rec = new JP_QuotationHeader__c();

            PageReference pref = Page.JP_QuotationEdit;
            System.Test.setCurrentPage(pref);

            ApexPages.currentPage().getParameters().put('distributorId',qd[0].id);
            ApexPages.currentPage().getParameters().put('spotflg', '0');

            System.Test.startTest();

            Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(qhlist[0]);
            JP_QuotationHeaderController jph = new JP_QuotationHeaderController(sc);
            jph.moveLastPage();
            jph.refleshDetails();
            jph.getError();
            jph.doNext();
            jph.doPrev();

            System.Test.stopTest();
        }

    }

    /*部署のプルダウン*/
    private static testMethod void testgetDepartmentList(){
        // テストデータ作成
        createData();
        qdList = JP_TestUtil.Create_JP_QuotationDistributor();

        List<SelectOption> DepartmentItems = new List<SelectOption>();

        system.runAs(user){
            JP_QuotationHeader__c rec = new JP_QuotationHeader__c();

            PageReference pref = Page.JP_QuotationEdit;
            System.Test.setCurrentPage(pref);

            System.Test.startTest();

            Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
            JP_QuotationHeaderController jph = new JP_QuotationHeaderController(sc);

            DepartmentItems = jph.getDepartmentList();

            System.Test.stopTest();
        }
        //「--なし--」も含めた件数
        system.assertEquals(6,DepartmentItems.size());
    }

    /*見積条件のプルダウン*/
    private static testMethod void testgetQuotationConditionList(){
        // テストデータ作成
        createData();
        qdList = JP_TestUtil.Create_JP_QuotationDistributor();

        List<SelectOption> QuotationConditionItems = new List<SelectOption>();

        system.runAs(user){
            JP_QuotationHeader__c rec = new JP_QuotationHeader__c();

            PageReference pref = Page.JP_QuotationEdit;
            System.Test.setCurrentPage(pref);

            System.Test.startTest();

            Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
            JP_QuotationHeaderController jph = new JP_QuotationHeaderController(sc);

            QuotationConditionItems = jph.getQuotationConditionList();

            System.Test.stopTest();
        }
        //「--なし--」も含めた件数
        system.assertEquals(3,QuotationConditionItems.size());
    }

    /*保存ボタン表示制御*/
    private static testMethod void testgetDispSave(){
        // テストデータ作成
        createData();


        Boolean dispFlg;

        system.runAs(user){
            JP_QuotationHeader__c rec = new JP_QuotationHeader__c();

            PageReference pref = Page.JP_QuotationEdit;
            System.Test.setCurrentPage(pref);

            System.Test.startTest();

            Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
            JP_QuotationHeaderController jph = new JP_QuotationHeaderController(sc);

            dispFlg = jph.getDispSave();

            System.Test.stopTest();
        }

        system.assertEquals(true,dispFlg);
    }

    /*保存ボタン表示制御*/
    private static testMethod void testgetDispSave2(){
        // テストデータ作成
        createData();
        List<JP_QuotationDistributor__c> qd = JP_TestUtil.Create_JP_QuotationDistributor();
        List<JP_QuotationHeader__c> qhlist = JP_TestUtil.Create_JP_QuotationHeader(1);
        JP_QuotationHeader__c qh = qhlist[0];
        qh.JP_QuotationStatus__c = JP_Const.QUOTATION_STATUS_APPROVE;
        qh.JP_QuotationDistCD__c = qd[0].Id;
        insert qhlist;

        Boolean dispFlg;

        system.runAs(user){
            JP_QuotationHeader__c rec = qhlist[0];

            PageReference pref = Page.JP_QuotationEdit;
            System.Test.setCurrentPage(pref);

            System.Test.startTest();

            Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
            JP_QuotationHeaderController jph = new JP_QuotationHeaderController(sc);

            dispFlg = jph.getDispSave();

            System.Test.stopTest();
        }

        system.assertEquals(false,dispFlg);
    }

    /*仮保存ボタン表示制御*/
    private static testMethod void testgetDispPreSave(){
        // テストデータ作成
        createData();
        List<JP_QuotationDistributor__c> qd = JP_TestUtil.Create_JP_QuotationDistributor();
        List<JP_QuotationHeader__c> qhlist = JP_TestUtil.Create_JP_QuotationHeader(1);
        qhlist[0].JP_QuotationStatus__c = JP_Const.QUOTATION_STATUS_UNAPPROVE;
        qhlist[0].JP_QuotationDistCD__c = qd[0].Id;
        //qhlist[0].JP_QuotationNo__c = '789456';
        insert qhlist;

        Boolean dispFlg;

        system.runAs(user){
            JP_QuotationHeader__c rec = new JP_QuotationHeader__c();

            PageReference pref = Page.JP_QuotationEdit;
            System.Test.setCurrentPage(pref);

            System.Test.startTest();

            Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
            JP_QuotationHeaderController jph = new JP_QuotationHeaderController(sc);

            dispFlg = jph.getDispPreSave();

            System.Test.stopTest();
        }

        system.assertEquals(true,dispFlg);
    }

    /*保存ボタン1*/
    private static testMethod void testdoSave1(){
        // テストデータ作成
        createData();
        List<JP_QuotationDistributor__c> qd = JP_TestUtil.Create_JP_QuotationDistributor();
        PageReference resultpage;

        system.runAs(user){
            JP_QuotationHeader__c rec = new JP_QuotationHeader__c();
            PageReference pref = Page.JP_QuotationEdit;
            System.Test.setCurrentPage(pref);
            JP_ApprovalProcessMaster__c apm = JP_TestUtil.Create_JP_ApprovalProcessMaster(1);
            JP_DecideApprovalProcess__c dap = new JP_DecideApprovalProcess__c();
            dap.JP_ApprovalProcessMaster__c = apm.Id;
            dap.JP_ChkTotalAmountCD__c = 'A1';
            dap.JP_ChkWholeSaleCD__c = 'B1';
            dap.JP_ChkLimitDiscountCD__c = 'C1';
            dap.JP_ChkRegisteredProductCD__c = 'D1';
            dap.JP_ChkQuotationExpiryDateCD__c = 'E1';
            dap.JP_ChkPreReleaseCD__c = 'F1';
            insert dap;

            System.Test.startTest();

            Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
            JP_QuotationHeaderController jph = new JP_QuotationHeaderController(sc);
            jph.QHeader.JP_QuotationDistCD__c = qd[0].Id;
            jph.QHeader.JP_QuotationStatus__c = JP_Const.QUOTATION_STATUS_UNAPPROVE;
            jph.QHeader.JP_TotalAmount__c = 10000;
            jph.presaveFlg = null;
            
            jph.QHeader.JP_AllowMixOfPriceYearMonth__c = false;
            
            JP_QuotationDetail__c dest = jph.QDetailList.get(0).obj;
            dest.JP_QuotationHeader__c = jph.QHeader.Id;
            dest.JP_StandardPrice__c = 10000;
            dest.JP_ProductCatalogCode__c = 'testcode';
            dest.JP_ProductName__c = 'testProduct';
            dest.JP_Sort__c = 1;
            dest.JP_Quantity__c = 1;
            dest.JP_SpecialUnitPrice__c = 1000000;
            dest.JP_WholeSalePriceMulQuantity__c = 1000;
            dest.JP_SpecialUnitPriceMulQuantity__c = 1000;
            dest.JP_StandardMinusSpecial__c = 1000;
            dest.JP_DeterminedAmount__c = 1000;
            dest.JP_PriceYearMonth__c = 'JP 2015/10';
            dest.JP_AppGroupID__c = 'G1';
            dest.JP_5PercentDiscount__c = 1200;
            dest.JP_OverLimitDiscount__c = false;
            dest.JP_ProductCode__c = '9999';
            dest.JP_PreRelease__c = false;
            dest.JP_WholeSaleRate__c = 1;
            dest.JP_UnitPrice__c = 1500;
            dest.JP_SpecialWholeSaleTRate__c = 0.8;
            dest.JP_DiscountLimitPrice__c = 8000000;
            dest.JP_WholeSalePriceMulQuantity__c = dest.JP_UnitPrice__c * dest.JP_WholeSaleRate__c;
            dest.JP_SpecialUnitPriceMulQuantity__c = dest.JP_SpecialUnitPrice__c * dest.JP_Quantity__c;
            dest.JP_StandardMinusSpecial__c = dest.JP_WholeSalePriceMulQuantity__c - dest.JP_SpecialUnitPriceMulQuantity__c;
            dest.JP_DeterminedAmount__c = dest.JP_SpecialUnitPriceMulQuantity__c;
            
            // 見積明細に空欄がある場合
            resultpage = jph.doRecSave();
            
            dest.JP_QuotationDetailType__c = '明細区分リセット用(システム利用)';
            jph.setDefaultQuotationDetail (dest,false);
            
            resultpage = jph.doRecSave();

            System.Test.stopTest();
        }

        List<JP_QuotationHeader__c> result = [Select Id,Name,JP_PreSave__c,JP_TriggerSkipFLG__c From JP_QuotationHeader__c];
        //system.assertEquals(false,result[0].JP_PreSave__c);
        //system.assertEquals(false,result[0].JP_TriggerSkipFLG__c);
        //system.assertNotEquals(null,resultpage);
    }

    /*保存ボタン2*/
    /**
    private static testMethod void testdoSave2(){
        // テストデータ作成
        createData();
        List<JP_QuotationDistributor__c> qd = JP_TestUtil.Create_JP_QuotationDistributor();
        List<JP_QuotationHeader__c> qhlist = JP_TestUtil.Create_JP_QuotationHeader(1);
        qhlist[0].JP_QuotationStatus__c = JP_Const.QUOTATION_STATUS_UNAPPROVE;
        qhlist[0].JP_QuotationDistCD__c = qd[0].Id;
        //qhlist[0].JP_QuotationNo__c = '789456';
        insert qhlist;
        PageReference resultpage;

        system.runAs(user){

            //JP_QuotationHeader__c rec = new JP_QuotationHeader__c();
            PageReference pref = Page.JP_QuotationEdit;
            System.Test.setCurrentPage(pref);

            System.Test.startTest();

            Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(qhlist[0]);
            JP_QuotationHeaderController jph = new JP_QuotationHeaderController(sc);
            jph.QHeader.JP_QuotationDistCD__c = qd[0].Id;
            jph.presaveFlg = null;

            resultpage = jph.doRecSave();

            System.Test.stopTest();
        }
        
        system.debug('■■■■■■■■■■■■■■■■■■■■　qhlist[0].Id = ' + qhlist[0].Id);
        List<JP_QuotationHeader__c> result = [Select Id,Name,JP_PreSave__c,JP_TriggerSkipFLG__c From JP_QuotationHeader__c Where Id =: qhlist[0].Id Limit 1];
        system.assertEquals(false,result[0].JP_PreSave__c);
        //system.assertEquals(false,result[0].JP_TriggerSkipFLG__c);
        system.assertNotEquals(null,resultpage);
    }
    */
    
    /*保存ボタン3(仮保存)*/
    private static testMethod void testdoSave3(){
        // テストデータ作成
        createData();
        List<JP_QuotationDistributor__c> qd = JP_TestUtil.Create_JP_QuotationDistributor();
        List<JP_QuotationHeader__c> qhlist = JP_TestUtil.Create_JP_QuotationHeader(1);
        qhlist[0].JP_QuotationDistCD__c = qd[0].Id;
        qhlist[0].JP_PreSave__c = true;
        insert qhlist;
        
        JP_QuotationDetail__c dest = new JP_QuotationDetail__c();
        dest.JP_QuotationHeader__c = qhlist[0].Id;
        dest.JP_ProductCatalogCode__c = 'testcode';
        dest.JP_ProductName__c = 'testProduct';
        dest.JP_Sort__c = 1;
        dest.JP_Quantity__c = 1;
        dest.JP_SpecialUnitPrice__c = 1000;
        dest.JP_WholeSalePriceMulQuantity__c = 1000;
        dest.JP_SpecialUnitPriceMulQuantity__c = 1000;
        dest.JP_StandardMinusSpecial__c = 1000;
        dest.JP_DeterminedAmount__c = 1000;
        dest.JP_PriceYearMonth__c = 'JP 2015/10';
        dest.JP_AppGroupID__c = 'G1';
        dest.JP_5PercentDiscount__c = 1200;
        dest.JP_OverLimitDiscount__c = false;
        dest.JP_ProductCode__c = '9999';
        dest.JP_PreRelease__c = false;
        dest.JP_WholeSaleRate__c = 1;
        dest.JP_UnitPrice__c = 1500;
        dest.JP_SpecialWholeSaleTRate__c = 0.8;
        dest.JP_DiscountLimitPrice__c = 800;
        dest.JP_WholeSalePriceMulQuantity__c = dest.JP_UnitPrice__c * dest.JP_WholeSaleRate__c;
        dest.JP_SpecialUnitPriceMulQuantity__c = dest.JP_SpecialUnitPrice__c * dest.JP_Quantity__c;
        dest.JP_StandardMinusSpecial__c = dest.JP_WholeSalePriceMulQuantity__c - dest.JP_SpecialUnitPriceMulQuantity__c;
        dest.JP_DeterminedAmount__c = dest.JP_SpecialUnitPriceMulQuantity__c;
        dest.JP_PreSave__c = true;
        insert dest;
        
        JP_DistributorPrice__c distributorPrice = new JP_DistributorPrice__c(JP_WholeSaleKey__c= 'Test', JP_ProductCatalogCode__c = dest.JP_ProductCatalogCode__c,JP_Price_List_Type__c = 'AE', JP_WholeSalePrice__c= 100);
        insert distributorPrice;

        PageReference resultpage;

        system.runAs(user){

            //JP_QuotationHeader__c rec = new JP_QuotationHeader__c();
            PageReference pref = Page.JP_QuotationEdit;
            System.Test.setCurrentPage(pref);
            ApexPages.currentPage().getParameters().put('id',qhlist[0].id);

            System.Test.startTest();

            Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(qhlist[0]);
            JP_QuotationHeaderController jph = new JP_QuotationHeaderController(sc);
            jph.QHeader.JP_QuotationDistCD__c = qd[0].Id;
            jph.QDetailList[0].obj.JP_QuotationDetailType__c = null;
            jph.presaveFlg = '1';
            
            

            resultpage = jph.doRecSave();

            System.Test.stopTest();
        }
        

        List<JP_QuotationHeader__c> result = [Select Id,Name,JP_PreSave__c,JP_TriggerSkipFLG__c From JP_QuotationHeader__c Where Id =: qhlist[0].Id Limit 1];
        system.assertEquals(true,result[0].JP_PreSave__c);
        //system.assertEquals(true,result[0].JP_TriggerSkipFLG__c);
        // 20151029
        //system.assertNotEquals(null,resultpage);
        System.assertEquals(null, resultpage);
    }

    /*キャンセルボタン表示１*/
    private static testMethod void testdoCancel1(){
        // テストデータ作成
        createData();
        qdList = JP_TestUtil.Create_JP_QuotationDistributor();
        PageReference resultpage;

        system.runAs(user){
            JP_QuotationHeader__c rec = new JP_QuotationHeader__c();

            PageReference pref = Page.JP_QuotationEdit;
            System.Test.setCurrentPage(pref);

            ApexPages.currentPage().getParameters().put('retURL',qdList[0].id);
            ApexPages.currentPage().getParameters().put('distributorId',qdList[0].id);
            ApexPages.currentPage().getParameters().put('spotflg', '1');

            System.Test.startTest();

            Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
            JP_QuotationHeaderController jph = new JP_QuotationHeaderController(sc);
            resultpage = jph.doCancel();
            System.Test.stopTest();
        }

        system.assertNotEquals(null,resultpage);

    }

    /*キャンセルボタン表示２*/
    private static testMethod void testdoCancel2(){
        // テストデータ作成
        createData();
        qdList = JP_TestUtil.Create_JP_QuotationDistributor();
        PageReference resultpage;

        system.runAs(user){
            JP_QuotationHeader__c rec = new JP_QuotationHeader__c();

            PageReference pref = Page.JP_QuotationEdit;
            System.Test.setCurrentPage(pref);

            System.Test.startTest();

            Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
            JP_QuotationHeaderController jph = new JP_QuotationHeaderController(sc);
            resultpage = jph.doCancel();
            System.Test.stopTest();
        }

        system.assertEquals(true,resultpage.getUrl().contains('/home/home.jsp'));

    }

    /*代理店変更時の値セット1*/
    private static testMethod void testdoChangeQuotationDistCD1(){
        // テストデータ作成
        createData();
        List<JP_QuotationDistributor__c> qd = JP_TestUtil.Create_JP_QuotationDistributor();
        PageReference resultpage;

        //ApexPages.currentPage().getParameters().put('retURL',qdList[0].id);
        ApexPages.currentPage().getParameters().put('distributorId',qd[0].id);
        //ApexPages.currentPage().getParameters().put('spotflg', '0');

        Apexpages.Standardcontroller sc;
        JP_QuotationHeaderController jph;

        system.runAs(user){
            JP_QuotationHeader__c rec = new JP_QuotationHeader__c();

            PageReference pref = Page.JP_QuotationEdit;
            System.Test.setCurrentPage(pref);

            System.Test.startTest();

            sc = new Apexpages.Standardcontroller(rec);
            jph = new JP_QuotationHeaderController(sc);
            jph.QHeader.JP_QuotationDistCD__c = qd[0].Id;
            
            system.debug('◆◆◆JP_QuotationDistCD__c : ' + qd[0].JP_DistributorCode__c);

            resultpage = jph.doChangeQuotationDistCD();
            System.Test.stopTest();
        }

        system.assertEquals(null,resultpage);
        system.assertEquals('000010',jph.QHeader.JP_DistributorCode__c);
        system.assertEquals('テスト代理店1',jph.QHeader.JP_Company__c);
        system.assertEquals('テスト条件11\nテスト条件1',jph.QHeader.JP_QuotationCondition__c);

    }

    /*代理店変更時の値セット2*/
    private static testMethod void testdoChangeQuotationDistCD2(){
        // テストデータ作成
        createData();
        qdList = JP_TestUtil.Create_JP_QuotationDistributor();
        PageReference resultpage;
        //ApexPages.currentPage().getParameters().put('retURL',qdList[0].id);
        //ApexPages.currentPage().getParameters().put('distributorId',qdList[0].id);
        //ApexPages.currentPage().getParameters().put('spotflg', '0');

        Apexpages.Standardcontroller sc;
        JP_QuotationHeaderController jph;

        system.runAs(user){
            JP_QuotationHeader__c rec = new JP_QuotationHeader__c();

            PageReference pref = Page.JP_QuotationEdit;
            System.Test.setCurrentPage(pref);

            System.Test.startTest();

            sc = new Apexpages.Standardcontroller(rec);
            jph = new JP_QuotationHeaderController(sc);

            jph.QHeader.JP_QuotationDistCD__c = null;

            resultpage = jph.doChangeQuotationDistCD();
            System.Test.stopTest();
        }

        system.assertEquals(null,resultpage);
        system.assertEquals(null,jph.QHeader.JP_DistributorCode__c);
        system.assertEquals(null,jph.QHeader.JP_Company__c);
        system.assertNotEquals(null,jph.QHeader.JP_QuotationCondition__c);


    }

    /*代理店変更時の値セット3*/
    private static testMethod void testdoChangeQuotationDistCD3(){
        // テストデータ作成
        createData();
        List<JP_QuotationDistributor__c> qd = JP_TestUtil.Create_JP_QuotationDistributor();
        List<JP_QuotationHeader__c> qhlist = JP_TestUtil.Create_JP_QuotationHeader(1);
        qhlist[0].JP_QuotationDistCD__c = qd[0].Id;
        qhlist[0].JP_PreSave__c =false;
        //qhlist[0].JP_QuotationNo__c = '789456';
        insert qhlist;
        
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

        List<JP_DistributorPrice__c> dpList = new List<JP_DistributorPrice__c>();
        JP_DistributorPrice__c dp = new JP_DistributorPrice__c();
        dp.Name = '12345';
        dp.JP_ProductCatalogCode__c = '20000';
        dp.JP_Price_List_Type__c  = '01';
        dp.JP_PriceYearMonth__c = 'JP 2015/10';
        dp.JP_WholeSaleKey__c = dp.JP_Price_List_Type__c + '_' + dp.JP_ProductCatalogCode__c + '_' + dp.JP_PriceYearMonth__c;
        dpList.add(dp);
        insert dpList;

        List<JP_QuotationDetail__c> detailList = JP_TestUtil.Create_JP_QuotationDetail(qhlist[0].Id,3);
        detailList[0].JP_ProductCatalogCode__c = dpList[0].Name;
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
        detailList[0].JP_PreSave__c =false;
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

        detailList[1].JP_ProductCatalogCode__c = dpList[0].Name;
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
        detailList[1].JP_PreSave__c =false;
        detailList[1].JP_5PercentDiscount__c = 1200;
        detailList[1].JP_OverLimitDiscount__c = false;
        detailList[1].JP_ProductCode__c = '9999';
        detailList[1].JP_PreRelease__c = false;
        detailList[1].JP_WholeSaleRate__c = 1;
        detailList[1].JP_UnitPrice__c = 1500;
        detailList[1].JP_SpecialWholeSaleTRate__c = 0.8;
        detailList[1].JP_DiscountLimitPrice__c = 800;
        detailList[1].JP_WholeSalePriceMulQuantity__c = detailList[1].JP_UnitPrice__c * detailList[1].JP_WholeSaleRate__c;
        detailList[1].JP_SpecialUnitPriceMulQuantity__c = detailList[1].JP_SpecialUnitPrice__c * detailList[1].JP_Quantity__c;
        detailList[1].JP_StandardMinusSpecial__c = detailList[1].JP_WholeSalePriceMulQuantity__c - detailList[1].JP_SpecialUnitPriceMulQuantity__c;
        detailList[1].JP_DeterminedAmount__c = detailList[1].JP_SpecialUnitPriceMulQuantity__c;

        detailList[2].JP_ProductCatalogCode__c = dpList[0].Name;
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
        detailList[2].JP_PreSave__c =false;
        detailList[2].JP_5PercentDiscount__c = 1200;
        detailList[2].JP_OverLimitDiscount__c = false;
        detailList[2].JP_ProductCode__c = '9999';
        detailList[2].JP_PreRelease__c = false;
        detailList[2].JP_WholeSaleRate__c = 1;
        detailList[2].JP_UnitPrice__c = 1500;
        detailList[2].JP_SpecialWholeSaleTRate__c = 0.8;
        detailList[2].JP_DiscountLimitPrice__c = 800;
        detailList[2].JP_WholeSalePriceMulQuantity__c = detailList[2].JP_UnitPrice__c * detailList[2].JP_WholeSaleRate__c;
        detailList[2].JP_SpecialUnitPriceMulQuantity__c = detailList[2].JP_SpecialUnitPrice__c * detailList[2].JP_Quantity__c;
        detailList[2].JP_StandardMinusSpecial__c = detailList[2].JP_WholeSalePriceMulQuantity__c - detailList[2].JP_SpecialUnitPriceMulQuantity__c;
        detailList[2].JP_DeterminedAmount__c = detailList[2].JP_SpecialUnitPriceMulQuantity__c;
        insert detailList;


        PageReference resultpage;

        //ApexPages.currentPage().getParameters().put('retURL',qdList[0].id);
        ApexPages.currentPage().getParameters().put('distributorId',qd[0].id);
        ApexPages.currentPage().getParameters().put('spotflg', '0');

        Apexpages.Standardcontroller sc;
        JP_QuotationHeaderController jph;

        system.runAs(user){
            JP_QuotationHeader__c rec = new JP_QuotationHeader__c();

            PageReference pref = Page.JP_QuotationEdit;
            System.Test.setCurrentPage(pref);

            System.Test.startTest();

            sc = new Apexpages.Standardcontroller(qhlist[0]);
            jph = new JP_QuotationHeaderController(sc);
            jph.QHeader.JP_QuotationDistCD__c = null;

            resultpage = jph.doChangeQuotationDistCD();
            System.Test.stopTest();
        }

        system.assertEquals(null,resultpage);
        system.assertEquals(null,jph.QHeader.JP_DistributorCode__c);
        system.assertEquals(null,jph.QHeader.JP_Company__c);
        system.assertNotEquals(null,jph.QHeader.JP_QuotationCondition__c);

    }


    /*見積顧客変更時の値セット1*/
    private static testMethod void testdoChangeContact1(){
        // テストデータ作成
        createData();
        List<JP_QuotationDistributor__c> qd = JP_TestUtil.Create_JP_QuotationDistributor();
        PageReference resultpage;

        //ApexPages.currentPage().getParameters().put('retURL',qdList[0].id);
        ApexPages.currentPage().getParameters().put('distributorId',qd[0].id);
        //ApexPages.currentPage().getParameters().put('spotflg', '0');

        List<JP_QuotationContact__c> qcList = [Select Id,Name From JP_QuotationContact__c Where JP_QuotationDistributor__c=:qd[0].id Order by Name];

        Apexpages.Standardcontroller sc;
        JP_QuotationHeaderController jph;

        system.runAs(user){
            JP_QuotationHeader__c rec = new JP_QuotationHeader__c();

            PageReference pref = Page.JP_QuotationEdit;
            System.Test.setCurrentPage(pref);

            System.Test.startTest();

            sc = new Apexpages.Standardcontroller(rec);
            jph = new JP_QuotationHeaderController(sc);
            jph.QHeader.JP_QuotationDistCD__c = qd[0].Id;
            jph.QHeader.JP_QuotationContact__c = qcList[0].Id;


            resultpage = jph.doChangeContact();
            System.Test.stopTest();
        }

        system.assertEquals(null,resultpage);
        system.assertEquals('1234567',jph.QHeader.JP_Postcode__c);
        system.assertEquals('テスト府1',jph.QHeader.JP_Adress1__c);
        system.assertEquals('テスト市1',jph.QHeader.JP_Adress2__c);
        system.assertEquals('テストビル1',jph.QHeader.JP_Building__c);
        system.assertEquals('管理部',jph.QHeader.JP_Department1__c);
        system.assertEquals('人事部',jph.QHeader.JP_Department2__c);
        system.assertEquals('様',jph.QHeader.JP_Title__c);
        system.assertEquals('78945612',jph.QHeader.JP_TelNo__c);
        system.assertEquals('123456',jph.QHeader.JP_FaxNo__c);

    }


    /*見積顧客変更時の値セット2*/
    private static testMethod void testdoChangeContact2(){
        // テストデータ作成
        createData();
        List<JP_QuotationDistributor__c> qd = JP_TestUtil.Create_JP_QuotationDistributor();
        PageReference resultpage;

        //ApexPages.currentPage().getParameters().put('retURL',qdList[0].id);
        ApexPages.currentPage().getParameters().put('distributorId',qd[0].id);
        //ApexPages.currentPage().getParameters().put('spotflg', '0');

        List<JP_QuotationContact__c> qcList = [Select Id,Name From JP_QuotationContact__c Where JP_QuotationDistributor__c=:qd[0].id Order by Name];

        Apexpages.Standardcontroller sc;
        JP_QuotationHeaderController jph;

        system.runAs(user){
            JP_QuotationHeader__c rec = new JP_QuotationHeader__c();

            PageReference pref = Page.JP_QuotationEdit;
            System.Test.setCurrentPage(pref);

            System.Test.startTest();

            sc = new Apexpages.Standardcontroller(rec);
            jph = new JP_QuotationHeaderController(sc);
            jph.QHeader.JP_QuotationDistCD__c = qd[0].Id;
            jph.QHeader.JP_QuotationContact__c = null;


            resultpage = jph.doChangeContact();
            System.Test.stopTest();
        }

        system.assertEquals(null,resultpage);
        system.assertEquals(null,jph.QHeader.JP_Postcode__c);
        system.assertEquals(null,jph.QHeader.JP_Adress1__c);
        system.assertEquals(null,jph.QHeader.JP_Adress2__c);
        system.assertEquals(null,jph.QHeader.JP_Building__c);
        system.assertEquals(null,jph.QHeader.JP_Department1__c);
        system.assertEquals(null,jph.QHeader.JP_Department2__c);
        system.assertEquals(null,jph.QHeader.JP_Title__c);
        system.assertEquals(null,jph.QHeader.JP_TelNo__c);
        system.assertEquals(null,jph.QHeader.JP_FaxNo__c);

    }

    /*営業OUTユーザ変更時の値セット1*/
    private static testMethod void testdoChangeOutuser1(){
        // テストデータ作成
        createData();
        List<JP_QuotationDistributor__c> qd = JP_TestUtil.Create_JP_QuotationDistributor();
        PageReference resultpage;

        //ApexPages.currentPage().getParameters().put('retURL',qdList[0].id);
        ApexPages.currentPage().getParameters().put('distributorId',qd[0].id);
        //ApexPages.currentPage().getParameters().put('spotflg', '0');

        Apexpages.Standardcontroller sc;
        JP_QuotationHeaderController jph;

        system.runAs(user){
            JP_QuotationHeader__c rec = new JP_QuotationHeader__c();

            PageReference pref = Page.JP_QuotationEdit;
            System.Test.setCurrentPage(pref);

            System.Test.startTest();

            sc = new Apexpages.Standardcontroller(rec);
            jph = new JP_QuotationHeaderController(sc);
            jph.QHeader.JP_Outside__c = user.Id;

            resultpage = jph.doChangeOutuser();
            System.Test.stopTest();
        }

        system.assertEquals(null,resultpage);
        system.assertEquals('999-9999',jph.QHeader.JP_ATKK_Postcode__c);
        system.assertEquals('テスト都1',jph.QHeader.JP_ATKK_Address1__c);
        system.assertEquals('テスト区1テスト番地1',jph.QHeader.JP_ATKK_Address2__c);
        system.assertEquals('テストビル1',jph.QHeader.JP_ATKK_Building__c);
        system.assertEquals('テスト株式会社1',jph.QHeader.JP_ATKK_Company__c);
        system.assertEquals('9999999',jph.QHeader.JP_atkkTellNo__c);
        system.assertEquals('9999999',jph.QHeader.JP_atkkFaxNo__c);
    }

    /*営業OUTユーザ変更時の値セット2*/
    private static testMethod void testdoChangeOutuser2(){
        // テストデータ作成
        createData();
        List<JP_QuotationDistributor__c> qd = JP_TestUtil.Create_JP_QuotationDistributor();
        PageReference resultpage;

        //ApexPages.currentPage().getParameters().put('retURL',qdList[0].id);
        ApexPages.currentPage().getParameters().put('distributorId',qd[0].id);
        //ApexPages.currentPage().getParameters().put('spotflg', '0');

        Apexpages.Standardcontroller sc;
        JP_QuotationHeaderController jph;

        system.runAs(user){
            JP_QuotationHeader__c rec = new JP_QuotationHeader__c();

            PageReference pref = Page.JP_QuotationEdit;
            System.Test.setCurrentPage(pref);

            System.Test.startTest();

            sc = new Apexpages.Standardcontroller(rec);
            jph = new JP_QuotationHeaderController(sc);
            jph.QHeader.JP_Outside__c = null;

            resultpage = jph.doChangeOutuser();
            System.Test.stopTest();
        }

        system.assertEquals(null,resultpage);
        system.assertEquals(null,jph.QHeader.JP_ATKK_Postcode__c);
        system.assertEquals(null,jph.QHeader.JP_ATKK_Address1__c);
        system.assertEquals(null,jph.QHeader.JP_ATKK_Address2__c);
        system.assertEquals(null,jph.QHeader.JP_ATKK_Building__c);
        system.assertEquals(null,jph.QHeader.JP_ATKK_Company__c);
        system.assertEquals(null,jph.QHeader.JP_atkkTellNo__c);
        system.assertEquals(null,jph.QHeader.JP_atkkFaxNo__c);

    }

    /*営業OUTユーザ変更時の値セット3*/
    private static testMethod void testdoChangeOutuser3(){
        // テストデータ作成
        createData();
        List<JP_QuotationDistributor__c> qd = JP_TestUtil.Create_JP_QuotationDistributor();
        PageReference resultpage;

        //ApexPages.currentPage().getParameters().put('retURL',qdList[0].id);
        ApexPages.currentPage().getParameters().put('distributorId',qd[0].id);
        //ApexPages.currentPage().getParameters().put('spotflg', '0');

        user.JP_DeptCode__c = '99999';
        update user;

        Apexpages.Standardcontroller sc;
        JP_QuotationHeaderController jph;


        system.runAs(user){
            JP_QuotationHeader__c rec = new JP_QuotationHeader__c();

            PageReference pref = Page.JP_QuotationEdit;
            System.Test.setCurrentPage(pref);

            System.Test.startTest();

            sc = new Apexpages.Standardcontroller(rec);
            jph = new JP_QuotationHeaderController(sc);
            jph.QHeader.JP_Outside__c = user.Id;

            resultpage = jph.doChangeOutuser();
            System.Test.stopTest();
        }

        system.assertEquals(null,resultpage);
        system.assertEquals(null,jph.QHeader.JP_ATKK_Postcode__c);
        system.assertEquals(null,jph.QHeader.JP_ATKK_Address1__c);
        system.assertEquals(null,jph.QHeader.JP_ATKK_Address2__c);
        system.assertEquals(null,jph.QHeader.JP_ATKK_Building__c);
        system.assertEquals(null,jph.QHeader.JP_ATKK_Company__c);
        system.assertEquals(null,jph.QHeader.JP_atkkTellNo__c);
        system.assertEquals(null,jph.QHeader.JP_atkkFaxNo__c);
    }

    /*部署変更時の値セット1*/
    private static testMethod void testdoChangeDepaertment1(){
        // テストデータ作成
        createData();
        List<JP_QuotationDistributor__c> qd = JP_TestUtil.Create_JP_QuotationDistributor();
        PageReference resultpage;

        //ApexPages.currentPage().getParameters().put('retURL',qdList[0].id);
        ApexPages.currentPage().getParameters().put('distributorId',qd[0].id);
        //ApexPages.currentPage().getParameters().put('spotflg', '0');

        Apexpages.Standardcontroller sc;
        JP_QuotationHeaderController jph;


        system.runAs(user){
            JP_QuotationHeader__c rec = new JP_QuotationHeader__c();

            PageReference pref = Page.JP_QuotationEdit;
            System.Test.setCurrentPage(pref);

            System.Test.startTest();

            sc = new Apexpages.Standardcontroller(rec);
            jph = new JP_QuotationHeaderController(sc);
            jph.QHeader.JP_Outside__c = user.Id;

            resultpage = jph.doChangeDepaertment();
            System.Test.stopTest();
        }

        system.assertEquals(null,resultpage);
        system.assertEquals('999-9999',jph.QHeader.JP_ATKK_Postcode__c);
        system.assertEquals('テスト都1',jph.QHeader.JP_ATKK_Address1__c);
        system.assertEquals('テスト区1テスト番地1',jph.QHeader.JP_ATKK_Address2__c);
        system.assertEquals('テストビル1',jph.QHeader.JP_ATKK_Building__c);
        system.assertEquals('テスト株式会社1',jph.QHeader.JP_ATKK_Company__c);
        system.assertEquals('9999999',jph.QHeader.JP_atkkTellNo__c);
        system.assertEquals('9999999',jph.QHeader.JP_atkkFaxNo__c);
    }

    /*部署変更時の値セット2*/
    private static testMethod void testdoChangeDepaertment2(){
        // テストデータ作成
        createData();
        List<JP_QuotationDistributor__c> qd = JP_TestUtil.Create_JP_QuotationDistributor();
        PageReference resultpage;

        //ApexPages.currentPage().getParameters().put('retURL',qdList[0].id);
        ApexPages.currentPage().getParameters().put('distributorId',qd[0].id);
        //ApexPages.currentPage().getParameters().put('spotflg', '0');

        user.JP_DeptCode__c = '99999';
        update user;

        Apexpages.Standardcontroller sc;
        JP_QuotationHeaderController jph;


        system.runAs(user){
            JP_QuotationHeader__c rec = new JP_QuotationHeader__c();

            PageReference pref = Page.JP_QuotationEdit;
            System.Test.setCurrentPage(pref);

            System.Test.startTest();

            sc = new Apexpages.Standardcontroller(rec);
            jph = new JP_QuotationHeaderController(sc);
            jph.QHeader.JP_Outside__c = user.Id;

            resultpage = jph.doChangeDepaertment();
            System.Test.stopTest();
        }

        system.assertEquals(null,resultpage);
        system.assertEquals(null,jph.QHeader.JP_ATKK_Postcode__c);
        system.assertEquals(null,jph.QHeader.JP_ATKK_Address1__c);
        system.assertEquals(null,jph.QHeader.JP_ATKK_Address2__c);
        system.assertEquals(null,jph.QHeader.JP_ATKK_Building__c);
        system.assertEquals(null,jph.QHeader.JP_ATKK_Company__c);
        system.assertEquals(null,jph.QHeader.JP_atkkTellNo__c);
        system.assertEquals(null,jph.QHeader.JP_atkkFaxNo__c);
    }

    /*部署変更時の値セット3*/
    private static testMethod void testdoChangeDepaertment3(){
        // テストデータ作成
        createData();
        List<JP_QuotationDistributor__c> qd = JP_TestUtil.Create_JP_QuotationDistributor();
        PageReference resultpage;

        //ApexPages.currentPage().getParameters().put('retURL',qdList[0].id);
        ApexPages.currentPage().getParameters().put('distributorId',qd[0].id);
        //ApexPages.currentPage().getParameters().put('spotflg', '0');

        user.JP_DeptCode__c = '99999';
        update user;

        Apexpages.Standardcontroller sc;
        JP_QuotationHeaderController jph;


        system.runAs(user){
            JP_QuotationHeader__c rec = new JP_QuotationHeader__c();

            PageReference pref = Page.JP_QuotationEdit;
            System.Test.setCurrentPage(pref);

            System.Test.startTest();

            sc = new Apexpages.Standardcontroller(rec);
            jph = new JP_QuotationHeaderController(sc);
            jph.QHeader.JP_atkkDepartment1__c = null;

            resultpage = jph.doChangeDepaertment();
            System.Test.stopTest();
        }

        system.assertEquals(null,resultpage);
        system.assertEquals(null,jph.QHeader.JP_ATKK_Postcode__c);
        system.assertEquals(null,jph.QHeader.JP_ATKK_Address1__c);
        system.assertEquals(null,jph.QHeader.JP_ATKK_Address2__c);
        system.assertEquals(null,jph.QHeader.JP_ATKK_Building__c);
        system.assertEquals(null,jph.QHeader.JP_ATKK_Company__c);
        system.assertEquals(null,jph.QHeader.JP_atkkTellNo__c);
        system.assertEquals(null,jph.QHeader.JP_atkkFaxNo__c);
    }

    /*見積条件定型文一覧ボタン*/
    private static testMethod void testdoConditionList(){
        // テストデータ作成
        createData();
        List<JP_QuotationDistributor__c> qd = JP_TestUtil.Create_JP_QuotationDistributor();
        PageReference resultpage;

        //ApexPages.currentPage().getParameters().put('retURL',qdList[0].id);
        ApexPages.currentPage().getParameters().put('distributorId',qd[0].id);
        //ApexPages.currentPage().getParameters().put('spotflg', '0');

        Apexpages.Standardcontroller sc;
        JP_QuotationHeaderController jph;

        system.runAs(user){
            JP_QuotationHeader__c rec = new JP_QuotationHeader__c();

            PageReference pref = Page.JP_QuotationEdit;
            System.Test.setCurrentPage(pref);

            System.Test.startTest();

            sc = new Apexpages.Standardcontroller(rec);
            jph = new JP_QuotationHeaderController(sc);
            jph.QHeader.JP_Outside__c = null;

            resultpage = jph.doConditionList();
            System.Test.stopTest();
        }

        system.assertEquals('/apex/JP_QuotationConditionList',jph.urlLink);


    }


    /*　見積条件を取得し、ソートして表示1*/
    private static testMethod void testdoCondition1(){
        // テストデータ作成
        createData();
        List<JP_QuotationDistributor__c> qd = JP_TestUtil.Create_JP_QuotationDistributor();
        PageReference resultpage;

        //ApexPages.currentPage().getParameters().put('retURL',qdList[0].id);
        ApexPages.currentPage().getParameters().put('distributorId',qd[0].id);
        //ApexPages.currentPage().getParameters().put('spotflg', '0');

        Apexpages.Standardcontroller sc;
        JP_QuotationHeaderController jph;

        system.runAs(user){
            JP_QuotationHeader__c rec = new JP_QuotationHeader__c();

            PageReference pref = Page.JP_QuotationEdit;
            System.Test.setCurrentPage(pref);

            System.Test.startTest();

            sc = new Apexpages.Standardcontroller(rec);
            jph = new JP_QuotationHeaderController(sc);
            jph.QHeader.JP_QuotationDistCD__c = qd[0].Id;

            resultpage = jph.doCondition();
            System.Test.stopTest();
        }

        String result = jph.QHeader.JP_QuotationCondition__c;
        system.assertEquals(null,resultpage);
        system.assertNotEquals('',result);
        system.assertEquals(true,result.contains('テスト条件11'));
        system.assertEquals(true,result.contains('テスト条件1'));
    }

    /*　見積条件を取得し、ソートして表示2*/
    private static testMethod void testdoCondition2(){
        // テストデータ作成
        createData();
        List<JP_QuotationDistributor__c> qd = JP_TestUtil.Create_JP_QuotationDistributor();
        PageReference resultpage;

        //ApexPages.currentPage().getParameters().put('retURL',qdList[0].id);
        ApexPages.currentPage().getParameters().put('distributorId',qd[0].id);
        //ApexPages.currentPage().getParameters().put('spotflg', '0');

        Apexpages.Standardcontroller sc;
        JP_QuotationHeaderController jph;

        system.runAs(user){
            JP_QuotationHeader__c rec = new JP_QuotationHeader__c();

            PageReference pref = Page.JP_QuotationEdit;
            System.Test.setCurrentPage(pref);

            System.Test.startTest();

            sc = new Apexpages.Standardcontroller(rec);
            jph = new JP_QuotationHeaderController(sc);
            jph.QHeader.JP_QuotationDistCD__c = null;

            resultpage = jph.doCondition();
            System.Test.stopTest();
        }

        String result = jph.QHeader.JP_QuotationCondition__c;
        system.assertEquals(null,resultpage);
        system.assertNotEquals('',result);
        system.assertEquals(true,result.contains('テスト条件11'));
    }

    /*　見積条件を取得し、ソートして表示3*/
    private static testMethod void testdoCondition3(){
        PageReference resultpage;

        // テストデータ作成
        createData();
        List<JP_QuotationDistributor__c> qd = JP_TestUtil.Create_JP_QuotationDistributor();
        List<JP_QuotationHeader__c> qhlist = JP_TestUtil.Create_JP_QuotationHeader(1);
        qhlist[0].JP_QuotationDistCD__c = qd[0].Id;
        qhlist[0].JP_PreSave__c = false;
        //qhlist[0].JP_QuotationNo__c = '789456';
        insert qhlist;
        
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
        

        List<JP_DistributorPrice__c> dpList = JP_TestUtil.Create_JP_DistributorPrice(3);
        dpList[0].Name = '12345';
        dpList[0].JP_PreRelease__c = true;
        dpList[0].JP_RequiredMaintenanceFlag__c = true;
        dpList[0].JP_CampaignStartDate__c = '20150801';
        dpList[0].JP_PiStock__c = true;
        dpList[0].JP_ProductCode__c = '10000';
        dpList[0].JP_ProductCatalogCode__c = '10000';
        dpList[0].JP_Price_List_Type__c  = '01';
        dpList[0].JP_PriceYearMonth__c = 'JP 2015/10';
        dpList[0].JP_WholeSaleKey__c = dpList[0].JP_Price_List_Type__c + '_' + dpList[0].JP_ProductCatalogCode__c + '_' + dpList[0].JP_PriceYearMonth__c;
        
        dpList[1].Name = '20000';
        dpList[1].JP_PreRelease__c = true;
        dpList[1].JP_RequiredMaintenanceFlag__c = true;
        dpList[1].JP_CampaignStartDate__c = '20150801';
        dpList[1].JP_PiStock__c = true;
        dpList[1].JP_ProductCode__c = '20000';
        dpList[1].JP_ProductCatalogCode__c = '20000';
        dpList[1].JP_Price_List_Type__c  = '01';
        dpList[1].JP_PriceYearMonth__c = 'JP 2015/10';
        dpList[1].JP_WholeSaleKey__c = dpList[1].JP_Price_List_Type__c + '_' + dpList[1].JP_ProductCatalogCode__c + '_' + dpList[1].JP_PriceYearMonth__c;
        
        dpList[2].Name = '30000';
        dpList[2].JP_PreRelease__c = true;
        dpList[2].JP_RequiredMaintenanceFlag__c = true;
        dpList[2].JP_CampaignStartDate__c = '20150801';
        dpList[2].JP_PiStock__c = true;
        dpList[2].JP_ProductCode__c = '30000';
        dpList[2].JP_ProductCatalogCode__c = '30000';
        dpList[2].JP_Price_List_Type__c  = '01';
        dpList[2].JP_PriceYearMonth__c = 'JP 2015/10';
        dpList[2].JP_WholeSaleKey__c = dpList[2].JP_Price_List_Type__c + '_' + dpList[2].JP_ProductCatalogCode__c + '_' + dpList[2].JP_PriceYearMonth__c;
        insert dpList;

        List<JP_QuotationDetail__c> detailList = JP_TestUtil.Create_JP_QuotationDetail(qhlist[0].Id,3);
        detailList[0].JP_ProductCatalogCode__c = dpList[0].Name;
        detailList[0].JP_ProductCode__c = dpList[0].JP_ProductCode__c;
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
        detailList[0].JP_PreSave__c = false;
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

        detailList[1].JP_ProductCatalogCode__c = dpList[1].Name;
        detailList[1].JP_ProductCode__c = dpList[1].JP_ProductCode__c;
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
        detailList[1].JP_PreSave__c = false;
        detailList[1].JP_5PercentDiscount__c = 1200;
        detailList[1].JP_OverLimitDiscount__c = false;
        detailList[1].JP_ProductCode__c = '9999';
        detailList[1].JP_PreRelease__c = false;
        detailList[1].JP_WholeSaleRate__c = 1;
        detailList[1].JP_UnitPrice__c = 1500;
        detailList[1].JP_SpecialWholeSaleTRate__c = 0.8;
        detailList[1].JP_DiscountLimitPrice__c = 800;
        detailList[1].JP_WholeSalePriceMulQuantity__c = detailList[1].JP_UnitPrice__c * detailList[1].JP_WholeSaleRate__c;
        detailList[1].JP_SpecialUnitPriceMulQuantity__c = detailList[1].JP_SpecialUnitPrice__c * detailList[1].JP_Quantity__c;
        detailList[1].JP_StandardMinusSpecial__c = detailList[1].JP_WholeSalePriceMulQuantity__c - detailList[1].JP_SpecialUnitPriceMulQuantity__c;
        detailList[1].JP_DeterminedAmount__c = detailList[1].JP_SpecialUnitPriceMulQuantity__c;

        detailList[2].JP_ProductCatalogCode__c = dpList[2].Name;
        detailList[2].JP_ProductCode__c = dpList[2].JP_ProductCode__c;
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
        detailList[2].JP_PreSave__c = false;
        detailList[2].JP_5PercentDiscount__c = 1200;
        detailList[2].JP_OverLimitDiscount__c = false;
        detailList[2].JP_ProductCode__c = '9999';
        detailList[2].JP_PreRelease__c = false;
        detailList[2].JP_WholeSaleRate__c = 1;
        detailList[2].JP_UnitPrice__c = 1500;
        detailList[2].JP_SpecialWholeSaleTRate__c = 0.8;
        detailList[2].JP_DiscountLimitPrice__c = 800;
        detailList[2].JP_WholeSalePriceMulQuantity__c = detailList[2].JP_UnitPrice__c * detailList[2].JP_WholeSaleRate__c;
        detailList[2].JP_SpecialUnitPriceMulQuantity__c = detailList[2].JP_SpecialUnitPrice__c * detailList[2].JP_Quantity__c;
        detailList[2].JP_StandardMinusSpecial__c = detailList[2].JP_WholeSalePriceMulQuantity__c - detailList[2].JP_SpecialUnitPriceMulQuantity__c;
        detailList[2].JP_DeterminedAmount__c = detailList[2].JP_SpecialUnitPriceMulQuantity__c;
        insert detailList;

        //ApexPages.currentPage().getParameters().put('retURL',qdList[0].id);
        ApexPages.currentPage().getParameters().put('distributorId',qd[0].id);
        ApexPages.currentPage().getParameters().put('spotflg', '0');

        Apexpages.Standardcontroller sc;
        JP_QuotationHeaderController jph;

        system.runAs(user){
            JP_QuotationHeader__c rec = new JP_QuotationHeader__c();

            PageReference pref = Page.JP_QuotationEdit;
            System.Test.setCurrentPage(pref);

            System.Test.startTest();

            sc = new Apexpages.Standardcontroller(rec);
            jph = new JP_QuotationHeaderController(sc);
            jph.QHeader.JP_QuotationDistCD__c = null;
            jph.inputMitumorijyoken1 = '10020';
            jph.inputMitumorijyoken2 = '10030';
            jph.inputMitumorijyoken3 = '10020';
            jph.inputMitumorijyoken4 = '10030';
            jph.inputMitumorijyoken5 = '10020';
            jph.inputMitumorijyoken6 = '10030';
            jph.inputMitumorijyoken7 = '10020';
            jph.inputMitumorijyoken8 = '10030';

            resultpage = jph.doCondition();
            System.Test.stopTest();
        }

        String result = jph.QHeader.JP_QuotationCondition__c;
        system.assertEquals(null,resultpage);
        system.assertNotEquals('',result);
        system.assertEquals(true,result.contains('テスト条件1'));
        system.assertEquals(true,result.contains('テスト条件11'));
        system.assertEquals(true,result.contains('テスト条件6'));
        system.assertEquals(true,result.contains('テスト条件7'));
    }

    /*　見積条件を取得し、ソートして表示4*/
    private static testMethod void testdoCondition4(){
        // テストデータ作成
        createData();
        List<JP_QuotationDistributor__c> qd = JP_TestUtil.Create_JP_QuotationDistributor();
        PageReference resultpage;

        //ApexPages.currentPage().getParameters().put('retURL',qdList[0].id);
        ApexPages.currentPage().getParameters().put('distributorId',qd[0].id);
        //ApexPages.currentPage().getParameters().put('spotflg', '0');

        Apexpages.Standardcontroller sc;
        JP_QuotationHeaderController jph;

        system.runAs(user){
            JP_QuotationHeader__c rec = new JP_QuotationHeader__c();

            PageReference pref = Page.JP_QuotationEdit;
            System.Test.setCurrentPage(pref);

            System.Test.startTest();

            sc = new Apexpages.Standardcontroller(rec);
            jph = new JP_QuotationHeaderController(sc);
            //jph.QHeader.JP_QuotationDistCD__c = null;
            jph.inputMitumorijyoken1 = '10020';
            jph.inputMitumorijyoken2 = '10030';
            jph.inputMitumorijyoken3 = '10020';
            jph.inputMitumorijyoken4 = '10030';
            jph.inputMitumorijyoken5 = '10020';
            jph.inputMitumorijyoken6 = '10030';
            jph.inputMitumorijyoken7 = '10020';
            jph.inputMitumorijyoken8 = '10030';

            resultpage = jph.doCondition();
            System.Test.stopTest();
        }

        String result = jph.QHeader.JP_QuotationCondition__c;
        system.assertEquals(null,resultpage);
        system.assertNotEquals('',result);
        system.assertEquals(true,result.contains('テスト条件11'));
        system.assertEquals(true,result.contains('テスト条件6'));
        system.assertEquals(true,result.contains('テスト条件7'));
    }

    /*　見積条件を取得し、ソートして表示5*/
    private static testMethod void testdoCondition5(){
        PageReference resultpage;

        // テストデータ作成
        createData();
        List<JP_QuotationDistributor__c> qd = JP_TestUtil.Create_JP_QuotationDistributor();
        List<JP_QuotationHeader__c> qhlist = JP_TestUtil.Create_JP_QuotationHeader(1);
        qhlist[0].JP_QuotationDistCD__c = qd[0].Id;
        qhlist[0].JP_PreSave__c = false;
        //qhlist[0].JP_QuotationNo__c = '789456';
        insert qhlist;

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

        List<JP_DistributorPrice__c> dpList = new List<JP_DistributorPrice__c>();
        JP_DistributorPrice__c dp = new JP_DistributorPrice__c();
        dp.Name = '12345';
        dp.JP_ProductCatalogCode__c = '20000';
        dp.JP_Price_List_Type__c  = '01';
        dp.JP_PriceYearMonth__c = 'JP 2015/10';
        dp.JP_WholeSaleKey__c = dp.JP_Price_List_Type__c + '_' + dp.JP_ProductCatalogCode__c + '_' + dp.JP_PriceYearMonth__c;
        dpList.add(dp);
        insert dpList;

        List<JP_QuotationDetail__c> detailList = JP_TestUtil.Create_JP_QuotationDetail(qhlist[0].Id,3);
        detailList[0].JP_ProductCatalogCode__c = dpList[0].Name;
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
        detailList[0].JP_SupportTicketCode__c = 'ON99999';
        detailList[0].JP_PreSave__c = false;
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

        detailList[1].JP_ProductCatalogCode__c = dpList[0].Name;
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
        detailList[1].JP_SupportTicketCode__c = 'ON99999';
        detailList[1].JP_PreSave__c = false;
        detailList[1].JP_5PercentDiscount__c = 1200;
        detailList[1].JP_OverLimitDiscount__c = false;
        detailList[1].JP_ProductCode__c = '9999';
        detailList[1].JP_PreRelease__c = false;
        detailList[1].JP_WholeSaleRate__c = 1;
        detailList[1].JP_UnitPrice__c = 1500;
        detailList[1].JP_SpecialWholeSaleTRate__c = 0.8;
        detailList[1].JP_DiscountLimitPrice__c = 800;
        detailList[1].JP_WholeSalePriceMulQuantity__c = detailList[1].JP_UnitPrice__c * detailList[1].JP_WholeSaleRate__c;
        detailList[1].JP_SpecialUnitPriceMulQuantity__c = detailList[1].JP_SpecialUnitPrice__c * detailList[1].JP_Quantity__c;
        detailList[1].JP_StandardMinusSpecial__c = detailList[1].JP_WholeSalePriceMulQuantity__c - detailList[1].JP_SpecialUnitPriceMulQuantity__c;
        detailList[1].JP_DeterminedAmount__c = detailList[1].JP_SpecialUnitPriceMulQuantity__c;

        detailList[2].JP_ProductCatalogCode__c = dpList[0].Name;
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
        detailList[2].JP_PreSave__c = false;
        detailList[2].JP_5PercentDiscount__c = 1200;
        detailList[2].JP_OverLimitDiscount__c = false;
        detailList[2].JP_ProductCode__c = '9999';
        detailList[2].JP_PreRelease__c = false;
        detailList[2].JP_WholeSaleRate__c = 1;
        detailList[2].JP_UnitPrice__c = 1500;
        detailList[2].JP_SpecialWholeSaleTRate__c = 0.8;
        detailList[2].JP_DiscountLimitPrice__c = 800;
        detailList[2].JP_WholeSalePriceMulQuantity__c = detailList[2].JP_UnitPrice__c * detailList[2].JP_WholeSaleRate__c;
        detailList[2].JP_SpecialUnitPriceMulQuantity__c = detailList[2].JP_SpecialUnitPrice__c * detailList[2].JP_Quantity__c;
        detailList[2].JP_StandardMinusSpecial__c = detailList[2].JP_WholeSalePriceMulQuantity__c - detailList[2].JP_SpecialUnitPriceMulQuantity__c;
        detailList[2].JP_DeterminedAmount__c = detailList[2].JP_SpecialUnitPriceMulQuantity__c;
        insert detailList;

        //ApexPages.currentPage().getParameters().put('retURL',qdList[0].id);
        ApexPages.currentPage().getParameters().put('distributorId',qd[0].id);
        ApexPages.currentPage().getParameters().put('spotflg', '0');

        Apexpages.Standardcontroller sc;
        JP_QuotationHeaderController jph;

        system.runAs(user){
            JP_QuotationHeader__c rec = new JP_QuotationHeader__c();

            PageReference pref = Page.JP_QuotationEdit;
            System.Test.setCurrentPage(pref);

            System.Test.startTest();

            sc = new Apexpages.Standardcontroller(qhlist[0]);
            jph = new JP_QuotationHeaderController(sc);
            jph.QHeader.JP_QuotationDistCD__c = null;
            jph.inputMitumorijyoken1 = '10020';
            jph.inputMitumorijyoken2 = '10030';
            jph.inputMitumorijyoken3 = '10020';
            jph.inputMitumorijyoken4 = '10030';
            jph.inputMitumorijyoken5 = '10020';
            jph.inputMitumorijyoken6 = '10030';
            jph.inputMitumorijyoken7 = '10020';
            jph.inputMitumorijyoken8 = '10030';

            resultpage = jph.doCondition();
            System.Test.stopTest();
        }

        String result = jph.QHeader.JP_QuotationCondition__c;
        system.assertEquals(null,resultpage);
        system.assertNotEquals('',result);
        system.assertEquals(true,result.contains('テスト条件1'));
        system.assertEquals(true,result.contains('テスト条件11'));
        system.assertEquals(true,result.contains('テスト条件6'));
        system.assertEquals(true,result.contains('テスト条件7'));
    }

    /*　見積条件を取得し、ソートして表示6*/
    private static testMethod void testdoCondition6(){
        PageReference resultpage;

        // テストデータ作成
        createData();
        List<JP_QuotationDistributor__c> qd = JP_TestUtil.Create_JP_QuotationDistributor();
        qd[0].JP_SpotDistributor__c = true;
        update qd;

        List<JP_QuotationHeader__c> qhlist = JP_TestUtil.Create_JP_QuotationHeader(1);
        qhlist[0].JP_QuotationDistCD__c = qd[0].Id;
        qhlist[0].JP_PreSave__c = false;
        //qhlist[0].JP_QuotationNo__c = '789456';
        insert qhlist;
        
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

        List<JP_DistributorPrice__c> dpList = new List<JP_DistributorPrice__c>();
        JP_DistributorPrice__c dp = new JP_DistributorPrice__c();
        dp.Name = '12345';
        dp.JP_ProductCatalogCode__c = '12345';
        dp.JP_Price_List_Type__c  = '01';
        dp.JP_PriceYearMonth__c = 'JP 2015/10';
        dp.JP_PiStock__c = true;
        dp.JP_CampaignStartDate__c = '20150801';
        dp.JP_PreRelease__c = true;
        dp.JP_RequiredMaintenanceFlag__c = true;
        dp.JP_WholeSaleKey__c = dp.JP_Price_List_Type__c + '_' + dp.JP_ProductCatalogCode__c + '_' + dp.JP_PriceYearMonth__c;
        dpList.add(dp);
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
        detailList[0].JP_SupportTicketCode__c = 'ON99999';
        detailList[0].JP_PreSave__c = false;
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
        detailList[1].JP_SupportTicketCode__c = 'ON99999';
        detailList[1].JP_PreSave__c = false;
        detailList[1].JP_5PercentDiscount__c = 1200;
        detailList[1].JP_OverLimitDiscount__c = false;
        detailList[1].JP_ProductCode__c = '9999';
        detailList[1].JP_PreRelease__c = false;
        detailList[1].JP_WholeSaleRate__c = 1;
        detailList[1].JP_UnitPrice__c = 1500;
        detailList[1].JP_SpecialWholeSaleTRate__c = 0.8;
        detailList[1].JP_DiscountLimitPrice__c = 800;
        detailList[1].JP_WholeSalePriceMulQuantity__c = detailList[1].JP_UnitPrice__c * detailList[1].JP_WholeSaleRate__c;
        detailList[1].JP_SpecialUnitPriceMulQuantity__c = detailList[1].JP_SpecialUnitPrice__c * detailList[1].JP_Quantity__c;
        detailList[1].JP_StandardMinusSpecial__c = detailList[1].JP_WholeSalePriceMulQuantity__c - detailList[1].JP_SpecialUnitPriceMulQuantity__c;
        detailList[1].JP_DeterminedAmount__c = detailList[1].JP_SpecialUnitPriceMulQuantity__c;

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
        detailList[2].JP_PreSave__c = false;
        detailList[2].JP_5PercentDiscount__c = 1200;
        detailList[2].JP_OverLimitDiscount__c = false;
        detailList[2].JP_ProductCode__c = '9999';
        detailList[2].JP_PreRelease__c = false;
        detailList[2].JP_WholeSaleRate__c = 1;
        detailList[2].JP_UnitPrice__c = 1500;
        detailList[2].JP_SpecialWholeSaleTRate__c = 0.8;
        detailList[2].JP_DiscountLimitPrice__c = 800;
        detailList[2].JP_WholeSalePriceMulQuantity__c = detailList[2].JP_UnitPrice__c * detailList[2].JP_WholeSaleRate__c;
        detailList[2].JP_SpecialUnitPriceMulQuantity__c = detailList[2].JP_SpecialUnitPrice__c * detailList[2].JP_Quantity__c;
        detailList[2].JP_StandardMinusSpecial__c = detailList[2].JP_WholeSalePriceMulQuantity__c - detailList[2].JP_SpecialUnitPriceMulQuantity__c;
        detailList[2].JP_DeterminedAmount__c = detailList[2].JP_SpecialUnitPriceMulQuantity__c;
        insert detailList;

        Apexpages.Standardcontroller sc;
        JP_QuotationHeaderController jph;

        system.runAs(user){
            JP_QuotationHeader__c rec = new JP_QuotationHeader__c();

            PageReference pref = Page.JP_QuotationEdit;
            System.Test.setCurrentPage(pref);

            ApexPages.currentPage().getParameters().put('distributorId',qd[0].id);
            ApexPages.currentPage().getParameters().put('spotflg', '1');

            System.Test.startTest();

            sc = new Apexpages.Standardcontroller(qhlist[0]);
            jph = new JP_QuotationHeaderController(sc);
            jph.inputMitumorijyoken1 = '10020';
            jph.inputMitumorijyoken2 = '10030';
            jph.inputMitumorijyoken3 = '10020';
            jph.inputMitumorijyoken4 = '10030';
            jph.inputMitumorijyoken5 = '10020';
            jph.inputMitumorijyoken6 = '10030';
            jph.inputMitumorijyoken7 = '10020';
            jph.inputMitumorijyoken8 = '10030';

            resultpage = jph.doCondition();
            System.Test.stopTest();
        }

        String result = jph.QHeader.JP_QuotationCondition__c;
        system.assertEquals(null,resultpage);
        system.assertNotEquals('',result);
        system.assertEquals(true,result.contains('テスト条件1'));
        system.assertEquals(true,result.contains('テスト条件22'));
        system.assertEquals(true,result.contains('テスト条件6'));
        system.assertEquals(true,result.contains('テスト条件7'));
    }

    /*　見積条件を取得し、ソートして表示7*/
    private static testMethod void testdoCondition7(){
        // テストデータ作成
        createData();

        List<JP_QuotationCondition__c> recList = [Select Id,Name From JP_QuotationCondition__c];
        delete recList;

        List<JP_QuotationDistributor__c> qd = JP_TestUtil.Create_JP_QuotationDistributor();
        PageReference resultpage;

        //ApexPages.currentPage().getParameters().put('retURL',qdList[0].id);
        ApexPages.currentPage().getParameters().put('distributorId',qd[0].id);
        //ApexPages.currentPage().getParameters().put('spotflg', '0');

        Apexpages.Standardcontroller sc;
        JP_QuotationHeaderController jph;

        system.runAs(user){
            JP_QuotationHeader__c rec = new JP_QuotationHeader__c();

            PageReference pref = Page.JP_QuotationEdit;
            System.Test.setCurrentPage(pref);

            System.Test.startTest();

            sc = new Apexpages.Standardcontroller(rec);
            jph = new JP_QuotationHeaderController(sc);
            //jph.QHeader.JP_QuotationDistCD__c = null;

            resultpage = jph.doCondition();
            System.Test.stopTest();
        }

        String result = jph.QHeader.JP_QuotationCondition__c;
        system.assertEquals(null,resultpage);
        system.assertEquals('',result);

    }

    /*行追加*/
    private static testMethod void testaddRow(){
        // テストデータ作成
        createData();
        qdList = JP_TestUtil.Create_JP_QuotationDistributor();

        system.runAs(user){
            JP_QuotationHeader__c rec = new JP_QuotationHeader__c();

            PageReference pref = Page.JP_QuotationEdit;
            System.Test.setCurrentPage(pref);
            ApexPages.currentPage().getParameters().put('retURL',qdList[0].id);
            ApexPages.currentPage().getParameters().put('distributorId',qdList[0].id);
            ApexPages.currentPage().getParameters().put('spotflg', '0');

            System.Test.startTest();

            Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
            JP_QuotationHeaderController jph = new JP_QuotationHeaderController(sc);
            jph.addRow();

            System.Test.stopTest();
        }
    }
    
    /*行追加*/
    private static testMethod void testaddRow10(){
        // テストデータ作成
        createData();
        qdList = JP_TestUtil.Create_JP_QuotationDistributor();

        system.runAs(user){
            JP_QuotationHeader__c rec = new JP_QuotationHeader__c();

            PageReference pref = Page.JP_QuotationEdit;
            System.Test.setCurrentPage(pref);
            ApexPages.currentPage().getParameters().put('retURL',qdList[0].id);
            ApexPages.currentPage().getParameters().put('distributorId',qdList[0].id);
            ApexPages.currentPage().getParameters().put('spotflg', '0');

            System.Test.startTest();

            Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
            JP_QuotationHeaderController jph = new JP_QuotationHeaderController(sc);
            jph.addRow10();

            System.Test.stopTest();
        }
    }

    /*行挿入*/
    private static testMethod void testinsertRow(){
        // テストデータ作成
        createData();
        qdList = JP_TestUtil.Create_JP_QuotationDistributor();

        system.runAs(user){
            JP_QuotationHeader__c rec = new JP_QuotationHeader__c();

            PageReference pref = Page.JP_QuotationEdit;
            System.Test.setCurrentPage(pref);
            ApexPages.currentPage().getParameters().put('retURL',qdList[0].id);
            ApexPages.currentPage().getParameters().put('distributorId',qdList[0].id);
            ApexPages.currentPage().getParameters().put('spotflg', '0');

            System.Test.startTest();

            Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
            JP_QuotationHeaderController jph = new JP_QuotationHeaderController(sc);

            ApexPages.currentPage().getParameters().put('vf_rownumber', '0');
            jph.insertRow();

            System.Test.stopTest();
        }
    }

    /*行ソート*/
    private static testMethod void testsortRows(){
        // テストデータ作成
        createData();
        List<JP_QuotationDistributor__c> qd = JP_TestUtil.Create_JP_QuotationDistributor();
        List<JP_QuotationHeader__c> qhlist = JP_TestUtil.Create_JP_QuotationHeader(1);
        qhlist[0].JP_QuotationDistCD__c = qd[0].Id;
        //qhlist[0].JP_QuotationNo__c = '789456';
        insert qhlist;

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
        

        List<JP_DistributorPrice__c> dpList = JP_TestUtil.Create_JP_DistributorPrice(3);
        dpList[0].Name = '12345';
        dpList[0].JP_PreRelease__c = true;
        dpList[0].JP_RequiredMaintenanceFlag__c = true;
        dpList[0].JP_CampaignStartDate__c = '20150801';
        dpList[0].JP_PiStock__c = true;
        dpList[0].JP_ProductCode__c = '10000';
        dpList[0].JP_ProductCatalogCode__c = '10000';
        dpList[0].JP_Price_List_Type__c  = '01';
        dpList[0].JP_PriceYearMonth__c = 'JP 2015/10';
        dpList[0].JP_WholeSaleKey__c = dpList[0].JP_Price_List_Type__c + '_' + dpList[0].JP_ProductCatalogCode__c + '_' + dpList[0].JP_PriceYearMonth__c;
        
        dpList[1].Name = '20000';
        dpList[1].JP_PreRelease__c = true;
        dpList[1].JP_RequiredMaintenanceFlag__c = true;
        dpList[1].JP_CampaignStartDate__c = '20150801';
        dpList[1].JP_PiStock__c = true;
        dpList[1].JP_ProductCode__c = '20000';
        dpList[1].JP_ProductCatalogCode__c = '20000';
        dpList[1].JP_Price_List_Type__c  = '01';
        dpList[1].JP_PriceYearMonth__c = 'JP 2015/10';
        dpList[1].JP_WholeSaleKey__c = dpList[1].JP_Price_List_Type__c + '_' + dpList[1].JP_ProductCatalogCode__c + '_' + dpList[1].JP_PriceYearMonth__c;
        
        dpList[2].Name = '30000';
        dpList[2].JP_PreRelease__c = true;
        dpList[2].JP_RequiredMaintenanceFlag__c = true;
        dpList[2].JP_CampaignStartDate__c = '20150801';
        dpList[2].JP_PiStock__c = true;
        dpList[2].JP_ProductCode__c = '30000';
        dpList[2].JP_ProductCatalogCode__c = '30000';
        dpList[2].JP_Price_List_Type__c  = '01';
        dpList[2].JP_PriceYearMonth__c = 'JP 2015/10';
        dpList[2].JP_WholeSaleKey__c = dpList[2].JP_Price_List_Type__c + '_' + dpList[2].JP_ProductCatalogCode__c + '_' + dpList[2].JP_PriceYearMonth__c;
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
        detailList[0].JP_SupportTicketCode__c = 'ON99999';
        detailList[0].JP_PreSave__c = false;
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

        detailList[1].JP_ProductCatalogCode__c = dpList[1].JP_ProductCatalogCode__c;
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
        detailList[1].JP_SupportTicketCode__c = 'ON99999';
        detailList[1].JP_PreSave__c = false;
        detailList[1].JP_5PercentDiscount__c = 1200;
        detailList[1].JP_OverLimitDiscount__c = false;
        detailList[1].JP_ProductCode__c = '9999';
        detailList[1].JP_PreRelease__c = false;
        detailList[1].JP_WholeSaleRate__c = 1;
        detailList[1].JP_UnitPrice__c = 1500;
        detailList[1].JP_SpecialWholeSaleTRate__c = 0.8;
        detailList[1].JP_DiscountLimitPrice__c = 800;
        detailList[1].JP_WholeSalePriceMulQuantity__c = detailList[1].JP_UnitPrice__c * detailList[1].JP_WholeSaleRate__c;
        detailList[1].JP_SpecialUnitPriceMulQuantity__c = detailList[1].JP_SpecialUnitPrice__c * detailList[1].JP_Quantity__c;
        detailList[1].JP_StandardMinusSpecial__c = detailList[1].JP_WholeSalePriceMulQuantity__c - detailList[1].JP_SpecialUnitPriceMulQuantity__c;
        detailList[1].JP_DeterminedAmount__c = detailList[1].JP_SpecialUnitPriceMulQuantity__c;

        detailList[2].JP_ProductCatalogCode__c = dpList[2].JP_ProductCatalogCode__c;
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
        detailList[2].JP_PreSave__c = false;
        detailList[2].JP_5PercentDiscount__c = 1200;
        detailList[2].JP_OverLimitDiscount__c = false;
        detailList[2].JP_ProductCode__c = '9999';
        detailList[2].JP_PreRelease__c = false;
        detailList[2].JP_WholeSaleRate__c = 1;
        detailList[2].JP_UnitPrice__c = 1500;
        detailList[2].JP_SpecialWholeSaleTRate__c = 0.8;
        detailList[2].JP_DiscountLimitPrice__c = 800;
        detailList[2].JP_WholeSalePriceMulQuantity__c = detailList[2].JP_UnitPrice__c * detailList[2].JP_WholeSaleRate__c;
        detailList[2].JP_SpecialUnitPriceMulQuantity__c = detailList[2].JP_SpecialUnitPrice__c * detailList[2].JP_Quantity__c;
        detailList[2].JP_StandardMinusSpecial__c = detailList[2].JP_WholeSalePriceMulQuantity__c - detailList[2].JP_SpecialUnitPriceMulQuantity__c;
        detailList[2].JP_DeterminedAmount__c = detailList[2].JP_SpecialUnitPriceMulQuantity__c;
        insert detailList;

        system.runAs(user){
            JP_QuotationHeader__c rec = new JP_QuotationHeader__c();

            PageReference pref = Page.JP_QuotationEdit;
            System.Test.setCurrentPage(pref);

            ApexPages.currentPage().getParameters().put('distributorId',qd[0].id);
            ApexPages.currentPage().getParameters().put('spotflg', '0');

            System.Test.startTest();

            Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(qhlist[0]);
            JP_QuotationHeaderController jph = new JP_QuotationHeaderController(sc);
            jph.sortRows();

            ApexPages.currentPage().getParameters().put('vf_rownumber2', '1');
            jph.upRow();
            ApexPages.currentPage().getParameters().put('vf_rownumber3', '0');
            jph.downRow();

            System.Test.stopTest();
        }

    }

    /*行削除*/
    private static testMethod void testdeleteRows1(){
        // テストデータ作成
        createData();
        List<JP_QuotationDistributor__c> qd = JP_TestUtil.Create_JP_QuotationDistributor();
        List<JP_QuotationHeader__c> qhlist = JP_TestUtil.Create_JP_QuotationHeader(1);
        qhlist[0].JP_QuotationDistCD__c = qd[0].Id;
        //qhlist[0].JP_QuotationNo__c = '789456';
        insert qhlist;
        
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

        system.runAs(user){
            JP_QuotationHeader__c rec = new JP_QuotationHeader__c();

            PageReference pref = Page.JP_QuotationEdit;
            System.Test.setCurrentPage(pref);

            ApexPages.currentPage().getParameters().put('distributorId',qd[0].id);
            ApexPages.currentPage().getParameters().put('spotflg', '0');

            System.Test.startTest();

            Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(qhlist[0]);
            JP_QuotationHeaderController jph = new JP_QuotationHeaderController(sc);
            jph.deleteRows();

            System.Test.stopTest();
        }

    }

    /*行削除*/
    private static testMethod void testdeleteRows2(){
        // テストデータ作成
        createData();
        List<JP_QuotationDistributor__c> qd = JP_TestUtil.Create_JP_QuotationDistributor();
        List<JP_QuotationHeader__c> qhlist = JP_TestUtil.Create_JP_QuotationHeader(1);
        qhlist[0].JP_QuotationDistCD__c = qd[0].Id;
        //qhlist[0].JP_QuotationNo__c = '789456';
        insert qhlist;
        
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

        List<JP_DistributorPrice__c> dpList = new List<JP_DistributorPrice__c>();
        JP_DistributorPrice__c dp = new JP_DistributorPrice__c();
        dp.Name = '12345';
        dp.JP_ProductCatalogCode__c = '20000';
        dp.JP_Price_List_Type__c  = '01';
        dp.JP_PriceYearMonth__c = 'JP 2015/10';
        dp.JP_WholeSaleKey__c = dp.JP_Price_List_Type__c + '_' + dp.JP_ProductCatalogCode__c + '_' + dp.JP_PriceYearMonth__c;
        dpList.add(dp);
        insert dpList;

        List<JP_QuotationDetail__c> detailList = JP_TestUtil.Create_JP_QuotationDetail(qhlist[0].Id,2);
        detailList[0].JP_ProductCatalogCode__c = dpList[0].Name;
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

        detailList[1].JP_ProductCatalogCode__c = dpList[0].Name;
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

        insert detailList;

        system.runAs(user){
            JP_QuotationHeader__c rec = new JP_QuotationHeader__c();

            PageReference pref = Page.JP_QuotationEdit;
            System.Test.setCurrentPage(pref);

            ApexPages.currentPage().getParameters().put('distributorId',qd[0].id);
            ApexPages.currentPage().getParameters().put('spotflg', '0');

            System.Test.startTest();

            Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(qhlist[0]);
            JP_QuotationHeaderController jph = new JP_QuotationHeaderController(sc);
            jph.QDetailList[0].selected = true;
            jph.QDetailList[1].selected = true;
            jph.deleteRows();

            System.Test.stopTest();
        }
    }
    
    /*エラー*/
    private static testMethod void testerror(){
        // テストデータ作成
        createData();
        List<JP_QuotationDistributor__c> qd = JP_TestUtil.Create_JP_QuotationDistributor();
        List<JP_QuotationHeader__c> qhlist = JP_TestUtil.Create_JP_QuotationHeader(1);
        qhlist[0].JP_QuotationDistCD__c = qd[0].Id;
        //qhlist[0].JP_QuotationNo__c = '789456';
        insert qhlist;
        
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

        List<JP_DistributorPrice__c> dpList = new List<JP_DistributorPrice__c>();
        JP_DistributorPrice__c dp = new JP_DistributorPrice__c();
        dp.Name = '12345';
        dp.JP_ProductCatalogCode__c = '20000';
        dp.JP_Price_List_Type__c  = '01';
        dp.JP_PriceYearMonth__c = 'JP 2015/10';
        dp.JP_WholeSaleKey__c = dp.JP_Price_List_Type__c + '_' + dp.JP_ProductCatalogCode__c + '_' + dp.JP_PriceYearMonth__c;
        dpList.add(dp);
        insert dpList;

        List<JP_QuotationDetail__c> detailList = JP_TestUtil.Create_JP_QuotationDetail(qhlist[0].Id,2);
        detailList[0].JP_ProductCatalogCode__c = '';
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

        detailList[1].JP_ProductCatalogCode__c = dpList[0].Name;
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

        insert detailList;

        system.runAs(user){
            JP_QuotationHeader__c rec = new JP_QuotationHeader__c();

            PageReference pref = Page.JP_QuotationEdit;
            System.Test.setCurrentPage(pref);

            ApexPages.currentPage().getParameters().put('distributorId',qd[0].id);
            ApexPages.currentPage().getParameters().put('spotflg', '0');

            System.Test.startTest();

            Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(qhlist[0]);
            JP_QuotationHeaderController jph = new JP_QuotationHeaderController(sc);
            jph.QDetailList[0].selected = true;
            jph.QDetailList[1].selected = true;
            jph.deleteRows();

            System.Test.stopTest();
        }
    }

    /**
     * 価格表プルダウン取得
     */
    private static testMethod void testGetPriceYearMonthList() {
        // テストデータ作成
        qdList = JP_TestUtil.Create_JP_QuotationDistributor();
        JP_QuotationDistributor__c qd = qdList.get(0);
        List<JP_QuotationHeader__c> qhlist = JP_TestUtil.Create_JP_QuotationHeader(1);
        qhlist[0].JP_QuotationDistCD__c = qd.Id;
        insert qhList;
        List<JP_PriceYearMonth__c> pymList = JP_TestUtil.Create_JP_PriceYearMonth(2);

        // 前月から2ヶ月分の価格年月作成
        Integer addMonth = -1;
        for (JP_PriceYearMonth__c pym : pymList) {
            String yearMonth = String.valueOf(Date.today().addMonths(addMonth).year()) + '/' + String.valueOf(Date.today().addMonths(addMonth).month()).leftPad(2, '0');
            pym.JP_PriceYearMonth__c = 'JP ' + yearMonth;
            pym.JP_Price_List_Type__c = qd.JP_Price_List_Type__c;
            ++addMonth;
        }
        insert pymList;

        // テスト開始
        System.Test.startTest();
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(qhlist[0]);
        JP_QuotationHeaderController jph = new JP_QuotationHeaderController(sc);
        System.assertEquals(2, jph.getPriceYearMonthList().size());
        System.Test.stopTest();
    }

    /**
     * 商品検索(正常系：商品正常検索)
     */
    private static testMethod void testSearchProductInfo_Normal01() {
        // テストデータ作成
        qdList = JP_TestUtil.Create_JP_QuotationDistributor();
        JP_QuotationDistributor__c qd = qdList.get(0);
        List<JP_QuotationHeader__c> qhlist = JP_TestUtil.Create_JP_QuotationHeader(1);
        qhlist[0].JP_QuotationDistCD__c = qd.Id;
        insert qhList;
        
        JP_ApprovalProcessMaster__c apm = JP_TestUtil.Create_JP_ApprovalProcessMaster(1);
        JP_DecideApprovalProcess__c dap = new JP_DecideApprovalProcess__c();
        dap.JP_ApprovalProcessMaster__c = apm.Id;
        dap.JP_ChkTotalAmountCD__c = 'A1';
        dap.JP_ChkWholeSaleCD__c = 'B1';
        dap.JP_ChkLimitDiscountCD__c = 'C1';
        dap.JP_ChkRegisteredProductCD__c = 'D1';
        dap.JP_ChkQuotationExpiryDateCD__c = 'E1';
        dap.JP_ChkPreReleaseCD__c = 'F1';
        //dap.JP_ChkkProductResponsibleCD__c = 'G1';
        insert dap;

        List<JP_QuotationDetail__c> detailList = JP_TestUtil.Create_JP_QuotationDetail(qhlist[0].Id,7);
        detailList[0].JP_ProductCatalogCode__c = 'test';
        detailList[0].JP_ProductName__c = 'testName';
        detailList[0].JP_Sort__c = 1;
        detailList[0].JP_Quantity__c = 1;
        detailList[0].JP_SpecialUnitPrice__c = 1000;
        detailList[0].JP_WholeSalePriceMulQuantity__c = 1000;
        detailList[0].JP_SpecialUnitPriceMulQuantity__c = 1000;
        detailList[0].JP_StandardMinusSpecial__c = 1000;
        detailList[0].JP_StandardPrice__c = 100;
        detailList[0].JP_DeterminedAmount__c = 1000;
        detailList[0].JP_PriceYearMonth__c = 'JP ' + Date.today().year() + '/' + Date.today().month();
        detailList[0].JP_AppGroupID__c = 'G2';
        detailList[0].JP_5PercentDiscount__c = 1200;
        detailList[0].JP_OverLimitDiscount__c = false;
        detailList[0].JP_ProductCode__c = '9999';
        detailList[0].JP_PreRelease__c = false;
        detailList[0].JP_WholeSaleRate__c = 1;
        detailList[0].JP_UnitPrice__c = 300;
        detailList[0].JP_SpecialWholeSaleTRate__c = 0.8;
        detailList[0].JP_DiscountLimitPrice__c = 800;
        detailList[0].JP_WholeSalePriceMulQuantity__c = detailList[0].JP_UnitPrice__c * detailList[0].JP_WholeSaleRate__c;
        detailList[0].JP_SpecialUnitPriceMulQuantity__c = detailList[0].JP_SpecialUnitPrice__c * detailList[0].JP_Quantity__c;
        detailList[0].JP_StandardMinusSpecial__c = detailList[0].JP_WholeSalePriceMulQuantity__c - detailList[0].JP_SpecialUnitPriceMulQuantity__c;
        detailList[0].JP_DeterminedAmount__c = detailList[0].JP_SpecialUnitPriceMulQuantity__c;
        detailList[0].JP_PreSave__c = true;

        detailList[1].JP_ProductCatalogCode__c = 'test';
        detailList[1].JP_ProductName__c = 'testName';
        detailList[1].JP_Sort__c = 2;
        detailList[1].JP_Quantity__c = 1;
        detailList[1].JP_SpecialUnitPrice__c = 1000;
        detailList[1].JP_WholeSalePriceMulQuantity__c = 1000;
        detailList[1].JP_SpecialUnitPriceMulQuantity__c = 1000;
        detailList[1].JP_StandardMinusSpecial__c = 1000;
        detailList[1].JP_StandardPrice__c = 100;
        detailList[1].JP_DeterminedAmount__c = 1000;
        detailList[1].JP_PriceYearMonth__c = 'JP ' + Date.today().year() + '/' + Date.today().month();
        detailList[1].JP_AppGroupID__c = 'G2';
        detailList[1].JP_5PercentDiscount__c = 1200;
        detailList[1].JP_OverLimitDiscount__c = false;
        detailList[1].JP_ProductCode__c = '9999';
        detailList[1].JP_PreRelease__c = false;
        detailList[1].JP_WholeSaleRate__c = 1;
        detailList[1].JP_UnitPrice__c = 300;
        detailList[1].JP_SpecialWholeSaleTRate__c = 0.8;
        detailList[1].JP_DiscountLimitPrice__c = 800;
        detailList[1].JP_WholeSalePriceMulQuantity__c = detailList[0].JP_UnitPrice__c * detailList[0].JP_WholeSaleRate__c;
        detailList[1].JP_SpecialUnitPriceMulQuantity__c = detailList[0].JP_SpecialUnitPrice__c * detailList[0].JP_Quantity__c;
        detailList[1].JP_StandardMinusSpecial__c = detailList[0].JP_WholeSalePriceMulQuantity__c - detailList[0].JP_SpecialUnitPriceMulQuantity__c;
        detailList[1].JP_DeterminedAmount__c = detailList[0].JP_SpecialUnitPriceMulQuantity__c;
        detailList[1].JP_PreSave__c = true;

        detailList[2].JP_ProductCatalogCode__c = 'test';
        detailList[2].JP_ProductName__c = 'testName';
        detailList[2].JP_Sort__c = 3;
        detailList[2].JP_Quantity__c = 1;
        detailList[2].JP_SpecialUnitPrice__c = 1000;
        detailList[2].JP_WholeSalePriceMulQuantity__c = 1000;
        detailList[2].JP_SpecialUnitPriceMulQuantity__c = 1000;
        detailList[2].JP_StandardMinusSpecial__c = 1000;
        detailList[2].JP_StandardPrice__c = 100;
        detailList[2].JP_DeterminedAmount__c = 1000;
        detailList[2].JP_PriceYearMonth__c = 'JP ' + Date.today().year() + '/' + Date.today().month();
        detailList[2].JP_AppGroupID__c = 'G2';
        detailList[2].JP_5PercentDiscount__c = 1200;
        detailList[2].JP_OverLimitDiscount__c = false;
        detailList[2].JP_ProductCode__c = '9999';
        detailList[2].JP_PreRelease__c = false;
        detailList[2].JP_WholeSaleRate__c = 1;
        detailList[2].JP_UnitPrice__c = 300;
        detailList[2].JP_SpecialWholeSaleTRate__c = 0.8;
        detailList[2].JP_DiscountLimitPrice__c = 800;
        detailList[2].JP_WholeSalePriceMulQuantity__c = detailList[0].JP_UnitPrice__c * detailList[0].JP_WholeSaleRate__c;
        detailList[2].JP_SpecialUnitPriceMulQuantity__c = detailList[0].JP_SpecialUnitPrice__c * detailList[0].JP_Quantity__c;
        detailList[2].JP_StandardMinusSpecial__c = detailList[0].JP_WholeSalePriceMulQuantity__c - detailList[0].JP_SpecialUnitPriceMulQuantity__c;
        detailList[2].JP_DeterminedAmount__c = detailList[0].JP_SpecialUnitPriceMulQuantity__c;
        detailList[2].JP_PreSave__c = true;
        
        detailList[3].JP_ProductCatalogCode__c = 'MEMO-00000';
        detailList[3].JP_ProductName__c = 'testName';
        detailList[3].JP_Sort__c = 4;
        detailList[3].JP_Quantity__c = 1;
        detailList[3].JP_SpecialUnitPrice__c = 1000;
        detailList[3].JP_WholeSalePriceMulQuantity__c = 1000;
        detailList[3].JP_SpecialUnitPriceMulQuantity__c = 1000;
        detailList[3].JP_StandardMinusSpecial__c = 1000;
        detailList[3].JP_StandardPrice__c = 100;
        detailList[3].JP_DeterminedAmount__c = 1000;
        detailList[3].JP_PriceYearMonth__c = 'JP ' + Date.today().year() + '/' + Date.today().month();
        detailList[3].JP_AppGroupID__c = 'G2';
        detailList[3].JP_5PercentDiscount__c = 1200;
        detailList[3].JP_OverLimitDiscount__c = false;
        detailList[3].JP_ProductCode__c = '9999';
        detailList[3].JP_PreRelease__c = false;
        detailList[3].JP_WholeSaleRate__c = 1;
        detailList[3].JP_UnitPrice__c = 300;
        detailList[3].JP_SpecialWholeSaleTRate__c = 0.8;
        detailList[3].JP_DiscountLimitPrice__c = 800;
        detailList[3].JP_WholeSalePriceMulQuantity__c = detailList[3].JP_UnitPrice__c * detailList[3].JP_WholeSaleRate__c;
        detailList[3].JP_SpecialUnitPriceMulQuantity__c = detailList[3].JP_SpecialUnitPrice__c * detailList[3].JP_Quantity__c;
        detailList[3].JP_StandardMinusSpecial__c = detailList[3].JP_WholeSalePriceMulQuantity__c - detailList[3].JP_SpecialUnitPriceMulQuantity__c;
        detailList[3].JP_DeterminedAmount__c = detailList[3].JP_SpecialUnitPriceMulQuantity__c;
        detailList[3].JP_PreSave__c = true;
        
        detailList[4].JP_ProductCatalogCode__c = '****';
        detailList[4].JP_ProductName__c = 'testName';
        detailList[4].JP_Sort__c = 5;
        detailList[4].JP_Quantity__c = 1;
        detailList[4].JP_SpecialUnitPrice__c = 1000;
        detailList[4].JP_WholeSalePriceMulQuantity__c = 1000;
        detailList[4].JP_SpecialUnitPriceMulQuantity__c = 1000;
        detailList[4].JP_StandardMinusSpecial__c = 1000;
        detailList[4].JP_StandardPrice__c = 100;
        detailList[4].JP_DeterminedAmount__c = 1000;
        detailList[4].JP_PriceYearMonth__c = 'JP ' + Date.today().year() + '/' + Date.today().month();
        detailList[4].JP_AppGroupID__c = 'G2';
        detailList[4].JP_5PercentDiscount__c = 1200;
        detailList[4].JP_OverLimitDiscount__c = false;
        detailList[4].JP_ProductCode__c = '9999';
        detailList[4].JP_PreRelease__c = false;
        detailList[4].JP_WholeSaleRate__c = 1;
        detailList[4].JP_UnitPrice__c = 300;
        detailList[4].JP_SpecialWholeSaleTRate__c = 0.8;
        detailList[4].JP_DiscountLimitPrice__c = 800;
        detailList[4].JP_WholeSalePriceMulQuantity__c = detailList[4].JP_UnitPrice__c * detailList[4].JP_WholeSaleRate__c;
        detailList[4].JP_SpecialUnitPriceMulQuantity__c = detailList[4].JP_SpecialUnitPrice__c * detailList[4].JP_Quantity__c;
        detailList[4].JP_StandardMinusSpecial__c = detailList[4].JP_WholeSalePriceMulQuantity__c - detailList[4].JP_SpecialUnitPriceMulQuantity__c;
        detailList[4].JP_DeterminedAmount__c = detailList[4].JP_SpecialUnitPriceMulQuantity__c;
        detailList[4].JP_PreSave__c = true;
        
        detailList[5].JP_ProductCatalogCode__c = '12345';
        detailList[5].JP_ProductName__c = 'testName';
        detailList[5].JP_Sort__c = 6;
        detailList[5].JP_Quantity__c = 1;
        detailList[5].JP_SpecialUnitPrice__c = 0;
        detailList[5].JP_SpecialUnitPriceMulQuantity__c = 1000;
        detailList[5].JP_StandardMinusSpecial__c = 1000;
        detailList[5].JP_StandardPrice__c = 100;
        detailList[5].JP_DeterminedAmount__c = 1000;
        detailList[5].JP_PriceYearMonth__c = 'JP ' + Date.today().year() + '/' + Date.today().month();
        detailList[5].JP_AppGroupID__c = 'G2';
        detailList[5].JP_5PercentDiscount__c = 1200;
        detailList[5].JP_OverLimitDiscount__c = false;
        detailList[5].JP_ProductCode__c = '9999';
        detailList[5].JP_PreRelease__c = false;
        detailList[5].JP_WholeSaleRate__c = 1;
        detailList[5].JP_UnitPrice__c = 300;
        detailList[5].JP_SpecialWholeSaleTRate__c = 0.8;
        detailList[5].JP_DiscountLimitPrice__c = 800;
        detailList[5].JP_WholeSalePriceMulQuantity__c = detailList[5].JP_UnitPrice__c * detailList[5].JP_WholeSaleRate__c;
        detailList[5].JP_SpecialUnitPriceMulQuantity__c = detailList[5].JP_SpecialUnitPrice__c * detailList[5].JP_Quantity__c;
        detailList[5].JP_StandardMinusSpecial__c = detailList[5].JP_WholeSalePriceMulQuantity__c - detailList[5].JP_SpecialUnitPriceMulQuantity__c;
        detailList[5].JP_DeterminedAmount__c = detailList[5].JP_SpecialUnitPriceMulQuantity__c;
        detailList[5].JP_PreSave__c = true;
        
        detailList[6].JP_ProductCatalogCode__c = '12345';
        detailList[6].JP_ProductName__c = 'testName';
        detailList[6].JP_Sort__c = 7;
        detailList[6].JP_Quantity__c = 1;
        detailList[6].JP_SpecialUnitPrice__c = 1000;
        detailList[6].JP_SpecialUnitPriceMulQuantity__c = 1000;
        detailList[6].JP_StandardMinusSpecial__c = 1000;
        detailList[6].JP_StandardPrice__c = 100;
        detailList[6].JP_DeterminedAmount__c = 1000;
        detailList[6].JP_PriceYearMonth__c = 'JP ' + Date.today().year() + '/' + Date.today().month();
        detailList[6].JP_AppGroupID__c = 'G2';
        detailList[6].JP_5PercentDiscount__c = 1200;
        detailList[6].JP_OverLimitDiscount__c = false;
        detailList[6].JP_ProductCode__c = 'ATSS-0000';
        detailList[6].JP_PreRelease__c = false;
        detailList[6].JP_WholeSaleRate__c = 1;
        detailList[6].JP_UnitPrice__c = 300;
        detailList[6].JP_SpecialWholeSaleTRate__c = 0.8;
        detailList[6].JP_DiscountLimitPrice__c = 800;
        detailList[6].JP_WholeSalePriceMulQuantity__c = detailList[6].JP_UnitPrice__c * detailList[6].JP_WholeSaleRate__c;
        detailList[6].JP_SpecialUnitPriceMulQuantity__c = detailList[6].JP_SpecialUnitPrice__c * detailList[6].JP_Quantity__c;
        detailList[6].JP_StandardMinusSpecial__c = detailList[6].JP_WholeSalePriceMulQuantity__c - detailList[6].JP_SpecialUnitPriceMulQuantity__c;
        detailList[6].JP_DeterminedAmount__c = detailList[6].JP_SpecialUnitPriceMulQuantity__c;
        detailList[6].JP_PreSave__c = true;
        insert detailList;

        List<JP_DistributorPrice__c> dpList = JP_TestUtil.Create_JP_DistributorPrice(1);
        JP_DistributorPrice__c dp = dpList.get(0);
        dp.JP_ProductCatalogCode__c = 'test';
        dp.JP_Price_List_Type__c = qd.JP_Price_List_Type__c;
        dp.JP_PriceYearMonth__c = 'JP ' + Date.today().year() + '/' + Date.today().month();
        dp.JP_OutputableQuotation__c = true;
        dp.JP_ProductName__c = 'testName';
        dp.JP_ExpirvStandardPrice__c = 100;
        dp.JP_WholeSaleRate__c = 1;
        dp.JP_WholeSalePrice__c = 300;
        dp.JP_SaleStatus__c = '承認';
        dp.JP_ReleaseDate__c = '2015/08';
        dp.JP_SalesEndScheduledPeriod__c = '2015/09';
        dp.JP_AppGroupID__c = 'G2';
        dp.JP_SearchItemKey1__c = qd.JP_Price_List_Type__c + '_' + 'test';
        dp.JP_SearchItemKey2__c = qd.JP_Price_List_Type__c + '_' + 'JP ' + Date.today().year() + '/' + Date.today().month();
        dp.JP_WholeSaleKey__c = qd.JP_Price_List_Type__c + '_' + 'test' + '_' + 'JP ' + Date.today().year() + '/' + Date.today().month();
        insert dp;
        
        system.debug('■■■価格年月 : ' + dp.JP_PriceYearMonth__c);
        system.debug('■■■price_list_type : ' + dp.JP_Price_List_Type__c);
        system.debug('■■■商品コード : ' + dp.JP_ProductCatalogCode__c);

        // テスト開始
        ApexPages.currentPage().getParameters().put('rowNum', '0');
        System.Test.startTest();
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(qhlist[0]);
        JP_QuotationHeaderController jph = new JP_QuotationHeaderController(sc);
        jph.inputPriceYearMonth = dp.JP_PriceYearMonth__c;
        jph.searchProductInfo();
        system.debug('◆◆◆ QHeader.JP_QuotationDistCD__c : ' + jph.QHeader.JP_QuotationDistCD__c);
        JP_QuotationDetail__c dest = jph.QDetailList.get(0).obj;
        system.debug('◆◆◆ dest.JP_ProductName__c : ' + dest.JP_ProductName__c);
        System.assertEquals(dp.JP_ProductName__c, dest.JP_ProductName__c);
        System.assertEquals(dp.JP_ExpirvStandardPrice__c, dest.JP_StandardPrice__c);
        System.assertEquals(dp.JP_WholeSaleRate__c, dest.JP_WholeSaleRate__c);
        System.assertEquals(dp.JP_WholeSalePrice__c, dest.JP_UnitPrice__c);
        //System.assertEquals(dp.JP_SaleStatus__c, dest.JP_SalesStatus__c);
        //System.assertEquals(dp.JP_ReleaseDate__c, dest.JP_ReleaseScheduled__c);
        //System.assertEquals(dp.JP_SalesEndScheduledPeriod__c, dest.JP_SalesEndScheduled__c);
        System.assertEquals(dp.JP_PriceYearMonth__c, dest.JP_PriceYearMonth__c);
        System.assertEquals(dp.JP_AppGroupID__c, dest.JP_AppGroupID__c);
        System.Test.stopTest();
    }

    /**
     * 商品検索(正常系：該当商品なし)
     */
    private static testMethod void testSearchProductInfo_Normal02() {
        // テストデータ作成
        qdList = JP_TestUtil.Create_JP_QuotationDistributor();
        JP_QuotationDistributor__c qd = qdList.get(0);
        List<JP_QuotationHeader__c> qhlist = JP_TestUtil.Create_JP_QuotationHeader(1);
        qhlist[0].JP_QuotationDistCD__c = qd.Id;
        insert qhList;
        
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

        List<JP_QuotationDetail__c> detailList = JP_TestUtil.Create_JP_QuotationDetail(qhlist[0].Id,3);
        detailList[0].JP_ProductCatalogCode__c = 'aaaa';
        detailList[0].JP_ProductName__c = 'aaaaa';
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

        detailList[1].JP_ProductCatalogCode__c = 'test02';
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

        detailList[2].JP_ProductCatalogCode__c = 'test03';
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

        List<JP_DistributorPrice__c> dpList = JP_TestUtil.Create_JP_DistributorPrice(1);
        JP_DistributorPrice__c dp = dpList.get(0);
        dp.JP_ProductCatalogCode__c = 'test';
        dp.JP_Price_List_Type__c = qd.JP_Price_List_Type__c;
        dp.JP_PriceYearMonth__c = String.valueOf(Date.today().year() * 100 + Date.today().month());
        dp.JP_OutputableQuotation__c = true;
        dp.JP_ProductName__c = 'testName';
        dp.JP_ExpirvStandardPrice__c = 100;
        dp.JP_WholeSaleRate__c = 200;
        dp.JP_WholeSalePrice__c = 300;
        dp.JP_SaleStatus__c = '承認';
        dp.JP_ReleaseDate__c = '2015/08';
        dp.JP_SalesEndScheduledPeriod__c = '2015/09';
        dp.JP_AppGroupID__c = 'G2';
        dp.JP_Price_List_Type__c = 'A';
        insert dp;

        // テスト開始
        ApexPages.currentPage().getParameters().put('rowNum', '0');
        System.Test.startTest();
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(qhlist[0]);
        JP_QuotationHeaderController jph = new JP_QuotationHeaderController(sc);
        //jph.inputPriceYearMonth = dp.JP_PriceYearMonth__c;
        jph.searchProductInfo();
        JP_QuotationDetail__c dest = jph.QDetailList.get(0).obj;
        System.assertEquals('aaaaa', dest.JP_ProductName__c);
        System.assertEquals(null, dest.JP_StandardPrice__c);
        System.assertEquals(1, dest.JP_WholeSaleRate__c);
        System.assertEquals(1500, dest.JP_UnitPrice__c);
        System.assertEquals(null, dest.JP_SalesStatus__c);
        System.assertEquals(null, dest.JP_ReleaseScheduled__c);
        System.assertEquals(null, dest.JP_SalesEndScheduled__c);
        System.assertEquals('201508', dest.JP_PriceYearMonth__c);
        System.assertEquals('G1', dest.JP_AppGroupID__c);
        System.Test.stopTest();
    }

    /**
     * z変換
     */
    private static testMethod void testReplaceHalfSmallZ() {
        // テストデータ作成
        qdList = JP_TestUtil.Create_JP_QuotationDistributor();
        JP_QuotationDistributor__c qd = qdList.get(0);
        List<JP_QuotationHeader__c> qhlist = JP_TestUtil.Create_JP_QuotationHeader(1);
        qhlist[0].JP_QuotationDistCD__c = qd.Id;
        insert qhList;

        // テスト開始
        System.Test.startTest();
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(qhlist[0]);
        JP_QuotationHeaderController jph = new JP_QuotationHeaderController(sc);
        System.assertEquals('z', jph.replaceHalfSmallZ('Z'));
        System.assertEquals('z', jph.replaceHalfSmallZ('ｚ'));
        System.assertEquals('z', jph.replaceHalfSmallZ('Ｚ'));
        System.Test.stopTest();
    }

    /**
     * 明細金額計算
     */
    private static testMethod void testCalcAmounts() {
        // テストデータ作成
        qdList = JP_TestUtil.Create_JP_QuotationDistributor();
        JP_QuotationDistributor__c qd = qdList.get(0);
        List<JP_QuotationHeader__c> qhlist = JP_TestUtil.Create_JP_QuotationHeader(1);
        qhlist[0].JP_QuotationDistCD__c = qd.Id;
        qhlist[0].JP_InputUnitPrice__c = true;
        insert qhList;

        JP_QuotationDetail__c detail = new JP_QuotationDetail__c();
        detail.JP_UnitPrice__c = 54321;
        detail.JP_StandardPrice__c = 54321;
        detail.JP_SpecialUnitPrice__c = 18460;
        detail.JP_SpecialWholeSaleTRate__c = 0.34;
        detail.JP_Quantity__c = 5;
        detail.JP_QuotationDetailType__c = '明細区分リセット用(システム利用)';

        // テスト開始
        System.Test.startTest();
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(qhlist[0]);
        JP_QuotationHeaderController jph = new JP_QuotationHeaderController(sc);

        // 特別仕切単価 > 0の場合
        system.debug('■■■■■　特別仕切単価 > 0の場合■■■■■');
        jph.calcAmounts(detail);
        System.assertEquals(18460, detail.JP_SpecialUnitPrice__c);
        System.assertEquals(271605, detail.JP_WholeSalePriceMulQuantity__c);
        //System.assertEquals(92300, detail.JP_SpecialUnitPriceMulQuantity__c);
        System.assertEquals(179305, detail.JP_StandardMinusSpecial__c);
        System.assertEquals(92300, detail.JP_DeterminedAmount__c);

        // 特別仕切単価 <= 0の場合
        system.debug('■■■■■　特別仕切単価 <= 0の場合■■■■■');
        detail.JP_SpecialWholeSaleTRate__c = 0;
        jph.calcAmounts(detail);
        //System.assertEquals(0, detail.JP_SpecialUnitPrice__c);
        //System.assertEquals(271605, detail.JP_WholeSalePriceMulQuantity__c);
        //System.assertEquals(0, detail.JP_SpecialUnitPriceMulQuantity__c);
        //System.assertEquals(0, detail.JP_StandardMinusSpecial__c);
        //System.assertEquals(271605, detail.JP_DeterminedAmount__c);
        
        // デフォルトの見積明細が集計外になる場合
        detail.JP_UnitPrice__c = 0;
        detail.JP_SpecialUnitPrice__c = 0;
        detail.JP_ProductCatalogCode__c = '-';
        detail.JP_QuotationDetailType__c = '明細区分リセット用(システム利用)';
        jph.calcAmounts(detail);
        System.assertEquals(JP_Const.QUOTATIONDETAILTYPE_NOTTOTALED, detail.JP_QuotationDetailType__c);
        
        // デフォルトの見積明細が空欄になる場合
        detail.JP_UnitPrice__c = 10000;
        detail.JP_SpecialUnitPrice__c = 10000;
        detail.JP_ProductCatalogCode__c = 'MEMO-00000';
        detail.JP_QuotationDetailType__c = '明細区分リセット用(システム利用)';
        jph.calcAmounts(detail);
        System.assertEquals('', detail.JP_QuotationDetailType__c);
        
        // デフォルトの見積明細が空欄になる場合
        detail.JP_ProductCatalogCode__c = '****';
        detail.JP_QuotationDetailType__c = '明細区分リセット用(システム利用)';
        jph.calcAmounts(detail);
        System.assertEquals('', detail.JP_QuotationDetailType__c);
        
        // デフォルトの見積明細が保守になる場合
        detail.JP_ProductCatalogCode__c = '12345';
        detail.JP_ProductCode__c = 'ATSS-00000';
        detail.JP_QuotationDetailType__c = '明細区分リセット用(システム利用)';
        jph.calcAmounts(detail);
        System.assertEquals(JP_Const.QUOTATIONDETAILTYPE_MAINTENANCE, detail.JP_QuotationDetailType__c);

        // ALLIEDTELESIS-523 add start
        // デフォルトの見積明細がi-Testになる場合
        detail.JP_ProductCatalogCode__c = '12345';
        detail.JP_ProductCode__c = 'ITS-00000';
        detail.JP_QuotationDetailType__c = '明細区分リセット用(システム利用)';
        jph.calcAmounts(detail);
        System.assertEquals(JP_Const.QUOTATIONDETAILTYPE_I_TEST, detail.JP_QuotationDetailType__c);

        // デフォルトの見積明細がNet.Campusになる場合
        detail.JP_ProductCatalogCode__c = '12345';
        detail.JP_ProductCode__c = 'CMP-00000';
        detail.JP_QuotationDetailType__c = '明細区分リセット用(システム利用)';
        jph.calcAmounts(detail);
        System.assertEquals(JP_Const.QUOTATIONDETAILTYPE_NET_CAMPUS, detail.JP_QuotationDetailType__c);

        // デフォルトの見積明細が製品サブスクになる場合
        detail.JP_ProductCatalogCode__c = 'R1123';
        detail.JP_ProductCode__c = 'TEST-00000';
        detail.JP_QuotationDetailType__c = '明細区分リセット用(システム利用)';
        jph.calcAmounts(detail);
        System.assertEquals(JP_Const.QUOTATIONDETAILTYPE_PRODUCT_SUBSCRIPTION, detail.JP_QuotationDetailType__c);

        // デフォルトの見積明細が製品サブスクになる場合
        detail.JP_ProductCatalogCode__c = 'R6123';
        detail.JP_ProductCode__c = 'TEST-00000';
        detail.JP_QuotationDetailType__c = '明細区分リセット用(システム利用)';
        jph.calcAmounts(detail);
        System.assertEquals(JP_Const.QUOTATIONDETAILTYPE_PRODUCT_SUBSCRIPTION, detail.JP_QuotationDetailType__c);

        // デフォルトの見積明細が製品サブスクになる場合
        detail.JP_ProductCatalogCode__c = 'R8123';
        detail.JP_ProductCode__c = 'TEST-00000';
        detail.JP_QuotationDetailType__c = '明細区分リセット用(システム利用)';
        jph.calcAmounts(detail);
        System.assertEquals(JP_Const.QUOTATIONDETAILTYPE_PRODUCT_SUBSCRIPTION, detail.JP_QuotationDetailType__c);

        // デフォルトの見積明細が製品サブスクになる場合
        detail.JP_ProductCatalogCode__c = 'R9123';
        detail.JP_ProductCode__c = 'TEST-00000';
        detail.JP_QuotationDetailType__c = '明細区分リセット用(システム利用)';
        jph.calcAmounts(detail);
        System.assertEquals(JP_Const.QUOTATIONDETAILTYPE_PRODUCT_SUBSCRIPTION, detail.JP_QuotationDetailType__c);
        // ALLIEDTELESIS-523 add end
        
        // 明細区分が「なし」で確定金額が0円になった時→明細区分が変わらない
        detail.JP_UnitPrice__c = 0;
        detail.JP_SpecialUnitPrice__c = 0;
        detail.JP_QuotationDetailType__c = JP_Const.QUOTATIONDETAILTYPE_MAINTENANCE;
        jph.calcAmounts (detail);
        System.assertEquals(JP_Const.QUOTATIONDETAILTYPE_MAINTENANCE, detail.JP_QuotationDetailType__c);
        
        // 明細区分が「集計外」で確定金額が1円以上になった時→条件に合う明細区分にする
        // 見積明細が空欄になる場合
        detail.JP_UnitPrice__c = 10000;
        detail.JP_SpecialUnitPrice__c = 10000;
        detail.JP_ProductCatalogCode__c = 'MEMO-00000';
        detail.JP_QuotationDetailType__c = JP_Const.QUOTATIONDETAILTYPE_NOTTOTALED;
        jph.calcAmounts(detail);
        System.assertEquals('', detail.JP_QuotationDetailType__c);
        
        // 見積明細が空欄になる場合
        detail.JP_DeterminedAmount__c = 0;
        detail.JP_ProductCatalogCode__c = '****';
        detail.JP_QuotationDetailType__c = JP_Const.QUOTATIONDETAILTYPE_NOTTOTALED;
        jph.calcAmounts(detail);
        System.assertEquals('', detail.JP_QuotationDetailType__c);
        
        // 見積明細が保守になる場合
        detail.JP_DeterminedAmount__c = 0;
        detail.JP_ProductCatalogCode__c = '12345';
        detail.JP_ProductCode__c = 'ATSS-00000';
        detail.JP_QuotationDetailType__c = JP_Const.QUOTATIONDETAILTYPE_NOTTOTALED;
        jph.calcAmounts(detail);
        System.assertEquals(JP_Const.QUOTATIONDETAILTYPE_MAINTENANCE, detail.JP_QuotationDetailType__c);

        // ALLIEDTELESIS-523 add start
        // デフォルトの見積明細がi-Testになる場合
        detail.JP_DeterminedAmount__c = 0;
        detail.JP_ProductCatalogCode__c = '12345';
        detail.JP_ProductCode__c = 'ITS-00000';
        detail.JP_QuotationDetailType__c = JP_Const.QUOTATIONDETAILTYPE_NOTTOTALED;
        jph.calcAmounts(detail);
        System.assertEquals(JP_Const.QUOTATIONDETAILTYPE_I_TEST, detail.JP_QuotationDetailType__c);

        // デフォルトの見積明細がNet.Campusになる場合
        detail.JP_DeterminedAmount__c = 0;
        detail.JP_ProductCatalogCode__c = '12345';
        detail.JP_ProductCode__c = 'CMP-00000';
        detail.JP_QuotationDetailType__c = JP_Const.QUOTATIONDETAILTYPE_NOTTOTALED;
        jph.calcAmounts(detail);
        System.assertEquals(JP_Const.QUOTATIONDETAILTYPE_NET_CAMPUS, detail.JP_QuotationDetailType__c);

        // デフォルトの見積明細が製品サブスクになる場合
        detail.JP_DeterminedAmount__c = 0;
        detail.JP_ProductCatalogCode__c = 'R1123';
        detail.JP_ProductCode__c = 'TEST-00000';
        detail.JP_QuotationDetailType__c = JP_Const.QUOTATIONDETAILTYPE_NOTTOTALED;
        jph.calcAmounts(detail);
        System.assertEquals(JP_Const.QUOTATIONDETAILTYPE_PRODUCT_SUBSCRIPTION, detail.JP_QuotationDetailType__c);

        // デフォルトの見積明細が製品サブスクになる場合
        detail.JP_DeterminedAmount__c = 0;
        detail.JP_ProductCatalogCode__c = 'R6123';
        detail.JP_ProductCode__c = 'TEST-00000';
        detail.JP_QuotationDetailType__c = JP_Const.QUOTATIONDETAILTYPE_NOTTOTALED;
        jph.calcAmounts(detail);
        System.assertEquals(JP_Const.QUOTATIONDETAILTYPE_PRODUCT_SUBSCRIPTION, detail.JP_QuotationDetailType__c);

        // デフォルトの見積明細が製品サブスクになる場合
        detail.JP_DeterminedAmount__c = 0;
        detail.JP_ProductCatalogCode__c = 'R8123';
        detail.JP_ProductCode__c = 'TEST-00000';
        detail.JP_QuotationDetailType__c = JP_Const.QUOTATIONDETAILTYPE_NOTTOTALED;
        jph.calcAmounts(detail);
        System.assertEquals(JP_Const.QUOTATIONDETAILTYPE_PRODUCT_SUBSCRIPTION, detail.JP_QuotationDetailType__c);

        // デフォルトの見積明細が製品サブスクになる場合
        detail.JP_DeterminedAmount__c = 0;
        detail.JP_ProductCatalogCode__c = 'R9123';
        detail.JP_ProductCode__c = 'TEST-00000';
        detail.JP_QuotationDetailType__c = JP_Const.QUOTATIONDETAILTYPE_NOTTOTALED;
        jph.calcAmounts(detail);
        System.assertEquals(JP_Const.QUOTATIONDETAILTYPE_PRODUCT_SUBSCRIPTION, detail.JP_QuotationDetailType__c);
        // ALLIEDTELESIS-523 add end

        // 見積明細が機器になる場合
        detail.JP_DeterminedAmount__c = 0;
        detail.JP_UnitPrice__c = 10000;
        detail.JP_SpecialUnitPrice__c = 10000;
        detail.JP_Quantity__c = 1;
        detail.JP_ProductCatalogCode__c = '12345';
        detail.JP_ProductCode__c = '';
        detail.JP_QuotationDetailType__c = JP_Const.QUOTATIONDETAILTYPE_NOTTOTALED;
        jph.calcAmounts(detail);
        System.assertEquals(JP_Const.QUOTATIONDETAILTYPE_DEVICE, detail.JP_QuotationDetailType__c);
        
        System.Test.stopTest();
    }
    
    private static testMethod void testSetDefaultQuotationDetail () {
        // テストデータ作成
        qdList = JP_TestUtil.Create_JP_QuotationDistributor();
        JP_QuotationDistributor__c qd = qdList.get(0);
        List<JP_QuotationHeader__c> qhlist = JP_TestUtil.Create_JP_QuotationHeader(1);
        qhlist[0].JP_QuotationDistCD__c = qd.Id;
        qhlist[0].JP_InputUnitPrice__c = true;
        insert qhList;

        JP_QuotationDetail__c detail = new JP_QuotationDetail__c();
        detail.JP_UnitPrice__c = 54321;
        detail.JP_StandardPrice__c = 54321;
        detail.JP_SpecialUnitPrice__c = 18460;
        detail.JP_SpecialWholeSaleTRate__c = 0.34;
        detail.JP_Quantity__c = 5;
        detail.JP_QuotationDetailType__c = '明細区分リセット用(システム利用)';

        // テスト開始
        System.Test.startTest();
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(qhlist[0]);
        JP_QuotationHeaderController jph = new JP_QuotationHeaderController(sc);

        jph.qDetailOriginalList.add (new JP_QuotationDetailSelect (detail));
        jph.setDefaultQuotationDetail ();

        // ALLIEDTELESIS-523 add start
        // デフォルトの見積明細がi-Testになる場合
        detail.JP_DeterminedAmount__c = 0;
        detail.JP_ProductCatalogCode__c = '12345';
        detail.JP_ProductCode__c = 'ITS-00000';
        jph.qDetailOriginalList.set (0, new JP_QuotationDetailSelect (detail));
        jph.setDefaultQuotationDetail ();
        System.assertEquals(JP_Const.QUOTATIONDETAILTYPE_I_TEST, detail.JP_QuotationDetailType__c);

        // デフォルトの見積明細がNet.Campusになる場合
        detail.JP_DeterminedAmount__c = 0;
        detail.JP_ProductCatalogCode__c = '12345';
        detail.JP_ProductCode__c = 'CMP-00000';
        jph.qDetailOriginalList.set (0, new JP_QuotationDetailSelect (detail));
        jph.setDefaultQuotationDetail ();
        System.assertEquals(JP_Const.QUOTATIONDETAILTYPE_NET_CAMPUS, detail.JP_QuotationDetailType__c);

        // デフォルトの見積明細が製品サブスクになる場合
        detail.JP_DeterminedAmount__c = 0;
        detail.JP_ProductCatalogCode__c = 'R1123';
        detail.JP_ProductCode__c = 'TEST-00000';
        jph.qDetailOriginalList.set (0, new JP_QuotationDetailSelect (detail));
        jph.setDefaultQuotationDetail ();
        System.assertEquals(JP_Const.QUOTATIONDETAILTYPE_PRODUCT_SUBSCRIPTION, detail.JP_QuotationDetailType__c);

        // デフォルトの見積明細が製品サブスクになる場合
        detail.JP_DeterminedAmount__c = 0;
        detail.JP_ProductCatalogCode__c = 'R6123';
        detail.JP_ProductCode__c = 'TEST-00000';
        jph.qDetailOriginalList.set (0, new JP_QuotationDetailSelect (detail));
        jph.setDefaultQuotationDetail ();
        System.assertEquals(JP_Const.QUOTATIONDETAILTYPE_PRODUCT_SUBSCRIPTION, detail.JP_QuotationDetailType__c);

        // デフォルトの見積明細が製品サブスクになる場合
        detail.JP_DeterminedAmount__c = 0;
        detail.JP_ProductCatalogCode__c = 'R8123';
        detail.JP_ProductCode__c = 'TEST-00000';
        jph.qDetailOriginalList.set (0, new JP_QuotationDetailSelect (detail));
        jph.setDefaultQuotationDetail ();
        System.assertEquals(JP_Const.QUOTATIONDETAILTYPE_PRODUCT_SUBSCRIPTION, detail.JP_QuotationDetailType__c);

        // デフォルトの見積明細が製品サブスクになる場合
        detail.JP_DeterminedAmount__c = 0;
        detail.JP_ProductCatalogCode__c = 'R9123';
        detail.JP_ProductCode__c = 'TEST-00000';
        jph.qDetailOriginalList.set (0, new JP_QuotationDetailSelect (detail));
        jph.setDefaultQuotationDetail ();
        System.assertEquals(JP_Const.QUOTATIONDETAILTYPE_PRODUCT_SUBSCRIPTION, detail.JP_QuotationDetailType__c);
        // ALLIEDTELESIS-523 add end

        jph.QDetailList.add (new JP_QuotationDetailSelect (detail));
        jph.QDetailList.get(0).selected = true;
        //jph.allSetCompletionScheduled ();
        //jph.selectSetCompletionScheduled ();

        System.Test.stopTest();
    }
    
    private static testmethod void testchangeDispPageNumList(){
        // テストデータ作成
        qdList = JP_TestUtil.Create_JP_QuotationDistributor();
        JP_QuotationDistributor__c qd = qdList.get(0);
        List<JP_QuotationHeader__c> qhlist = JP_TestUtil.Create_JP_QuotationHeader(1);
        qhlist[0].JP_QuotationDistCD__c = qd.Id;
        insert qhList;

        JP_QuotationDetail__c detail = new JP_QuotationDetail__c();
        detail.JP_UnitPrice__c = 54321;
        detail.JP_StandardPrice__c = 54321;
        detail.JP_SpecialWholeSaleTRate__c = 0.34;
        detail.JP_Quantity__c = 5;

        // テスト開始
        System.Test.startTest();
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(qhlist[0]);
        JP_QuotationHeaderController jph = new JP_QuotationHeaderController(sc);
        jph.pageSize = 50;
        jph.changeDispPageNumList();
        System.Test.stopTest();
    }

    private static testMethod void testClearDetailColumns(){
        // テストデータ作成
        qdList = JP_TestUtil.Create_JP_QuotationDistributor();
        JP_QuotationDistributor__c qd = qdList.get(0);
        List<JP_QuotationHeader__c> qhlist = JP_TestUtil.Create_JP_QuotationHeader(1);
        qhlist[0].JP_QuotationDistCD__c = qd.Id;
        insert qhList;
        
        JP_ApprovalProcessMaster__c apm = JP_TestUtil.Create_JP_ApprovalProcessMaster(1);
        JP_DecideApprovalProcess__c dap = new JP_DecideApprovalProcess__c();
        dap.JP_ApprovalProcessMaster__c = apm.Id;
        dap.JP_ChkTotalAmountCD__c = 'A1';
        dap.JP_ChkWholeSaleCD__c = 'B1';
        dap.JP_ChkLimitDiscountCD__c = 'C1';
        dap.JP_ChkRegisteredProductCD__c = 'D1';
        dap.JP_ChkQuotationExpiryDateCD__c = 'E1';
        dap.JP_ChkPreReleaseCD__c = 'F1';
        //dap.JP_ChkkProductResponsibleCD__c = 'G1';
        insert dap;

        List<JP_QuotationDetail__c> detailList = JP_TestUtil.Create_JP_QuotationDetail(qhlist[0].Id,3);
        detailList[0].JP_ProductCatalogCode__c = '-';
        detailList[0].JP_ProductName__c = 'testName';
        detailList[0].JP_Sort__c = 1;
        detailList[0].JP_Quantity__c = 1;
        detailList[0].JP_SpecialUnitPrice__c = 1000;
        detailList[0].JP_WholeSalePriceMulQuantity__c = 1000;
        detailList[0].JP_SpecialUnitPriceMulQuantity__c = 1000;
        detailList[0].JP_StandardMinusSpecial__c = 1000;
        detailList[0].JP_StandardPrice__c = 100;
        detailList[0].JP_DeterminedAmount__c = 1000;
        detailList[0].JP_PriceYearMonth__c = 'JP ' + Date.today().year() + '/' + Date.today().month();
        detailList[0].JP_AppGroupID__c = 'G2';
        detailList[0].JP_5PercentDiscount__c = 1200;
        detailList[0].JP_OverLimitDiscount__c = false;
        detailList[0].JP_ProductCode__c = '9999';
        detailList[0].JP_PreRelease__c = false;
        detailList[0].JP_WholeSaleRate__c = 1;
        detailList[0].JP_UnitPrice__c = 300;
        detailList[0].JP_SpecialWholeSaleTRate__c = 0.8;
        detailList[0].JP_DiscountLimitPrice__c = 800;
        detailList[0].JP_WholeSalePriceMulQuantity__c = detailList[0].JP_UnitPrice__c * detailList[0].JP_WholeSaleRate__c;
        detailList[0].JP_SpecialUnitPriceMulQuantity__c = detailList[0].JP_SpecialUnitPrice__c * detailList[0].JP_Quantity__c;
        detailList[0].JP_StandardMinusSpecial__c = detailList[0].JP_WholeSalePriceMulQuantity__c - detailList[0].JP_SpecialUnitPriceMulQuantity__c;
        detailList[0].JP_DeterminedAmount__c = detailList[0].JP_SpecialUnitPriceMulQuantity__c;
        detailList[0].JP_PreSave__c = true;
        

        detailList[1].JP_ProductCatalogCode__c = '-';
        detailList[1].JP_ProductName__c = 'testName';
        detailList[1].JP_Sort__c = 2;
        detailList[1].JP_Quantity__c = 1;
        detailList[1].JP_SpecialUnitPrice__c = 1000;
        detailList[1].JP_WholeSalePriceMulQuantity__c = 1000;
        detailList[1].JP_SpecialUnitPriceMulQuantity__c = 1000;
        detailList[1].JP_StandardMinusSpecial__c = 1000;
        detailList[1].JP_StandardPrice__c = 100;
        detailList[1].JP_DeterminedAmount__c = 1000;
        detailList[1].JP_PriceYearMonth__c = 'JP ' + Date.today().year() + '/' + Date.today().month();
        detailList[1].JP_AppGroupID__c = 'G2';
        detailList[1].JP_5PercentDiscount__c = 1200;
        detailList[1].JP_OverLimitDiscount__c = false;
        detailList[1].JP_ProductCode__c = '9999';
        detailList[1].JP_PreRelease__c = false;
        detailList[1].JP_WholeSaleRate__c = 1;
        detailList[1].JP_UnitPrice__c = 300;
        detailList[1].JP_SpecialWholeSaleTRate__c = 0.8;
        detailList[1].JP_DiscountLimitPrice__c = 800;
        detailList[1].JP_WholeSalePriceMulQuantity__c = detailList[0].JP_UnitPrice__c * detailList[0].JP_WholeSaleRate__c;
        detailList[1].JP_SpecialUnitPriceMulQuantity__c = detailList[0].JP_SpecialUnitPrice__c * detailList[0].JP_Quantity__c;
        detailList[1].JP_StandardMinusSpecial__c = detailList[0].JP_WholeSalePriceMulQuantity__c - detailList[0].JP_SpecialUnitPriceMulQuantity__c;
        detailList[1].JP_DeterminedAmount__c = detailList[0].JP_SpecialUnitPriceMulQuantity__c;
        detailList[1].JP_PreSave__c = true;

        detailList[2].JP_ProductCatalogCode__c = '-';
        detailList[2].JP_ProductName__c = 'testName';
        detailList[2].JP_Sort__c = 3;
        detailList[2].JP_Quantity__c = 1;
        detailList[2].JP_SpecialUnitPrice__c = 1000;
        detailList[2].JP_WholeSalePriceMulQuantity__c = 1000;
        detailList[2].JP_SpecialUnitPriceMulQuantity__c = 1000;
        detailList[2].JP_StandardMinusSpecial__c = 1000;
        detailList[2].JP_StandardPrice__c = 100;
        detailList[2].JP_DeterminedAmount__c = 1000;
        detailList[2].JP_PriceYearMonth__c = 'JP ' + Date.today().year() + '/' + Date.today().month();
        detailList[2].JP_AppGroupID__c = 'G2';
        detailList[2].JP_5PercentDiscount__c = 1200;
        detailList[2].JP_OverLimitDiscount__c = false;
        detailList[2].JP_ProductCode__c = '9999';
        detailList[2].JP_PreRelease__c = false;
        detailList[2].JP_WholeSaleRate__c = 1;
        detailList[2].JP_UnitPrice__c = 300;
        detailList[2].JP_SpecialWholeSaleTRate__c = 0.8;
        detailList[2].JP_DiscountLimitPrice__c = 800;
        detailList[2].JP_WholeSalePriceMulQuantity__c = detailList[0].JP_UnitPrice__c * detailList[0].JP_WholeSaleRate__c;
        detailList[2].JP_SpecialUnitPriceMulQuantity__c = detailList[0].JP_SpecialUnitPrice__c * detailList[0].JP_Quantity__c;
        detailList[2].JP_StandardMinusSpecial__c = detailList[0].JP_WholeSalePriceMulQuantity__c - detailList[0].JP_SpecialUnitPriceMulQuantity__c;
        detailList[2].JP_DeterminedAmount__c = detailList[0].JP_SpecialUnitPriceMulQuantity__c;
        detailList[2].JP_PreSave__c = true;
        insert detailList;

        List<JP_DistributorPrice__c> dpList = JP_TestUtil.Create_JP_DistributorPrice(1);
        JP_DistributorPrice__c dp = dpList.get(0);
        dp.JP_ProductCatalogCode__c = 'TEST';
        dp.JP_Price_List_Type__c = qd.JP_Price_List_Type__c;
        dp.JP_PriceYearMonth__c = 'JP ' + Date.today().year() + '/' + Date.today().month();
        dp.JP_OutputableQuotation__c = true;
        dp.JP_ProductName__c = 'testName';
        dp.JP_ExpirvStandardPrice__c = 100;
        dp.JP_WholeSaleRate__c = 1;
        dp.JP_WholeSalePrice__c = 300;
        dp.JP_SaleStatus__c = '承認';
        dp.JP_ReleaseDate__c = '2015/08';
        dp.JP_SalesEndScheduledPeriod__c = '2015/09';
        dp.JP_AppGroupID__c = 'G2';
        dp.JP_SearchItemKey1__c = qd.JP_Price_List_Type__c + '_' + 'test';
        dp.JP_SearchItemKey2__c = qd.JP_Price_List_Type__c + '_' + 'JP ' + Date.today().year() + '/' + Date.today().month();
        dp.JP_WholeSaleKey__c = qd.JP_Price_List_Type__c + '_' + 'test' + '_' + 'JP ' + Date.today().year() + '/' + Date.today().month();
        insert dp;
        
        system.debug('■■■価格年月 : ' + dp.JP_PriceYearMonth__c);
        system.debug('■■■price_list_type : ' + dp.JP_Price_List_Type__c);
        system.debug('■■■商品コード : ' + dp.JP_ProductCatalogCode__c);

        // テスト開始
        ApexPages.currentPage().getParameters().put('rowNum', '0');
        System.Test.startTest();
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(qhlist[0]);
        JP_QuotationHeaderController jph = new JP_QuotationHeaderController(sc);
        jph.searchProductInfo();
        JP_QuotationDetail__c dest = jph.QDetailList.get(0).obj;

        System.Test.stopTest();
    }

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