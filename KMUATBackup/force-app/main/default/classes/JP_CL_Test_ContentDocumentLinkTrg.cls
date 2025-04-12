@isTest
private class JP_CL_Test_ContentDocumentLinkTrg {
    //testSetupデータ準備
    @testSetup
    static void setup() {
        //テスト用のToDoレコードを作成
        Task ts = new Task();
            ts.Subject = '問合せ対応';
            ts.Status = 'Not begun';
            ts.Priority = 'Normal';
            //ToDoのレコードタイプIDの「JP_Tasks」
            ts.RecordTypeId = '012200000005vdvAAA';  
        insert ts;
        
        //テスト実施ユーザ作成
        User u = new User();
          u.LastName = 'testuser';
          u.Alias = 'newUser';
          u.Email = 'testsemba1@xx.xxx.com';
          u.UserName = 'testsemba1@xx.xxx.com';
          u.ProfileId = '00e20000001MEiKAAW';
          u.EmailEncodingKey = 'ISO-2022-JP';
          u.LanguageLocaleKey = 'ja';
          u.LocaleSidKey = 'ja_JP';
          u.TimeZoneSidKey = 'Asia/Tokyo';
        insert u;
    }
    
    //static User createUser(){
        
        //Profile p = [Select Id from Profile Where Name = 'システム管理者'];
        //テスト用のユーザ作成
        //User u = new User(
            //LastName = 'testuser',
            //Alias = 'newUser',
            //Email = 'test@xx.xxx.com',
            //UserName = 'test@xx.xxx.com',
            //ProfileId = p.Id,
            //EmailEncodingKey = 'ISO-2022-JP',
            //LanguageLocaleKey = 'ja',
            //LocaleSidKey = 'ja_JP',
            //TimeZoneSidKey = 'Asia/Tokyo'
        //);
        //insert u;
        //return u;
    //}

    @isTest static void afterInsertTest01() {
        /* ＝＝＝＝＝＝テストデータ準備＝＝＝＝＝＝ */
        //ユーザ作成
        User testuser = [SELECT Id FROM User Limit 1];
        
        //CollaborationGroup ChatterAdminGroup = [SELECT CollaborationType,Id,MemberCount,Name FROM CollaborationGroup where Name = 'Chatter Files Administrators'];
        
        // ToDoオブジェクトテストデータ取得
        Task record = [SELECT Id FROM Task Limit 1];

        // 添付ファイル作成
        contentversion cv = new contentversion();
        cv.contentlocation = 'S'; //ファイルはSalesforce上に保存
        cv.PathOnClient = 'test.csv'; //ファイル名
        cv.Title = 'テスト'; //ファイルタイトル
        cv.VersionData = Blob.valueOf('test'); //ファイルデータ
        insert cv;

        // ContentDocument Id 取得
        contentversion cvDocument = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Title = 'テスト' AND IsLatest = True];

        // ContentDocumentLinkテストデータ作成
        // ToDoレコードと添付ファイルの紐付け
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = record.Id;
        cdl.ContentDocumentId = cvDocument.ContentDocumentId;

        /* ＝＝＝＝＝＝テストメソッド起動＝＝＝＝＝＝ */
        //作成したユーザで取引先を作成
        
        Test.startTest();
        
        //system.runAs(testuser){
            insert cdl;
        //}
              
        Test.stopTest();

        /* ＝＝＝＝＝＝結果検証＝＝＝＝＝＝ */
        //Task result = [SELECT Id,JP_AttachmentFlag__c FROM Task Limit 1];
        //System.assertEquals(False, result.JP_AttachmentFlag__c);
    }


    @isTest static void afterInsertTest02() {
        /* ＝＝＝＝＝＝テストデータ準備＝＝＝＝＝＝ */
        //ユーザ作成
        User testuser = [SELECT Id FROM User Limit 1];
        
        // ToDoオブジェクトテストデータ取得
        Task record = [SELECT Id FROM Task Limit 1];

        // 添付ファイル作成
        contentversion cv = new contentversion();
        cv.contentlocation = 'S'; //ファイルはSalesforce上に保存
        cv.PathOnClient = 'test'; //ファイル名
        cv.Title = 'テスト'; //ファイルタイトル
        cv.VersionData = Blob.valueOf('test'); //ファイルデータ
        insert cv;

        // ContentDocument Id 取得
        contentversion cvDocument = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Title='テスト' AND IsLatest = True];

        // ContentDocumentLinkテストデータ作成
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = record.Id;
        cdl.ContentDocumentId = cvDocument.ContentDocumentId;

        /* ＝＝＝＝＝＝テストメソッド起動＝＝＝＝＝＝ */
        Test.startTest();
        
        //system.runAs(testuser){
            insert cdl;
        //}

        Test.stopTest();

        /* ＝＝＝＝＝＝結果検証＝＝＝＝＝＝ */
        //Task result = [SELECT Id,JP_AttachmentFlag__c FROM Task Limit 1];
        //System.assertEquals(False, result.JP_AttachmentFlag__c);
    }
}