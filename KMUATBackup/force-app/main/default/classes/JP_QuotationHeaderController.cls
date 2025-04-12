public with sharing class JP_QuotationHeaderController {
    // 商品コード「z」
    private final static String TOUROKUGAI_Z = JP_Const.TOUROKUGAI_Z;
    // 商品コード「-」
    private final static String COMMENT_HYPHEN = JP_Const.COMMENT_HYPHEN;

    //見積情報
    public JP_QuotationHeader__c QHeader {get; set;}
    // 見積明細元情報
    public List<JP_QuotationDetailSelect> qDetailOriginalList{get; set;}
    //見積明細リスト
    public List<JP_QuotationDetailSelect> QDetailList{get;set;}
    //見積明細.完了予定日（見積明細の完了予定日は保留）
//    public SObjectField completionScheduled = JP_QuotationDetail__c.JP_CompletionScheduled__c.getDescribe().getSObjectField(); // ALLIEDTELESIS-462 20210125 Terrasky add
    public JP_QuotationDetailSelect QDetailDummy{get;set;}

    //代理店情報
    @TestVisible private List<JP_QuotationDistributor__c> distributor;
    //スポット代理店フラグ
    @TestVisible private String spotflg;
    //部署
    //public String inputDepartment{get; set;}
    @TestVisible private Map<String,JP_Department__c> jp_DpMap;
    //自動計算フラグ
    public Boolean autoSumflg {get; set;}
    
    //見積条件定型文
    public String inputMitumorijyoken1{get; set;}
    public String inputMitumorijyoken2{get; set;}
    public String inputMitumorijyoken3{get; set;}
    public String inputMitumorijyoken4{get; set;}
    public String inputMitumorijyoken5{get; set;}
    public String inputMitumorijyoken6{get; set;}
    public String inputMitumorijyoken7{get; set;}
    public String inputMitumorijyoken8{get; set;}
    //価格年月
    public String inputPriceYearMonth{get; set;}

    @TestVisible private List<Id> deleteQdIds;

    //承認者フラグ
    @TestVisible private String approvalFlg;
    //遷移元URL
    @TestVisible private String retURL;
    //代理店コード
    @TestVisible private String distributorId;

    // PriceListType
    public String priceListType{get; set;}

    //行番号
    public String index{get;set;}

    // 親代理店コード
    public String parentDistributor{get; set;}

    // 選択状態保持用セット
    public Set<Id> selectedIdSet{get; set;}

    // 現在ページ番号
    public Integer nowPageNum{get; set;}

    // 全ページ数　
    public Integer totalPage{get; set;}

    // １ページあたり行数
    public Integer pageSize{get; set;}

    // 全明細最大件数
    public Integer MAX_QDETAILORIGINALLISTSIZE{get; set;}

    //仮保存フラグ
    public String presaveFlg{get; set;}

    //Index
    public Integer recNumber{get; set;}

    public Boolean isProductError{get;set;}
    
    //カスタム例外クラス
    public class HeaderException extends Exception {} 
    
    public String testValue {get;set;}
    /**
     * コントローラ
     */
    public JP_QuotationHeaderController(ApexPages.StandardController stdController) {
        this.recNumber = 0;
        // 初期化
        this.nowPageNum = 1;
        this.totalPage = 0;
        this.selectedIdSet = new Set<ID>();
        this.qDetailOriginalList = new List<JP_QuotationDetailSelect>();
        this.pageSize = 20;
        this.MAX_QDETAILORIGINALLISTSIZE = 500;

        this.QHeader = (JP_QuotationHeader__c)stdController.getRecord();
        
        // レコード取得
        Id recId = stdController.getRecord().Id;
        if(recId != null){
            this.QHeader = JP_QuotationHeaderDAO.getRecById(recId);
            this.autoSumflg = QHeader.JP_AutoSumFlg__c;
            this.createQDetailOriginalList();
        } else {
            // 見積明細に空の5行を作成
            this.qDetailOriginalList = new List<JP_QuotationDetailSelect>();
            this.addRow();
        }
        
        QDetailList = new List<JP_QuotationDetailSelect>();
        QDetailDummy = new JP_QuotationDetailSelect(new JP_QuotationDetail__c()); // ALLIEDTELESIS-462 20210125 Terrasky add

        this.deleteQdIds = new List<Id>();

        //遷移元URLパラメータ取得
        retURL = ApexPages.currentPage().getParameters().get('retURL');

        //代理店コードパラメータ取得
        distributorId = ApexPages.currentPage().getParameters().get('distributorId');
        //スポットフラグ
        spotflg = ApexPages.currentPage().getParameters().get('spotflg');

        //代理店情報取得
        if(String.isBlank(distributorId)){
            distributor = JP_QuotationDistributorDAO.getRecByDistId(this.QHeader.JP_QuotationDistCD__c);
        }else{
            distributor = JP_QuotationDistributorDAO.getRecByDistId(distributorId);
        }
        
        if (distributor.size() != 0) {
            // priceListTypeと親代理店コード
            this.priceListType = this.distributor[0].JP_Price_List_Type__c;
            this.parentDistributor = this.distributor[0].JP_MainDistributorCode__c;
        }

        //ログインユーザ取得
        User usr = [Select Id,Name,JP_DeptCode__c From User Where Id =:UserInfo.getUserId()];
        //初期値設定
        if(recId == null){
            if(distributor.size() != 0){
                //基本情報
                if(distributor[0].JP_SubjectAutoSetFlag__c){
                    QHeader.Name = distributor[0].JP_MainDistributorName__c + System.Label.JP_QuatationNAMETitle;
                }
                QHeader.JP_PaymentCondition__c = distributor[0].JP_PaymentCondition__c;
                //顧客情報
                QHeader.JP_QuotationDistCD__c = distributor[0].Id;
                QHeader.JP_Company__c = distributor[0].Name;
                QHeader.JP_DistributorCode__c = distributor[0].JP_DistributorCode__c;
            }
            
            //自社情報 ユーザセット
            QHeader.JP_Outside__c = UserInfo.getUserId();
            QHeader.JP_Inside__c = UserInfo.getUserId();
            //部署情報取得
            List<JP_Department__c> jp_Dp = JP_DepartmentDAO.getRecByUsrDepartment(usr.JP_DeptCode__c);
            //部署情報から住所などをセット
            if(jp_Dp.size() > 0){
                //部署情報から値を取得する
                QHeader.JP_ATKK_Postcode__c = jp_Dp[0].JP_Postcode__c;
                QHeader.JP_ATKK_Address1__c = jp_Dp[0].JP_Address1__c;
                QHeader.JP_ATKK_Address2__c = jp_Dp[0].JP_Address2__c + jp_Dp[0].JP_Address3__c;
                QHeader.JP_ATKK_Building__c = jp_Dp[0].JP_Building__c;
                QHeader.JP_ATKK_Company__c = jp_Dp[0].JP_Company__c;
                QHeader.JP_atkkDepartment1__c = jp_Dp[0].JP_DeptCode__c;
                QHeader.JP_atkkDepartment2__c = jp_Dp[0].Name;
                QHeader.JP_atkkTellNo__c = jp_Dp[0].JP_TelNo__c;
                QHeader.JP_atkkFaxNo__c = jp_Dp[0].JP_FaxNo__c;
            }

            if(String.isNotBlank(distributorId)){
                setDefoultQuotationCondition(this.distributor[0].JP_DeafultQuotationCondition__c);         
            }else{
                setDefoultQuotationCondition('');
            }
        }

        //見積明細
        this.createQDetailList();
        
        // 価格年月デフォルト値
        //system.debug('***** 価格年月 : ' + this.QHeader.JP_PriceYearMonth__c);
        if(this.QHeader.JP_PriceYearMonth__c != null){
            this.inputPriceYearMonth = this.QHeader.JP_PriceYearMonth__c;
        }else{
            String prefix = null;
            for (SelectOption so : this.getPriceYearMonthList()) {
                prefix = so.getValue().subString(0, 2) + ' ';
                break;
            }

            if (prefix != null) {
                this.inputPriceYearMonth = prefix + String.valueOf(Date.today().year()) + '/' + String.valueOf(Date.today().month()).leftPad(2, '0');
            }
        }
        
    }

    /**
     * 見積明細元リスト作成
     */
    private void createQDetailOriginalList() {
        this.qDetailOriginalList = new List<JP_QuotationDetailSelect>();
        for (JP_QuotationDetail__c qd : JP_QuotationDetailDAO.getRecByParentId(this.QHeader.Id)) {
            JP_QuotationDetailSelect qds = new JP_QuotationDetailSelect(qd);
            qds.isProductError = qd.JP_IsProductError__c;
            
            // 明細区分が null であった場合はデフォルト値をセット Alliedtelesis-462 Add
            if (qds.obj.JP_QuotationDetailType__c == null)
                setDefaultQuotationDetail (qds);
            
            this.qDetailOriginalList.add(qds);
        }
        
        // 全ページ数算出
        this.calcTotalPages();
    }

    /**
     * 見積明細リスト作成
     */
    private void createQDetailList() {
        this.QDetailList = new List<JP_QuotationDetailSelect>();
        Integer rowNo = 0;
        for (Integer i = (nowPageNum - 1) * pageSize; i < nowPageNum * pageSize; i++) {
            if (i >= this.qDetailOriginalList.size()) {
                break;
            }
            JP_QuotationDetailSelect qds = this.qDetailOriginalList.get(i);
            
            qds.rowNo = rowNo;
            QDetailList.add(qds);
            ++rowNo;
        }
    }

    /**
     * 1ページあたり表示件数選択リスト変更時処理
     */
    public PageReference changeDispPageNumList() {
        this.nowPageNum = 1;
        this.createQDetailList();
        // 全ページ数算出
        this.calcTotalPages();
        return null;
    }

    /**
     * 最大ページ数算出
     */
    private void calcTotalPages() {
        Decimal pages = (Double) this.qDetailOriginalList.size() / pageSize;
        this.totalPage = (Integer)pages.round(System.RoundingMode.CEILING);
    }

    /***************************************
    * 見積ヘッダーのボタン処理
    *　　・仮保存ボタン処理
    *　　・保存ボタン処理
    *　　・キャンセルボタン処理
    ***************************************/
    
    /**
     * 保存・仮保存メソッド
     */
    public Pagereference doRecSave() {
        system.debug('========== doRecSave() Start ==========');
        PageReference retPage = null;
        this.isProductError = false;

// Alliedtelesis-462 Add start
        // 見積明細の明細区分が未入力の場合エラー. 仮保存時は入力チェックを行わない
        if (presaveFlg != '1') {
            /*for (Integer n = 0; n < QDetailList.size (); n++) {
                /*if (QDetailList[n].obj.JP_QuotationDetailType__c != null)
                    continue;
                
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, QDetailList[n].obj.JP_ProductName__c + ' の明細区分が未入力です。'));
                return retPage;*/

                /*if (QDetailList[n].obj.JP_QuotationDetailType__c == null){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, QDetailList[n].obj.JP_ProductName__c + ' の'
                        + Schema.SObjectType.JP_QuotationDetail__c.fields.JP_QuotationDetailType__c.label + 'が未入力です。'));
                    return retPage;
                }
                if (QDetailList[n].obj.JP_CompletionScheduled__c == null){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, QDetailList[n].obj.JP_ProductName__c + ' の' 
                        + Schema.SObjectType.JP_QuotationDetail__c.fields.JP_CompletionScheduled__c.label + 'が未入力です。'));
                    return retPage;
                }
            }*/
            for(JP_QuotationDetailSelect rec : this.qDetailOriginalList){
                if(rec.obj.JP_QuotationDetailType__c == null){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, rec.obj.JP_ProductName__c + ' の'
                        + Schema.SObjectType.JP_QuotationDetail__c.fields.JP_QuotationDetailType__c.label + 'が未入力です。'));
                    return retPage;
                }
/* 見積明細の完了予定日は保留
                if (rec.obj.JP_CompletionScheduled__c == null){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, rec.obj.JP_ProductName__c + ' の' 
                    + Schema.SObjectType.JP_QuotationDetail__c.fields.JP_CompletionScheduled__c.label + 'が未入力です。'));
                return retPage;
                }
*/
            }
        }
