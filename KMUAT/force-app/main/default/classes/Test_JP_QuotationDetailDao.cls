@isTest
private class Test_JP_QuotationDetailDao {
    static List<JP_QuotationDistributor__c> distibutors = JP_TestUtil.Create_JP_QuotationDistributor();
    static List<JP_QuotationContact__c> qcList = [Select Id,Name From JP_QuotationContact__c Where JP_QuotationDistributor__c=:distibutors[0].id Order by Name];

    // 【getChildrenByParentIds】見積基本1件、見積明細1件のケース
    static testMethod void testGetChildrenByParentIds1() {
        Integer headerQuantity = 1;
        Integer detailQuantity = 1;
        Map<ID,List<JP_QuotationDetail__c>> qdMap = new  Map<ID,List<JP_QuotationDetail__c>>();
        Set<ID> parentIds = new Set<ID>();
        List<JP_QuotationDetail__c> insertList = new List<JP_QuotationDetail__c>();
        List<JP_QuotationHeader__c> qhList = new List<JP_QuotationHeader__c>();
        
        //承認プロセスマスタ作成
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
        
        qhList = JP_TestUtil.Create_JP_QuotationHeader(headerQuantity);
        for(JP_QuotationHeader__c qh : qhList){
            qh.JP_QuotationDistCD__c = distibutors[0].Id;
        }
        insert qhList;
        
        for(JP_QuotationHeader__c qh : qhList){
            parentIds.add(qh.Id);
            List<JP_QuotationDetail__c> qdList = JP_TestUtil.Create_JP_QuotationDetail(qh.Id, detailQuantity);
            for(JP_QuotationDetail__c qd : qdList){
                qd.JP_QuotationHeader__c = qh.Id;
                qd.JP_AppGroupID__c = 'G1';
                qd.JP_SpecialUnitPrice__c = 0;
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
                insertList.add(qd);
            }
        }
        
        insert insertList;

        Test.startTest();
        qdMap = JP_QuotationDetailDAO.getChildrenByParentIds(parentIds);
        Test.stopTest();
        
        for(JP_QuotationHeader__c qh : qhList){
            system.assert(qdMap.containsKey(qh.Id));
            List<JP_QuotationDetail__c> qdList = qdMap.get(qh.Id);
            system.assertequals(qdList.size(),detailQuantity);
        }
    }
    
    
    // 【getChildrenByParentIds】見積基本1件、見積明細複数件のケース
    static testMethod void testGetChildrenByParentIds2() {
        Integer headerQuantity = 1;
        Integer detailQuantity = 5;
        Map<ID,List<JP_QuotationDetail__c>> qdMap = new  Map<ID,List<JP_QuotationDetail__c>>();
        Set<ID> parentIds = new Set<ID>();
        List<JP_QuotationDetail__c> insertList = new List<JP_QuotationDetail__c>();
        List<JP_QuotationHeader__c> qhList = new List<JP_QuotationHeader__c>();
        
        //承認プロセスマスタ作成
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
        
        qhList = JP_TestUtil.Create_JP_QuotationHeader(headerQuantity);
        for(JP_QuotationHeader__c qh : qhList){
            qh.JP_QuotationDistCD__c = distibutors[0].Id;
        }
        insert qhList;
        
        for(JP_QuotationHeader__c qh : qhList){
            parentIds.add(qh.Id);
            List<JP_QuotationDetail__c> qdList = JP_TestUtil.Create_JP_QuotationDetail(qh.Id, detailQuantity);
            for(JP_QuotationDetail__c qd : qdList){
                qd.JP_QuotationHeader__c = qh.Id;
                qd.JP_AppGroupID__c = 'G1';
                qd.JP_SpecialUnitPrice__c = 0;
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
                insertList.add(qd);
            }
        }
        
        insert insertList;

        Test.startTest();
        qdMap = JP_QuotationDetailDAO.getChildrenByParentIds(parentIds);
        Test.stopTest();
        
        for(JP_QuotationHeader__c qh : qhList){
            system.assert(qdMap.containsKey(qh.Id));
            List<JP_QuotationDetail__c> qdList = qdMap.get(qh.Id);
            system.assertequals(qdList.size(),detailQuantity);
        }
    }
    
