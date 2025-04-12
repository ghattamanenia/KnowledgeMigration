@isTest
public class Test_JP_CopyQuoToOppForLightning {
    
    // 通常チェック
    @isTest
    static void testCopy_Normal () {
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
            List<JP_QuotationHeader__c> QHeader = JP_TestUtil.Create_JP_QuotationHeader(1);
            List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
            List<JP_CustomerInfo2__c> ci2List = new List<JP_CustomerInfo2__c>();
            List<JP_DistributorPrice__c> dpList = JP_TestUtil.Create_JP_DistributorPrice(1);
            List<JP_QuotationDistributor__c> distibutors = JP_TestUtil.Create_JP_QuotationDistributor();
            List<JP_QuotationContact__c> qcList = [SELECT Id,Name FROM JP_QuotationContact__c WHERE JP_QuotationDistributor__c = :distibutors[0].id ORDER BY Name];
            Date day = System.today ();
            
            for (JP_DistributorPrice__c dp : dpList){
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
                dp.JP_ProductCatalogCode__c = '00000';
                dp.JP_WholeSaleKey__c = dp.JP_Price_List_Type__c + '_' + dp.JP_ProductCatalogCode__c + '_' + dp.JP_PriceYearMonth__c;
                dp.JP_OutputableQuotation__c  = true;
                System.debug (dp.JP_WholeSaleKey__c);
            }
            insert dpList;
            System.debug('dpList：' + dpList);
            
            QHeader[0].Name = 'Qheader_00000';
            QHeader[0].JP_PreSave__c = true;
            QHeader[0].JP_QuotationDistCD__c = distibutors[0].Id;
            insert QHeader[0];
            
            qdList = JP_TestUtil.Create_JP_QuotationDetail (QHeader[0].Id, 2);
            for (JP_QuotationDetail__c qd : qdList) {
                qd.JP_QuotationHeader__c = QHeader[0].Id;
                qd.Name = 'テスト製品';
                qd.JP_DetailsNo__c = 11111;
                qd.JP_ProductCode__c = 'TEST11111';
                qd.JP_ProductCatalogCode__c = '00000';
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
                if (qd.JP_SpecialUnitPrice__c > 0)
                    qd.JP_DeterminedAmount__c = qd.JP_SpecialUnitPriceMulQuantity__c;
                else
                    qd.JP_DeterminedAmount__c = qd.JP_WholeSalePriceMulQuantity__c;
                qd.JP_DiscountLimitPrice__c = 6000;
                qd.JP_QuotationRemarks__c = 'テスト備考';
                qd.JP_RequiredMaintenanceFlag__c = true;
                qd.JP_CampaignDecision__c = true;
                qd.JP_SpecialPriceDecision__c = true;
                qd.JP_DistributorProCode__c = 'DPC1111';
                qd.JP_PriceYearMonth__c = 'JP ' + day.year();
                if(String.valueOf(day.month()).length() == 2)
                    qd.JP_PriceYearMonth__c += '/' + day.month();
                else
                    qd.JP_PriceYearMonth__c += '/0' + day.month();
                        
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
            insert qdList;
            
            // 取引先の作成
            Account acc = new Account (Name = 'テスト会社', Phone='0120-123-123');
            insert acc;
            
            // ALLIEDTELESIS-514 mod start
            // トリガによるガバナ抵触のため、JP_TestUtilを利用せずにテストデータ作成
            // コピー対象の商談を作成
            List<Opportunity> targetOpportunity = new List<Opportunity> ();
            // for (Integer i = 0; i < 2; i++) {
            //     Opportunity opp = JP_TestUtil.Create_Opportunity ();
            //     opp.AccountId = acc.Id;
            //     targetOpportunity.add (opp);
            // }


            List<Contact> targetContacts = new List<Contact> ();
            List<OpportunityContactRole> targetOpportunityContactRoles = new List<OpportunityContactRole> ();

            for (Integer i = 0; i < 2; i++) {
                // 商談作成
                Opportunity opp = new Opportunity();
                opp.Name = 'TESTOPPORTUNITY';
                opp.StageName = 'Final Quote';
                opp.CloseDate = system.today().addDays(7);
                opp.Amount = 10000;
                opp.RecordTypeId = '012200000005vdt';
                opp.Required_Delivery_Date__c=system.today().adddays(8);
                opp.AccountId = acc.Id;

                // 顧客作成
                Contact contact = new Contact();
                contact.LastName = 'TESTCONTACT';

                targetOpportunity.add (opp);
                targetContacts.add (contact);
            }
            insert targetOpportunity;
            insert targetContacts;


            // 顧客の役割作成
            for (Integer i = 0; i < 2; i++) {
                OpportunityContactRole ocr = new OpportunityContactRole();
                ocr.isPrimary = true;
                ocr.OpportunityId = targetOpportunity[i].Id;
                ocr.ContactId = targetContacts[i].Id;
                insert ocr;
            }
            // ALLIEDTELESIS-514 mod end
            
            // 商品の作成
            Product2 prod = new Product2 (Name = 'テスト商品');
            insert prod;
            
            // 価格表を作成
            PriceBook2 pBook = new PriceBook2 ();
            pBook.Name = 'JP ' + day.year () + (String.valueOf(day.month()).length() == 2 ? '/' : '/0') + day.month ();
            pBook.Description = '11';
            pBook.IsActive = true;
            insert pBook;
            
            List<PriceBookEntry> pbEntry = new List<PriceBookEntry> ();
            pbEntry.add (new PriceBookEntry ());
            pbEntry[0].Pricebook2Id = Test.getStandardPricebookId ();
            pbEntry[0].Product2Id = prod.Id;
            pbEntry[0].UnitPrice = 1000;
            pbEntry[0].IsActive = true;
            pbEntry.add (new PriceBookEntry ());
            pbEntry[1].Pricebook2Id = pBook.Id;
            pbEntry[1].Product2Id = prod.Id;
            pbEntry[1].UnitPrice = 1000;
            pbEntry[1].IsActive = true;
            insert pbEntry;
            
            // 商談商品の作成
            List<String>stageList = System.Label.JP_HighStageName.split(',');
            List<String>rankList = System.Label.JP_HighDirectRank.split(',');
            Schema.DescribeFieldResult stageNameDescribeFieldResult = Opportunity.stageName.getDescribe();
            List<Schema.PicklistEntry> stageNamePicklistEntry = stageNameDescribeFieldResult.getPicklistValues();

            JP_TestUtil.CreateOpportunityLineItem (targetOpportunity[0].Id, pbEntry[0].Id);
            JP_TestUtil.CreateOpportunityLineItem (targetOpportunity[1].Id, pbEntry[0].Id);
            
            targetOpportunity[0].JP_DirectRank__c = 'A';
            targetOpportunity[0].StageName = stageList.get(0);
            targetOpportunity[0].JP_DirectTouchDegree__c = stageNamePicklistEntry.get(0).getValue();
            
            targetOpportunity[1].JP_DirectRank__c = 'A';
            targetOpportunity[1].StageName = stageList.get(0);
            targetOpportunity[1].JP_DirectTouchDegree__c = stageNamePicklistEntry.get(0).getValue();
            update targetOpportunity;
            
            qdList[0].JP_PriceBookEntryId__c = pbEntry[0].Id;
            qdList[1].JP_PriceBookEntryId__c = pbEntry[0].Id;        
            update qdList;
            
            QHeader.add (new JP_QuotationHeader__c ());
            QHeader[1].Name = 'Qheader_00001';
            QHeader[1].JP_PreSave__c = true;
            QHeader[1].JP_QuotationDistCD__c = distibutors[0].Id;
            insert QHeader[1];
            
            QHeader.add (new JP_QuotationHeader__c ());
            QHeader[2].Name = 'Qheader_00002';
            QHeader[2].JP_PreSave__c = true;
            QHeader[2].JP_QuotationDistCD__c = distibutors[0].Id;
            insert QHeader[2];
            
            Test.startTest ();
            // 見積明細が 1 件以上, 選択した商談の直接入力ランクが A, B かつ商品なしの理由が空欄
            System.debug(JP_CopyQuoToOppForLightning.doCopy (QHeader[0].Id, targetOpportunity[0].Id));
            
            // 見積明細が 0 件, 選択した商談の直接入力ランクが A, B かつ商品なしの理由が空欄
            System.debug(JP_CopyQuoToOppForLightning.doCopy (QHeader[1].Id, targetOpportunity[1].Id));
            
            Test.stopTest ();
        }
    }

