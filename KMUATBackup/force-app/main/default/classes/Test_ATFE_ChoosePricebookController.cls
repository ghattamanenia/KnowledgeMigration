/*******************
Description: This cord is a test cord of ATFE_ChoosePricebookController.
Developer: Hitachi Solutions, Ltd.
Date Created: 10/1/2010
Date Modified: 6/7/2011
*****************/
/*
    Because of Force.com restriction, profiles can't insert,
    so this Test Class is implimented with basis of profiles were already deployed.
    Be careful at execute tests or deploy this source code.
    This TestClass needs to execute by the USER their language is English or Japanese. Because of retrieving  SystemAdministrator Profile Id.

    テストカバー率は75％を目指したので、現在85%のカバー率でテストクラスの作成を完了としている。
    （100%を目指すとテスト実行に時間がかかるため）

    【カバーしていないデータパターン】
    ・コンストラクタを呼び出し価格表一覧を取得した際に、価格表が1つも該当しなかったデータ(Line120,121)
    ・代理店選択後、「次へ」押下時に価格表が1つも該当しなかったデータ（Line251,252）
    ・見積作成ボタン押下時
        －ユーザープロファイルが、外国のプロファイルのデータ(Line370)
        －エラー発生のデータ(Line376,379,382,384)
    ・価格表選択ボタン押下時
        －外国プロファイルで遷移する商品追加画面のURL作成データ(Line392～395)
        －日本プロファイルで連携レコード作成の生成のデータ(Line411～420)
        －日本プロファイルのセーブポイント定義・設定データ(Line423,425,427,429)
        －エラー発生のデータ(Line432,433,436,438)
        －見積ポーリング画面のURL作成のデータ(Line442～444)
*/
@isTest
private class Test_ATFE_ChoosePricebookController{
    // □□□create test data□□□
    //各プロファイルIDを取得
    // We no longer have EMEA_SalesUser or NA_SalesUser profiles.  We only use 'Sales User' so the code will be updated
    static Profile pEMEA = [select id from profile where name='Sales User'];
    static Profile pNA = [select id from profile where name='Sales User'];
    static Profile pJP = [select id from profile where name='JP_SalesUser'];
    static Profile pNA2 = [select id from profile where name='NA_APIUser'];//★2024/05/10 NA_SalesManager →　NA_APIUser
    static Profile pSysad = [select id from profile where name='System Administrator' or name='システム管理者'];
    static List<RecordType> RecordTypeList = [select Name,ID from RecordType where SObjectType ='Account' order by name];
    static Map<String, Id> RecordTypeMap = new Map<String, Id>();
    
    /**
     * Create Account RecordType Map (key-RecordTypeName, value-RecordTypeId)
     */
    public static void getAccountRecordType(){
        for(Integer i = 0; i < RecordTypeList.size(); i++){
            RecordTypeMap.put(RecordTypeList[i].Name,RecordTypeList[i].Id);
        }
        System.debug(RecordTypeMap);
    }
    
    /**
     * Account insert for America
     * @param なし -
     * @return test_acc.Id
     * @throws なし -
     */
    public static String prepareDataAmericaAccount(){
        Account test_acc = new Account();
        test_acc.Name = 'NA_TEST_ACCOUNT';
        test_acc.Name = 'TestAccount';
        test_acc.BillingCountry = 'United States';
        test_acc.BillingStreet = '123 Fake St';
        test_acc.BillingCity = 'Toronto';
        test_acc.BillingState = 'Ontario';
        test_acc.BillingPostalCode = 'M5J 2T3';
        test_acc.BillingCountry = 'Canada';
        test_acc.RecordTypeId = RecordTypeMap.get('ATI Accounts');
        insert test_acc;
        return test_acc.Id;
    }
    /**
     * Account insert for EMEA
     * @param なし -
     * @return test_acc.Id
     * @throws なし -
     */
    public static String prepareDataEMEAAccount(){
        Account test_acc = new Account();
//        test_acc.Name = 'NA_TEST_ACCOUNT';
        test_acc.Name = 'TestAccount';
        //test_acc.BillingCountry = 'Germany';
        test_acc.BillingStreet = '123 Fake St';
        test_acc.BillingCity = 'Toronto';
        test_acc.BillingState = 'Ontario';
        test_acc.BillingPostalCode = 'M5J 2T3';
        test_acc.BillingCountry = 'Canada';
        test_acc.RecordTypeId = RecordTypeMap.get('EMEA Accounts');
        insert test_acc;
        return test_acc.Id;
    }
    
    /**
     * Account insert for Japan
     * @param なし -
     * @return test_acc.Id - insertした会社のID
     * @throws なし -
     */
    public static String prepareDataJapanAccount(){
        Account test_acc = new Account();
        test_acc.Name = 'JP_TEST_ACCOUNT';
        test_acc.Phone = '+81 3-1111-2222';
        test_acc.RecordTypeId = RecordTypeMap.get('JP_AccountsBeforeCleansing');
        test_acc.BillingCountry = 'Japan';
        insert test_acc;
        return test_acc.Id;
    }

    /**
     * 代理店情報のinsert
     * @param acc_id - 作成した会社のID
     * @return test_dis.id - insertした代理店のID
     * @throws なし -
     */
    public static Id prepareDataDistributor(Id acc_id){
        JP_Distributor__c test_dis = new JP_Distributor__c();
        test_dis.Name = 'JP_TEST_DISTRIBUTOE';
        test_dis.JP_SAPCompanyCode__c = '222';
        test_dis.JP_SAPAccountGroup__c = '33';
        test_dis.JP_DistributorCode__c = '1020aaaaa';
        test_dis.JP_SalesOrganization__c = '44';
        test_dis.JP_DistributionChannel__c = '5';
        test_dis.JP_Division__c = '6';
        test_dis.JP_Connectionkey1__c = '222_33_1020aaaaa_44_5_6';
        test_dis.JP_Connectionkey2__c = '1020aaaaa_44_5_6';
        test_dis.JP_Account__c = acc_id;
        insert test_dis;
        return test_dis.id;
    }

    /**
     * Contact insert for America
     * @param acc_id
     * @return test_con.id
     * @throws none -
     */
    public static Id prepareDataAmericaContact(Id acc_id){
        Contact test_con = new Contact();
        test_con.LastName = 'NA_TEST_CONTACT';
        test_con.FirstName = '@@@';
        test_con.AccountId = acc_id;
        test_con.MailingCountry = 'United States';
        test_con.CurrencyIsoCode = 'USD';
        insert test_con;
        return test_con.id;
    }
    /**
     * 顧客情報のinsert
     * @param acc_id - 作成した会社のID
     * @return test_con.id - insertした顧客のID
     * @throws なし -
     */
    public static Id prepareDataJapanContact(Id acc_id){
        Contact test_con = new Contact();
        test_con.LastName = 'JP_TEST_CONTACT';
        test_con.FirstName = '@@@';
        test_con.AccountId = acc_id;
        test_con.CurrencyIsoCode = 'JPY';
        test_con.JP_Grade__c = 'D';
        test_con.MailingCountry = 'Japan';//2024/01/22 Add Semba 
        insert test_con;
        return test_con.id;
    }
    /**
     * NA-Pricebook insert
     * @param acc_id
     * @return test_prb_id
     * @throws なし -
     */
    public static String prepareDataAmericaPrb(Id acc_id){
        Pricebook2 test_prb = new Pricebook2();
        test_prb.Name = 'NA 2010/Q1';
        test_prb.Description = '▲▲';
        test_prb.IsActive = true;
        insert test_prb;
        String test_prb_id = test_prb.Id;
        return test_prb_id;
    }
    
