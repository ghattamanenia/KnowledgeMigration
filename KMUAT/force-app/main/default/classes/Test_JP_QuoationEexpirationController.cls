@isTest
private class Test_JP_QuoationEexpirationController {
    private static User user;
    private final static String SYSTEM_ADMIN = system.label.System_Administrator_ProfileName;

    // 見積有効期限未入力
    private static testMethod void CheckSaveTest1() {
        // テストデータ作成
        createData();
        List<JP_QuotationDistributor__c> qd = JP_TestUtil.Create_JP_QuotationDistributor();
        List<JP_QuotationHeader__c> qhlist = JP_TestUtil.Create_JP_QuotationHeader(1);
        qhlist[0].JP_QuotationDistCD__c = qd[0].Id;
        qhlist[0].JP_QuotationStatus__c = JP_Const.QUOTATION_STATUS_UNAPPROVE;
        qhlist[0].JP_TotalAmount__c = 10000;
        qhlist[0].JP_AllowMixOfPriceYearMonth__c = false;
        qhlist[0].JP_TriggerSkipFLG__c = true;
        qhlist[0].JP_PreSave__c = true;
        insert qhlist;
        
        JP_SpecailPriceApprove__c spa = JP_TestUtil.Create_JP_SpecailPriceApprove(qhlist[0]);
        spa.JP_ProductClassification__c = 'JP_ATKK_Product';
        insert spa;

        system.runAs(user){
            JP_QuoationChangesEexpirationDate__c rec = new JP_QuoationChangesEexpirationDate__c();

            PageReference pref = Page.JP_QuotationChangesExpiration;
            System.Test.setCurrentPage(pref);
            
            ApexPages.currentPage().getParameters().put('qId',qhlist[0].id);
            ApexPages.currentPage().getParameters().put('retURL','/' + qhlist[0].id);

            System.Test.startTest();
            
            Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
            JP_QuoationChangesEexpirationController jph = new JP_QuoationChangesEexpirationController(sc);
            jph.record.JP_QuotationExpireDate__c = null;
            
            jph.CheckSave();
            jph.doSave();

            System.Test.stopTest();
        }
    }
    
    private static testMethod void CheckSaveTest2() {
        // テストデータ作成
        createData();
        List<JP_QuotationDistributor__c> qd = JP_TestUtil.Create_JP_QuotationDistributor();
        List<JP_QuotationHeader__c> qhlist = JP_TestUtil.Create_JP_QuotationHeader(1);
        qhlist[0].JP_QuotationDistCD__c = qd[0].Id;
        qhlist[0].JP_QuotationStatus__c = JP_Const.QUOTATION_STATUS_UNAPPROVE;
        qhlist[0].JP_TotalAmount__c = 10000;
        qhlist[0].JP_AllowMixOfPriceYearMonth__c = false;
        qhlist[0].JP_TriggerSkipFLG__c = true;
        qhlist[0].JP_PreSave__c = true;
        qhlist[0].JP_QuotationExpireDate__c = String.valueOf(system.today());
        insert qhlist;
        
        JP_SpecailPriceApprove__c spa = JP_TestUtil.Create_JP_SpecailPriceApprove(qhlist[0]);
        spa.JP_ProductClassification__c = 'JP_ATKK_Product';
        insert spa;
        
        List<JP_QuotationDetail__c> qdList = JP_TestUtil.Create_JP_QuotationDetail(qhlist[0].Id,1);
        qdList[0] = createQDetail(qdList[0]);
        qdList[0].JP_AppGroupID__c = 'G3';
        insert qdList;
        

        system.runAs(user){
            JP_QuoationChangesEexpirationDate__c rec = new JP_QuoationChangesEexpirationDate__c();

            PageReference pref = Page.JP_QuotationChangesExpiration;
            System.Test.setCurrentPage(pref);
            
            ApexPages.currentPage().getParameters().put('qId',qhlist[0].id);
            ApexPages.currentPage().getParameters().put('retURL','/' + qhlist[0].id);

            System.Test.startTest();
            
            Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
            JP_QuoationChangesEexpirationController jph = new JP_QuoationChangesEexpirationController(sc);
            jph.record.JP_QuotationExpireDate__c = system.today();
            
            jph.CheckSave();

            System.Test.stopTest();
        }
    }
    
