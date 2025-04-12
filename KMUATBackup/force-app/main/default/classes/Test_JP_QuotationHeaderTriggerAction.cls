@isTest
private class Test_JP_QuotationHeaderTriggerAction{

    /*-------------------------------------採番処理 TEST START-----------------------------------------*/

    static testMethod void testBeforeInsertNew(){
        DateTime dtNow = System.Now();

        String jstYYMM = dtNow.format('yyMM','JST');

        Test.startTest();
        List<JP_QuotationDistributor__c> distributorList = JP_TestUtil.Create_JP_QuotationDistributor();
        JP_QuotationHeader__c rec = new JP_QuotationHeader__c();
        rec.JP_QuotationStatus__c = JP_Const.QUOTATION_STATUS_UNAPPROVE;
        rec.JP_PreSave__c = false;
        rec.JP_TriggerSkipFLG__c = true;
        rec.JP_QuotationEffectiveTerm__c = '30';
        rec.JP_TotalAmount__c = 30000;
        rec.JP_QuotationDistCD__c = distributorList[0].Id;
        insert rec;
        rec = new JP_QuotationHeader__c();
        rec.JP_QuotationStatus__c = JP_Const.QUOTATION_STATUS_UNAPPROVE;
        rec.JP_PreSave__c = true;
        rec.JP_TriggerSkipFLG__c = true;
        rec.JP_QuotationEffectiveTerm__c = '30';
        rec.JP_TotalAmount__c = 30000;
        rec.JP_QuotationDistCD__c = distributorList[0].Id;
        insert rec;

        Test.stopTest();

        rec = JP_QuotationHeaderDAO.getRecByQuotationNoMax(jstYYMM);

        System.assertEquals(jstYYMM + '0002A', rec.JP_QuotationNo__c);
    }
    static testMethod void testBeforeInsertCopy(){
        DateTime dtNow = System.Now();

        String jstYYMM = dtNow.format('yyMM','JST');

        Test.startTest();
        List<JP_QuotationDistributor__c> distributorList = JP_TestUtil.Create_JP_QuotationDistributor();
        JP_QuotationHeader__c rec;
        rec = new JP_QuotationHeader__c();
        rec.JP_QuotationStatus__c = JP_Const.QUOTATION_STATUS_UNAPPROVE;
        rec.JP_PreSave__c = true;
        rec.JP_TriggerSkipFLG__c = true;
        rec.JP_QuotationEffectiveTerm__c = '30';
        rec.JP_TotalAmount__c = 30000;
        rec.JP_QuotationDistCD__c = distributorList[0].Id;
        insert rec;
        rec = new JP_QuotationHeader__c(JP_QuotationNo__c = jstYYMM + '0001A',JP_QuotationDistCD__c = distributorList[0].Id,JP_TotalAmount__c = 30000,JP_TriggerSkipFLG__c = true);
        insert rec;

        Test.stopTest();

        rec = JP_QuotationHeaderDAO.getRecByQuotationNoMax(jstYYMM);

        System.assertEquals(jstYYMM + '0001B', rec.JP_QuotationNo__c);
    }

    static testMethod void testBeforeInsertCopyErrNotExist(){
        DateTime dtNow = System.Now();

        String jstYYMM = dtNow.format('yyMM','JST');

        DmlException dmle = null;

        Test.startTest();
        List<JP_QuotationDistributor__c> distributorList = JP_TestUtil.Create_JP_QuotationDistributor();
        JP_QuotationHeader__c rec;
        rec = new JP_QuotationHeader__c();
        rec.JP_QuotationStatus__c = JP_Const.QUOTATION_STATUS_UNAPPROVE;
        rec.JP_PreSave__c = true;
        rec.JP_TriggerSkipFLG__c = true;
        rec.JP_QuotationEffectiveTerm__c = '30';
        rec.JP_TotalAmount__c = 30000;
        rec.JP_QuotationDistCD__c = distributorList[0].Id;
        insert rec;
        rec = new JP_QuotationHeader__c(JP_QuotationNo__c = jstYYMM + '0002A',JP_QuotationDistCD__c = distributorList[0].Id,JP_TotalAmount__c = 30000,JP_PreSave__c = true,JP_TriggerSkipFLG__c = true);
        try{
            insert rec;
        } catch(DmlException e){
            dmle = e;
        }

        Test.stopTest();

        System.assertNotEquals(-1, dmle.getMessage().indexOf(System.Label.JP_ErrorMessageQuotationHeaderCopyNotExist));
    }

    static testMethod void testBeforeInsertCopyErrOverZ(){
        DateTime dtNow = System.Now();

        String jstYYMM = dtNow.format('yyMM','JST');

        DmlException dmle = null;

        Test.startTest();

        List<JP_QuotationDistributor__c> distributorList = JP_TestUtil.Create_JP_QuotationDistributor();
        JP_QuotationHeader__c rec;
        rec = new JP_QuotationHeader__c();
        rec.JP_QuotationStatus__c = JP_Const.QUOTATION_STATUS_UNAPPROVE;
        rec.JP_PreSave__c = true;
        rec.JP_TriggerSkipFLG__c = true;
        rec.JP_QuotationEffectiveTerm__c = '30';
        rec.JP_TotalAmount__c = 30000;
        rec.JP_QuotationDistCD__c = distributorList[0].Id;        
        insert rec;
        try{
            for(integer i=0; i < 26; i++){
                rec = new JP_QuotationHeader__c(JP_QuotationNo__c = jstYYMM + '0001A',JP_QuotationDistCD__c = distributorList[0].Id,JP_TotalAmount__c = 30000,JP_PreSave__c = true,JP_TriggerSkipFLG__c = true); insert rec;
            }
        } catch(DmlException e){
            dmle = e;
        }

        Test.stopTest();

        System.assertNotEquals(-1, dmle.getMessage().indexOf(System.Label.JP_ErrorMessageQuotationHeaderOverZ));
    }

