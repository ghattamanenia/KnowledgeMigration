/*******************
Description: This cord is a controller for screens choosing a price list.
Developer: Hitachi Solutions, Ltd.
Date Created: 10/1/2010
Date Modified: 8/25/2011
*****************/
/**
 * 価格表選択画面用コントローラ -
 */
public class ATFE_ChoosePricebookController {

    //価格表選択画面に表示
    //Selection screen price list
    String headerVal ='価格表選択画面        宛名会社  を選択';
    String smallHeader='宛名会社';

    //価格表選択機能を呼び出した商談情報の保持に利用
    //Opportunity to hold information on calling the selection function price list
    Opportunity opp;

    //どのRegionの価格表選択処理かの判断に利用
    //Region used to determine if any selection process price list
    String PROFILE_SPLITTER = '_';
    String sRegion = null;

    //EMEA、NAの価格表選択に利用
    //EMEA, NA price list used to select
    ATFE_PricebookManager pbm;

    //Exceptionの用意
    //Exception Provision
    ATFE_Exception expWord = new ATFE_Exception();

    //各リストのデフォルト値を商談に持つため利用
    //To have the opportunity to use the default value for each list
    String selectValue = null;

    //本機能の起動箇所の判断 - 価格表選択ボタン=0、見積作成ボタン=1
    //This function determines the starting point - price list selection button = 0, quoting = one button
    Integer spmsMode = 0;
    //Whether this function triggered by "AddProducts button" (YES:1/No:0)
    Integer addProducts = 0;

    //商談のIDを保持
    //ID holds business meeting
    String oppId;
    
    //価格表選択ウィザードのどの処理を行っているかの情報を保持
    //If it contains information which in the process of price list Selection Wizard
    Integer wzdStage = 1;

    //リスト値の保持に利用
    //Used to hold the list
    List<SelectOption> options = new List<SelectOption>();

    //価格表ページのメッセージの切り替え
    //Price List-page message switching
    Boolean show_jp_description = false;
    Boolean show_other_description = false;

    //各ボタンの活性、非活性、ボタン名の切り替えに利用
    //Activity of each button, deactivation switch on the button name
    Boolean nextBtn  = false;
    Boolean backBtn  = true;
    Boolean endPrbStartQuoBtn = true;
    Boolean nextBtnRender = true;
    Boolean backBtnRender = true;
    Boolean endPrbStartQuoBtnRender = true;
    String cancelName;
    String prbBtnName;

    //価格表リストの作成に使用する値
    //The value used to create the list price list
    string prbCode;
    Set<String> setAccId;
    Map<String, String> disPrbMap;
    List<Pricebook2> prbList;
    string prbNamePrefix = 'JP ';

    //見積作成に利用
    //Used an estimate
    DateTime qMakingDate;
    String quoteStatus ='連携前';
    String sessionId;
    
    // * コンストラクタ -    
    // * 商談情報取得 + ログインユーザのプロファイルから判定される価格表を取得する -
     //* @param [ApexPages.StandardController]標準コントローラ -      
     // @return なし
     // @throws なし
     //
     public ATFE_ChoosePricebookController(){}
    
