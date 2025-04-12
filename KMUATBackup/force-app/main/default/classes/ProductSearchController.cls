public with sharing class ProductSearchController {

    /**
     * 結果を保存する変数
     **/
    public List<JP_DistributorPrice__c> productList{get;set;}
    public List<JP_QuotationDetailSelect> selectedList{get;set;}
    public List<WrapProductSearch> wrapList{get;set;}

    public String productCatalogCode {get;set;}

    public String category1 {get;set;}
    public String category2 {get;set;}
    public String productName {get;set;}

    @TestVisible private Set<String> codeSet;
    @TestVisible private Map<String, String> codeMap;
    @TestVisible private JP_DistributorPrice__c distributorPrice;
    @TestVisible private String mode;

    /**
     * 渡ってくる変数
     *　　 ・ページボタン制御
     * 　 ・price List Type
     * 　 ・見積明細ラッパリスト
     **/
    public String price_list_type {get;set;}
    public List<JP_QuotationDetailSelect> detailList {get;set;}
    public Integer listIndex{get;set;}
    public String parentDistributorCD{get;set;}

    /**
     * 価格年月リスト
     **/
    public String inputPriceYearMonth {get; set;}

    public String alertMessage {get;set;}
    public Boolean messageFlag {get;set;}
    public Boolean warningFlag {get;set;}
    public List<String> specialProductList {get;set;}
    public List<String> piStockList {get;set;}
    public String spList {get;set;}
    public String piList {get;set;}




    /**
     * コンストラクタ
     *
     * @param none
     * @return none
     *
     * 初期化：　
     * 　　・代理店仕切価格表リスト
     * 　　・代理店仕切価格表ラップリスト
     * 　　・価格年月リスト（未定）
     **/
    public ProductSearchController() {
        
        system.debug('■■■■■■■■■■　start ProductSearchController ■■■■■■■■■■');
        
        system.debug('========== price_list_type : ' + price_list_type);
        system.debug('========== parentDistributorCD : ' + parentDistributorCD);

        distributorPrice = new JP_DistributorPrice__c();

        this.inputPriceYearMonth = '---なし---';

    }

    /**
    * 価格表プルダウン
    */
    public List<SelectOption> getPriceYearMonthList() {
        
        system.debug('■■■■■■■■■■　start getPriceYearMonthList ■■■■■■■■■■');
        system.debug('========== price_list_type : ' + price_list_type);
        
        List<SelectOption> priceYearMonthItems = new List<SelectOption>();

        priceYearMonthItems.add(new SelectOption('','---なし---'));

        for (JP_PriceYearMonth__c pym : JP_PriceYearMonthDAO.selectFromPreviousMonth(price_list_type)) {

            priceYearMonthItems.add(new SelectOption(String.valueOf(pym.JP_PriceYearMonth__c), pym.JP_PriceYearMonth__c));
        }
        return priceYearMonthItems;
    }

    /**
     * 製品検索メソッド
     *
     * @param none
     * @return none
     *
     **/
    public void searchProduct2(){
        
        System.debug('■■■■■■■■■START searchProduct2 ■■■■■■■■■');

        //検索条件を設置
        distributorPrice.JP_ProductCatalogCode__c = this.productCatalogCode;
        distributorPrice.JP_ProductName__c = this.productName;
        distributorPrice.JP_Category1__c = this.category1;
        distributorPrice.JP_Category2__c = this.category2;      //データベースから検索結果を取得

        //検索結果を保持するラッパークラスリスト
        wrapList = new List<WrapProductSearch>();
        //990コードキーセット
        codeSet = new Set<String>();
        //エラーメッセージ判定フラグ
        messageFlag = false;
        warningFlag = false;

        productList = JP_DistributorPriceDAO.selectListForProductSearch(distributorPrice, price_list_type ,inputPriceYearMonth);

        System.debug('■■■■■■■■■productList1■■■■■■■■■' + productList.size()+ '■■■■■■■■■■■■■■■■■■');

        if(productList == null || productList.size() == 0){
            //エラー
            messageFlag = true;
            alertMessage = JP_Const.ERR_MESSAGE_PRODUCT_NUMBER_IS_0;

            System.debug('■■■■■■■■■productList2■■■■■■■■■' + productList.size()+ '■■■■■■■■■■■■■■■■■■');

        }else{

            //ラッパークラスで整形 & 990コード抽出　&　特殊代理店製品フラグ抽出
            for(JP_DistributorPrice__c dp : productList){

                codeSet.add(dp.JP_ProductCode__c);
                WrapProductSearch wps = new WrapProductSearch(dp);
                wrapList.add(wps);

                System.debug('■■■■■■■■■wrapList2■■■■■■■■■' + wrapList.size()+ '■■■■■■■■■■■■■■■■■■');
            }
            System.debug('■■■■■■■■■wrapList2■■■■■■■■■' + wrapList.size()+ '■■■■■■■■■■■■■■■■■■');
        }

    }

    /**
     * 商品追加メソッド
     *
     * @param none
     * @return none
     *
     **/
    public void addProduct(){
        
        System.debug('■■■■■■■■■START addProduct ■■■■■■■■■');

        messageFlag = false;
        warningFlag = false;
        specialProductList = new List<String>();
        piStockList = new List<String>();
        mode = 'Add';

        chooseCheckedAndChangeToDetailSelect(mode);


        System.debug('**selectedList' + selectedList);

        if(selectedList != null && selectedList.size() != 0){

            //Integer recordNum = detailList.size() + selectedList.size();

            //System.debug('■■■■■■■■■■■■■■■■■■specialProductList' + specialProductList+ '■■■■■■■■■■■■■■■■■■');

            //番号振り
            Decimal no = 0;
            Decimal sortNo = 0;
            for(JP_QuotationDetailSelect qds : detailList){
                JP_QuotationDetail__c qd = qds.obj;
                if(no < qd.JP_DetailsNo__c){
                    no = qd.JP_DetailsNo__c ;
                }
                if(sortNo < qd.JP_Sort__c){
                    sortNo = qd.JP_Sort__c ;
                }
            }

            for(JP_QuotationDetailSelect qds : selectedList){

                JP_QuotationDetail__c qd = qds.obj;
                qd.JP_DetailsNo__c = ++no ;
                qd.JP_Sort__c = ++sortNo ;

                if(qd.JP_IsSpecialDistributorProduct__c){
                    specialProductList.add(qd.JP_ProductCatalogCode__c);
                }

                if(qd.JP_PiStock__c){
                    piStockList.add(qd.JP_ProductCatalogCode__c);
                }

                qd.JP_SpecialUnitPriceMulQuantity__c = 0;
                qd.JP_WholeSalePriceMulQuantity__c = 0;
                qd.JP_StandardMinusSpecial__c = 0;
                qd.JP_DeterminedAmount__c = 0;
                qd.JP_SpecialUnitPrice__c = 0;
                qd.JP_OverLimitDiscount__c = false;
                
                setDefaultQuotationDetail (qd); // Alliedtelesis-462 Add
            }

            if(specialProductList.size() > 0 ){
                warningFlag = true;
                spList = specialProductList[0];
                for(Integer i = 1 ; i < specialProductList.size() ; i++ ){
                    spList += ',' + specialProductList.get(i);
                }

            }

            if(piStockList.size() > 0){
                warningFlag = true;
                piList = piStockList[0];
                for(Integer i = 1 ; i < piStockList.size() ; i++ ){
                    spList += ',' + piStockList.get(i);
                }
            }

            detailList.addAll(selectedList);
            
            System.debug('**detailList' + detailList.size());
        }
    }

    /**
     * 商品更新メソッド
     *
     * @param none
     * @return none
     *
     **/
    public void updateProduct(){
        
        System.debug('■■■■■■■■■START updateProduct ■■■■■■■■■');

        messageFlag = false;
        warningFlag = false;
        specialProductList = new List<String>();
        piStockList = new List<String>();
        mode = 'Update';

        chooseCheckedAndChangeToDetailSelect(mode);

        System.debug('■■■■■■■■■selectedList■■■■■■■■■' + selectedList +'■■■■■■■■■■■■■■■■■■');

        if(selectedList != null &&  selectedList.size() != 0){

            System.debug('yearmonth:' + selectedList[0].obj.JP_PriceYearMonth__c);
            detailList[listIndex] = selectedList[0];
            System.debug('**detailList' + detailList.size());
            if(selectedList[0].obj.JP_IsSpecialDistributorProduct__c){
                specialProductList.add(selectedList[0].obj.JP_ProductCatalogCode__c);
            }

            if(selectedList[0].obj.JP_PiStock__c){
                piStockList.add(selectedList[0].obj.JP_ProductCatalogCode__c);
            }
            
            selectedList[0].obj.JP_QuotationDetailType__c = '明細区分リセット用(システム利用)'; // Alliedtelesis-462 Add
        }

        if(specialProductList.size() > 0 ){
            warningFlag = true;
            spList = specialProductList[0];
        }

        if(piStockList.size() > 0){
            warningFlag = true;
            piList = piStockList[0];
        }

        System.debug('◼︎◼︎◼︎◼︎◼︎◼︎◼︎◼︎◼︎◼︎◼︎◼︎◼︎◼︎◼︎◼︎◼︎detailList:' + detailList);
    }

    // -----------------------------------内部ロジック----------------------------------------

    /**
     * 代理店専用製品コード検索メソッド
     *
     *  @param none
     *  @return none
     *
     **/
    @TestVisible private void searchDistributorProductCode(){
        
        System.debug('■■■■■■■■■START searchDistributorProductCode ■■■■■■■■■');

        System.debug('■■■■■■■■■■■■■■■■■■parentDistributorCD:'+ parentDistributorCD +'■■■■■■■■■■■■■■■■■■');
        System.debug('■■■■■■■■■■■■■■■■■■codeSet:'+ codeSet +'■■■■■■■■■■■■■■■■■■');

        List<JP_DistributorProductCode__c> disProCodeList = JP_DistributorProductCodeDAO.selectDistributorProCode(parentDistributorCD, codeSet);

        codeMap = new Map<String, String>();

        System.debug('■■■■■■■■■■■■■■■■■■disProCodeList.size:'+ disProCodeList +'■■■■■■■■■■■■■■■■■■');

        if(disProCodeList != null){

            for(JP_DistributorProductCode__c dpc : disProCodeList){

                codeMap.put(dpc.JP_ProductCode__c, dpc.JP_DistributorProCode__c);

            }
        }

     }

    /**
     * チェックされたレコードを取り出して見積明細のラッパクラスに渡す
     *
     * @param none
     * @return none
     *
     **/
    @TestVisible private void chooseCheckedAndChangeToDetailSelect(String mode){
        
        System.debug('■■■■■■■■■START chooseCheckedAndChangeToDetailSelect ■■■■■■■■■');

    selectedList= new List<JP_QuotationDetailSelect>();

        //if(detailList != null){
        //  Integer setRowNum = detailList.size() - 1 ;
        //}
        //specialProductList = new List<String>();
        //piStockProductList = new List<String>();

        searchDistributorProductCode();
        System.debug('***** wrapList:' + wrapList);
        if(!(wrapList == null || wrapList.size() ==0)){

        //代理店仕切価格表から見積明細に変換する。
            for(WrapProductSearch wps : wrapList){
                system.debug('***** wps.isChecked : ' + wps.isChecked);
                if(wps.isChecked){

                    system.debug('***** mode : ' + mode);
                    if(mode == 'Add'){
                        // ad
                        JP_QuotationDetail__c qd = new JP_QuotationDetail__c();
                        JP_QuotationDetailSelect qds = setPropaties(qd,wps);
                        selectedList.add(qds);
                    }else{
                        JP_QuotationDetail__c qd = detailList[listIndex].obj;
                        JP_QuotationDetailSelect qds = setPropaties(qd,wps);
                        selectedList.add(qds);
                    }
                }
            }
        }
    }

    @TestVisible private JP_QuotationDetailSelect setPropaties(JP_QuotationDetail__c qd, WrapProductSearch wps){

        System.debug('■■■■■■■■■START setPropaties ■■■■■■■■■');

        qd.JP_AppGroupID__c = wps.dp.JP_AppGroupID__c;                                      //承認グループID
        qd.JP_Category1__c = wps.dp.JP_Category1__c;                                        //カテゴリ１
        qd.JP_Category2__c = wps.dp.JP_Category2__c;                                        //カテゴリ２
        qd.JP_DiscountLimitPrice__c = wps.dp.JP_ExpirvDiscountLimit__c;                     //値引限度額
        qd.JP_IsSpecialDistributorProduct__c = wps.dp.JP_IsSpecialDistributorProduct__c;    //特殊代理店製品フラグ
        qd.JP_PiStock__c = wps.dp.JP_PiStock__c;                                            //PI在庫誘導フラグ
        qd.JP_PriceBookEntryId__c = wps.dp.JP_PriceBookEntryId__c;                          //仕切表エントリー
        qd.JP_PreRelease__c = wps.dp.JP_PreRelease__c;                                      //リリース前フラグ
        qd.JP_PriceYearMonth__c = wps.dp.JP_PriceYearMonth__c;                              //価格年月
        qd.JP_ProductCatalogCode__c = wps.dp.JP_ProductCatalogCode__c;                      //商品コード
        qd.JP_ProductCode__c = wps.dp.JP_ProductCode__c;                                    //990コード
        qd.JP_ProductName__c = wps.dp.JP_ProductName__c;                                    //製品名
        qd.JP_QuotationRemarks__c = wps.dp.JP_QuotationRemarks__c;                          //見積備考
        qd.JP_ReleaseScheduled__c = wps.dp.JP_ReleaseDate__c;                               //リリース日
        qd.JP_RequiredMaintenanceFlag__c = wps.dp.JP_RequiredMaintenanceFlag__c;            //保守必須フラグ
        qd.JP_SalesEndScheduled__c = wps.dp.JP_SalesEndScheduledPeriod__c;                  //販売終了予定時期
        qd.JP_SalesStatus__c = wps.dp.JP_SaleStatus__c;                                     //販売状態
        qd.JP_StandardPrice__c = wps.dp.JP_ExpirvStandardPrice__c;                          //有効標準価格→標準価格
        qd.JP_SupportTicketCode__c = wps.dp.JP_SupportTicketClassificationCode__c;          //サポチケ
        qd.JP_WholeSaleRate__c = wps.dp.JP_WholeSaleRate__c;                                //仕切率
        qd.JP_UnitPrice__c = wps.dp.JP_WholeSalePrice__c;                                   //仕切価格→単価
        qd.JP_5PercentDiscount__c = wps.dp.JP_5PercentDiscount__c;                          //仕切5%減
        qd.JP_Maker__c = wps.dp.JP_Maker__c;

        if(!String.isBlank(wps.dp.JP_CampaignStartDate__c)){                                //キャンペーン判定
            qd.JP_CampaignDecision__c = true;
        }else{
            qd.JP_CampaignDecision__c = false;
        }
        
        System.debug('■■■■■■■■■productcode■■■■■■■■■' + wps.dp.JP_ProductCode__c +'■■■■■■■■■■■■■■■■■■');

        //代理店専用製品コードがある場合、明細に転記
        if(codeMap.containsKey(wps.dp.JP_ProductCode__c)){
            qd.JP_DistributorProCode__c = codeMap.get(wps.dp.JP_ProductCode__c);        //代理店専用製品コード
        }else{
            qd.JP_DistributorProCode__c = null;
        }

        qd.JP_IsProductError__c = false;        // 製品検索エラーを初期化

        //ラッピング
        JP_QuotationDetailSelect qds = new JP_QuotationDetailSelect(qd);

        System.debug('■■■■■■■■■qds■■■■■■■■■1' + qds +'■■■■■■■■■■■■■■■■■■');

        return qds;

    }
// Alliedtelesis-462 Add start
    /**
     * 明細区分項目のデフォルト値をセットします
     * @param src 見積明細
     */
    private void setDefaultQuotationDetail (JP_QuotationDetail__c qd) {
        // 新規追加時は確定金額が 0 であるため、見積明細のデフォルト値は集計外となる
        qd.JP_QuotationDetailType__c = JP_Const.QUOTATIONDETAILTYPE_NOTTOTALED;
        
        /*編集画面コントローラの明細部分作成で実施のため不要
        if (qd.JP_DeterminedAmount__c == 0)
            qd.JP_QuotationDetail__c = '集計外';       // 確定金額が 0 のとき, 集計外
        else if (qd.JP_ProductCatalogCode__c != null && qd.JP_ProductCatalogCode__c.startsWith ('MEMO'))
            qd.JP_QuotationDetail__c = '';              // 商品コードが MEMO から始まるとき, 空欄
        else if (qd.JP_ProductCatalogCode__c != null && qd.JP_ProductCatalogCode__c == '****')
            qd.JP_QuotationDetail__c = '';              // 商品コードが **** のとき, 空欄
        else if (qd.JP_ProductCode__c != null && qd.JP_ProductCode__c.startsWith ('ATSS'))
            qd.JP_QuotationDetail__c = '保守';            // 990 コードが ATSS から始まるとき, 保守
        else
            qd.JP_QuotationDetail__c = '機器';            // それ以外のときは機器*/
    }
// Alliedtelesis-462 Add end
}