    static testMethod void testBeforeInsertCopyErrOver9999(){
        DateTime dtNow = System.Now();

        String jstYYMM = dtNow.format('yyMM','JST');

        DmlException dmle = null;

        JP_QuotationHeader__c rec;
        List<JP_QuotationHeader__c> qhList = new List<JP_QuotationHeader__c>();
        rec = new JP_QuotationHeader__c(JP_TotalAmount__c = 30000,JP_PreSave__c = true,JP_TriggerSkipFLG__c = true);
        qhList.add(rec);
        insert qhList;
        
        //最大値に更新
        JP_QuotationHeader__c updateRec = [SELECT ID, JP_QuotationNo__c FROM JP_QuotationHeader__c WHERE ID IN :qhList];      
        updateRec.JP_QuotationNo__c = jstYYMM + '9999A';
        
        update updateRec;

        Test.startTest();

        try{
            rec = new JP_QuotationHeader__c(JP_TotalAmount__c = 30000,JP_PreSave__c = true,JP_TriggerSkipFLG__c = true);
            insert rec;
        } catch(DmlException e){
            dmle = e;
        }

        Test.stopTest();
        
        system.debug('*****' + dmle.getMessage().indexOf(System.Label.JP_ErrorMessageQuotationHeaderOver9999));

        System.assertNotEquals(-1, dmle.getMessage().indexOf(System.Label.JP_ErrorMessageQuotationHeaderOver9999));
    }

    /*-------------------------------------採番処理 TEST END-----------------------------------------*/

    // 承認プロセス番号判定処理テスト
    static testMethod void testGetApprovalProcessNo1(){
        List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
        List<JP_QuotationHeader__c> qhList = new List<JP_QuotationHeader__c>();
        
        JP_ApprovalProcessMaster__c apm = JP_TestUtil.Create_JP_ApprovalProcessMaster(1);
        List<JP_QuotationDistributor__c> distributorList = JP_TestUtil.Create_JP_QuotationDistributor();

        JP_DecideApprovalProcess__c dap = new JP_DecideApprovalProcess__c();
        dap.JP_ApprovalProcessMaster__c = apm.Id;
        dap.JP_ChkTotalAmountCD__c = 'A1';
        dap.JP_ChkWholeSaleCD__c = 'B1';
        dap.JP_ChkLimitDiscountCD__c = 'C1';
        dap.JP_ChkRegisteredProductCD__c = 'D1';
        dap.JP_ChkQuotationExpiryDateCD__c = 'E1';
        dap.JP_ChkPreReleaseCD__c = 'F1';
        insert dap;

        JP_QuotationHeader__c qh = new JP_QuotationHeader__c();
        qh.JP_QuotationStatus__c = JP_Const.QUOTATION_STATUS_UNAPPROVE;
        qh.JP_PreSave__c = true;
        qh.JP_TriggerSkipFLG__c = false;
        qh.JP_QuotationEffectiveTerm__c = '90';
        qh.JP_TotalAmount__c = 2999999;
        qh.JP_QuotationDistCD__c = distributorList[0].Id;
        qhList.add(qh);
        insert qhList;

        JP_QuotationDetail__c qd1 = new JP_QuotationDetail__c();
        qd1.JP_QuotationHeader__c = qhList[0].Id;
        qd1.JP_AppGroupID__c = 'G1';
        qd1.JP_SpecialUnitPrice__c = NULL;
        qd1.JP_5PercentDiscount__c = NULL;
        qd1.JP_OverLimitDiscount__c = false;
        qd1.JP_ProductCode__c = '9998';
        qd1.JP_ProductCatalogCode__c = '1111';
        qd1.JP_PreRelease__c = false;
        qd1.JP_ProductName__c = 'テスト商品1';
        qd1.JP_Sort__c = 1;
        qd1.JP_Quantity__c = 1;
        qd1.JP_WholeSaleRate__c = 1;
        qd1.JP_UnitPrice__c = 10000;
        qd1.JP_SpecialWholeSaleTRate__c = NULL;
        qd1.JP_DiscountLimitPrice__c = 9000;
        qd1.JP_WholeSalePriceMulQuantity__c = qd1.JP_UnitPrice__c * qd1.JP_WholeSaleRate__c;
        //qd1.JP_SpecialUnitPriceMulQuantity__c = qd1.JP_SpecialUnitPrice__c * qd1.JP_Quantity__c;
        //qd1.JP_StandardMinusSpecial__c = qd1.JP_WholeSalePriceMulQuantity__c - qd1.JP_SpecialUnitPriceMulQuantity__c;
        qd1.JP_DeterminedAmount__c = qd1.JP_WholeSalePriceMulQuantity__c;
        qd1.JP_PriceYearMonth__c = 'JP 2015/09';
        qd1.JP_PreSave__c = true;
        qdList.add(qd1);

        JP_QuotationDetail__c qd2 = new JP_QuotationDetail__c();
        qd2.JP_QuotationHeader__c = qhList[0].Id;
        qd2.JP_AppGroupID__c = 'G1';
        qd2.JP_SpecialUnitPrice__c = NULL;
        qd2.JP_5PercentDiscount__c = NULL;
        qd2.JP_OverLimitDiscount__c = false;
        qd2.JP_ProductCode__c = '9999';
        qd2.JP_ProductCatalogCode__c = '2222';
        qd2.JP_PreRelease__c = false;
        qd2.JP_ProductName__c = 'テスト商品2';
        qd2.JP_Sort__c = 2;
        qd2.JP_Quantity__c = 1;
        qd2.JP_WholeSaleRate__c = 1;
        qd2.JP_UnitPrice__c = 10000;
        qd2.JP_SpecialWholeSaleTRate__c = NULL;
        qd2.JP_DiscountLimitPrice__c = 9000;
        qd2.JP_WholeSalePriceMulQuantity__c = qd2.JP_UnitPrice__c * qd2.JP_WholeSaleRate__c;
        //qd2.JP_SpecialUnitPriceMulQuantity__c = qd2.JP_SpecialUnitPrice__c * qd2.JP_Quantity__c;
        //qd2.JP_StandardMinusSpecial__c = qd2.JP_WholeSalePriceMulQuantity__c - qd2.JP_SpecialUnitPriceMulQuantity__c;
        qd2.JP_DeterminedAmount__c = qd2.JP_WholeSalePriceMulQuantity__c;
        qd2.JP_PriceYearMonth__c = 'JP 2015/09';
        qd2.JP_PreSave__c = true;
        qdList.add(qd2);

        insert qdList;
        
        qh.JP_PreSave__c = false;
        qd1.JP_PreSave__c = false;
        qd2.JP_PreSave__c = false;

        Test.startTest();
        JP_QuotationHeaderTriggerAction.getApprovalProcessNo(qhList);
        Test.stopTest();
        system.debug('****** ApprovalProcessKey ApprovalProcessKey ' + qh.JP_ApprovalProcessKey__c);
        system.assertEquals(qh.JP_QuotationApprovalProcessNo__c, '1');
    }

