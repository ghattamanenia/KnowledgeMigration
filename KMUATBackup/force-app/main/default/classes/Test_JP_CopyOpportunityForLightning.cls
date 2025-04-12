@isTest(SeeAllData=true)
private class Test_JP_CopyOpportunityForLightning {

    //関連情報と共にコピーの画面の全てのチェックボックスがチェックなしの場合、コピーする商談の完了予定日が過去日付の場合
    @isTest
    static void testCopy01() {
        User u = getUser();
        System.runAs(u){
            Date targetDate = Date.today();//当日
			Date closeDate = targetDate.addMonths(-3);//3か月前
            Opportunity opp = createOppData();
            opp.CloseDate = closeDate;
            Test.startTest();
            JP_CopyOpportunityForLightning.doCopyRec(opp.Id, false, false, false, false, false, false);//20250212 semba update
            Test.stopTest();
        }
    }

    //関連情報と共にコピーの画面の「商談商品」にのみにチェックが入っているかつ商談に商談商品が紐ついている場合
    @isTest
    static void testCopy02() {
        User u = getUser();
        System.runAs(u){
            Opportunity opp = createOppData();
            OpportunityLineItem oli = createOppLineItemData(opp.Id);
            //20221114 ALLIEDTELESIS-481 terrasky mod start
            opp.StageName = JP_Const.STAGENAME_PROSPECTQUALIFICATION;
            opp.JP_DirectTouchDegree__c = null;
            update opp;
            //20221114 ALLIEDTELESIS-481 terrasky mod end
            Test.startTest();
            JP_CopyOpportunityForLightning.doCopyRec(opp.Id, true, false, false, false, false, false);//20250212 semba update
            Test.stopTest();
        }
    }

    //関連情報と共にコピーの画面の「パートナー」にのみにチェックが入っている場合
    @isTest
    static void testCopy03() {
        User u = getUser();
        System.runAs(u){
            Opportunity opp = createOppData();
            Partner p = createPartnerData(opp.Id);
            Test.startTest();
            JP_CopyOpportunityForLightning.doCopyRec(opp.Id, false, true, false, false, false, false);//20250212 semba update
            Test.stopTest();
        }
    }

    //関連情報と共にコピーの画面の「顧客の役割」にのみにチェックが入っている場合
    @isTest
    static void testCopy04() {
        User u = getUser();
        System.runAs(u){
            Opportunity opp = createOppData();
            OpportunityContactRole ocr = createOpportunityContactRole(opp.Id);
            Test.startTest();
            JP_CopyOpportunityForLightning.doCopyRec(opp.Id, false, false, true, false, false, false);//20250212 semba update
            Test.stopTest();
        }
    }

    //関連情報と共にコピーの画面の「商談チーム」にのみにチェックが入っている場合
    @isTest
    static void testCopy05(){
        User u = getUser();
        System.runAs(u){
            Opportunity opp = createOppData();
            User user = getUser();
            OpportunityTeamMember otm = createOpportunityTeamMember(opp.Id,user.Id);
            Test.startTest();
            JP_CopyOpportunityForLightning.doCopyRec(opp.Id, false, false, false, true, false, false);//20250212 semba update
            Test.stopTest();
        }
    }

    //関連情報と共にコピーの画面の「商談商品」にのみにチェックが入っているかつ、商談に商談商品が紐ついている場合
    @isTest
    static void testCopy06() {
        User u = getUser();
        System.runAs(u){
            Opportunity opp = createOppData();
            OpportunityLineItem oli = createOppLineItemData(opp.Id);
            opp.JP_ReasonNoOppLineItem__c = '';
            //20221114 ALLIEDTELESIS-481 terrasky mod start
            opp.StageName = JP_Const.STAGENAME_PROSPECTQUALIFICATION;
            opp.JP_DirectTouchDegree__c = null;
            //20221114 ALLIEDTELESIS-481 terrasky mod end
            update opp;
            Test.startTest();
            JP_CopyOpportunityForLightning.doCopyRec(opp.Id, true, false, false, false, false, false);//20250212 semba update
            Test.stopTest();
        }
    }
    
//20241204 semba add start
    //テスト実施ユーザと商談チームのユーザが違うかつ、編集権限がAllの場合
    @isTest
    static void testCopy07(){
        User u = getUser();
        System.runAs(u){
            Opportunity opp = createOppData();
            User user = getUser2();
            OpportunityTeamMember otm = createOpportunityTeamMember(opp.Id,user.Id);
            otm.OpportunityAccessLevel = 'All';
            update otm;
            Test.startTest();
            JP_CopyOpportunityForLightning.doCopyRec(opp.Id, false, false, false, true, false, false);//20250212 semba update
            Test.stopTest();
        }
    }
//20241204 semba add end
    
