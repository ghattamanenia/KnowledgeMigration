public class JP_TestUtil {

    /* カスタム設定：見積書出力テンプレート作成
    *  @void
    */
    public static void Create_JP_QuotationTemplate(){
        List<JP_QuotationTemplate__c> qtList = new List<JP_QuotationTemplate__c>();
        
        JP_QuotationTemplate__c qt1 = new JP_QuotationTemplate__c();
        qt1.JP_No__c = '1';
        qt1.JP_TemplateName__c = 'B_1Template';
        qt1.JP_Name__c = '値引有(OPEN価格表示有)';
        qt1.JP_Description__c = '値引有、オープン価格製品は参考価格を標準価格欄に表示';
        qt1.Name = 'Temp1';
        qt1.JP_Direction__c = '横';
        qtList.add(qt1);

        JP_QuotationTemplate__c qt2 = new JP_QuotationTemplate__c();
        qt2.JP_No__c = '2';
        qt2.JP_TemplateName__c = 'Temp1';
        qt2.JP_Name__c = '値引有(OPEN価格表示無)';
        qt2.JP_Description__c = '値引有、オープン価格製品は「OPEN」と標準価格欄に表示';
        qt2.Name = 'Temp2';
        qt2.JP_Direction__c = '横';
        qtList.add(qt2);

        insert qtList;
    }

    /* 承認プロセス管理マスタ作成
    * @param Integer quantity   ：登録するレコード数
    * @return void
    */
    public static JP_ApprovalProcessMaster__c Create_JP_ApprovalProcessMaster(Integer apNo){

        JP_ApprovalProcessMaster__c ap = new JP_ApprovalProcessMaster__c();
        ap.JP_ApprovalProcessNo__c = apNo;
        insert ap;

        return ap;
    }

    /* 承認プロセス判定作成
    * @param Integer quantity   ：登録するレコード数
    * @return void
    */
    public static List<JP_DecideApprovalProcess__c> Create_JP_ApprovalProcess(Integer quantity){
        List<JP_DecideApprovalProcess__c> apList = new List<JP_DecideApprovalProcess__c>();
        JP_ApprovalProcessMaster__c apm = Create_JP_ApprovalProcessMaster(1);

        for(Integer i = 1; i <= quantity; i++){
            JP_DecideApprovalProcess__c ap = new JP_DecideApprovalProcess__c();
            ap.JP_ApprovalProcessMaster__c = apm.Id;
            ap.JP_ChkTotalAmountCD__c = 'A' + String.valueOf(i);
            ap.JP_ChkWholeSaleCD__c = 'B' + String.valueOf(i);
            ap.JP_ChkLimitDiscountCD__c = 'C' + String.valueOf(i);
            ap.JP_ChkRegisteredProductCD__c = 'D' + String.valueOf(i);
            ap.JP_ChkQuotationExpiryDateCD__c = 'E' + String.valueOf(i);
            ap.JP_ChkPreReleaseCD__c = 'F' + String.valueOf(i);
            ap.JP_ChkkProductResponsibleCD__c = 'G' + String.valueOf(i);
            apList.add(ap);
        }

        insert apList;
        return apList;
    }

    /* 見積基本作成
    * @param Integer quantity   ：登録するレコード数
    * @return void
    */
    public static List<JP_QuotationHeader__c> Create_JP_QuotationHeader(Integer quantity){
        List<JP_QuotationHeader__c> qhList = new List<JP_QuotationHeader__c>();

        for(Integer i = 1; i <= quantity; i++){
            JP_QuotationHeader__c qh = new JP_QuotationHeader__c();
            qh.JP_QuotationStatus__c = JP_Const.QUOTATION_STATUS_UNAPPROVE;
            qh.JP_PreSave__c = false;
            qh.JP_TriggerSkipFLG__c = false;
            qh.JP_TotalAmount__c = 10000;
            qhList.add(qh);
        }

        return qhList;
    }
    
    /*
    * @param String qhId        ：【見積基本】.[Id]
    * @param Integer quantity   ：登録するレコード数
    */
    public static List<JP_CustomerInfo2__c> Create_JP_CustomerInfo2(String qhId, Integer quantity){
        List<JP_CustomerInfo2__c> ci2List = new List<JP_CustomerInfo2__c>();
        
        for(Integer i = 1; i <= quantity; i++){
            JP_CustomerInfo2__c ci2 = new JP_CustomerInfo2__c();
            ci2.JP_QuotationHeader__c = qhId;
            ci2.Name = 'TEST Name';
            ci2.JP_Address1__c = 'address1';
            ci2.JP_Address2__c = 'address2';
            ci2.JP_Building__c = 'building';
            ci2.JP_ChangeAddresses__c = true;
            ci2.JP_Department1__c = 'department1';
            ci2.JP_Department2__c = 'department2';
            ci2.JP_FaxNo__c = 'fax number';
            ci2.JP_PostalCode__c = 'postalcode';
            ci2.JP_TelNo__c = 'tel number';
            ci2.JP_Title__c = 'JP_Sama';
            ci2List.add(ci2);
        }
        
        return ci2List;
    }

    /* 帳票出力用見積基本作成(For Trigger)
    * @param days
    * @return void
    */
    public static JP_QuotationHeader__c Create_JP_QuotationHeaderForTrigger(Integer days){
        JP_QuotationHeader__c qh = new JP_QuotationHeader__c();
        qh.JP_QuotationStatus__c = JP_Const.QUOTATION_STATUS_UNAPPROVE;
        qh.JP_PreSave__c = false;
        qh.JP_TriggerSkipFLG__c = true;
        qh.JP_TotalAmount__c = 10000;
        qh.JP_QuotationStatus__c = '承認済';
        qh.JP_ApprovedDateTime__c = System.now().addDays(days);
        return qh;
    }

    /* 帳票出力用見積基本作成(PreSave)
    * @param days
    * @return void
    */
    public static JP_QuotationHeader__c Create_PreJP_QuotationHeader(Integer days){
        JP_QuotationHeader__c qh = new JP_QuotationHeader__c();
        qh.JP_QuotationStatus__c = JP_Const.QUOTATION_STATUS_UNAPPROVE;
        qh.JP_PreSave__c = true;
        qh.JP_TriggerSkipFLG__c = true;
        qh.JP_TotalAmount__c = 10000;
        qh.JP_QuotationStatus__c = '未承認';
        return qh;
    }

    /* 見積明細作成
    * @param String qhId        ：【見積基本】.[Id]
    * @param Integer quantity   ：登録するレコード数
    * @return void
    */
    public static List<JP_QuotationDetail__c> Create_JP_QuotationDetail(String qhId, Integer quantity){
        List<JP_QuotationDetail__c> qdList = new List<JP_QuotationDetail__c>();

        for(Integer i = 1; i <= quantity; i++){
            JP_QuotationDetail__c qd = new JP_QuotationDetail__c();
            qd.JP_QuotationHeader__c = qhId;
            qd.JP_AppGroupID__c = 'G1';
            qdList.add(qd);
        }

        return qdList;
    }

    /* 代理店仕切価格表作成
    * @param Integer quantity   ：登録するレコード数
    * @return void
    */
    public static List<JP_DistributorPrice__c> Create_JP_DistributorPrice(Integer quantity) {
        List<JP_DistributorPrice__c> dpList = new List<JP_DistributorPrice__c>();

        for(Integer i = 1; i <= quantity; i++){
            JP_DistributorPrice__c dp = new JP_DistributorPrice__c();
            dp.JP_WholeSaleKey__c = String.valueOf(1+i);
            dpList.add(dp);
        }

        return dpList;
    }

    /* 代理店仕切価格表作成(For Trigger)
    * @param Integer quantity   ：登録するレコード数
    * @return void
    */
    public static List<JP_DistributorPrice__c> Create_JP_DistributorPriceForTrigger(Integer quantity) {
        List<JP_DistributorPrice__c> dpList = new List<JP_DistributorPrice__c>();

        for(Integer i = 1; i <= quantity; i++){
            JP_DistributorPrice__c dp = new JP_DistributorPrice__c();
            dp.JP_WholeSaleKey__c = String.valueOf(1+i);
            dp.Name = String.valueOf(i);
            dp.JP_PriceYearMonth__c = 'JP ' + String.valueOf(system.today().year()) + '/0' + String.valueOf(i);
            dp.JP_Price_List_Type__c = 'TE';
            dpList.add(dp);
        }   
        return dpList;
    }

    //部署マスタ
    public static void Create_JP_Department(){
        //部署マスタ作成 5件
        List<JP_Department__c> depList = new List<JP_Department__c>();
        depList.add(new JP_Department__c(Name='TEST_DEP1',JP_DeptCode__c='00001',JP_Company__c='テスト株式会社1',JP_Building__c='テストビル1',JP_Postcode__c='999-9999',JP_Address1__c='テスト都1'
                                        ,JP_Address2__c = 'テスト区1',JP_Address3__c = 'テスト番地1',JP_TelNo__c = '9999999',JP_FaxNo__c = '9999999'));
        depList.add(new JP_Department__c(Name='TEST_DEP2',JP_DeptCode__c='00002',JP_Company__c='テスト株式会社2',JP_Building__c='テストビル2',JP_Postcode__c='999-9999',JP_Address1__c='テスト都2'
                                        ,JP_Address2__c = 'テスト区2',JP_Address3__c = 'テスト番地2',JP_TelNo__c = '9999999',JP_FaxNo__c = '9999999'));
        depList.add(new JP_Department__c(Name='TEST_DEP3',JP_DeptCode__c='00003',JP_Company__c='テスト株式会社3',JP_Building__c='テストビル3',JP_Postcode__c='999-9999',JP_Address1__c='テスト都3'
                                        ,JP_Address2__c = 'テスト区3',JP_Address3__c = 'テスト番地3',JP_TelNo__c = '9999999',JP_FaxNo__c = '9999999'));
        depList.add(new JP_Department__c(Name='TEST_DEP4',JP_DeptCode__c='00004',JP_Company__c='テスト株式会社4',JP_Building__c='テストビル4',JP_Postcode__c='999-9999',JP_Address1__c='テスト都4'
                                        ,JP_Address2__c = 'テスト区4',JP_Address3__c = 'テスト番地4',JP_TelNo__c = '9999999',JP_FaxNo__c = '9999999'));
        depList.add(new JP_Department__c(Name='TEST_DEP5',JP_DeptCode__c='00005',JP_Company__c='テスト株式会社5',JP_Building__c='テストビル5',JP_Postcode__c='999-9999',JP_Address1__c='テスト都5'
                                        ,JP_Address2__c = 'テスト区5',JP_Address3__c = 'テスト番地5',JP_TelNo__c = '9999999',JP_FaxNo__c = '9999999'));
        insert depList;
    }

    //見積条件作成 9件
    public static void Create_JP_QuotationCondition(){
        List<JP_QuotationCondition__c> conditionList = new List<JP_QuotationCondition__c>();
        conditionList.add(new JP_QuotationCondition__c(Name='テスト条件11',JP_QuotationConditionCode__c='2',JP_QuotationCondition__c='テスト条件11',JP_DisplayOrder__c=10));
        conditionList.add(new JP_QuotationCondition__c(Name='テスト条件22',JP_QuotationConditionCode__c='3',JP_QuotationCondition__c='テスト条件22',JP_DisplayOrder__c=20));
        conditionList.add(new JP_QuotationCondition__c(Name='テスト条件1',JP_QuotationConditionCode__c='00010',JP_QuotationCondition__c='テスト条件1',JP_DisplayOrder__c=1));
        conditionList.add(new JP_QuotationCondition__c(Name='テスト条件2',JP_QuotationConditionCode__c='00020',JP_QuotationCondition__c='テスト条件2',JP_DisplayOrder__c=2));
        conditionList.add(new JP_QuotationCondition__c(Name='テスト条件3',JP_QuotationConditionCode__c='00030',JP_QuotationCondition__c='テスト条件3',JP_DisplayOrder__c=3));
        conditionList.add(new JP_QuotationCondition__c(Name='テスト条件4',JP_QuotationConditionCode__c='00040',JP_QuotationCondition__c='テスト条件4',JP_DisplayOrder__c=4));
        conditionList.add(new JP_QuotationCondition__c(Name='テスト条件5',JP_QuotationConditionCode__c='00050',JP_QuotationCondition__c='テスト条件5',JP_DisplayOrder__c=5));
        conditionList.add(new JP_QuotationCondition__c(Name='テスト条件6',JP_QuotationConditionCode__c='10020',JP_QuotationCondition__c='テスト条件6',JP_DisplayOrder__c=6));
        conditionList.add(new JP_QuotationCondition__c(Name='テスト条件7',JP_QuotationConditionCode__c='10030',JP_QuotationCondition__c='テスト条件7',JP_DisplayOrder__c=7));
        insert conditionList;
    }

    //代理店
    public static List<JP_QuotationDistributor__c> Create_JP_QuotationDistributor(){
        //代理店作成
        List<JP_QuotationDistributor__c> qdList = new List<JP_QuotationDistributor__c>();
        qdList.add(new JP_QuotationDistributor__c(Name='テスト代理店1',JP_DistributorCode__c='000010',JP_PaymentCondition__c='テスト支払条件1',JP_MainDistributorName__c='OYA代理店1',JP_MainDistributorCode__c='OYA00010'
                                                ,JP_SubjectAutoSetFlag__c=true,JP_DeafultQuotationCondition__c='00010',JP_SpotDistributor__c=false,JP_Price_List_Type__c='11'
                                                ,JP_QuotationCreatableFlag__c=true,JP_DistributorActiveFlag__c=true,JP_EffectiveFlagForMainDistributor__c=true));
        qdList.add(new JP_QuotationDistributor__c(Name='テスト代理店2',JP_DistributorCode__c='000020',JP_PaymentCondition__c='テスト支払条件2',JP_MainDistributorName__c='OYA代理店2',JP_MainDistributorCode__c='OYA00020'
                                                ,JP_SubjectAutoSetFlag__c=true,JP_DeafultQuotationCondition__c='00020',JP_SpotDistributor__c=false,JP_Price_List_Type__c='11'
                                                ,JP_QuotationCreatableFlag__c=true,JP_DistributorActiveFlag__c=true,JP_EffectiveFlagForMainDistributor__c=true));
        qdList.add(new JP_QuotationDistributor__c(Name='テスト代理店3',JP_DistributorCode__c='000030',JP_PaymentCondition__c='テスト支払条件3',JP_MainDistributorName__c='OYA代理店3',JP_MainDistributorCode__c='OYA00030'
                                                ,JP_SubjectAutoSetFlag__c=true,JP_DeafultQuotationCondition__c='00030',JP_SpotDistributor__c=false,JP_Price_List_Type__c='11'
                                                ,JP_QuotationCreatableFlag__c=true,JP_DistributorActiveFlag__c=true,JP_EffectiveFlagForMainDistributor__c=true));
        qdList.add(new JP_QuotationDistributor__c(Name='テスト代理店4',JP_DistributorCode__c='000040',JP_PaymentCondition__c='テスト支払条件4',JP_MainDistributorName__c='OYA代理店4',JP_MainDistributorCode__c='OYA00040'
                                                ,JP_SubjectAutoSetFlag__c=true,JP_DeafultQuotationCondition__c='00040',JP_SpotDistributor__c=false,JP_Price_List_Type__c='11'
                                                ,JP_QuotationCreatableFlag__c=true,JP_DistributorActiveFlag__c=true,JP_EffectiveFlagForMainDistributor__c=true));
        qdList.add(new JP_QuotationDistributor__c(Name='テスト代理店5',JP_DistributorCode__c='000050',JP_PaymentCondition__c='テスト支払条件5',JP_MainDistributorName__c='OYA代理店5',JP_MainDistributorCode__c='OYA00050'
                                                ,JP_SubjectAutoSetFlag__c=true,JP_DeafultQuotationCondition__c='10030',JP_SpotDistributor__c=false,JP_Price_List_Type__c='11'
                                                ,JP_QuotationCreatableFlag__c=true,JP_DistributorActiveFlag__c=true,JP_EffectiveFlagForMainDistributor__c=true));
        insert qdList;

        Create_JP_QuotationContact(qdList);

        return qdList;
    }

    //見積顧客
    public static void Create_JP_QuotationContact(List<JP_QuotationDistributor__c> oyaList){
        List<JP_QuotationContact__c> contactList = new List<JP_QuotationContact__c>();
        contactList.add(new JP_QuotationContact__c(Name='テスト顧客1',JP_CustomerAddress1__c='テスト府1',JP_CustomerAddress2__c='テスト市1',JP_CustomerBuilding__c='テストビル1'
                                                    ,JP_CustomerDept1__c='管理部',JP_CustomerDept2__c='人事部',JP_CustomerFaxNo__c='123456',JP_CustomerPostcode__c='1234567'
                                                    ,JP_CustomerTelNo__c='78945612',JP_Title_Position__c='様',JP_QuotationDistributor__c=oyaList[0].Id));
        contactList.add(new JP_QuotationContact__c(Name='テスト顧客2',JP_CustomerAddress1__c='テスト府2',JP_CustomerAddress2__c='テスト市2',JP_CustomerBuilding__c='テストビル2'
                                                    ,JP_CustomerDept1__c='管理部',JP_CustomerDept2__c='人事部',JP_CustomerFaxNo__c='123456',JP_CustomerPostcode__c='1234567'
                                                    ,JP_CustomerTelNo__c='78945612',JP_Title_Position__c='様',JP_QuotationDistributor__c=oyaList[1].Id));
        contactList.add(new JP_QuotationContact__c(Name='テスト顧客3',JP_CustomerAddress1__c='テスト府3',JP_CustomerAddress2__c='テスト市3',JP_CustomerBuilding__c='テストビル3'
                                                    ,JP_CustomerDept1__c='管理部',JP_CustomerDept2__c='人事部',JP_CustomerFaxNo__c='123456',JP_CustomerPostcode__c='1234567'
                                                    ,JP_CustomerTelNo__c='78945612',JP_Title_Position__c='様',JP_QuotationDistributor__c=oyaList[0].Id));
        contactList.add(new JP_QuotationContact__c(Name='テスト顧客4',JP_CustomerAddress1__c='テスト府4',JP_CustomerAddress2__c='テスト市4',JP_CustomerBuilding__c='テストビル4'
                                                    ,JP_CustomerDept1__c='管理部',JP_CustomerDept2__c='人事部',JP_CustomerFaxNo__c='123456',JP_CustomerPostcode__c='1234567'
                                                    ,JP_CustomerTelNo__c='78945612',JP_Title_Position__c='様',JP_QuotationDistributor__c=oyaList[1].Id));
        insert contactList;

    }

    /* 価格年月作成
    * @param Integer quantity   ：登録するレコード数
    * @return void
    */
    public static List<JP_PriceYearMonth__c> Create_JP_PriceYearMonth(Integer quantity){
        List<JP_PriceYearMonth__c> pymList = new List<JP_PriceYearMonth__c>();

        for(Integer i = 1; i <= quantity; i++){
            JP_PriceYearMonth__c pym = new JP_PriceYearMonth__c();
            pymList.add(pym);
        }

        return pymList;
    }

    /* JP_SystemAdministratorユーザ作成
    *  @param String JP_Class   ：クラス
    *  @return user
    */
    public static User Create_AdminUser(String JP_Class){
        Profile p = getProfile('JP_SystemAdministrator');
        User user = new User();
        // ユーザ名
        user.UserName = 'terraskyTest_'+ JP_Class +'@test.allied-telesis.co.jp';
        // メール
        user.Email = 'terraskyTest_'+ JP_Class +'@test.allied-telesis.co.jp';
        // 姓
        user.LastName = 'TESTUSER';
        // プロファイル
        user.profileId = p.Id;
        // 別名
        user.Alias = 'user';
        // コミュニティのニックネーム
        user.CommunityNickname = 'TEST_TERRA_' + JP_Class;
        // メールの文字コード
        user.EmailEncodingKey = 'ISO-2022-JP';
        // タイムゾーン
        user.TimeZoneSidKey = 'Asia/Tokyo';
        // 地域
        user.LocaleSidKey = 'ja_JP';
        // 言語
        user.LanguageLocaleKey = 'ja';
        // クラス
        user.JP_Class__c = JP_Class;
        
        insert user;
        
        return user;
    }

    /* JP_SystemAdministrator承認ステップ設定用ユーザ作成
    *  @param String JP_Class   ：クラス
    *  @return user
    */
    public static User Create_ApproverUser(String JP_Class){
        Profile p = getProfile('JP_SystemAdministrator');
        User user = new User();
        // ユーザ名
        user.UserName = 'approverTest_'+ JP_Class +'@test.allied-telesis.co.jp';
        // メール
        user.Email = 'approverTest'+'@test.allied-telesis.co.jp';
        // 姓
        user.LastName = 'TESTUSER';
        // プロファイル
        user.profileId = p.Id;
        // 別名
        user.Alias = 'user';
        // コミュニティのニックネーム
        user.CommunityNickname = 'APPRO_TERRA_' + JP_Class;
        // メールの文字コード
        user.EmailEncodingKey = 'ISO-2022-JP';
        // タイムゾーン
        user.TimeZoneSidKey = 'Asia/Tokyo';
        // 地域
        user.LocaleSidKey = 'ja_JP';
        // 言語
        user.LanguageLocaleKey = 'ja';
        // クラス
        user.JP_Class__c = JP_Class;
        
        insert user;
        
        List<User> userList = new List<User>();
        userList.add(user);
        userList = [SELECT ID FROM USER WHERE ID IN :userList];  
        return userList[0];
    }
    
    /* outsideユーザ作成
    *  @param String JP_Class   ：クラス
    *  @return user
    */
    public static User Create_User(String JP_Class){
        Profile p = getProfile('JP_SalesUser');
        User user = new User();
        // ユーザ名
        user.UserName = 'terraskyTest_'+ JP_Class +'@test.allied-telesis.co.jp';
        // メール
        user.Email = 'terraskyTest_'+ JP_Class +'@test.allied-telesis.co.jp';
        // 姓
        user.LastName = 'TESTUSER';
        // プロファイル
        user.profileId = p.Id;
        // 別名
        user.Alias = 'user';
        // コミュニティのニックネーム
        user.CommunityNickname = 'TEST_TERRA_' + JP_Class;
        // メールの文字コード
        user.EmailEncodingKey = 'ISO-2022-JP';
        // タイムゾーン
        user.TimeZoneSidKey = 'Asia/Tokyo';
        // 地域
        user.LocaleSidKey = 'ja_JP';
        // 言語
        user.LanguageLocaleKey = 'ja';
        // クラス
        user.JP_Class__c = JP_Class;
        
        insert user;
        
        return user;
    }
    
    /*
     * プロファイル取得
     */
    private static Profile getProfile(String PROFILE_NAME) {
        return [select Id,Name from Profile where Name =: PROFILE_NAME limit 1];
    }
    
    /*
     * 取引先作成
     * @return Account
     */
    public static List<Account> CreateAccount(Integer quantity){
        List<Account> accList = new List<Account>();
        for(Integer i = 0; i < quantity; i++){
            Account acc = new Account();
            acc.Name = 'test' + i;
            accList.add(acc);
        }
        insert accList;
        return accList;
    }
    
    /* 商談作成
    *  @return Opportunity
    */
    public static Opportunity Create_Opportunity(){
        Opportunity opp = new Opportunity();
        opp.Name = 'TESTOPPORTUNITY';
        opp.StageName = 'Final Quote';
        opp.CloseDate = system.today().addDays(7);
        opp.Amount = 10000;
        opp.RecordTypeId = '012200000005vdt';
        opp.Required_Delivery_Date__c=system.today().adddays(8);
        insert opp;
        //20221114 Alliedtelesis-462 Add start
        // 顧客作成
        Contact contact = new Contact();
        contact.LastName = 'TESTCONTACT';
        contact.MailingCountry = 'Japan';//2024/01/19 仙波追記
        
        insert contact;
        // 顧客の役割作成
        OpportunityContactRole ocr = new OpportunityContactRole();
        ocr.isPrimary = true;
        ocr.OpportunityId = opp.Id;
        ocr.ContactId = contact.Id;
        insert ocr;
        //20221114  Alliedtelesis-462 Add end
        return opp;
    }
    
    /*
     * パートナー作成
     * @return void
     */
    public static void CreatePartner(Id oppId, Id accId){
        Partner p = new Partner();
        p.OpportunityId = oppId;
        p.AccountToId = accId;
        insert p;
    }
    
    /*
     * 商談チームメンバー作成
     */
    public static void CreateOpportunityTeamMember(Id oppId, Id userId){
        OpportunityTeamMember otm = new OpportunityTeamMember();
        otm.OpportunityId = oppId;
        otm.TeamMemberRole = 'Outside Sales';
        otm.UserId = userId;
        insert otm;
    }
    
    /*
     * 商品を作成
     */
    public static PriceBookEntry CreateProduct(){
        /**
         *価格表を登録
         */
        Pricebook2 pb2 = new Pricebook2();
        pb2.Name = getCurrentYearMonth();
        pb2.IsActive = true;
        insert pb2;
        
        Product2 pdt2 = new Product2();
        pdt2.Name = 'その他商品';
        insert pdt2;
        
        PriceBookEntry pbe = new PriceBookEntry();
        pbe.Pricebook2Id = Test.getStandardPricebookId();
        pbe.Product2Id = pdt2.Id;
        pbe.UnitPrice = 100.00;
        pbe.IsActive = true;
        insert pbe;
        return pbe;
    }
    
    /*
     * 商談商品を作成
     */
    public static void CreateOpportunityLineItem(Id oppId, Id peId){
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.OpportunityId = oppId;
        oli.PricebookEntryId = peId;
        oli.UnitPrice = 10000;
        oli.quantity = 30;
        insert oli;
    }
    
    /**
     *今月の年月を取得
     */
    static String getCurrentYearMonth() { 
        Date nowDate = system.today();
        String dateYM = 'JP ' + nowDate.year();
        if(String.valueOf(nowDate.month()).length() == 2){
            dateYM += '/' + nowDate.month();
        }else{
            dateYM += '/0' + nowDate.month();
        }
        
        return dateYM;
    }
    
    
    /* 代理店専用製品コード取得
    *  @param String ProductCode    :990コード
    *  @return JP_DistributorProductCode__c
    */
    public static void Create_DistributorProductCode(String ProductCode){
        JP_DistributorProductCode__c dpc = new JP_DistributorProductCode__c();
        dpc.JP_ProductCode__c = ProductCode;
        dpc.JP_DistributorProCode__c = 'DPC2222';
        dpc.JP_MainDistributorCode__c = 'OYA00010';
        insert dpc;
    }
    
    /*
     * 特化承認情報取得
     */
    public static JP_SpecailPriceApprove__c Create_JP_SpecailPriceApprove(JP_QuotationHeader__c qh){

        JP_SpecailPriceApprove__c spa = new JP_SpecailPriceApprove__c();
        spa.JP_QuotationHeader__c = qh.Id;
        spa.JP_ApplicationTimes__c = 'JP_PartialDelivery';
        spa.JP_ApprovalNo__c = '1';
        spa.JP_SpecailPriceEndDate__c = Date.newInstance(system.today().year(),system.today().month()+3,1);

        return spa;
    }
    
    public static List<JP_SpecailPriceApprove__c> Create_JP_SpecailPriceApprove(JP_QuotationHeader__c qh, Integer quantity){
        List<JP_SpecailPriceApprove__c> spaList = new List<JP_SpecailPriceApprove__c>();
        
        for(Integer i = 1; i <= quantity; i++){
            JP_SpecailPriceApprove__c spa = new JP_SpecailPriceApprove__c();
            spa.JP_QuotationHeader__c = qh.Id;
            spa.JP_ApplicationTimes__c = 'JP_PartialDelivery';
            spa.JP_ApprovalNo__c = '1';
            spa.JP_ProductClassification__c = 'JP_ATKK_Product';
            spa.JP_SpecailPriceEndDate__c = Date.newInstance(system.today().year(),system.today().month()+3,1);
            spaList.add(spa);
        }
        
        return spaList;
    }
}