	// 複数の価格表が混在している場合    
    @isTest
    static void testCopy_MixedPriceBook () {
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
            JP_QuotationHeader__c QHeader = JP_TestUtil.Create_JP_QuotationHeader(1)[0];
            List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
            List<JP_CustomerInfo2__c> ci2List = new List<JP_CustomerInfo2__c>();
            List<JP_DistributorPrice__c> dpList = JP_TestUtil.Create_JP_DistributorPrice(1);
            List<JP_QuotationDistributor__c> distibutors = JP_TestUtil.Create_JP_QuotationDistributor();
            List<JP_QuotationContact__c> qcList = [SELECT Id,Name FROM JP_QuotationContact__c WHERE JP_QuotationDistributor__c = :distibutors[0].id ORDER BY Name];
            Date day = System.today ();
            
            for (JP_DistributorPrice__c dp : dpList){
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
            }
            insert dpList;
            
            QHeader.Name = 'Qheader_00000';
            QHeader.JP_PreSave__c = true;
            insert QHeader;
            
            qdList = JP_TestUtil.Create_JP_QuotationDetail (QHeader.Id, 2);
            for (JP_QuotationDetail__c qd : qdList) {
                qd.JP_QuotationHeader__c = QHeader.Id;
                qd.Name = 'テスト製品';
                qd.JP_DetailsNo__c = 11111;
                qd.JP_ProductCode__c = 'TEST11111';
                qd.JP_ProductCatalogCode__c = '00000';
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
                if (qd.JP_SpecialUnitPrice__c > 0)
                    qd.JP_DeterminedAmount__c = qd.JP_SpecialUnitPriceMulQuantity__c;
                else
                    qd.JP_DeterminedAmount__c = qd.JP_WholeSalePriceMulQuantity__c;
                qd.JP_DiscountLimitPrice__c = 6000;
                qd.JP_QuotationRemarks__c = 'テスト備考';
                qd.JP_RequiredMaintenanceFlag__c = true;
                qd.JP_CampaignDecision__c = true;
                qd.JP_SpecialPriceDecision__c = true;
                qd.JP_DistributorProCode__c = 'DPC1111';
                qd.JP_PriceYearMonth__c = 'JP ' + System.today ().year () + '/';
                if (system.today ().month () - 1 < 10 && System.today ().month () - 1 != 0)
                    qd.JP_PriceYearMonth__c += '0' + (System.today ().month () - 1);
                else if (system.today ().month () - 1 == 0)
                    qd.JP_PriceYearMonth__c += '01';
                else
                    qd.JP_PriceYearMonth__c += system.today ().month () - 1;            
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
            insert qdList;
            
            // 取引先の作成
            Account acc = new Account (Name = 'テスト会社', Phone='0120-123-123');
            insert acc;
            
            // コピー対象の商談を作成
            Opportunity targetOpportunity = JP_TestUtil.Create_Opportunity ();
            targetOpportunity.AccountId = acc.Id;
            
            // 商品の作成
            Product2 prod = new Product2 (Name = 'テスト商品');
            insert prod;
            
            // 価格表を作成
            PriceBook2 pBook = new PriceBook2 ();
            pBook.Name = 'テスト価格表';
            pBook.IsActive = true;
            insert pBook;
            
            PriceBookEntry pbEntry = new PriceBookEntry ();
            pbEntry.Pricebook2Id = Test.getStandardPricebookId ();
            pbEntry.Product2Id = prod.Id;
            pbEntry.UnitPrice = 1000;
            pbEntry.IsActive = true;
            insert pbEntry;
            
            PriceBookEntry pbEntry2 = new PriceBookEntry ();
            pbEntry2.Pricebook2Id = pBook.Id;
            pbEntry2.Product2Id = prod.Id;
            pbEntry2.UnitPrice = 1000;
            pbEntry2.IsActive = true;
            insert pbEntry2;
            
            // 商談商品の作成
            JP_TestUtil.CreateOpportunityLineItem (targetOpportunity.Id, pbEntry.Id);
            
            targetOpportunity.JP_DirectRank__c = 'D';
            update targetOpportunity;
            
            qdList[0].JP_PriceBookEntryId__c = pbEntry.Id;
            qdList[1].JP_PriceBookEntryId__c = pbEntry2.Id;
            update qdList;
            
            Test.startTest ();
            JP_CopyQuoToOppForLightning.doCopy (QHeader.Id, targetOpportunity.Id);
            
            qdList = JP_TestUtil.Create_JP_QuotationDetail (QHeader.Id, 3);
            for (Integer i = 0; i < qdList.size (); i++) {
                JP_QuotationDetail__c qd = qdList[i];
                qd.JP_QuotationHeader__c = QHeader.Id;
                qd.Name = 'テスト製品';
                qd.JP_DetailsNo__c = 11111;
                qd.JP_ProductCode__c = 'TEST11111';
                qd.JP_ProductCatalogCode__c = '00000';
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
                if (qd.JP_SpecialUnitPrice__c > 0)
                    qd.JP_DeterminedAmount__c = qd.JP_SpecialUnitPriceMulQuantity__c;
                else
                    qd.JP_DeterminedAmount__c = qd.JP_WholeSalePriceMulQuantity__c;
                qd.JP_DiscountLimitPrice__c = 6000;
                qd.JP_QuotationRemarks__c = 'テスト備考';
                qd.JP_RequiredMaintenanceFlag__c = true;
                qd.JP_CampaignDecision__c = true;
                qd.JP_SpecialPriceDecision__c = true;
                qd.JP_DistributorProCode__c = 'DPC1111';
                qd.JP_PriceYearMonth__c = 'JP ' + (System.today ().year () + 1) + '/';
                if (system.today ().month () - 1 < 10 && System.today ().month () - 1 != 0)
                    qd.JP_PriceYearMonth__c += '0' + (System.today ().month () - 1);
                else if (system.today ().month () - 1 == 0)
                    qd.JP_PriceYearMonth__c += '01';
                else
                    qd.JP_PriceYearMonth__c += system.today ().month () - 1;            
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
                qd.JP_PriceBookEntryId__c = pbEntry.Id;
            }
            insert qdList;
            
            JP_CopyQuoToOppForLightning.doCopy (QHeader.Id, targetOpportunity.Id);
            Test.stopTest ();
        }
    }
    
