public without sharing class JP_CLMakeOppFromContact {
    
    private final Contact con;
    private  List<String> setList;
    public static String PROFILE_SPLITTER = '_';
    public static Profile UProfile;
    public static List<String> PPrefix;
    
    public JP_CLMakeOppFromContact(ApexPages.StandardController stdController) {
        this.con = (Contact)stdController.getRecord();
    }
    
    public PageReference makeOpp(){
        //国別固定値リストの取得
        //プロファイルプレフィックスの設定
        UProfile = [Select Name From Profile where Id = :Userinfo.getProfileId()];
        PPrefix = UProfile.Name.split(PROFILE_SPLITTER, 2);
        
        //プレフィックスがない場合（システム管理者）はJP_MakeOppFromContactページに遷移し、エラーを表示する。
        if(PPrefix.size() != 2){
            PageReference pre = ApexPages.currentPage();
            con.addError(system.label.JP_ErrorMessageProfile); 
            return pre;
        }
        
        JP_CreateList jpc = new JP_CreateList(); 
        setList = jpc.getvalueList(PPrefix[0]);
        
        //リスト値が0の場合はJP_MakeOppFromContactページに遷移し、エラーを表示する。
        if(setList.size() == 0){
            PageReference pre = ApexPages.currentPage();
            con.addError(system.label.JP_ErrorMessageProfile); 
            return pre;
        }
        
        //実行ユーザの国のレコードタイプIDを取得 -
        RecordType rtJPOpp = [SELECT id From RecordType where DeveloperName = :setList[0]];
        
        //ダミー会社のIDを取得 -
        List<Account> DummyList = [Select id From Account where Name= :setList[1] limit 1];
        //ダミー会社が存在しない場合はJP_MakeOppFromContactページに遷移し、エラーを表示する。
        if(DummyList.size()!=1){
            PageReference pre = ApexPages.currentPage();
            con.addError(system.label.JP_ErrorMessageAccount); 
            return pre;
        }
        Account DummyEnd = DummyList[0];
        
        //商談 -
        Opportunity opp = new Opportunity();
        opp.Name = setList[2];
        opp.AccountId = DummyEnd.Id;
        //当月末をデフォルトセット -
        Date dToday = System.today();
        Integer iYear  = dToday.year();
        Integer iMonth = dToday.month();
        //月末日を取得 -
        opp.CloseDate = Date.newInstance(iYear, iMonth, date.daysInMonth(iYear, iMonth));
        opp.StageName = setList[3];
        opp.RecordTypeId = rtJPOpp.id;

        insert opp;
        
        //顧客の役割　 -
        OpportunityContactRole ocr = new OpportunityContactRole();
        ocr.OpportunityId = opp.id;
        ocr.ContactId = con.id;
        ocr.Role= setList[4];
        ocr.IsPrimary =true;

        insert ocr;
        
        //パートナー -
        Partner ptn = new Partner();
        ptn.OpportunityId = opp.id;
        ptn.AccountToID = con.Accountid;
        ptn.Role = setList[5];
        ptn.isPrimary = true;

        insert ptn;

        PageReference pr = new PageReference('/p/opp/ContactRoleEditUi/e?oppid=' + opp.id + '&retURL=/' + opp.id);  
        return pr;
    }
}