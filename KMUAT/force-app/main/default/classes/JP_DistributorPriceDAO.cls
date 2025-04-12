/**
 * 代理店仕切り価格表Dao
 */
public with sharing class JP_DistributorPriceDAO {
    /**
     * 見積画面商品検索用
     * @param catalogCodeSet 商品コードセット
     * @param priceListType Price List Type
     * @param priceYearMonth 価格年月
     * @return 検索条件に一致した代理店仕切価格表リスト 
     */
    public static List<JP_DistributorPrice__c> selectForQuotationEdit(Set<String> catalogCodeSet, String priceListType, String priceYearMonth) {
        system.debug('========== Start selectForQuotationEdit ==========');
        system.debug('********** catalogCodeSet : ' + catalogCodeSet + ' **********');
        system.debug('********** priceListType : ' + priceListType + ' **********');
        system.debug('********** priceYearMonth : ' + priceYearMonth + ' **********');
        
        Set<String> key1Set = new Set<String>();
        String key2;

        for(String catalogCode : catalogCodeSet){
            system.debug('========== key1Set ==========' + priceListType + '_' + catalogCode);
            key1Set.add(priceListType + '_' + catalogCode);
        }
        key2 = priceListType + '_' + priceYearMonth;
        system.debug('========== key2 ==========' + key2);
        return
            [
            select
                Id,
                JP_5PercentDiscount__c,
                JP_AppGroupID__c,
                JP_CampaignClassificationCode__c,
                JP_CampaignContent__c,
                JP_CampaignDiscountLimitPrice__c,
                JP_CampaignEndDate__c,
                JP_CampaignName__c,
                JP_CampaignPurpose__c,
                JP_CampaignStandardPriceTaxOff__c,
                JP_CampaignStartDate__c,
                JP_CampaignWholeSaleRate_A__c,
                JP_CampaignWholeSaleRate_B__c,
                JP_CampaignWholeSaleRate_C__c,
                JP_CampaignWholeSaleRate_D__c,
                JP_CategoryCode__c,
                JP_Category1__c,
                JP_DiscountLimitPrice__c,
                JP_ExpirvDiscountLimit__c,
                JP_ExpirvStandardPrice__c,
                JP_MakerCode__c,
                JP_Maker__c,
                JP_OpenPriceFlag__c,
                JP_OutputableQuotation__c,
                JP_PriceChangedDate__c,
                JP_PriceYearMonth__c,
                JP_Price_List_Type__c,
                JP_ProductCatalogCode__c,
                JP_ProductCode__c,
                JP_ProductName__c,
                JP_QuotationRemarks__c,
                JP_RefPriceTaxOff__c,
                JP_ReleaseDate__c,
                JP_RequiredMaintenanceFlag__c,
                JP_SaleStatus__c,
                JP_SalesEndScheduledPeriod__c,
                JP_StandardPriceTaxOff__c,
                JP_SupportTicketClassificationCode__c,
                JP_WholeSaleKey__c,
                JP_WholeSalePrice_SpecailAboveCampaign__c,
                JP_WholeSalePrice_SpecailAboveStandard__c,
                JP_WholeSalePrice_Standard__c,
                JP_WholeSalePrice__c,
                JP_WholeSaleRate_A__c,
                JP_WholeSaleRate_B__c,
                JP_WholeSaleRate_C__c,
                JP_WholeSaleRate_D__c,
                JP_WholeSaleRate__c,
                JP_WholeSale_CampaignAboveStandardRate__c,
                JP_WholeSale_SpecialAboveCampaignRate__c,
                JP_WholeSale_SpecialAboveStandardRate__c,
                JP_WholeSale_StandardRate__c,
                JP_PreRelease__c,
                JP_PiStock__c,
                JP_RentCharge__c,
                JP_RentOverageChargesPerDay__c,
                JP_Category2__c,
                JP_IsSpecialDistributorProduct__c,
                JP_PriceBookEntryId__c,
                JP_CampaignDecision__c
            from
                JP_DistributorPrice__c
            where
                JP_SearchItemKey1__c IN:key1Set
            and
                JP_SearchItemKey2__c = :key2
            and
                JP_OutputableQuotation__c = true
            ];

    }
    
    /**
     * 見積画面商品検索用
     * @param wholeSaleKeySet 仕切表キーセット
     * @return 検索条件に一致した代理店仕切価格表の仕切表キーをKeyとした代理店仕切価格表のマップ
     */
    public static Map<String, JP_DistributorPrice__c> getDistributorPriceByKeyset(Set<String> wholeSaleKeySet) {
        system.debug('========== Start getDistributorPriceByKeyset ==========');
        Map<String, JP_DistributorPrice__c> dpMap = new Map<String, JP_DistributorPrice__c>();
        List<JP_DistributorPrice__c> dpList = new List<JP_DistributorPrice__c>();
        
        dpList = [select
                    Id,
                    JP_5PercentDiscount__c,
                    JP_AppGroupID__c,
                    JP_CampaignClassificationCode__c,
                    JP_CampaignContent__c,
                    JP_CampaignDiscountLimitPrice__c,
                    JP_CampaignEndDate__c,
                    JP_CampaignName__c,
                    JP_CampaignPurpose__c,
                    JP_CampaignStandardPriceTaxOff__c,
                    JP_CampaignStartDate__c,
                    JP_CampaignWholeSaleRate_A__c,
                    JP_CampaignWholeSaleRate_B__c,
                    JP_CampaignWholeSaleRate_C__c,
                    JP_CampaignWholeSaleRate_D__c,
                    JP_CategoryCode__c,
                    JP_Category1__c,
                    JP_DiscountLimitPrice__c,
                    JP_ExpirvDiscountLimit__c,
                    JP_ExpirvStandardPrice__c,
                    JP_MakerCode__c,
                    JP_Maker__c,
                    JP_OpenPriceFlag__c,
                    JP_OutputableQuotation__c,
                    JP_PriceChangedDate__c,
                    JP_PriceYearMonth__c,
                    JP_Price_List_Type__c,
                    JP_ProductCatalogCode__c,
                    JP_ProductCode__c,
                    JP_ProductName__c,
                    JP_QuotationRemarks__c,
                    JP_RefPriceTaxOff__c,
                    JP_ReleaseDate__c,
                    JP_RequiredMaintenanceFlag__c,
                    JP_SaleStatus__c,
                    JP_SalesEndScheduledPeriod__c,
                    JP_StandardPriceTaxOff__c,
                    JP_SupportTicketClassificationCode__c,
                    JP_WholeSaleKey__c,
                    JP_WholeSalePrice_SpecailAboveCampaign__c,
                    JP_WholeSalePrice_SpecailAboveStandard__c,
                    JP_WholeSalePrice_Standard__c,
                    JP_WholeSalePrice__c,
                    JP_WholeSaleRate_A__c,
                    JP_WholeSaleRate_B__c,
                    JP_WholeSaleRate_C__c,
                    JP_WholeSaleRate_D__c,
                    JP_WholeSaleRate__c,
                    JP_WholeSale_CampaignAboveStandardRate__c,
                    JP_WholeSale_SpecialAboveCampaignRate__c,
                    JP_WholeSale_SpecialAboveStandardRate__c,
                    JP_WholeSale_StandardRate__c,
                    JP_PreRelease__c,
                    JP_PiStock__c,
                    JP_RentCharge__c,
                    JP_RentOverageChargesPerDay__c,
                    JP_Category2__c,
                    JP_IsSpecialDistributorProduct__c,
                    JP_PriceBookEntryId__c,
                    JP_CampaignDecision__c
                from
                    JP_DistributorPrice__c
                where
                    JP_WholeSaleKey__c IN:wholeSaleKeySet
                and
                    JP_OutputableQuotation__c = true
                ];
                
        for(JP_DistributorPrice__c dp : dpList){
            if(!dpMap.containsKey(dp.JP_WholeSaleKey__c)){
                dpMap.put(dp.JP_WholeSaleKey__c, dp);
            }
        }
        return dpMap;
    }

    /**
     * 製品検索画面用
     *
     *  @param jpdp 代理店仕切価格表レコード
     * @param priceListType Price List Type
     *
     * @return 検索条件に一致した代理店仕切価格表リスト 
     */
    public static List<JP_DistributorPrice__c> selectListForProductSearch(JP_DistributorPrice__c jpdp, String priceListType, String priceYearMonth){

        //検索結果項目
        String query = 'SELECT Id ' + 
                                ',Name ' +
                                ',JP_ProductCatalogCode__c ' +          //商品コード
                                ',JP_ProductCode__c ' +                 //990コード
                                ',JP_ProductName__c ' +                 //製品名
                                ',JP_5PercentDiscount__c ' +
                                ',JP_AppGroupID__c ' +
                                ',JP_CampaignClassificationCode__c ' +
                                ',JP_CampaignContent__c ' +
                                ',JP_CampaignDiscountLimitPrice__c ' +
                                ',JP_CampaignName__c ' +
                                ',JP_CampaignPurpose__c ' +
                                ',JP_CampaignStandardPriceTaxOff__c ' +
                                ',JP_CampaignStartDate__c ' +           //キャンベーン開始日
                                ',JP_CampaignEndDate__c ' +             //キャンペーン終了日
                                ',JP_CampaignWholeSaleRate_A__c ' +
                                ',JP_CampaignWholeSaleRate_B__c ' +
                                ',JP_CampaignWholeSaleRate_C__c ' +
                                ',JP_CampaignWholeSaleRate_D__c ' +
                                ',JP_Category1__c ' +                   //カテゴリ1
                                ',JP_Category2__c ' +                   //カテゴリ2
                                ',JP_CategoryCode__c ' +
                                ',JP_DiscountLimitPrice__c ' +          //値引限度額
                                ',JP_ExpirvDiscountLimit__c ' +
                                ',JP_ExpirvStandardPrice__c ' +
                                ',JP_IsSpecialDistributorProduct__c ' + //特殊代理店製品フラグ
                                ',JP_MakerCode__c ' +
                                ',JP_Maker__c ' +
                                ',JP_OpenPriceFlag__c ' +
                                ',JP_OutputableQuotation__c ' +
                                ',JP_PiStock__c ' +
                                ',JP_PreRelease__c ' +                  //リリース前
                                ',JP_PriceBookEntryId__c ' +
                                ',JP_PriceChangedDate__c ' +            //価格改定日
                                ',JP_Price_List_Type__c ' +             //price list type
                                ',JP_PriceYearMonth__c ' +              //価格年月
                                ',JP_QuotationRemarks__c ' +            //見積備考
                                ',JP_RefPriceTaxOff__c ' +
                                ',JP_ReleaseDate__c ' +                 //リリース日
                                ',JP_RentCharge__c ' +
                                ',JP_RentOverageChargesPerDay__c ' +
                                ',JP_RequiredMaintenanceFlag__c ' +
                                ',JP_SalesEndScheduledPeriod__c ' +     //販売終了
                                ',JP_SaleStatus__c ' +                  //販売状態
                                ',JP_StandardPriceTaxOff__c ' +         //標準価格
                                ',JP_SupportTicketClassificationCode__c ' +
                                ',JP_WholeSaleKey__c ' +
                                ',JP_WholeSalePrice_SpecailAboveCampaign__c ' +
                                ',JP_WholeSalePrice_SpecailAboveStandard__c ' +
                                ',JP_WholeSalePrice_Standard__c ' +
                                ',JP_WholeSalePrice__c ' +              //仕切価格
                                ',JP_WholeSaleRate_A__c ' +
                                ',JP_WholeSaleRate_B__c ' +
                                ',JP_WholeSaleRate_C__c ' +
                                ',JP_WholeSaleRate_D__c ' +
                                ',JP_WholeSaleRate__c ' +               //仕切率
                                ',JP_WholeSale_CampaignAboveStandardRate__c ' +
                                ',JP_WholeSale_SpecialAboveCampaignRate__c ' +
                                ',JP_WholeSale_SpecialAboveStandardRate__c ' +
                                ',JP_WholeSale_StandardRate__c ' +
                                ',JP_CampaignDecision__c ' +
                         'FROM JP_DistributorPrice__c  ' +
                         //検索条件：見積出力可能フラグ=true
                         'WHERE JP_OutputableQuotation__c = true ' ;
        

        System.debug('■■■■■■■■■■■■■■■■■■' + query + '■■■■■■■■■■■■■■■■■■' );

        /**
         * 検索条件：SearchItemKey1
         * 完全一致検索
         */
         if(!String.isBlank(jpdp.JP_ProductCatalogCode__c)){
            system.debug('********** ProductCatalogCode is not blank **********');
            query += ' AND JP_SearchItemKey1__c = \'' + priceListType + '_' + jpdp.JP_ProductCatalogCode__c + '\'';
         }
            System.debug('■■■■■■■■■■■■■■■■■■' + priceListType + '_' + jpdp.JP_ProductCatalogCode__c + '■■■■■■■■■■■■■■■■■■' );


         /**
         * 検索条件：SearchItemKey2
         * 完全一致検索
         */
         if(!String.isBlank(priceYearMonth)){
            query += ' AND JP_SearchItemKey2__c = \'' + priceListType + '_' + priceYearMonth + '\'';
         }
         System.debug('■■■■■■■■■■■■■■■■■■' + priceListType + '_' + priceYearMonth + '■■■■■■■■■■■■■■■■■■' );

        /*
         *検索条件：商品コード
         *曖昧検索
         */
        //if(jpdp.JP_ProductCatalogCode__c != null){
        //  query += ' AND JP_ProductCatalogCode__c LIKE \'%' + jpdp.JP_ProductCatalogCode__c + '%\'';  
        //}

        /*
         *検索条件：製品名
         *曖昧検索
         */
        if(!String.isBlank(jpdp.JP_ProductName__c)){
            query += ' AND JP_ProductName__c LIKE \'%' + jpdp.JP_ProductName__c + '%\'';    
        }
        
        /*
         *検索条件：価格年月
         *完全一致検索
         */
        //if(priceYearMonth != null){
        //  query += ' AND JP_PriceYearMonth__c =\'' + priceYearMonth + '\'';   
        //}

        /*
         *検索条件：カテゴリ1
         *曖昧検索
         */
        if(!String.isBlank(jpdp.JP_Category1__c) ){
            query += ' AND JP_Category1__c LIKE \'%' + jpdp.JP_Category1__c + '%\'';    
        }
        
        /*
         *検索条件：カテゴリ2
         *曖昧検索
         */
        if(!String.isBlank(jpdp.JP_Category2__c)){
            query += ' AND JP_Category2__c LIKE \'%' + jpdp.JP_Category2__c + '%\'';    
        }

        query += ' ORDER BY JP_ProductCatalogCode__c LIMIT 100';

        System.debug('■■■■■■■■■■■■■■■■■■' + query + '■■■■■■■■■■■■■■■■■■' );

        List<JP_DistributorPrice__c> distributorPriceList = Database.query(query);

        return distributorPriceList;

    }
    
    /**
     * 2016/02/03追加
     * 商談→見積コピー用
     * @param pbeIdSet 価格表エントリIDセット
     * @return 検索条件に一致した代理店仕切価格表の価格表エントリIDをKeyとした代理店仕切価格表のマップ
     */
    public static Map<String, JP_DistributorPrice__c> getDistributorPriceByPBEIdt(Set<String> pbeIdSet) {
        system.debug('========== Start getDistributorPriceByPBEIdt ==========');
        Map<String, JP_DistributorPrice__c> dpMap = new Map<String, JP_DistributorPrice__c>();
        List<JP_DistributorPrice__c> dpList = new List<JP_DistributorPrice__c>();
        
        dpList = [select
                    Id,
                    JP_5PercentDiscount__c,
                    JP_AppGroupID__c,
                    JP_CampaignClassificationCode__c,
                    JP_CampaignContent__c,
                    JP_CampaignDiscountLimitPrice__c,
                    JP_CampaignEndDate__c,
                    JP_CampaignName__c,
                    JP_CampaignPurpose__c,
                    JP_CampaignStandardPriceTaxOff__c,
                    JP_CampaignStartDate__c,
                    JP_CampaignWholeSaleRate_A__c,
                    JP_CampaignWholeSaleRate_B__c,
                    JP_CampaignWholeSaleRate_C__c,
                    JP_CampaignWholeSaleRate_D__c,
                    JP_CategoryCode__c,
                    JP_Category1__c,
                    JP_DiscountLimitPrice__c,
                    JP_ExpirvDiscountLimit__c,
                    JP_ExpirvStandardPrice__c,
                    JP_MakerCode__c,
                    JP_Maker__c,
                    JP_OpenPriceFlag__c,
                    JP_OutputableQuotation__c,
                    JP_PriceChangedDate__c,
                    JP_PriceYearMonth__c,
                    JP_Price_List_Type__c,
                    JP_ProductCatalogCode__c,
                    JP_ProductCode__c,
                    JP_ProductName__c,
                    JP_QuotationRemarks__c,
                    JP_RefPriceTaxOff__c,
                    JP_ReleaseDate__c,
                    JP_RequiredMaintenanceFlag__c,
                    JP_SaleStatus__c,
                    JP_SalesEndScheduledPeriod__c,
                    JP_StandardPriceTaxOff__c,
                    JP_SupportTicketClassificationCode__c,
                    JP_WholeSaleKey__c,
                    JP_WholeSalePrice_SpecailAboveCampaign__c,
                    JP_WholeSalePrice_SpecailAboveStandard__c,
                    JP_WholeSalePrice_Standard__c,
                    JP_WholeSalePrice__c,
                    JP_WholeSaleRate_A__c,
                    JP_WholeSaleRate_B__c,
                    JP_WholeSaleRate_C__c,
                    JP_WholeSaleRate_D__c,
                    JP_WholeSaleRate__c,
                    JP_WholeSale_CampaignAboveStandardRate__c,
                    JP_WholeSale_SpecialAboveCampaignRate__c,
                    JP_WholeSale_SpecialAboveStandardRate__c,
                    JP_WholeSale_StandardRate__c,
                    JP_PreRelease__c,
                    JP_PiStock__c,
                    JP_RentCharge__c,
                    JP_RentOverageChargesPerDay__c,
                    JP_Category2__c,
                    JP_IsSpecialDistributorProduct__c,
                    JP_PriceBookEntryId__c,
                    JP_CampaignDecision__c
                from
                    JP_DistributorPrice__c
                where
                    JP_PriceBookEntryId__c IN:pbeIdSet
                and
                    JP_OutputableQuotation__c = true
                ];
                
        for(JP_DistributorPrice__c dp : dpList){
            if(!dpMap.containsKey(dp.JP_PriceBookEntryId__c)){
                dpMap.put(dp.JP_PriceBookEntryId__c, dp);
            }
        }
        return dpMap;
    }


    /**
     * 2022/02/15追加
     * 見積画面明細保存用
     * @param pbeIdSet 代理店仕切価格表 商品コードSet
     * @return 検索条件に一致した商品コードをKeyとした仕切価格のマップ
     */
    public static Map<String,Decimal> getDistributorPriceByAE(Set<String> ProductCatalogCodeSet) {
        Map<String,Decimal> distributorPriceMap = new Map<String,Decimal>();
        List<JP_DistributorPrice__c> distributorPriceList = [select
            JP_ProductCatalogCode__c,
            JP_Price_List_Type__c ,
            JP_WholeSalePrice__c
            from JP_DistributorPrice__c
            where JP_ProductCatalogCode__c = :ProductCatalogCodeSet
            and JP_Price_List_Type__c = 'AE'];

            
        for (JP_DistributorPrice__c distributorPrice : distributorPriceList) {
            distributorPriceMap.put(distributorPrice.JP_ProductCatalogCode__c,distributorPrice.JP_WholeSalePrice__c);
        }
        return distributorPriceMap;
    }
}