    /**
     * EMEA-Pricebook insert
     * @param acc_id - 作成した会社のID
     * @return test_prb_id - insertしたEMEA価格表のID
     * @throws なし -
     */
    public static String prepareDataEMEAPrb(Id acc_id){
        Pricebook2 test_prb = new Pricebook2();
        test_prb.Name = 'EMEA 2010/Q1';
        test_prb.Description = '▲▲';
        test_prb.IsActive = true;
        insert test_prb;
        String test_prb_id = test_prb.Id;
        return test_prb_id;
    }

    /**
     * JP価格表（代理店コードと説明項目が同じ仕切表）のinsert
     * @param acc_id - 作成した会社のID、dis_id - 作成した代理店のID
     * @return test_prb3.id - insertしたJP価格表のID
     * @throws なし -
     */
    public static String prepareDataJPPrb(Id acc_id,Id dis_id){
        Pricebook2 test_prb3 = new Pricebook2();
        test_prb3.Name = 'JP 2010/08 P-010';
        test_prb3.Description = '▲▲';
        test_prb3.IsActive = true;
        insert test_prb3;
        JP_PricebookMapping__c test_prb_map = new JP_PricebookMapping__c();
        test_prb_map.JP_Distributor__c = dis_id;
        test_prb_map.JP_UsePricebookCode__c = '▲▲';
        insert test_prb_map;
        return test_prb3.id;
    }
    /**
     * JP価格表（代理店コードと説明項目が違う仕切表）のinsert
     * @param acc_id - 作成した会社のID、dis_id - 作成した代理店のID
     * @return test_prb4.Id - insertしたJP価格表のID
     * @throws なし -
     */
    public static String prepareDataJPPrb2(Id acc_id,Id dis_id){
        Pricebook2 test_prb4 = new Pricebook2();
        test_prb4.Name = 'JP 2010/09 P-011';
        test_prb4.Description = '■■';
        insert test_prb4;
        JP_PricebookMapping__c test_prb_mapJP = new JP_PricebookMapping__c();
        test_prb_mapJP.JP_Distributor__c = dis_id;
        test_prb_mapJP.JP_UsePricebookCode__c = '■■';
        insert test_prb_mapJP; 
        return test_prb4.Id;
    }
    /**
     * 商談情報（宛先顧客の指定あり）のinsert
     * @param acc_id - 作成した会社のID、con_id - 作成した顧客のID、prb_id - 作成した価格表のID
     * @return test_opp.Id - insertした商談情報のID
     * @throws なし -
     */
    public static Id prepareDataOpp(Id acc_id,Id con_id,Id prb_id){
        Opportunity test_opp = new Opportunity();
        test_opp.Name = 'テスト商談@';
        test_opp.CloseDate = system.today().adddays(2);//20240912 update semba 
        // test_opp.StageName = 'Final Quote';
        test_opp.stageName='Engagement/Value Proposition';
        test_opp.Required_Delivery_Date__c=system.today().adddays(3);
        test_opp.AccountId = acc_id;
        test_opp.JP_Enduser__c = acc_id;
        test_opp.JP_RelatedContact__c = con_id;
        test_opp.JP_ContactEnduser__c = con_id;
        test_opp.pricebook2id= prb_id;
        test_opp.JP_SendToAccount__c= acc_id;
        test_opp.JP_SendToContact__c= con_id;
        test_opp.JP_NoSendToContactFlag__c= FALSE;
        test_opp.JP_PlVersion__c= '';
        test_opp.JP_TargetDistributorCode__c= '1020aaaaa';
        insert test_opp;
        return test_opp.Id;
    }
    /**
     * 商談情報（宛先顧客の指定なし）のinsert
     * @param acc_id - 作成した会社のID、con_id - 作成した顧客のID、prb_id - 作成した価格表のID
     * @return test_opp.Id - insertした商談情報のID
     * @throws なし -
     */
    public static Id prepareDataOpp2(Id acc_id,Id con_id,Id prb_id){
        Opportunity test_opp2 = new Opportunity();
        test_opp2.Name = 'テスト商談@';
        test_opp2.Required_Delivery_Date__c=system.today().adddays(3);
        test_opp2.CloseDate = system.today().adddays(2);//20240912 update semba 
        test_opp2.StageName = 'Final Quote';
        test_opp2.AccountId = acc_id;
        test_opp2.JP_Enduser__c = acc_id;
        test_opp2.JP_RelatedContact__c = con_id;
        test_opp2.JP_ContactEnduser__c = con_id;
        test_opp2.pricebook2id= prb_id;
        test_opp2.JP_SendToAccount__c= acc_id;
        test_opp2.JP_SendToContact__c= null;
        test_opp2.JP_NoSendToContactFlag__c= TRUE;
        test_opp2.JP_PlVersion__c= '';
        test_opp2.JP_TargetDistributorCode__c= '1020aaaaa';
        insert test_opp2;
        return test_opp2.Id;
    }
    
    /**
     * 商談情報（宛先顧客の指定なし）のinsert
     * @param tmp_oppId - 作成した商談のID
     * @return opptmp - selectしたIDのリスト
     * @throws なし -
     */
    public static List<Opportunity> prepareDataOpp(Id tmp_oppId){
        List<Opportunity> opptmp = [select id from Opportunity where Id =: tmp_oppId];
        return opptmp;
    }
    