    //20241204 semba update start
    //20241029 ALLIEDTELESIS-510 terrasky add start
    //@isTest
    //static void testCopy08() {
        //User u = getUser();
        //System.runAs(u) {
            //Opportunity opp = createOppData();
            //OpportunityLineItem oli = createOppLineItemData(opp.Id);
            //opp.JP_CopyableClosedOpportunity__c = true;
            //List<String> highStageList = System.Label.JP_HighStageName.split(',');
          //opp.StageName = highStageList[0];
            //update opp;
            //Test.startTest();
            //JP_CopyOpportunityForLightning.doCopyRec(opp.Id, true, false, true, false, false);
            //Test.stopTest();
        //}
    //}
   //20241029 ALLIEDTELESIS-510 terrasky add end
   //20241204 semba update end

          
    // 取引先作成
    private static Account createAccountData(){
        Account acc = new Account();
        acc.Name = 'test account';
        acc.Phone = '0312345678';
        insert acc;

        return acc;
    }

    // 商談作成
    private static Opportunity createOppData(){
        RecordType oppRec = [Select Id from RecordType where DeveloperName = 'JP_Opportunity'];
        PriceBook2 pb2 = getPriceBook();
        Account acc = createAccountData();
        JP_Project__c PJ = createProject();//20241204 semba add
        //20221114 Alliedtelesis-462 Add start
        Opportunity opp = JP_TestUtil.Create_Opportunity ();
        //20221114 Alliedtelesis-462 Add end
        opp.Name = 'Test Opportunity';
        opp.Description = 'Test Description';
        opp.CloseDate = system.today().addDays(30);
        opp.StageName = 'Prospect/Qualification';
        opp.Amount = 10000;
        opp.AccountId = acc.Id;
        opp.Pricebook2Id = pb2.Id;
        opp.JP_DistributionChannels__c = 'DIS';
        opp.JP_Distribution__c = 'Test Distribution';
        opp.JP_AdptionMaker__c = 'Acton';
        opp.JP_AtkkAccuracy__c = '確定';
        opp.JP_BANTC_01_Budget__c = 'TEST01';
        opp.JP_BANTC_02_Authority__c = 'TEST02';
        opp.JP_BANTC_03_Needs__c = 'TEST03';
        opp.JP_BANTC_04_TimeFrame__c = 'TEST04';
        opp.JP_BANTC_05_Competitor__c = 'TEST05';
        opp.JP_CampaignSalesOpportunity__c = 'AMF';
        opp.JP_DMG__c = true;
        opp.JP_DayOfTender__c = system.today().addDays(30);
        opp.JP_DeleteFlag__c = false;
        opp.JP_DirectTouchDegree__c = '100%：商談はE/Uキーマンと共に全て自分の管理下で進めた'; //20201225 ALLIEDTELESIS-453 terrasky mod
        opp.JP_DirectorVisited__c = 'JP_PersonInCharge';
        opp.JP_DistributorAccuracy__c = '確定';
        opp.JP_DivisionHistory__c = 'Test JP_DivisionHistory__c';
        opp.JP_EnduserPrefecture__c = '新潟県';
        opp.JP_FailedOfferCompany__c = acc.Id;
        opp.JP_FailedOfferDetails__c = 'Test JP_FailedOfferDetails__c';
        opp.JP_FailedOfferReason__c = '別商流にてATKK受注';
        opp.JP_FinalMailSendTime__c = system.now();
        opp.JP_Finance__c = true;
        opp.JP_GiDate__c = system.today().addDays(30);
        opp.JP_MailFlag__c = false;
        opp.JP_MaintenanceQuoteId__c = 'Test';
        opp.JP_MaintenanceTrace__c = '受注済み';
        opp.JP_OpportunitySource__c = '代理店からの見積り依頼より(OUT)';
        opp.JP_OrderDate__c = system.today().addDays(30);
        opp.JP_ParentOPP_ID__c = 'Test';
        opp.JP_SDN_Notes__c = 'Test JP_SDN_Notes__c';
        opp.JP_SPMSCooperationdate__c = system.now();
        opp.JP_SpecialServiceForMembers__c = 'xシリーズプログラム';
        opp.JP_Tags__c = 'Test JP_Tags__c';
        opp.JP_TenderingProject__c = '一般入札';
        opp.JP_TraceGroup__c = 'インサイド対応可';
        opp.JP_WinningBidders__c = 'JP_WinningBidders__c';
        opp.JP_isJapan__c = true;
        opp.RecordTypeId = oppRec.Id;
        opp.Type = '新規 (New)';
        opp.JP_TargetDistributorCode__c = 'Test';
//20201225 ALLIEDTELESIS-453 terrasky add start
        opp.JP_DirectRank__c = JP_Const.JP_DIRECT_RANK_A;
        opp.StageName = JP_Const.STAGENAME_CLOSEDWON;
        opp.JP_ReasonNoOppLineItem__c = JP_Const.REASON_NO_OPP_LINE_ITEM_COPY;
//20201225 ALLIEDTELESIS-453 terrasky add end
//20241204 semba add start
		opp.JP_Partner1__c = acc.Id;
        opp.JP_Project__c = PJ.Id;
//20201204 semba add end
        
        update opp;

        return opp;
    }

