public without sharing class JP_CopyQuotationToOpportunityController {
    //遷移元URL
    @TestVisible private String retURL;
    // 見積情報
    public JP_QuotationHeader__c QHeader {get; private set;}
    // 見積商談コピー時に価格表に存在しない商品だった場合の代替商品
    public final String OTHER_PRODUCT = system.Label.JP_OtherProduct;

    public JP_CopyQuotationToOpportunityController(ApexPages.StandardController stdController) {
        this.QHeader = (JP_QuotationHeader__c)stdController.getRecord();
        // レコード取得
        Id recId = stdController.getRecord().Id;
        if(recId != null){
            this.QHeader = JP_QuotationHeaderDAO.getRecById(recId);
        }
        
        //遷移元URLパラメータ取得
        retURL = ApexPages.currentPage().getParameters().get('retURL');
    }
    
    /**
     * コピーボタン：商談へ見積情報をコピーします
     * @return 商談ページ
     */
    public Pagereference doCopy(){
        PageReference retPage;
        String oppNo = QHeader.JP_OpportunityNo__c;
        String parentId = QHeader.Id;
        String priceYM;
        SET<String> pricebookentries = new SET<String>();
        Set<String> wholeSaleKeySet = new SET<String>();
        List<JP_QuotationDetail__c> updateDetails = new List<JP_QuotationDetail__c>();
        List<OpportunityLineItem> opplines = new List<OpportunityLineItem>();
        Map<String,PriceBookEntry> pbeMap = new Map<String,PriceBookEntry>();
        Map<String, JP_DistributorPrice__c> dpMap = new Map<String, JP_DistributorPrice__c>();

        if(QHeader.JP_OpportunityNo__c != null){
            // 商談を取得
            Opportunity opp = OpportunityDAO.getRecById(QHeader.JP_OpportunityNo__c);
            // 見積明細を取得
            List<JP_QuotationDetail__c> detailList = JP_QuotationDetailDAO.getRecByParentId(QHeader.Id);
            
            // savepoint作成
            Savepoint sp = Database.setSavepoint();
            
            // 商談の価格表を削除
            if(opp.Pricebook2Id != null){
                opp.Pricebook2Id = null;
            }
            // 既存商談商品削除
            List<OpportunityLineItem> oliList = OpportunityLineItemDAO.getOppLineItem(opp.Id);
            if(oliList.size() > 0){
                try{
                    delete oliList;
                }catch(DmlException ex){
                    Database.rollback(sp);
                    for (Integer i = 0; i < ex.getNumDml(); i++) {
                        ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getDmlMessage(i)));
                    }
                    return null;
                }
            }
            
            for(JP_QuotationDetail__c detail : detailList){
                if(priceYM == null && detail.JP_ProductCatalogCode__c != JP_Const.COMMENT_HYPHEN && detail.JP_ProductCatalogCode__c != JP_Const.TOUROKUGAI_Z){
                    priceYM = detail.JP_PriceYearMonth__c;
                }
                if(priceYM != detail.JP_PriceYearMonth__c && detail.JP_ProductCatalogCode__c != JP_Const.COMMENT_HYPHEN && detail.JP_ProductCatalogCode__c != JP_Const.TOUROKUGAI_Z){
                    QHeader.addError(JP_Const.ERR_MESSAGE_COPY_OPPORTUNITY);
                    Database.rollback(sp);
                    return null;
                }
                
                system.debug('■見積明細.価格表エントリＩＤ : ' + detail.JP_PriceBookEntryId__c);
                if(detail.JP_PriceBookEntryId__c != null){
                    if(!pricebookentries.contains(detail.JP_PriceBookEntryId__c)){
                        pricebookentries.add(detail.JP_PriceBookEntryId__c);
                    }
                }else{
                    // 仕切表検索キー作成
                    String wholeSaleKey = QHeader.JP_QuotationDistCD__r.JP_Price_List_Type__c + '_' + detail.JP_ProductCatalogCode__c + '_' + detail.JP_PriceYearMonth__c;
                    if(!wholeSaleKeySet.contains(wholeSaleKey)){
                        wholeSaleKeySet.add(wholeSaleKey);
                    }
                }
            }
            
            // 仕切価格表から価格表エントリIDを検索
            if(wholeSaleKeySet.size() > 0){
                // 代理店仕切価格表取得
                dpMap = JP_DistributorPriceDAO.getDistributorPriceByKeyset(wholeSaleKeySet);
                if(!dpMap.isEmpty()){
                    for(JP_QuotationDetail__c detail : detailList){
                        String wholeSaleKey = QHeader.JP_QuotationDistCD__r.JP_Price_List_Type__c + '_' + detail.JP_ProductCatalogCode__c + '_' + detail.JP_PriceYearMonth__c;
                        if(dpMap.containsKey(wholeSaleKey)){
                            detail.JP_PriceBookEntryId__c = dpMap.get(wholeSaleKey).JP_PriceBookEntryId__c;
                            updateDetails.add(detail);
                            pricebookentries.add(detail.JP_PriceBookEntryId__c);
                        }
                    }
                }
            }
            
            // 価格表エントリIDを入力された見積明細を更新
            if(updateDetails.size() > 0){
                try{
                    update updateDetails;
                }catch(DmlException ex){
                    Database.rollback(sp);
                    for (Integer i = 0; i < ex.getNumDml(); i++) {
                        ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getDmlMessage(i)));
                    }
                    return null;
                }
            }
            
            pbeMap = PriceBookEntryDAO.getRecMapById(pricebookentries);
            
            
            // 商談に価格表に、見積明細の価格表エントリIDから価格表を取得しセット
            for(JP_QuotationDetail__c detail : detailList){
                if(pbeMap.containsKey(detail.JP_PriceBookEntryId__c)){
                    PriceBookEntry pbe = pbeMap.get(detail.JP_PriceBookEntryId__c);
                    opp.Pricebook2Id = pbe.PriceBook2Id;
                    break;
                }
            }
            
            // 価格表エントリから価格表を特定できなかった場合、見積明細の価格年月と同年月の価格表を設定する
            if(opp.Pricebook2Id == null){
                List<PriceBook2> pbList = PriceBookDAO.getPriceBookThisMonth(QHeader.JP_QuotationDistCD__r.JP_Price_List_Type__c, priceYM);
                if(pbList.size() > 0){
                    opp.Pricebook2Id = pbList[0].Id;
                }else{
                    Date nowDate = system.today();
                    priceYM = 'JP ' + nowDate.year();
                    if(String.valueOf(nowDate.month()).length() == 2){
                        priceYM += '/' + nowDate.month();
                    }else{
                        priceYM += '/0' + nowDate.month();
                    }
                    List<PriceBook2> pbList2 = PriceBookDAO.getPriceBookThisMonth(QHeader.JP_QuotationDistCD__r.JP_Price_List_Type__c, priceYM);
                    if(pbList2.size() > 0){
                        opp.Pricebook2Id = pbList2[0].Id;
                    }else{
                        QHeader.addError(priceYM + 'の価格表が登録されていません');
                        Database.rollback(sp);
                        return null;
                    }
                }
            }
        
            // 商談に見積書番号をセット
            opp.JP_QuoteId__c = QHeader.JP_QuotationNo__c;
            // SPMS　連携日時に現在日時をセット
            opp.JP_SPMSCooperationdate__c = system.now();
            
            // 商談を更新
            try{
                update opp;
            }catch(Exception ex){
                Database.rollback(sp);
                for (Integer i = 0; i < ex.getNumDml(); i++) {
                    ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getDmlMessage(i)));
                }
                return null;
            }
            
            system.debug('■価格表エントリマップキーセット : ' + pbeMap.keySet());

            // 商談商品作成
            for(JP_QuotationDetail__c detail : detailList){
                if(detail.JP_ProductCatalogCode__c != JP_Const.COMMENT_HYPHEN){
                    OpportunityLineItem oli = new OpportunityLineItem();
                    oli.OpportunityId = opp.Id;
                    oli.Quantity = detail.JP_Quantity__c;
                    oli.JP_SortOrder__c = Integer.valueOf(detail.JP_Sort__c);
                    oli.Description = detail.JP_QuotationRemarks__c;
                    oli.TotalPrice = detail.JP_DeterminedAmount__c;
                    
                    // 価格表エントリを設定
                    system.debug('■価格表エントリID : ' + detail.JP_PriceBookEntryId__c);
                    system.debug('■価格表エントリ存在チェック ： ' + pbeMap.containsKey(detail.JP_PriceBookEntryId__c));
                    if(pbeMap.containsKey(detail.JP_PriceBookEntryId__c)){
                        PriceBookEntry pbe = pbeMap.get(detail.JP_PriceBookEntryId__c);
                        if(pbe.PriceBook2Id == opp.PriceBook2Id){
                            oli.PriceBookEntryId = pbe.Id;
                            opplines.add(oli);
                        }else{
                            oli.PriceBookEntryId.addError(JP_Const.ERR_MESSAGE_COPY_OPPORTUNITY);
                            Database.rollback(sp);
                            return null;
                        }
                    }else{
                        // 価格表に商品が存在しなかった場合はその他商品に置き換えてセット
                        system.debug('■その他商品');
                        system.debug('■■価格表ＩＤ ： ' + opp.Pricebook2Id);
                        if(opp.Pricebook2Id != null){
                            List<PriceBookEntry> pbeList = PriceBookEntryDAO.getOtherProduct(opp.Pricebook2Id);
                            if(pbeList.size() > 0){
                                oli.PriceBookEntryId = pbeList[0].Id;
                                opplines.add(oli);
                            }else{
                                QHeader.addError('商品が存在しません');
                                Database.rollback(sp);
                                return null;
                            }
                        }
                    }
                }
            }
            
            try{
                insert opplines;
                retPage = new PageReference('/' + opp.Id);
                return retPage;
            }catch(DmlException ex){
                Database.rollback(sp);
                for (Integer i = 0; i < ex.getNumDml(); i++) {
                    ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getDmlMessage(i)));
                }
                return null;
            }
        }else{
            QHeader.JP_OpportunityNo__c.addError('商談が選択されていません');
            return null;
        }
    }
}