    // 価格表が登録されていない場合    
    @isTest
    static void testCopy_NoPriceBook () {
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
            JP_QuotationHeader__c QHeader = JP_TestUtil.Create_JP_QuotationHeader(1)[0];
            List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
            List<JP_CustomerInfo2__c> ci2List = new List<JP_CustomerInfo2__c>();
            List<JP_DistributorPrice__c> dpList = JP_TestUtil.Create_JP_DistributorPrice(1);
            List<JP_QuotationDistributor__c> distibutors = JP_TestUtil.Create_JP_QuotationDistributor();
            List<JP_QuotationContact__c> qcList = [SELECT Id,Name FROM JP_QuotationContact__c WHERE JP_QuotationDistributor__c = :distibutors[0].id ORDER BY Name];
            Date day = System.today ();
            
            for (JP_DistributorPrice__c dp : dpList){
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
            }
            insert dpList;
            
            QHeader.Name = 'Qheader_00000';
            QHeader.JP_PreSave__c = true;
            insert QHeader;
            
            qdList = JP_TestUtil.Create_JP_QuotationDetail (QHeader.Id, 1);
            for (JP_QuotationDetail__c qd : qdList) {
                qd.JP_QuotationHeader__c = QHeader.Id;
                qd.Name = 'テスト製品';
                qd.JP_DetailsNo__c = 11111;
                qd.JP_ProductCode__c = 'TEST11111';
                qd.JP_ProductCatalogCode__c = '00000';
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
                if (qd.JP_SpecialUnitPrice__c > 0)
                    qd.JP_DeterminedAmount__c = qd.JP_SpecialUnitPriceMulQuantity__c;
                else
                    qd.JP_DeterminedAmount__c = qd.JP_WholeSalePriceMulQuantity__c;
                qd.JP_DiscountLimitPrice__c = 6000;
                qd.JP_QuotationRemarks__c = 'テスト備考';
                qd.JP_RequiredMaintenanceFlag__c = true;
                qd.JP_CampaignDecision__c = true;
                qd.JP_SpecialPriceDecision__c = true;
                qd.JP_DistributorProCode__c = 'DPC1111';
                qd.JP_PriceYearMonth__c = 'JP ' + System.today ().year () + '/';
                if (system.today ().month () - 1 < 10 && System.today ().month () - 1 != 0)
                    qd.JP_PriceYearMonth__c += '0' + (System.today ().month () - 1);
                else if (system.today ().month () - 1 == 0)
                    qd.JP_PriceYearMonth__c += '01';
                else
                    qd.JP_PriceYearMonth__c += system.today ().month () - 1;            
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
            insert qdList;
            
            // 取引先の作成
            Account acc = new Account (Name = 'テスト会社', Phone='0120-123-123');
            insert acc;
            
            // コピー対象の商談を作成
            Opportunity targetOpportunity = JP_TestUtil.Create_Opportunity ();
            targetOpportunity.AccountId = acc.Id;
            
            for (JP_QuotationDetail__c qd : qdList)
                qd.JP_PriceBookEntryId__c = null;
            update qdList;
            
            Test.startTest ();
            JP_CopyQuoToOppForLightning.doCopy (QHeader.Id, targetOpportunity.Id);
            Test.stopTest ();
        }
    }
    
