@isTest
private class Test_JP_CLCallSPMSPollingController{
    static Profile pJP = [select id from profile where name='JP_SalesUser'];
    static List<RecordType> RecordTypeList = [select Name,ID from RecordType where SObjectType ='Account' order by name];
    static Map<String, Id> RecordTypeMap = new Map<String, Id>();
    

    /**
     * Account insert for Japan
     * @param なし -
     * @return test_acc.Id - insertした会社のID
     * @throws なし -
     */
    public static Account prepareDataJapanAccount(){
        for(RecordType rt:RecordTypeList){
            RecordTypeMap.put(rt.name,rt.id);
        }
        Account test_acc = new Account();
        test_acc.Name = 'JP_TEST_ACCOUNT';
        test_acc.Phone = '+81 3-1111-2222';
        test_acc.Recordtypeid=RecordTypeMap.get('JP_AccountsBeforeCleansing');
        test_acc.BillingCountry = 'Japan';
        insert test_acc;
        return test_acc;
    }
    
    
    public static Contact prepareDataJapanContact(Id acc_id){
        Contact test_con = new Contact();
        test_con.LastName = 'JP_TEST_CONTACT';
        test_con.FirstName = '@@@';
        test_con.AccountId = acc_id;
        test_con.CurrencyIsoCode = 'JPY';
        test_con.JP_Grade__c = 'D';
        test_con.MailingCountry = 'Japan';//2024/01/22 仙波追記
        insert test_con;
        return test_con;
    }
    
    /**
     * 商談情報（宛先顧客の指定あり）のinsert
     * @param acc_id - 作成した会社のID、con_id - 作成した顧客のID、prb_id - 作成した価格表のID
     * @return test_opp.Id - insertした商談情報のID
     * @throws なし -
     */
    public static Opportunity prepareDataOpp(Id acc_id,Id con_id,Id prb_id){
        Opportunity test_opp = new Opportunity();
        test_opp.Name = 'テスト商談@';
        test_opp.CloseDate = Date.valueof('2010-12-31');
        test_opp.Required_Delivery_Date__c=system.today().adddays(3);
        // test_opp.StageName = 'Final Quote';
         test_opp.stageName='Engagement/Value Proposition';
        test_opp.AccountId = acc_id;
        test_opp.JP_Enduser__c = acc_id;
        test_opp.JP_RelatedContact__c = con_id;
        test_opp.JP_ContactEnduser__c = con_id;
        test_opp.JP_SendToAccount__c= acc_id;
        test_opp.JP_SendToContact__c= con_id;
        test_opp.JP_NoSendToContactFlag__c= FALSE;
        test_opp.JP_PlVersion__c= '';
        test_opp.JP_TargetDistributorCode__c= '1020aaaaa';
        insert test_opp;
        return test_opp;
    }
    

    /**
     * Check ATFE_ChoosePricebookController（日本プロファイル：コンストラクタ呼び出し正常）
     * @param なし -
     * @return なし -
     * @throws なし -
     */
        private static testMethod void Test_JP_CLCallSPMSPollingController() {
        //テストページを用意
        PageReference pageRef = Page.JP_PGCallSPMSPolling;
        Test.setCurrentPage(pageRef);
        
        Account acc = prepareDataJapanAccount();
        Contact con = prepareDataJapanContact(acc.id);
        Opportunity opp = prepareDataOpp(acc.id, con.id, NULL);
        
        //パラメータの設定
        ApexPages.currentPage().getParameters().put('id', opp.Id);
        
      
    
        //商談型リストを定義し、作成した商談のIDを取得
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        //プロファイル・ユーザ情報を設定（日本ユーザ）
        User u = new User(alias = 'テスト', email='standarduser@testorg.com',
            emailencodingkey='UTF-8', lastname='価格表テストクラスユーザJP',
            languagelocalekey='ja', localesidkey='ja',profileid = pJP.id,
            timezonesidkey='Asia/Tokyo', username='standarduser_test@alliedtelesistestorg.com');

        System.runAs(u) {
            Test.Starttest();
                //コンストラクタの呼び出し
                JP_CLCallSPMSPollingController cPrbCon = new JP_CLCallSPMSPollingController(sc);
              cPrbCon.getStatus();
              cPrbCon.getErrorDetailMsg();
              cPrbCon.getStatusCount();
              cPrbCon.getQuoid();
              cPrbCon.getPollingLimit();
              cPrbCon.getPollingTime();
              cPrbCon.getWholeTime();
              cPrbCon.getTotalTimeoutMSG();
              cPrbCon.setStatus('test');
            Test.StopTest();
            
        }
    }
 }