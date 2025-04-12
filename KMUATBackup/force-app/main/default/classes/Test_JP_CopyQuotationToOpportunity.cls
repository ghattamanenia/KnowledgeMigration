@isTest
private class Test_JP_CopyQuotationToOpportunity {
    static List<JP_QuotationDistributor__c> distibutors = JP_TestUtil.Create_JP_QuotationDistributor();
    static List<JP_QuotationContact__c> qcList = [Select Id,Name From JP_QuotationContact__c Where JP_QuotationDistributor__c=:distibutors[0].id Order by Name];
    
    static testMethod void testCopyQtoO1() {
   //Channelinsight.CI_TEST_TestUtils.createBaseInstallData();  Neha commented for model n package uninstallation
        PageReference resultpage;
        Opportunity opp = JP_TestUtil.Create_Opportunity();
        
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();

        /**
         *価格表を登録
         */
        Pricebook2 pb2 = new Pricebook2();
        pb2.Name = getCurrentYearMonth();
        pb2.IsActive = true;
        insert pb2;
        
        /**
         *価格表エントリを登録
         */
        Product2 pdt2 = new Product2();
        pdt2.Name = 'その他商品';
        insert pdt2;
        
        PriceBookEntry pbe = new PriceBookEntry();
        pbe.Pricebook2Id = Test.getStandardPricebookId();
        pbe.Product2Id = pdt2.Id;
        pbe.UnitPrice = 100.00;
        pbe.IsActive = true;
        insert pbe;
        
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
        }
        
        insert qhList;
        
        for(JP_QuotationHeader__c qh : qhList){
            qdList = JP_TestUtil.Create_JP_QuotationDetail(qh.Id,1);
            for(JP_QuotationDetail__c qd : qdList){
                setQuotationDetailDefault(qd, pbe, true);
            }
        }
        insert qdList;
        
        PageReference pref = Page.JP_CopyQuotationToOpportunity;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        Apexpages.Standardcontroller sc;
        JP_CopyQuotationToOpportunityController jph;

        JP_QuotationHeader__c rec = qhList[0];

        Test.startTest();

        sc = new Apexpages.Standardcontroller(rec);
        jph = new JP_CopyQuotationToOpportunityController(sc);
        jph.QHeader.JP_OpportunityNo__c = opp.Id;

        resultpage = jph.doCopy();
        
        Test.stopTest();
        