    // 仕切表検索キーを作成し、仕切価格表から価格表エントリIDを検索させる
    @isTest
    static void testCopy_WholeSaleKey () {
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
            JP_QuotationHeader__c QHeader = JP_TestUtil.Create_JP_QuotationHeader(1)[0];
            List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
            List<JP_CustomerInfo2__c> ci2List = new List<JP_CustomerInfo2__c>();
            List<JP_DistributorPrice__c> dpList = JP_TestUtil.Create_JP_DistributorPrice(1);
            List<JP_QuotationDistributor__c> distibutors = JP_TestUtil.Create_JP_QuotationDistributor();
            List<JP_QuotationContact__c> qcList = [SELECT Id,Name FROM JP_QuotationContact__c WHERE JP_QuotationDistributor__c = :distibutors[0].id ORDER BY Name];
            Date day = System.today ();
            
            for (JP_DistributorPrice__c dp : dpList){
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
                dp.JP_ProductCatalogCode__c = '00000';
                dp.JP_WholeSaleKey__c = dp.JP_Price_List_Type__c + '_' + dp.JP_ProductCatalogCode__c + '_' + dp.JP_PriceYearMonth__c;
                dp.JP_OutputableQuotation__c  = true;
            }
            insert dpList;
            
            distibutors[0].JP_Price_List_Type__c = '11';
            QHeader.Name = 'Qheader_00000';
            QHeader.JP_PreSave__c = true;
            QHeader.JP_QuotationDistCD__c = distibutors[0].Id;
            insert QHeader;
            
            qdList = JP_TestUtil.Create_JP_QuotationDetail (QHeader.Id, 2);
            for (JP_QuotationDetail__c qd : qdList) {
                qd.JP_QuotationHeader__c = QHeader.Id;
                qd.Name = 'テスト製品';
                qd.JP_DetailsNo__c = 11111;
                qd.JP_ProductCode__c = 'TEST11111';
                qd.JP_ProductCatalogCode__c = '00000';
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
                if (qd.JP_SpecialUnitPrice__c > 0)
                    qd.JP_DeterminedAmount__c = qd.JP_SpecialUnitPriceMulQuantity__c;
                else
                    qd.JP_DeterminedAmount__c = qd.JP_WholeSalePriceMulQuantity__c;
                qd.JP_DiscountLimitPrice__c = 6000;
                qd.JP_QuotationRemarks__c = 'テスト備考';
                qd.JP_RequiredMaintenanceFlag__c = true;
                qd.JP_CampaignDecision__c = true;
                qd.JP_SpecialPriceDecision__c = true;
                qd.JP_DistributorProCode__c = 'DPC1111';
                qd.JP_PriceYearMonth__c = 'JP ' + day.year();
                if(String.valueOf(day.month()).length() == 2)
                    qd.JP_PriceYearMonth__c += '/' + day.month();
                else
                    qd.JP_PriceYearMonth__c += '/0' + day.month();
                        
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
            insert qdList;
            
            // 取引先の作成
            Account acc = new Account (Name = 'テスト会社', Phone='0120-123-123');
            insert acc;
            
            // コピー対象の商談を作成
            Opportunity targetOpportunity = JP_TestUtil.Create_Opportunity ();
            targetOpportunity.AccountId = acc.Id;
            
            // 商品の作成
            Product2 prod = new Product2 (Name = 'テスト商品');
            insert prod;
            
            // 価格表を作成
            PriceBook2 pBook = new PriceBook2 ();
            pBook.Name = 'JP ' + day.year () + (String.valueOf(day.month()).length() == 2 ? '/' : '/0') + day.month ();
            pBook.Description = '11';
            pBook.IsActive = true;
            insert pBook;
            
            List<PriceBookEntry> pbEntry = new List<PriceBookEntry> ();
            pbEntry.add (new PriceBookEntry ());
            pbEntry[0].Pricebook2Id = Test.getStandardPricebookId ();
            pbEntry[0].Product2Id = prod.Id;
            pbEntry[0].UnitPrice = 1000;
            pbEntry[0].IsActive = true;
            pbEntry.add (new PriceBookEntry ());
            pbEntry[1].Pricebook2Id = pBook.Id;
            pbEntry[1].Product2Id = prod.Id;
            pbEntry[1].UnitPrice = 1000;
            pbEntry[1].IsActive = true;
            insert pbEntry;
            
            // 商談商品の作成
            List<String>stageList = System.Label.JP_HighStageName.split(',');
            List<String>rankList = System.Label.JP_HighDirectRank.split(',');
            Schema.DescribeFieldResult stageNameDescribeFieldResult = Opportunity.stageName.getDescribe();
            List<Schema.PicklistEntry> stageNamePicklistEntry = stageNameDescribeFieldResult.getPicklistValues();
            JP_TestUtil.CreateOpportunityLineItem (targetOpportunity.Id, pbEntry[0].Id);
            
            targetOpportunity.JP_DirectRank__c = rankList.get(0);
            targetOpportunity.StageName = stageList.get(0);
            targetOpportunity.JP_DirectTouchDegree__c = stageNamePicklistEntry.get(0).getValue();
            update targetOpportunity;
            
            qdList[0].JP_PriceBookEntryId__c = pbEntry[0].Id;
            qdList[1].JP_PriceBookEntryId__c = null;
            update qdList;
            
            Test.startTest ();
            JP_CopyQuoToOppForLightning.doCopy (QHeader.Id, targetOpportunity.Id);
            
            // DML エラーを発生させる
            JP_CopyQuoToOppForLightning.isDMLexception = 3;
            JP_CopyQuoToOppForLightning.doCopy (QHeader.Id, targetOpportunity.Id);
            Test.stopTest ();
        }
    }
    