// Alliedtelesis-462 Add end

// Alliedtelesis-462 Add start
        Set<String> ProductCatalogCodeSet = new Set<String>();
        for (JP_QuotationDetailSelect qds : this.qDetailOriginalList) {
            ProductCatalogCodeSet.add(qds.obj.JP_ProductCatalogCode__c);
        }
        system.debug('ProductCatalogCodeSet：'+ ProductCatalogCodeSet);
        //List<JP_DistributorPrice__c> distributorPriceList = [select JP_ProductCatalogCode__c, JP_Price_List_Type__c , JP_WholeSalePrice__c from JP_DistributorPrice__c where JP_ProductCatalogCode__c = :ProductCatalogCodeSet and JP_Price_List_Type__c = 'AE'];
        Map<String,Decimal> distributorPriceMap = JP_DistributorPriceDAO.getDistributorPriceByAE(ProductCatalogCodeSet);
        /*for (JP_DistributorPrice__c distributorPrice : distributorPriceList) {
            distributorPriceMap.put(distributorPrice.JP_ProductCatalogCode__c,distributorPrice.JP_WholeSalePrice__c);
        }*/

        for (JP_QuotationDetailSelect qds : this.qDetailOriginalList) {
            Decimal distributorPrice = distributorPriceMap.get(qds.obj.JP_ProductCatalogCode__c);
            if(distributorPrice == null){
                qds.obj.JP_WholesalePrice__c = 0;
            } else {
                qds.obj.JP_WholesalePrice__c = distributorPrice;
            }
        }
