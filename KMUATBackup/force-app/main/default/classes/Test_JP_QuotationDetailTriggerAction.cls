@isTest
public class Test_JP_QuotationDetailTriggerAction {

    //Test1 正常処理
    private static testMethod void  testInsert1(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
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
            //見積基本作成
            JP_QuotationHeader__c qh = Create_JP_QuotationHeader('30');
            //見積明細作成
             List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
            JP_QuotationDetail__c qd1 = new JP_QuotationDetail__c();
            qd1.JP_QuotationHeader__c = qh.Id;
            qd1.JP_AppGroupID__c = 'G1';
            qd1.JP_SpecialUnitPrice__c = 0;
            qd1.JP_5PercentDiscount__c = 227430;
            qd1.JP_OverLimitDiscount__c = false;
            qd1.JP_ProductCode__c = '9998';
            qd1.JP_ProductCatalogCode__c = '1111';
            qd1.JP_PreRelease__c = false;
            qd1.JP_ProductName__c = 'テスト商品1';
            qd1.JP_Sort__c = 1;
            qd1.JP_Quantity__c = 1;
            qd1.JP_DetailsNo__c = 1;
            qd1.JP_WholeSaleRate__c  = 0.6;
            qd1.JP_UnitPrice__c = 239400;
            qd1.JP_SpecialWholeSaleTRate__c = NULL;
            qd1.JP_DiscountLimitPrice__c = 205884;
            qd1.JP_SalesStatus__c = '1';
            qd1.JP_WholeSalePriceMulQuantity__c = qd1.JP_UnitPrice__c * qd1.JP_WholeSaleRate__c;
            qd1.JP_SpecialUnitPriceMulQuantity__c = 0;
            qd1.JP_StandardMinusSpecial__c = 0;
            qd1.JP_DeterminedAmount__c = 239400;
            qd1.JP_PriceYearMonth__c = 'JP 2015/09';
            qd1.JP_PreSave__c = false;
            qdList.add(qd1);

            insert qdList;

        }
    }

    //Test2 商品コードブランクチェック
    private static testMethod void  testInsert2(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
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
            //見積基本作成
            JP_QuotationHeader__c qh = Create_JP_QuotationHeader('30');
            //見積明細作成
             List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
            JP_QuotationDetail__c qd1 = new JP_QuotationDetail__c();
            qd1.JP_QuotationHeader__c = qh.Id;
            qd1.JP_AppGroupID__c = 'G1';
            qd1.JP_SpecialUnitPrice__c = 0;
            qd1.JP_5PercentDiscount__c = 227430;
            qd1.JP_OverLimitDiscount__c = false;
            qd1.JP_ProductCode__c = '9998';
            //ブランク
            qd1.JP_ProductCatalogCode__c = '';
            qd1.JP_PreRelease__c = false;
            qd1.JP_ProductName__c = 'テスト商品1';
            qd1.JP_Sort__c = 1;
            qd1.JP_Quantity__c = 1;
            qd1.JP_DetailsNo__c = 1;
            qd1.JP_WholeSaleRate__c  = 0.6;
            qd1.JP_UnitPrice__c = 239400;
            qd1.JP_SpecialWholeSaleTRate__c = NULL;
            qd1.JP_DiscountLimitPrice__c = 205884;
            qd1.JP_SalesStatus__c = '1';
            qd1.JP_WholeSalePriceMulQuantity__c = qd1.JP_UnitPrice__c * qd1.JP_WholeSaleRate__c;
            qd1.JP_SpecialUnitPriceMulQuantity__c = 0;
            qd1.JP_StandardMinusSpecial__c = 0;
            qd1.JP_DeterminedAmount__c = 239400;
            qd1.JP_PriceYearMonth__c = 'JP 2015/09';
            qd1.JP_PreSave__c = false;
            qdList.add(qd1);
            
            try{
                insert qdList;
            }catch(DmlException de){
                System.AssertEquals(de.getDmlMessage(0),'No.1：商品コードへ値を設定してください。');
            }

        }
    }

    //Test3 商品名ブランクチェック
    private static testMethod void  testInsert3(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
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
            //見積基本作成
            JP_QuotationHeader__c qh = Create_JP_QuotationHeader('30');
            //見積明細作成
             List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
            JP_QuotationDetail__c qd1 = new JP_QuotationDetail__c();
            qd1.JP_QuotationHeader__c = qh.Id;
            qd1.JP_AppGroupID__c = 'G1';
            qd1.JP_SpecialUnitPrice__c = 0;
            qd1.JP_5PercentDiscount__c = 227430;
            qd1.JP_OverLimitDiscount__c = false;
            qd1.JP_ProductCode__c = '9998';
            qd1.JP_ProductCatalogCode__c = 'test';
            qd1.JP_PreRelease__c = false;
            //ブランク
            qd1.JP_ProductName__c = '';
            qd1.JP_Sort__c = 1;
            qd1.JP_Quantity__c = 1;
            qd1.JP_DetailsNo__c = 1;
            qd1.JP_WholeSaleRate__c  = 0.6;
            qd1.JP_UnitPrice__c = 239400;
            qd1.JP_SpecialWholeSaleTRate__c = NULL;
            qd1.JP_DiscountLimitPrice__c = 205884;
            qd1.JP_SalesStatus__c = '1';
            qd1.JP_WholeSalePriceMulQuantity__c = qd1.JP_UnitPrice__c * qd1.JP_WholeSaleRate__c;
            qd1.JP_SpecialUnitPriceMulQuantity__c = 0;
            qd1.JP_StandardMinusSpecial__c = 0;
            qd1.JP_DeterminedAmount__c = 239400;
            qd1.JP_PriceYearMonth__c = 'JP 2015/09';
            qd1.JP_PreSave__c = false;
            qdList.add(qd1);
            
            try{
                insert qdList;
            }catch(DmlException de){
                System.AssertEquals(de.getDmlMessage(0),'No.1：商品名へ値を設定してください。');
            }

        }
    }

    //Test4 順ブランクチェック
    private static testMethod void  testInsert4(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
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
            //見積基本作成
            JP_QuotationHeader__c qh = Create_JP_QuotationHeader('30');
            //見積明細作成
             List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
            JP_QuotationDetail__c qd1 = new JP_QuotationDetail__c();
            qd1.JP_QuotationHeader__c = qh.Id;
            qd1.JP_AppGroupID__c = 'G1';
            qd1.JP_SpecialUnitPrice__c = 0;
            qd1.JP_5PercentDiscount__c = 227430;
            qd1.JP_OverLimitDiscount__c = false;
            qd1.JP_ProductCode__c = '9998';
            qd1.JP_ProductCatalogCode__c = 'test';
            qd1.JP_PreRelease__c = false;
            qd1.JP_ProductName__c = 'テスト商品1';
            qd1.JP_Sort__c = null;
            qd1.JP_Quantity__c = 1;
            qd1.JP_DetailsNo__c = 1;
            qd1.JP_WholeSaleRate__c  = 0.6;
            qd1.JP_UnitPrice__c = 239400;
            qd1.JP_SpecialWholeSaleTRate__c = NULL;
            qd1.JP_DiscountLimitPrice__c = 205884;
            qd1.JP_SalesStatus__c = '1';
            qd1.JP_WholeSalePriceMulQuantity__c = qd1.JP_UnitPrice__c * qd1.JP_WholeSaleRate__c;
            qd1.JP_SpecialUnitPriceMulQuantity__c = 0;
            qd1.JP_StandardMinusSpecial__c = 0;
            qd1.JP_DeterminedAmount__c = 239400;
            qd1.JP_PriceYearMonth__c = 'JP 2015/09';
            qd1.JP_PreSave__c = false;
            qdList.add(qd1);
            
            try{
                insert qdList;
            }catch(DmlException de){
                System.AssertEquals(de.getDmlMessage(0),'No.1：順へ値を設定してください。');
            }

        }
    }

    //Test5 数量ブランクチェック
    private static testMethod void  testInsert5(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
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
            //見積基本作成
            JP_QuotationHeader__c qh = Create_JP_QuotationHeader('30');
            //見積明細作成
             List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
            JP_QuotationDetail__c qd1 = new JP_QuotationDetail__c();
            qd1.JP_QuotationHeader__c = qh.Id;
            qd1.JP_AppGroupID__c = 'G1';
            qd1.JP_SpecialUnitPrice__c = 0;
            qd1.JP_5PercentDiscount__c = 227430;
            qd1.JP_OverLimitDiscount__c = false;
            qd1.JP_ProductCode__c = '9998';
            qd1.JP_ProductCatalogCode__c = 'test';
            qd1.JP_PreRelease__c = false;
            qd1.JP_ProductName__c = 'テスト商品1';
            qd1.JP_Sort__c = null;
            //null
            qd1.JP_Quantity__c = null;
            qd1.JP_DetailsNo__c = 1;
            qd1.JP_WholeSaleRate__c  = 0.6;
            qd1.JP_UnitPrice__c = 239400;
            qd1.JP_SpecialWholeSaleTRate__c = NULL;
            qd1.JP_DiscountLimitPrice__c = 205884;
            qd1.JP_SalesStatus__c = '1';
            qd1.JP_WholeSalePriceMulQuantity__c = qd1.JP_UnitPrice__c * qd1.JP_WholeSaleRate__c;
            qd1.JP_SpecialUnitPriceMulQuantity__c = 0;
            qd1.JP_StandardMinusSpecial__c = 0;
            qd1.JP_DeterminedAmount__c = 239400;
            qd1.JP_PriceYearMonth__c = 'JP 2015/09';
            qd1.JP_PreSave__c = false;
            qdList.add(qd1);
            
            try{
                insert qdList;
            }catch(DmlException de){
                System.AssertEquals(de.getDmlMessage(0),'No.1：数量へ値を設定してください。');
            }

        }
    }

    //Test6 数量0チェック
    private static testMethod void  testInsert6(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
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
            //見積基本作成
            JP_QuotationHeader__c qh = Create_JP_QuotationHeader('30');
            //見積明細作成
             List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
            JP_QuotationDetail__c qd1 = new JP_QuotationDetail__c();
            qd1.JP_QuotationHeader__c = qh.Id;
            qd1.JP_AppGroupID__c = 'G1';
            qd1.JP_SpecialUnitPrice__c = 0;
            qd1.JP_5PercentDiscount__c = 227430;
            qd1.JP_OverLimitDiscount__c = false;
            qd1.JP_ProductCode__c = '9998';
            qd1.JP_ProductCatalogCode__c = 'test';
            qd1.JP_PreRelease__c = false;
            qd1.JP_ProductName__c = 'テスト商品1';
            qd1.JP_Sort__c = null;
            //0
            qd1.JP_Quantity__c = 0;
            qd1.JP_DetailsNo__c = 1;
            qd1.JP_WholeSaleRate__c  = 0.6;
            qd1.JP_UnitPrice__c = 239400;
            qd1.JP_SpecialWholeSaleTRate__c = NULL;
            qd1.JP_DiscountLimitPrice__c = 205884;
            qd1.JP_SalesStatus__c = '1';
            qd1.JP_WholeSalePriceMulQuantity__c = qd1.JP_UnitPrice__c * qd1.JP_WholeSaleRate__c;
            qd1.JP_SpecialUnitPriceMulQuantity__c = 0;
            qd1.JP_StandardMinusSpecial__c = 0;
            qd1.JP_DeterminedAmount__c = 239400;
            qd1.JP_PriceYearMonth__c = 'JP 2015/09';
            qd1.JP_PreSave__c = false;
            qdList.add(qd1);
            
            try{
                insert qdList;
            }catch(DmlException de){
                System.AssertEquals(de.getDmlMessage(0),'No.1：数量へ0は設定できません。');
            }

        }
    }


    //Test7 数量マイナスチェック
    private static testMethod void  testInsert7(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
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
            //見積基本作成
            JP_QuotationHeader__c qh = Create_JP_QuotationHeader('30');
            //見積明細作成
             List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
            JP_QuotationDetail__c qd1 = new JP_QuotationDetail__c();
            qd1.JP_QuotationHeader__c = qh.Id;
            qd1.JP_AppGroupID__c = 'G1';
            qd1.JP_SpecialUnitPrice__c = 0;
            qd1.JP_5PercentDiscount__c = 227430;
            qd1.JP_OverLimitDiscount__c = false;
            qd1.JP_ProductCode__c = '9998';
            qd1.JP_ProductCatalogCode__c = 'test';
            qd1.JP_PreRelease__c = false;
            qd1.JP_ProductName__c = 'テスト商品1';
            qd1.JP_Sort__c = null;
            //-1
            qd1.JP_Quantity__c = -1;
            qd1.JP_DetailsNo__c = 1;
            qd1.JP_WholeSaleRate__c  = 0.6;
            qd1.JP_UnitPrice__c = 239400;
            qd1.JP_SpecialWholeSaleTRate__c = NULL;
            qd1.JP_DiscountLimitPrice__c = 205884;
            qd1.JP_SalesStatus__c = '1';
            qd1.JP_WholeSalePriceMulQuantity__c = qd1.JP_UnitPrice__c * qd1.JP_WholeSaleRate__c;
            qd1.JP_SpecialUnitPriceMulQuantity__c = 0;
            qd1.JP_StandardMinusSpecial__c = 0;
            qd1.JP_DeterminedAmount__c = 239400;
            qd1.JP_PriceYearMonth__c = 'JP 2015/09';
            qd1.JP_PreSave__c = false;
            qdList.add(qd1);
            
            try{
                insert qdList;
            }catch(DmlException de){
                System.AssertEquals(de.getDmlMessage(0),'No.1：数量へ負の値は設定できません。');
            }

        }
    }

    //Test8 仕切率マイナスチェック
    private static testMethod void  testInsert8(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
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
            //見積基本作成
            JP_QuotationHeader__c qh = Create_JP_QuotationHeader('30');
            //見積明細作成
             List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
            JP_QuotationDetail__c qd1 = new JP_QuotationDetail__c();
            qd1.JP_QuotationHeader__c = qh.Id;
            qd1.JP_AppGroupID__c = 'G1';
            qd1.JP_SpecialUnitPrice__c = 0;
            qd1.JP_5PercentDiscount__c = 227430;
            qd1.JP_OverLimitDiscount__c = false;
            qd1.JP_ProductCode__c = '9998';
            qd1.JP_ProductCatalogCode__c = 'test';
            qd1.JP_PreRelease__c = false;
            qd1.JP_ProductName__c = 'テスト商品1';
            qd1.JP_Sort__c = null;
            qd1.JP_Quantity__c = 1;
            qd1.JP_DetailsNo__c = 1;
            //マイナス
            qd1.JP_WholeSaleRate__c  = -0.6;
            qd1.JP_UnitPrice__c = 239400;
            qd1.JP_SpecialWholeSaleTRate__c = NULL;
            qd1.JP_DiscountLimitPrice__c = 205884;
            qd1.JP_SalesStatus__c = '1';
            qd1.JP_WholeSalePriceMulQuantity__c = 100000;
            qd1.JP_SpecialUnitPriceMulQuantity__c = 0;
            qd1.JP_StandardMinusSpecial__c = 0;
            qd1.JP_DeterminedAmount__c = 239400;
            qd1.JP_PriceYearMonth__c = 'JP 2015/09';
            qd1.JP_PreSave__c = false;
            qdList.add(qd1);
            
            try{
                insert qdList;
            }catch(DmlException de){
                System.AssertEquals(de.getDmlMessage(0),'No.1：仕切率に負の値は設定できません。');
            }

        }
    }

    //Test9 単価ブランクチェック
    private static testMethod void  testInsert9(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
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
            //見積基本作成
            JP_QuotationHeader__c qh = Create_JP_QuotationHeader('30');
            //見積明細作成
             List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
            JP_QuotationDetail__c qd1 = new JP_QuotationDetail__c();
            qd1.JP_QuotationHeader__c = qh.Id;
            qd1.JP_AppGroupID__c = 'G1';
            qd1.JP_SpecialUnitPrice__c = 0;
            qd1.JP_5PercentDiscount__c = 227430;
            qd1.JP_OverLimitDiscount__c = false;
            qd1.JP_ProductCode__c = '9998';
            qd1.JP_ProductCatalogCode__c = 'test';
            qd1.JP_PreRelease__c = false;
            qd1.JP_ProductName__c = 'テスト商品1';
            qd1.JP_Sort__c = null;
            qd1.JP_Quantity__c = 1;
            qd1.JP_DetailsNo__c = 1;
            qd1.JP_WholeSaleRate__c  = 0.6;
            //単価
            qd1.JP_UnitPrice__c = null;
            qd1.JP_SpecialWholeSaleTRate__c = NULL;
            qd1.JP_DiscountLimitPrice__c = 205884;
            qd1.JP_SalesStatus__c = '1';
            qd1.JP_WholeSalePriceMulQuantity__c = 0;
            qd1.JP_SpecialUnitPriceMulQuantity__c = 0;
            qd1.JP_StandardMinusSpecial__c = 0;
            qd1.JP_DeterminedAmount__c = 239400;
            qd1.JP_PriceYearMonth__c = 'JP 2015/09';
            qd1.JP_PreSave__c = false;
            qdList.add(qd1);
            
            try{
                insert qdList;
            }catch(DmlException de){
                System.AssertEquals(de.getDmlMessage(0),'No.1：単価へ値を設定してください。');
            }

        }
    }

    //Test10 単価マイナスチェック
    private static testMethod void  testInsert10(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
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
            //見積基本作成
            JP_QuotationHeader__c qh = Create_JP_QuotationHeader('30');
            //見積明細作成
             List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
            JP_QuotationDetail__c qd1 = new JP_QuotationDetail__c();
            qd1.JP_QuotationHeader__c = qh.Id;
            qd1.JP_AppGroupID__c = 'G1';
            qd1.JP_SpecialUnitPrice__c = 0;
            qd1.JP_5PercentDiscount__c = 227430;
            qd1.JP_OverLimitDiscount__c = false;
            qd1.JP_ProductCode__c = '9998';
            qd1.JP_ProductCatalogCode__c = 'test';
            qd1.JP_PreRelease__c = false;
            qd1.JP_ProductName__c = 'テスト商品1';
            qd1.JP_Sort__c = null;
            qd1.JP_Quantity__c = 1;
            qd1.JP_DetailsNo__c = 1;
            qd1.JP_WholeSaleRate__c  = 0.6;
            //単価
            qd1.JP_UnitPrice__c = -10000;
            qd1.JP_SpecialWholeSaleTRate__c = NULL;
            qd1.JP_DiscountLimitPrice__c = 205884;
            qd1.JP_SalesStatus__c = '1';
            qd1.JP_WholeSalePriceMulQuantity__c = 0;
            qd1.JP_SpecialUnitPriceMulQuantity__c = 0;
            qd1.JP_StandardMinusSpecial__c = 0;
            qd1.JP_DeterminedAmount__c = 239400;
            qd1.JP_PriceYearMonth__c = 'JP 2015/09';
            qd1.JP_PreSave__c = false;
            qdList.add(qd1);
            
            try{
                insert qdList;
            }catch(DmlException de){
                System.AssertEquals(de.getDmlMessage(0),'No.1：単価へ負の値は設定できません。');
            }

        }
    }

    //Test11 特別仕切率マイナスチェック
    private static testMethod void  testInsert11(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
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
            //見積基本作成
            JP_QuotationHeader__c qh = Create_JP_QuotationHeader('30');
            //見積明細作成
             List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
            JP_QuotationDetail__c qd1 = new JP_QuotationDetail__c();
            qd1.JP_QuotationHeader__c = qh.Id;
            qd1.JP_AppGroupID__c = 'G1';
            qd1.JP_SpecialUnitPrice__c = 100;
            qd1.JP_5PercentDiscount__c = 227430;
            qd1.JP_OverLimitDiscount__c = false;
            qd1.JP_ProductCode__c = '9998';
            qd1.JP_ProductCatalogCode__c = 'test';
            qd1.JP_PreRelease__c = false;
            qd1.JP_ProductName__c = 'テスト商品1';
            qd1.JP_Sort__c = null;
            qd1.JP_Quantity__c = 1;
            qd1.JP_DetailsNo__c = 1;
            qd1.JP_WholeSaleRate__c  = 0.6;
            qd1.JP_UnitPrice__c = 1000;
            //マイナス
            qd1.JP_SpecialWholeSaleTRate__c = -100;
            qd1.JP_DiscountLimitPrice__c = 205884;
            qd1.JP_SalesStatus__c = '1';
            qd1.JP_WholeSalePriceMulQuantity__c = 0;
            qd1.JP_SpecialUnitPriceMulQuantity__c = 0;
            qd1.JP_StandardMinusSpecial__c = 0;
            qd1.JP_DeterminedAmount__c = 239400;
            qd1.JP_PriceYearMonth__c = 'JP 2015/09';
            qd1.JP_PreSave__c = false;
            qdList.add(qd1);
            
            try{
                insert qdList;
            }catch(DmlException de){
                System.AssertEquals(de.getDmlMessage(0),'No.1：特別仕切率へ負の値は設定できません。');
            }

        }
    }

    /**
    //Test12 特別仕切単価ブランクチェック
    private static testMethod void  testInsert12(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
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
            //見積基本作成
            JP_QuotationHeader__c qh = Create_JP_QuotationHeader('30');
            //見積明細作成
             List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
            JP_QuotationDetail__c qd1 = new JP_QuotationDetail__c();
            qd1.JP_QuotationHeader__c = qh.Id;
            qd1.JP_AppGroupID__c = 'G1';
            //ブランク
            qd1.JP_SpecialUnitPrice__c = null;
            qd1.JP_5PercentDiscount__c = 227430;
            qd1.JP_OverLimitDiscount__c = false;
            qd1.JP_ProductCode__c = '9998';
            qd1.JP_ProductCatalogCode__c = 'test';
            qd1.JP_PreRelease__c = false;
            qd1.JP_ProductName__c = 'テスト商品1';
            qd1.JP_Sort__c = null;
            qd1.JP_Quantity__c = 1;
            qd1.JP_DetailsNo__c = 1;
            qd1.JP_WholeSaleRate__c  = 0.6;
            qd1.JP_UnitPrice__c = 1000;
            qd1.JP_SpecialWholeSaleTRate__c = 100;
            qd1.JP_DiscountLimitPrice__c = 205884;
            qd1.JP_SalesStatus__c = '1';
            qd1.JP_WholeSalePriceMulQuantity__c = 0;
            qd1.JP_SpecialUnitPriceMulQuantity__c = 0;
            qd1.JP_StandardMinusSpecial__c = 0;
            qd1.JP_DeterminedAmount__c = 239400;
            qd1.JP_PriceYearMonth__c = 'JP 2015/09';
            qd1.JP_PreSave__c = false;
            qdList.add(qd1);
            
            try{
                insert qdList;
            }catch(DmlException de){
                System.AssertEquals(de.getDmlMessage(0),'No.1：特別仕切単価へ値を設定してください。');
            }

        }
    }
    */

    //Test13 特別仕切単価0チェック
    private static testMethod void  testInsert13(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
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
            //見積基本作成
            JP_QuotationHeader__c qh = Create_JP_QuotationHeader('30');
            //見積明細作成
             List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
            JP_QuotationDetail__c qd1 = new JP_QuotationDetail__c();
            qd1.JP_QuotationHeader__c = qh.Id;
            qd1.JP_AppGroupID__c = 'G1';
            //ブランク
            qd1.JP_SpecialUnitPrice__c = 0;
            qd1.JP_5PercentDiscount__c = 227430;
            qd1.JP_OverLimitDiscount__c = false;
            qd1.JP_ProductCode__c = '9998';
            qd1.JP_ProductCatalogCode__c = 'test';
            qd1.JP_PreRelease__c = false;
            qd1.JP_ProductName__c = 'テスト商品1';
            qd1.JP_Sort__c = null;
            qd1.JP_Quantity__c = 1;
            qd1.JP_DetailsNo__c = 1;
            qd1.JP_WholeSaleRate__c  = 0.6;
            qd1.JP_UnitPrice__c = 1000;
            qd1.JP_SpecialWholeSaleTRate__c = 100;
            qd1.JP_DiscountLimitPrice__c = 205884;
            qd1.JP_SalesStatus__c = '1';
            qd1.JP_WholeSalePriceMulQuantity__c = 0;
            qd1.JP_SpecialUnitPriceMulQuantity__c = 0;
            qd1.JP_StandardMinusSpecial__c = 0;
            qd1.JP_DeterminedAmount__c = 239400;
            qd1.JP_PriceYearMonth__c = 'JP 2015/09';
            qd1.JP_PreSave__c = false;
            qdList.add(qd1);
            
            try{
                insert qdList;
            }catch(DmlException de){
                System.AssertEquals(de.getDmlMessage(0),'No.1：特別仕切単価へ0は設定できません。');
            }

        }
    }

    //Test14 特別仕切単価マイナスチェック
    private static testMethod void  testInsert14(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
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
            //見積基本作成
            JP_QuotationHeader__c qh = Create_JP_QuotationHeader('30');
            //見積明細作成
             List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
            JP_QuotationDetail__c qd1 = new JP_QuotationDetail__c();
            qd1.JP_QuotationHeader__c = qh.Id;
            qd1.JP_AppGroupID__c = 'G1';
            //マイナス
            qd1.JP_SpecialUnitPrice__c = -100;
            qd1.JP_5PercentDiscount__c = 227430;
            qd1.JP_OverLimitDiscount__c = false;
            qd1.JP_ProductCode__c = '9998';
            qd1.JP_ProductCatalogCode__c = 'test';
            qd1.JP_PreRelease__c = false;
            qd1.JP_ProductName__c = 'テスト商品1';
            qd1.JP_Sort__c = null;
            qd1.JP_Quantity__c = 1;
            qd1.JP_DetailsNo__c = 1;
            qd1.JP_WholeSaleRate__c  = 0.6;
            qd1.JP_UnitPrice__c = 1000;
            qd1.JP_SpecialWholeSaleTRate__c = 100;
            qd1.JP_DiscountLimitPrice__c = 205884;
            qd1.JP_SalesStatus__c = '1';
            qd1.JP_WholeSalePriceMulQuantity__c = 0;
            qd1.JP_SpecialUnitPriceMulQuantity__c = 0;
            qd1.JP_StandardMinusSpecial__c = 0;
            qd1.JP_DeterminedAmount__c = 239400;
            qd1.JP_PriceYearMonth__c = 'JP 2015/09';
            qd1.JP_PreSave__c = false;
            qdList.add(qd1);
            
            try{
                insert qdList;
            }catch(DmlException de){
                System.AssertEquals(de.getDmlMessage(0),'No.1：特別仕切単価へ負の値は設定できません。');
            }

        }
    }

    //Test15 値引限度額マイナスチェック
    private static testMethod void  testInsert15(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
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
            //見積基本作成
            JP_QuotationHeader__c qh = Create_JP_QuotationHeader('30');
            //見積明細作成
             List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
            JP_QuotationDetail__c qd1 = new JP_QuotationDetail__c();
            qd1.JP_QuotationHeader__c = qh.Id;
            qd1.JP_AppGroupID__c = 'G1';
            qd1.JP_SpecialUnitPrice__c = 100;
            qd1.JP_5PercentDiscount__c = 227430;
            qd1.JP_OverLimitDiscount__c = false;
            qd1.JP_ProductCode__c = '9998';
            qd1.JP_ProductCatalogCode__c = 'test';
            qd1.JP_PreRelease__c = false;
            qd1.JP_ProductName__c = 'テスト商品1';
            qd1.JP_Sort__c = null;
            qd1.JP_Quantity__c = 1;
            qd1.JP_DetailsNo__c = 1;
            qd1.JP_WholeSaleRate__c  = 0.6;
            qd1.JP_UnitPrice__c = 1000;
            qd1.JP_SpecialWholeSaleTRate__c = 100;
            //マイナス
            qd1.JP_DiscountLimitPrice__c = -1000;
            qd1.JP_SalesStatus__c = '1';
            qd1.JP_WholeSalePriceMulQuantity__c = 0;
            qd1.JP_SpecialUnitPriceMulQuantity__c = 0;
            qd1.JP_StandardMinusSpecial__c = 0;
            qd1.JP_DeterminedAmount__c = 239400;
            qd1.JP_PriceYearMonth__c = 'JP 2015/09';
            qd1.JP_PreSave__c = false;
            qdList.add(qd1);
            
            try{
                insert qdList;
            }catch(DmlException de){
                System.AssertEquals(de.getDmlMessage(0),'No.1：値引限度額へ負の値は設定できません。');
            }

        }
    }


    //Test16 仕切5%減：マイナスチェック
    private static testMethod void  testInsert16(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
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
            //見積基本作成
            JP_QuotationHeader__c qh = Create_JP_QuotationHeader('30');
            //見積明細作成
             List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
            JP_QuotationDetail__c qd1 = new JP_QuotationDetail__c();
            qd1.JP_QuotationHeader__c = qh.Id;
            qd1.JP_AppGroupID__c = 'G1';
            qd1.JP_SpecialUnitPrice__c = 100;
            //マイナス
            qd1.JP_5PercentDiscount__c = -100;
            qd1.JP_OverLimitDiscount__c = false;
            qd1.JP_ProductCode__c = '9998';
            qd1.JP_ProductCatalogCode__c = 'test';
            qd1.JP_PreRelease__c = false;
            qd1.JP_ProductName__c = 'テスト商品1';
            qd1.JP_Sort__c = null;
            qd1.JP_Quantity__c = 1;
            qd1.JP_DetailsNo__c = 1;
            qd1.JP_WholeSaleRate__c  = 0.6;
            qd1.JP_UnitPrice__c = 1000;
            qd1.JP_SpecialWholeSaleTRate__c = 100;
            qd1.JP_DiscountLimitPrice__c = 1000;
            qd1.JP_SalesStatus__c = '1';
            qd1.JP_WholeSalePriceMulQuantity__c = 0;
            qd1.JP_SpecialUnitPriceMulQuantity__c = 0;
            qd1.JP_StandardMinusSpecial__c = 0;
            qd1.JP_DeterminedAmount__c = 239400;
            qd1.JP_PriceYearMonth__c = 'JP 2015/09';
            qd1.JP_PreSave__c = false;
            qdList.add(qd1);
            
            try{
                insert qdList;
            }catch(DmlException de){
                System.AssertEquals(de.getDmlMessage(0),'No.1：仕切5%減へ負の値は設定できません。');
            }

        }
    }

    //Test17 仕切単価×数量：ブランクチェック
    private static testMethod void  testInsert17(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
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
            //見積基本作成
            JP_QuotationHeader__c qh = Create_JP_QuotationHeader('30');
            //見積明細作成
             List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
            JP_QuotationDetail__c qd1 = new JP_QuotationDetail__c();
            qd1.JP_QuotationHeader__c = qh.Id;
            qd1.JP_AppGroupID__c = 'G1';
            qd1.JP_SpecialUnitPrice__c = 100;
            qd1.JP_5PercentDiscount__c = 100;
            qd1.JP_OverLimitDiscount__c = false;
            qd1.JP_ProductCode__c = '9998';
            qd1.JP_ProductCatalogCode__c = 'test';
            qd1.JP_PreRelease__c = false;
            qd1.JP_ProductName__c = 'テスト商品1';
            qd1.JP_Sort__c = null;
            qd1.JP_Quantity__c = 1;
            qd1.JP_DetailsNo__c = 1;
            qd1.JP_WholeSaleRate__c  = 0.6;
            qd1.JP_UnitPrice__c = 1000;
            qd1.JP_SpecialWholeSaleTRate__c = 100;
            qd1.JP_DiscountLimitPrice__c = 1000;
            qd1.JP_SalesStatus__c = '1';
            //ブランク
            qd1.JP_WholeSalePriceMulQuantity__c = null;
            qd1.JP_SpecialUnitPriceMulQuantity__c = 0;
            qd1.JP_StandardMinusSpecial__c = 0;
            qd1.JP_DeterminedAmount__c = 239400;
            qd1.JP_PriceYearMonth__c = 'JP 2015/09';
            qd1.JP_PreSave__c = false;
            qdList.add(qd1);
            
            try{
                insert qdList;
            }catch(DmlException de){
                System.AssertEquals(de.getDmlMessage(0),'No.1：仕切単価×数量へ値を設定してください。');
            }

        }
    }

    //Test18 仕切単価×数量：マイナスチェック
    private static testMethod void  testInsert18(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
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
            //見積基本作成
            JP_QuotationHeader__c qh = Create_JP_QuotationHeader('30');
            //見積明細作成
             List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
            JP_QuotationDetail__c qd1 = new JP_QuotationDetail__c();
            qd1.JP_QuotationHeader__c = qh.Id;
            qd1.JP_AppGroupID__c = 'G1';
            qd1.JP_SpecialUnitPrice__c = 100;
            qd1.JP_5PercentDiscount__c = 100;
            qd1.JP_OverLimitDiscount__c = false;
            qd1.JP_ProductCode__c = '9998';
            qd1.JP_ProductCatalogCode__c = 'test';
            qd1.JP_PreRelease__c = false;
            qd1.JP_ProductName__c = 'テスト商品1';
            qd1.JP_Sort__c = null;
            qd1.JP_Quantity__c = 1;
            qd1.JP_DetailsNo__c = 1;
            qd1.JP_WholeSaleRate__c  = 0.6;
            qd1.JP_UnitPrice__c = 1000;
            qd1.JP_SpecialWholeSaleTRate__c = 100;
            qd1.JP_DiscountLimitPrice__c = 1000;
            qd1.JP_SalesStatus__c = '1';
            //ブランク
            qd1.JP_WholeSalePriceMulQuantity__c = -100;
            qd1.JP_SpecialUnitPriceMulQuantity__c = 0;
            qd1.JP_StandardMinusSpecial__c = 0;
            qd1.JP_DeterminedAmount__c = 239400;
            qd1.JP_PriceYearMonth__c = 'JP 2015/09';
            qd1.JP_PreSave__c = false;
            qdList.add(qd1);
            
            try{
                insert qdList;
            }catch(DmlException de){
                System.AssertEquals(de.getDmlMessage(0),'No.1：仕切単価×数量へ負の値は設定できません。');
            }

        }
    }

    //Test19 特別仕切単価×数量：ブランクチェック
    private static testMethod void  testInsert19(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
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
            //見積基本作成
            JP_QuotationHeader__c qh = Create_JP_QuotationHeader('30');
            //見積明細作成
             List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
            JP_QuotationDetail__c qd1 = new JP_QuotationDetail__c();
            qd1.JP_QuotationHeader__c = qh.Id;
            qd1.JP_AppGroupID__c = 'G1';
            qd1.JP_SpecialUnitPrice__c = 100;
            qd1.JP_5PercentDiscount__c = 100;
            qd1.JP_OverLimitDiscount__c = false;
            qd1.JP_ProductCode__c = '9998';
            qd1.JP_ProductCatalogCode__c = 'test';
            qd1.JP_PreRelease__c = false;
            qd1.JP_ProductName__c = 'テスト商品1';
            qd1.JP_Sort__c = null;
            qd1.JP_Quantity__c = 1;
            qd1.JP_DetailsNo__c = 1;
            qd1.JP_WholeSaleRate__c  = 0.6;
            qd1.JP_UnitPrice__c = 1000;
            qd1.JP_SpecialWholeSaleTRate__c = 100;
            qd1.JP_DiscountLimitPrice__c = 1000;
            qd1.JP_SalesStatus__c = '1';
            qd1.JP_WholeSalePriceMulQuantity__c = 100;
            //ヌル
            qd1.JP_SpecialUnitPriceMulQuantity__c = null;
            qd1.JP_StandardMinusSpecial__c = 0;
            qd1.JP_DeterminedAmount__c = 239400;
            qd1.JP_PriceYearMonth__c = 'JP 2015/09';
            qd1.JP_PreSave__c = false;
            qdList.add(qd1);
            
            try{
                insert qdList;
            }catch(DmlException de){
                System.AssertEquals(de.getDmlMessage(0),'No.1：特別仕切単価×数量へ値を設定してください。');
            }

        }
    }

    //Test20 特別仕切単価×数量：マイナスチェック
    private static testMethod void  testInsert20(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
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
            //見積基本作成
            JP_QuotationHeader__c qh = Create_JP_QuotationHeader('30');
            //見積明細作成
             List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
            JP_QuotationDetail__c qd1 = new JP_QuotationDetail__c();
            qd1.JP_QuotationHeader__c = qh.Id;
            qd1.JP_AppGroupID__c = 'G1';
            qd1.JP_SpecialUnitPrice__c = 100;
            qd1.JP_5PercentDiscount__c = 100;
            qd1.JP_OverLimitDiscount__c = false;
            qd1.JP_ProductCode__c = '9998';
            qd1.JP_ProductCatalogCode__c = 'test';
            qd1.JP_PreRelease__c = false;
            qd1.JP_ProductName__c = 'テスト商品1';
            qd1.JP_Sort__c = null;
            qd1.JP_Quantity__c = 1;
            qd1.JP_DetailsNo__c = 1;
            qd1.JP_WholeSaleRate__c  = 0.6;
            qd1.JP_UnitPrice__c = 1000;
            qd1.JP_SpecialWholeSaleTRate__c = 100;
            qd1.JP_DiscountLimitPrice__c = 1000;
            qd1.JP_SalesStatus__c = '1';
            qd1.JP_WholeSalePriceMulQuantity__c = 100;
            //マイナス
            qd1.JP_SpecialUnitPriceMulQuantity__c = -10;
            qd1.JP_StandardMinusSpecial__c = 0;
            qd1.JP_DeterminedAmount__c = 239400;
            qd1.JP_PriceYearMonth__c = 'JP 2015/09';
            qd1.JP_PreSave__c = false;
            qdList.add(qd1);
            
            try{
                insert qdList;
            }catch(DmlException de){
                System.AssertEquals(de.getDmlMessage(0),'No.1：特別仕切単価×数量へ負の値は設定できません。');
            }

        }
    }


    //Test21 ：差額(通常-特化) ブランクチェック
    private static testMethod void  testInsert21(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
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
            //見積基本作成
            JP_QuotationHeader__c qh = Create_JP_QuotationHeader('30');
            //見積明細作成
             List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
            JP_QuotationDetail__c qd1 = new JP_QuotationDetail__c();
            qd1.JP_QuotationHeader__c = qh.Id;
            qd1.JP_AppGroupID__c = 'G1';
            qd1.JP_SpecialUnitPrice__c = 100;
            qd1.JP_5PercentDiscount__c = 100;
            qd1.JP_OverLimitDiscount__c = false;
            qd1.JP_ProductCode__c = '9998';
            qd1.JP_ProductCatalogCode__c = 'test';
            qd1.JP_PreRelease__c = false;
            qd1.JP_ProductName__c = 'テスト商品1';
            qd1.JP_Sort__c = null;
            qd1.JP_Quantity__c = 1;
            qd1.JP_DetailsNo__c = 1;
            qd1.JP_WholeSaleRate__c  = 0.6;
            qd1.JP_UnitPrice__c = 1000;
            qd1.JP_SpecialWholeSaleTRate__c = 100;
            qd1.JP_DiscountLimitPrice__c = 1000;
            qd1.JP_SalesStatus__c = '1';
            qd1.JP_WholeSalePriceMulQuantity__c = 100;
            qd1.JP_SpecialUnitPriceMulQuantity__c = 10;
            //ヌル
            qd1.JP_StandardMinusSpecial__c = null;
            qd1.JP_DeterminedAmount__c = 239400;
            qd1.JP_PriceYearMonth__c = 'JP 2015/09';
            qd1.JP_PreSave__c = false;
            qdList.add(qd1);
            
            try{
                insert qdList;
            }catch(DmlException de){
                System.AssertEquals(de.getDmlMessage(0),'No.1：差額(通常-特価)へ値を設定してください。');
            }

        }
    }

    //Test22 ：差額(通常-特化) マイナスチェック
    private static testMethod void  testInsert22(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
            //承認プロセスマスタ作成
            JP_ApprovalProcessMaster__c apm = JP_TestUtil.Create_JP_ApprovalProcessMaster(1);
            JP_DecideApprovalProcess__c dap = new JP_DecideApprovalProcess__c();
            dap.JP_ApprovalProcessMaster__c = apm.Id;
            dap.JP_ChkTotalAmountCD__c = 'A1';
            dap.JP_ChkWholeSaleCD__c = 'B2';
            dap.JP_ChkLimitDiscountCD__c = 'C1';
            dap.JP_ChkRegisteredProductCD__c = 'D1';
            dap.JP_ChkQuotationExpiryDateCD__c = 'E1';
            dap.JP_ChkPreReleaseCD__c = 'F1';
            insert dap;
            //見積基本作成
            JP_QuotationHeader__c qh = Create_JP_QuotationHeader('30');
            //見積明細作成
             List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
            JP_QuotationDetail__c qd1 = new JP_QuotationDetail__c();
            qd1.JP_QuotationHeader__c = qh.Id;
            qd1.JP_AppGroupID__c = 'G1';
            qd1.JP_SpecialUnitPrice__c = 100;
            qd1.JP_5PercentDiscount__c = 100;
            qd1.JP_OverLimitDiscount__c = false;
            qd1.JP_ProductCode__c = '9998';
            qd1.JP_ProductCatalogCode__c = 'test';
            qd1.JP_PreRelease__c = false;
            qd1.JP_ProductName__c = 'テスト商品1';
            qd1.JP_Sort__c = 1;
            qd1.JP_Quantity__c = 1;
            qd1.JP_DetailsNo__c = 1;
            qd1.JP_WholeSaleRate__c  = 0.6;
            qd1.JP_UnitPrice__c = 1000;
            qd1.JP_SpecialWholeSaleTRate__c = 100;
            qd1.JP_DiscountLimitPrice__c = 1000;
            qd1.JP_SalesStatus__c = '1';
            qd1.JP_WholeSalePriceMulQuantity__c = 100;
            qd1.JP_SpecialUnitPriceMulQuantity__c = 10;
            //マイナス
            qd1.JP_StandardMinusSpecial__c = -10;
            qd1.JP_DeterminedAmount__c = 239400;
            qd1.JP_PriceYearMonth__c = 'JP 2015/09';
            qd1.JP_PreSave__c = false;
            qdList.add(qd1);
            
            try{
                insert qdList;
            }catch(DmlException de){
                System.AssertEquals(de.getDmlMessage(0),'No.1：差額(通常-特価)へ負の値は設定できません。');
            }

        }
    }

    //Test23 ：　確定金額 ブランクチェック
    private static testMethod void  testInsert23(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
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
            //見積基本作成
            JP_QuotationHeader__c qh = Create_JP_QuotationHeader('30');
            //見積明細作成
             List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
            JP_QuotationDetail__c qd1 = new JP_QuotationDetail__c();
            qd1.JP_QuotationHeader__c = qh.Id;
            qd1.JP_AppGroupID__c = 'G1';
            qd1.JP_SpecialUnitPrice__c = 100;
            qd1.JP_5PercentDiscount__c = 100;
            qd1.JP_OverLimitDiscount__c = false;
            qd1.JP_ProductCode__c = '9998';
            qd1.JP_ProductCatalogCode__c = 'test';
            qd1.JP_PreRelease__c = false;
            qd1.JP_ProductName__c = 'テスト商品1';
            qd1.JP_Sort__c = null;
            qd1.JP_Quantity__c = 1;
            qd1.JP_DetailsNo__c = 1;
            qd1.JP_WholeSaleRate__c  = 0.6;
            qd1.JP_UnitPrice__c = 1000;
            qd1.JP_SpecialWholeSaleTRate__c = 100;
            qd1.JP_DiscountLimitPrice__c = 1000;
            qd1.JP_SalesStatus__c = '1';
            qd1.JP_WholeSalePriceMulQuantity__c = 100;
            qd1.JP_SpecialUnitPriceMulQuantity__c = 10;
            qd1.JP_StandardMinusSpecial__c = 10;
            //ヌル
            qd1.JP_DeterminedAmount__c = null;
            qd1.JP_PriceYearMonth__c = 'JP 2015/09';
            qd1.JP_PreSave__c = false;
            qdList.add(qd1);
            
            try{
                insert qdList;
            }catch(DmlException de){
                System.AssertEquals(de.getDmlMessage(0),'No.1：確定金額へ値を設定してください。');
            }

        }
    }

    //Test24 ：　確定金額 マイナスチェック
    private static testMethod void  testInsert24(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
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
            //見積基本作成
            JP_QuotationHeader__c qh = Create_JP_QuotationHeader('30');
            //見積明細作成
             List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
            JP_QuotationDetail__c qd1 = new JP_QuotationDetail__c();
            qd1.JP_QuotationHeader__c = qh.Id;
            qd1.JP_AppGroupID__c = 'G1';
            qd1.JP_SpecialUnitPrice__c = 100;
            qd1.JP_5PercentDiscount__c = 100;
            qd1.JP_OverLimitDiscount__c = false;
            qd1.JP_ProductCode__c = '9998';
            qd1.JP_ProductCatalogCode__c = 'test';
            qd1.JP_PreRelease__c = false;
            qd1.JP_ProductName__c = 'テスト商品1';
            qd1.JP_Sort__c = null;
            qd1.JP_Quantity__c = 1;
            qd1.JP_DetailsNo__c = 1;
            qd1.JP_WholeSaleRate__c  = 0.6;
            qd1.JP_UnitPrice__c = 1000;
            qd1.JP_SpecialWholeSaleTRate__c = 100;
            qd1.JP_DiscountLimitPrice__c = 1000;
            qd1.JP_SalesStatus__c = '1';
            qd1.JP_WholeSalePriceMulQuantity__c = 100;
            qd1.JP_SpecialUnitPriceMulQuantity__c = 10;
            qd1.JP_StandardMinusSpecial__c = 10;
            //マイナス
            qd1.JP_DeterminedAmount__c = -10000;
            qd1.JP_PriceYearMonth__c = 'JP 2015/09';
            qd1.JP_PreSave__c = false;
            qdList.add(qd1);
            
            try{
                insert qdList;
            }catch(DmlException de){
                System.AssertEquals(de.getDmlMessage(0),'No.1：確定金額へ負の値は設定できません。');
            }

        }
    }


    //Test25 ：　価格年月 ブランクチェック
    private static testMethod void  testInsert25(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
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
            //見積基本作成
            JP_QuotationHeader__c qh = Create_JP_QuotationHeader('30');
            //見積明細作成
             List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
            JP_QuotationDetail__c qd1 = new JP_QuotationDetail__c();
            qd1.JP_QuotationHeader__c = qh.Id;
            qd1.JP_AppGroupID__c = 'G1';
            qd1.JP_SpecialUnitPrice__c = 100;
            qd1.JP_5PercentDiscount__c = 100;
            qd1.JP_OverLimitDiscount__c = false;
            qd1.JP_ProductCode__c = '9998';
            qd1.JP_ProductCatalogCode__c = 'test';
            qd1.JP_PreRelease__c = false;
            qd1.JP_ProductName__c = 'テスト商品1';
            qd1.JP_Sort__c = null;
            qd1.JP_Quantity__c = 1;
            qd1.JP_DetailsNo__c = 1;
            qd1.JP_WholeSaleRate__c  = 0.6;
            qd1.JP_UnitPrice__c = 1000;
            qd1.JP_SpecialWholeSaleTRate__c = 100;
            qd1.JP_DiscountLimitPrice__c = 1000;
            qd1.JP_SalesStatus__c = '1';
            qd1.JP_WholeSalePriceMulQuantity__c = 100;
            qd1.JP_SpecialUnitPriceMulQuantity__c = 10;
            qd1.JP_StandardMinusSpecial__c = 10;
            qd1.JP_DeterminedAmount__c = 10000;
            //ブランク
            qd1.JP_PriceYearMonth__c = '';
            qd1.JP_PreSave__c = false;
            qdList.add(qd1);
            
            try{
                insert qdList;
            }catch(DmlException de){
                System.AssertEquals(de.getDmlMessage(0),'No.1：価格年月へ値を設定してください。');
            }

        }
    }

    //Test26 ：　承認グループID ブランクチェック
    private static testMethod void  testInsert26(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
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
            //見積基本作成
            JP_QuotationHeader__c qh = Create_JP_QuotationHeader('30');
            //見積明細作成
             List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
            JP_QuotationDetail__c qd1 = new JP_QuotationDetail__c();
            qd1.JP_QuotationHeader__c = qh.Id;
            //ブランク
            qd1.JP_AppGroupID__c = '';
            qd1.JP_SpecialUnitPrice__c = 100;
            qd1.JP_5PercentDiscount__c = 100;
            qd1.JP_OverLimitDiscount__c = false;
            qd1.JP_ProductCode__c = '9998';
            qd1.JP_ProductCatalogCode__c = 'test';
            qd1.JP_PreRelease__c = false;
            qd1.JP_ProductName__c = 'テスト商品1';
            qd1.JP_Sort__c = null;
            qd1.JP_Quantity__c = 1;
            qd1.JP_DetailsNo__c = 1;
            qd1.JP_WholeSaleRate__c  = 0.6;
            qd1.JP_UnitPrice__c = 1000;
            qd1.JP_SpecialWholeSaleTRate__c = 100;
            qd1.JP_DiscountLimitPrice__c = 1000;
            qd1.JP_SalesStatus__c = '1';
            qd1.JP_WholeSalePriceMulQuantity__c = 100;
            qd1.JP_SpecialUnitPriceMulQuantity__c = 10;
            qd1.JP_StandardMinusSpecial__c = 10;
            qd1.JP_DeterminedAmount__c = 10000;
            qd1.JP_PriceYearMonth__c = '';
            qd1.JP_PreSave__c = false;
            qdList.add(qd1);
            
            try{
                insert qdList;
            }catch(DmlException de){
                System.AssertEquals(de.getDmlMessage(0),'No.1：承認グループIDへ値を設定してください。');
            }

        }
    }

    //Test27 削除処理
    private static testMethod void  testInsertDelete(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
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
            //見積基本作成
            JP_QuotationHeader__c qh = Create_JP_QuotationHeader('30');
            //見積明細作成
             List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
            JP_QuotationDetail__c qd1 = new JP_QuotationDetail__c();
            qd1.JP_QuotationHeader__c = qh.Id;
            qd1.JP_AppGroupID__c = 'G1';
            qd1.JP_SpecialUnitPrice__c = 0;
            qd1.JP_5PercentDiscount__c = 227430;
            qd1.JP_OverLimitDiscount__c = false;
            qd1.JP_ProductCode__c = '9998';
            qd1.JP_ProductCatalogCode__c = '1111';
            qd1.JP_PreRelease__c = false;
            qd1.JP_ProductName__c = 'テスト商品1';
            qd1.JP_Sort__c = 1;
            qd1.JP_Quantity__c = 1;
            qd1.JP_DetailsNo__c = 1;
            qd1.JP_WholeSaleRate__c  = 0.6;
            qd1.JP_UnitPrice__c = 239400;
            qd1.JP_SpecialWholeSaleTRate__c = NULL;
            qd1.JP_DiscountLimitPrice__c = 205884;
            qd1.JP_SalesStatus__c = '1';
            qd1.JP_WholeSalePriceMulQuantity__c = qd1.JP_UnitPrice__c * qd1.JP_WholeSaleRate__c;
            qd1.JP_SpecialUnitPriceMulQuantity__c = 0;
            qd1.JP_StandardMinusSpecial__c = 0;
            qd1.JP_DeterminedAmount__c = 239400;
            qd1.JP_PriceYearMonth__c = 'JP 2015/09';
            qd1.JP_PreSave__c = false;
            qdList.add(qd1);

            insert qdList;
            
            try{
                delete qdList;
            }catch(Exception e){
            }
        }
    }

    //Test28 親更新処理
    private static testMethod void  testInsertException(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
            //承認プロセスマスタ作成
            JP_ApprovalProcessMaster__c apm = JP_TestUtil.Create_JP_ApprovalProcessMaster(1);
            JP_DecideApprovalProcess__c dap = new JP_DecideApprovalProcess__c();
            dap.JP_ApprovalProcessMaster__c = apm.Id;
            dap.JP_ChkTotalAmountCD__c = 'A1';
            dap.JP_ChkWholeSaleCD__c = 'B3';
            dap.JP_ChkLimitDiscountCD__c = 'C2';
            dap.JP_ChkRegisteredProductCD__c = 'D1';
            dap.JP_ChkQuotationExpiryDateCD__c = 'E1';
            dap.JP_ChkPreReleaseCD__c = 'F1';
            insert dap;
            //見積基本作成
            JP_QuotationHeader__c qh = Create_JP_QuotationHeader('30');
            //見積明細作成
             List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
            JP_QuotationDetail__c qd1 = new JP_QuotationDetail__c();
            qd1.JP_QuotationHeader__c = qh.Id;
            qd1.JP_AppGroupID__c = 'G1';
            qd1.JP_SpecialUnitPrice__c = 0;
            qd1.JP_5PercentDiscount__c = 227430;
            qd1.JP_OverLimitDiscount__c = false;
            qd1.JP_ProductCode__c = '9998';
            qd1.JP_ProductCatalogCode__c = '1111';
            qd1.JP_PreRelease__c = false;
            qd1.JP_ProductName__c = 'テスト商品1';
            qd1.JP_Sort__c = 1;
            qd1.JP_Quantity__c = 1;
            qd1.JP_DetailsNo__c = 1;
            qd1.JP_WholeSaleRate__c  = 0.5;
            qd1.JP_UnitPrice__c = 239400;
            qd1.JP_SpecialWholeSaleTRate__c = NULL;
            qd1.JP_DiscountLimitPrice__c = 205884;
            qd1.JP_SalesStatus__c = '1';
            qd1.JP_WholeSalePriceMulQuantity__c = 239400;
            qd1.JP_SpecialUnitPriceMulQuantity__c = 199500;
            qd1.JP_StandardMinusSpecial__c = 39900;
            qd1.JP_DeterminedAmount__c = 199500;
            qd1.JP_PriceYearMonth__c = 'JP 2015/09';
            qd1.JP_PreSave__c = false;
            qdList.add(qd1);
            
            try{
                insert qdList;
            }catch(Exception e){
            }
        }
    }

    /* 見積基本作成
    * @param Integer quantity   ：登録するレコード数
    * @return void
    */
    private static JP_QuotationHeader__c Create_JP_QuotationHeader(String yukoDays){
            List<JP_QuotationDistributor__c> distributorList = JP_TestUtil.Create_JP_QuotationDistributor();
            JP_QuotationHeader__c qh = new JP_QuotationHeader__c();
            qh.JP_QuotationStatus__c = JP_Const.QUOTATION_STATUS_UNAPPROVE;
            qh.JP_PreSave__c = false;
            qh.JP_TriggerSkipFLG__c = true;
            qh.JP_QuotationEffectiveTerm__c = yukoDays;
            qh.JP_TotalAmount__c = 30000;
            qh.JP_QuotationDistCD__c = distributorList[0].Id;
            
            insert qh;

        return qh;
    }


}