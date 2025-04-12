@isTest
private class Test_JP_CopyQuotationForLightning {

    // 見積書番号を引継いでコピーテスト
    static testMethod void testCopyQtoQ1() {
        Map<String, JP_DistributorPrice__c> dpMap = new Map<String, JP_DistributorPrice__c>();
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
        List<JP_CustomerInfo2__c> ci2List = new List<JP_CustomerInfo2__c>();
        List<JP_DistributorPrice__c> dpList = JP_TestUtil.Create_JP_DistributorPrice(1);
        List<JP_QuotationDistributor__c> distibutors = JP_TestUtil.Create_JP_QuotationDistributor();
        List<JP_QuotationContact__c> qcList = [Select Id,Name From JP_QuotationContact__c Where JP_QuotationDistributor__c=:distibutors[0].id Order by Name];
        Date day = system.today();
        
        for(JP_DistributorPrice__c dp : dpList){
            dp.JP_ExpirvStandardPrice__c = 12000;
            dp.JP_WholeSaleRate__c = 0.7;
            dp.JP_WholeSalePrice__c = 8400;
            dp.JP_SaleStatus__c = '1';
            dp.JP_ReleaseDate__c = String.valueOf(day).replace('/','');
            dp.JP_SalesEndScheduledPeriod__c = String.valueOf(day.addDays(10));
            dp.JP_PriceYearMonth__c = 'JP ' + day.year();
            if(String.valueOf(day.month()).length() == 2){
                dp.JP_PriceYearMonth__c += '/' + day.month();
            }else{
                dp.JP_PriceYearMonth__c += '/0' + day.month();
            }
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
            dp.JP_PriceBookEntryId__c = 'aaaaaaaa';
            dp.JP_CampaignStartDate__c = String.valueOf(day);
            dp.JP_Price_List_Type__c = distibutors[0].JP_Price_List_Type__c;
            dp.JP_ProductCatalogCode__c = 'TEST12345';
            dp.JP_WholeSaleKey__c = dp.JP_Price_List_Type__c + '_' + dp.JP_ProductCatalogCode__c + '_' + dp.JP_PriceYearMonth__c;
            dp.JP_OutputableQuotation__c  = true;
            system.debug('******* dp.JP_WholeSaleKey__c : ' + dp.JP_WholeSaleKey__c);
            dpMap.put(dp.JP_WholeSaleKey__c, dp);
        }
        insert dpList;
        
        for(JP_QuotationHeader__c qh :qhList){
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
        
        insert qhList;
        
        for(JP_QuotationHeader__c qh : qhList){
            qdList = JP_TestUtil.Create_JP_QuotationDetail(qh.Id,1);
            ci2List = JP_TestUtil.Create_JP_CustomerInfo2(qh.Id,1);
            for(JP_QuotationDetail__c qd : qdList){
                qd.Name = 'テスト商品';
                qd.JP_DetailsNo__c = 11111;
                qd.JP_ProductCode__c = 'TEST11111';
                qd.JP_ProductCatalogCode__c = 'TEST12345';
                qd.JP_ProductName__c = 'テスト商品';
                qd.JP_StandardPrice__c = 10000;
                qd.JP_Quantity__c = 1;
                qd.JP_Unit__c = 'テスト単位';
                qd.JP_WholeSaleRate__c = 1;
                qd.JP_SpecialWholeSaleTRate__c = 0.1;
                qd.JP_UnitPrice__c = qd.JP_StandardPrice__c * qd.JP_SpecialWholeSaleTRate__c;
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
                if(system.today().month()-1 < 10 && system.today().month()-1 != 0){
                    qd.JP_PriceYearMonth__c += '0' + (system.today().month()-1);
                }else if(system.today().month()-1 == 0){
                    qd.JP_PriceYearMonth__c += '01';
                }else{
                    qd.JP_PriceYearMonth__c += system.today().month()-1;
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
            }
        }
        insert qdList;
        insert ci2List;
        
        Test.startTest();
        JP_CopyQuotationForLightning.chkError(qhList[0].Id,'button1');
        JP_CopyQuotationForLightning.copyQuotation(qhList[0].Id,'button1');
        Test.stopTest();
        
        JP_QuotationHeader__c srcQH = JP_QuotationHeaderDAO.getRecByIdUseFieldSet(qhList[0].Id);
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : SObjectType.JP_QuotationHeader__c.FieldSets.CopyItemToQuotation.getFields()) {
            query += f.getFieldPath() + ', ';
        }
        query += 'Id, JP_QuotationDistCD__r.JP_Price_List_Type__c, JP_QuotationDistCD__r.JP_MainDistributorCode__c, ';
        query += 'JP_QuotationDistCD__r.JP_QuotationCreatableFlag__c, JP_QuotationDistCD__r.JP_DistributorActiveFlag__c, JP_QuotationDistCD__r.JP_EffectiveFlagForMainDistributor__c ';
        query += 'FROM JP_QuotationHeader__c ';
        query += 'where JP_QuotationCopyNo__c = \'' + srcQH.JP_QuotationNo__c + '\' ';
        query += 'LIMIT 1';
        
        system.debug('******query : ' + query);
        JP_QuotationHeader__c destQH =  Database.query(query);
        
        List<JP_QuotationDetail__c> srcQDList = JP_QuotationDetailDAO.getRecByIdUseFieldSet(srcQH.Id);
        List<JP_QuotationDetail__c> destQDList = JP_QuotationDetailDAO.getRecByIdUseFieldSet(destQH.Id);
        
        // 製品見積項目セット
        List<Schema.FieldSetMember> schemaParent = SObjectType.JP_QuotationHeader__c.FieldSets.CopyItemToQuotation.getFields();
        // 見積明細項目セット
        List<Schema.FieldSetMember> schemaChildren = SObjectType.JP_QuotationDetail__c.FieldSets.CopyItemToQuotation.getFields();

        for(integer i = 0; i < schemaParent.size(); i++){
            system.debug('***** Field : ' + schemaParent[i].getFieldPath());
            if(schemaParent[i].getFieldPath() != 'JP_QuotationNo__c' && schemaParent[i].getFieldPath() != 'JP_TotalAmount__c' && schemaParent[i].getFieldPath() != 'JP_AutoSumFlg__c'){
                system.assertEquals(srcQH.get(schemaParent[i].getFieldPath()), destQH.get(schemaParent[i].getFieldPath()));
            }
        }
        system.assertNotEquals(destQH.JP_QuotationNo__c, srcQH.JP_QuotationNo__c);
        
        Date nowDate = system.today();
        String priceYM = 'JP ' + nowDate.year();
        if(String.valueOf(nowDate.month()).length() == 2){
            priceYM += '/' + nowDate.month();
        }else{
            priceYM += '/0' + nowDate.month();
        }
        String wholeSaleKey = destQH.JP_QuotationDistCD__r.JP_Price_List_Type__c + '_' + destQDList[0].JP_ProductCatalogCode__c + '_' + priceYM;
        JP_DistributorPrice__c dp;
        
        if(dpMap.containsKey(wholeSaleKey)){
            dp = dpMap.get(wholeSaleKey);
        }
        
        for(integer i = 0; i < schemaChildren.size(); i++){
            system.debug('***** Field : ' + schemaChildren[i].getFieldPath());
            if( schemaChildren[i].getFieldPath() == 'JP_StandardPrice__c' ){
                system.assertEquals(destQDList[0].get(schemaChildren[i].getFieldPath()), dp.JP_ExpirvStandardPrice__c);
            } else if( schemaChildren[i].getFieldPath() == 'JP_WholeSaleRate__c' ){
                system.assertEquals(destQDList[0].get(schemaChildren[i].getFieldPath()), dp.JP_WholeSaleRate__c);
            } else if( schemaChildren[i].getFieldPath() == 'JP_UnitPrice__c' ){
                system.assertEquals(destQDList[0].get(schemaChildren[i].getFieldPath()), destQDList[0].JP_StandardPrice__c * destQDList[0].JP_WholeSaleRate__c);
            } else if( schemaChildren[i].getFieldPath() == 'JP_DiscountLimitPrice__c' ){
                system.assertEquals(destQDList[0].get(schemaChildren[i].getFieldPath()), dp.JP_ExpirvDiscountLimit__c);
            } else if( schemaChildren[i].getFieldPath() == 'JP_RequiredMaintenanceFlag__c' ){
                system.assertEquals(destQDList[0].get(schemaChildren[i].getFieldPath()), dp.JP_RequiredMaintenanceFlag__c);
            } else if( schemaChildren[i].getFieldPath() == 'JP_PriceYearMonth__c' ){
                system.assertEquals(destQDList[0].get(schemaChildren[i].getFieldPath()), dp.JP_PriceYearMonth__c);
            } else if( schemaChildren[i].getFieldPath() == 'JP_SalesStatus__c' ){
                system.assertEquals(destQDList[0].get(schemaChildren[i].getFieldPath()), dp.JP_SaleStatus__c);
            } else if( schemaChildren[i].getFieldPath() == 'JP_ReleaseScheduled__c' ){
                system.assertEquals(destQDList[0].get(schemaChildren[i].getFieldPath()), dp.JP_ReleaseDate__c);
            } else if( schemaChildren[i].getFieldPath() == 'JP_SalesEndScheduled__c' ){
                system.assertEquals(destQDList[0].get(schemaChildren[i].getFieldPath()), dp.JP_SalesEndScheduledPeriod__c);
            } else if( schemaChildren[i].getFieldPath() == 'JP_5PercentDiscount__c' ){
                system.assertEquals(destQDList[0].get(schemaChildren[i].getFieldPath()), dp.JP_5PercentDiscount__c);
            } else if( schemaChildren[i].getFieldPath() == 'JP_PriceBookEntryId__c' ){
                system.assertEquals(destQDList[0].get(schemaChildren[i].getFieldPath()), dp.JP_PriceBookEntryId__c);
            } else if( schemaChildren[i].getFieldPath() == 'JP_Category1__c' ){
                system.assertEquals(destQDList[0].get(schemaChildren[i].getFieldPath()), dp.JP_Category1__c);
            } else if( schemaChildren[i].getFieldPath() == 'JP_Category2__c' ){
                system.assertEquals(destQDList[0].get(schemaChildren[i].getFieldPath()), dp.JP_Category2__c);
            } else if( schemaChildren[i].getFieldPath() == 'JP_Maker__c' ){
                system.assertEquals(destQDList[0].get(schemaChildren[i].getFieldPath()), dp.JP_Maker__c);
            } else if( schemaChildren[i].getFieldPath() == 'JP_SupportTicketCode__c' ){
                system.assertEquals(destQDList[0].get(schemaChildren[i].getFieldPath()), dp.JP_SupportTicketClassificationCode__c);
            } else if( schemaChildren[i].getFieldPath() == 'JP_AppGroupID__c' ){
                system.assertEquals(destQDList[0].get(schemaChildren[i].getFieldPath()), dp.JP_AppGroupID__c);
            } else if( schemaChildren[i].getFieldPath() == 'JP_CampaignDecision__c' ){
                system.assertEquals(destQDList[0].get(schemaChildren[i].getFieldPath()), true);
            } else if(schemaChildren[i].getFieldPath() == 'JP_IsSpecialDistributorProduct__c'){
                system.assertEquals(destQDList[0].get(schemaChildren[i].getFieldPath()), true);
            } else if( schemaChildren[i].getFieldPath() == 'JP_WholeSalePriceMulQuantity__c' ){
                system.assertEquals(destQDList[0].get(schemaChildren[i].getFieldPath()), destQDList[0].JP_UnitPrice__c * destQDList[0].JP_Quantity__c);
            } else if(schemaChildren[i].getFieldPath() == 'JP_SpecialUnitPrice__c'){
                system.assertEquals(destQDList[0].get(schemaChildren[i].getFieldPath()), destQDList[0].JP_StandardPrice__c * destQDList[0].JP_SpecialWholeSaleTRate__c);
            } else if(schemaChildren[i].getFieldPath() == 'JP_SpecialUnitPriceMulQuantity__c'){
                system.assertEquals(destQDList[0].get(schemaChildren[i].getFieldPath()), destQDList[0].JP_SpecialUnitPrice__c * destQDList[0].JP_Quantity__c);
            } else if(schemaChildren[i].getFieldPath() == 'JP_StandardMinusSpecial__c'){
                system.assertEquals(destQDList[0].get(schemaChildren[i].getFieldPath()), destQDList[0].JP_WholeSalePriceMulQuantity__c - destQDList[0].JP_SpecialUnitPriceMulQuantity__c);
            } else if(schemaChildren[i].getFieldPath() == 'JP_SpecialPriceDecision__c'){
                system.assertEquals(destQDList[0].get(schemaChildren[i].getFieldPath()), true);
            } else if(schemaChildren[i].getFieldPath() == 'JP_DeterminedAmount__c'){
                system.assertEquals(destQDList[0].get(schemaChildren[i].getFieldPath()), destQDList[0].JP_SpecialUnitPriceMulQuantity__c);
            } else if(schemaChildren[i].getFieldPath() == 'JP_OverLimitDiscount__c'){
                system.assertEquals(destQDList[0].get(schemaChildren[i].getFieldPath()), true);
            } else{
                system.assertEquals(srcQDList[0].get(schemaChildren[i].getFieldPath()), destQDList[0].get(schemaChildren[i].getFieldPath()));
            }
        }
    }
    
    // 見積書番号を引継がずにコピーテスト
    static testMethod void testCopyQtoQ2() {
        Map<String, JP_DistributorPrice__c> dpMap = new Map<String, JP_DistributorPrice__c>();
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
        List<JP_QuotationDistributor__c> distibutors = JP_TestUtil.Create_JP_QuotationDistributor();
        List<JP_DistributorPrice__c> dpList = JP_TestUtil.Create_JP_DistributorPrice(1);
        List<JP_QuotationContact__c> qcList = [Select Id,Name From JP_QuotationContact__c Where JP_QuotationDistributor__c=:distibutors[0].id Order by Name];
        Date day = system.today();
        
        for(JP_DistributorPrice__c dp : dpList){
            dp.JP_ExpirvStandardPrice__c = 12000;
            dp.JP_WholeSaleRate__c = 0.7;
            dp.JP_WholeSalePrice__c = 8400;
            dp.JP_SaleStatus__c = '1';
            dp.JP_ReleaseDate__c = String.valueOf(day).replace('/','');
            dp.JP_SalesEndScheduledPeriod__c = String.valueOf(day.addDays(10));
            dp.JP_PriceYearMonth__c = 'JP ' + day.year();
            if(String.valueOf(day.month()).length() == 2){
                dp.JP_PriceYearMonth__c += '/' + day.month();
            }else{
                dp.JP_PriceYearMonth__c += '/0' + day.month();
            }
            dp.JP_ExpirvDiscountLimit__c = 8500;
            dp.JP_RequiredMaintenanceFlag__c = false;
            dp.JP_AppGroupID__c = 'G1';
            dp.JP_5PercentDiscount__c = 11400;
            dp.JP_SupportTicketClassificationCode__c = 'TEST';
            dp.JP_PreRelease__c = false;
            dp.JP_Category1__c = 'カテゴリ1';
            dp.JP_Category2__c = 'カテゴリ2';
            dp.JP_Maker__c = 'メーカー';
            dp.JP_PiStock__c = false;
            dp.JP_PriceBookEntryId__c = 'aaaaaaaa';
            dp.JP_Price_List_Type__c = distibutors[0].JP_Price_List_Type__c;
            dp.JP_ProductCatalogCode__c = 'TEST12345';
            dp.JP_WholeSaleKey__c = dp.JP_Price_List_Type__c + '_' + dp.JP_ProductCatalogCode__c + '_' + dp.JP_PriceYearMonth__c;
            dp.JP_OutputableQuotation__c  = true;
            system.debug('******* dp.JP_WholeSaleKey__c : ' + dp.JP_WholeSaleKey__c);
            dpMap.put(dp.JP_WholeSaleKey__c, dp);
        }
        insert dpList;
        
        for(JP_QuotationHeader__c qh :qhList){
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
            qh.JP_Title__c = 'JP_SAMA';
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
            qh.JP_TotalAmount__c = 100000;
            qh.JP_TotalStandardAmount__c = 1;
            qh.JP_PreSave__c = true;
        }
        
        insert qhList;
        
        for(JP_QuotationHeader__c qh : qhList){
            qdList = JP_TestUtil.Create_JP_QuotationDetail(qh.Id,1);
            for(JP_QuotationDetail__c qd : qdList){
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
                qd.JP_SpecialUnitPrice__c = qd.JP_StandardPrice__c * qd.JP_SpecialWholeSaleTRate__c;
                qd.JP_WholeSalePriceMulQuantity__c = qd.JP_StandardPrice__c * qd.JP_WholeSaleRate__c * qd.JP_Quantity__c;
                qd.JP_SpecialUnitPriceMulQuantity__c = qd.JP_StandardPrice__c * qd.JP_SpecialWholeSaleTRate__c * qd.JP_Quantity__c;
                if (qd.JP_SpecialUnitPrice__c > 0) {
                    qd.JP_DeterminedAmount__c = qd.JP_SpecialUnitPriceMulQuantity__c;
                } else {
                    qd.JP_DeterminedAmount__c = qd.JP_WholeSalePriceMulQuantity__c;
                }
                qd.JP_DiscountLimitPrice__c = 12000;
                qd.JP_QuotationRemarks__c = 'テスト備考';
                qd.JP_RequiredMaintenanceFlag__c = true;
                qd.JP_CampaignDecision__c = true;
                qd.JP_SpecialPriceDecision__c = true;
                qd.JP_DistributorProCode__c = 'DPC1111';
                qd.JP_PriceYearMonth__c = 'JP ' + system.today().year()+'/';
                if(system.today().month()-1 < 10 && system.today().month()-1 != 0){
                    qd.JP_PriceYearMonth__c += '0' + (system.today().month()-1);
                }else if(system.today().month()-1 == 0){
                    qd.JP_PriceYearMonth__c += '01';
                }else{
                    qd.JP_PriceYearMonth__c += system.today().month()-1;
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
                qd.JP_StandardMinusSpecial__c = 0;
            }
        }
        insert qdList;
        
        JP_TestUtil.Create_DistributorProductCode(dpList[0].JP_ProductCode__c);
        
        Test.startTest();
        JP_CopyQuotationForLightning.chkError(qhList[0].Id,'button2');
        JP_CopyQuotationForLightning.copyQuotation(qhList[0].Id,'button2');
        Test.stopTest();
        
        JP_QuotationHeader__c srcQH = JP_QuotationHeaderDAO.getRecByIdUseFieldSet(qhList[0].Id);
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : SObjectType.JP_QuotationHeader__c.FieldSets.CopyItemToQuotation.getFields()) {
            query += f.getFieldPath() + ', ';
        }
        query += 'Id, JP_QuotationDistCD__r.JP_Price_List_Type__c, JP_QuotationDistCD__r.JP_MainDistributorCode__c ';
        query += 'FROM JP_QuotationHeader__c ';
        query += 'where JP_QuotationCopyNo__c = \'' + srcQH.JP_QuotationNo__c + '\' ';
        query += 'LIMIT 1';
        
        system.debug('★query : ' + query);
        JP_QuotationHeader__c destQH =  Database.query(query);
        
        List<JP_QuotationDetail__c> srcQDList = JP_QuotationDetailDAO.getRecByIdUseFieldSet(srcQH.Id);
        system.debug('**** srcQDList.size() : ' + srcQDList.size());
        List<JP_QuotationDetail__c> destQDList = JP_QuotationDetailDAO.getRecByIdUseFieldSet(destQH.Id);
        system.debug('**** destQDList.size() : ' + destQDList.size());
        
        // 製品見積項目セット
        List<Schema.FieldSetMember> schemaParent = SObjectType.JP_QuotationHeader__c.FieldSets.CopyItemToQuotation.getFields();
        // 見積明細項目セット
        List<Schema.FieldSetMember> schemaChildren = SObjectType.JP_QuotationDetail__c.FieldSets.CopyItemToQuotation.getFields();
        
        for(integer i = 0; i < schemaParent.size(); i++){
            system.debug('***** ' + schemaParent[i].getFieldPath());
            if(schemaParent[i].getFieldPath() != 'JP_QuotationNo__c' && schemaParent[i].getFieldPath() != 'JP_TotalAmount__c'){
                system.assertEquals(srcQH.get(schemaParent[i].getFieldPath()), destQH.get(schemaParent[i].getFieldPath()));
            }
        }
        system.assertNotEquals(destQH.JP_QuotationNo__c, srcQH.JP_QuotationNo__c);
        
        Date nowDate = system.today();
        String priceYM = 'JP ' + nowDate.year();
        if(String.valueOf(nowDate.month()).length() == 2){
            priceYM += '/' + nowDate.month();
        }else{
            priceYM += '/0' + nowDate.month();
        }
        String wholeSaleKey = destQH.JP_QuotationDistCD__r.JP_Price_List_Type__c + '_' + destQDList[0].JP_ProductCatalogCode__c + '_' + priceYM;
        JP_DistributorPrice__c dp;
        
        if(dpMap.containsKey(wholeSaleKey)){
            dp = dpMap.get(wholeSaleKey);
        }
        
        for(integer i = 0; i < schemaChildren.size(); i++){
            system.debug('***** Field : ' + schemaChildren[i].getFieldPath());
            if( schemaChildren[i].getFieldPath() == 'JP_StandardPrice__c' ){
                system.assertEquals(destQDList[0].get(schemaChildren[i].getFieldPath()), dp.JP_ExpirvStandardPrice__c);
            } else if( schemaChildren[i].getFieldPath() == 'JP_WholeSaleRate__c' ){
                system.assertEquals(destQDList[0].get(schemaChildren[i].getFieldPath()), dp.JP_WholeSaleRate__c);
            } else if( schemaChildren[i].getFieldPath() == 'JP_UnitPrice__c' ){
                system.assertEquals(destQDList[0].get(schemaChildren[i].getFieldPath()), destQDList[0].JP_StandardPrice__c * destQDList[0].JP_WholeSaleRate__c);
            } else if( schemaChildren[i].getFieldPath() == 'JP_DiscountLimitPrice__c' ){
                system.assertEquals(destQDList[0].get(schemaChildren[i].getFieldPath()), dp.JP_ExpirvDiscountLimit__c);
            } else if( schemaChildren[i].getFieldPath() == 'JP_RequiredMaintenanceFlag__c' ){
                system.assertEquals(destQDList[0].get(schemaChildren[i].getFieldPath()), dp.JP_RequiredMaintenanceFlag__c);
            } else if( schemaChildren[i].getFieldPath() == 'JP_PriceYearMonth__c' ){
                system.assertEquals(destQDList[0].get(schemaChildren[i].getFieldPath()), dp.JP_PriceYearMonth__c);
            } else if( schemaChildren[i].getFieldPath() == 'JP_SalesStatus__c' ){
                system.assertEquals(destQDList[0].get(schemaChildren[i].getFieldPath()), dp.JP_SaleStatus__c);
            } else if( schemaChildren[i].getFieldPath() == 'JP_ReleaseScheduled__c' ){
                system.assertEquals(destQDList[0].get(schemaChildren[i].getFieldPath()), dp.JP_ReleaseDate__c);
            } else if( schemaChildren[i].getFieldPath() == 'JP_SalesEndScheduled__c' ){
                system.assertEquals(destQDList[0].get(schemaChildren[i].getFieldPath()), dp.JP_SalesEndScheduledPeriod__c);
            } else if( schemaChildren[i].getFieldPath() == 'JP_5PercentDiscount__c' ){
                system.assertEquals(destQDList[0].get(schemaChildren[i].getFieldPath()), dp.JP_5PercentDiscount__c);
            } else if( schemaChildren[i].getFieldPath() == 'JP_PriceBookEntryId__c' ){
                system.assertEquals(destQDList[0].get(schemaChildren[i].getFieldPath()), dp.JP_PriceBookEntryId__c);
            } else if( schemaChildren[i].getFieldPath() == 'JP_Category1__c' ){
                system.assertEquals(destQDList[0].get(schemaChildren[i].getFieldPath()), dp.JP_Category1__c);
            } else if( schemaChildren[i].getFieldPath() == 'JP_Category2__c' ){
                system.assertEquals(destQDList[0].get(schemaChildren[i].getFieldPath()), dp.JP_Category2__c);
            } else if( schemaChildren[i].getFieldPath() == 'JP_Maker__c' ){
                system.assertEquals(destQDList[0].get(schemaChildren[i].getFieldPath()), dp.JP_Maker__c);
            } else if( schemaChildren[i].getFieldPath() == 'JP_SupportTicketCode__c' ){
                system.assertEquals(destQDList[0].get(schemaChildren[i].getFieldPath()), dp.JP_SupportTicketClassificationCode__c);
            } else if( schemaChildren[i].getFieldPath() == 'JP_AppGroupID__c' ){
                system.assertEquals(destQDList[0].get(schemaChildren[i].getFieldPath()), dp.JP_AppGroupID__c);
            } else if( schemaChildren[i].getFieldPath() == 'JP_CampaignDecision__c' ){
                system.assertEquals(destQDList[0].get(schemaChildren[i].getFieldPath()), false);
            } else if(schemaChildren[i].getFieldPath() == 'JP_IsSpecialDistributorProduct__c'){
                system.assertEquals(destQDList[0].get(schemaChildren[i].getFieldPath()), true);
            } else if( schemaChildren[i].getFieldPath() == 'JP_WholeSalePriceMulQuantity__c' ){
                system.assertEquals(destQDList[0].get(schemaChildren[i].getFieldPath()), destQDList[0].JP_UnitPrice__c * destQDList[0].JP_Quantity__c);
            } else if(schemaChildren[i].getFieldPath() == 'JP_SpecialUnitPrice__c'){
                system.assertEquals(destQDList[0].get(schemaChildren[i].getFieldPath()), destQDList[0].JP_StandardPrice__c * destQDList[0].JP_SpecialWholeSaleTRate__c);
            } else if(schemaChildren[i].getFieldPath() == 'JP_SpecialUnitPriceMulQuantity__c'){
                system.assertEquals(destQDList[0].get(schemaChildren[i].getFieldPath()), destQDList[0].JP_SpecialUnitPrice__c * destQDList[0].JP_Quantity__c);
            } else if(schemaChildren[i].getFieldPath() == 'JP_StandardMinusSpecial__c'){
                system.assertEquals(destQDList[0].get(schemaChildren[i].getFieldPath()), destQDList[0].JP_WholeSalePriceMulQuantity__c - destQDList[0].JP_SpecialUnitPriceMulQuantity__c);
            } else if(schemaChildren[i].getFieldPath() == 'JP_DistributorProCode__c'){
                system.assertNotEquals(srcQDList[0].get(schemaChildren[i].getFieldPath()), destQDList[0].get(schemaChildren[i].getFieldPath()));
            } else if(schemaChildren[i].getFieldPath() == 'JP_SpecialPriceDecision__c'){
                system.assertEquals(destQDList[0].get(schemaChildren[i].getFieldPath()), false);
            } else if(schemaChildren[i].getFieldPath() == 'JP_OverLimitDiscount__c'){
                system.assertEquals(destQDList[0].get(schemaChildren[i].getFieldPath()), true);
            } else if(schemaChildren[i].getFieldPath() == 'JP_DeterminedAmount__c'){
                system.assertEquals(destQDList[0].get(schemaChildren[i].getFieldPath()), destQDList[0].JP_SpecialUnitPriceMulQuantity__c);
            } else{
                system.assertEquals(srcQDList[0].get(schemaChildren[i].getFieldPath()), destQDList[0].get(schemaChildren[i].getFieldPath()));
            }
        }
    }
}