        private static testMethod void CheckSaveTest3() {
        // テストデータ作成
        createData();
        List<JP_QuotationDistributor__c> qd = JP_TestUtil.Create_JP_QuotationDistributor();
        List<JP_QuotationHeader__c> qhlist = JP_TestUtil.Create_JP_QuotationHeader(1);
        qhlist[0].JP_QuotationDistCD__c = qd[0].Id;
        qhlist[0].JP_QuotationStatus__c = JP_Const.QUOTATION_STATUS_UNAPPROVE;
        qhlist[0].JP_TotalAmount__c = 10000;
        qhlist[0].JP_AllowMixOfPriceYearMonth__c = false;
        qhlist[0].JP_TriggerSkipFLG__c = true;
        qhlist[0].JP_PreSave__c = true;
        qhlist[0].JP_QuotationExpireDate__c = String.valueOf(system.today());
        insert qhlist;
        
        JP_SpecailPriceApprove__c spa = JP_TestUtil.Create_JP_SpecailPriceApprove(qhlist[0]);
        spa.JP_ProductClassification__c = 'JP_ATKK_Product';
        insert spa;
        
        List<JP_QuotationDetail__c> qdList = JP_TestUtil.Create_JP_QuotationDetail(qhlist[0].Id,1);
        qdList[0] = createQDetail(qdList[0]);
        qdList[0].JP_AppGroupID__c = 'G1';
        insert qdList;
        

        system.runAs(user){
            JP_QuoationChangesEexpirationDate__c rec = new JP_QuoationChangesEexpirationDate__c();

            PageReference pref = Page.JP_QuotationChangesExpiration;
            System.Test.setCurrentPage(pref);
            
            ApexPages.currentPage().getParameters().put('qId',qhlist[0].id);
            ApexPages.currentPage().getParameters().put('retURL','/' + qhlist[0].id);

            System.Test.startTest();
            
            Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
            JP_QuoationChangesEexpirationController jph = new JP_QuoationChangesEexpirationController(sc);
            jph.record.JP_QuotationExpireDate__c = system.today();
            
            jph.CheckSave();

            System.Test.stopTest();
        }
    }
    
    private static testMethod void CheckSaveTest4() {
        // テストデータ作成
        createData();
        List<JP_QuotationDistributor__c> qd = JP_TestUtil.Create_JP_QuotationDistributor();
        List<JP_QuotationHeader__c> qhlist = JP_TestUtil.Create_JP_QuotationHeader(1);
        qhlist[0].JP_QuotationDistCD__c = qd[0].Id;
        qhlist[0].JP_QuotationStatus__c = JP_Const.QUOTATION_STATUS_UNAPPROVE;
        qhlist[0].JP_TotalAmount__c = 10000;
        qhlist[0].JP_AllowMixOfPriceYearMonth__c = false;
        qhlist[0].JP_TriggerSkipFLG__c = true;
        qhlist[0].JP_PreSave__c = true;
        qhlist[0].JP_QuotationExpireDate__c = String.valueOf(system.today());
        insert qhlist;
        
        JP_SpecailPriceApprove__c spa = JP_TestUtil.Create_JP_SpecailPriceApprove(qhlist[0]);
        spa.JP_ProductClassification__c = 'TEST';
        insert spa;
        
        List<JP_QuotationDetail__c> qdList = JP_TestUtil.Create_JP_QuotationDetail(qhlist[0].Id,1);
        qdList[0] = createQDetail(qdList[0]);
        qdList[0].JP_AppGroupID__c = 'G1';
        insert qdList;
        

        system.runAs(user){
            JP_QuoationChangesEexpirationDate__c rec = new JP_QuoationChangesEexpirationDate__c();

            PageReference pref = Page.JP_QuotationChangesExpiration;
            System.Test.setCurrentPage(pref);
            
            ApexPages.currentPage().getParameters().put('qId',qhlist[0].id);
            ApexPages.currentPage().getParameters().put('retURL','/' + qhlist[0].id);

            System.Test.startTest();
            
            Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
            JP_QuoationChangesEexpirationController jph = new JP_QuoationChangesEexpirationController(sc);
            jph.record.JP_QuotationExpireDate__c = system.today();
            
            jph.CheckSave();

            System.Test.stopTest();
        }
    }
    