    static testMethod void testGetApprovalProcessNo2(){
        List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
        List<JP_QuotationHeader__c> qhList = new List<JP_QuotationHeader__c>();

        JP_ApprovalProcessMaster__c apm = JP_TestUtil.Create_JP_ApprovalProcessMaster(2);
        List<JP_QuotationDistributor__c> distributorList = JP_TestUtil.Create_JP_QuotationDistributor();

        JP_DecideApprovalProcess__c dap = new JP_DecideApprovalProcess__c();
        dap.JP_ApprovalProcessMaster__c = apm.Id;
        dap.JP_ChkTotalAmountCD__c = 'A2';
        dap.JP_ChkWholeSaleCD__c = 'B2';
        dap.JP_ChkLimitDiscountCD__c = 'C1';
        dap.JP_ChkRegisteredProductCD__c = 'D1';
        dap.JP_ChkQuotationExpiryDateCD__c = 'E2';
        dap.JP_ChkPreReleaseCD__c = 'F1';
        insert dap;

        JP_QuotationHeader__c qh = new JP_QuotationHeader__c();
        qh.JP_QuotationStatus__c = JP_Const.QUOTATION_STATUS_UNAPPROVE;
        qh.JP_PreSave__c = true;
        qh.JP_TriggerSkipFLG__c = false;
        qh.JP_QuotationEffectiveTerm__c = '120';
        qh.JP_TotalAmount__c = 3000000;
        qh.JP_QuotationDistCD__c = distributorList[0].Id;
        qhList.add(qh);
        insert qhList;

        JP_QuotationDetail__c qd1 = new JP_QuotationDetail__c();
        qd1.JP_QuotationHeader__c = qhList[0].Id;
        qd1.JP_AppGroupID__c = 'G1';
        qd1.JP_SpecialUnitPrice__c = 12000;
        qd1.JP_5PercentDiscount__c = 10000;
        qd1.JP_OverLimitDiscount__c = false;
        qd1.JP_ProductCode__c = NULL;
        qd1.JP_ProductCatalogCode__c = 'z';
        qd1.JP_PreRelease__c = false;
        qd1.JP_ProductName__c = 'テスト商品1';
        qd1.JP_Sort__c = 1;
        qd1.JP_Quantity__c = 1;
        qd1.JP_WholeSaleRate__c = 1;
        qd1.JP_UnitPrice__c = 15000;
        qd1.JP_SpecialWholeSaleTRate__c = 0.8;
        qd1.JP_DiscountLimitPrice__c = 9000;
        qd1.JP_WholeSalePriceMulQuantity__c = qd1.JP_UnitPrice__c * qd1.JP_WholeSaleRate__c;
        qd1.JP_SpecialUnitPriceMulQuantity__c = qd1.JP_SpecialUnitPrice__c * qd1.JP_Quantity__c;
        qd1.JP_StandardMinusSpecial__c = qd1.JP_WholeSalePriceMulQuantity__c - qd1.JP_SpecialUnitPriceMulQuantity__c;
        qd1.JP_DeterminedAmount__c = qd1.JP_SpecialUnitPriceMulQuantity__c;
        qd1.JP_PriceYearMonth__c = 'JP 2015/09';
        qd1.JP_PreSave__c = true;
        qdList.add(qd1);

        JP_QuotationDetail__c qd2 = new JP_QuotationDetail__c();
        qd2.JP_QuotationHeader__c = qhList[0].Id;
        qd2.JP_AppGroupID__c = 'G1';
        qd2.JP_SpecialUnitPrice__c = NULL;
        qd2.JP_5PercentDiscount__c = NULL;
        qd2.JP_OverLimitDiscount__c = false;
        qd2.JP_ProductCode__c = '9999';
        qd2.JP_ProductCatalogCode__c = '2222';
        qd2.JP_PreRelease__c = false;
        qd2.JP_ProductName__c = 'テスト商品2';
        qd2.JP_Sort__c = 2;
        qd2.JP_Quantity__c = 1;
        qd2.JP_WholeSaleRate__c = 1;
        qd2.JP_UnitPrice__c = 10000;
        qd2.JP_SpecialWholeSaleTRate__c = NULL;
        qd2.JP_DiscountLimitPrice__c = 9000;
        qd2.JP_WholeSalePriceMulQuantity__c = qd2.JP_UnitPrice__c * qd2.JP_WholeSaleRate__c;
        //qd2.JP_SpecialUnitPriceMulQuantity__c = qd2.JP_SpecialUnitPrice__c * qd2.JP_Quantity__c;
        //qd2.JP_StandardMinusSpecial__c = qd2.JP_WholeSalePriceMulQuantity__c - qd2.JP_SpecialUnitPriceMulQuantity__c;
        qd2.JP_DeterminedAmount__c = qd2.JP_WholeSalePriceMulQuantity__c;
        qd2.JP_PriceYearMonth__c = 'JP 2015/09';
        qd2.JP_PreSave__c = true;
        qdList.add(qd2);

        insert qdList;
        
        qh.JP_PreSave__c = false;
        qd1.JP_PreSave__c = false;
        qd2.JP_PreSave__c = false;

        Test.startTest();
        JP_QuotationHeaderTriggerAction.getApprovalProcessNo(qhList);
        Test.stopTest();
        system.debug('****** ApprovalProcessKey ' + qh.JP_ApprovalProcessKey__c);
        system.assertEquals(qh.JP_QuotationApprovalProcessNo__c, '2');
    }