        System.assertEquals('/' + opp.Id, resultpage.getUrl());
    }
    
    
    /**
     *見積明細の価格表エントリIDから価格表を取得できなく、当月の価格表を取得できる場合
     */
    static testMethod void testCopyQtoO2() {
   // Channelinsight.CI_TEST_TestUtils.createBaseInstallData();Neha commented for model n package uninstallation
        PageReference resultpage;
        Opportunity opp = JP_TestUtil.Create_Opportunity();
        
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
        
        /**
         *価格表を登録
         */
        Pricebook2 pb2 = new Pricebook2();
        pb2.Name = getCurrentYearMonth();
        pb2.isActive = true;
        pb2.Description = 'A';
        insert pb2;
        
        /**
         *価格表エントリを登録
         */
        Product2 pdt22 = new Product2();
        pdt22.Name = 'その他商品';
        insert pdt22;
        
        PriceBookEntry pbe1 = new PriceBookEntry();
        pbe1.Pricebook2Id = Test.getStandardPricebookId();
        pbe1.Product2Id = pdt22.Id;
        pbe1.UnitPrice = 100;
        pbe1.IsActive = true;
        pbe1.UseStandardPrice = false;
        insert pbe1;
        
        PriceBookEntry pbe2 = new PriceBookEntry();
        pbe2.Pricebook2Id = pb2.Id;
        pbe2.Product2Id = pdt22.Id;
        pbe2.UnitPrice = 100;
        pbe2.IsActive = true;
        pbe2.UseStandardPrice = false;
        insert pbe2;
        
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
        }
        
        insert qhList;
        
        for(JP_QuotationHeader__c qh : qhList){
            qdList = JP_TestUtil.Create_JP_QuotationDetail(qh.Id,1);
            for(JP_QuotationDetail__c qd : qdList){
                setQuotationDetailDefault(qd, pbe1, false);
            }
        }
        insert qdList;
        
        PageReference pref = Page.JP_CopyQuotationToOpportunity;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        Apexpages.Standardcontroller sc;
        JP_CopyQuotationToOpportunityController jph;

        JP_QuotationHeader__c rec = qhList[0];

        Test.startTest();

        sc = new Apexpages.Standardcontroller(rec);
        jph = new JP_CopyQuotationToOpportunityController(sc);
        jph.QHeader.JP_OpportunityNo__c = opp.Id;

        resultpage = jph.doCopy();
        
        Test.stopTest();
        
        Opportunity oppAfterUpdate = OpportunityDAO.getRecById(jph.QHeader.JP_OpportunityNo__c);
        // System.assertEquals(pb2.Id, oppAfterUpdate.PriceBook2Id);
    }
    
    
    /**
     *見積明細に価格表が混在している場合
     */
    static testMethod void testCopyQtoO3() {
    //Channelinsight.CI_TEST_TestUtils.createBaseInstallData();Neha commented for model n package uninstallation
        PageReference resultpage;
        Opportunity opp = JP_TestUtil.Create_Opportunity();
        opp.Pricebook2Id = Test.getStandardPricebookId();
        update opp;
        
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
        
        /**
         *価格表を登録
         */
        Pricebook2 pb2 = new Pricebook2();
        pb2.Name = getCurrentYearMonth();
        pb2.isActive = true;
        insert pb2;
        
        /**
         *価格表エントリを登録
         */
        Product2 pdt22 = new Product2();
        pdt22.Name = 'その他商品';
        insert pdt22;
        
        List<PriceBookEntry> pbes = new List<PriceBookEntry>();
        
        PriceBookEntry pbe1 = new PriceBookEntry();
        pbe1.Pricebook2Id = Test.getStandardPricebookId();
        pbe1.Product2Id = pdt22.Id;
        pbe1.UnitPrice = 100;
        pbe1.IsActive = true;
        pbe1.UseStandardPrice = false;
        pbes.add(pbe1);
        
        PriceBookEntry pbe2 = new PriceBookEntry();
        pbe2.Pricebook2Id = pb2.Id;
        pbe2.Product2Id = pdt22.Id;
        pbe2.UnitPrice = 100;
        pbe2.IsActive = true;
        pbe2.UseStandardPrice = false;
        pbes.add(pbe2);
        
        insert pbes;
        
        
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
        }
        
        insert qhList;
        
        for(JP_QuotationHeader__c qh : qhList){
            qdList = JP_TestUtil.Create_JP_QuotationDetail(qh.Id,2);
            setQuotationDetailDefault(qdList[0], pbe1, true);
            setQuotationDetailDefault(qdList[1], pbe2, true);
        }
        insert qdList;
        
        PageReference pref = Page.JP_CopyQuotationToOpportunity;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        Apexpages.Standardcontroller sc;
        JP_CopyQuotationToOpportunityController jph;

        JP_QuotationHeader__c rec = qhList[0];

        Test.startTest();

        sc = new Apexpages.Standardcontroller(rec);
        jph = new JP_CopyQuotationToOpportunityController(sc);
        jph.QHeader.JP_OpportunityNo__c = opp.Id;

        resultpage = jph.doCopy();
        
        Test.stopTest();
        
        String errMsgs = '';
        for(ApexPages.Message message : ApexPages.getMessages()) {
            errMsgs += message.getSummary();
        }
        System.assertEquals(true, errMsgs.contains(JP_Const.ERR_MESSAGE_COPY_OPPORTUNITY));
    }
    
    
    /**
     *価格表に商品が存在しなかった場合、その他商品が存在する場合
     */
    static testMethod void testCopyQtoO4() {
    //Channelinsight.CI_TEST_TestUtils.createBaseInstallData(); Neha commented for model n package uninstallation
        PageReference resultpage;
        Opportunity opp = JP_TestUtil.Create_Opportunity();
        opp.Pricebook2Id = Test.getStandardPricebookId();
        update opp;
        
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
        
        /**
         *価格表を登録
         */
        Pricebook2 pb2 = new Pricebook2();
        pb2.Name = getCurrentYearMonth();
        pb2.IsActive = true;
        insert pb2;
        
        /**
         *価格表エントリを登録
         */
        Product2 pdt2 = new Product2();
        pdt2.Name = 'その他商品';
        insert pdt2;
        
        PriceBookEntry pbe = new PriceBookEntry();
        pbe.Pricebook2Id = Test.getStandardPricebookId();
        pbe.Product2Id = pdt2.Id;
        pbe.UnitPrice = 100.00;
        pbe.IsActive = true;
        insert pbe;
        
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
        }
        
        insert qhList;
        
        for(JP_QuotationHeader__c qh : qhList){
            qdList = JP_TestUtil.Create_JP_QuotationDetail(qh.Id,1);
            for(JP_QuotationDetail__c qd : qdList){
                setQuotationDetailDefault(qd, pbe, false);
            }
        }
        insert qdList;
        
        PageReference pref = Page.JP_CopyQuotationToOpportunity;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        Apexpages.Standardcontroller sc;
        JP_CopyQuotationToOpportunityController jph;

        JP_QuotationHeader__c rec = qhList[0];

        Test.startTest();

        sc = new Apexpages.Standardcontroller(rec);
        jph = new JP_CopyQuotationToOpportunityController(sc);
        jph.QHeader.JP_OpportunityNo__c = opp.Id;

        resultpage = jph.doCopy();
        
        Test.stopTest();
        
        List<OpportunityLineItem> opplines = [Select Id, OpportunityId, PriceBookEntryId From OpportunityLineItem Where OpportunityId =: opp.Id];
        //System.assertEquals(pbe.Id, opplines[0].PriceBookEntryId);
    }
    
    
    /**
     *価格表に商品が存在しなかった場合、その他商品が存在しない場合
     */
    static testMethod void testCopyQtoO5() {
    //Channelinsight.CI_TEST_TestUtils.createBaseInstallData();Neha commented for model n package uninstallation
        PageReference resultpage;
        Opportunity opp = JP_TestUtil.Create_Opportunity();
        opp.Pricebook2Id = Test.getStandardPricebookId();
        update opp;
        
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
        
        /**
         *価格表を登録
         */
        Pricebook2 pb2 = new Pricebook2();
        pb2.Name = getCurrentYearMonth();
        pb2.IsActive = true;
        insert pb2;
        
        /**
         *価格表エントリを登録
         */
        Product2 pdt22 = new Product2();
        pdt22.Name = 'テストプロダクト名';
        insert pdt22;
        
        PriceBookEntry pbe = new PriceBookEntry();
        pbe.Pricebook2Id = Test.getStandardPricebookId();
        pbe.Product2Id = pdt22.Id;
        pbe.UnitPrice = 100.00;
        pbe.IsActive = true;
        insert pbe;
        
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
        }
        
        insert qhList;
        
        for(JP_QuotationHeader__c qh : qhList){
            qdList = JP_TestUtil.Create_JP_QuotationDetail(qh.Id,1);
            for(JP_QuotationDetail__c qd : qdList){
                setQuotationDetailDefault(qd, pbe, false);
            }
        }
        insert qdList;
        
        PageReference pref = Page.JP_CopyQuotationToOpportunity;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        Apexpages.Standardcontroller sc;
        JP_CopyQuotationToOpportunityController jph;

        JP_QuotationHeader__c rec = qhList[0];

        Test.startTest();

        sc = new Apexpages.Standardcontroller(rec);
        jph = new JP_CopyQuotationToOpportunityController(sc);
        jph.QHeader.JP_OpportunityNo__c = opp.Id;

        resultpage = jph.doCopy();
        
        Test.stopTest();
        
        String errMsgs = '';
        for(ApexPages.Message message : ApexPages.getMessages()) {
            errMsgs += message.getSummary();
        }
        //System.assertEquals(true, errMsgs.contains('商品が存在しません'));
    }
    
    
    /**
     *QHeader.JP_OpportunityNo__cがnullの場合
     */
    static testMethod void testCopyQtoO6() {
    //Channelinsight.CI_TEST_TestUtils.createBaseInstallData();
        PageReference resultpage;
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
        
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
            qh.JP_OpportunityNo__c = null;
        }
        
        insert qhList;
        
        for(JP_QuotationHeader__c qh : qhList){
            qdList = JP_TestUtil.Create_JP_QuotationDetail(qh.Id,1);
            for(JP_QuotationDetail__c qd : qdList){
                setQuotationDetailDefault(qd, new PriceBookEntry(), false);
            }
        }
        insert qdList;
        
        PageReference pref = Page.JP_CopyQuotationToOpportunity;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        Apexpages.Standardcontroller sc;
        JP_CopyQuotationToOpportunityController jph;

        JP_QuotationHeader__c rec = qhList[0];

        Test.startTest();

        sc = new Apexpages.Standardcontroller(rec);
        jph = new JP_CopyQuotationToOpportunityController(sc);

        resultpage = jph.doCopy();
        
        Test.stopTest();
        
        String errMsgs = '';
        for(ApexPages.Message message : ApexPages.getMessages()) {
            errMsgs += message.getSummary();
        }
        System.assertEquals(true, errMsgs.contains('商談が選択されていません'));
    }
    
    
    /**
     *見積明細の価格表エントリIDから価格表を取得できなく、当月の価格表を取得できない場合
     */
    static testMethod void testCopyQtoO7() {
   // Channelinsight.CI_TEST_TestUtils.createBaseInstallData();
        PageReference resultpage;
        Opportunity opp = JP_TestUtil.Create_Opportunity();
        
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
        
        /**
         *価格表を登録
         */
        Pricebook2 pb2 = new Pricebook2();
        pb2.Name = getCurrentYearMonth();
        pb2.isActive = true;
        insert pb2;
        
        /**
         *価格表エントリを登録
         */
        Product2 pdt22 = new Product2();
        pdt22.Name = 'その他商品';
        insert pdt22;
        
        PriceBookEntry pbe1 = new PriceBookEntry();
        pbe1.Pricebook2Id = Test.getStandardPricebookId();
        pbe1.Product2Id = pdt22.Id;
        pbe1.UnitPrice = 100;
        pbe1.IsActive = true;
        pbe1.UseStandardPrice = false;
        insert pbe1;
        
        PriceBookEntry pbe2 = new PriceBookEntry();
        pbe2.Pricebook2Id = pb2.Id;
        pbe2.Product2Id = pdt22.Id;
        pbe2.UnitPrice = 100;
        pbe2.IsActive = true;
        pbe2.UseStandardPrice = false;
        insert pbe2;
        
        
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
        }
        
        insert qhList;
        
        for(JP_QuotationHeader__c qh : qhList){
            qdList = JP_TestUtil.Create_JP_QuotationDetail(qh.Id,1);
            for(JP_QuotationDetail__c qd : qdList){
                setQuotationDetailDefault(qd, pbe1, false);
            }
        }
        insert qdList;
        
        PageReference pref = Page.JP_CopyQuotationToOpportunity;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        Apexpages.Standardcontroller sc;
        JP_CopyQuotationToOpportunityController jph;

        JP_QuotationHeader__c rec = qhList[0];

        Test.startTest();

        sc = new Apexpages.Standardcontroller(rec);
        jph = new JP_CopyQuotationToOpportunityController(sc);
        jph.QHeader.JP_OpportunityNo__c = opp.Id;

        resultpage = jph.doCopy();
        
        Test.stopTest();
        
        String errMsgs = '';
        for(ApexPages.Message message : ApexPages.getMessages()) {
            errMsgs += message.getSummary();
        }
        //System.assertEquals(true, errMsgs.contains('価格表が特定できません'));
    }
    
    
    /**
     *既存商談商品が存在する場合
     */
    static testMethod void testCopyQtoO8() {
    //Channelinsight.CI_TEST_TestUtils.createBaseInstallData();
        PageReference resultpage;
        Opportunity opp = JP_TestUtil.Create_Opportunity();
        
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
        
        /**
         *価格表を登録
         */
        Pricebook2 pb2 = new Pricebook2();
        pb2.Name = getCurrentYearMonth();
        pb2.IsActive = true;
        insert pb2;
        
        /**
         *価格表エントリを登録
         */
        Product2 pdt2 = new Product2();
        pdt2.Name = 'その他商品';
        insert pdt2;
        
        PriceBookEntry pbe = new PriceBookEntry();
        pbe.Pricebook2Id = Test.getStandardPricebookId();
        pbe.Product2Id = pdt2.Id;
        pbe.UnitPrice = 100.00;
        pbe.IsActive = true;
        insert pbe;
        
        /**
         *OpportunityLineItemを登録
         */
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.OpportunityId = opp.Id;
        oli.PricebookEntryId = pbe.Id;
        oli.Quantity = 100.00;
        oli.TotalPrice = oli.Quantity * pbe.UnitPrice;
        insert oli;
        
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
        }
        
        insert qhList;
        
        for(JP_QuotationHeader__c qh : qhList){
            qdList = JP_TestUtil.Create_JP_QuotationDetail(qh.Id,1);
            for(JP_QuotationDetail__c qd : qdList){
                setQuotationDetailDefault(qd, pbe, true);
            }
        }
        insert qdList;
        
        PageReference pref = Page.JP_CopyQuotationToOpportunity;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        Apexpages.Standardcontroller sc;
        JP_CopyQuotationToOpportunityController jph;

        JP_QuotationHeader__c rec = qhList[0];

        Test.startTest();

        sc = new Apexpages.Standardcontroller(rec);
        jph = new JP_CopyQuotationToOpportunityController(sc);
        jph.QHeader.JP_OpportunityNo__c = opp.Id;

        resultpage = jph.doCopy();
        
        Test.stopTest();
        
        System.assertEquals('/' + opp.Id, resultpage.getUrl());
    }
    
    static testMethod void testCopyQtoO9() {
    //Channelinsight.CI_TEST_TestUtils.createBaseInstallData();
        PageReference resultpage;
        Opportunity opp = JP_TestUtil.Create_Opportunity();
        List<JP_DistributorPrice__c> dpList = JP_TestUtil.Create_JP_DistributorPrice(1);        
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
        Date day = system.today();
        
        /**
         *価格表を登録
         */
        Pricebook2 pb2 = new Pricebook2();
        pb2.Name = getCurrentYearMonth();
        pb2.IsActive = true;
        insert pb2;
        
        /**
         *価格表エントリを登録
         */
        Product2 pdt2 = new Product2();
        pdt2.Name = 'その他商品';
        insert pdt2;
        
        PriceBookEntry pbe = new PriceBookEntry();
        pbe.Pricebook2Id = Test.getStandardPricebookId();
        pbe.Product2Id = pdt2.Id;
        pbe.UnitPrice = 100.00;
        pbe.IsActive = true;
        insert pbe;
        
        for(JP_DistributorPrice__c dp : dpList){
            dp.JP_ExpirvStandardPrice__c = 12000;
            dp.JP_WholeSaleRate__c = 0.7;
            dp.JP_WholeSalePrice__c = 8400;
            dp.JP_SaleStatus__c = '1';
            dp.JP_ReleaseDate__c = String.valueOf(day).replace('/','');
            dp.JP_SalesEndScheduledPeriod__c = String.valueOf(day.addDays(10));
            dp.JP_PriceYearMonth__c = getCurrentYearMonth();
            dp.JP_ExpirvDiscountLimit__c = 5000;
            dp.JP_RequiredMaintenanceFlag__c = false;
            dp.JP_AppGroupID__c = 'G1';
            dp.JP_5PercentDiscount__c = 11400;
            dp.JP_SupportTicketClassificationCode__c = 'TEST';
            dp.JP_PreRelease__c = false;
            dp.JP_Category1__c = 'カテゴリ1';
            dp.JP_Category2__c = 'カテゴリ2';
            dp.JP_Maker__c = 'メーカー';
            dp.JP_PiStock__c = false;
            dp.JP_PriceBookEntryId__c = pbe.Id;
            dp.JP_CampaignStartDate__c = String.valueOf(day);
            dp.JP_Price_List_Type__c = distibutors[0].JP_Price_List_Type__c;
            dp.JP_ProductCatalogCode__c = 'TEST12345';
            dp.JP_WholeSaleKey__c = dp.JP_Price_List_Type__c + '_' + dp.JP_ProductCatalogCode__c + '_' + dp.JP_PriceYearMonth__c;
            dp.JP_OutputableQuotation__c  = true;
        }
        insert dpList;

        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
        }
        
        insert qhList;
        
        for(JP_QuotationHeader__c qh : qhList){
            qdList = JP_TestUtil.Create_JP_QuotationDetail(qh.Id,1);
            for(JP_QuotationDetail__c qd : qdList){
                setQuotationDetailDefault(qd, pbe, false);
            }
        }
        insert qdList;
        
        PageReference pref = Page.JP_CopyQuotationToOpportunity;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        Apexpages.Standardcontroller sc;
        JP_CopyQuotationToOpportunityController jph;

        JP_QuotationHeader__c rec = qhList[0];

        Test.startTest();

        sc = new Apexpages.Standardcontroller(rec);
        jph = new JP_CopyQuotationToOpportunityController(sc);
        jph.QHeader.JP_OpportunityNo__c = opp.Id;

        resultpage = jph.doCopy();
        
        Test.stopTest();
        
        System.assertEquals('/' + opp.Id, resultpage.getUrl());
    }
    
    
    /**
     *今月の年月を取得
     */
    static String getCurrentYearMonth() { 
    //Channelinsight.CI_TEST_TestUtils.createBaseInstallData();
        Date nowDate = system.today();
        String dateYM = 'JP ' + nowDate.year();
        if(String.valueOf(nowDate.month()).length() == 2){
            dateYM += '/' + nowDate.month();
        }else{
            dateYM += '/0' + nowDate.month();
        }
        
        return dateYM;
    }
    
    
    /**
     *製品見積のデフォルト値を設定する
     */
    static void setQuotationHeaderDefault(JP_QuotationHeader__c qh) {
    //Channelinsight.CI_TEST_TestUtils.createBaseInstallData();
        qh.Name = '見積コピーテスト';
        qh.JP_PlannedDeliveryDate__c = 'テスト予定納期';
        qh.JP_PaymentCondition__c = 'テスト支払条件';
        qh.JP_QuotationEffectiveTerm__c = '90';
        qh.JP_Postcode__c = '123-4567';
        qh.JP_Adress1__c = '東京都';
        qh.JP_Adress2__c = '中央区日本橋一丁目3番13号';
        qh.JP_Building__c = '東京建物日本橋ビル';
        qh.JP_Department1__c = 'ソリューション本部';
        qh.JP_Department2__c = '金融ソリューション部';
        qh.JP_QuotationDistCD__c = distibutors[0].Id;
        qh.JP_QuotationContact__c = qcList[0].Id;
        qh.JP_Title__c = '様';
        qh.JP_TelNo__c = '03-1234-5678';
        qh.JP_FaxNo__c = '03-1234-5677';
        qh.JP_ATKK_Postcode__c = '987-6543';
        qh.JP_ATKK_Address1__c = '東京都';
        qh.JP_ATKK_Address2__c = '千代田区千代田１−１';
        qh.JP_ATKK_Building__c = 'テストビル';
        qh.JP_ATKK_Company__c = 'テストカンパニー';
        qh.JP_atkkDepartment1__c = 'テスト部';
        qh.JP_Outside__c = JP_TestUtil.Create_User('011_OUT').Id;
        qh.JP_Inside__c = JP_TestUtil.Create_User('010_IN').Id;
        qh.JP_atkkTellNo__c = '05-1234-5678';
        qh.JP_atkkFaxNo__c = '05-1234-5677';
        qh.JP_QuotationCondition__c = 'テスト見積条件';
        qh.JP_OpportunityNo__c = JP_TestUtil.Create_Opportunity().Id;
        qh.JP_E_U_CompanyName__c = 'テストE/U会社名';
        qh.JP_Distributor__c = 'DIS';
        qh.JP_DeliveryRoute__c = 'テスト納入経路';
        qh.JP_DeliveryDateForApproval__c = 'テスト納期';
        qh.JP_OpportunitySummary__c = 'テスト案件概要';
        qh.JP_CompetitionInfoDetail__c = 'テストコンペ情報の詳細';
        qh.JP_DiscountReason__c = 'テスト値引金額の根拠';
        qh.JP_BusinessPotential__c = 'テスト特価による今後の案件の展開、メリット等';
        qh.JP_OtherRequestReason__c = 'テストその他申請理由';
        qh.JP_TotalAmount__c = 1;
        qh.JP_TotalStandardAmount__c = 1;
        qh.JP_PreSave__c = true;
    }
    
    
    /**
     *見積明細のデフォルト値を設定する
     */
    static void setQuotationDetailDefault(JP_QuotationDetail__c qd, PriceBookEntry pbe, Boolean setPbeFlg) {
   // Channelinsight.CI_TEST_TestUtils.createBaseInstallData();
        qd.Name = 'テスト商品';
        qd.JP_DetailsNo__c = 11111;
        qd.JP_ProductCode__c = 'TEST11111';
        qd.JP_ProductCatalogCode__c = 'TEST12345';
        qd.JP_ProductName__c = 'テスト商品';
        qd.JP_StandardPrice__c = 10000;
        qd.JP_Quantity__c = 1;
        qd.JP_Unit__c = 'テスト単位';
        qd.JP_WholeSaleRate__c = 1;
        qd.JP_SpecialWholeSaleTRate__c = 0.7;
        qd.JP_UnitPrice__c = qd.JP_StandardPrice__c * qd.JP_WholeSaleRate__c;
        qd.JP_SpecialUnitPrice__c = qd.JP_UnitPrice__c * qd.JP_SpecialWholeSaleTRate__c;
        qd.JP_WholeSalePriceMulQuantity__c = qd.JP_StandardPrice__c * qd.JP_WholeSaleRate__c * qd.JP_Quantity__c;
        qd.JP_SpecialUnitPriceMulQuantity__c = qd.JP_StandardPrice__c * qd.JP_SpecialWholeSaleTRate__c;
        if (qd.JP_SpecialUnitPrice__c > 0) {
            qd.JP_DeterminedAmount__c = qd.JP_SpecialUnitPriceMulQuantity__c;
        } else {
            qd.JP_DeterminedAmount__c = qd.JP_WholeSalePriceMulQuantity__c;
        }
        qd.JP_DiscountLimitPrice__c = 6000;
        qd.JP_QuotationRemarks__c = 'テスト備考';
        qd.JP_RequiredMaintenanceFlag__c = true;
        qd.JP_CampaignDecision__c = true;
        qd.JP_SpecialPriceDecision__c = true;
        qd.JP_DistributorProCode__c = 'DPC1111';
        qd.JP_PriceYearMonth__c = 'JP ' + system.today().year()+'/';
        if(system.today().month() < 10){
            qd.JP_PriceYearMonth__c += '0' + system.today().month();
        }else{
            qd.JP_PriceYearMonth__c += system.today().month();
        }
        qd.JP_SalesStatus__c = 'テストステータス';
        qd.JP_ReleaseScheduled__c = 'テストリリース予定';
        qd.JP_SalesEndScheduled__c = 'テスト販売終了予定';
        qd.JP_DetailsID__c = 1;
        qd.JP_Sort__c = 1;
        qd.JP_IsSpecialDistributorProduct__c = true;
        qd.JP_5PercentDiscount__c = 9500;
        qd.JP_OverLimitDiscount__c = false;
        qd.JP_AppGroupID__c = 'G1';
        qd.JP_StandardMinusSpecial__c = qd.JP_WholeSalePriceMulQuantity__c - qd.JP_SpecialUnitPriceMulQuantity__c;
        
        if(setPbeFlg) {
            qd.JP_PriceBookEntryId__c  = pbe.Id;
        }else{
            qd.JP_PriceBookEntryId__c  = null;
        }
    }
}