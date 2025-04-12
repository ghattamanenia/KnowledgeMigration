global with sharing class JP_CopyQuotationToQuotation {

    /*
    * 見積コピー
    * @param JP_QuotationＨｅａｄｅｒ__c.Id id
    * @param Boolean takeoverFlg
    * @return ID JP_QuotationＨｅａｄｅｒ__c.Id
    */
     webservice static String copyQuotationtoQuotation(String id, Boolean takeoverFlg){
        // コピー先製品見積
        JP_QuotationHeader__c destQH = new JP_QuotationHeader__c();
        // コピー元製品見積り
        JP_QuotationHeader__c srcQH = JP_QuotationHeaderDAO.getRecByIdUseFieldSet(id);
        // コピー先見積明細リスト
        List<JP_QuotationDetail__c> destList = new List<JP_QuotationDetail__c>();
        // コピー元見積明細リスト
        List<JP_QuotationDetail__c> srcList = JP_QuotationDetailDAO.getRecByIdUseFieldSet(id);
        // 製品見積項目セット
        List<Schema.FieldSetMember> schemaParent = SObjectType.JP_QuotationHeader__c.FieldSets.CopyItemToQuotation.getFields();
        // 見積明細項目セット
        List<Schema.FieldSetMember> schemaChildren = SObjectType.JP_QuotationDetail__c.FieldSets.CopyItemToQuotation.getFields();
        
        /**
         * 20170623 Terrasky yorikasa Add
         * エラー条件追加
         */
        system.debug('*** srcQH.JP_QuotationDistCD__r.JP_QuotationCreatableFlag__c : ' + srcQH.JP_QuotationDistCD__r.JP_QuotationCreatableFlag__c);
        system.debug('*** srcQH.JP_QuotationDistCD__r.JP_DistributorActiveFlag__c : ' + srcQH.JP_QuotationDistCD__r.JP_DistributorActiveFlag__c);
        system.debug('*** srcQH.JP_QuotationDistCD__r.JP_EffectiveFlagForMainDistributor__c : ' + srcQH.JP_QuotationDistCD__r.JP_EffectiveFlagForMainDistributor__c);
        
        // JP_QuotationDistCD__cのルックアップ条件に該当しない場合エラー
        if(!(srcQH.JP_QuotationDistCD__r.JP_QuotationCreatableFlag__c
            && srcQH.JP_QuotationDistCD__r.JP_DistributorActiveFlag__c
            && srcQH.JP_QuotationDistCD__r.JP_EffectiveFlagForMainDistributor__c)
        ){
            return JP_Const.JP_QUOTE_COPY_MESSAGE_DISTRIBUTOR_INACTIVE;
        }else if(srcQH.JP_QuotationNo__c.right(1) == 'Z'){
            return JP_Const.JP_QUOTE_COPY_MESSAGE_OVER_BRANCH_NUMBER;
        }
        
        // savepoint作成
        Savepoint sp = Database.setSavepoint();
        
        // 製品見積コピー
        for(integer i = 0; i < schemaParent.size(); i++){
            destQH.put(schemaParent[i].getFieldPath(), srcQH.get(schemaParent[i].getFieldPath()));
        }
        
        if(takeoverFlg != true){
            destQH.JP_QuotationNo__c = NULL;
        }
        
        /** 明細自動フラグON 
        　　　　    *   2016/02/26
          */
        destQH.JP_AutoSumFlg__c = true;
        
        destQH.JP_PreSave__c = true;
        destQH.JP_QuotationCopyNo__c = srcQH.JP_QuotationNo__c;
        
        try{
            insert destQH;
        }catch(Exception ex){
            destQH.addError(ex.getMessage());
            Database.rollback(sp);
            return null;
        }
        
        // 見積明細コピー
        List<JP_QuotationDetail__c> qdList = getLatestDistributorPrice(srcQH, srcList);
        system.debug('========== end getLatestDistributorPrice ==========');
        for(JP_QuotationDetail__c srcQD : qdList){
            JP_QuotationDetail__c destQD = new JP_QuotationDetail__c();
            
            for(integer i = 0; i < schemaChildren.size(); i++){
                system.debug('◆◆◆◆◆ srcQD.get(schemaChildren[i].getFieldPath() : ' + srcQD.get(schemaChildren[i].getFieldPath()));
                destQD.put(schemaChildren[i].getFieldPath(), srcQD.get(schemaChildren[i].getFieldPath()));
            }
            
            destQD.JP_QuotationHeader__c = destQH.Id;
            destQD.JP_PreSave__c = true;
            
            if(destQD.JP_ProductCatalogCode__c != JP_Const.COMMENT_HYPHEN){
                reCalculateField(destQH.JP_InputUnitPrice__c, destQD);
            }
            
            destList.add(destQD);
            
            system.debug('====================');
            system.debug('***** destQD.JP_Category1__c : ' + destQD.JP_Category1__c);
            system.debug('***** destQD.JP_Category2__c : ' + destQD.JP_Category2__c);
            system.debug('***** destQD.JP_Maker__c : ' + destQD.JP_Maker__c);
            system.debug('***** destQD.JP_PriceBookEntryId__c : ' + destQD.JP_PriceBookEntryId__c);
            system.debug('====================');
        }
        

        try{
            insert destList;
        }catch(Exception ex){
            system.debug('■■■■■ Error ： ' + ex.getMessage());
            Database.rollback(sp);
            return null;
        }
        
        /*
         * 2015/12/18 terrasky update start
         * 顧客情報2コピー 
        */
        system.debug('=========== 顧客情報2コピー ==========');
        List<JP_CustomerInfo2__c> destCI2List = new List<JP_CustomerInfo2__c>();
        List<JP_CustomerInfo2__c> srcCI2List = new List<JP_CustomerInfo2__c>();
        srcCI2List = JP_CustomerInfo2Dao.getRecsByQuoteId(srcQH.Id);
        
        if(srcCI2List.size() > 0){
            for(JP_CustomerInfo2__c srcCI2 : srcCI2List){
                JP_CustomerInfo2__c destCI2 = new JP_CustomerInfo2__c();
                destCI2 = srcCI2.clone(false,true);
                destCI2.JP_QuotationHeader__c = destQH.Id;
                destCI2.JP_Uniquekey__c = null;
                destCI2List.add(destCI2);
            }
            
            try{
                insert destCI2List;
            }catch(Exception ex){
                Database.rollback(sp);
                return null;
            }
        }
        /*
         * 2015/12/18 update end
        */
        
        return destQH.Id;
     }

     static List<JP_QuotationDetail__c> getLatestDistributorPrice(JP_QuotationHeader__c srcQH, List<JP_QuotationDetail__c> srcList){
        system.debug('========== Start getLatestDistributorPrice ==========');
        Set<String> productCatalogCodeSet = new Set<String>();
        Set<String> wholeSaleKeySet = new Set<String>();
        Map<String, List<JP_QuotationDetail__c>> qdMap = new Map<String, List<JP_QuotationDetail__c>>();
        Map<String, JP_DistributorPrice__c> dpMap = new Map<String, JP_DistributorPrice__c>();
        
        // 時点年月（月初日）
        Date nowDate = system.today();
        Date thisMonthFirst = Date.newInstance(nowDate.year(),nowDate.month(),1);
        
        // 今月の価格年月
        String priceYM_ThisMonth = 'JP ' + nowDate.year();
        if(String.valueOf(nowDate.month()).length() == 2){
            priceYM_ThisMonth += '/' + nowDate.month();
        }else{
            priceYM_ThisMonth += '/0' + nowDate.month();
        }

        for (JP_QuotationDetail__c qd : srcList) {
            if(qd.JP_ProductCatalogCode__c != JP_Const.TOUROKUGAI_Z && qd.JP_ProductCatalogCode__c != JP_Const.COMMENT_HYPHEN && qd.JP_PriceYearMonth__c != null){
                system.debug('◆◆◆◆◆ 登録商品 ◆◆◆◆◆');
                system.debug('■価格年月 ： ' + qd.JP_PriceYearMonth__c);
                // 価格年月
                String priceYM = qd.JP_PriceYearMonth__c;
                // 価格年月（月初日）
                Date priceYMFirst;
                if(qd.JP_PriceYearMonth__c.length() >= 10){
                    priceYMFirst = Date.newInstance(Integer.valueOf(qd.JP_PriceYearMonth__c.subString(3,7)), Integer.valueOf(qd.JP_PriceYearMonth__c.subString(8,10)), 1);
                }else{
                    priceYMFirst = Date.newInstance(Integer.valueOf(qd.JP_PriceYearMonth__c.subString(3,7)), Integer.valueOf(qd.JP_PriceYearMonth__c.subString(8,10)), 1);
                }
                system.debug('◆◆◆ priceYMFirst : ' + priceYMFirst);
                
                // 価格年月が過去年月だったら時点年月をセット
                if(priceYMFirst < thisMonthFirst){
                    priceYM = priceYM_ThisMonth;
                }
                
                // 仕切表検索キー作成
                String wholeSaleKey = srcQH.JP_QuotationDistCD__r.JP_Price_List_Type__c + '_' + qd.JP_ProductCatalogCode__c + '_' + priceYM;
                
                system.debug('********** wholeSaleKey : ' + wholeSaleKey + ' **********');
                
                if(!wholeSaleKeySet.contains(wholeSaleKey)){
                    wholeSaleKeySet.add(wholeSaleKey);
                }
            }
        }
        
        // 代理店仕切価格表取得
        dpMap = JP_DistributorPriceDAO.getDistributorPriceByKeyset(wholeSaleKeySet);
        
        system.debug('********** dpMap.keySet() : ' + dpMap.keySet() + ' **********');
        
        if(dpMap.keySet().size() > 0){
            // 代理店仕切価格表取得
            List<JP_DistributorPrice__c> dpList = dpMap.values();

            // 代理店専用製品コード取得し990コードでマッピング
            Set<String> productCodeSet = new Set<String>();
            for (JP_DistributorPrice__c dp : dpList) {
                productCodeSet.add(dp.JP_ProductCode__c);
            }
            
            system.debug('********** productCodeSet **********');
            system.debug(productCodeSet);
            
            Map<String, JP_DistributorProductCode__c> dpcMap = new Map<String, JP_DistributorProductCode__c>();
            for (JP_DistributorProductCode__c dpc : JP_DistributorProductCodeDAO.selectDistributorProCode(
                    srcQH.JP_QuotationDistCD__r.JP_MainDistributorCode__c,
                    productCodeSet)) {
                        dpcMap.put(dpc.JP_ProductCode__c, dpc);
            }
    
            for(JP_QuotationDetail__c qd : srcList){
                if(qd.JP_ProductCatalogCode__c != JP_Const.TOUROKUGAI_Z  && qd.JP_ProductCatalogCode__c != JP_Const.COMMENT_HYPHEN && qd.JP_PriceYearMonth__c != null){
                    // 価格年月
                    String priceYM = qd.JP_PriceYearMonth__c;
                    // 価格年月（月初日）
                    Date priceYMFirst = Date.newInstance(Integer.valueOf(qd.JP_PriceYearMonth__c.subString(3,7)), Integer.valueOf(qd.JP_PriceYearMonth__c.subString(8,10)), 1);
                    
                    // 価格年月が過去年月だったら時点年月をセット
                    if(priceYMFirst < thisMonthFirst){
                        priceYM = priceYM_ThisMonth;
                    }
                    
                    // 仕切表検索キー作成
                    String wholeSaleKey = srcQH.JP_QuotationDistCD__r.JP_Price_List_Type__c + '_' + qd.JP_ProductCatalogCode__c + '_' + priceYM;
                    
                    if(dpMap.containsKey(wholeSaleKey)){
                        JP_DistributorPrice__c dp = dpMap.get(wholeSaleKey);
                        // 代理店専用製品コードセット
                        if(dpcMap.containsKey(dp.JP_ProductCode__c)){
                            JP_DistributorProductCode__c dpc = dpcMap.get(dp.JP_ProductCode__c);
                            qd.JP_DistributorProCode__c = dpc.JP_DistributorProCode__c;
                        }
                        
                        // 明細に代理店仕切価格表の値をセット
                        setDistributorPriceInfoToDetail(qd, dp);
                        system.debug('********** JP_PriceBookEntryId **********');
                        system.debug(qd.JP_PriceBookEntryId__c);
                    }
                }
            }
        }
        
        return srcList;
     }
     
     /**
     * 代理店仕切価格表の項目を見積明細へセットします
     * @param qd 見積明細
     * @param dp 代理店仕切価格表
     */
    @TestVisible
    static void setDistributorPriceInfoToDetail(JP_QuotationDetail__c qd, JP_DistributorPrice__c dp) {
        system.debug('========== Start setDistributorPriceInfoToDetail ==========');
        qd.JP_StandardPrice__c = dp.JP_ExpirvStandardPrice__c;
        qd.JP_WholeSaleRate__c = dp.JP_WholeSaleRate__c;
        qd.JP_SalesStatus__c = dp.JP_SaleStatus__c;
        qd.JP_ReleaseScheduled__c = dp.JP_ReleaseDate__c;
        qd.JP_SalesEndScheduled__c = dp.JP_SalesEndScheduledPeriod__c;
        qd.JP_PriceYearMonth__c = dp.JP_PriceYearMonth__c;
        qd.JP_DiscountLimitPrice__c = dp.JP_ExpirvDiscountLimit__c;
        qd.JP_RequiredMaintenanceFlag__c = dp.JP_RequiredMaintenanceFlag__c;
        qd.JP_AppGroupID__c = dp.JP_AppGroupID__c;
        qd.JP_5PercentDiscount__c = dp.JP_5PercentDiscount__c;
        qd.JP_SupportTicketCode__c = dp.JP_SupportTicketClassificationCode__c;
        qd.JP_PreRelease__c = dp.JP_PreRelease__c;
        qd.JP_Category1__c = dp.JP_Category1__c;
        qd.JP_Category2__c = dp.JP_Category2__c;
        qd.JP_Maker__c = dp.JP_Maker__c;
        qd.JP_PiStock__c = dp.JP_PiStock__c;
        qd.JP_PriceBookEntryId__c = dp.JP_PriceBookEntryId__c;
        qd.JP_UnitPrice__c = dp.JP_WholeSalePrice__c;
        // キャンペーン判定
        if(dp.JP_CampaignStartDate__c != null){
            qd.JP_CampaignDecision__c = true;
        }else{
            qd.JP_CampaignDecision__c = false;
        }
    }
    
    /**
     * 見積明細の項目を再計算します
     * @param qd 見積明細
     */
    static void reCalculateField(Boolean JP_InputUnitPrice, JP_QuotationDetail__c qd){
        system.debug('========== Start reCalculateField ==========');
        // 仕切単価×数量
        if(qd.JP_UnitPrice__c != null && qd.JP_Quantity__c != null){
            qd.JP_WholeSalePriceMulQuantity__c = qd.JP_UnitPrice__c * qd.JP_Quantity__c;
        }
        
        if(JP_InputUnitPrice == false){
            if(qd.JP_SpecialWholeSaleTRate__c != null && qd.JP_SpecialWholeSaleTRate__c != 0){
                if(qd.JP_StandardPrice__c != null && qd.JP_StandardPrice__c != 0){
                    // 特別仕切単価
                    qd.JP_SpecialUnitPrice__c = Math.floor(qd.JP_StandardPrice__c * qd.JP_SpecialWholeSaleTRate__c / 10) * 10;
                }
                if(qd.JP_SpecialUnitPrice__c != null && qd.JP_SpecialUnitPrice__c != 0 && qd.JP_Quantity__c != null && qd.JP_Quantity__c != 0){
                    // 特別仕切単価×数量
                    qd.JP_SpecialUnitPriceMulQuantity__c = qd.JP_SpecialUnitPrice__c * qd.JP_Quantity__c;
                }
                if(qd.JP_WholeSalePriceMulQuantity__c != null && qd.JP_WholeSalePriceMulQuantity__c != 0 && qd.JP_SpecialUnitPriceMulQuantity__c != null && qd.JP_SpecialUnitPriceMulQuantity__c != 0){
                    // 差額（通常-特価）
                    qd.JP_StandardMinusSpecial__c = qd.JP_WholeSalePriceMulQuantity__c - qd.JP_SpecialUnitPriceMulQuantity__c;
                }
            }
        }else{
            if(qd.JP_SpecialUnitPrice__c != null && qd.JP_SpecialUnitPrice__c != 0){
                if(qd.JP_StandardPrice__c != null && qd.JP_StandardPrice__c != 0){
                    // 特別仕切率
                    qd.JP_SpecialWholeSaleTRate__c = qd.JP_SpecialUnitPrice__c / qd.JP_StandardPrice__c;
                }
                if(qd.JP_Quantity__c != null && qd.JP_Quantity__c != 0){
                    // 特別仕切単価×数量
                    qd.JP_SpecialUnitPriceMulQuantity__c = qd.JP_SpecialUnitPrice__c * qd.JP_Quantity__c;
                }
                if(qd.JP_WholeSalePriceMulQuantity__c != null && qd.JP_WholeSalePriceMulQuantity__c != 0 && qd.JP_SpecialUnitPriceMulQuantity__c != null && qd.JP_SpecialUnitPriceMulQuantity__c != 0){
                    // 差額（通常-特価）
                    qd.JP_StandardMinusSpecial__c = qd.JP_WholeSalePriceMulQuantity__c - qd.JP_SpecialUnitPriceMulQuantity__c;
                }
            }
        }
            
        // 確定金額
        if (qd.JP_SpecialUnitPrice__c > 0) {
            qd.JP_DeterminedAmount__c = qd.JP_SpecialUnitPriceMulQuantity__c;
        } else {
            qd.JP_DeterminedAmount__c = qd.JP_WholeSalePriceMulQuantity__c;
        }

        // 特価判定
        if(qd.JP_StandardMinusSpecial__c != null && qd.JP_StandardMinusSpecial__c > 0){
            qd.JP_SpecialPriceDecision__c = true;
        }else{
            qd.JP_SpecialPriceDecision__c = false;
        }
        
        // 値引限度額超
        if( qd.JP_SpecialUnitPrice__c == 0 || qd.JP_SpecialUnitPrice__c == null){
            if(qd.JP_UnitPrice__c < qd.JP_DiscountLimitPrice__c){
                qd.JP_OverLimitDiscount__c = true;
            }else{
                qd.JP_OverLimitDiscount__c = false;
            }
        }else if (qd.JP_SpecialUnitPrice__c < qd.JP_DiscountLimitPrice__c) {
            qd.JP_OverLimitDiscount__c = true;
        } else {
            qd.JP_OverLimitDiscount__c = false;
        }
    }
    
    public class HeaderException extends Exception {}
}