    static testMethod void testGetApprovalProcessNo3(){
        List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
        List<JP_QuotationHeader__c> qhList = new List<JP_QuotationHeader__c>();

        JP_ApprovalProcessMaster__c apm = JP_TestUtil.Create_JP_ApprovalProcessMaster(3);
        List<JP_QuotationDistributor__c> distributorList = JP_TestUtil.Create_JP_QuotationDistributor();

        JP_DecideApprovalProcess__c dap = new JP_DecideApprovalProcess__c();
        dap.JP_ApprovalProcessMaster__c = apm.Id;
        dap.JP_ChkTotalAmountCD__c = 'A3';
        dap.JP_ChkWholeSaleCD__c = 'B1';
        dap.JP_ChkLimitDiscountCD__c = 'C1';
        dap.JP_ChkRegisteredProductCD__c = 'D1';
        dap.JP_ChkQuotationExpiryDateCD__c = 'E2';
        dap.JP_ChkPreReleaseCD__c = 'F1';
        insert dap;

        JP_QuotationHeader__c qh = new JP_QuotationHeader__c();
        qh.JP_QuotationStatus__c = JP_Const.QUOTATION_STATUS_UNAPPROVE;
        qh.JP_PreSave__c = true;
        qh.JP_TriggerSkipFLG__c = false;
        qh.JP_QuotationEffectiveTerm__c = '120';
        qh.JP_TotalAmount__c = 10000000;
        qh.JP_QuotationDistCD__c = distributorList[0].Id;
        qhList.add(qh);
        insert qhList;

        JP_QuotationDetail__c qd1 = new JP_QuotationDetail__c();
        qd1.JP_QuotationHeader__c = qhList[0].Id;
        qd1.JP_AppGroupID__c = 'G1';
        qd1.JP_SpecialUnitPrice__c = 10000;
        qd1.JP_5PercentDiscount__c = 12000;
        qd1.JP_OverLimitDiscount__c = false;
        qd1.JP_ProductCode__c = '9999';
        qd1.JP_ProductCatalogCode__c = '1111';
        qd1.JP_PreRelease__c = false;
        qd1.JP_ProductName__c = 'テスト商品1';
        qd1.JP_Sort__c = 1;
        qd1.JP_Quantity__c = 1;
        qd1.JP_WholeSaleRate__c = 1;
        qd1.JP_UnitPrice__c = 10000;
        qd1.JP_SpecialWholeSaleTRate__c = 0.8;
        qd1.JP_DiscountLimitPrice__c = 9000;
        qd1.JP_WholeSalePriceMulQuantity__c = qd1.JP_UnitPrice__c * qd1.JP_WholeSaleRate__c;
        qd1.JP_SpecialUnitPriceMulQuantity__c = qd1.JP_SpecialUnitPrice__c * qd1.JP_Quantity__c;
        qd1.JP_StandardMinusSpecial__c = qd1.JP_WholeSalePriceMulQuantity__c - qd1.JP_SpecialUnitPriceMulQuantity__c;
        qd1.JP_DeterminedAmount__c = qd1.JP_SpecialUnitPriceMulQuantity__c;
        qd1.JP_PriceYearMonth__c = 'JP 2015/09';
        qd1.JP_PreSave__c = true;
        qdList.add(qd1);

        JP_QuotationDetail__c qd2 = new JP_QuotationDetail__c();
        qd2.JP_QuotationHeader__c = qhList[0].Id;
        qd2.JP_AppGroupID__c = 'G1';
        qd2.JP_SpecialUnitPrice__c = NULL;
        qd2.JP_5PercentDiscount__c = NULL;
        qd2.JP_OverLimitDiscount__c = false;
        qd2.JP_ProductCode__c = '9999';
        qd2.JP_ProductCatalogCode__c = '2222';
        qd2.JP_PreRelease__c = false;
        qd2.JP_ProductName__c = 'テスト商品2';
        qd2.JP_Sort__c = 2;
        qd2.JP_Quantity__c = 1;
        qd2.JP_WholeSaleRate__c = 1;
        qd2.JP_UnitPrice__c = 10000;
        qd2.JP_SpecialWholeSaleTRate__c = NULL;
        qd2.JP_DiscountLimitPrice__c = 9000;
        qd2.JP_WholeSalePriceMulQuantity__c = qd2.JP_UnitPrice__c * qd2.JP_WholeSaleRate__c;
        //qd2.JP_SpecialUnitPriceMulQuantity__c = qd2.JP_SpecialUnitPrice__c * qd2.JP_Quantity__c;
        //qd2.JP_StandardMinusSpecial__c = qd2.JP_WholeSalePriceMulQuantity__c - qd2.JP_SpecialUnitPriceMulQuantity__c;
        qd2.JP_DeterminedAmount__c = qd2.JP_WholeSalePriceMulQuantity__c;
        qd2.JP_PriceYearMonth__c = 'JP 2015/09';
        qd2.JP_PreSave__c = true;
        qdList.add(qd2);

        insert qdList;
        
        qh.JP_PreSave__c = false;
        qd1.JP_PreSave__c = false;
        qd2.JP_PreSave__c = false;

        Test.startTest();
        JP_QuotationHeaderTriggerAction.getApprovalProcessNo(qhList);
        Test.stopTest();
        system.debug('****** ApprovalProcessKey ' + qh.JP_ApprovalProcessKey__c);
        system.assertEquals(qh.JP_QuotationApprovalProcessNo__c, '3');
    }