// Alliedtelesis-462 Add end
        // 保存時に商品コードが存在しないエラーが無い時か、仮保存の時
        if ((presaveFlg != '1' && !this.isErrorForQDetailList()) || (presaveFlg == '1')) {

            Savepoint sp = Database.setSavepoint();

            if(presaveFlg == '1'){
                this.QHeader.JP_PreSave__c = true;
            }else{
                this.QHeader.JP_PreSave__c = false;
            }

            try{
                // 価格年月をセット
                QHeader.JP_PriceYearMonth__c = this.inputPriceYearMonth;

                // 「価格年月混在許可」チェックボックスがfalse または　承認申請前なら仕切表を元に計算
                if(this.QHeader.JP_QuotationStatus__c == '未承認'
                    && this.QHeader.JP_AllowMixOfPriceYearMonth__c == false){
                    system.debug('========== START doPriceYearMonth ==========');
                    this.doPriceYearMonth();
                    system.debug('========== END doPriceYearMonth ==========');
                }
                // 再計算
                system.debug('========== START allCalcAmounts ==========');
                this.allCalcAmounts();
                system.debug('========== END allCalcAmounts ==========');

                // 製品見積の追加更新モード初期化
                String sMode = 'INS';

                // 明細自動更新フラグを保存
                QHeader.JP_AutoSumFlg__c = autoSumflg;

                if(this.QHeader.Id != null){
                    this.QHeader.JP_TriggerSkipFLG__c = true;

                    // 製品見積をIDで検索して、追加更新モードの判定。読めたら更新、読めなければ追加
                    JP_QuotationHeader__c qhead = JP_QuotationHeaderDAO.getRecById(this.QHeader.Id);
                    if (qhead != null){
                        // 読めたので更新
                        sMode = 'UPD';
                    }
                }else{
                    this.QHeader.JP_TriggerSkipFLG__c = false;
                }

                //更新の時
                if (sMode == 'UPD'){
                    update this.QHeader;
                //新規作成の時
                }else{
                    this.QHeader.Id = null;
                    insert this.QHeader;
                }
                //upsert this.QHeader;
                //System.debug('◆◆◆◆◆◆this.QHeader.JP_PreSave__c◆◆◆◆◆' + this.QHeader.JP_PreSave__c);

                // 見積ソート
                this.sortRows();

                 //見積明細作成--------------------------------------
                List<JP_QuotationDetail__c> qdUpList = new List<JP_QuotationDetail__c>();
                
                Integer i=0;

                for (Integer k = 0; k < this.qDetailOriginalList.size (); k++)
                    System.debug ('qDetailOriginalList[' + k + '] : errCode = ' + this.qDetailOriginalList[k].errCode + ', 製品名 = ' + this.qDetailOriginalList[k].obj.Name + ', 明細区分 = ' + this.qDetailOriginalList[k].obj.JP_QuotationDetailType__c + ', 価格年月 = ' + this.qDetailOriginalList[k].obj.JP_PriceYearMonth__c);
                for (Integer k = 0; k < this.QDetailList.size (); k++)
                    System.debug ('QDetailList[' + k + '] : errCode = ' + this.QDetailList[k].errCode + ', 製品名 = ' + this.QDetailList[k].obj.Name + ', 明細区分 = ' + this.QDetailList[k].obj.JP_QuotationDetailType__c + ', 価格年月 = ' + this.QDetailList[k].obj.JP_PriceYearMonth__c);
                for(JP_QuotationDetailSelect rec : this.qDetailOriginalList){
                    if(presaveFlg == '1'){
                        rec.obj.JP_PreSave__c = true;
                        rec.obj.JP_IsProductError__c = false;
                    }else{
                        rec.obj.JP_PreSave__c = false;
                    }

                    qdUpList.add(rec.obj.clone(false, false));
                    qdUpList[i].JP_QuotationHeader__c = this.QHeader.Id;
                    i++;
                }
                
                List<JP_QuotationDetail__c> oldQDList = [SELECT Id From JP_QuotationDetail__c WHERE JP_QuotationHeader__c = :this.QHeader.Id];
                if(oldQDList.size() > 0){
                    delete oldQDList;
                }
                insert qdUpList;
        
            } catch(DmlException de){
                Database.Rollback(sp);
                setQDetailErrMessages();
                return null;           
            } catch(HeaderException he){
                Database.Rollback(sp);
                this.QHeader.addError(he.getMessage());
                return null;
            }catch(Exception e){
                Database.Rollback(sp);
                setQDetailErrMessages();
                ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, e.getMessage()+'\n'+e.getStackTraceString()+this.QHeader.Id));
                return null;
            }
            
            if(presaveFlg == '1'){
                retPage = null;
            }else{
                retPage = new PageReference('/'+ this.QHeader.Id);
            }

            presaveFlg = null;
        } else {
            system.debug('========== エラー ==========');
            // 明細でエラー発生
            this.isProductError = true;
        }

        return retPage;
    }

    /**
     * 見積明細のエラーチェックを行います
     * @return true：エラー発生 false：正常
     */
    public Boolean isErrorForQDetailList() {
        Boolean isError = false;
        //System.debug('========== qDetailOriginalList : ' + this.qDetailOriginalList);
        for (JP_QuotationDetailSelect qds : this.qDetailOriginalList) {
            if (qds.isProductError) {
                qds.obj.JP_IsProductError__c = qds.isProductError;
                isError = qds.isProductError;
                break;
            }
        }
        return isError;
    }


    /**
     * 見積明細エラーメッセージ設定
     */
    @TestVisible
    private void setQDetailErrMessages() {
        // エラーメッセージを先頭の5件まで表示
        List<ApexPages.Message> originalMsgList = Apexpages.getMessages();
        if (originalMsgList.size() > 5) {
            List<ApexPages.Message> newMsgList = originalMsgList.clone();
            ApexPages.getMessages().clear();
            List<ApexPages.Message> msList = new List<ApexPages.Message>();
            for (Integer i = 0; i < 5; i++) {
                ApexPages.Message msg = newMsgList.get(i);
                ApexPages.addmessage(msg);
            }
        }
    }


    /**
     * キャンセルボタン：見積情報を保存せず画面遷移します
     * @return retPage
     */
    public Pagereference doCancel(){
        PageReference retPage;
        //RetUrlが取得できた場合
        if(retURL != null){
            retPage = new PageReference(retURL);
            retPage.setRedirect(true);
            return retPage;
        }
        //RetUrlが取得できない場合、HOME画面へ
        retPage = new PageReference('/home/home.jsp');
        return retPage;
    }


    /***************************************
    * 見積代理店の変更時：代理店に紐付く情報をセットします
    * 　
    ***************************************/
    public Pagereference doChangeQuotationDistCD(){
        if(String.isNotBlank(this.QHeader.JP_QuotationDistCD__c)){
            this.distributor = JP_QuotationDistributorDAO.getRecByDistId(this.QHeader.JP_QuotationDistCD__c);
            //代理店から値を取得する
            List<JP_QuotationDistributor__c> jp_Dist = JP_QuotationDistributorDAO.getRecByDistId(this.QHeader.JP_QuotationDistCD__c);
            QHeader.JP_Company__c = jp_Dist[0].Name;
            QHeader.JP_PaymentCondition__c = jp_Dist[0].JP_PaymentCondition__c;
            QHeader.JP_DistributorCode__c = jp_Dist[0].JP_DistributorCode__c;
            
            //スポットフラグの取り直し 2015/10/08 修正
            this.spotflg = this.distributor[0].JP_SpotDistributor__c?'1':'0';

            //代理店に紐付く見積条件をセット
            setDefoultQuotationCondition(this.distributor[0].JP_DeafultQuotationCondition__c);

            QHeader.JP_QuotationContact__c = null;
            QHeader.JP_Postcode__c = null;
            QHeader.JP_Adress1__c = null;
            QHeader.JP_Adress2__c = null;
            QHeader.JP_Building__c = null;
            QHeader.JP_Department1__c = null;
            QHeader.JP_Department2__c = null;
            QHeader.JP_Title__c = null;
            QHeader.JP_TelNo__c = null;
            QHeader.JP_FaxNo__c  = null;

            // priceListTypeと親代理店コード
            this.priceListType = this.distributor[0].JP_Price_List_Type__c;
            this.parentDistributor = this.distributor[0].JP_MainDistributorCode__c;
        }else{
            //値をクリアする
            QHeader.JP_DistributorCode__c = null;
            QHeader.JP_Company__c = null;
            QHeader.JP_QuotationContact__c = null;
            QHeader.JP_Postcode__c = null;
            QHeader.JP_Adress1__c = null;
            QHeader.JP_Adress2__c = null;
            QHeader.JP_Building__c = null;
            QHeader.JP_Department1__c = null;
            QHeader.JP_Department2__c = null;
            QHeader.JP_Title__c = null;
            QHeader.JP_TelNo__c = null;
            QHeader.JP_FaxNo__c  = null;
            //基本見積条件をセット
            Map<Integer,String> defultConditionMap = new Map<Integer,String>();
            if(spotflg != '1'){
                defultConditionMap = getDistributorCondition(System.Label.JP_DistributorDefaultCondition1);
            }else{
                defultConditionMap = getDistributorCondition(System.Label.JP_DistributorDefaultCondition2);
            }

            if(defultConditionMap != null){
                QHeader.JP_QuotationCondition__c = defultConditionMap.values()[0] + '\n';
            }
        }

        // 価格年月デフォルト値
        if(this.QHeader.JP_PriceYearMonth__c != null){
            this.inputPriceYearMonth = this.QHeader.JP_PriceYearMonth__c;
        }else{
            String prefix = null;
            for (SelectOption so : this.getPriceYearMonthList()) {
                prefix = so.getValue().subString(0, 2) + ' ';
                break;
            }

            if (prefix != null) {
                this.inputPriceYearMonth = prefix + String.valueOf(Date.today().year()) + '/' + String.valueOf(Date.today().month()).leftPad(2, '0');
            }
        }
        
        //明細部の値をクリアする
        if(this.QDetailList.size() > 0){
            productDetailsClear();
        }

        return null;
    }

    //明細部の値をクリアする
    public void productDetailsClear(){
        for(Integer i = this.QDetailList.size() - 1; i >= 0; i--){
            if(this.QDetailList[i].obj.JP_ProductCatalogCode__c != TOUROKUGAI_Z && this.QDetailList[i].obj.JP_ProductCatalogCode__c != COMMENT_HYPHEN){
                this.QDetailList[i].obj.JP_ProductName__c = null;
                this.QDetailList[i].obj.JP_ProductCode__c = null;
                this.QDetailList[i].obj.JP_StandardPrice__c = null;
                this.QDetailList[i].obj.JP_WholeSaleRate__c = null;
                this.QDetailList[i].obj.JP_UnitPrice__c = null;
                this.QDetailList[i].obj.JP_SalesStatus__c = null;
                this.QDetailList[i].obj.JP_ReleaseScheduled__c = null;
                this.QDetailList[i].obj.JP_SalesEndScheduled__c = null;
                this.QDetailList[i].obj.JP_PriceYearMonth__c = null;
                this.QDetailList[i].obj.JP_AppGroupID__c = null;
                this.QDetailList[i].obj.JP_DistributorProCode__c = null;
                this.QDetailList[i].obj.JP_PriceBookEntryId__c = null;
                this.QDetailList[i].obj.JP_Category1__c = null;
                this.QDetailList[i].obj.JP_Category2__c = null;
                this.QDetailList[i].obj.JP_Maker__c = null;
                this.QDetailList[i].obj.JP_5PercentDiscount__c = null;
                this.QDetailList[i].obj.JP_WholeSalePriceMulQuantity__c = null;
                this.QDetailList[i].obj.JP_SpecialUnitPriceMulQuantity__c = null;
                this.QDetailList[i].obj.JP_StandardMinusSpecial__c = null;
                this.QDetailList[i].obj.JP_DeterminedAmount__c = null;
                this.QDetailList[i].obj.JP_RequiredMaintenanceFlag__c = false;
                this.QDetailList[i].obj.JP_QuotationRemarks__c = null;
                this.QDetailList[i].obj.JP_DiscountLimitPrice__c = null;
                this.QDetailList[i].obj.JP_SupportTicketCode__c = null;
                this.QDetailList[i].obj.JP_CampaignDecision__c = false;
                this.QDetailList[i].obj.JP_OpenPriceFlag__c = false;
                this.QDetailList[i].obj.JP_PreRelease__c = false;
                this.QDetailList[i].obj.JP_PiStock__c = false;
                this.QDetailList[i].obj.JP_LoweLimitPrice__c = null;
            }
        }
    }

    /***************************************
    * 顧客の変更時：顧客に紐付く情報をセットします
    * 　
    ***************************************/
    public Pagereference doChangeContact(){
        if(String.isNotBlank(QHeader.JP_QuotationContact__c)){            
             //部署情報から値を取得する
            List<JP_QuotationContact__c> jp_Qcontact = JP_QuotationContactDAO.getRecBySfId(QHeader.JP_QuotationContact__c);
            QHeader.JP_Postcode__c = jp_Qcontact[0].JP_CustomerPostcode__c;
            QHeader.JP_Adress1__c = jp_Qcontact[0].JP_CustomerAddress1__c;
            QHeader.JP_Adress2__c = jp_Qcontact[0].JP_CustomerAddress2__c;
            QHeader.JP_Building__c = jp_Qcontact[0].JP_CustomerBuilding__c;
            QHeader.JP_Department1__c = jp_Qcontact[0].JP_CustomerDept1__c;
            QHeader.JP_Department2__c = jp_Qcontact[0].JP_CustomerDept2__c;
            QHeader.JP_Title__c = jp_Qcontact[0].JP_Title_Position__c;
            QHeader.JP_TelNo__c = jp_Qcontact[0].JP_CustomerTelNo__c;
            QHeader.JP_FaxNo__c = jp_Qcontact[0].JP_CustomerFaxNo__c;
        }else{
            QHeader.JP_Postcode__c = null;
            QHeader.JP_Adress1__c = null;
            QHeader.JP_Adress2__c = null;
            QHeader.JP_Building__c = null;
            QHeader.JP_Department1__c = null;
            QHeader.JP_Department2__c = null;
            QHeader.JP_Title__c = null;
            QHeader.JP_TelNo__c = null;
            QHeader.JP_FaxNo__c  = null;
        } 
        

        return null;
    }

    /***************************************
    * 営業OUTユーザの変更時：営業OUTユーザに紐付く情報をセットします
    * 　
    ***************************************/
    public Pagereference doChangeOutuser(){
        if(QHeader.JP_Outside__c != null){            
            //自社情報
            User chgUsr = [Select Id,Name,JP_DeptCode__c From User Where Id =:QHeader.JP_Outside__c];
            //部署情報取得
            List<JP_Department__c> chg_Dp = JP_DepartmentDAO.getRecByUsrDepartment(chgUsr.JP_DeptCode__c);
            //部署情報から住所などをセット
            if(chg_Dp.size() > 0){
                //部署情報から値を取得する
                QHeader.JP_ATKK_Postcode__c = chg_Dp[0].JP_Postcode__c;
                QHeader.JP_ATKK_Address1__c = chg_Dp[0].JP_Address1__c;
                QHeader.JP_ATKK_Address2__c = chg_Dp[0].JP_Address2__c + chg_Dp[0].JP_Address3__c;
                QHeader.JP_ATKK_Building__c = chg_Dp[0].JP_Building__c;
                QHeader.JP_ATKK_Company__c = chg_Dp[0].JP_Company__c;
                QHeader.JP_atkkDepartment1__c = chg_Dp[0].JP_DeptCode__c;
                QHeader.JP_atkkTellNo__c = chg_Dp[0].JP_TelNo__c;
                QHeader.JP_atkkFaxNo__c = chg_Dp[0].JP_FaxNo__c;
                QHeader.JP_atkkDepartment2__c = chg_Dp[0].Name;
            }else{
                clearAkkInfo();
            }
        }else{
            clearAkkInfo();
        }
        return null;
    }

    //自社・部署に紐付く値をクリアする
    public void clearAkkInfo(){
        QHeader.JP_atkkDepartment1__c = null;
        QHeader.JP_ATKK_Postcode__c = null;
        QHeader.JP_ATKK_Address1__c = null;
        QHeader.JP_ATKK_Address2__c = null;
        QHeader.JP_ATKK_Building__c = null;
        QHeader.JP_ATKK_Company__c = null;
        QHeader.JP_atkkTellNo__c = null;
        QHeader.JP_atkkFaxNo__c = null;
    }



    /***************************************
    * 部署選択リストの変更時：部署に紐付く情報をセットします
    * 　
    ***************************************/
    public Pagereference doChangeDepaertment(){
        if(String.isNotBlank(QHeader.JP_atkkDepartment1__c)){            
             //部署情報から値を取得する
            List<JP_Department__c> jp_Dp = JP_DepartmentDAO.getRecByUsrDepartment(QHeader.JP_atkkDepartment1__c);
            if(jp_Dp.size() > 0){
                QHeader.JP_ATKK_Postcode__c = jp_Dp[0].JP_Postcode__c;
                QHeader.JP_ATKK_Address1__c = jp_Dp[0].JP_Address1__c;
                QHeader.JP_ATKK_Address2__c = jp_Dp[0].JP_Address2__c + jp_Dp[0].JP_Address3__c;
                QHeader.JP_ATKK_Building__c = jp_Dp[0].JP_Building__c;
                QHeader.JP_ATKK_Company__c = jp_Dp[0].JP_Company__c;
                QHeader.JP_atkkTellNo__c = jp_Dp[0].JP_TelNo__c;
                QHeader.JP_atkkFaxNo__c = jp_Dp[0].JP_FaxNo__c;
                QHeader.JP_atkkDepartment2__c = jp_Dp[0].Name;

            }
        }else{
            clearAkkInfo();
        } 
        return null;
    }


    /***************************************
    * 見積条件定型文一覧ボタン：見積条件定型文一覧を表示します
    * 　
    ***************************************/
     // 遷移用URL
    public String urlLink{set; get;}
    //ポップアップURLセット
    public PageReference doConditionList(){
        urlLink = null;
        urlLink = '/apex/JP_QuotationConditionList';
        return null;
    }


    /***************************************
    * 見積条件更新ボタン：見積条件を更新します
    * 　見積条件を取得し、ソートして表示する
    ***************************************/
    public Pagereference doCondition(){
        if(String.isNotBlank(this.QHeader.JP_QuotationDistCD__c) || this.QHeader.JP_QuotationDistCD__c !=null){
            this.distributor = JP_QuotationDistributorDAO.getRecByDistId(this.QHeader.JP_QuotationDistCD__c);
        }

        //代理店仕切価格表：製品の状態「リリース前」の場合 JP_PreRelease__c
        Boolean preRelease = false; 
        //代理店仕切価格表：製品の保守必須確認「true」の場合 JP_RequiredMaintenanceFlag__c
        Boolean requiredMaintenance = false;
        //代理店仕切価格表：キャンペーン中フラグがついている販売状態の製品がある場合 JP_CampaignDecision__c
        Boolean campaign = false;
        //見積明細：通常販売価格ではない製品が1明細でもある場合
        Boolean spPrice = false;
        //代理店仕切価格表：PI在庫誘導フラグがついている販売状態の製品がある場合 JP_PiStock__c
        Boolean piStock = false;
        //見積明細：サポチケ区分(サポチケ識別子かもしれません)がオンサイトの製品がある場合 JP_SupportTicketCode__c
        String spKbn = null;
        Boolean saPotiket = false;

        if(this.qDetailOriginalList.size()>0){
            for(Integer i = this.qDetailOriginalList.size() - 1; i >= 0; i--){
                //製品の状態「リリース前」
                if(this.qDetailOriginalList[i].obj.JP_PreRelease__c){
                    preRelease = true;
                }
                //製品の保守必須確認「true」の場合
                if(this.qDetailOriginalList[i].obj.JP_RequiredMaintenanceFlag__c){
                    requiredMaintenance = true;
                }
                //キャンペーン中フラグ
                if(this.qDetailOriginalList[i].obj.JP_CampaignDecision__c){
                    campaign = true;
                }
                //特別価格製品のフラグ
                if(this.qDetailOriginalList[i].obj.JP_StandardMinusSpecial__c > 1){
                    spPrice = true;
                }
                //PI在庫誘導フラグ
                if(this.qDetailOriginalList[i].obj.JP_PiStock__c){
                    piStock = true;
                }
                //サポチケ
                spKbn = this.qDetailOriginalList[i].obj.JP_SupportTicketCode__c;
                if(String.isNotBlank(spKbn) && spKbn.left(2) == 'ON'){
                    saPotiket = true;
                }
            }
        }

        Map<Integer,String> QuotationConditionMap = new Map<Integer,String>();
        //見積代理店に基づく見積条件を取得
        if(this.distributor.size() > 0  && String.isNotBlank(this.distributor[0].JP_DeafultQuotationCondition__c)){
            QuotationConditionMap = getDistributorCondition(this.distributor[0].JP_DeafultQuotationCondition__c);
        }

        //見積明細に基づく見積条件を取得
        QuotationConditionMap = getProductCondition(QuotationConditionMap,preRelease,requiredMaintenance,campaign,spPrice,piStock,saPotiket);

        //選択した定型文の見積条件を取得
        Set<String> mitumorijyokens = new Set<String>();
        if(String.isNotBlank(this.inputMitumorijyoken1)){
            mitumorijyokens.add(this.inputMitumorijyoken1);
        }
        if(String.isNotBlank(this.inputMitumorijyoken2)){
            mitumorijyokens.add(this.inputMitumorijyoken2);
        }
        if(String.isNotBlank(this.inputMitumorijyoken3)){
            mitumorijyokens.add(this.inputMitumorijyoken3);
        }
        if(String.isNotBlank(this.inputMitumorijyoken4)){
            mitumorijyokens.add(this.inputMitumorijyoken4);
        }
        if(String.isNotBlank(this.inputMitumorijyoken5)){
            mitumorijyokens.add(this.inputMitumorijyoken5);
        }
        if(String.isNotBlank(this.inputMitumorijyoken6)){
            mitumorijyokens.add(this.inputMitumorijyoken6);
        }
        if(String.isNotBlank(this.inputMitumorijyoken7)){
            mitumorijyokens.add(this.inputMitumorijyoken7);
        }
        if(String.isNotBlank(this.inputMitumorijyoken8)){
            mitumorijyokens.add(this.inputMitumorijyoken8);
        }

        if(mitumorijyokens.size()>0){
            QuotationConditionMap = getQuotationCondition(mitumorijyokens,QuotationConditionMap);
        }
        
        if(QuotationConditionMap == null){
            QHeader.JP_QuotationCondition__c = '';
            return null;
        }

        List<Integer> QuotationConditionList = new List<Integer>();
        QuotationConditionList.addAll(QuotationConditionMap.keySet());

        QHeader.JP_QuotationCondition__c = '';

        //基本文章セット
        Map<Integer,String> QuotationConditionDef = new Map<Integer,String>();

        if(this.QHeader.JP_QuotationEffectiveTerm__c == '999'){
            QHeader.JP_QuotationCondition__c += JP_QuotationConditionDAO.getRecByCondCode(System.Label.JP_DistributorDefaultCondition)[0].JP_QuotationCondition__c+ '\n';
        }

        if(this.distributor.size() > 0  && this.distributor[0].JP_SpotDistributor__c){
            QuotationConditionDef = getDistributorCondition(System.Label.JP_DistributorDefaultCondition2);
        }else{
            QuotationConditionDef = getDistributorCondition(System.Label.JP_DistributorDefaultCondition1);
        }
        
        if(QuotationConditionDef != null){
            QHeader.JP_QuotationCondition__c += QuotationConditionDef.values()[0] + '\n';
        }
        
        for(Integer i : QuotationConditionList){
            QHeader.JP_QuotationCondition__c += QuotationConditionMap.get(i) + '\n';
        }

        // priceListTypeと親代理店コード
        if(this.distributor.size() > 0 ){
            this.priceListType = this.distributor[0].JP_Price_List_Type__c;
            this.parentDistributor = this.distributor[0].JP_MainDistributorCode__c;
        }

        return null;
    }

    /**
     * 見積条件の初期化メソッド
     */
    public void setDefoultQuotationCondition(String distributorCondition){

        //基本見積条件をセット
        Map<Integer,String> defultQuotationConditionMap = new Map<Integer,String>();
        if(spotflg != '1'){
            defultQuotationConditionMap = getDistributorCondition(System.Label.JP_DistributorDefaultCondition1);
        }else{
            defultQuotationConditionMap = getDistributorCondition(System.Label.JP_DistributorDefaultCondition2);
        }
        
        if(defultQuotationConditionMap != null){
            QHeader.JP_QuotationCondition__c = defultQuotationConditionMap.values()[0] + '\n';
        }

        //代理店に紐付く見積条件をセット
        if(String.isNotBlank(distributorCondition)){
            Map<Integer,String> qcMap = new Map<Integer,String>();
            qcMap = getDistributorCondition(distributorCondition);
            if(qcMap != null && !qcMap.isEmpty()){
                QHeader.JP_QuotationCondition__c += qcMap.values()[0];
            }
        }

    }


    /**
     * 代理店の見積条件の文言を取得する
     */
    public Map<Integer,String> getDistributorCondition(String conditionCode){
        Map<Integer,String> distributorConditionMap = new Map<Integer,String>();

        List<JP_QuotationCondition__c> qc = JP_QuotationConditionDAO.getRecByCondCode(conditionCode);

        if(qc.size() == 0){
            return null;
        }

        for(JP_QuotationCondition__c rec : qc){
            if(rec.JP_QuotationCondition__c != null){
                distributorConditionMap.put(Integer.valueOf(rec.JP_QuotationConditionCode__c),rec.JP_QuotationCondition__c);
            }
        }
        return distributorConditionMap;
    }

    /**
     * 見積明細の製品に関する見積条件の文言を取得する
     */
    public Map<Integer,String> getProductCondition(Map<Integer,String> conditionMap,
                                                    Boolean preRelease,
                                                    Boolean requiredMaintenance,
                                                    Boolean campaign,
                                                    Boolean spPrice,
                                                    Boolean piStock,
                                                    Boolean saPotiket){

        Map<Integer,String> QuotationConditionMap = new Map<Integer,String>();
        Set<String> conditionCd = new Set<String>();

        //代理店仕切価格表：製品の状態「リリース前」の場合
        if(preRelease){
            conditionCd.add(System.Label.JP_ConditionCode1);
        }
        //代理店仕切価格表：製品の保守必須確認「true」の場合
        if(requiredMaintenance){
            conditionCd.add(System.Label.JP_ConditionCode2);
        }
        //見積明細：通常販売価格ではない製品が1明細でもある場合
        if(spPrice){
            conditionCd.add(System.Label.JP_ConditionCode3);
        }
        //代理店仕切価格表：キャンペーン中フラグがついている販売状態の製品がある場合
        if(campaign){
            conditionCd.add(System.Label.JP_ConditionCode4);
        }
        //代理店仕切価格表：PI在庫誘導フラグがついている販売状態の製品がある場合
        if(piStock){
            conditionCd.add(System.Label.JP_ConditionCode5);
        }
        //見積明細：サポチケ区分(サポチケ識別子かもしれません)がオンサイトの製品がある場合
        if(saPotiket){
            conditionCd.add(System.Label.JP_ConditionCode6);
        }

        QuotationConditionMap = getQuotationCondition(conditionCd,conditionMap);

        return QuotationConditionMap;
    }


    /**
     * 見積明細の製品に関する見積条件の文言を取得する
     */

    public Map<Integer,String> getQuotationCondition(Set<String> conditionCd,Map<Integer,String> conditionMap){
        
        Map<Integer,String> QuotationConditionMap = new Map<Integer,String>();
        List<JP_QuotationCondition__c> qcList = new List<JP_QuotationCondition__c>();
        
        if(conditionMap!=null){
            QuotationConditionMap.putAll(conditionMap);
        } 

        if(conditionCd.size() > 0){
            qcList = JP_QuotationConditionDAO.getRecByCondCDs(conditionCd);    
        }
        
        if(qcList.size() > 0){
            for(JP_QuotationCondition__c rec : qcList){
                if(QuotationConditionMap == null){
                    QuotationConditionMap.put(Integer.valueOf(rec.JP_QuotationConditionCode__c),rec.JP_QuotationCondition__c);
                }

                if(!QuotationConditionMap.containsKey(Integer.valueOf(rec.JP_QuotationConditionCode__c))){
                    QuotationConditionMap.put(Integer.valueOf(rec.JP_QuotationConditionCode__c),rec.JP_QuotationCondition__c);
                }
            }
        }

        return QuotationConditionMap;
    }


    /***************************************
    * 見積明細のボタン処理
    * 　・行追加
    *　　・行ソート
    *　　・行削除
    *　　・製品検索
    *　　・仕切表を元に計算
    ***************************************/
    /**
     * 1行追加
     */
    public void addRow() {
        JP_QuotationDetailSelect qds = new JP_QuotationDetailSelect(new JP_QuotationDetail__c());
        
        // Noと順の最大を算出して+1を設定
        Decimal no = 0;
        Decimal sortNo = 0;
        for (JP_QuotationDetailSelect originalQds : this.qDetailOriginalList) {
            JP_QuotationDetail__c qd = originalQds.obj;
            if (no < qd.JP_DetailsNo__c) {
                no = qd.JP_DetailsNo__c;
            }
            
            if (sortNo < qd.JP_Sort__c) {
                sortNo = qd.JP_Sort__c;
            }
        }
        
        qds.obj.JP_DetailsNo__c = no + 1;
        qds.obj.JP_Sort__c = sortNo + 1;
        this.qDetailOriginalList.add(qds);

        // 最終ページを表示してリスト再作成
        this.calcTotalPages();
        this.nowPageNum = this.totalPage;
        this.createQDetailList();
    }
    
    /**
     * 10行追加
     */
    public void addRow10() {
        // Noと順の最大を算出して+1を設定
        Decimal no = 0;
        Decimal sortNo = 0;
        for (JP_QuotationDetailSelect originalQds : this.qDetailOriginalList) {
            JP_QuotationDetail__c qd = originalQds.obj;
            if (no < qd.JP_DetailsNo__c) {
                no = qd.JP_DetailsNo__c;
            }
            
            if (sortNo < qd.JP_Sort__c) {
                sortNo = qd.JP_Sort__c;
            }
        }
        
        for(integer i = 1; i <= 10; i++){
            JP_QuotationDetailSelect qds = new JP_QuotationDetailSelect(new JP_QuotationDetail__c());
            qds.obj.JP_DetailsNo__c = no + i;
            qds.obj.JP_Sort__c = sortNo + i;
            this.qDetailOriginalList.add(qds);
        }

        // 最終ページを表示してリスト再作成
        this.calcTotalPages();
        this.nowPageNum = this.totalPage;
        this.createQDetailList();
    }

    /**
     * 1行挿入
     * ALLIEDTELESIS-416 20191126 Mod
     */
    public PageReference insertRow() {
        Integer i = Integer.valueOf(ApexPages.currentPage().getParameters().get('vf_rownumber'));
        JP_QuotationDetailSelect qds = new JP_QuotationDetailSelect(new JP_QuotationDetail__c());
        this.qDetailOriginalList.add(qds);

        for(Integer x = this.qDetailOriginalList.size()-1; x > i; x--){
            this.qDetailOriginalList[x] = this.qDetailOriginalList[x-1];
            this.qDetailOriginalList[x].obj.JP_Sort__c += 1;
        }

        this.qDetailOriginalList[i] = qds;
        
        // Noと順の最大を算出して+1を設定
        Decimal no = 0;
        for (JP_QuotationDetailSelect originalQds : this.qDetailOriginalList) {
            JP_QuotationDetail__c qd = originalQds.obj;
            if (no < qd.JP_DetailsNo__c) {
                no = qd.JP_DetailsNo__c;
            }
        }
        
        qds.obj.JP_DetailsNo__c = no + 1;
        qds.obj.JP_Sort__c = i + 1;

        // 最終ページを表示してリスト再作成
        this.calcTotalPages();
        this.nowPageNum = this.totalPage;
        this.createQDetailList();

        return null;
    }

    /**
     * 1行上へ
     * ALLIEDTELESIS-416 20191126 Mod
     */
    public PageReference upRow(){
        Integer i = Integer.valueOf(ApexPages.currentPage().getParameters().get('vf_rownumber2'));
        if(i > 0){
            JP_QuotationDetail__c qd = new JP_QuotationDetail__c();
            Boolean isSelect = false;
            qd = this.QDetailList[i-1].obj;
            isSelect = this.QDetailList[i-1].selected;
            this.QDetailList[i-1].obj = this.QDetailList[i].obj;
            this.QDetailList[i-1].obj.JP_Sort__c -= 1;
            this.QDetailList[i-1].obj.JP_DetailsNo__c -= 1;
            this.QDetailList[i-1].selected = this.QDetailList[i].selected;
            this.QDetailList[i].obj = qd;
            this.QDetailList[i].obj.JP_Sort__c += 1;
            this.QDetailList[i].obj.JP_DetailsNo__c += 1;
            this.QDetailList[i].selected = isSelect;
        }

        return null;
    }

    /**
     * 1行下へ
     * ALLIEDTELESIS-416 20191126 Mod
     */
    public PageReference downRow(){
        Integer i = Integer.valueOf(ApexPages.currentPage().getParameters().get('vf_rownumber3'));
        if(i < this.QDetailList.size()-1){
            JP_QuotationDetail__c qd = new JP_QuotationDetail__c();
            Boolean isSelect = false;
            qd = this.QDetailList[i+1].obj;
            isSelect = this.QDetailList[i+1].selected;
            this.QDetailList[i+1].obj = this.QDetailList[i].obj;
            this.QDetailList[i+1].obj.JP_Sort__c += 1;
            this.QDetailList[i+1].obj.JP_DetailsNo__c += 1;
            this.QDetailList[i+1].selected = this.QDetailList[i].selected;
            this.QDetailList[i].obj = qd;
            this.QDetailList[i].obj.JP_Sort__c -= 1;
            this.QDetailList[i].obj.JP_DetailsNo__c -= 1;
            this.QDetailList[i].selected = isSelect;
        }

        return null;
    }
    
    /**
     * 行ソート
     */
    public void sortRows() {
        this.qDetailOriginalList.sort();

        // ソート順とNoを振り直し
        Decimal no = 1;
        for(JP_QuotationDetailSelect rec : this.qDetailOriginalList) {
            rec.obj.JP_Sort__c = no;
            rec.obj.JP_DetailsNo__c = no;
            ++no;
        }

        // 1ページ目を表示してリスト再作成
        if(this.presaveFlg != '1') {
            this.nowPageNum = 1;
        }
        
        this.createQDetailList();
    }

    /**
     * 行削除
     */
    public void deleteRows(){
        Integer deleteCountNo = 0;

        List<Integer> deleteList = new List<Integer>();
        for(JP_QuotationDetailSelect qds : this.qDetailOriginalList) {
            /** 条件に合致するものを削除対象リストに格納 */
            if(qds.selected) {
                deleteList.add(deleteCountNo);
            } else { 
                // 条件に合致しなければ要素数をカウントアップしていく
                deleteCountNo++;
            }
        }
        
        /** 削除の実行 */
        for(Integer d : deleteList) {
            this.qDetailOriginalList.remove(d);
        }

        // リスト再作成
        this.calcTotalPages();
        this.createQDetailList();
        // 金額全計算
        this.allCalcAmounts();
    }

    /**
     * 製品検索
     */
     // 遷移用URL
    public String searchlLink{set; get;}
    //ポップアップURLセット
    public PageReference searchProduct(){
        urlLink = null;

        urlLink = '/apex/JP_QuotationConditionList?param1=&param2=&';
        return null;
    }

    /**
     * 仕切表を元に計算ボタン
     */
    public Pagereference doPriceYM(){
        doPriceYearMonth();
        return null;
    }
    
    public void doPriceYearMonth(){
        if(this.QHeader.JP_QuotationDistCD__c != null){
            // 指定された価格年月で全代理店仕切価格表を取得
            Set<String> productCatalogCodeSet = new Set<String>();
            for (JP_QuotationDetailSelect qds : this.qDetailOriginalList) {
                // 全角半角変換
                String str = qds.obj.JP_ProductCatalogCode__c;
                if(str != null){
                    // 商品コード　アルファベット全角⇒半角変換
                    str = JP_StringUtil.emAlphabetToEn(str);
                    // 商品コード　数値全角⇒半角変換
                    str = JP_StringUtil.emNumberToEn(str);
                    qds.obj.JP_ProductCatalogCode__c = str.toUpperCase();
                }

                if (qds.obj.JP_ProductCatalogCode__c == 'z' || qds.obj.JP_ProductCatalogCode__c == '****') {
                    // 登録外商品
                    qds.obj.JP_ProductCatalogCode__c = '****';
                    // 登録外商品の場合はエラーフラグ落とす
                    qds.obj.JP_IsProductError__c= false;
                    qds.isProductError = false;
                } else if (qds.obj.JP_ProductCatalogCode__c == '-') {
                    // MEMO
                    // 登録外商品の場合はエラーフラグ落とす
                    qds.obj.JP_IsProductError__c= false;
                    qds.isProductError = false;
                }
                
                if (!String.isEmpty(qds.obj.JP_ProductCatalogCode__c)) {
                    productCatalogCodeSet.add(qds.obj.JP_ProductCatalogCode__c);
                }
            }
            // 代理店仕切価格表取得しマッピング
            List<JP_DistributorPrice__c> dpList = JP_DistributorPriceDAO.selectForQuotationEdit(
                productCatalogCodeSet, 
                this.distributor.get(0).JP_Price_List_Type__c, 
                this.inputPriceYearMonth);
            Map<String, JP_DistributorPrice__c> dpMap = new Map<String, JP_DistributorPrice__c>();
            for (JP_DistributorPrice__c dp : dpList) {
                dpMap.put(dp.JP_ProductCatalogCode__c, dp);
            }

            // 代理店専用製品コード取得し990コードでマッピング
            Set<String> productCodeSet = new Set<String>();
            for (JP_DistributorPrice__c dp : dpList) {
                productCodeSet.add(dp.JP_ProductCode__c);
            }

            Map<String, JP_DistributorProductCode__c> dpcMap = new Map<String, JP_DistributorProductCode__c>();
            for (JP_DistributorProductCode__c dpc : JP_DistributorProductCodeDAO.selectDistributorProCode(
                this.distributor.get(0).JP_MainDistributorCode__c,
                productCodeSet)) {
                    dpcMap.put(dpc.JP_ProductCode__c, dpc);
            }

            // 明細に代理店仕切価格表の値をセットして計算
            for (JP_QuotationDetailSelect qds : qDetailOriginalList) {
                JP_QuotationDetail__c qd = qds.obj;
                
                // 代理店仕切価格表情報セット
                if (qd.JP_ProductCatalogCode__c != null) {
                    JP_DistributorPrice__c dp = dpMap.get(qd.JP_ProductCatalogCode__c);
                    if (dp != null) {
                        this.setDistributorPriceInfoToDetail(qd, dp);

                        // 代理店専用製品コードセット
                        JP_DistributorProductCode__c dpc = dpcMap.get(dp.JP_ProductCode__c);
                        if (dpc != null) {
                            qd.JP_DistributorProCode__c = dpc.JP_DistributorProCode__c;
                        }

                        qds.errProductCatalogCode = '';
                        qds.errCode = '';
                    } else if (qd.JP_ProductCatalogCode__c != '****' && qd.JP_ProductCatalogCode__c != '-') {
                        // 商品が見つからない場合は項目クリア
                        qds.errProductCatalogCode = qd.JP_ProductCatalogCode__c;
                        qds.errCode = '1';
                        this.clearDistributorPriceInfoToDetail(qd);
                    }
                }
                // 20220712 ALLIEDTELESIS-462 「仕切表を元に計算」「仮保存」押下時対応
                if (qd.JP_QuotationDetailType__c == null){
                    qd.JP_QuotationDetailType__c = '明細区分リセット用(システム利用)';
                }
            }

            // 金額全計算
            this.allCalcAmounts();
        }
    }

    /***************************************
    * ボタンの表示制御
    ***************************************/
    //保存ボタンの表示制御
    public Boolean getDispSave(){
        Boolean showed = false;
        // 見積状態が設定されていないか、「未承認」の場合はボタン出力
        if(String.isBlank(QHeader.JP_QuotationStatus__c) || JP_Const.QUOTATION_STATUS_UNAPPROVE == QHeader.JP_QuotationStatus__c){
            showed = true;
        // 承認申請された後
        }else{
            showed = chkUpdateAuth();
        }
        return showed;
    }
    
    //仮保存ボタンの表示制御
    public Boolean getDispPreSave(){
        Boolean showed = false;
        // 見積状態が設定されていないか、「未承認」の場合はボタン出力
        if(String.isBlank(QHeader.JP_QuotationStatus__c) || JP_Const.QUOTATION_STATUS_UNAPPROVE == QHeader.JP_QuotationStatus__c){
            showed = true;
        }
        return showed;
    }

    // 承認プロセスでロックされた時のボタン出しわけ
    @TestVisible
    private boolean chkUpdateAuth() {
        // ログインユーザのプロファイルIDを取得
        String profileId = UserInfo.getProfileId();
        // プロファイルIDからプロファイルの名称を取得
        String profileName = ProfileDAO.getRecById(profileId).Name;
        // プロファイル名：システム管理者
        String systemadmin = JP_Const.SYSTEM_ADMIN;
        
        Id recId = this.QHeader.Id;
        // 待機中の承認プロセスを取得
        List<ProcessInstance> piList = ProcessInstanceDAO.getProcessInstance(recId);

        //　承認プロセスがある
        if(piList.size() > 0 && piList[0].Workitems.size() > 0){
            Set<String> actors = new Set<String>();
            for(ProcessInstanceWorkItem piwi : piList[0].Workitems){
                if(!actors.contains(piwi.ActorId)){
                    actors.add(piwi.ActorId);
                }
            }

            // 承認者IDがキューであったら、キューに所属しているユーザのIDを取得しSetに追加
            actors = UserDAO.getUserByGroupId(actors);
            // ログインユーザが承認者でない かつ ログインユーザのプロファイルがシステム管理者でない ボタン消す
            if(!actors.contains(Userinfo.getUserId()) && profileName != systemadmin){
                return false;
            }else{
                return true;
            }
        //　承認プロセスがない場合、承認済でもシステム管理者はボタン出す。
        }else{
            if((JP_Const.QUOTATION_STATUS_APPROVE == QHeader.JP_QuotationStatus__c) && profileName == systemadmin){
                return true;
            }else{
                return false;
            }
        }
    }

    /***************************************
    * マスタの選択リスト化
    ***************************************/
    /** 
    * 部署プルダウン
    */
    public List<SelectOption> getDepartmentList() {
        List<SelectOption> DepartmentItems = new List<SelectOption>();
        //部署の一覧を取得する。
        Map<String,String> departmentMap = getDepartment();

        //プルダウンに追加
        DepartmentItems.add(new SelectOption('','---なし---'));

        for (String str : departmentMap.keySet()) {
            DepartmentItems.add(new SelectOption(str,departmentMap.get(str)));   
        }

        return DepartmentItems;
    }

    /**
    * 部署の一覧を取得する
    */
    private Map<String,String> getDepartment(){
        Map<String,String> resMap = new Map<String,String>();
        List<JP_Department__c> DepartmentList = [Select Name,JP_DeptCode__c
                                                From JP_Department__c 
                                                Where JP_EnabledQuotation__c = true 
                                                Order by Name
                                                ];
        for(JP_Department__c rec : DepartmentList){
            resMap.put(rec.JP_DeptCode__c,rec.Name);
        }
        return resMap;
    }

    /**
    * 見積条件プルダウン
    */
    public List<SelectOption> getQuotationConditionList() {
    
        List<SelectOption> QuotationConditionItems = new List<SelectOption>();
        
        //見積条件の一覧を取得する。
        Map<Integer,String> conditionMap = getQuotationCondition();
        List<Integer> conditionList = new List<Integer>();
        conditionList.addAll(conditionMap.keySet());

        //プルダウンに追加
        QuotationConditionItems.add(new SelectOption('','---なし---'));
        for (Integer i : conditionList) {
            if( i > 10000 && i < 20000){
                QuotationConditionItems.add(new SelectOption(String.valueOf(i),conditionMap.get(i))); 
            }              
        }  
        return QuotationConditionItems;
    }

    /**
    * 見積条件の一覧を取得する
    */
    private Map<Integer,String> getQuotationCondition(){
        Map<Integer,String> resMap = new Map<Integer,String>();
        List<JP_QuotationCondition__c> QuotationConditionList = JP_QuotationConditionDAO.getAllRec();

        for(JP_QuotationCondition__c rec : QuotationConditionList){
            resMap.put(Integer.valueof(rec.JP_QuotationConditionCode__c),rec.Name);
        }
        return resMap;
    }

    /**
    * 価格表プルダウン
    */
    public List<SelectOption> getPriceYearMonthList() {
        List<SelectOption> priceYearMonthItems = new List<SelectOption>();
        Set<String> priceYearMonthSet = new Set<String>();
        
        for (JP_PriceYearMonth__c pym : JP_PriceYearMonthDAO.selectFromPreviousMonth(this.priceListType)) {
            priceYearMonthItems.add(new SelectOption(pym.JP_PriceYearMonth__c, pym.JP_PriceYearMonth__c));
            priceYearMonthSet.add(pym.JP_PriceYearMonth__c);
        }
        
        system.debug('========== JP_PriceYearMonth__c : ' + this.QHeader.JP_PriceYearMonth__c);
        
        if(!priceYearMonthSet.contains(this.QHeader.JP_PriceYearMonth__c) && this.QHeader.JP_PriceYearMonth__c != null){
            priceYearMonthItems.add(new SelectOption(this.QHeader.JP_PriceYearMonth__c, this.QHeader.JP_PriceYearMonth__c));
        }
        return priceYearMonthItems;
    }

    /**
     * 任意の位置で切り捨て
     * @param roundNumber 切り捨て対象の数値
     * @param decimalPlace 切り捨てする位置
     * @return 切り捨てした結果
     */
    public Decimal roundNumber(Decimal roundNumber, Integer decimalPlace){
        if(roundNumber != null){
            return roundNumber.setScale(decimalPlace, RoundingMode.DOWN);
        } else {
            return 0;
        }
    }

    /**
     * 商品検索処理
     * @return null
     */
    public PageReference searchProductInfo() {
        System.debug('========== searchProductInfo start ==========');
        String rowNum = ApexPages.currentPage().getParameters().get('rowNum');
        recNumber = Integer.valueOf(rowNum);
        System.debug('◆◆◆◆◆◆rowNum◆◆◆◆◆' + rowNum);
        Boolean isProductError = false;
        if (!String.isEmpty(rowNum) && this.QDetailList.size() >= Integer.valueOf(rowNum)) {

            // 行番号から編集された明細を取得
            JP_QuotationDetailSelect qds = this.QDetailList.get(Integer.valueOf(rowNum));
            // System.debug (qds); // Alliedtelesis-462 Add
            if (qds != null && !String.isEmpty(qds.obj.JP_ProductCatalogCode__c)) {
                // zを半角小文字に変換
                qds.obj.JP_ProductCatalogCode__c = this.replaceHalfSmallZ(qds.obj.JP_ProductCatalogCode__c);

                // 明細区分を自動計算させるようにセット // Alliedtelesis-462 Add
                qds.obj.JP_QuotationDetailType__c = '明細区分リセット用(システム利用)';

                // 商品検索
                if (qds.obj.JP_ProductCatalogCode__c != 'z'
                        && qds.obj.JP_ProductCatalogCode__c != '****'
                        && qds.obj.JP_ProductCatalogCode__c != '-'
                        && this.inputPriceYearMonth != null
                        && this.distributor.get(0).JP_Price_List_Type__c != null) {
                    JP_DistributorPrice__c dp = null;
                    List<JP_DistributorPrice__c> dpList = JP_DistributorPriceDAO.selectForQuotationEdit(
                                                            new Set<String>{qds.obj.JP_ProductCatalogCode__c},
                                                            this.distributor.get(0).JP_Price_List_Type__c,
                                                            this.inputPriceYearMonth
                                                            );
                    if (dpList.size() > 0) {
                        dp = dpList.get(0);
                        // 値設定
                        this.setDistributorPriceInfoToDetail(qds.obj, dp);

                        // 代理店専用製品コード設定
                        List<JP_DistributorProductCode__c> dpcList = 
                            JP_DistributorProductCodeDAO.selectDistributorProCode(this.distributor.get(0).JP_MainDistributorCode__c, new Set<String>{dp.JP_ProductCode__c});
                        if (dpcList.size() > 0) {
                            qds.obj.JP_DistributorProCode__c = dpcList.get(0).JP_DistributorProCode__c;
                        }
                        //商品あるから、エラーフラグを落とす
                        qds.obj.JP_IsProductError__c= false;
                        qds.isProductError = false;
                        
                        // メッセージコード設定
                        if (dp.JP_IsSpecialDistributorProduct__c) {
                            // 特殊代理店用製品
                            qds.errProductCatalogCode = qds.obj.JP_ProductCatalogCode__c;
                            qds.errCode = '2';
                        } else if (dp.JP_PiStock__c) {
                            // PI在庫誘導製品
                            qds.errProductCatalogCode = qds.obj.JP_ProductCatalogCode__c;
                            qds.errCode = '3';
                        }
                    } else {
                        // 商品が見つからない
                        qds.errProductCatalogCode = qds.obj.JP_ProductCatalogCode__c;
                        qds.errCode = '1';
                        qds.obj.JP_IsProductError__c= true;
                        this.clearDistributorPriceInfoToDetail(qds.obj);

                        isProductError = true;
                    }
                } else if (qds.obj.JP_ProductCatalogCode__c == 'z' || qds.obj.JP_ProductCatalogCode__c == '****') {
                    // 登録外商品
                    this.clearDistributorPriceInfoToDetail(qds.obj);
                    qds.obj.JP_ProductCatalogCode__c = '****';
                    // 登録外商品の場合はエラーフラグ落とす
                    qds.obj.JP_IsProductError__c= false;
                    qds.isProductError = false;
                } else if (qds.obj.JP_ProductCatalogCode__c == '-') {
                    // MEMO
                    this.clearDetailColumns(qds.obj);
                    // 登録外商品の場合はエラーフラグ落とす
                    qds.obj.JP_IsProductError__c= false;
                    qds.isProductError = false;
                }
            }

            if (qds != null) {
                System.debug('========== productError:' + isProductError);
                qds.isProductError = isProductError;
            }
        }

        // 金額再計算
        this.allCalcAmounts();
        
        return null;
    }

    /**
     * 代理店仕切価格表の項目を見積明細へセットします
     * @param qd 見積明細
     * @param dp 代理店仕切価格表
     */
    @TestVisible
    private void setDistributorPriceInfoToDetail(JP_QuotationDetail__c qd, JP_DistributorPrice__c dp) {
        qd.JP_ProductName__c = dp.JP_ProductName__c;
        qd.JP_ProductCode__c = dp.JP_ProductCode__c;
        qd.JP_StandardPrice__c = dp.JP_ExpirvStandardPrice__c;
        qd.JP_WholeSaleRate__c = dp.JP_WholeSaleRate__c;
        qd.JP_UnitPrice__c = dp.JP_WholeSalePrice__c;
        qd.JP_SalesStatus__c = dp.JP_SaleStatus__c;
        qd.JP_ReleaseScheduled__c = dp.JP_ReleaseDate__c;
        qd.JP_SalesEndScheduled__c = dp.JP_SalesEndScheduledPeriod__c;
        qd.JP_PriceYearMonth__c = dp.JP_PriceYearMonth__c;
        qd.JP_AppGroupID__c = dp.JP_AppGroupID__c;
        qd.JP_PriceBookEntryId__c = dp.JP_PriceBookEntryId__c;
        qd.JP_Category1__c = dp.JP_Category1__c;
        qd.JP_Category2__c = dp.JP_Category2__c;
        qd.JP_Maker__c = dp.JP_Maker__c;
        qd.JP_5PercentDiscount__c = dp.JP_5PercentDiscount__c;
        qd.JP_RequiredMaintenanceFlag__c = dp.JP_RequiredMaintenanceFlag__c;
        qd.JP_QuotationRemarks__c = dp.JP_QuotationRemarks__c;
        qd.JP_DiscountLimitPrice__c = dp.JP_ExpirvDiscountLimit__c;
        qd.JP_SupportTicketCode__c = dp.JP_SupportTicketClassificationCode__c;
        qd.JP_CampaignDecision__c = dp.JP_CampaignDecision__c;
        qd.JP_OpenPriceFlag__c = dp.JP_OpenPriceFlag__c;
        qd.JP_PreRelease__c = dp.JP_PreRelease__c;
        qd.JP_PiStock__c = dp.JP_PiStock__c;

    }
    
    /**
     * 見積明細の代理店仕切価格表に関連する項目をクリアします
     * @param qd 見積明細
     */
    @TestVisible
    private void clearDistributorPriceInfoToDetail(JP_QuotationDetail__c qd) {
        qd.JP_ProductName__c = null;
        qd.JP_ProductCode__c = null;
        qd.JP_StandardPrice__c = null;
        qd.JP_WholeSaleRate__c = null;
        qd.JP_UnitPrice__c = null;
        qd.JP_SalesStatus__c = null;
        qd.JP_ReleaseScheduled__c = null;
        qd.JP_SalesEndScheduled__c = null;
        qd.JP_PriceYearMonth__c = null;
        qd.JP_AppGroupID__c = null;
        qd.JP_DistributorProCode__c = null;
        qd.JP_PriceBookEntryId__c = null;
        qd.JP_Category1__c = null;
        qd.JP_Category2__c = null;
        qd.JP_Maker__c = null;
        qd.JP_5PercentDiscount__c = null;
        qd.JP_RequiredMaintenanceFlag__c = false;
        qd.JP_QuotationRemarks__c = null;
        qd.JP_DiscountLimitPrice__c = null;
        qd.JP_SupportTicketCode__c = null;
        qd.JP_CampaignDecision__c = false;
        qd.JP_OpenPriceFlag__c = false;
        qd.JP_PreRelease__c = false;
        qd.JP_PiStock__c = false;
        qd.JP_LoweLimitPrice__c = null;
        /** 20160119 追加 */
        qd.JP_Quantity__c = null;
        /** 20160225 追加 */
        qd.JP_SpecialUnitPrice__c = null;
        qd.JP_SpecialWholeSaleTRate__c = null;
        /** 20160804 追加 */
        qd.JP_QuotationDescription__c = null;
        qd.JP_Unit__c = null;
    }

    /**
     * 見積明細の項目を商品コード、商品名以外クリアします
     * @param qd 見積明細
     */
    @TestVisible
    private void clearDetailColumns(JP_QuotationDetail__c qd) {
System.debug('========== clearDetailColumns start ==========');
        this.clearDistributorPriceInfoToDetail(qd);
        qd.JP_OverLimitDiscount__c = false;
        qd.JP_WholeSalePriceMulQuantity__c = null;
        qd.JP_SpecialUnitPriceMulQuantity__c = null;
        qd.JP_StandardMinusSpecial__c = null;
        qd.JP_DeterminedAmount__c = null;
        qd.JP_Quantity__c = null;
        qd.JP_Unit__c = null;
        qd.JP_SpecialWholeSaleTRate__c = null;
        qd.JP_QuotationRemarks__c = null;
        /** 20160225 追加 */
        qd.JP_SpecialUnitPrice__c = null;
        /** 20160804 追加 */
        qd.JP_QuotationDescription__c = null;
    }

    /**
     * 大文字もしくは全角のzを小文字半角のzに変換します
     * @param src 対象文字列
     * @return 変換されたz
     */
    @TestVisible
    private String replaceHalfSmallZ(String src) {
        String dest = src;
        if (dest.length() == 1) {
            dest = dest.replace('Z', 'z').replace('ｚ', 'z').replace('Ｚ', 'z');
        }
        return dest;
    }

    /**
     * 各種金額計算を行います
     * @param src 見積明細
     */
    @TestVisible
    private void calcAmounts(JP_QuotationDetail__c src) {
        Decimal unitPrice = this.null2Zero(src.JP_UnitPrice__c);
        Decimal standardPrice = this.null2Zero(src.JP_StandardPrice__c);
        Decimal specialUnitPrice = 0;
        Decimal specialWholeSaleTRate = 0;
        Decimal quantity = this.null2Zero(src.JP_Quantity__c);
        
        //20151015 削除　if (inputUnitPrice) {
        if (this.QHeader.JP_InputUnitPrice__c) {
            specialUnitPrice = this.null2Zero(src.JP_SpecialUnitPrice__c);

            if (standardPrice != 0) {
                src.JP_SpecialWholeSaleTRate__c = specialUnitPrice / standardPrice;
                src.JP_SpecialWholeSaleTRate__c = src.JP_SpecialWholeSaleTRate__c.setScale(4, RoundingMode.HALF_UP);
            } else {
                src.JP_SpecialWholeSaleTRate__c = 0;
            }
            specialWholeSaleTRate = src.JP_SpecialWholeSaleTRate__c;
        } else {
            specialWholeSaleTRate = this.null2Zero(src.JP_SpecialWholeSaleTRate__c);
            src.JP_SpecialUnitPrice__c = Math.floor(standardPrice * specialWholeSaleTRate / 10) * 10;
            specialUnitPrice = src.JP_SpecialUnitPrice__c;
        }
     
        src.JP_WholeSalePriceMulQuantity__c = unitPrice * quantity;
        src.JP_SpecialUnitPriceMulQuantity__c = specialUnitPrice * quantity;

        // 差額（通常-特価）
        specialUnitPrice = this.null2Zero(src.JP_SpecialUnitPrice__c);
        //　特別仕切単価が0だったら、「仕切単価×数量」を利用して計算する。
        if (specialUnitPrice == 0) {
            src.JP_StandardMinusSpecial__c = src.JP_WholeSalePriceMulQuantity__c - src.JP_WholeSalePriceMulQuantity__c;
        } else {
            src.JP_StandardMinusSpecial__c = src.JP_WholeSalePriceMulQuantity__c - src.JP_SpecialUnitPriceMulQuantity__c;
        }
// Alliedtelesis-462 Add start
        Decimal determinedAmount = 0;
        Boolean determinedAmountChangeFlg = false;
        if( src.JP_DeterminedAmount__c > 0){
            determinedAmount = src.JP_DeterminedAmount__c;
        }
// Alliedtelesis-462 Add end
        if (src.JP_SpecialUnitPrice__c > 0) {
            src.JP_DeterminedAmount__c = src.JP_SpecialUnitPriceMulQuantity__c;
        } else {
            src.JP_DeterminedAmount__c = src.JP_WholeSalePriceMulQuantity__c;
        }
// Alliedtelesis-462 Add start
        if( (determinedAmount == 0 || determinedAmount == null) && src.JP_DeterminedAmount__c > 0){
            determinedAmountChangeFlg = true;
        }
// Alliedtelesis-462 Add end
        //値引限度額超の判定
        if( src.JP_SpecialUnitPrice__c == 0 || src.JP_SpecialUnitPrice__c == null){
            if(src.JP_UnitPrice__c < src.JP_DiscountLimitPrice__c){
                src.JP_OverLimitDiscount__c = true;
            }else{
                src.JP_OverLimitDiscount__c = false;
            }
        }else if (src.JP_SpecialUnitPrice__c < src.JP_DiscountLimitPrice__c) {
            src.JP_OverLimitDiscount__c = true;
        } else {
            src.JP_OverLimitDiscount__c = false;
        }
        
        setDefaultQuotationDetail (src,determinedAmountChangeFlg); // Alliedtelesis-462 Add
    }