    // 仕切価格表から価格表を検索させるが見つからなかった場合
    @isTest
    static void testCopy_WholeSaleKeyNoPriceBook () {
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
            JP_QuotationHeader__c QHeader = JP_TestUtil.Create_JP_QuotationHeader(1)[0];
            List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
            List<JP_CustomerInfo2__c> ci2List = new List<JP_CustomerInfo2__c>();
            List<JP_DistributorPrice__c> dpList = JP_TestUtil.Create_JP_DistributorPrice(1);
            List<JP_QuotationDistributor__c> distibutors = JP_TestUtil.Create_JP_QuotationDistributor();
            List<JP_QuotationContact__c> qcList = [SELECT Id,Name FROM JP_QuotationContact__c WHERE JP_QuotationDistributor__c = :distibutors[0].id ORDER BY Name];
            Date day = System.today ();
            
            for (JP_DistributorPrice__c dp : dpList){
                dp.JP_ExpirvStandardPrice__c = 12000;
                dp.JP_WholeSaleRate__c = 0.7;
                dp.JP_WholeSalePrice__c = 8400;
                dp.JP_SaleStatus__c = '1';
                dp.JP_ReleaseDate__c = String.valueOf(day).replace('/','');
                dp.JP_SalesEndScheduledPeriod__c = String.valueOf(day.addDays(10));
                dp.JP_PriceYearMonth__c = 'JP 0000';
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
                dp.JP_ProductCatalogCode__c = '00000';
                dp.JP_WholeSaleKey__c = dp.JP_Price_List_Type__c + '_' + dp.JP_ProductCatalogCode__c + '_' + dp.JP_PriceYearMonth__c;
                dp.JP_OutputableQuotation__c  = true;
            }
            insert dpList;
            
            QHeader.Name = 'Qheader_00000';
            QHeader.JP_PreSave__c = true;
            QHeader.JP_QuotationDistCD__c = distibutors[0].Id;
            insert QHeader;
            
            qdList = JP_TestUtil.Create_JP_QuotationDetail (QHeader.Id, 2);
            for (JP_QuotationDetail__c qd : qdList) {
                qd.JP_QuotationHeader__c = QHeader.Id;
                qd.Name = 'テスト製品';
                qd.JP_DetailsNo__c = 11111;
                qd.JP_ProductCode__c = 'TEST11111';
                qd.JP_ProductCatalogCode__c = '00000';
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
                if (qd.JP_SpecialUnitPrice__c > 0)
                    qd.JP_DeterminedAmount__c = qd.JP_SpecialUnitPriceMulQuantity__c;
                else
                    qd.JP_DeterminedAmount__c = qd.JP_WholeSalePriceMulQuantity__c;
                qd.JP_DiscountLimitPrice__c = 6000;
                qd.JP_QuotationRemarks__c = 'テスト備考';
                qd.JP_RequiredMaintenanceFlag__c = true;
                qd.JP_CampaignDecision__c = true;
                qd.JP_SpecialPriceDecision__c = true;
                qd.JP_DistributorProCode__c = 'DPC1111';
                qd.JP_PriceYearMonth__c = 'JP 0000';
                if(String.valueOf(day.month()).length() == 2)
                    qd.JP_PriceYearMonth__c += '/' + day.month();
                else
                    qd.JP_PriceYearMonth__c += '/0' + day.month();
                        
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
            insert qdList;
            
            // 取引先の作成
            Account acc = new Account (Name = 'テスト会社', Phone='0120-123-123');
            insert acc;
            
            // コピー対象の商談を作成
            Opportunity targetOpportunity = JP_TestUtil.Create_Opportunity ();
            targetOpportunity.AccountId = acc.Id;
            
            // 商品の作成
            Product2 prod = new Product2 (Name = 'テスト商品');
            insert prod;
            
            // 価格表を作成
            PriceBook2 pBook = new PriceBook2 ();
            pBook.Name = 'JP ' + day.year () + (String.valueOf(day.month()).length() == 2 ? '/' : '/0') + day.month ();
            pBook.Description = '11';
            pBook.IsActive = true;
            insert pBook;
            
            List<PriceBookEntry> pbEntry = new List<PriceBookEntry> ();
            pbEntry.add (new PriceBookEntry ());
            pbEntry[0].Pricebook2Id = Test.getStandardPricebookId ();
            pbEntry[0].Product2Id = prod.Id;
            pbEntry[0].UnitPrice = 1000;
            pbEntry[0].IsActive = true;
            pbEntry.add (new PriceBookEntry ());
            pbEntry[1].Pricebook2Id = pBook.Id;
            pbEntry[1].Product2Id = prod.Id;
            pbEntry[1].UnitPrice = 1000;
            pbEntry[1].IsActive = true;
            insert pbEntry;
            
            // 商談商品の作成
            List<String>stageList = System.Label.JP_HighStageName.split(',');
            List<String>rankList = System.Label.JP_HighDirectRank.split(',');
            Schema.DescribeFieldResult stageNameDescribeFieldResult = Opportunity.stageName.getDescribe();
            List<Schema.PicklistEntry> stageNamePicklistEntry = stageNameDescribeFieldResult.getPicklistValues();
            JP_TestUtil.CreateOpportunityLineItem (targetOpportunity.Id, pbEntry[0].Id);
            
            targetOpportunity.JP_DirectRank__c = rankList.get(0);
            targetOpportunity.StageName = stageList.get(0);
            targetOpportunity.JP_DirectTouchDegree__c = stageNamePicklistEntry.get(0).getValue();
            update targetOpportunity;
            
            qdList[0].JP_PriceBookEntryId__c = pbEntry[0].Id;
            qdList[1].JP_PriceBookEntryId__c = null;
            update qdList;
            
            Test.startTest ();        
            JP_CopyQuoToOppForLightning.doCopy (QHeader.Id, targetOpportunity.Id);
            Test.stopTest ();
        }
    }