    // ■■■test class■■■
    /**
     * Check ATFE_ChoosePricebookController（外国プロファイル：コンストラクタ呼び出し正常）
     * @param なし -
     * @return なし -
     * @throws なし -
     */
    private static testMethod void Test_ATFE_ChoosePricebookController001() {
        //テストページを用意
        PageReference pageRef = Page.ATFE_ChoosePricebook;
        Test.setCurrentPage(pageRef);
        
        getAccountRecordType();

        //会社ID・価格表ID・顧客IDを取得
        Id tmp_accId = prepareDataAmericaAccount();
        Id tmp_prbId = prepareDataAmericaprb(tmp_accId);
        Id tmp_conId = prepareDataAmericaContact(tmp_accId);

        //プロファイル・ユーザ情報を設定（外国ユーザ）
        //Set the user profile information (US)
        User u = new User(alias = 'NATest', email='standarduser@testorg.com',
            emailencodingkey='UTF-8', lastname='NATest',
            languagelocalekey='en_US', localesidkey='en_US', profileid = pNA.Id,
            timezonesidkey='America/Los_Angeles', username='standarduser_test@alliedtelesistestorg.com');
        //AccountShare ash = new AccountShare(UserOrGroupId = u.id, OpportunityAccessLevel = 'Edit', ContactAccessLevel = 'Edit', CaseAccessLevel = 'Edit', AccountId = tmp_accId, AccountAccessLevel = 'Edit');
        //insert ash;
        insert u;
        ContactShare cs = new ContactShare(UserOrGroupId = u.id, ContactAccessLevel = 'Edit', ContactId = tmp_conId);
        insert cs;
        System.runAs(u) {            
          String tmp_oppId = prepareDataOpp(tmp_accId,tmp_conId,tmp_prbId);

            //パラメータの設定
            //Parameters
            ApexPages.currentPage().getParameters().put('id', tmp_oppId);

            //商談型リストを定義し、作成した商談のIDを取得
            //Opportunity to define a list type, get the ID of the opportunities created
            List<Opportunity> opptmp = new List<Opportunity>();
            opptmp = prepareDataOpp(tmp_oppId);
            ApexPages.StandardController sc = new ApexPages.StandardController(opptmp[0]);
            ATFE_ChoosePricebookController cPrbCon = new ATFE_ChoosePricebookController(sc);
            Test.Starttest();

                //テスト対象メソッドの呼び出し
                //Test method invocation
                cPrbCon.getNextBtn();
                cPrbCon.getBackBfrBtn();
                cPrbCon.getEndPrbStartQuo();
                cPrbCon.getNextBtnRender();
                cPrbCon.getbackBtnRender();
                cPrbCon.getEndPrbStartQuoBtnRender();
                cPrbCon.endPrbStartQuo();
            //Test.StopTest();
       //String nextPage = cPrbCon.endPrbStartQuo().getUrl();
       
   
            tmp_oppId = prepareDataOpp(tmp_accId,tmp_conId,tmp_prbId);

            //パラメータの設定
            ApexPages.currentPage().getParameters().put('id', tmp_oppId);

            //商談型リストを定義し、作成した商談のIDを取得
            opptmp = prepareDataOpp(tmp_oppId);
            sc = new ApexPages.StandardController(opptmp[0]);
            //Test.Starttest();

                //コンストラクタの呼び出し
                cPrbCon = new ATFE_ChoosePricebookController(sc);
                ATFE_PricebookManagerNA cna = new ATFE_PricebookManagerNA();
                ATFE_PricebookManagerEMEA nemea = new ATFE_PricebookManagerEMEA();
                
                
                cna.getRegion();
                nemea.getRegion();
       cPrbCon.endPrbStartQuo();
       
                
                cPrbCon.getShow_other_description();
cPrbCon.getCreateListVal();
cPrbCon.getSelectValue();
cPrbCon.setSelectValue('test');
cPrbCon.getHeaderVal() ;
cPrbCon.getSmallHeader(); 
cPrbCon.getNextBtn();
cPrbCon.getBackBfrBtn();
cPrbCon.getEndPrbStartQuo();
cPrbCon.getNextBtnRender();
cPrbCon.getbackBtnRender();
cPrbCon.getEndPrbStartQuoBtnRender();
cPrbCon.getCancelName();
cPrbCon.getPrbBtnName();
            Test.StopTest();
           
        }
    }
    /**
     * Check ATFE_ChoosePricebookController（日本プロファイル：コンストラクタ呼び出し正常）
     * @param なし -
     * @return なし -
     * @throws なし -
     */
        private static testMethod void Test_ATFE_ChoosePricebookController002() {
        //テストページを用意
        PageReference pageRef = Page.ATFE_ChoosePricebook;
        Test.setCurrentPage(pageRef);
        
        getAccountRecordType();

        //会社ID・代理店ID・価格表ID・顧客IDを取得
        Id tmp_accId = prepareDataJapanAccount();
        Id tmp_disId = prepareDataDistributor(tmp_accId);
        Id tmp_prbId = prepareDataJPprb(tmp_accId,tmp_disId);
        Id tmp_conId = prepareDataJapanContact(tmp_accId);

        //プロファイル・ユーザ情報を設定（日本ユーザ）
        User u = new User(alias = 'テスト', email='standarduser@testorg.com',
            emailencodingkey='UTF-8', lastname='価格表テストクラスユーザJP',
            languagelocalekey='ja', localesidkey='ja', profileid = pJP.id,
            timezonesidkey='Asia/Tokyo', username='standarduser_test@alliedtelesistestorg.com');
        insert u;
        ContactShare cs = new ContactShare(UserOrGroupId = u.id, ContactAccessLevel = 'Edit', ContactId = tmp_conId);
        insert cs;
        System.runAs(u) {
            String tmp_oppId = prepareDataOpp(tmp_accId,tmp_conId,tmp_prbId);

            //パラメータの設定
            ApexPages.currentPage().getParameters().put('id', tmp_oppId);

            //商談型リストを定義し、作成した商談のIDを取得
            List<Opportunity> opptmp = prepareDataOpp(tmp_oppId);
            ApexPages.StandardController sc = new ApexPages.StandardController(opptmp[0]);
            Test.Starttest();

                //コンストラクタの呼び出し
                ATFE_ChoosePricebookController cPrbCon = new ATFE_ChoosePricebookController(sc);
            Test.StopTest();
        }
    }
    /**
     * Check ATFE_ChoosePricebookController（システム管理者プロファイル：コンストラクタ呼び出し異常）
     * @param なし -
     * @return なし -
     * @throws なし -
     */
        private static testMethod void Test_ATFE_ChoosePricebookController003() {
        //テストページを用意
        PageReference pageRef = Page.ATFE_ChoosePricebook;
        Test.setCurrentPage(pageRef);
        
        getAccountRecordType();

        //会社ID・代理店ID・価格表ID・顧客IDを取得
        Id tmp_accId = prepareDataJapanAccount();
        Id tmp_disId = prepareDataDistributor(tmp_accId);
        Id tmp_prbId = prepareDataJPprb(tmp_accId,tmp_disId);
        Id tmp_conId = prepareDataJapanContact(tmp_accId);

        //プロファイル・ユーザ情報を設定（システム管理者）
        User u = new User(alias = 'テスト', email='standarduser@testorg.com',
            emailencodingkey='UTF-8', lastname='価格表テストクラスユーザJP',
            languagelocalekey='ja', localesidkey='ja', profileid = pSysad.id,
            timezonesidkey='Asia/Tokyo', username='standarduser_test@alliedtelesistestorg.com');
        insert u;
        ContactShare cs = new ContactShare(UserOrGroupId = u.id, ContactAccessLevel = 'Edit', ContactId = tmp_conId);
        insert cs;
        System.runAs(u) {
            String tmp_oppId = prepareDataOpp(tmp_accId,tmp_conId,tmp_prbId);

            //パラメータの設定
            ApexPages.currentPage().getParameters().put('id', tmp_oppId);
            ApexPages.currentPage().getParameters().put('spmsMode', '1');

            //商談型リストを定義し、作成した商談のIDを取得
            List<Opportunity> opptmp = prepareDataOpp(tmp_oppId);
            ApexPages.StandardController sc = new ApexPages.StandardController(opptmp[0]);
            Test.Starttest();

                //コンストラクタの呼び出し
                ATFE_ChoosePricebookController cPrbCon = new ATFE_ChoosePricebookController(sc);
            Test.StopTest();
        }
    }
    /**
     * Check ATFE_ChoosePricebookController（日本プロファイル：次へ/ウィザード1【宛先会社選択⇒宛先顧客選択】）
     * @param なし -
     * @return なし -
     * @throws なし -
     */
        private static testMethod void Test_ATFE_ChoosePricebookController004() {
        //テストページを用意
        PageReference pageRef = Page.ATFE_ChoosePricebook;
        Test.setCurrentPage(pageRef);
        
        getAccountRecordType();

        //会社ID・代理店ID・価格表ID・顧客IDを取得
        Id tmp_accId = prepareDataJapanAccount();
        Id tmp_disId = prepareDataDistributor(tmp_accId);
        Id tmp_prbId = prepareDataJPprb(tmp_accId,tmp_disId);
        Id tmp_conId = prepareDataJapanContact(tmp_accId);

        //プロファイル・ユーザ情報を設定（日本ユーザ）
        User u = new User(alias = 'テスト', email='standarduser@testorg.com',
            emailencodingkey='UTF-8', lastname='価格表テストクラスユーザJP',
            languagelocalekey='ja', localesidkey='ja', profileid = pJP.id,
            timezonesidkey='Asia/Tokyo', username='standarduser_test@alliedtelesistestorg.com');
        insert u;
        ContactShare cs = new ContactShare(UserOrGroupId = u.id, ContactAccessLevel = 'Edit', ContactId = tmp_conId);
        insert cs;
        System.runAs(u) {
            String tmp_oppId = prepareDataOpp(tmp_accId,tmp_conId,tmp_prbId);

            //パラメータの設定
            ApexPages.currentPage().getParameters().put('id', tmp_oppId);

            //商談型リストを定義し、作成した商談のIDを取得
            List<Opportunity> opptmp = prepareDataOpp(tmp_oppId);
            ApexPages.StandardController sc = new ApexPages.StandardController(opptmp[0]);
            ATFE_ChoosePricebookController cPrbCon = new ATFE_ChoosePricebookController(sc);
            Test.Starttest();

                //テスト対象メソッドの呼び出し：wzdStage=1
                cPrbCon.openNext();
            Test.StopTest();
        }
    }
    /**
     * Check ATFE_ChoosePricebookController（日本プロファイル：次へ/ウィザード3【代理店選択⇒価格表選択】）
     * @param なし -
     * @return なし -
     * @throws なし -
     */
        private static testMethod void Test_ATFE_ChoosePricebookController006() {
        //テストページを用意
        PageReference pageRef = Page.ATFE_ChoosePricebook;
        Test.setCurrentPage(pageRef);
        
        getAccountRecordType();

        //会社ID・代理店ID・価格表ID・顧客IDを取得
        Id tmp_accId = prepareDataJapanAccount();
        Id tmp_disId = prepareDataDistributor(tmp_accId);
        Id tmp_prbId = prepareDataJPprb(tmp_accId,tmp_disId);
        Id tmp_conId = prepareDataJapanContact(tmp_accId);

        //プロファイル・ユーザ情報を設定（日本ユーザ）
        User u = new User(alias = 'テスト', email='standarduser@testorg.com',
            emailencodingkey='UTF-8', lastname='価格表テストクラスユーザJP',
            languagelocalekey='ja', localesidkey='ja', profileid = pJP.id,
            timezonesidkey='Asia/Tokyo', username='standarduser_test@alliedtelesistestorg.com');
        insert u;
        ContactShare cs = new ContactShare(UserOrGroupId = u.id, ContactAccessLevel = 'Edit', ContactId = tmp_conId);
        insert cs;
        System.runAs(u) {
            String tmp_oppId = prepareDataOpp2(tmp_accId,tmp_conId,tmp_prbId);

            //パラメータの設定
            ApexPages.currentPage().getParameters().put('id', tmp_oppId);

            //商談型リストを定義し、作成した商談のIDを取得
            List<Opportunity> opptmp = prepareDataOpp(tmp_oppId);
            ApexPages.StandardController sc = new ApexPages.StandardController(opptmp[0]);
            ATFE_ChoosePricebookController cPrbCon = new ATFE_ChoosePricebookController(sc);
            cPrbCon.openNext();
            cPrbCon.openNext();
            Test.Starttest();

                //テスト対象メソッドの呼び出し：wzdStage=3
                cPrbCon.openNext();
            Test.StopTest();
        }
    }
    /**
     * Check ATFE_ChoosePricebookController（日本プロファイル：完了/ウィザード4【価格表選択⇒商談詳細】）
     * @param なし -
     * @return なし -
     * @throws なし -
     */
        private static testMethod void Test_ATFE_ChoosePricebookController007() {
        //テストページを用意
        PageReference pageRef = Page.ATFE_ChoosePricebook;
        Test.setCurrentPage(pageRef);
        
        getAccountRecordType();

        //会社ID・代理店ID・価格表ID・顧客IDを取得
        Id tmp_accId = prepareDataJapanAccount();
        Id tmp_disId = prepareDataDistributor(tmp_accId);
        Id tmp_prbId = prepareDataJPprb(tmp_accId,tmp_disId);
        Id tmp_conId = prepareDataJapanContact(tmp_accId);

        //プロファイル・ユーザ情報を設定（日本ユーザ）
        User u = new User(alias = 'テスト', email='standarduser@testorg.com',
            emailencodingkey='UTF-8', lastname='価格表テストクラスユーザJP',
            languagelocalekey='ja', localesidkey='ja', profileid = pJP.id,
            timezonesidkey='Asia/Tokyo', username='standarduser_test@alliedtelesistestorg.com');
        insert u;
        ContactShare cs = new ContactShare(UserOrGroupId = u.id, ContactAccessLevel = 'Edit', ContactId = tmp_conId);
        insert cs;
        System.runAs(u) {
            String tmp_oppId = prepareDataOpp(tmp_accId,tmp_conId,tmp_prbId);

            //パラメータの設定
            ApexPages.currentPage().getParameters().put('id', tmp_oppId);

            //商談型リストを定義し、作成した商談のIDを取得
            List<Opportunity> opptmp = prepareDataOpp(tmp_oppId);
            ApexPages.StandardController sc = new ApexPages.StandardController(opptmp[0]);
            ATFE_ChoosePricebookController cPrbCon = new ATFE_ChoosePricebookController(sc);
            cPrbCon.openNext();
            cPrbCon.openNext();
            cPrbCon.openNext();
            Test.Starttest();

                //テスト対象メソッドの呼び出し：wzdStage=4
                cPrbCon.openNext();
            Test.StopTest();
        }
    }
    /**
     * Check ATFE_ChoosePricebookController（日本プロファイル：戻る/ウィザード2【宛先顧客選択⇒宛先会社選択】）
     * @param なし -
     * @return なし -
     * @throws なし -
     */
        private static testMethod void Test_ATFE_ChoosePricebookController008() {
        //テストページを用意
        PageReference pageRef = Page.ATFE_ChoosePricebook;
        Test.setCurrentPage(pageRef);
        
        getAccountRecordType();

        //会社ID・代理店ID・価格表ID・顧客IDを取得
        Id tmp_accId = prepareDataJapanAccount();
        Id tmp_disId = prepareDataDistributor(tmp_accId);
        Id tmp_prbId = prepareDataJPprb(tmp_accId,tmp_disId);
        Id tmp_conId = prepareDataJapanContact(tmp_accId);

        //プロファイル・ユーザ情報を設定（日本ユーザ）
        User u = new User(alias = 'テスト', email='standarduser@testorg.com',
            emailencodingkey='UTF-8', lastname='価格表テストクラスユーザJP',
            languagelocalekey='ja', localesidkey='ja', profileid = pJP.id,
            timezonesidkey='Asia/Tokyo', username='standarduser_test@alliedtelesistestorg.com');
        insert u;
        ContactShare cs = new ContactShare(UserOrGroupId = u.id, ContactAccessLevel = 'Edit', ContactId = tmp_conId);
        insert cs;
        System.runAs(u) {
            String tmp_oppId = prepareDataOpp(tmp_accId,tmp_conId,tmp_prbId);

            //パラメータの設定
            ApexPages.currentPage().getParameters().put('id', tmp_oppId);

            //商談型リストを定義し、作成した商談のIDを取得
            List<Opportunity> opptmp = prepareDataOpp(tmp_oppId);
            ApexPages.StandardController sc = new ApexPages.StandardController(opptmp[0]);
            ATFE_ChoosePricebookController cPrbCon = new ATFE_ChoosePricebookController(sc);
            cPrbCon.openNext();
            Test.Starttest();

                //テスト対象メソッドの呼び出し：wzdStage=2
                cPrbCon.backBfr();
        Test.StopTest();
        }
    }
    /**
     * Check ATFE_ChoosePricebookController（日本プロファイル：次へ/ウィザード2【宛先顧客選択⇒代理店選択】）
     * @param なし -
     * @return なし -
     * @throws なし -
     */
        private static testMethod void Test_ATFE_ChoosePricebookController005() {
        //テストページを用意
        PageReference pageRef = Page.ATFE_ChoosePricebook;
        Test.setCurrentPage(pageRef);
        
        getAccountRecordType();

        //会社ID・代理店ID・価格表ID・顧客IDを取得
        Id tmp_accId = prepareDataJapanAccount();
        Id tmp_disId = prepareDataDistributor(tmp_accId);
        Id tmp_prbId = prepareDataJPprb(tmp_accId,tmp_disId);
        Id tmp_conId = prepareDataJapanContact(tmp_accId);

        //プロファイル・ユーザ情報を設定（日本ユーザ）
        User u = new User(alias = 'テスト', email='standarduser@testorg.com',
            emailencodingkey='UTF-8', lastname='価格表テストクラスユーザJP',
            languagelocalekey='ja', localesidkey='ja', profileid = pJP.id,
            timezonesidkey='Asia/Tokyo', username='standarduser_test@alliedtelesistestorg.com');
        insert u;
        ContactShare cs = new ContactShare(UserOrGroupId = u.id, ContactAccessLevel = 'Edit', ContactId = tmp_conId);
        insert cs;
        System.runAs(u) {
            String tmp_oppId = prepareDataOpp(tmp_accId,tmp_conId,tmp_prbId);

            //パラメータの設定
            ApexPages.currentPage().getParameters().put('id', tmp_oppId);

            //商談型リストを定義し、作成した商談のIDを取得
            List<Opportunity> opptmp = prepareDataOpp(tmp_oppId);
            ApexPages.StandardController sc = new ApexPages.StandardController(opptmp[0]);
            ATFE_ChoosePricebookController cPrbCon = new ATFE_ChoosePricebookController(sc);
            cPrbCon.openNext();
            Test.Starttest();

                //テスト対象メソッドの呼び出し：wzdStage=2
                cPrbCon.openNext();
            Test.StopTest();
        }
    }
    /**
     * Check ATFE_ChoosePricebookController（日本プロファイル：戻る/ウィザード3【代理店選択⇒宛先顧客選択】）
     * @param なし -
     * @return なし -
     * @throws なし -
     */
        private static testMethod void Test_ATFE_ChoosePricebookController009() {
        //テストページを用意
        PageReference pageRef = Page.ATFE_ChoosePricebook;
        Test.setCurrentPage(pageRef);
        
        getAccountRecordType();

        //会社ID・代理店ID・価格表ID・顧客IDを取得
        Id tmp_accId = prepareDataJapanAccount();
        Id tmp_disId = prepareDataDistributor(tmp_accId);
        Id tmp_prbId = prepareDataJPprb(tmp_accId,tmp_disId);
        Id tmp_conId = prepareDataJapanContact(tmp_accId);

        //プロファイル・ユーザ情報を設定（日本ユーザ）
        User u = new User(alias = 'テスト', email='standarduser@testorg.com',
            emailencodingkey='UTF-8', lastname='価格表テストクラスユーザJP',
            languagelocalekey='ja', localesidkey='ja', profileid = pJP.id,
            timezonesidkey='Asia/Tokyo', username='standarduser_test@alliedtelesistestorg.com');
        insert u;
        ContactShare cs = new ContactShare(UserOrGroupId = u.id, ContactAccessLevel = 'Edit', ContactId = tmp_conId);
        insert cs;
        System.runAs(u) {
            String tmp_oppId = prepareDataOpp(tmp_accId,tmp_conId,tmp_prbId);

            //パラメータの設定
            ApexPages.currentPage().getParameters().put('id', tmp_oppId);

            //商談型リストを定義し、作成した商談のIDを取得
            List<Opportunity> opptmp = prepareDataOpp(tmp_oppId);
            ApexPages.StandardController sc = new ApexPages.StandardController(opptmp[0]);
            ATFE_ChoosePricebookController cPrbCon = new ATFE_ChoosePricebookController(sc);
            cPrbCon.openNext();
            cPrbCon.openNext();
            Test.Starttest();

                //テスト対象メソッドの呼び出し：wzdStage=3
                cPrbCon.backBfr();
            Test.StopTest();
        }
    }
    /**
     * Check ATFE_ChoosePricebookController（日本プロファイル：戻る/ウィザード4【価格表選択⇒代理店選択】）
     * @param なし -
     * @return なし -
     * @throws なし -
     */
        private static testMethod void Test_ATFE_ChoosePricebookController010() {
        //テストページを用意
        PageReference pageRef = Page.ATFE_ChoosePricebook;
        Test.setCurrentPage(pageRef);
        
        getAccountRecordType();

        //会社ID・代理店ID・価格表ID・顧客IDを取得
        Id tmp_accId = prepareDataJapanAccount();
        Id tmp_disId = prepareDataDistributor(tmp_accId);
        Id tmp_prbId = prepareDataJPprb(tmp_accId,tmp_disId);
        Id tmp_conId = prepareDataJapanContact(tmp_accId);

        //プロファイル・ユーザ情報を設定（日本ユーザ）
        User u = new User(alias = 'テスト', email='standarduser@testorg.com',
            emailencodingkey='UTF-8', lastname='価格表テストクラスユーザJP',
            languagelocalekey='ja', localesidkey='ja', profileid = pJP.id,
            timezonesidkey='Asia/Tokyo', username='standarduser_test@alliedtelesistestorg.com');
        insert u;
        ContactShare cs = new ContactShare(UserOrGroupId = u.id, ContactAccessLevel = 'Edit', ContactId = tmp_conId);
        insert cs;
        System.runAs(u) {
            String tmp_oppId = prepareDataOpp(tmp_accId,tmp_conId,tmp_prbId);

            //パラメータの設定
            ApexPages.currentPage().getParameters().put('id', tmp_oppId);

            //商談型リストを定義し、作成した商談のIDを取得
            List<Opportunity> opptmp = prepareDataOpp(tmp_oppId);
            ApexPages.StandardController sc = new ApexPages.StandardController(opptmp[0]);
            ATFE_ChoosePricebookController cPrbCon = new ATFE_ChoosePricebookController(sc);
            cPrbCon.openNext();
            cPrbCon.openNext();
            cPrbCon.openNext();
            Test.Starttest();

                //テスト対象メソッドの呼び出し：wzdStage=4
                cPrbCon.backBfr();
            Test.StopTest();
        }
    }
    /**
     * Check ATFE_ChoosePricebookController（日本プロファイル：見積作成(代理店コードと説明項目が同じ商談)）
     * @param なし -
     * @return なし -
     * @throws なし -
     */
        private static testMethod void Test_ATFE_ChoosePricebookController012() {
        //テストページを用意
        PageReference pageRef = Page.ATFE_ChoosePricebook;
        Test.setCurrentPage(pageRef);
        
        getAccountRecordType();

        //会社ID・代理店ID・価格表ID・顧客IDを取得
        Id tmp_accId = prepareDataJapanAccount();
        Id tmp_disId = prepareDataDistributor(tmp_accId);
        Id tmp_prbId = prepareDataJPprb(tmp_accId,tmp_disId);
        Id tmp_conId = prepareDataJapanContact(tmp_accId);

        //プロファイル・ユーザ情報を設定（日本ユーザ）
        User u = new User(alias = 'テスト', email='standarduser@testorg.com',
            emailencodingkey='UTF-8', lastname='価格表テストクラスユーザJP',
            languagelocalekey='ja', localesidkey='ja', profileid = pJP.id,
            timezonesidkey='Asia/Tokyo', username='standarduser_test@alliedtelesistestorg.com');
        insert u;
        ContactShare cs = new ContactShare(UserOrGroupId = u.id, ContactAccessLevel = 'Edit', ContactId = tmp_conId);
        insert cs;
        System.runAs(u) {
            String tmp_oppId = prepareDataOpp(tmp_accId,tmp_conId,tmp_prbId);

            //パラメータの設定
            ApexPages.currentPage().getParameters().put('id', tmp_oppId);

            //商談型リストを定義し、作成した商談のIDを取得
            List<Opportunity> opptmp = prepareDataOpp(tmp_oppId);
            ApexPages.StandardController sc = new ApexPages.StandardController(opptmp[0]);
            ATFE_ChoosePricebookController cPrbCon = new ATFE_ChoosePricebookController(sc);
            cPrbCon.openNext();
            cPrbCon.openNext();
            cPrbCon.openNext();
            Test.Starttest();

                //テスト対象メソッドの呼び出し
                cPrbCon.endPrbStartQuo();
            Test.StopTest();
        }
    }
    /**
     * Check ATFE_ChoosePricebookController（外国プロファイル：キャンセルボタン名変更・仕切表ボタン名変更）
     * @param なし -
     * @return なし -
     * @throws なし -
     */
//        private static testMethod void Test_ATFE_ChoosePricebookController013() {
//        //テストページを用意
//        PageReference pageRef = Page.ATFE_ChoosePricebook;
//        Test.setCurrentPage(pageRef);
//        
//        getAccountRecordType();
//
//        //会社ID・代理店ID・価格表ID・顧客IDを取得
//        Id tmp_accId = prepareDataEMEAAccount();
//        //Id tmp_disId = prepareDataDistributor(tmp_accId);
//        Id tmp_prbId = prepareDataEMEAprb(tmp_accId);
//        Id tmp_conId = prepareDataJapanContact(tmp_accId);
//
//        //プロファイル・ユーザ情報を設定（外国ユーザ）
//        User u = new User(alias = 'テスト', email='standarduser@testorg.com',
//            emailencodingkey='UTF-8', lastname='価格表テストクラスユーザJP',
//            languagelocalekey='ja', localesidkey='ja', profileid = pEMEA.id,
//            timezonesidkey='Asia/Tokyo', username='standarduser_test@alliedtelesistestorg.com');
//
//        System.runAs(u) {
//            String tmp_oppId = prepareDataOpp(tmp_accId,tmp_conId,tmp_prbId);
//
//            //パラメータの設定
//            ApexPages.currentPage().getParameters().put('id', tmp_oppId);
//
//            //商談型リストを定義し、作成した商談のIDを取得
//            List<Opportunity> opptmp = prepareDataOpp(tmp_oppId);
//            ApexPages.StandardController sc = new ApexPages.StandardController(opptmp[0]);
//            ATFE_ChoosePricebookController cPrbCon = new ATFE_ChoosePricebookController(sc);
//            Test.Starttest();
//
//                //テスト対象メソッドの呼び出し
//                cPrbCon.getCancelName();
//                cPrbCon.getPrbBtnName();
//            Test.StopTest();
//        }
//   }
    /**
     * Check ATFE_ChoosePricebookController（日本プロファイル：キャンセルボタン名変更・仕切表ボタン名変更（spmsMode＝0））
     * @param なし -
     * @return なし -
     * @throws なし -
     */
        private static testMethod void Test_ATFE_ChoosePricebookController014() {
        //テストページを用意
        PageReference pageRef = Page.ATFE_ChoosePricebook;
        Test.setCurrentPage(pageRef);
        
        getAccountRecordType();

        //会社ID・代理店ID・価格表ID・顧客IDを取得
        Id tmp_accId = prepareDataJapanAccount();
        Id tmp_disId = prepareDataDistributor(tmp_accId);
        Id tmp_prbId = prepareDataJPprb(tmp_accId,tmp_disId);
        Id tmp_conId = prepareDataJapanContact(tmp_accId);

        //プロファイル・ユーザ情報を設定（日本ユーザ）
        User u = new User(alias = 'テスト', email='standarduser@testorg.com',
            emailencodingkey='UTF-8', lastname='価格表テストクラスユーザJP',
            languagelocalekey='ja', localesidkey='ja', profileid = pJP.id,
            timezonesidkey='Asia/Tokyo', username='standarduser_test@alliedtelesistestorg.com');
        insert u;
        ContactShare cs = new ContactShare(UserOrGroupId = u.id, ContactAccessLevel = 'Edit', ContactId = tmp_conId);
        insert cs;
        System.runAs(u) {
            String tmp_oppId = prepareDataOpp(tmp_accId,tmp_conId,tmp_prbId);

            //パラメータの設定（spmsModeの設定なし=初期値0）
            ApexPages.currentPage().getParameters().put('id', tmp_oppId);

            //商談型リストを定義し、作成した商談のIDを取得
            List<Opportunity> opptmp = prepareDataOpp(tmp_oppId);
            ApexPages.StandardController sc = new ApexPages.StandardController(opptmp[0]);
            ATFE_ChoosePricebookController cPrbCon = new ATFE_ChoosePricebookController(sc);
            Test.Starttest();

                //テスト対象メソッドの呼び出し
                cPrbCon.getCancelName();
                cPrbCon.getPrbBtnName();
            Test.StopTest();
        }
    }
    /**
     * Check ATFE_ChoosePricebookController（日本プロファイル：仕切表ボタン名変更（spmsMode＝1））
     * @param なし -
     * @return なし -
     * @throws なし -
     */
        private static testMethod void Test_ATFE_ChoosePricebookController015() {
        //テストページを用意
        PageReference pageRef = Page.ATFE_ChoosePricebook;
        Test.setCurrentPage(pageRef);
        
        getAccountRecordType();

        //会社ID・代理店ID・価格表ID・顧客IDを取得
        Id tmp_accId = prepareDataJapanAccount();
        Id tmp_disId = prepareDataDistributor(tmp_accId);
        Id tmp_prbId = prepareDataJPprb(tmp_accId,tmp_disId);
        Id tmp_conId = prepareDataJapanContact(tmp_accId);

        //プロファイル・ユーザ情報を設定（日本ユーザ）
        User u = new User(alias = 'テスト', email='standarduser@testorg.com',
            emailencodingkey='UTF-8', lastname='価格表テストクラスユーザJP',
            languagelocalekey='ja', localesidkey='ja', profileid = pJP.id,
            timezonesidkey='Asia/Tokyo', username='standarduser_test@alliedtelesistestorg.com');
        insert u;
        ContactShare cs = new ContactShare(UserOrGroupId = u.id, ContactAccessLevel = 'Edit', ContactId = tmp_conId);
        insert cs;
        System.runAs(u) {
            String tmp_oppId = prepareDataOpp(tmp_accId,tmp_conId,tmp_prbId);

            //パラメータの設定
            ApexPages.currentPage().getParameters().put('id', tmp_oppId);
            ApexPages.currentPage().getParameters().put('spmsMode', '1');

            //商談型リストを定義し、作成した商談のIDを取得
            List<Opportunity> opptmp = prepareDataOpp(tmp_oppId);
            ApexPages.StandardController sc = new ApexPages.StandardController(opptmp[0]);
            ATFE_ChoosePricebookController cPrbCon = new ATFE_ChoosePricebookController(sc);
            Test.Starttest();

                //テスト対象メソッドの呼び出し
                cPrbCon.getPrbBtnName();
            Test.StopTest();
        }
    }
    /**
     * Check ATFE_ChoosePricebookController（日本プロファイル：メッセージ・値取得）
     * @param なし -
     * @return なし -
     * @throws なし -
     */
        private static testMethod void Test_ATFE_ChoosePricebookController016() {
        //テストページを用意
        PageReference pageRef = Page.ATFE_ChoosePricebook;
        Test.setCurrentPage(pageRef);
        
        getAccountRecordType();

        //会社ID・代理店ID・価格表ID・顧客IDを取得
        Id tmp_accId = prepareDataJapanAccount();
        Id tmp_disId = prepareDataDistributor(tmp_accId);
        Id tmp_prbId = prepareDataJPprb(tmp_accId,tmp_disId);
        Id tmp_conId = prepareDataJapanContact(tmp_accId);

        //プロファイル・ユーザ情報を設定（日本ユーザ）
        User u = new User(alias = 'テスト', email='standarduser@testorg.com',
            emailencodingkey='UTF-8', lastname='価格表テストクラスユーザJP',
            languagelocalekey='ja', localesidkey='ja', profileid = pJP.id,
            timezonesidkey='Asia/Tokyo', username='standarduser_test@alliedtelesistestorg.com');
        insert u;
        ContactShare cs = new ContactShare(UserOrGroupId = u.id, ContactAccessLevel = 'Edit', ContactId = tmp_conId);
        insert cs;
        System.runAs(u) {
            String tmp_oppId = prepareDataOpp(tmp_accId,tmp_conId,tmp_prbId);

            //パラメータの設定
            ApexPages.currentPage().getParameters().put('id', tmp_oppId);

            //商談型リストを定義し、作成した商談のIDを取得
            List<Opportunity> opptmp = prepareDataOpp(tmp_oppId);
            ApexPages.StandardController sc = new ApexPages.StandardController(opptmp[0]);
            ATFE_ChoosePricebookController cPrbCon = new ATFE_ChoosePricebookController(sc);
            Test.Starttest();

                //テスト対象メソッドの呼び出し
                cPrbCon.getShow_jp_description();
                cPrbCon.getShow_other_description();
                cPrbCon.getCreateListVal();
                cPrbCon.getSelectValue();
                cPrbCon.setSelectValue('test');
                cPrbCon.getHeaderVal();
                cPrbCon.getSmallHeader();
            Test.StopTest();
        }
    }
    /**
     * Check ATFE_ChoosePricebookController（日本プロファイル：ボタン非活性情報取得）
     * @param なし -
     * @return なし -
     * @throws なし -
     */
        private static testMethod void Test_ATFE_ChoosePricebookController017() {
        //テストページを用意
        PageReference pageRef = Page.ATFE_ChoosePricebook;

        getAccountRecordType();
        
        Test.setCurrentPage(pageRef);
        //会社ID・代理店ID・価格表ID・顧客IDを取得
        Id tmp_accId = prepareDataJapanAccount();
        Id tmp_disId = prepareDataDistributor(tmp_accId);
        Id tmp_prbId = prepareDataJPprb(tmp_accId,tmp_disId);
        Id tmp_conId = prepareDataJapanContact(tmp_accId);

        //プロファイル・ユーザ情報を設定（日本ユーザ）
        User u = new User(alias = 'テスト', email='standarduser@testorg.com',
            emailencodingkey='UTF-8', lastname='価格表テストクラスユーザJP',
            languagelocalekey='ja', localesidkey='ja', profileid = pJP.id,
            timezonesidkey='Asia/Tokyo', username='standarduser_test@alliedtelesistestorg.com');
        insert u;
        ContactShare cs = new ContactShare(UserOrGroupId = u.id, ContactAccessLevel = 'Edit', ContactId = tmp_conId);
        insert cs;
        System.runAs(u) {
            String tmp_oppId = prepareDataOpp(tmp_accId,tmp_conId,tmp_prbId);

            //パラメータの設定
            ApexPages.currentPage().getParameters().put('id', tmp_oppId);

            //商談型リストを定義し、作成した商談のIDを取得
            List<Opportunity> opptmp = prepareDataOpp(tmp_oppId);
            ApexPages.StandardController sc = new ApexPages.StandardController(opptmp[0]);
            ATFE_ChoosePricebookController cPrbCon = new ATFE_ChoosePricebookController(sc);
            Test.Starttest();

                //テスト対象メソッドの呼び出し
                cPrbCon.getNextBtn();
                cPrbCon.getBackBfrBtn();
                cPrbCon.getEndPrbStartQuo();
                cPrbCon.getNextBtnRender();
                cPrbCon.getbackBtnRender();
                cPrbCon.getEndPrbStartQuoBtnRender();
            Test.StopTest();
        }
    }
    /**
     * Check ATFE_ChoosePricebookController（日本プロファイル：PricebookManagerJPを呼ぶ）
     * @param なし -
     * @return なし -
     * @throws なし -
     */
        private static testMethod void Test_ATFE_ChoosePricebookController018() {

            Test.Starttest();

                //テスト対象メソッドの呼び出し
                ATFE_PricebookManagerJP pjJP = new ATFE_PricebookManagerJP();
                pjJP.getRegion();
                pjJP.getPriceBooks();

            Test.StopTest();
    }
    


