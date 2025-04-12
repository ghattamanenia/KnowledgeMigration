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
private class Test_JP_TRUserInsertUpdateTrigger {
    
    //'CS'のプロファイルを取得する
    public static Id getJPCSProfileId () {
        
        List<Profile> profListCS = [Select Id From Profile Where Name = 'JP_CS'];
        return profListCS[0].Id;
    }
    
    //'EMEA_Sales'のプロファイルを取得する
    public static Id getEMEAProfileId() {
        
        //List<Profile> profListEM = [Select Id From Profile Where Name = 'EMEA_SalesUser']; 'We no longer have EMEA Sales Users
        List<Profile> profListEM = [Select Id From Profile Where Name = 'Sales User'];
        return profListEM[0].Id;
    }
    
    //Triggerのテスト用ユーザを作成
    public static User createUser0() {
        
        User insTestUser = new User();
        insTestUser.FirstName = 'Yuuki';
        insTestUser.LastName = 'Fukakusa';
        insTestUser.IsActive = False;
        insTestUser.JP_QueueFlag__c = false;
        insTestUser.ProfileId = getEMEAProfileId();
        insTestUser.Username = 'TestInsert.hitachi-solutions0@allied-telesis.co.jp';
        insTestUser.Email = 'TestInsert@hitachi-solutions0.com';
        insTestUser.Alias = 'HSOLT00';
        insTestUser.CommunityNickname = 'HSOLT00';
        insTestUser.TimeZoneSidKey = 'Asia/Tokyo';
        insTestUser.LocaleSidKey = 'ja_JP';
        insTestUser.EmailEncodingKey = 'Shift_JIS';
        insTestUser.LanguageLocaleKey = 'ja';
        return insTestUser;
    }
    
    //Insert/Upsert/Deleteの実処理をテストするユーザの作成（ユーザ）
    public static User createUser1() {
        
        User newTestUser1 = new User();
        newTestUser1.FirstName = 'Yuuki';
        newTestUser1.LastName = 'Fukakusa';
        newTestUser1.jp_FullName__c = 'RepairItemPersonInCharge1';
        newTestUser1.Email = 'TestInsert@hitachi-solutions1.com';
        newTestUser1.ProfileId = getJPCSProfileId();
        newTestUser1.IsActive = false;
        newTestUser1.JP_QueueFlag__c = false;
        newTestUser1.Username = 'TestInsert.hitachi-solutions1@allied-telesis.co.jp';
        newTestUser1.Alias = 'HSOLT01';
        newTestUser1.CommunityNickname = 'HSOLT01';
        newTestUser1.TimeZoneSidKey = 'Asia/Tokyo';
        newTestUser1.LocaleSidKey = 'ja_JP';
        newTestUser1.EmailEncodingKey = 'Shift_JIS';
        newTestUser1.LanguageLocaleKey = 'ja';
        return newTestUser1;
    }
    
    //Insert/Upsert/Deleteの実処理をテストするユーザの作成（キューユーザ）
    public static User createUser2() {
        
        User newTestUser2 = new User();
        newTestUser2.LastName = 'TestQueueUserName';
        newTestUser2.jp_FullName__c = 'TestQueue';
        newTestUser2.Email = 'TestInsert@hitachi-solutions2.com';
        newTestUser2.ProfileId = getJPCSProfileId();
        newTestUser2.IsActive = false;
        newTestUser2.JP_QueueFlag__c = true;
        newTestUser2.Username = 'TestInsert.hitachi-solutions2@allied-telesis.co.jp';
        newTestUser2.Alias = 'HSOLT02';
        newTestUser2.CommunityNickname = 'HSOLT02';
        newTestUser2.TimeZoneSidKey = 'Asia/Tokyo';
        newTestUser2.LocaleSidKey = 'ja_JP';
        newTestUser2.EmailEncodingKey = 'Shift_JIS';
        newTestUser2.LanguageLocaleKey = 'ja';
        return newTestUser2;
    }

    //Insert/Upsert/Deleteの実処理をテストするユーザの作成（RepairItem担当者Delete対象）
    public static User createUser3() {
        
        User newTestUser3 = new User();
        newTestUser3.LastName = 'DeleteQueue';
        newTestUser3.jp_FullName__c = 'DelQueue';
        newTestUser3.Email = 'TestInsert@hitachi-solutions3.com';
        newTestUser3.ProfileId = getEMEAProfileId();
        newTestUser3.IsActive = false;
        newTestUser3.JP_QueueFlag__c = true;
        newTestUser3.Username = 'TestInsert.hitachi-solutions3@allied-telesis.co.jp';
        newTestUser3.Alias = 'HSOLT03';
        newTestUser3.CommunityNickname = 'HSOLT03';
        newTestUser3.TimeZoneSidKey = 'Asia/Tokyo';
        newTestUser3.LocaleSidKey = 'ja_JP';
        newTestUser3.EmailEncodingKey = 'Shift_JIS';
        newTestUser3.LanguageLocaleKey = 'ja';
        return newTestUser3;
    }
    
    //Insertトリガテスト
    static testMethod void insertUserTriggerTest() {
        
        User testUser0 = createUser0();
        test.startTest();
        insert testUser0;
        test.stopTest();
    }
    
    //Insert実処理のテスト
    static testMethod void insertNewUserTest() {
        
        List<User> testUserList = new List<User>();
        
        User insTestUser1 = createUser1();
        User insTestUser2 = createUser2();
        testUserList.add(insTestUser1);
        testUserList.add(insTestUser2);
        
        test.startTest();
        insert testUserList;
        test.stopTest();
        
        //RepairItem担当者レコードが作成されているか確認する
        Set<Id> userIds = new Set<Id>{testUserList[0].Id,testUserList[1].Id};
        List<JP_RepairItemPersonInCharge__c> riPic = [Select Id From JP_RepairItemPersonInCharge__c Where JP_OriginUser__c IN: userIds];
        system.assertEquals(1,riPic.size());
    }
    
    //Upsert/Delete実処理のテスト
    static testMethod void updateUserDataTest() {
        
        List<User> testInsUserList = new List<User>();
        User tmpTestUser1 = createUser1();
        User tmpTestUser2 = createUser2();
        User tmpTestUser3 = createUser3();
        testInsUserList.add(tmpTestUser1);
        testInsUserList.add(tmpTestUser2);
        testInsUserList.add(tmpTestUser3);
        
        insert testInsUserList;

        test.startTest();
        update testInsUserList;
        test.stopTest();
        
        //RepairItem担当者レコードが作成/削除されているか確認する
        Set<Id> userIds = new Set<Id>{testInsUserList[0].Id,testInsUserList[1].Id,testInsUserList[2].Id};
        List<JP_RepairItemPersonInCharge__c> riPic = [Select Id From JP_RepairItemPersonInCharge__c Where JP_OriginUser__c IN: userIds];
        system.assertEquals(1,riPic.size());
    }
    
}