// Alliedtelesis-462 Add start
    /**
     * 明細区分項目のデフォルト値をセットします
     * @param src 見積明細
     */
    @TestVisible
    private void setDefaultQuotationDetail (JP_QuotationDetail__c src,Boolean determinedAmountChangeFlg) {

        // 明細区分が「なし」で確定金額が0円になった時→明細区分を「集計外」にする
        //if (src.JP_QuotationDetailType__c == null && src.JP_DeterminedAmount__c == 0){
        if (src.JP_ProductCatalogCode__c != null && src.JP_ProductCatalogCode__c == '-'){
            src.JP_QuotationDetailType__c = JP_Const.QUOTATIONDETAILTYPE_NOTTOTALED;
        }
        // 明細区分が「集計外」で確定金額が1円以上になった時→条件に合う明細区分にする
        //if (src.JP_QuotationDetailType__c == JP_Const.QUOTATIONDETAILTYPE_NOTTOTALED && src.JP_DeterminedAmount__c >= 1) {
        if (src.JP_QuotationDetailType__c == JP_Const.QUOTATIONDETAILTYPE_NOTTOTALED && determinedAmountChangeFlg) {
            if (src.JP_ProductCatalogCode__c != null && src.JP_ProductCatalogCode__c.startsWith ('MEMO'))
                src.JP_QuotationDetailType__c = '';             // 商品コードが MEMO から始まるとき, 空欄
            else if (src.JP_ProductCatalogCode__c != null && src.JP_ProductCatalogCode__c == '****')
                src.JP_QuotationDetailType__c = '';             // 商品コードが **** のとき, 空欄
            // ALLIEDTELESIS-523 mod start
            else if (src.JP_ProductCatalogCode__c != null && src.JP_ProductCatalogCode__c.contains('R1'))
                src.JP_QuotationDetailType__c = JP_Const.QUOTATIONDETAILTYPE_PRODUCT_SUBSCRIPTION;  // 商品コードに R1 を含むとき, 製品サブスク
            else if (src.JP_ProductCatalogCode__c != null && src.JP_ProductCatalogCode__c.contains('R6'))
                src.JP_QuotationDetailType__c = JP_Const.QUOTATIONDETAILTYPE_PRODUCT_SUBSCRIPTION;  // 商品コードに R6 を含むとき, 製品サブスク
            else if (src.JP_ProductCatalogCode__c != null && src.JP_ProductCatalogCode__c.contains('R8'))
                src.JP_QuotationDetailType__c = JP_Const.QUOTATIONDETAILTYPE_PRODUCT_SUBSCRIPTION;  // 商品コードに R8 を含むとき, 製品サブスク
            else if (src.JP_ProductCatalogCode__c != null && src.JP_ProductCatalogCode__c.contains('R9'))
                src.JP_QuotationDetailType__c = JP_Const.QUOTATIONDETAILTYPE_PRODUCT_SUBSCRIPTION;  // 商品コードに R9 を含むとき, 製品サブスク
            else if (src.JP_ProductCode__c != null && src.JP_ProductCode__c.startsWith ('ATSS'))
                src.JP_QuotationDetailType__c = JP_Const.QUOTATIONDETAILTYPE_MAINTENANCE;         // 990 コードが ATSS から始まるとき, 保守
            else if (src.JP_ProductCode__c != null && src.JP_ProductCode__c.startsWith ('ITS'))
                src.JP_QuotationDetailType__c = JP_Const.QUOTATIONDETAILTYPE_I_TEST;                // 990 コードが ITS から始まるとき, i-Test
            else if (src.JP_ProductCode__c != null && src.JP_ProductCode__c.startsWith ('CMP'))
                src.JP_QuotationDetailType__c = JP_Const.QUOTATIONDETAILTYPE_NET_CAMPUS;            // 990 コードが CMP から始まるとき, Net.Campus
            // ALLIEDTELESIS-523 mod end
            else
                src.JP_QuotationDetailType__c = JP_Const.QUOTATIONDETAILTYPE_DEVICE;          // それ以外のときは機器
        }

        if (src.JP_QuotationDetailType__c != '明細区分リセット用(システム利用)')
            return;

        if (src.JP_ProductCatalogCode__c != null && src.JP_ProductCatalogCode__c == '****')
            src.JP_QuotationDetailType__c = '';             // 商品コードが **** のとき, 空欄
        //else if (src.JP_DeterminedAmount__c == 0)
        else if (src.JP_ProductCatalogCode__c != null && src.JP_ProductCatalogCode__c == '-')
            src.JP_QuotationDetailType__c = JP_Const.QUOTATIONDETAILTYPE_NOTTOTALED;        // 確定金額が 0 のとき, 集計外
        else if (src.JP_ProductCatalogCode__c != null && src.JP_ProductCatalogCode__c.startsWith ('MEMO'))
            src.JP_QuotationDetailType__c = '';             // 商品コードが MEMO から始まるとき, 空欄
        else if (src.JP_ProductCatalogCode__c == null)
            src.JP_QuotationDetailType__c = '';             // 商品コードが 空欄 のとき, 空欄
        // ALLIEDTELESIS-523 mod start
        else if (src.JP_ProductCatalogCode__c != null && src.JP_ProductCatalogCode__c.contains('R1'))
            src.JP_QuotationDetailType__c = JP_Const.QUOTATIONDETAILTYPE_PRODUCT_SUBSCRIPTION;  // 商品コードに R1 を含むとき, 製品サブスク
        else if (src.JP_ProductCatalogCode__c != null && src.JP_ProductCatalogCode__c.contains('R6'))
            src.JP_QuotationDetailType__c = JP_Const.QUOTATIONDETAILTYPE_PRODUCT_SUBSCRIPTION;  // 商品コードに R6 を含むとき, 製品サブスク
        else if (src.JP_ProductCatalogCode__c != null && src.JP_ProductCatalogCode__c.contains('R8'))
            src.JP_QuotationDetailType__c = JP_Const.QUOTATIONDETAILTYPE_PRODUCT_SUBSCRIPTION;  // 商品コードに R8 を含むとき, 製品サブスク
        else if (src.JP_ProductCatalogCode__c != null && src.JP_ProductCatalogCode__c.contains('R9'))
            src.JP_QuotationDetailType__c = JP_Const.QUOTATIONDETAILTYPE_PRODUCT_SUBSCRIPTION;  // 商品コードに R9 を含むとき, 製品サブスク
        else if (src.JP_ProductCode__c != null && src.JP_ProductCode__c.startsWith ('ATSS'))
            src.JP_QuotationDetailType__c = JP_Const.QUOTATIONDETAILTYPE_MAINTENANCE;           // 990 コードが ATSS から始まるとき, 保守
        else if (src.JP_ProductCode__c != null && src.JP_ProductCode__c.startsWith ('ITS'))
            src.JP_QuotationDetailType__c = JP_Const.QUOTATIONDETAILTYPE_I_TEST;                // 990 コードが ITS から始まるとき, i-Test
        else if (src.JP_ProductCode__c != null && src.JP_ProductCode__c.startsWith ('CMP'))
            src.JP_QuotationDetailType__c = JP_Const.QUOTATIONDETAILTYPE_NET_CAMPUS;            // 990 コードが CMP から始まるとき, Net.Campus
        // ALLIEDTELESIS-523 mod end
        else
            src.JP_QuotationDetailType__c = JP_Const.QUOTATIONDETAILTYPE_DEVICE;            // それ以外のときは機器

    }
    
    @TestVisible
    private void setDefaultQuotationDetail (JP_QuotationDetailSelect qds) {

        if (qds.obj.JP_ProductCatalogCode__c != null && qds.obj.JP_ProductCatalogCode__c == '****')
            qds.obj.JP_QuotationDetailType__c = '';             // 商品コードが **** のとき, 空欄
        //else if (qds.obj.JP_DeterminedAmount__c == 0)
        else if (qds.obj.JP_ProductCatalogCode__c != null && qds.obj.JP_ProductCatalogCode__c == '-')
            qds.obj.JP_QuotationDetailType__c = JP_Const.QUOTATIONDETAILTYPE_NOTTOTALED;        // 確定金額が 0 のとき, 集計外
        else if (qds.obj.JP_ProductCatalogCode__c != null && qds.obj.JP_ProductCatalogCode__c.startsWith ('MEMO'))
            qds.obj.JP_QuotationDetailType__c = '';             // 商品コードが MEMO から始まるとき, 空欄
        // ALLIEDTELESIS-523 mod start
        else if (qds.obj.JP_ProductCatalogCode__c != null && qds.obj.JP_ProductCatalogCode__c.contains('R1'))
            qds.obj.JP_QuotationDetailType__c = JP_Const.QUOTATIONDETAILTYPE_PRODUCT_SUBSCRIPTION;  // 商品コードに R1 を含むとき, 製品サブスク
        else if (qds.obj.JP_ProductCatalogCode__c != null && qds.obj.JP_ProductCatalogCode__c.contains('R6'))
            qds.obj.JP_QuotationDetailType__c = JP_Const.QUOTATIONDETAILTYPE_PRODUCT_SUBSCRIPTION;  // 商品コードに R6 を含むとき, 製品サブスク
        else if (qds.obj.JP_ProductCatalogCode__c != null && qds.obj.JP_ProductCatalogCode__c.contains('R8'))
            qds.obj.JP_QuotationDetailType__c = JP_Const.QUOTATIONDETAILTYPE_PRODUCT_SUBSCRIPTION;  // 商品コードに R8 を含むとき, 製品サブスク
        else if (qds.obj.JP_ProductCatalogCode__c != null && qds.obj.JP_ProductCatalogCode__c.contains('R9'))
            qds.obj.JP_QuotationDetailType__c = JP_Const.QUOTATIONDETAILTYPE_PRODUCT_SUBSCRIPTION;  // 商品コードに R9 を含むとき, 製品サブスク
        else if (qds.obj.JP_ProductCode__c != null && qds.obj.JP_ProductCode__c.startsWith ('ATSS'))
            qds.obj.JP_QuotationDetailType__c = JP_Const.QUOTATIONDETAILTYPE_MAINTENANCE;           // 990 コードが ATSS から始まるとき, 保守
        else if (qds.obj.JP_ProductCode__c != null && qds.obj.JP_ProductCode__c.startsWith ('ITS'))
            qds.obj.JP_QuotationDetailType__c = JP_Const.QUOTATIONDETAILTYPE_I_TEST;                // 990 コードが ITS から始まるとき, i-Test
        else if (qds.obj.JP_ProductCode__c != null && qds.obj.JP_ProductCode__c.startsWith ('CMP'))
            qds.obj.JP_QuotationDetailType__c = JP_Const.QUOTATIONDETAILTYPE_NET_CAMPUS;            // 990 コードが CMP から始まるとき, Net.Campus
        // ALLIEDTELESIS-523 mod end
        else
            qds.obj.JP_QuotationDetailType__c = JP_Const.QUOTATIONDETAILTYPE_DEVICE;            // それ以外のときは機器
    }
    
    // 見積明細に対して条件に合う明細区分にする
    public void setDefaultQuotationDetail () {
        for (Integer i = 0; i < qDetailOriginalList.size (); i++) {
            setDefaultQuotationDetail (qDetailOriginalList[i]);
        }
    }