    static testMethod void testGetApprovalProcessNo4(){
        List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
        List<JP_QuotationHeader__c> qhList = new List<JP_QuotationHeader__c>();

        JP_ApprovalProcessMaster__c apm = JP_TestUtil.Create_JP_ApprovalProcessMaster(4);
        List<JP_QuotationDistributor__c> distributorList = JP_TestUtil.Create_JP_QuotationDistributor();

        JP_DecideApprovalProcess__c dap = new JP_DecideApprovalProcess__c();
        dap.JP_ApprovalProcessMaster__c = apm.Id;
        dap.JP_ChkTotalAmountCD__c = 'A2';
        dap.JP_ChkWholeSaleCD__c = 'B1';
        dap.JP_ChkLimitDiscountCD__c = 'C1';
        dap.JP_ChkRegisteredProductCD__c = 'D1';
        dap.JP_ChkQuotationExpiryDateCD__c = 'E2';
        dap.JP_ChkPreReleaseCD__c = 'F1';
        insert dap;

        JP_QuotationHeader__c qh = new JP_QuotationHeader__c();
        qh.JP_QuotationStatus__c = JP_Const.QUOTATION_STATUS_UNAPPROVE;
        qh.JP_PreSave__c = true;
        qh.JP_TriggerSkipFLG__c = false;
        qh.JP_QuotationEffectiveTerm__c = '120';
        qh.JP_TotalAmount__c = 3000000;
        qh.JP_QuotationDistCD__c = distributorList[0].Id;
        qhList.add(qh);
        insert qhList;

        JP_QuotationDetail__c qd1 = new JP_QuotationDetail__c();
        qd1.JP_QuotationHeader__c = qhList[0].Id;
        qd1.JP_AppGroupID__c = 'G2';
        qd1.JP_SpecialUnitPrice__c = 110000;
        qd1.JP_5PercentDiscount__c = 100000;
        qd1.JP_OverLimitDiscount__c = false;
        qd1.JP_ProductCode__c = '9999';
        qd1.JP_ProductCatalogCode__c = '2222';
        qd1.JP_PreRelease__c = false;
        qd1.JP_ProductName__c = 'テスト商品2';
        qd1.JP_Sort__c = 2;
        qd1.JP_Quantity__c = 1000;
        qd1.JP_WholeSaleRate__c = 1;
        qd1.JP_UnitPrice__c = 100000;
        qd1.JP_SpecialWholeSaleTRate__c = NULL;
        qd1.JP_DiscountLimitPrice__c = 9000;
        qd1.JP_WholeSalePriceMulQuantity__c = qd1.JP_UnitPrice__c * qd1.JP_WholeSaleRate__c;
        //qd1.JP_SpecialUnitPriceMulQuantity__c = qd1.JP_SpecialUnitPrice__c * qd1.JP_Quantity__c;
        //qd1.JP_StandardMinusSpecial__c = qd1.JP_WholeSalePriceMulQuantity__c - qd1.JP_SpecialUnitPriceMulQuantity__c;
        qd1.JP_DeterminedAmount__c = qd1.JP_WholeSalePriceMulQuantity__c;
        qd1.JP_PriceYearMonth__c = 'JP 2015/09';
        qd1.JP_PreSave__c = true;
        qdList.add(qd1);

        JP_QuotationDetail__c qd2 = new JP_QuotationDetail__c();
        qd2.JP_QuotationHeader__c = qhList[0].Id;
        qd2.JP_AppGroupID__c = 'G2';
        qd2.JP_SpecialUnitPrice__c = 100000;
        qd2.JP_5PercentDiscount__c = 110000;
        qd2.JP_OverLimitDiscount__c = true;
        qd2.JP_ProductCode__c = '9999';
        qd2.JP_ProductCatalogCode__c = '1111';
        qd2.JP_PreRelease__c = false;
        qd2.JP_ProductName__c = 'テスト商品1';
        qd2.JP_Sort__c = 1;
        qd2.JP_Quantity__c = 1;
        qd2.JP_WholeSaleRate__c = 1;
        qd2.JP_UnitPrice__c = 10000;
        qd2.JP_SpecialWholeSaleTRate__c = 0.8;
        qd2.JP_DiscountLimitPrice__c = 9000;
        qd2.JP_WholeSalePriceMulQuantity__c = qd2.JP_UnitPrice__c * qd2.JP_WholeSaleRate__c;
        qd2.JP_SpecialUnitPriceMulQuantity__c = qd2.JP_SpecialUnitPrice__c * qd2.JP_Quantity__c;
        qd2.JP_StandardMinusSpecial__c = qd2.JP_WholeSalePriceMulQuantity__c - qd2.JP_SpecialUnitPriceMulQuantity__c;
        qd2.JP_DeterminedAmount__c = qd2.JP_SpecialUnitPriceMulQuantity__c;
        qd2.JP_PriceYearMonth__c = 'JP 2015/09';
        qd2.JP_PreSave__c = true;
        qdList.add(qd2);

        insert qdList;
        
        qh.JP_PreSave__c = false;
        qd1.JP_PreSave__c = false;
        qd2.JP_PreSave__c = false;

        Test.startTest();
        JP_QuotationHeaderTriggerAction.getApprovalProcessNo(qhList);
        Test.stopTest();
        system.debug('****** ApprovalProcessKey ' + qh.JP_ApprovalProcessKey__c);
        system.assertEquals(qh.JP_QuotationApprovalProcessNo__c, '4');
    }