    // 【getChildrenByParentIds】見積基本複数件、見積明細複数件のケース
    /**
    static testMethod void testGetChildrenByParentIds3() {
        Integer headerQuantity = 5;
        Integer detailQuantity = 5;
        Map<ID,List<JP_QuotationDetail__c>> qdMap = new  Map<ID,List<JP_QuotationDetail__c>>();
        Set<ID> parentIds = new Set<ID>();
        List<JP_QuotationDetail__c> insertList = new List<JP_QuotationDetail__c>();
        List<JP_QuotationHeader__c> qhList = new List<JP_QuotationHeader__c>();
        
        //承認プロセスマスタ作成
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
        
        qhList = JP_TestUtil.Create_JP_QuotationHeader(headerQuantity);
        for(JP_QuotationHeader__c qh : qhList){
            qh.JP_QuotationDistCD__c = distibutors[0].Id;
        }
        insert qhList;
        
        for(JP_QuotationHeader__c qh : qhList){
            parentIds.add(qh.Id);
            List<JP_QuotationDetail__c> qdList = JP_TestUtil.Create_JP_QuotationDetail(qh.Id, detailQuantity);
            for(JP_QuotationDetail__c qd : qdList){
                qd.JP_QuotationHeader__c = qh.Id;
                qd.JP_AppGroupID__c = 'G1';
                qd.JP_SpecialUnitPrice__c = 0;
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
                insertList.add(qd);
            }
        }
        
        insert insertList;

        Test.startTest();
        qdMap = JP_QuotationDetailDAO.getChildrenByParentIds(parentIds);
        Test.stopTest();
        
        for(JP_QuotationHeader__c qh : qhList){
            system.assert(qdMap.containsKey(qh.Id));
            List<JP_QuotationDetail__c> qdList = qdMap.get(qh.Id);
            system.assertequals(qdList.size(),detailQuantity);
        }
    }
    */
    
    static testMethod void testGetChildrenByParentIds4() {
        Integer headerQuantity = 1;
        Integer detailQuantity = 5;
        Map<ID,List<JP_QuotationDetail__c>> qdMap = new  Map<ID,List<JP_QuotationDetail__c>>();
        Set<ID> parentIds = new Set<ID>();
        List<JP_QuotationDetail__c> insertList = new List<JP_QuotationDetail__c>();
        List<JP_QuotationHeader__c> qhList = new List<JP_QuotationHeader__c>();
        
        //承認プロセスマスタ作成
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
        
        qhList = JP_TestUtil.Create_JP_QuotationHeader(headerQuantity);
        for(JP_QuotationHeader__c qh : qhList){
            qh.JP_QuotationDistCD__c = distibutors[0].Id;
        }
        insert qhList;
        
        for(JP_QuotationHeader__c qh : qhList){
            parentIds.add(qh.Id);
            List<JP_QuotationDetail__c> qdList = JP_TestUtil.Create_JP_QuotationDetail(qh.Id, detailQuantity);
            for(JP_QuotationDetail__c qd : qdList){
                qd.JP_QuotationHeader__c = qh.Id;
                qd.JP_AppGroupID__c = 'G1';
                qd.JP_SpecialUnitPrice__c = 0;
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
                insertList.add(qd);
            }
        }
        
        insert insertList;

        Test.startTest();
        List<JP_QuotationDetail__c> details = JP_QuotationDetailDAO.getRecByParentId(qhList[0].Id);
        Test.stopTest();
    }
    
    static testMethod void testGetChildrenByParentIds5() {
        Integer headerQuantity = 1;
        Integer detailQuantity = 5;
        Map<ID,List<JP_QuotationDetail__c>> qdMap = new  Map<ID,List<JP_QuotationDetail__c>>();
        Set<ID> parentIds = new Set<ID>();
        List<JP_QuotationDetail__c> insertList = new List<JP_QuotationDetail__c>();
        List<JP_QuotationHeader__c> qhList = new List<JP_QuotationHeader__c>();
        
        //承認プロセスマスタ作成
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
        
        qhList = JP_TestUtil.Create_JP_QuotationHeader(headerQuantity);
        for(JP_QuotationHeader__c qh : qhList){
            qh.JP_QuotationDistCD__c = distibutors[0].Id;
        }
        insert qhList;
        
        for(JP_QuotationHeader__c qh : qhList){
            parentIds.add(qh.Id);
            List<JP_QuotationDetail__c> qdList = JP_TestUtil.Create_JP_QuotationDetail(qh.Id, detailQuantity);
            for(JP_QuotationDetail__c qd : qdList){
                qd.JP_QuotationHeader__c = qh.Id;
                qd.JP_AppGroupID__c = 'G1';
                qd.JP_SpecialUnitPrice__c = 0;
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
                insertList.add(qd);
            }
        }
        
        insert insertList;

        Test.startTest();
        List<JP_QuotationDetail__c> details = JP_QuotationDetailDAO.getRecByIdUseFieldSet(qhList[0].Id);
        Test.stopTest();
    }
}