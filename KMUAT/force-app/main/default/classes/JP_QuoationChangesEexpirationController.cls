public with sharing class JP_QuoationChangesEexpirationController {
    
    //見積No
    @TestVisible private String qNo;
    //見積Id
    @TestVisible private String qId;
    //price list type
    @TestVisible private String plt;
    //retURL
    @TestVisible private String retURL;
    //保存可能フラグ
    public Boolean saveOKFlg {get; set;}
    //見積有効期限変更履歴
    public JP_QuoationChangesEexpirationDate__c record {get; set;}
    private JP_QuotationHeader__c qheader {get; private set;}
    //SalesUser Profile
    private String SALESUSER = JP_Const.JP_SALES_USER;
    //SalesUserフラグ
    public Boolean isSalesUser {get; set;}
    
    /**
     * コンストラクタ
     */
    public JP_QuoationChangesEexpirationController(ApexPages.StandardController stdController) {
        this.record = (JP_QuoationChangesEexpirationDate__c)stdController.getRecord();
        qId = ApexPages.currentPage().getParameters().get('qId');
        retURL = ApexPages.currentPage().getParameters().get('retURL');
        record = new JP_QuoationChangesEexpirationDate__c();
        record.JP_QuotationExpireDate__c = system.today().addDays(30);
        
        qheader = JP_QuotationHeaderDAO.getRecById(qId);
        qNo = qheader.JP_QuotationNo__c;
        plt = qheader.JP_Price_List_Type__c;
        
        saveOKFlg = false;
        // ログインユーザのプロファイルIDを取得
        String profileId = UserInfo.getProfileId();
        // プロファイルIDからプロファイルの名称を取得
        String profileName = ProfileDAO.getRecById(profileId).Name;
        
        if(profileName == SALESUSER){
            IsSalesUser = true;
        }
    }
    
    public PageReference CheckSave(){
        String errMsg = '';
        Integer g2g3 = 0;
        String priceYM = 'JP ' + String.valueOf(system.today().year()) + '/' + String.valueOf(system.today().month());
        Set<String> productSet = new Set<String>();
        List<JP_QuotationDetail__c> qdList = JP_QuotationDetailDAO.getRecByParentId(qId);
        
        //見積有効期限が未入力
        if(record.JP_QuotationExpireDate__c == null){
            errMsg = System.Label.JP_NotInput_JP_QuotationExpireDate;
            saveOKFlg = false;
            ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, errMsg));
            return null;
        }
        
        //元の見積で見積有効期限が未入力
        if(qheader.JP_QuotationExpireDate__c == null){
            errMsg = System.Label.NotInputJP_QuotationExpireDate;
            saveOKFlg = false;
            ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, errMsg));
            return null;
        }
        
        //見積明細取得
        List<AggregateResult> aggregateList = JP_QuotationDetailDAO.getRecForGId(qId);
        
        //見積明細の承認グループID件数をカウント
        for(AggregateResult ar : aggregateList) {
            system.debug('**** GroupID = ' + ar.get('JP_AppGroupID__c'));
            system.debug('**** count = ' + Integer.valueOf(ar.get('gId')));
            if(ar.get('JP_AppGroupID__c') == 'G2' || ar.get('JP_AppGroupID__c') == 'G3'){
                g2g3 += Integer.valueOf(ar.get('gId'));
            }
        }
        
        //見積明細.承認GIDチェック
        //G2、G3を含む場合
        if(g2g3 > 0){
            errMsg = System.Label.JP_MSG_G2G3InQuotationDetail;
            saveOKFlg = false;
            ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.WARNING, errMsg));
            return null;
        }

        //特化承認情報取得
        List<JP_SpecailPriceApprove__c> spa = JP_SpecailPriceApproveDAO.getRecByQHeaderId(qId);
        
        //特価承認のATKK製品が存在しない場合
        if(spa.size() == 0){
            errMsg = System.Label.JP_QuotationDetailNotG1;
            saveOKFlg = false;
            ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.WARNING, errMsg));
            return null;
        }
        
        //特化承認情報.特化適用終了日チェック
        //特価承認の特価適用終了日が30日未満の場合
        Date errDate = Date.newInstance(2999,12,31);
        if(system.today().daysBetween(spa[0].JP_SpecailPriceEndDate__c) < 30 || spa[0].JP_SpecailPriceEndDate__c == errDate){
            errMsg = System.Label.JP_SpecailPriceEndDate_Under_30date;
            saveOKFlg = false;
            ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.WARNING, errMsg));
            return null;
        }
        
        //単価と仕切価格が違う場合
        //製品コードのセット作成
        for(JP_QuotationDetail__c qd : qdList){
            String code = plt + '_' + qd.JP_ProductCatalogCode__c + '_' + priceYM;
            if(!productSet.contains(code)){
                productSet.add(code);
            }
        }
        
        //代理店価格仕切表取得
        Map<String,JP_DistributorPrice__c> dpMap = JP_DistributorPriceDAO.getDistributorPriceByKeyset(productSet);
        
        //単価と仕切価格が違う場合
        for(JP_QuotationDetail__c qd : qdList){
            String key = plt + '_' + qd.JP_ProductCatalogCode__c + '_' + priceYM;
            system.debug('*** key : ' + key);
            if(dpMap.containsKey(key)){
                if(qd.JP_UnitPrice__c != dpMap.get(key).JP_WholeSalePrice__c){
                    errMsg = System.Label.JP_NotEqualUnitPrice;
                    saveOKFlg = false;
                    ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.WARNING, errMsg));
                    return null;
                }
            }
        }
        
        
        SaveOKFlg = true;
        ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.CONFIRM, '保存可能です'));
        return null;
    }
    
    public Pagereference doSave(){
        Integer revision;
        
        record.JP_QuotationHeader__c = qId;
        record.JP_QuoteOutputDate__c = system.today();
        
        // YYYYMMDD + 連番  を取得
        String strPrefix = this.qNo;
        // YYYYMMDD + 連番 の revision が最大であるレコードを取得
        JP_QuoationChangesEexpirationDate__c rec = JP_QuoationChangesEexpirationDateDAO.getRecByQuotationNoMax(strPrefix);
            
        // revision の文字コードを取得
        if(rec != null){
            system.debug('*** 既存 ***');
            if(strPrefix.length() == 11){
                revision = rec.Name.charAt(11);
            }else{
                revision = rec.Name.charAt(9);
            }
            revision++;
            system.debug('*** revision : ' + revision);
            
            if(revision > 90){
                // リビジョンが Z を超える場合
                //エラーメッセージ JP_QuotationNo over Z
                record.addError(System.Label.JP_ErrorMessageQuotationHeaderOverZ);     
                       
            } else {
                String strRevision = String.fromCharArray( new List<integer> { revision } );
                record.Name = strPrefix + strRevision;
            }
        }else{
            system.debug('*** 新規 ***');
            record.Name = strPrefix + 'A';
        }

        try{
            system.debug('***** Save *****');
            insert record;
        }catch(Exception ex){
            system.debug('*** Exception +++');
            ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()+'\n'+ex.getStackTraceString()+this.qNo));
            return null;
        }
        
        system.debug('*** retURL : ' + retURL);
        return new PageReference(retURL);
    }
}