    private static testMethod void CheckSaveTest5() {
        // テストデータ作成
        createData();
        List<JP_QuotationDistributor__c> qd = JP_TestUtil.Create_JP_QuotationDistributor();
        List<JP_QuotationHeader__c> qhlist = JP_TestUtil.Create_JP_QuotationHeader(1);
        qhlist[0].JP_QuotationDistCD__c = qd[0].Id;
        qhlist[0].JP_QuotationStatus__c = JP_Const.QUOTATION_STATUS_UNAPPROVE;
        qhlist[0].JP_TotalAmount__c = 10000;
        qhlist[0].JP_AllowMixOfPriceYearMonth__c = false;
        qhlist[0].JP_TriggerSkipFLG__c = true;
        qhlist[0].JP_PreSave__c = true;
        qhlist[0].JP_QuotationExpireDate__c = String.valueOf(system.today());
        insert qhlist;
        
        JP_SpecailPriceApprove__c spa = JP_TestUtil.Create_JP_SpecailPriceApprove(qhlist[0]);
        spa.JP_ProductClassification__c = 'JP_ATKK_Product';
        spa.JP_SpecailPriceEndDate__c = Date.newInstance(system.today().year(), system.today().month(),system.today().day()-1);
        insert spa;
        
        List<JP_QuotationDetail__c> qdList = JP_TestUtil.Create_JP_QuotationDetail(qhlist[0].Id,1);
        qdList[0] = createQDetail(qdList[0]);
        qdList[0].JP_AppGroupID__c = 'G1';
        insert qdList;
        

        system.runAs(user){
            JP_QuoationChangesEexpirationDate__c rec = new JP_QuoationChangesEexpirationDate__c();

            PageReference pref = Page.JP_QuotationChangesExpiration;
            System.Test.setCurrentPage(pref);
            
            ApexPages.currentPage().getParameters().put('qId',qhlist[0].id);
            ApexPages.currentPage().getParameters().put('retURL','/' + qhlist[0].id);

            System.Test.startTest();
            
            Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
            JP_QuoationChangesEexpirationController jph = new JP_QuoationChangesEexpirationController(sc);
            jph.record.JP_QuotationExpireDate__c = system.today();
            
            jph.CheckSave();

            System.Test.stopTest();
        }
    }
    
    private static testMethod void CheckSaveTest6() {
        // テストデータ作成
        String priceYM = 'JP ' + String.valueOf(system.today().year()) + '/' + String.valueOf(system.today().month());
        createData();
        List<JP_QuotationDistributor__c> qd = JP_TestUtil.Create_JP_QuotationDistributor();
        
        List<JP_QuotationHeader__c> qhlist = JP_TestUtil.Create_JP_QuotationHeader(1);
        qhlist[0].JP_QuotationDistCD__c = qd[0].Id;
        qhlist[0].JP_QuotationStatus__c = JP_Const.QUOTATION_STATUS_UNAPPROVE;
        qhlist[0].JP_TotalAmount__c = 10000;
        qhlist[0].JP_AllowMixOfPriceYearMonth__c = false;
        qhlist[0].JP_TriggerSkipFLG__c = true;
        qhlist[0].JP_PreSave__c = true;
        qhlist[0].JP_QuotationExpireDate__c = String.valueOf(system.today());
        insert qhlist;

        JP_SpecailPriceApprove__c spa = JP_TestUtil.Create_JP_SpecailPriceApprove(qhlist[0]);
        spa.JP_ProductClassification__c = 'JP_ATKK_Product';
        spa.JP_SpecailPriceEndDate__c = Date.newInstance(system.today().year(), system.today().month()+2,1);
        insert spa;
        
        List<JP_QuotationDetail__c> qdList = JP_TestUtil.Create_JP_QuotationDetail(qhlist[0].Id,1);
        qdList[0] = createQDetail(qdList[0]);
        qdList[0].JP_AppGroupID__c = 'G1';
        insert qdList;
        
        List<JP_DistributorPrice__c> dpList = new List<JP_DistributorPrice__c>();
        dpList = JP_TestUtil.Create_JP_DistributorPrice(1);
        dpList[0].JP_WholeSalePrice__c = 1000;
        dpList[0].JP_OutputableQuotation__c = true;
        dpList[0].JP_WholeSaleKey__c = '09_' + qdList[0].JP_ProductCatalogCode__c + '_' + priceYM;
        insert dpList;
        

        system.runAs(user){
            JP_QuoationChangesEexpirationDate__c rec = new JP_QuoationChangesEexpirationDate__c();

            PageReference pref = Page.JP_QuotationChangesExpiration;
            System.Test.setCurrentPage(pref);
            
            ApexPages.currentPage().getParameters().put('qId',qhlist[0].id);
            ApexPages.currentPage().getParameters().put('retURL','/' + qhlist[0].id);

            System.Test.startTest();
            
            Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
            JP_QuoationChangesEexpirationController jph = new JP_QuoationChangesEexpirationController(sc);
            jph.record.JP_QuotationExpireDate__c = system.today();
            
            jph.CheckSave();

            System.Test.stopTest();
        }
    }
    