    static testMethod void testGetApprovalProcessNo5(){
        List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
        List<JP_QuotationHeader__c> qhList = new List<JP_QuotationHeader__c>();

        JP_ApprovalProcessMaster__c apm = JP_TestUtil.Create_JP_ApprovalProcessMaster(5);
        List<JP_QuotationDistributor__c> distributorList = JP_TestUtil.Create_JP_QuotationDistributor();

        JP_DecideApprovalProcess__c dap = new JP_DecideApprovalProcess__c();
        dap.JP_ApprovalProcessMaster__c = apm.Id;
        dap.JP_ChkTotalAmountCD__c = 'A3';
        dap.JP_ChkWholeSaleCD__c = 'B1';
        dap.JP_ChkLimitDiscountCD__c = 'C1';
        dap.JP_ChkRegisteredProductCD__c = 'D2';
        dap.JP_ChkQuotationExpiryDateCD__c = 'E2';
        dap.JP_ChkPreReleaseCD__c = 'F2';
        insert dap;

        JP_QuotationHeader__c qh = new JP_QuotationHeader__c();
        qh.JP_QuotationStatus__c = JP_Const.QUOTATION_STATUS_UNAPPROVE;
        qh.JP_PreSave__c = true;
        qh.JP_TriggerSkipFLG__c = false;
        qh.JP_QuotationEffectiveTerm__c = '120';
        qh.JP_TotalAmount__c = 10000000;
        qh.JP_QuotationDistCD__c = distributorList[0].Id;
        qhList.add(qh);
        insert qhList;

        JP_QuotationDetail__c qd1 = new JP_QuotationDetail__c();
        qd1.JP_QuotationHeader__c = qhList[0].Id;
        qd1.JP_AppGroupID__c = 'G3';
        qd1.JP_SpecialUnitPrice__c = 100000;
        qd1.JP_5PercentDiscount__c = 110000;
        qd1.JP_OverLimitDiscount__c = true;
        qd1.JP_ProductCode__c = '9999';
        qd1.JP_ProductCatalogCode__c = '1111';
        qd1.JP_PreRelease__c = true;
        qd1.JP_ProductName__c = 'テスト商品1';
        qd1.JP_Sort__c = 1;
        qd1.JP_Quantity__c = 1;
        qd1.JP_WholeSaleRate__c = 1;
        qd1.JP_UnitPrice__c = 10000;
        qd1.JP_SpecialWholeSaleTRate__c = 0.8;
        qd1.JP_DiscountLimitPrice__c = 9000;
        qd1.JP_WholeSalePriceMulQuantity__c = qd1.JP_UnitPrice__c * qd1.JP_WholeSaleRate__c;
        qd1.JP_SpecialUnitPriceMulQuantity__c = qd1.JP_SpecialUnitPrice__c * qd1.JP_Quantity__c;
        qd1.JP_StandardMinusSpecial__c = qd1.JP_WholeSalePriceMulQuantity__c - qd1.JP_SpecialUnitPriceMulQuantity__c;
        qd1.JP_DeterminedAmount__c = qd1.JP_SpecialUnitPriceMulQuantity__c;
        qd1.JP_PriceYearMonth__c = 'JP 2015/09';
        qd1.JP_PreSave__c = true;
        qdList.add(qd1);

        JP_QuotationDetail__c qd2 = new JP_QuotationDetail__c();
        qd2.JP_QuotationHeader__c = qhList[0].Id;
        qd2.JP_AppGroupID__c = 'G1';
        qd2.JP_SpecialUnitPrice__c = 110000;
        qd2.JP_5PercentDiscount__c = 100000;
        qd2.JP_OverLimitDiscount__c = false;
        qd2.JP_ProductCode__c = '9999';
        qd2.JP_ProductCatalogCode__c = '2222';
        qd2.JP_PreRelease__c = false;
        qd2.JP_ProductName__c = 'テスト商品2';
        qd2.JP_Sort__c = 2;
        qd2.JP_Quantity__c = 1000;
        qd2.JP_WholeSaleRate__c = 1;
        qd2.JP_UnitPrice__c = 100000;
        qd2.JP_SpecialWholeSaleTRate__c = NULL;
        qd2.JP_DiscountLimitPrice__c = 9000;
        qd2.JP_WholeSalePriceMulQuantity__c = qd2.JP_UnitPrice__c * qd2.JP_WholeSaleRate__c;
        //qd2.JP_SpecialUnitPriceMulQuantity__c = qd2.JP_SpecialUnitPrice__c * qd2.JP_Quantity__c;
        //qd2.JP_StandardMinusSpecial__c = qd2.JP_WholeSalePriceMulQuantity__c - qd2.JP_SpecialUnitPriceMulQuantity__c;
        qd2.JP_DeterminedAmount__c = qd2.JP_WholeSalePriceMulQuantity__c;
        qd2.JP_PriceYearMonth__c = 'JP 2015/09';
        qd2.JP_PreSave__c = true;
        qdList.add(qd2);
        
        JP_QuotationDetail__c qd3 = new JP_QuotationDetail__c();
        qd3.JP_QuotationHeader__c = qhList[0].Id;
        qd3.JP_AppGroupID__c = 'G1';
        qd3.JP_SpecialUnitPrice__c = 110000;
        qd3.JP_5PercentDiscount__c = 100000;
        qd3.JP_OverLimitDiscount__c = false;
        qd3.JP_ProductCatalogCode__c = '****';
        qd3.JP_PreRelease__c = false;
        qd3.JP_ProductName__c = 'テスト商品2';
        qd3.JP_Sort__c = 2;
        qd3.JP_Quantity__c = 1000;
        qd3.JP_WholeSaleRate__c = 1;
        qd3.JP_UnitPrice__c = 100000;
        qd3.JP_SpecialWholeSaleTRate__c = NULL;
        qd3.JP_DiscountLimitPrice__c = 9000;
        qd3.JP_WholeSalePriceMulQuantity__c = qd3.JP_UnitPrice__c * qd3.JP_WholeSaleRate__c;
        //qd3.JP_SpecialUnitPriceMulQuantity__c = qd3.JP_SpecialUnitPrice__c * qd3.JP_Quantity__c;
        //qd3.JP_StandardMinusSpecial__c = qd3.JP_WholeSalePriceMulQuantity__c - qd3.JP_SpecialUnitPriceMulQuantity__c;
        qd3.JP_DeterminedAmount__c = qd3.JP_WholeSalePriceMulQuantity__c;
        qd3.JP_PriceYearMonth__c = 'JP 2015/09';
        qd3.JP_PreSave__c = true;
        qdList.add(qd3);

        insert qdList;
        
        qh.JP_PreSave__c = false;
        qd1.JP_PreSave__c = false;
        qd2.JP_PreSave__c = false;

        Test.startTest();
        JP_QuotationHeaderTriggerAction.getApprovalProcessNo(qhList);
        Test.stopTest();
        system.debug('****** ApprovalProcessKey ' + qh.JP_ApprovalProcessKey__c);
        system.assertEquals(qh.JP_QuotationApprovalProcessNo__c, '5');
    }
    
    
    //見積基本情報共通入力チェック
    static testMethod void testMethodHeaderCommonValidation1(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
            Test.startTest();
            JP_QuotationHeader__c qh = new JP_QuotationHeader__c();
            qh.JP_QuotationStatus__c = JP_Const.QUOTATION_STATUS_UNAPPROVE;
            qh.JP_PreSave__c = false;
            qh.JP_TriggerSkipFLG__c = true;
            qh.JP_QuotationEffectiveTerm__c = null;
            qh.JP_TotalAmount__c = null;
            qh.JP_QuotationDistCD__c = null;
            Boolean isError = JP_QuotationHeaderTriggerAction.headerCommonValidation(qh);
            System.assertEquals(true,isError);     
            Test.stopTest();
        }  
    }
    
    //見積基本情報共通入力チェック
    static testMethod void testMethodHeaderCommonValidation2(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
            Test.startTest();
            JP_QuotationHeader__c qh = new JP_QuotationHeader__c();
            qh.JP_QuotationStatus__c = JP_Const.QUOTATION_STATUS_UNAPPROVE;
            qh.JP_PreSave__c = false;
            qh.JP_TriggerSkipFLG__c = false;
            qh.JP_QuotationEffectiveTerm__c = null;
            qh.JP_TotalAmount__c = 0;
            qh.JP_QuotationDistCD__c = null;
            Boolean isError = JP_QuotationHeaderTriggerAction.headerCommonValidation(qh);
            System.assertEquals(true,isError);     
            Test.stopTest();
        }  
    }

    //見積基本情報共通入力チェック
    static testMethod void testMethodHeaderCommonValidation3(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
            Test.startTest();
            JP_QuotationHeader__c qh = new JP_QuotationHeader__c();
            qh.JP_QuotationStatus__c = JP_Const.QUOTATION_STATUS_UNAPPROVE;
            qh.JP_PreSave__c = false;
            qh.JP_TriggerSkipFLG__c = false;
            qh.JP_QuotationEffectiveTerm__c = null;
            qh.JP_TotalAmount__c = -10;
            qh.JP_QuotationDistCD__c = null;
            Boolean isError = JP_QuotationHeaderTriggerAction.headerCommonValidation(qh);
            System.assertEquals(true,isError);     
            Test.stopTest();
        }  
    }

    //承認プロセスNo有無確認
    static testMethod void testMethodNoExistCheck4(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
            Test.startTest();
            List<JP_QuotationHeader__c> qhList = new List<JP_QuotationHeader__c>();
            JP_QuotationHeader__c qh = new JP_QuotationHeader__c();
            qh.JP_QuotationStatus__c = JP_Const.QUOTATION_STATUS_UNAPPROVE;
            qh.JP_PreSave__c = false;
            qh.JP_TriggerSkipFLG__c = false;
            qh.JP_QuotationEffectiveTerm__c = null;
            qh.JP_TotalAmount__c = -10;
            qh.JP_QuotationDistCD__c = null;
            qh.JP_QuotationApprovalProcessNo__c = null;
            qhList.add(qh);
            Boolean isError = JP_QuotationHeaderTriggerAction.processNoExistCheck(qhList);
            System.assertEquals(true,isError);     
            Test.stopTest();
        }  
    }   
    
    //申請中承認プロセスNo変更禁止処理
    static testMethod void testMethodProcessNoNotChangeForRequest5(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
            Test.startTest();
            //新規情報
            List<JP_QuotationHeader__c> qhList = new List<JP_QuotationHeader__c>();
            //古い情報
            Map<Id,JP_QuotationHeader__c> qhMap = new Map<Id,JP_QuotationHeader__c>();
            JP_QuotationHeader__c qh = new JP_QuotationHeader__c();
            qh.JP_QuotationStatus__c = JP_Const.QUOTATION_STATUS_UNAPPROVE;
            qh.JP_PreSave__c = true;
            qh.JP_TriggerSkipFLG__c = true;
            qh.JP_QuotationEffectiveTerm__c = null;
            qh.JP_TotalAmount__c = 100;
            qh.JP_QuotationDistCD__c = null;
            qh.JP_QuotationApprovalProcessNo__c = '50';
            qh.JP_QuotationStatus__c = System.Label.JP_Status_RequestInspection;
            qhList.add(qh);
            insert qhList;
            qhlist = [SELECT ID,JP_QuotationApprovalProcessNo__c,JP_PreSave__c,JP_TriggerSkipFLG__c,JP_QuotationStatus__c FROM JP_QuotationHeader__c WHERE ID IN :qhList];
            qhMap.put(qhList[0].Id,qhList[0]);
            JP_QuotationHeader__c qh2 = qhList[0].clone(true,false);
            List<JP_QuotationHeader__c> qhList2 =  new List<JP_QuotationHeader__c>();
            qh2.JP_QuotationApprovalProcessNo__c = '10';
            qh2.JP_PreSave__c = false;
            qh2.JP_TriggerSkipFLG__c = false;
            qhList2.add(qh2);
            System.assertEquals(qhMap.get(qhList2[0].Id).JP_QuotationApprovalProcessNo__c,'50');
            Boolean isError = JP_QuotationHeaderTriggerAction.processNoNotChangeForRequest(qhMap,qhList2);
            System.assertEquals(true,isError);     
            Test.stopTest();
        }  
    }       

    //handlerPass Insert
    static testMethod void testMethodInsertPattern(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
            Test.startTest();
            List<JP_QuotationDistributor__c> distributorList = JP_TestUtil.Create_JP_QuotationDistributor();
            List<JP_QuotationHeader__c> qhList = new List<JP_QuotationHeader__c>(); 
            JP_QuotationHeader__c qh = new JP_QuotationHeader__c();
            qh.JP_QuotationStatus__c = JP_Const.QUOTATION_STATUS_UNAPPROVE;
            qh.JP_PreSave__c = false;
            qh.JP_TriggerSkipFLG__c = false;
            qh.JP_QuotationEffectiveTerm__c = '30';
            qh.JP_TotalAmount__c = 100;
            qh.JP_QuotationDistCD__c = distributorList[0].Id;
            qhList.add(qh);
            insert qhList;
            qhList = [SELECT ID FROM JP_QuotationHeader__c WHERE ID IN :qhList];
            System.assertEquals(qhList.size(),1);    
            Test.stopTest();
        }
    }  
    
    
    //HandlerPass Update
    static testMethod void testMethodUpdatePattern(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
            Test.startTest();
            List<JP_QuotationDistributor__c> distributorList = JP_TestUtil.Create_JP_QuotationDistributor();
            List<JP_QuotationHeader__c> qhList = new List<JP_QuotationHeader__c>(); 
            JP_QuotationHeader__c qh = new JP_QuotationHeader__c();
            qh.JP_QuotationStatus__c = JP_Const.QUOTATION_STATUS_UNAPPROVE;
            qh.JP_PreSave__c = false;
            qh.JP_TriggerSkipFLG__c = false;
            qh.JP_QuotationEffectiveTerm__c = '30';
            qh.JP_TotalAmount__c = 100;
            qh.JP_QuotationDistCD__c = distributorList[0].Id;
            qhList.add(qh);
            insert qhList;
            qhList = [SELECT ID FROM JP_QuotationHeader__c WHERE ID IN :qhList];
            try{
                update qhList;
            }catch(DmlException e){
                System.assertEquals(e.getDMLMessage(0),JP_Const.ERR_MESSAGE_APPROVAL_PROCESS_NO);
            }
            Test.stopTest();
        }
    }  


    //承認プロセスNo別バリデーション　最終承認者='取締役'
    static testMethod void testMethodProcessNoValidation6(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
            Test.startTest();
            List<JP_QuotationHeader__c> qhList = new List<JP_QuotationHeader__c>();
            JP_QuotationHeader__c qh = new JP_QuotationHeader__c();
            qh.JP_QuotationStatus__c = JP_Const.QUOTATION_STATUS_UNAPPROVE;
            qh.JP_PreSave__c = false;
            qh.JP_TriggerSkipFLG__c = false;
            qh.JP_QuotationEffectiveTerm__c = null;
            qh.JP_TotalAmount__c = -10;
            qh.JP_QuotationDistCD__c = null;
            //取締役
            qh.JP_QuotationApprovalProcessNo__c = '5';
            qh.JP_OpportunityNo__c = null;
            qh.JP_DiscountReason__c = null;
            qh.JP_BusinessPotential__c = null;
            qhList.add(qh);
            Boolean isError = JP_QuotationHeaderTriggerAction.processNoValidation(qhList);
            System.assertEquals(true,isError);     
            Test.stopTest();
        }
    }  
    
    
    //承認プロセスNo別バリデーション 最終承認者='製品担当者'
    static testMethod void testMethodProcessNoValidation7(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
            Test.startTest();
            List<JP_QuotationHeader__c> qhList = new List<JP_QuotationHeader__c>();
            JP_QuotationHeader__c qh = new JP_QuotationHeader__c();
            qh.JP_QuotationStatus__c = JP_Const.QUOTATION_STATUS_UNAPPROVE;
            qh.JP_PreSave__c = false;
            qh.JP_TriggerSkipFLG__c = false;
            qh.JP_QuotationEffectiveTerm__c = null;
            qh.JP_TotalAmount__c = -10;
            qh.JP_QuotationDistCD__c = null;
            //取締役
            qh.JP_QuotationApprovalProcessNo__c = '6';
            qh.JP_OpportunityNo__c = null;
            qh.JP_DiscountReason__c = null;
            qh.JP_BusinessPotential__c = null;
            qhList.add(qh);
            Boolean isError = JP_QuotationHeaderTriggerAction.processNoValidation(qhList);
            System.assertEquals(true,isError);     
            Test.stopTest();
        }
    }
    
    //ステップユーザ初期化処理
    static testMethod void testMethodProcessStepUserReset8(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        User setUsr = JP_TestUtil.Create_ApproverUser('A151_取締役');
        System.runAs(testUsr){
            Test.startTest();
            //新規情報
            List<JP_QuotationHeader__c> qhList = new List<JP_QuotationHeader__c>();
            //古い情報
            Map<Id,JP_QuotationHeader__c> qhMap = new Map<Id,JP_QuotationHeader__c>();
            JP_QuotationHeader__c qh = new JP_QuotationHeader__c();
            qh.JP_QuotationStatus__c = JP_Const.QUOTATION_STATUS_UNAPPROVE;
            qh.JP_PreSave__c = true;
            qh.JP_TriggerSkipFLG__c = true;
            qh.JP_QuotationEffectiveTerm__c = null;
            qh.JP_TotalAmount__c = 100;
            qh.JP_QuotationDistCD__c = null;
            qh.JP_QuotationApprovalProcessNo__c = '50';
            qh.JP_QuotationStatus__c = System.Label.JP_Status_RequestInspection;
            /*---------------初期化対象--------------*/
            qh.JP_SectionChief__c = setUsr.Id;
            qh.JP_Manager__c = setUsr.Id;
            qh.JP_GeneralManager__c = setUsr.Id;
            qh.JP_Director__c = setUsr.Id;
            qh.JP_Step0Status__c = 'teststatus';
            qh.JP_Step1Approver__c = setUsr.Id;
            qh.JP_Step1exec__c  = true;
            qh.JP_Step1Skip__c  =  true;
            qh.JP_Step1Status__c = 'testStatus';
            qh.JP_Step1type__c = 'testType';
            qh.JP_Step2Approver__c = setUsr.Id;
            qh.JP_Step2exec__c = true;
            qh.JP_Step2Skip__c = true;
            qh.JP_Step2Status__c  = 'testStatus';
            qh.JP_Step2type__c = 'testType';
            qh.JP_Step3Approver__c = setUsr.Id;
            qh.JP_Step3exec__c = true;
            qh.JP_Step3Skip__c = true;
            qh.JP_Step3Status__c = 'teststatus';
            qh.JP_Step3type__c = 'testtype';
            qh.JP_Step4Approver__c = setUsr.Id;
            qh.JP_Step4exec__c = true;
            qh.JP_Step4Skip__c = true;
            qh.JP_Step4Status__c = 'teststatus';
            qh.JP_Step4type__c = 'testtype';
            qh.JP_Step5Approver__c = setUsr.Id;
            qh.JP_Step5exec__c = true;
            qh.JP_Step5Skip__c = true;
            qh.JP_Step5type__c = 'testtype';
            qh.JP_Step6Approver__c = setUsr.Id;
            qh.JP_Step6exec__c = true;
            qh.JP_Step6Skip__c = true;
            qh.JP_Step6Status__c = 'teststatus';
            qh.JP_Step6type__c = 'testType';
            qhList.add(qh);
            insert qhList;
            qhlist = [SELECT ID,JP_QuotationApprovalProcessNo__c,JP_PreSave__c,JP_TriggerSkipFLG__c,JP_QuotationStatus__c FROM JP_QuotationHeader__c WHERE ID IN :qhList];
            qhMap.put(qhList[0].Id,qhList[0]);
            JP_QuotationHeader__c qh2 = qhList[0].clone(true,false);
            List<JP_QuotationHeader__c> qhList2 =  new List<JP_QuotationHeader__c>();
            qh2.JP_QuotationApprovalProcessNo__c = '10';
            qh2.JP_PreSave__c = false;
            qh2.JP_TriggerSkipFLG__c = false;
            qhList2.add(qh2);
            System.assertEquals(qhMap.get(qhList2[0].Id).JP_QuotationApprovalProcessNo__c,'50');
            JP_QuotationHeaderTriggerAction.stepUserReset(qhMap,qhList2);    
            Test.stopTest();
        }  
    }       

      
    
    
}