    public ATFE_ChoosePricebookController(ApexPages.StandardController stdController) {
   

        // 起動箇所の判断 - 価格表選択ボタン or 見積作成ボタン
        //Determining starting points - the Create button or select button estimated price list
        String oppUrl = ApexPages.currentPage().getUrl();
        if(oppUrl.contains('spmsMode')){
            spmsMode  = Integer.valueof(ApexPages.currentPage().getParameters().get('spmsMode'));
        }
        if(oppUrl.contains('addTo')){
            addProducts  = 1;
        }
        oppId = ApexPages.currentPage().getParameters().get('id');
        String sRetUrl = ApexPages.currentPage().getParameters().get('retUrl');
        System.debug('●●●spmsMode：'+spmsMode + '/oppId：'+oppId +'/sRetUrl' + sRetUrl);

        // 商談の値を取得
        //Get the value of negotiation
        this.opp = [select id, ATFE_OppID__c, name, Accountid, JP_Enduser__c, JP_RelatedContact__c, JP_ContactEnduser__c, pricebook2id, JP_SendToAccount__c, JP_SendToContact__c, JP_NoSendToContactFlag__c, JP_PlVersion__c, JP_TargetDistributorCode__c, StageName, JP_DirectRank__c, JP_ReasonNoOppLineItem__c, JP_DirectTouchDegree__c, recordtype.name from Opportunity where id=:oppId];

        // ログインユーザプロファイル取得 -
        Profile  prf = [SELECT id, name  FROM Profile Where id=:UserInfo.getProfileId()];

     /*   if(prf.name == 'System Administrator'){
            prf.name = 'NA_SystemAdmin';
        }  */
        
        
        // プロファイル名より、該当エリア取得 -
        //From the profile name and get the appropriate area
        String[] slPrfName = prf.name.split(PROFILE_SPLITTER, 2);
        System.debug('●●●slPrfName.size:'+slPrfName.size());
        System.debug('●●●slPrfName.size:'+slPrfName);
        // エラーハンドリング -
        //Error Handling
        if(slPrfName.size() != 2){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, expWord.MSG_Error_Prb_ProfileName));
        }
        //Initial treatment for each individual Region
        else{
            sRegion = slPrfName[0];
            // EMEA, NAプロファイルユーザのアクション
            //EMEA, NA profile of user actions
            if(sRegion!='JP'){
                //ヘッダー情報セット
                //Set header information
                headerVal = 'Select Pricebook.';
                smallHeader = 'Pricebook';
                //メッセージの切り替え
                //Message Switching
                show_other_description = true;
                
                //ボタンの活性・非活性処理
                //Deactivation process of the activity buttons
                nextBtnRender = false;
                endPrbStartQuoBtnRender = true;
                backBtnRender = false;
                endPrbStartQuoBtn =false;
                
                // 価格表が選択中の場合は、デフォルトセット -
                //If the price list is selected, the default set
                if(opp.Pricebook2id != null){
                    this.selectValue = opp.pricebook2id;
                }
                ATFE_PricebookManagerFactory pbmf = new ATFE_PricebookManagerFactory();
                this.pbm = pbmf.getInstance(sRegion);
                this.pbm.setOppAccount(opp.Accountid);
                //価格表一覧取得
                //Get listed Price List
                this.options = this.pbm.getPriceBooks();
                if(this.options.size() < 1){
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, expWord.MSG_No_PricebookExistEn));
                    endPrbStartQuoBtn = true;
                }
            // JPプロファイルユーザのアクション
            //Profile of user actions JP
            }else if (sRegion=='JP'){
                // 説明文の追加
                show_jp_description = true;

                // 会社リストの作成クラス呼び出し
                JP_CLPricebookSendToAccount pr_sendAcc = new JP_CLPricebookSendToAccount();
                List<selectOption> accOptions = pr_sendAcc.createSendToAccount(opp);    
                System.debug('●●●初期表示前のopp.JP_SendToAccount__c'+opp.JP_SendToAccount__c);
                // デフォルト値の設定
                System.debug('●●●初期表示後のopp.JP_SendToAccount__c'+opp.JP_SendToAccount__c);
                selectValue = pr_sendAcc.getdefaultVal();

                //AccountIdを取得
                setAccId = pr_sendAcc.getSetAccId();

                // リターン値の設定
                this.options = accOptions;
            }
        }
    }
    //
    // * 「次へ」ボタン押下時イベント - JP
    // * @param なし -
    // * @return なし -
    // * @throws なし -
    // 
    public void OpenNext(){
        
        //会社選択後、顧客のリストを表示する
        if(wzdStage == 1 && sRegion == 'JP'){
            System.debug('●●●選択前の会社ID：'+opp.JP_SendToAccount__c);

            //ウィザードを次へ進める
            this.wzdStage = 2;

            //商談に宛名会社をセット -
            this.opp.JP_SendToAccount__c = this.selectValue;
            System.debug('●●●選択後の会社ID：'+opp.JP_SendToAccount__c);

            //顧客リスト作成クラス呼び出し
            JP_CLPricebookSendToContact prSendCon = new JP_CLPricebookSendToContact();
            List<selectOption> tmpConOptions = prSendCon.createSendToContact(opp,opp.JP_SendToAccount__c );

            //デフォルト値の設定
            selectValue = null;
            selectValue = prSendCon.getDefaultVal();
            System.debug('●●●デフォルトの顧客ID：'+selectValue);

            //リストに値を設定
            this.options = tmpConOptions;

            //ヘッダーの切り替え
            smallHeader = '宛名顧客';
            headerVal ='価格表選択画面        宛名会社 > 宛名顧客  を選択';

            //ボタンの活性・非活性の切り替え
            backBtn = false;

        //顧客選択後、代理店のリストを表示する
        }else if(wzdStage == 2){
            System.debug('●●●選択前の顧客ID：'+opp.JP_SendToContact__c+'/顧客名'+opp.JP_SendToContact__r.name);

            //ウィザードを次へ進める
            wzdStage = 3;

            //商談に宛名顧客をセット -
            if(selectValue != 'special_value'){
                this.opp.JP_SendToContact__c = this.selectValue;
            }else{
                this.opp.JP_SendToContact__c = null;
                this.opp.JP_NoSendToContactFlag__c = true;
            }
            System.debug('●●●選択後の顧客ID'+opp.JP_SendToContact__c+'/顧客名'+opp.JP_SendToContact__r.name);

            //代理店リスト作成クラス呼び出し
            JP_CLPricebookSelectDistributor selDis = new JP_CLPricebookSelectDistributor();
            List<selectOption>tmpNexDisOptions = selDis.disValOption(opp, opp.JP_SendToAccount__c, setAccId);

            //代理店と価格表のマップの取得
            disPrbMap = selDis.getDisPrbMap();
            //デフォルト値の設定
            selectValue = null;
            selectValue = selDis.getDefaultVal();
            System.debug('●●●デフォルトの代理店コード：'+selectValue);
            
            //リストに値を設定
            this.options = tmpNexDisOptions;

            //ヘッダーの切り替え
            smallHeader = '代理店';
            headerVal ='価格表選択画面        宛名会社 > 宛名顧客 > 代理店 を選択';

        //代理店選択後、価格表のリストを表示する
        }else if(wzdStage == 3){
            System.debug('●●●選択前の代理店コード'+opp.JP_TargetDistributorCode__c);

            //ウィザードを次へ進める
            wzdStage = 4;

            //商談にSPMS用検索代理店をセット -
            this.opp.JP_TargetDistributorCode__c = this.selectValue;
            System.debug('●●●選択後の代理店コード'+opp.JP_TargetDistributorCode__c);

            //価格表リスト作成クラス呼び出し
            JP_CLPricebookSelectPricebook selPrb = new JP_CLPricebookSelectPricebook();
            List<selectOption> tmpPrbOptions = selPrb.prbValOption(opp, disPrbMap, opp.JP_TargetDistributorCode__c);

            //価格表リストの取得
            prbList = selPrb.getPrbList();

            //デフォルト値の設定
            selectValue = null;
            selectValue = selPrb.getDefaultVal();
            System.debug('●●●デフォルトの価格表コード：'+selectValue);

            //リストに値を設定
            this.options = tmpPrbOptions;

            //ヘッダーの切り替え
            smallHeader = '価格表';
            headerVal ='価格表選択画面        宛名会社 > 宛名顧客 > 代理店 > 価格表 を選択';

            //ボタンの活性・非活性の切り替え
            if( tmpPrbOptions.size() != 0 ){
                nextBtn = true;
                endPrbStartQuoBtn = false;
            }else{
                nextBtn = true;
                endPrbStartQuoBtn = true;
            }
        }
    }
    /**
     * 「戻る」ボタン押下時イベント -
     * @param  なし -
     * @return なし -
     * @throws なし -
     */
    public void backBfr() {
        if(wzdStage ==2){
            // 会社リスト作成クラスの呼び出し
            JP_CLPricebookSendToAccount pr_sendAcc = new JP_CLPricebookSendToAccount();
            List<selectOption> accTmpOption = pr_sendAcc.createSendToAccount(opp);

            //ウィザードを次へ進める
            wzdStage = 1;

            //デフォルト値の設定
            selectValue = null;
            this.selectValue = pr_sendAcc.getDefaultVal();
            System.debug('●●●会社デフォルト値'+selectValue);
    
            // リストに値を設定
            this.options = accTmpOption;

            //ヘッダーの切り替え
            smallHeader = '宛名会社';
            headerVal ='価格表選択画面        宛名会社  を選択';

            //ボタンの活性・非活性の切り替え
            backBtn = true; 

        }else if(wzdStage == 3){
            // 顧客リスト作成クラスの呼び出し
            JP_CLPricebookSendToContact prSendCon = new JP_CLPricebookSendToContact();
            List<selectOption> tmpConOptions = prSendCon.createSendToContact(opp,opp.JP_SendToAccount__c );

            //ウィザードを次へ進める
            wzdStage = 2;

            // デフォルト値の設定
            selectValue = null;
            this.selectValue = prSendCon.getDefaultVal();

            System.debug('●●●顧客デフォルト値：'+selectValue);

            // リストに値を設定
            this.options = tmpConOptions;

            //ヘッダーの切り替え
            smallHeader = '宛名顧客';
            headerVal ='価格表選択画面        宛名会社 > 宛名顧客 を選択';

        }else if(wzdStage == 4){

            // 代理店リスト作成クラスの呼び出し
            JP_CLPricebookSelectDistributor selDis = new JP_CLPricebookSelectDistributor();
            List<selectOption> tmpDisOptions = selDis.disValOption(opp, opp.JP_SendToAccount__c, setAccId);
            
            
            //ウィザードを次へ進める
            wzdStage = 3;

            // デフォルト値の設定
            selectValue = selDis.getDefaultVal();
            System.debug('●●●代理店コードデフォルト値：'+selectValue);

            // リストに値を設定
            this.options = tmpDisOptions;

            //ヘッダーの切り替え
            smallHeader = '代理店';
            headerVal ='価格表選択画面        宛名会社 > 宛名顧客 > 代理店 を選択';

            //ボタンの活性・非活性の切り替え
            nextBtn = false;
            endPrbStartQuoBtn = true;
        }
    }
    /**
     * 「見積作成」ボタン押下時イベント
     * @param なし -
     * @return PageReference pageRef - 遷移先のページ - 商談詳細画面(価格表ボタンから起動時) or 見積作成画面(見積作成ボタンから起動時)
     * @throws なし -
     */
    public pageReference endPrbStartQuo(){

        //セーブポイントの定義
        Savepoint sp;
        System.debug('●●●セーブポイント通過');
        try{
            //セーブポイント設定 -
            sp = Database.setSavepoint();
            System.debug('●●●セーブポイント設定');
            
            // JP
            if(opp.recordtype.name == 'JP_Opportunity'){

                if(String.isBlank(opp.JP_ReasonNoOppLineItem__c)){
                    Boolean upOpp = false;
                    List<String>ranks = System.Label.JP_HighDirectRank.split(',');
                    List<String>stages = System.Label.JP_HighStageName.split(',');

                    if(ranks.contains(opp.JP_DirectRank__c)){
                        opp.JP_DirectRank__c = 'D';
                        upOpp = true;
                    }
                    if(stages.contains(opp.StageName)){
                        opp.StageName = 'Prospect/Qualification - APAC';
                        opp.JP_DirectTouchDegree__c = '';
                        upOpp = true;
                    }
                    if(upOpp == true){
                        update opp;
                        System.debug('●●●商談の更新完了(低確度へ変更)');
                    }
                }
            }

            if(opp.Pricebook2Id != selectValue){

                //商談商品の削除処理、取得したoppItemから200件ずつ取得し削除する(try-catch終了までは未削除)
                for(List<OpportunityLineItem> oppItemList : [select id from OpportunityLineItem where OPPORTUNITYID =: opp.id for update]){
                    delete oppItemList;
                }
                System.debug('●●●商談商品の削除完了');

                //商談に価格表コードをセット -
                if(sRegion == 'JP'){
                    for(Integer i =0; i<prbList.size();i++){
                        if(prbList[i].id == selectValue){
                            opp.pricebook2Id = prbList[i].Id;
                            System.debug('■■■：'+opp.JP_TargetDistributorCode__c);
                            if(opp.JP_TargetDistributorCode__c == 'SS'){
                                opp.JP_TargetDistributorCode__c = null;
                            }
                            System.debug('■■■：'+opp.JP_TargetDistributorCode__c);
                            //opp.JP_TargetDistributorCode__c = prbList[i].description;
                            opp.JP_SapPricebookCode__c = prbList[i].description;
                            Integer l = prbNamePrefix.length();
                            Integer m = prbList[i].name.length();
                            String n = prbList[i].name.substring(l,m);
                            opp.JP_PlVersion__c = n.replace('/','')+'01';
                        }
                    }
                }else{
                    opp.pricebook2Id = selectValue;
                }
            }
            update opp;
            System.debug('●●●商談のアップデート完了');

        }catch(DmlException ex){
            //エラーを表示 -
            System.debug('●●●エラー発生');
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, expWord.MSG_SelectTooMuchItems));

            //ROLLBACK -
            Database.rollback(sp);

            return null;
        }
        // 遷移先のページの型定義
        PageReference pageRef;

        if(sRegion != 'JP'){

            // EMEA、NAで価格表選択時に遷移する商品追加画面のURL作成(相対パスが用意できないため、絶対パス利用)
            String Domain = ApexPages.currentPage().getHeaders().get('Host');
            String shtOppId = String.valueof(opp.Id).substring(0,15);
            String sUrl      = 'https://' + Domain +'/ui/opportunity/SelectSearch?addTo=' + shtOppId + '&retURL=%2F' + shtOppId;
            pageRef = new PageReference(sUrl);

        }else if(sRegion == 'JP'){

            // 価格表選択ボタンから起動時の動作 
            if(wzdStage == 4 && spmsMode == 0 && addProducts == 0){

                // 遷移先の商談詳細ページのURL取得
                ApexPages.StandardController sc = new ApexPages.StandardController(opp);
                pageReference pgDetailUrl = sc.view();
                pageRef = pgDetailUrl;
                
            //価格表選択前に、商品追加ボタン押下により遷移してきた場合の動作 -
            }else if(wzdStage == 4 && spmsMode == 0 && addProducts == 1){
                //商品追加画面のURL作成(相対パスが用意できないため、絶対パス利用)
                String Domain = ApexPages.currentPage().getHeaders().get('Host');
                String shtOppId = String.valueof(opp.Id).substring(0,15);
                String sUrl      = 'https://' + Domain +'/ui/opportunity/SelectSearch?addTo=' + shtOppId + '&retURL=%2F' + shtOppId;
                pageRef = new PageReference(sUrl);
                
            // 見積作成ボタンから起動時の動作
            }else if(wzdStage == 4 && spmsMode == 1 && sRegion == 'JP'){

                //連携レコード作成の生成
                sessionId = Userinfo.getSessionId();
                qMakingDate= system.now();  //The format is: 'MM/DD/YYYY HH:MM PERIOD'
                List<OpportunityTeamMember> OISales = new List<OpportunityTeamMember>();
                OISales = [select UserId,TeamMemberRole from OpportunityTeamMember where opportunityid =: opp.Id and ( TeamMemberRole = 'Inside Sales' or TeamMemberRole = 'Outside Sales' ) and User.isActive = True order by LastModifiedDate];
                JP_OrderQuoteMaking__c quoMake = new JP_OrderQuoteMaking__c();
                    quoMake.JP_SessionId__c = sessionId;
                    quoMake.JP_OppIdQuoteMakingDate__c = String.valueof(qMakingDate);
                    quoMake.JP_RenkeiStatus__c = quoteStatus;
                    quoMake.JP_OppId__c = opp.ATFE_OppID__c;
                    quoMake.JP_OpportunityId__c = opp.Id;
                    quoMake.CurrencyIsoCode = 'JPY';
                    quoMake.JP_ErrorMessage__c = '';
                    for(Integer i =0; i<OISales.size();i++){
                        if(OISales[i].TeamMemberRole == 'Inside Sales'){
                            quoMake.JP_InsideSales__c = OISales[i].UserId;
                        }else if(OISales[i].TeamMemberRole == 'Outside Sales'){
                            quoMake.JP_OutsideSales__c = OISales[i].UserId;
                        }
                    }

                //セーブポイントの定義
                Savepoint sp2;

                try{
                    //セーブポイント設定 -
                    sp2 = Database.setSavepoint();

                    insert quoMake;
                    System.debug('●●●見積作成依頼オブジェクトへのレコード作成完了');

                }catch(DmlException ex){
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, expWord.MSG_FailtoCreateQuoteIFRecord));

                    //ROLLBACK -
                    Database.rollback(sp2);

                    return null;
                }

                //見積ポーリング画面のURL作成
              pageRef = Page.JP_PGCallSPMSPolling;
              pageRef.getParameters().put('id',opp.Id);
              pageRef.getParameters().put('quoid',quoMake.Id);
          }
        }
        pageRef.setRedirect(true);
        return PageRef;
    }

    /**
     * 価格表画面に表示するメッセージ
     * @param なし -
     * @return options - JPのメッセージ
     * @throws なし -
     */
    public Boolean getShow_jp_description(){
        return show_jp_description;
    }
    /**
     * 価格表画面に表示するメッセージ
     * @param なし -
     * @return options - EMEA, NAのメッセージ
     * @throws なし -
     */
    public Boolean getShow_other_description(){
        return show_other_description;
    }
    //
    //  リスト値をリターン
    //  @param なし -
     // @return options - 各リスト作成メソッドから返されたリスト値
     // @throws なし -
     
    public List<SelectOption> getCreateListVal(){
        return this.options;
    }
    //
    // * デフォルト値の取得
    // * @param なし -
    // * @return selectValue - 各リスト作成メソッドで選択されたリスト値のIDやコード
    // * @throws なし -
    // 
    public String getSelectValue(){
        return selectValue;
    }
    
    public void setSelectValue(String argPbn){
        selectValue = argPbn;
    }
    
    public String getHeaderVal() {
        return headerVal;
    }
    public String getSmallHeader() {
        return smallHeader;
    }
    
    public Boolean getNextBtn(){
        return nextBtn;
    }
    public Boolean getBackBfrBtn(){
        return backBtn;
    }
    public Boolean getEndPrbStartQuo(){
        return endPrbStartQuoBtn;
    }
    public Boolean getNextBtnRender(){
        return nextBtnRender;
    }
    public Boolean getbackBtnRender(){
        return backBtnRender;
    }
    public Boolean getEndPrbStartQuoBtnRender(){
        return endPrbStartQuoBtnRender;
    }
    
    public string getCancelName(){
        if(sRegion != 'JP'){
            cancelName = 'cancel';
        }else if(sRegion == 'JP'){
            cancelName = 'キャンセル';
        }
        return cancelName;
    }
    public string getPrbBtnName(){
        if(spmsMode==0 && sRegion =='JP'){
            prbBtnName = '完了';
        }else if(spmsMode==1 && sRegion =='JP'){
            prbBtnName = '見積作成';
        }else if(sRegion != 'JP'){
            prbBtnName = 'Next';
        }
        return prbBtnName;
    }
    

}