        private static testMethod void CheckSaveTest7() {
        // テストデータ作成
        String priceYM = 'JP ' + String.valueOf(system.today().year()) + '/' + String.valueOf(system.today().month());
        createData();
        List<JP_QuotationDistributor__c> qd = JP_TestUtil.Create_JP_QuotationDistributor();
        
        List<JP_QuotationHeader__c> qhlist = JP_TestUtil.Create_JP_QuotationHeader(1);
        qhlist[0].JP_QuotationDistCD__c = qd[0].Id;
        qhlist[0].JP_QuotationStatus__c = JP_Const.QUOTATION_STATUS_UNAPPROVE;
        qhlist[0].JP_TotalAmount__c = 10000;
        qhlist[0].JP_AllowMixOfPriceYearMonth__c = false;
        qhlist[0].JP_TriggerSkipFLG__c = true;
        qhlist[0].JP_PreSave__c = true;
        qhlist[0].JP_QuotationExpireDate__c = null;
        insert qhlist;

        JP_SpecailPriceApprove__c spa = JP_TestUtil.Create_JP_SpecailPriceApprove(qhlist[0]);
        spa.JP_ProductClassification__c = 'JP_ATKK_Product';
        spa.JP_SpecailPriceEndDate__c = Date.newInstance(system.today().year(), system.today().month()+2,1);
        insert spa;
        
        List<JP_QuotationDetail__c> qdList = JP_TestUtil.Create_JP_QuotationDetail(qhlist[0].Id,1);
        qdList[0] = createQDetail(qdList[0]);
        qdList[0].JP_AppGroupID__c = 'G1';
        insert qdList;
        
        List<JP_DistributorPrice__c> dpList = new List<JP_DistributorPrice__c>();
        dpList = JP_TestUtil.Create_JP_DistributorPrice(1);
        dpList[0].JP_WholeSalePrice__c = 1000;
        dpList[0].JP_OutputableQuotation__c = true;
        dpList[0].JP_WholeSaleKey__c = '09_' + qdList[0].JP_ProductCatalogCode__c + '_' + priceYM;
        insert dpList;
        

        system.runAs(user){
            JP_QuoationChangesEexpirationDate__c rec = new JP_QuoationChangesEexpirationDate__c();

            PageReference pref = Page.JP_QuotationChangesExpiration;
            System.Test.setCurrentPage(pref);
            
            ApexPages.currentPage().getParameters().put('qId',qhlist[0].id);
            ApexPages.currentPage().getParameters().put('retURL','/' + qhlist[0].id);

            System.Test.startTest();
            
            Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
            JP_QuoationChangesEexpirationController jph = new JP_QuoationChangesEexpirationController(sc);
            jph.record.JP_QuotationExpireDate__c = system.today();
            
            jph.CheckSave();

            System.Test.stopTest();
        }
    }
    