/* 見積明細の完了予定日は保留になったので現在はコールされない
    // 全ての見積明細に対して、入力した完了予定日をセットする
    public void allSetCompletionScheduled () {
        for (JP_QuotationDetailSelect qds : this.qDetailOriginalList) {
            qds.obj.JP_CompletionScheduled__c = QDetailDummy.obj.JP_CompletionScheduled__c;
        }
    }
    // 選択した見積明細に対して、入力した完了予定日をセットする
    public void selectSetCompletionScheduled () {
        for (JP_QuotationDetailSelect qds : this.qDetailOriginalList) {
            if(qds.selected){
                qds.obj.JP_CompletionScheduled__c = QDetailDummy.obj.JP_CompletionScheduled__c;
            }
        }
    }
*/
// Alliedtelesis-462 Add end

    /**
     * nullを0に変換します
     * @param src 変換対象
     * @return 変換した値
     */
    @TestVisible
    private Decimal null2Zero(Decimal src) {
        Decimal dest = src;
        if (src == null) {
            dest = 0;
        }
        return dest;
    }

    /**
     * 全明細の各種金額計算を行います
     * @return null
     */
    public PageReference allCalcAmounts() {
        Decimal totalStandardAmount = 0;
        Decimal discountAmount = 0;
        for (JP_QuotationDetailSelect qds : this.qDetailOriginalList) {
            this.calcAmounts(qds.obj);
            totalStandardAmount += qds.obj.JP_WholeSalePriceMulQuantity__c;
            discountAmount += qds.obj.JP_StandardMinusSpecial__c;            
            
            String str = qds.obj.JP_ProductCatalogCode__c;
            if(str != null){
                // 商品コード　アルファベット全角⇒半角変換
                str = JP_StringUtil.emAlphabetToEn(str);
                // 商品コード　数値全角⇒半角変換
                str = JP_StringUtil.emNumberToEn(str);

                qds.obj.JP_ProductCatalogCode__c = str.toUpperCase();
            }            
        }
        this.qHeader.JP_TotalStandardAmount__c = totalStandardAmount;
        this.qHeader.JP_DiscountAmount__c = discountAmount;
        this.qHeader.JP_TotalAmount__c = totalStandardAmount - discountAmount;
        return null;
    }

    /**
     * 前ページ前へ
     * @return null
     */
    public PageReference doPrev() {
        if (this.nowPageNum > 1) {
            --this.nowPageNum;
        }
        this.createQDetailList();
        return null;
    }

    /**
     * 次ページヘ
     * @return null
     */
    public Pagereference doNext() {
        if (this.nowPageNum < this.totalPage) {
            ++this.nowPageNum;
        }
        this.createQDetailList();
        return null;
    }

    /**
     * 最後のページヘ移動します
     * @return null
     */
    public PageReference moveLastPage() {
        this.calcTotalPages();
        this.nowPageNum = this.totalPage;
        this.createQDetailList();
        return null;
    }

    /**
     * 製品検索ダイアログでの明細一覧リフレッシュ用
     * @return null
     */
    public PageReference refleshDetails() {
        this.allCalcAmounts();
        this.createQDetailList();
        return null;
    }
    public String getError() {
        for(ApexPages.Message message : ApexPages.getmessages()) {
            return message.getDetail();
        }
        return '';
    }
}