    // 商談商品作成
    private static OpportunityLineItem createOppLineItemData(Id OppId){
        OpportunityLineItem oli = new OpportunityLineItem();

        PriceBook2 pb2 = getPriceBook();

        Product2 p2 = new Product2();
        p2.Name = 'Test';
        p2.IsActive = true;
        insert p2;

        PriceBookEntry pbe = new PriceBookEntry();
        pbe.Pricebook2Id = pb2.Id;
        pbe.Product2Id = p2.Id;
        pbe.UnitPrice = 1000;
        pbe.IsActive = true;
        insert pbe;

        oli.OpportunityId = oppId;
        oli.Product2Id = p2.Id;
        oli.PriceBookEntryId = pbe.Id;
        oli.UnitPrice = 1000;
        oli.Quantity = 1;
        insert oli;

        return oli;
    }
	
    //価格表の取得
    private static PriceBook2 getPriceBook(){
        PriceBook2 pb = [Select Id From PriceBook2 Where IsStandard = true Limit 1];
        return pb;
    }
    
    //20241204 semba add start
    //プロジェクト作成
    private static JP_Project__c createProject(){
        JP_Project__c PJ = new JP_Project__c();
        
        PJ.name = 'test_project';
        
        insert PJ;
        
        return PJ;
    }
    //20241204 semba add end

    // パートナー作成
    private static Partner createPartnerData(Id OppId){
        Partner p = new Partner();
        Account acc = createAccountData();

        p.AccountToId = acc.Id;
        p.OpportunityId = OppId;
        p.IsPrimary = true;
        p.Role = 'JP_USE_ONLY03';
        insert p;

        return p;
    }
    
    //顧客の役割
    private static OpportunityContactRole createOpportunityContactRole(Id OppId){
        OpportunityContactRole ocr = new OpportunityContactRole();
        Contact con = createContact();

        ocr.OpportunityId = OppId;
        ocr.ContactId = con.Id;
        ocr.IsPrimary = true;
        insert ocr;

        return ocr;
    }
    
    //顧客作成
    private static Contact createContact(){
        Contact con = new Contact();
        con.LastName = 'test';
        insert con;

        return con;
    }

    private static OpportunityShare createOpportunityShare(Id OppId, Id userId){
        OpportunityShare os = new OpportunityShare();

        os.OpportunityAccessLevel = 'Edit';
        os.UserOrGroupId = userId;
        os.OpportunityId = OppId;
system.debug('=== os : ' + os);
        insert os;
        return os;
    }

    //商談チーム
    private static OpportunityTeamMember createOpportunityTeamMember(Id OppId, Id userId){
        OpportunityTeamMember otm = new OpportunityTeamMember();
        otm.OpportunityId = OppId;
        otm.UserId = userId;
        otm.OpportunityAccessLevel = 'Edit';
        otm.TeamMemberRole = 'BP Assistance';
        insert otm;

        return otm;
    }

    //ユーザ取得
    public static User getUser(){
        Profile p = getProfile('JP_SalesUser');
        User user = [select Id from User where IsActive = true and ProfileId = :p.Id limit 1];
        
        return user;
    }
    //20241204 semba add start
    //ユーザ2取得
    public static User getUser2(){
        Profile p = getProfile('システム管理者');
        User user2 = [select Id from User where IsActive = true and ProfileId = :p.Id limit 1];
        
        return user2;
    }
    //20241204 semba add end

    /*
     * プロファイル取得
     */
    private static Profile getProfile(String PROFILE_NAME) {
        return [select Id,Name from Profile where Name =: PROFILE_NAME limit 1];
    }

}