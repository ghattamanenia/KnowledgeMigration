/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation sdo not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Test_JP_TRLeadTrans {
    
    //'JP_SalesUser'のプロファイルを取得する
    public static Id getJPSalesProfileId () {
        
        List<Profile> profListSales = [Select Id From Profile Where Name = 'JP_SalesUser'];
        return profListSales[0].Id;
    }
    
    //'JP_LeadsForItemTrans'のレコードタイプを取得する
    public static Id getJPRecordtypeId () {
        
        List<Recordtype> JPRecordtype = [Select Id From Recordtype where name = 'JP_LeadsForItemTrans'];
        return JPRecordtype[0].Id;
    }
    //'JP_LeadsTrans'のレコードタイプを取得する
    public static Id getJPLeadRecordtypeId () {
        
        List<Recordtype> JPLeadRecordtype = [Select Id From Recordtype where name = 'JP_LeadTrans'];
        return JPLeadRecordtype[0].Id;
    }
    
    //テスト用ユーザを作成
    public static User createUser() {
        
        User insTestUser = new User();
        insTestUser.FirstName = 'Kotaro';
        insTestUser.LastName = 'Hitachi';
        insTestUser.JP_FullName__c = '日立小太郎';
        insTestUser.IsActive = False;
        insTestUser.JP_QueueFlag__c = true;
        insTestUser.ProfileId = getJPSalesProfileId();
        insTestUser.Username = 'TestLeadTrans.hitachi-solutions@allied-telesis.co.jp';
        insTestUser.Email = 'TestLeadTrace@hitachi-solutions.com';
        insTestUser.Alias = 'HISOL_Le';
        insTestUser.CommunityNickname = 'HISOL_Lead';
        insTestUser.TimeZoneSidKey = 'Asia/Tokyo';
        insTestUser.LocaleSidKey = 'ja_JP';
        insTestUser.EmailEncodingKey = 'Shift_JIS';
        insTestUser.LanguageLocaleKey = 'ja';
        return insTestUser;
    }
    
    //テスト用RepeaItem担当者を作成
    public static JP_RepairItemPersonInCharge__c createRIPerson(User TestUser){
        
        JP_RepairItemPersonInCharge__c RIPerson = new JP_RepairItemPersonInCharge__c();
        RIPerson.JP_OriginUser__c=TestUser.ID;
        RIPerson.RecordTypeId = getJPLeadRecordtypeId ();
        RIPerson.Name = 'Hitachi';
        return RIPerson;
        
    }
    //テスト用リードを作成
    public static Lead createLead() {
        
        Lead TestLead = new Lead();
        TestLead.RecordTypeId = getJPRecordtypeId ();
        TestLead.JP_TransformerClassification__c = '対応依頼';
        TestLead.Status='承認依頼';
        TestLead.Company='Test会社';
        TestLead.LastName = 'Hitachi';
        TestLead.JP_Transuser__c= UserInfo.getUserId();
        return TestLead;
    }
    
    //テスト用リードトランスを作成
    public static JP_LeadTrans__c createLeadTrans(JP_RepairItemPersonInCharge__c testRIPerson,Lead TestLead){
        
        JP_LeadTrans__c TestLeadTrans = new JP_LeadTrans__c();
        TestLeadTrans.JP_Lead__c = TestLead.ID;
        TestLeadTrans.JP_PersonInCharge__c = testRIPerson.ID;
        return TestLeadTrans;
    }
    
    //テスト用リードを更新
    public static Lead updateLead(Lead TestLead){
        TestLead.Status = '承認&トランス通知済み';
        TestLead.JP_TransDate__c=system.today();
        return TestLead;
    }
    
    //updateテスト
    static testMethod void insertUserTriggerTest() {
        
        User TestUser = createUser();
        insert TestUser;
        JP_RepairItemPersonInCharge__c testRIPerson = createRIPerson(TestUser);
        insert testRIPerson;
        Lead TestLead = createLead();
        insert TestLead;
        JP_LeadTrans__c TestLeadTrans = createLeadTrans(testRIPerson,TestLead);
        insert TestLeadTrans;
        Lead updateLead = updateLead(TestLead);
        test.startTest();
        update updateLead;
        test.stopTest();
    }
}