    private static testMethod void RecSaveTest() {
        // テストデータ作成
        String priceYM = 'JP ' + String.valueOf(system.today().year()) + '/' + String.valueOf(system.today().month());
        createData();
        List<JP_QuotationDistributor__c> qd = JP_TestUtil.Create_JP_QuotationDistributor();
        
        List<JP_QuotationHeader__c> qhlist = JP_TestUtil.Create_JP_QuotationHeader(1);
        qhlist[0].JP_QuotationDistCD__c = qd[0].Id;
        qhlist[0].JP_QuotationStatus__c = JP_Const.QUOTATION_STATUS_UNAPPROVE;
        qhlist[0].JP_TotalAmount__c = 10000;
        qhlist[0].JP_AllowMixOfPriceYearMonth__c = false;
        qhlist[0].JP_TriggerSkipFLG__c = true;
        qhlist[0].JP_PreSave__c = true;
        qhlist[0].JP_QuotationExpireDate__c = String.valueOf(system.today());
        insert qhlist;

        JP_SpecailPriceApprove__c spa = JP_TestUtil.Create_JP_SpecailPriceApprove(qhlist[0]);
        spa.JP_ProductClassification__c = 'JP_ATKK_Product';
        spa.JP_SpecailPriceEndDate__c = Date.newInstance(system.today().year(), system.today().month()+2,1);
        insert spa;
        
        List<JP_QuotationDetail__c> qdList = JP_TestUtil.Create_JP_QuotationDetail(qhlist[0].Id,1);
        qdList[0] = createQDetail(qdList[0]);
        qdList[0].JP_AppGroupID__c = 'G1';
        insert qdList;
        
        List<JP_DistributorPrice__c> dpList = new List<JP_DistributorPrice__c>();
        dpList = JP_TestUtil.Create_JP_DistributorPrice(1);
        dpList[0].JP_WholeSalePrice__c = 1500;
        dpList[0].JP_OutputableQuotation__c = true;
        dpList[0].JP_WholeSaleKey__c = '09_' + qdList[0].JP_ProductCatalogCode__c + '_' + priceYM;
        insert dpList;
        
        JP_QuotationHeader__c qh = JP_QuotationHeaderDAO.getRecById(qhlist[0].Id);
        JP_QuoationChangesEexpirationDate__c qced = new JP_QuoationChangesEexpirationDate__c();
        qced.JP_QuotationHeader__c = qh.Id;
        qced.Name = qh.JP_QuotationNo__c + 'A';
        insert qced;
        

        system.runAs(user){
            JP_QuoationChangesEexpirationDate__c rec = new JP_QuoationChangesEexpirationDate__c();

            PageReference pref = Page.JP_QuotationChangesExpiration;
            System.Test.setCurrentPage(pref);
            
            ApexPages.currentPage().getParameters().put('qId',qh.id);
            ApexPages.currentPage().getParameters().put('retURL','/' + qhlist[0].id);

            System.Test.startTest();
            
            Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
            JP_QuoationChangesEexpirationController jph = new JP_QuoationChangesEexpirationController(sc);
            jph.record.JP_QuotationExpireDate__c = system.today();
            
            jph.CheckSave();
            jph.doSave();

            System.Test.stopTest();
        }
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
    
    public static JP_QuotationDetail__c createQDetail(JP_QuotationDetail__c qd){
        qd.JP_StandardPrice__c = 10000;
        qd.JP_ProductCatalogCode__c = 'testcode';
        qd.JP_ProductName__c = 'testProduct';
        qd.JP_Sort__c = 1;
        qd.JP_Quantity__c = 1;
        qd.JP_SpecialUnitPrice__c = 1000000;
        qd.JP_WholeSalePriceMulQuantity__c = 1000;
        qd.JP_SpecialUnitPriceMulQuantity__c = 1000;
        qd.JP_StandardMinusSpecial__c = 1000;
        qd.JP_DeterminedAmount__c = 1000;
        qd.JP_PriceYearMonth__c = 'JP 2017/08';
        qd.JP_5PercentDiscount__c = 1200;
        qd.JP_OverLimitDiscount__c = false;
        qd.JP_ProductCode__c = '9999';
        qd.JP_PreRelease__c = false;
        qd.JP_WholeSaleRate__c = 1;
        qd.JP_UnitPrice__c = 1500;
        qd.JP_SpecialWholeSaleTRate__c = 0.8;
        qd.JP_DiscountLimitPrice__c = 8000000;
        qd.JP_WholeSalePriceMulQuantity__c = qd.JP_UnitPrice__c * qd.JP_WholeSaleRate__c;
        qd.JP_SpecialUnitPriceMulQuantity__c = qd.JP_SpecialUnitPrice__c * qd.JP_Quantity__c;
        qd.JP_StandardMinusSpecial__c = qd.JP_WholeSalePriceMulQuantity__c - qd.JP_SpecialUnitPriceMulQuantity__c;
        qd.JP_DeterminedAmount__c = qd.JP_SpecialUnitPriceMulQuantity__c;
        
        return qd;
    }
}