    /**
     * 海外プロファイル
     */
        private static testMethod void Test_ATFE_ChoosePricebookController101() {
        //テストページを用意
        PageReference pageRef = Page.ATFE_ChoosePricebook;
        Test.setCurrentPage(pageRef);
        
        getAccountRecordType();

        //会社ID・代理店ID・価格表ID・顧客IDを取得
        Id tmp_accId = prepareDataJapanAccount();
        Id tmp_disId = prepareDataDistributor(tmp_accId);
        Id tmp_prbId = prepareDataJPprb(tmp_accId,tmp_disId);
        Id tmp_conId = prepareDataJapanContact(tmp_accId);

        User u = new User(alias = 'NATest', email='standarduser@testorg.com',
            emailencodingkey='UTF-8', lastname='NATest',
            languagelocalekey='en_US', localesidkey='en_US', profileid = pNA2.Id,
            timezonesidkey='America/Los_Angeles', username='standarduser_test@alliedtelesistestorg.com');
        insert u;
        ContactShare cs = new ContactShare(UserOrGroupId = u.id, ContactAccessLevel = 'Edit', ContactId = tmp_conId);
        insert cs;
        System.runAs(u) {
            String tmp_oppId = prepareDataOpp(tmp_accId,tmp_conId,tmp_prbId);

            //パラメータの設定（spmsModeの設定なし=初期値0）
            ApexPages.currentPage().getParameters().put('id', tmp_oppId);

            //商談型リストを定義し、作成した商談のIDを取得
            List<Opportunity> opptmp = prepareDataOpp(tmp_oppId);
            ApexPages.StandardController sc = new ApexPages.StandardController(opptmp[0]);
            ATFE_ChoosePricebookController cPrbCon = new ATFE_ChoosePricebookController(sc);
            Test.Starttest();

                //テスト対象メソッドの呼び出し
                cPrbCon.getCancelName();
                cPrbCon.getPrbBtnName();
            Test.StopTest();
        }
    }
    /**
     * 商品必須化改修
     */
        private static testMethod void Test_ATFE_ChoosePricebookController102() {
        //テストページを用意
        PageReference pageRef = Page.ATFE_ChoosePricebook;
        Test.setCurrentPage(pageRef);
        
        getAccountRecordType();

        //会社ID・代理店ID・価格表ID・顧客IDを取得
        Id tmp_accId = prepareDataJapanAccount();
        Id tmp_disId = prepareDataDistributor(tmp_accId);
        Id tmp_prbId = prepareDataJPprb(tmp_accId,tmp_disId);
        Id tmp_conId = prepareDataJapanContact(tmp_accId);

        //プロファイル・ユーザ情報を設定（日本ユーザ）
        User u = new User(alias = 'テスト', email='standarduser@testorg.com',
            emailencodingkey='UTF-8', lastname='価格表テストクラスユーザJP',
            languagelocalekey='ja', localesidkey='ja', profileid = pJP.id,
            timezonesidkey='Asia/Tokyo', username='standarduser_test@alliedtelesistestorg.com');
        insert u;
        ContactShare cs = new ContactShare(UserOrGroupId = u.id, ContactAccessLevel = 'Edit', ContactId = tmp_conId);
        insert cs;
        System.runAs(u) {

        //価格表と商品作成
        PriceBookEntry pbe = JP_TestUtil.CreateProduct();

        // 商談作成
        //20221114 Alliedtelesis-462 Mod start
        Opportunity opp = JP_TestUtil.Create_Opportunity();
        opp.Name = 'テスト商談@';
        opp.CloseDate = system.today().adddays(2);//20240912 update semba 
        opp.JP_DirectRank__c = 'D';
        opp.stageName='Engagement/Value Proposition';
        opp.Required_Delivery_Date__c=system.today().adddays(3);
        opp.AccountId = tmp_accId;
        opp.JP_Enduser__c = tmp_accId ;
        opp.JP_RelatedContact__c = tmp_conId;
        opp.JP_ContactEnduser__c = tmp_conId;
        opp.pricebook2id= pbe.Pricebook2Id;
        opp.JP_SendToAccount__c= tmp_accid;
        opp.JP_SendToContact__c= tmp_conid;
        opp.JP_NoSendToContactFlag__c= FALSE;
        opp.JP_PlVersion__c= '';
        opp.JP_TargetDistributorCode__c= '1020aaaaa';
        update opp;
        //20221114 Alliedtelesis-462 Mod end

        // 商談商品作成
        JP_TestUtil.CreateOpportunityLineItem(opp.Id, pbe.Id);

        //商談のフェーズとランク更新
        opp.JP_DirectRank__c = 'A';
        opp.stageName='Booking(Forecast) - APAC';
        opp.JP_DirectTouchDegree__c = 'test';
        update opp;

        //パラメータの設定
        ApexPages.currentPage().getParameters().put('id', opp.id);

        //商談型リストを定義し、作成した商談のIDを取得
        List<Opportunity> opptmp = prepareDataOpp(opp.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(opptmp[0]);

        Test.Starttest();
        ATFE_ChoosePricebookController cPrbCon = new ATFE_ChoosePricebookController(sc);
        cPrbCon.openNext();
        cPrbCon.openNext();
        cPrbCon.openNext();
        cPrbCon.getSelectValue();
        cPrbCon.setSelectValue(tmp_prbId);
        cPrbCon.endPrbStartQuo();
        Test.StopTest();

        }
    }

}