   	// 価格表に商品が存在せずその他商品に置き換える場合
	@isTest
    static void testCopy_GetOtherProduct () {
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
            JP_QuotationHeader__c QHeader = JP_TestUtil.Create_JP_QuotationHeader(1)[0];
            List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();
            List<JP_CustomerInfo2__c> ci2List = new List<JP_CustomerInfo2__c>();
            List<JP_DistributorPrice__c> dpList = JP_TestUtil.Create_JP_DistributorPrice(1);
            List<JP_QuotationDistributor__c> distibutors = JP_TestUtil.Create_JP_QuotationDistributor();
            List<JP_QuotationContact__c> qcList = [SELECT Id,Name FROM JP_QuotationContact__c WHERE JP_QuotationDistributor__c = :distibutors[0].id ORDER BY Name];
            Date day = System.today ();
            
            for (JP_DistributorPrice__c dp : dpList){
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
                dp.JP_ProductCatalogCode__c = '00000';
                dp.JP_WholeSaleKey__c = dp.JP_Price_List_Type__c + '_' + dp.JP_ProductCatalogCode__c + '_' + dp.JP_PriceYearMonth__c;
                dp.JP_OutputableQuotation__c  = true;
            }
            insert dpList;
            
            distibutors[0].JP_Price_List_Type__c = '11';
            QHeader.Name = 'Qheader_00000';
            QHeader.JP_PreSave__c = true;
            QHeader.JP_QuotationDistCD__c = distibutors[0].Id;
            insert QHeader;
            
            qdList = JP_TestUtil.Create_JP_QuotationDetail (QHeader.Id, 2);
            for (JP_QuotationDetail__c qd : qdList) {
                qd.JP_QuotationHeader__c = QHeader.Id;
                qd.Name = 'テスト製品';
                qd.JP_DetailsNo__c = 11111;
                qd.JP_ProductCode__c = 'TEST11111';
                qd.JP_ProductCatalogCode__c = '00000';
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
                if (qd.JP_SpecialUnitPrice__c > 0)
                    qd.JP_DeterminedAmount__c = qd.JP_SpecialUnitPriceMulQuantity__c;
                else
                    qd.JP_DeterminedAmount__c = qd.JP_WholeSalePriceMulQuantity__c;
                qd.JP_DiscountLimitPrice__c = 6000;
                qd.JP_QuotationRemarks__c = 'テスト備考';
                qd.JP_RequiredMaintenanceFlag__c = true;
                qd.JP_CampaignDecision__c = true;
                qd.JP_SpecialPriceDecision__c = true;
                qd.JP_DistributorProCode__c = 'DPC1111';
                qd.JP_PriceYearMonth__c = 'JP ' + day.year();
                if(String.valueOf(day.month()).length() == 2)
                    qd.JP_PriceYearMonth__c += '/' + day.month();
                else
                    qd.JP_PriceYearMonth__c += '/0' + day.month();
                        
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
            insert qdList;
            
            // 取引先の作成
            Account acc = new Account (Name = 'テスト会社', Phone='0120-123-123');
            insert acc;
            
            // コピー対象の商談を作成
            Opportunity targetOpportunity = JP_TestUtil.Create_Opportunity ();
            targetOpportunity.AccountId = acc.Id;
            
            // 商品の作成
            Product2 prod = new Product2 (Name = 'その他商品');
            insert prod;
            
            // 価格表を作成
            PriceBook2 pBook = new PriceBook2 ();
            pBook.Name = 'JP ' + day.year () + (String.valueOf(day.month()).length() == 2 ? '/' : '/0') + day.month ();
            pBook.Description = '11';
            pBook.IsActive = true;
            insert pBook;
            
            List<PriceBookEntry> pbEntry = new List<PriceBookEntry> ();
            pbEntry.add (new PriceBookEntry ());
            pbEntry[0].Pricebook2Id = Test.getStandardPricebookId ();
            pbEntry[0].Product2Id = prod.Id;
            pbEntry[0].UnitPrice = 1000;
            pbEntry[0].IsActive = true;
            pbEntry.add (new PriceBookEntry ());
            pbEntry[1].Pricebook2Id = pBook.Id;
            pbEntry[1].Product2Id = prod.Id;
            pbEntry[1].UnitPrice = 1000;
            pbEntry[1].IsActive = true;
            insert pbEntry;
            
            // 商談商品の作成
            List<String>stageList = System.Label.JP_HighStageName.split(',');
            List<String>rankList = System.Label.JP_HighDirectRank.split(',');
            Schema.DescribeFieldResult stageNameDescribeFieldResult = Opportunity.stageName.getDescribe();
            List<Schema.PicklistEntry> stageNamePicklistEntry = stageNameDescribeFieldResult.getPicklistValues();
            JP_TestUtil.CreateOpportunityLineItem (targetOpportunity.Id, pbEntry[0].Id);
            
            targetOpportunity.JP_DirectRank__c = rankList.get(0);
            targetOpportunity.StageName = stageList.get(0);
            targetOpportunity.JP_DirectTouchDegree__c = stageNamePicklistEntry.get(0).getValue();
            update targetOpportunity;
            
            qdList[0].JP_PriceBookEntryId__c = pbEntry[0].Id;
            qdList[1].JP_PriceBookEntryId__c = null;
            update qdList;
            
            Test.startTest ();
            JP_CopyQuoToOppForLightning.doCopy (QHeader.Id, targetOpportunity.Id);
            Test.stopTest ();
        }
    }    
    // DML エラーを発生させるテストメソッド
    @isTest
    static void testCopy_DMLexception () {
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
            JP_QuotationHeader__c QHeader = JP_TestUtil.Create_JP_QuotationHeader(1)[0];
            List<JP_CustomerInfo2__c> ci2List = new List<JP_CustomerInfo2__c>();
            List<JP_DistributorPrice__c> dpList = JP_TestUtil.Create_JP_DistributorPrice(1);
            List<JP_QuotationDistributor__c> distibutors = JP_TestUtil.Create_JP_QuotationDistributor();
            List<JP_QuotationContact__c> qcList = [SELECT Id,Name FROM JP_QuotationContact__c WHERE JP_QuotationDistributor__c = :distibutors[0].id ORDER BY Name];
            Date day = System.today ();
            
            for (JP_DistributorPrice__c dp : dpList){
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
                dp.JP_ProductCatalogCode__c = '00000';
                dp.JP_WholeSaleKey__c = dp.JP_Price_List_Type__c + '_' + dp.JP_ProductCatalogCode__c + '_' + dp.JP_PriceYearMonth__c;
                dp.JP_OutputableQuotation__c  = true;
                System.debug (dp.JP_WholeSaleKey__c);
            }
            insert dpList;
            
            QHeader.Name = 'Qheader_00000';
            QHeader.JP_PreSave__c = true;
            QHeader.JP_QuotationDistCD__c = distibutors[0].Id;
            insert QHeader;
            
            // 取引先の作成
            Account acc = new Account (Name = 'テスト会社', Phone='0120-123-123');
            insert acc;
            
            // コピー対象の商談を作成
            List<Opportunity> targetOpportunity = new List<Opportunity> ();
            for (Integer i = 0; i < 2; i++) {
                Opportunity opp = JP_TestUtil.Create_Opportunity ();
                opp.AccountId = acc.Id;
                targetOpportunity.add (opp);
            }
            
            // 商品の作成
            Product2 prod = new Product2 (Name = 'テスト商品');
            insert prod;
            
            // 価格表を作成
            PriceBook2 pBook = new PriceBook2 ();
            pBook.Name = 'JP ' + day.year () + (String.valueOf(day.month()).length() == 2 ? '/' : '/0') + day.month ();
            pBook.Description = '11';
            pBook.IsActive = true;
            insert pBook;
            
            List<PriceBookEntry> pbEntry = new List<PriceBookEntry> ();
            pbEntry.add (new PriceBookEntry ());
            pbEntry[0].Pricebook2Id = Test.getStandardPricebookId ();
            pbEntry[0].Product2Id = prod.Id;
            pbEntry[0].UnitPrice = 1000;
            pbEntry[0].IsActive = true;
            pbEntry.add (new PriceBookEntry ());
            pbEntry[1].Pricebook2Id = pBook.Id;
            pbEntry[1].Product2Id = prod.Id;
            pbEntry[1].UnitPrice = 1000;
            pbEntry[1].IsActive = true;
            insert pbEntry;
            
            // 商談商品の作成
            JP_TestUtil.CreateOpportunityLineItem (targetOpportunity[1].Id, pbEntry[0].Id);
            
            targetOpportunity[1].JP_DirectRank__c = 'A';
            update targetOpportunity;
        
            Test.startTest ();
            JP_CopyQuoToOppForLightning.isDMLexception = 1;
            JP_CopyQuoToOppForLightning.doCopy (QHeader.Id, targetOpportunity[1].Id);
            JP_CopyQuoToOppForLightning.isDMLexception = 2;
            JP_CopyQuoToOppForLightning.doCopy (QHeader.Id, targetOpportunity[1].Id);
            JP_CopyQuoToOppForLightning.isDMLexception = 4;
            JP_CopyQuoToOppForLightning.doCopy (QHeader.Id, targetOpportunity[1].Id);
            JP_CopyQuoToOppForLightning.isDMLexception = 5;
            JP_CopyQuoToOppForLightning.doCopy (QHeader.Id, targetOpportunity[1].Id);
            JP_CopyQuoToOppForLightning.isDMLexception = 6;
            JP_CopyQuoToOppForLightning.doCopy (QHeader.Id, targetOpportunity[1].Id);
            Test.stopTest ();
        }
    }
    
    // 商談を選択せずにコピーをする場合
    @isTest
    static void testCopy_NoOpportunity () {
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
            JP_QuotationHeader__c QHeader = JP_TestUtil.Create_JP_QuotationHeader(1)[0];
            QHeader.Name = 'Qheader_00000';
            QHeader.JP_PreSave__c = true;
            insert QHeader;
            
            Test.startTest ();
            JP_CopyQuoToOppForLightning.doCopy (QHeader.Id, null);
            Test.stopTest ();
        }
    }
    
    // 製品見積もりの取得
    @isTest
    static void testCopy_getQuotationHeader () {
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
            JP_QuotationHeader__c QHeader = JP_TestUtil.Create_JP_QuotationHeader(1)[0];
            QHeader.Name = 'Qheader_00000';
            QHeader.JP_PreSave__c = true;
            insert QHeader;
            
            Test.startTest ();
            JP_CopyQuoToOppForLightning.getQuotationHeader (QHeader.Id);
            Test.stopTest ();
        }
    }
}