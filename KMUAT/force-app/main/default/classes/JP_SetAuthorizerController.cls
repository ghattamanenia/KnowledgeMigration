public with sharing class JP_SetAuthorizerController {

    //遷移元URL
    @TestVisible private String retURL;
    // 見積情報
    public JP_QuotationHeader__c QHeader {get; set;}
    // 承認プロセス管理
    public JP_ApprovalProcessMaster__c apm {get; private set;}
    // STEP1表示フラグ
    public Boolean renderedSTEP1 {get; private set;}
    // STEP2表示フラグ
    public Boolean renderedSTEP2 {get; private set;}
    // STEP3表示フラグ
    public Boolean renderedSTEP3 {get; private set;}
    // STEP4表示フラグ
    public Boolean renderedSTEP4 {get; private set;}
    // STEP5表示フラグ
    public Boolean renderedSTEP5 {get; private set;}
    // STEP6表示フラグ
    public Boolean renderedSTEP6 {get; private set;}
    // STEP1キューフラグ
    public Boolean STEP1Queue {get; private set;}
    // STEP2キューフラグ
    public Boolean STEP2Queue {get; private set;}
    // STEP3キューフラグ
    public Boolean STEP3Queue {get; private set;}
    // STEP4キューフラグ
    public Boolean STEP4Queue {get; private set;}
    // STEP5キューフラグ
    public Boolean STEP5Queue {get; private set;}
    // STEP6キューフラグ
    public Boolean STEP6Queue {get; private set;}
    // ステップ1キュー表示名称
    public String Queue1Name {get; private set;}
    // ステップ2キュー表示名称
    public String Queue2Name {get; private set;}
    // ステップ3キュー表示名称
    public String Queue3Name {get; private set;}
    // ステップ4キュー表示名称
    public String Queue4Name {get; private set;}
    // ステップ5キュー表示名称
    public String Queue5Name {get; private set;}
    // ステップ6キュー表示名称
    public String Queue6Name {get; private set;}
    // デフォルトの取締役ユーザ
    private final String DEFAULT_DIRECTOR = system.Label.JP_DefaultDirector;
    // 課長
    private final String CHIEF_MANAGER = JP_Const.SECTION_CHIEF;
    // 部長
    private final String MANAGER = JP_Const.MANAGER;
    // 本部長
    private final String GENERAL_MANAGER = JP_Const.GENERAL_MANAGER;
    // 取締役
    private final String DIRECTOR = JP_Const.DIRECTOR;

    // ステップ1表示項目
    public List<String> step1 {
        get {
            if (step1 == null) {
                step1 = new List<String>();
                step1.add(CHIEF_MANAGER + '__c');
                step1.add(MANAGER + '__c');
                step1.add(GENERAL_MANAGER + '__c');
                step1.add(DIRECTOR + '__c');
            }
            return step1;
        }
        private set;
    }
    
    // ステップ2表示項目
    public List<String> step2 {
        get {
            if (step2 == null) {
                step2 = new List<String>();
                step2.add(CHIEF_MANAGER + '__c');
                step2.add(MANAGER + '__c');
                step2.add(GENERAL_MANAGER + '__c');
                step2.add(DIRECTOR + '__c');
            }
            return step2;
        }
        private set;
    }
    
    // ステップ3表示項目
    public List<String> step3 {
        get {
            if (step3 == null) {
                step3 = new List<String>();
                step3.add(CHIEF_MANAGER + '__c');
                step3.add(MANAGER + '__c');
                step3.add(GENERAL_MANAGER + '__c');
                step3.add(DIRECTOR + '__c');
            }
            return step3;
        }
        private set;
    }
    
    // ステップ4表示項目
    public List<String> step4 {
        get {
            if (step4 == null) {
                step4 = new List<String>();
                step4.add(CHIEF_MANAGER + '__c');
                step4.add(MANAGER + '__c');
                step4.add(GENERAL_MANAGER + '__c');
                step4.add(DIRECTOR + '__c');
            }
            return step4;
        }
        private set;
    }
    
    // ステップ5表示項目
    public List<String> step5 {
        get {
            if (step5 == null) {
                step5 = new List<String>();
                step5.add(CHIEF_MANAGER + '__c');
                step5.add(MANAGER + '__c');
                step5.add(GENERAL_MANAGER + '__c');
                step5.add(DIRECTOR + '__c');
            }
            return step5;
        }
        private set;
    }
    
    // ステップ6表示項目
    public List<String> step6 {
        get {
            if (step6 == null) {
                step6 = new List<String>();
                step6.add(CHIEF_MANAGER + '__c');
                step6.add(MANAGER + '__c');
                step6.add(GENERAL_MANAGER + '__c');
                step6.add(DIRECTOR + '__c');
            }
            return step6;
        }
        private set;
    }
    
    // フラグ初期化
    public void init(){
        this.renderedSTEP1 = false;
        this.renderedSTEP2 = false;
        this.renderedSTEP3 = false;
        this.renderedSTEP4 = false;
        this.renderedSTEP5 = false;
        this.renderedSTEP6 = false;
        this.STEP1Queue = false;
        this.STEP2Queue = false;
        this.STEP3Queue = false;
        this.STEP4Queue = false;
        this.STEP5Queue = false;
        this.STEP6Queue = false;
    }
    
    /**
     * コントローラ
     */
    public JP_SetAuthorizerController(ApexPages.StandardController stdController) {
        init();
        
        // 画面表示承認者項目追加
        if(!Test.isRunningTest()) {
            stdController.addFields(step1);
            stdController.addFields(step2);
            stdController.addFields(step3);
            stdController.addFields(step4);
            stdController.addFields(step5);
            stdController.addFields(step6);
        }
        
        this.QHeader = (JP_QuotationHeader__c)stdController.getRecord();
        // レコード取得
        Id recId = stdController.getRecord().Id;
        if(recId != null){
            this.QHeader = JP_QuotationHeaderDAO.getRecById(recId);
        }
        
        //Skipフラグ初期化
        QHeader.JP_Step1Skip__c = false;
        QHeader.JP_Step2Skip__c = false;
        QHeader.JP_Step3Skip__c = false;
        QHeader.JP_Step4Skip__c = false;
        QHeader.JP_Step5Skip__c = false;
        QHeader.JP_Step6Skip__c = false;
        
        //遷移元URLパラメータ取得
        retURL = ApexPages.currentPage().getParameters().get('retURL');
        
        if(QHeader.JP_QuotationApprovalProcessNo__c != null){
            // 承認プロセス管理マスタ情報取得
            Integer processno = Integer.valueOF(QHeader.JP_QuotationApprovalProcessNo__c);
            this.apm = JP_ApprovalProcess_DAO.getApprovalProcessInfoByNo(processno);
            if(QHeader.JP_Applicant__c == null){
                QHeader.JP_Applicant__c = UserInfo.getUserId();
            }
    
            // STEP1
            if(this.apm.JP_Step1exec__c == true){
                renderedSTEP1 = true;
                QHeader.JP_Step1exec__c = this.apm.JP_Step1exec__c;
                QHeader.JP_Step1Status__c = this.apm.JP_Step1Status__c;
                
                if(apm.JP_Step1type__c == 'User'){
                    QHeader.JP_Step1type__c = this.apm.JP_Step1type__c;
                    // JP_Step1Approverで設定されている承認者以外の項目を削除
                    for(Integer i = 0; i < step1.size(); i++){
                        if(step1[i].replace('__c','') != apm.JP_Step1Approver__c){
                            step1.remove(i);
                            i--;
                        }
                    }
                    
                    // 承認者が取締役だったらデフォルトの取締役ユーザをセット
                    if(apm.JP_Step1Approver__c == DIRECTOR){
                        if(QHeader.JP_Director__c == null){
                            QHeader.JP_Director__c = DEFAULT_DIRECTOR;
                        }
                    }
                }else if(apm.JP_Step1type__c == 'Queue'){
                    STEP1Queue = true;
                    QUEUE1NAME = 'JP_' + this.apm.JP_Step1Approver__c;
                    QHeader.JP_Step1type__c = this.apm.JP_Step1type__c + ':' + this.apm.JP_Step1Approver__c;
                    //キューの場合承認者項目が不要なので全削除
                    step1.clear();
                }else{
                    step1.clear();
                }
            }
            
            // STEP2
            if(this.apm.JP_Step2exec__c == true){
                renderedSTEP2 = true;
                QHeader.JP_Step2exec__c = this.apm.JP_Step2exec__c;
                QHeader.JP_Step2Status__c = this.apm.JP_Step2Status__c;
                
                if(apm.JP_Step2type__c == 'User'){
                    QHeader.JP_Step2type__c = this.apm.JP_Step2type__c;
                    // JP_Step2Approverで設定されている承認者以外の項目を削除
    
                    for(Integer i = 0; i < step2.size(); i++){
                        if(step2[i].replace('__c','') != apm.JP_Step2Approver__c){
                            step2.remove(i);
                            i--;
                        }
                    }
    
                    // 承認者が取締役だったらデフォルトの取締役ユーザをセット
                    if(apm.JP_Step2Approver__c == DIRECTOR){
                        if(QHeader.JP_Director__c == null){
                            QHeader.JP_Director__c = DEFAULT_DIRECTOR;
                        }
                    }
                }else if(apm.JP_Step2type__c == 'Queue'){
                    STEP2Queue = true;
                    QUEUE2NAME = 'JP_' + this.apm.JP_Step2Approver__c;
                    QHeader.JP_Step2type__c = this.apm.JP_Step2type__c + ':' + this.apm.JP_Step2Approver__c;
                    //キューの場合承認者項目が不要なので全削除
                    step2.clear();
                }else{
                    step2.clear();
                }
            }
            
            // STEP3
            if(this.apm.JP_Step3exec__c == true){
                renderedSTEP3 = true;
                QHeader.JP_Step3exec__c = this.apm.JP_Step3exec__c;
                QHeader.JP_Step3Status__c = this.apm.JP_Step3Status__c;
                
                if(this.apm.JP_Step3type__c == 'User'){
                    QHeader.JP_Step3type__c = this.apm.JP_Step3type__c;
                    // JP_Step3Approverで設定されている承認者以外の項目を削除
                    for(Integer i = 0; i < step3.size(); i++){
                        if(step3[i].replace('__c','') != apm.JP_Step3Approver__c){
                            step3.remove(i);
                            i--;
                        }
                    }
                    
                    // 承認者が取締役だったらデフォルトの取締役ユーザをセット
                    if(apm.JP_Step3Approver__c == DIRECTOR){
                        if(QHeader.JP_Director__c == null){
                            QHeader.JP_Director__c = DEFAULT_DIRECTOR;
                        }
                    }
                }else if(apm.JP_Step3type__c == 'Queue'){
                    STEP3Queue = true;
                    QUEUE3NAME = 'JP_' + this.apm.JP_Step3Approver__c;
                    QHeader.JP_Step3type__c = this.apm.JP_Step3type__c + ':' + this.apm.JP_Step3Approver__c;
                    //キューの場合承認者項目が不要なので全削除
                    step3.clear();
                }else{
                    step3.clear();
                }
            }
            
            // STEP4
            if(this.apm.JP_Step4exec__c == true){
                renderedSTEP4 = true;
                QHeader.JP_Step4exec__c = this.apm.JP_Step4exec__c;
                QHeader.JP_Step4Status__c = this.apm.JP_Step4Status__c;
                if(this.apm.JP_Step4type__c == 'User'){
                    QHeader.JP_Step4type__c = this.apm.JP_Step4type__c;
                    // JP_Step4Approverで設定されている承認者以外の項目を削除
                    for(Integer i = 0; i < step4.size(); i++){
                        if(step4[i].replace('__c','') != apm.JP_Step4Approver__c){
                            step4.remove(i);
                            i--;
                        }
                    }
                    
                    // 承認者が取締役だったらデフォルトの取締役ユーザをセット
                    if(apm.JP_Step4Approver__c == DIRECTOR){
                        if(QHeader.JP_Director__c == null){
                            QHeader.JP_Director__c = DEFAULT_DIRECTOR;
                        }
                    }
                    
                }else if(apm.JP_Step4type__c == 'Queue'){
                    STEP4Queue = true;
                    QUEUE4NAME = 'JP_' + this.apm.JP_Step4Approver__c;
                    QHeader.JP_Step4type__c = this.apm.JP_Step4type__c + ':' + this.apm.JP_Step4Approver__c;
                    //キューの場合承認者項目が不要なので全削除
                    step4.clear();
                }else{
                    step4.clear();
                }
            }
            
            // STEP5
            if(this.apm.JP_Step5exec__c == true){
                renderedSTEP5 = true;
                QHeader.JP_Step5exec__c = this.apm.JP_Step5exec__c;
                QHeader.JP_Step5Status__c = this.apm.JP_Step5Status__c;
                
                if(this.apm.JP_Step5type__c == 'User'){
                    QHeader.JP_Step5type__c = this.apm.JP_Step5type__c;
                    // JP_Step5Approverで設定されている承認者以外の項目を削除
                    for(Integer i = 0; i < step5.size(); i++){
                        if(step5[i].replace('__c','') != apm.JP_Step5Approver__c){
                            step5.remove(i);
                            i--;
                        }
                    }
                    
                    // 承認者が取締役だったらデフォルトの取締役ユーザをセット
                    if(apm.JP_Step5Approver__c == DIRECTOR){
                        if(QHeader.JP_Director__c == null){
                            QHeader.JP_Director__c = DEFAULT_DIRECTOR;
                        }
                    }
                    
                }else if(apm.JP_Step5type__c == 'Queue'){
                    STEP5Queue = true;
                    QUEUE5NAME = 'JP_' + this.apm.JP_Step5Approver__c;
                    QHeader.JP_Step5type__c = this.apm.JP_Step5type__c + ':' + this.apm.JP_Step5Approver__c;
                    //キューの場合承認者項目が不要なので全削除
                    step5.clear();
                }else{
                    step5.clear();
                }
            }
            
            // STEP6
            if(this.apm.JP_Step6exec__c == true){
                renderedSTEP6 = true;
                QHeader.JP_Step6exec__c = this.apm.JP_Step6exec__c;
                QHeader.JP_Step6Status__c = this.apm.JP_Step6Status__c;
                if(this.apm.JP_Step6type__c == 'User'){
                    QHeader.JP_Step6type__c = this.apm.JP_Step6type__c;
                    // JP_Step6Approverで設定されている承認者以外の項目を削除
                    for(Integer i = 0; i < step6.size(); i++){
                        if(step6[i].replace('__c','') != apm.JP_Step6Approver__c){
                            step6.remove(i);
                            i--;
                        }
                    }
                    
                    // 承認者が取締役だったらデフォルトの取締役ユーザをセット
                    if(apm.JP_Step6Approver__c == DIRECTOR){
                        if(QHeader.JP_Director__c == null){
                            QHeader.JP_Director__c = DEFAULT_DIRECTOR;
                        }
                    }
                }else if(apm.JP_Step6type__c == 'Queue'){
                    STEP6Queue = true;
                    QUEUE6NAME = 'JP_' + this.apm.JP_Step6Approver__c;
                    QHeader.JP_Step6type__c = this.apm.JP_Step6type__c + ':' + this.apm.JP_Step6Approver__c;
                    //キューの場合承認者項目が不要なので全削除
                    step6.clear();
                }else{
                    step6.clear();
                }
            }
        }
    }
    
    /**
     * 保存ボタン：見積情報を保存します
     * @return retPage
     */
    public Pagereference doSave(){
        PageReference retPage;
        Boolean isError = false;
        Savepoint sp = Database.setSavepoint();
        
        QHeader.JP_Step0Status__c = apm.JP_Step0Status__c;

        // ステップ1ユーザセット
        if(apm.JP_Step1Approver__c == CHIEF_MANAGER){
            QHeader.JP_Step1Approver__c = QHeader.JP_SectionChief__c;
        }else if(apm.JP_Step1Approver__c == MANAGER){
            QHeader.JP_Step1Approver__c = QHeader.JP_Manager__c;
        }else if(apm.JP_Step1Approver__c == GENERAL_MANAGER){
            QHeader.JP_Step1Approver__c = QHeader.JP_GeneralManager__c;
        }else if(apm.JP_Step1Approver__c == DIRECTOR){
            QHeader.JP_Step1Approver__c = QHeader.JP_Director__c;
        }
        
        // ステップ2ユーザセット
        if(apm.JP_step2Approver__c == CHIEF_MANAGER){
            QHeader.JP_step2Approver__c = QHeader.JP_SectionChief__c;
        }else if(apm.JP_step2Approver__c == MANAGER){
            QHeader.JP_step2Approver__c = QHeader.JP_Manager__c;
        }else if(apm.JP_step2Approver__c == GENERAL_MANAGER){
            QHeader.JP_step2Approver__c = QHeader.JP_GeneralManager__c;
        }else if(apm.JP_step2Approver__c == DIRECTOR){
            QHeader.JP_step2Approver__c = QHeader.JP_Director__c;
        }
        
        // ステップ3ユーザセット
        if(apm.JP_step3Approver__c == CHIEF_MANAGER){
            QHeader.JP_step3Approver__c = QHeader.JP_SectionChief__c;
        }else if(apm.JP_step3Approver__c == MANAGER){
            QHeader.JP_step3Approver__c = QHeader.JP_Manager__c;
        }else if(apm.JP_step3Approver__c == GENERAL_MANAGER){
            QHeader.JP_step3Approver__c = QHeader.JP_GeneralManager__c;
        }else if(apm.JP_step3Approver__c == DIRECTOR){
            QHeader.JP_step3Approver__c = QHeader.JP_Director__c;
        }
        
        // ステップ4ユーザセット
        if(apm.JP_step4Approver__c == CHIEF_MANAGER){
            QHeader.JP_step4Approver__c = QHeader.JP_SectionChief__c;
        }else if(apm.JP_step4Approver__c == MANAGER){
            QHeader.JP_step4Approver__c = QHeader.JP_Manager__c;
        }else if(apm.JP_step4Approver__c == GENERAL_MANAGER){
            QHeader.JP_step4Approver__c = QHeader.JP_GeneralManager__c;
        }else if(apm.JP_step4Approver__c == DIRECTOR){
            QHeader.JP_step4Approver__c = QHeader.JP_Director__c;
        }
        
        // ステップ5ユーザセット
        if(apm.JP_step5Approver__c == CHIEF_MANAGER){
            QHeader.JP_step5Approver__c = QHeader.JP_SectionChief__c;
        }else if(apm.JP_step5Approver__c == MANAGER){
            QHeader.JP_step5Approver__c = QHeader.JP_Manager__c;
        }else if(apm.JP_step5Approver__c == GENERAL_MANAGER){
            QHeader.JP_step5Approver__c = QHeader.JP_GeneralManager__c;
        }else if(apm.JP_step5Approver__c == DIRECTOR){
            QHeader.JP_step5Approver__c = QHeader.JP_Director__c;
        }
        
        // ステップ6ユーザセット
        if(apm.JP_step6Approver__c == CHIEF_MANAGER){
            QHeader.JP_step6Approver__c = QHeader.JP_SectionChief__c;
        }else if(apm.JP_step6Approver__c == MANAGER){
            QHeader.JP_step6Approver__c = QHeader.JP_Manager__c;
        }else if(apm.JP_step6Approver__c == GENERAL_MANAGER){
            QHeader.JP_step6Approver__c = QHeader.JP_GeneralManager__c;
        }else if(apm.JP_step6Approver__c == DIRECTOR){
            QHeader.JP_step6Approver__c = QHeader.JP_Director__c;
        }
        
        // ステップ1スキップ
        if((QHeader.JP_Step1Approver__c == QHeader.JP_Step2Approver__c) && 
           (QHeader.JP_Step1Approver__c != null &&
            QHeader.JP_Step2Approver__c != null)){
            QHeader.JP_Step1Skip__c = true;
        }
        
        // ステップ2スキップ
        if((QHeader.JP_Step2Approver__c == QHeader.JP_Step3Approver__c) && 
           (QHeader.JP_Step2Approver__c != null &&
            QHeader.JP_Step3Approver__c != null)){
            QHeader.JP_Step2Skip__c = true;
        }
        
        // ステップ3スキップ
        if((QHeader.JP_Step3Approver__c == QHeader.JP_Step4Approver__c) && 
           (QHeader.JP_Step3Approver__c != null &&
            QHeader.JP_Step4Approver__c != null)){
            QHeader.JP_Step3Skip__c = true;
        }
        
        // ステップ4スキップ
        if((QHeader.JP_Step4Approver__c == QHeader.JP_Step5Approver__c) && 
           (QHeader.JP_Step4Approver__c != null &&
            QHeader.JP_Step5Approver__c != null)){
            QHeader.JP_Step4Skip__c = true;
        }
        
        // ステップ5スキップ
        if((QHeader.JP_Step5Approver__c == QHeader.JP_Step6Approver__c) && 
           (QHeader.JP_Step5Approver__c != null &&
            QHeader.JP_Step6Approver__c != null)){
            QHeader.JP_Step5Skip__c = true;
        }
        
        //　STEP1承認者入力チェック
        if(QHeader.JP_Step1exec__c){
            if(QHeader.JP_Step1type__c == 'User' && QHeader.JP_Step1Approver__c == null){
                QHeader.addError(JP_Const.ERR_MESSAGE_STEP1APPROVER);
                isError = true;
            }
        }
        
        //　STEP2承認者入力チェック
        if(QHeader.JP_Step2exec__c){
            if(QHeader.JP_Step2type__c == 'User' && QHeader.JP_Step2Approver__c == null){
                QHeader.addError(JP_Const.ERR_MESSAGE_STEP2APPROVER);
                isError = true;
            }
        }
        
        //　STEP3承認者入力チェック
        if(QHeader.JP_Step3exec__c){
            if(QHeader.JP_Step3type__c == 'User' && QHeader.JP_Step3Approver__c == null){
                QHeader.addError(JP_Const.ERR_MESSAGE_STEP3APPROVER);
                isError = true;
            }
        }
        
        //　STEP4承認者入力チェック
        if(QHeader.JP_Step4exec__c){
            if(QHeader.JP_Step4type__c == 'User' && QHeader.JP_Step4Approver__c == null){
                QHeader.addError(JP_Const.ERR_MESSAGE_STEP4APPROVER);
                isError = true;
            }
        }
        
        //　STEP5承認者入力チェック
        if(QHeader.JP_Step5exec__c){
            if(QHeader.JP_Step5type__c == 'User' && QHeader.JP_Step5Approver__c == null){
                QHeader.addError(JP_Const.ERR_MESSAGE_STEP5APPROVER);
                isError = true;
            }
        }
        
        //　STEP6承認者入力チェック
        if(QHeader.JP_Step6exec__c){
            if(QHeader.JP_Step6type__c == 'User' && QHeader.JP_Step6Approver__c == null){
                QHeader.addError(JP_Const.ERR_MESSAGE_STEP6APPROVER);
                isError = true;
            }
        }
        
        // 課長チェック
        if(QHeader.JP_SectionChief__c == QHeader.JP_Outside__c 
            || (QHeader.JP_SectionChief__c == QHeader.JP_Inside__c && QHeader.JP_Inside__c != null) 
            || QHeader.JP_SectionChief__c == QHeader.JP_Applicant__c){
            QHeader.addError(JP_Const.ERR_MESSAGE_SALES_OUT_APPROVER);
            isError = true;
        }
        
        // 部長チェック
        if(QHeader.JP_Manager__c == QHeader.JP_Outside__c 
            || (QHeader.JP_Manager__c == QHeader.JP_Inside__c && QHeader.JP_Inside__c != null) 
            || QHeader.JP_Manager__c == QHeader.JP_Applicant__c){
            QHeader.addError(JP_Const.ERR_MESSAGE_SALES_OUT_APPROVER);
            isError = true;
        }
        
        // 本部長チェック
        if(QHeader.JP_GeneralManager__c == QHeader.JP_Outside__c 
            || (QHeader.JP_GeneralManager__c == QHeader.JP_Inside__c && QHeader.JP_Inside__c != null) 
            || QHeader.JP_GeneralManager__c == QHeader.JP_Applicant__c){
            QHeader.addError(JP_Const.ERR_MESSAGE_SALES_OUT_APPROVER);
            isError = true;
        }
        
        // 取締役チェック
        if(QHeader.JP_Director__c == QHeader.JP_Outside__c 
            || (QHeader.JP_Director__c == QHeader.JP_Inside__c && QHeader.JP_Inside__c != null) 
            || QHeader.JP_Director__c == QHeader.JP_Applicant__c){
            QHeader.addError(JP_Const.ERR_MESSAGE_SALES_OUT_APPROVER);
            isError = true;
        }
        
        if(isError){
            return null;
        }
        
        // 最終承認者セット
        if(apm.JP_StepCnt__c == 1){
            if(apm.JP_Step1type__c == 'User' && QHeader.JP_Step1Approver__c != null){
                QHeader.JP_ApprovalLV__c = UserDAO.getUserName(QHeader.JP_Step1Approver__c);
            }else{
                QHeader.JP_ApprovalLV__c = apm.JP_Step1Approver__c;
            }
        }else if(apm.JP_StepCnt__c == 2){
            if(apm.JP_Step2type__c == 'User' && QHeader.JP_Step2Approver__c != null){
                QHeader.JP_ApprovalLV__c = UserDAO.getUserName(QHeader.JP_Step2Approver__c);
            }else{
                QHeader.JP_ApprovalLV__c = apm.JP_Step2Approver__c;
            }
        }else if(apm.JP_StepCnt__c == 3){
            if(apm.JP_Step3type__c == 'User' && QHeader.JP_Step3Approver__c != null){
                QHeader.JP_ApprovalLV__c = UserDAO.getUserName(QHeader.JP_Step3Approver__c);
            }else{
                QHeader.JP_ApprovalLV__c = apm.JP_Step3Approver__c;
            }
        }else if(apm.JP_StepCnt__c == 4){
            if(apm.JP_Step4type__c == 'User' && QHeader.JP_Step4Approver__c != null){
                QHeader.JP_ApprovalLV__c = UserDAO.getUserName(QHeader.JP_Step4Approver__c);
            }else{
                if(apm.JP_Step4Approver__c == 'ATKK'){
                    QHeader.JP_ApprovalLV__c = system.label.JP_ATKK;
                }else if(apm.JP_Step4Approver__c == 'Partner'){
                    QHeader.JP_ApprovalLV__c = system.label.JP_Partner;
                }else if(apm.JP_Step4Approver__c == 'Warranty'){
                    QHeader.JP_ApprovalLV__c = system.label.JP_Warranty;
                }else if(apm.JP_Step4Approver__c == 'ATKK_Partner'){
                    QHeader.JP_ApprovalLV__c = system.label.JP_ATKK_Partner.replace('<br/>',',');
                }else if(apm.JP_Step4Approver__c == 'ATKK_Warranty'){
                    QHeader.JP_ApprovalLV__c = system.label.JP_ATKK_Warranty.replace('<br/>',',');
                }else if(apm.JP_Step4Approver__c == 'Partner_Warranty'){
                    QHeader.JP_ApprovalLV__c = system.label.JP_Partner_Warranty.replace('<br/>',',');
                }else if(apm.JP_Step4Approver__c == 'ATKK_Partner_Warranty'){
                    QHeader.JP_ApprovalLV__c = system.label.JP_ATKK_Partner_Warranty.replace('<br/>',',');
                }
            }
        }else if(apm.JP_StepCnt__c == 5){
            if(apm.JP_Step5type__c == 'User' && QHeader.JP_Step5Approver__c != null){
                QHeader.JP_ApprovalLV__c = UserDAO.getUserName(QHeader.JP_Step5Approver__c);
            }else{
                if(apm.JP_Step5Approver__c == 'ATKK'){
                    QHeader.JP_ApprovalLV__c = system.label.JP_ATKK;
                }else if(apm.JP_Step5Approver__c == 'Partner'){
                    QHeader.JP_ApprovalLV__c = system.label.JP_Partner;
                }else if(apm.JP_Step5Approver__c == 'Warranty'){
                    QHeader.JP_ApprovalLV__c = system.label.JP_Warranty;
                }else if(apm.JP_Step5Approver__c == 'ATKK_Partner'){
                    QHeader.JP_ApprovalLV__c = system.label.JP_ATKK_Partner.replace('<br/>',',');
                }else if(apm.JP_Step5Approver__c == 'ATKK_Warranty'){
                    QHeader.JP_ApprovalLV__c = system.label.JP_ATKK_Warranty.replace('<br/>',',');
                }else if(apm.JP_Step5Approver__c == 'Partner_Warranty'){
                    QHeader.JP_ApprovalLV__c = system.label.JP_Partner_Warranty.replace('<br/>',',');
                }else if(apm.JP_Step5Approver__c == 'ATKK_Partner_Warranty'){
                    QHeader.JP_ApprovalLV__c = system.label.JP_ATKK_Partner_Warranty.replace('<br/>',',');
                }
            }
        }else if(apm.JP_StepCnt__c == 6){
            if(apm.JP_Step6type__c == 'User' && QHeader.JP_Step6Approver__c != null){
                QHeader.JP_ApprovalLV__c = UserDAO.getUserName(QHeader.JP_Step6Approver__c);
            }else{
                if(apm.JP_Step6Approver__c == 'ATKK'){
                    QHeader.JP_ApprovalLV__c = system.label.JP_ATKK;
                }else if(apm.JP_Step6Approver__c == 'Partner'){
                    QHeader.JP_ApprovalLV__c = system.label.JP_Partner;
                }else if(apm.JP_Step6Approver__c == 'Warranty'){
                    QHeader.JP_ApprovalLV__c = system.label.JP_Warranty;
                }else if(apm.JP_Step6Approver__c == 'ATKK_Partner'){
                    QHeader.JP_ApprovalLV__c = system.label.JP_ATKK_Partner.replace('<br/>',',');
                }else if(apm.JP_Step6Approver__c == 'ATKK_Warranty'){
                    QHeader.JP_ApprovalLV__c = system.label.JP_ATKK_Warranty.replace('<br/>',',');
                }else if(apm.JP_Step6Approver__c == 'Partner_Warranty'){
                    QHeader.JP_ApprovalLV__c = system.label.JP_Partner_Warranty.replace('<br/>',',');
                }else if(apm.JP_Step6Approver__c == 'ATKK_Partner_Warranty'){
                    QHeader.JP_ApprovalLV__c = system.label.JP_ATKK_Partner_Warranty.replace('<br/>',',');
                }
            }
        }

        try{
            update QHeader;
        }catch (Exception ex){
            ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()+'\n'+ex.getStackTraceString()));
            return null;
        }
        
        //参照画面遷移
        retPage = new PageReference('/'+ this.QHeader.Id); 
        
        return retPage;
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
}