@isTest
private class JP_CL_Test_ContentVersionTrg {
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
          u.Email = 'testsemba3@xx.xxx.com';
          u.UserName = 'testsemba3@xx.xxx.com';
          u.ProfileId = '00e20000001MEiKAAW';
          u.EmailEncodingKey = 'ISO-2022-JP';
          u.LanguageLocaleKey = 'ja';
          u.LocaleSidKey = 'ja_JP';
          u.TimeZoneSidKey = 'Asia/Tokyo';
        insert u;

    }

    @isTest static void afterInsertTest01() {
        /* ＝＝＝＝＝＝テストデータ準備＝＝＝＝＝＝ */
        //ユーザ作成
        //User testuser = [SELECT Id FROM User Limit 1];
        // ToDoオブジェクトテストデータ取得
        Task record = [SELECT Id FROM Task Limit 1];

        // 添付ファイル作成
        contentversion cv1 = new contentversion();
        cv1.contentlocation = 'S';
        cv1.PathOnClient = 'sample.xlsx';
        cv1.Title = 'sample';
        cv1.VersionData = Blob.valueOf('sample fileOld');
        insert cv1;

        // ContentDocument Id 取得
        contentversion cvDocument = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Title='sample' AND IsLatest=True];

        // ContentDocumentLinkテストデータ作成
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = record.Id;
        cdl.ContentDocumentId = cvDocument.ContentDocumentId;
        insert cdl;

        // 添付ファイル更新
        contentversion cv2 = new contentversion();
        cv2.contentlocation = 'S';
        cv2.PathOnClient = 'sample.msg';
        cv2.Title = 'sample';
        cv2.VersionData = Blob.valueOf('sample fileNew');
        cv2.ContentDocumentId = cvDocument.ContentDocumentId;

        /* ＝＝＝＝＝＝テストメソッド起動＝＝＝＝＝＝ */
        Test.startTest();
        insert cv2;
        Test.stopTest();

        /* ＝＝＝＝＝＝結果検証＝＝＝＝＝＝ */
        //Task result = [SELECT Id,JP_AttachmentFlag__c FROM Task Limit 1];
        //System.assertEquals(True, result.JP_AttachmentFlag__c);
    }

    @isTest static void afterInsertTest02() {
        /* ＝＝＝＝＝＝テストデータ準備＝＝＝＝＝＝ */
        //ユーザ作成
        //User testuser = [SELECT Id FROM User Limit 1];
        // ToDoオブジェクトテストデータ取得
        Task record = [SELECT Id FROM Task Limit 1];

        // 添付ファイル作成
        contentversion cv1 = new contentversion();
        cv1.contentlocation = 'S';
        cv1.PathOnClient = 'sample.msg';
        cv1.Title = 'sample';
        cv1.VersionData = Blob.valueOf('sample fileOld');
        insert cv1;

        // ContentDocument Id 取得
        contentversion cvDocument = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Title='sample' AND IsLatest=True];

        // ContentDocumentLinkテストデータ作成
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = record.Id;
        cdl.ContentDocumentId = cvDocument.ContentDocumentId;
        insert cdl;

        // 添付ファイル更新
        contentversion cv2 = new contentversion();
        cv2.contentlocation = 'S';
        cv2.PathOnClient = 'sample.xlsx';
        cv2.Title = 'sample';
        cv2.VersionData = Blob.valueOf('sample fileNew');
        cv2.ContentDocumentId = cvDocument.ContentDocumentId;

        /* ＝＝＝＝＝＝テストメソッド起動＝＝＝＝＝＝ */
        Test.startTest();
        insert cv2;
        Test.stopTest();

        /* ＝＝＝＝＝＝結果検証＝＝＝＝＝＝ */
        //Task result = [SELECT Id,JP_AttachmentFlag__c FROM Task Limit 1];
        //System.assertEquals(False, result.JP_AttachmentFlag__c);
    }

    @isTest static void afterInsertTest03() {
        /* ＝＝＝＝＝＝テストデータ準備＝＝＝＝＝＝ */
        //ユーザ作成
        //User testuser = [SELECT Id FROM User Limit 1];
        // ToDoオブジェクトテストデータ取得
        Task record = [SELECT Id FROM Task Limit 1];

        // 添付ファイル作成
        contentversion cv1 = new contentversion();
        cv1.contentlocation = 'S';
        cv1.PathOnClient = 'sampleOld';
        cv1.Title = 'sampleOld';
        cv1.VersionData = Blob.valueOf('sample fileOld');
        insert cv1;

        // ContentDocument Id 取得
        contentversion cvDocument = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Title='sampleOld' AND IsLatest=True];

        // ContentDocumentLinkテストデータ作成
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = record.Id;
        cdl.ContentDocumentId = cvDocument.ContentDocumentId;
        insert cdl;

        // 添付ファイル更新
        contentversion cv2 = new contentversion();
        cv2.contentlocation = 'S';
        cv2.PathOnClient = 'sampleNew';
        cv2.Title = 'sampleNew';
        cv2.VersionData = Blob.valueOf('sample fileNew');
        cv2.ContentDocumentId = cvDocument.ContentDocumentId;

        /* ＝＝＝＝＝＝テストメソッド起動＝＝＝＝＝＝ */
        Test.startTest();
        insert cv2;
        Test.stopTest();

        /* ＝＝＝＝＝＝結果検証＝＝＝＝＝＝ */
        //Task result = [SELECT Id,JP_AttachmentFlag__c FROM Task Limit 1];
        //System.assertEquals(False, result.JP_AttachmentFlag__c);
    }
    
    @isTest static void afterUpdateTest01() {
        /* ＝＝＝＝＝＝テストデータ準備＝＝＝＝＝＝ */
        //ユーザ作成
        //User testuser = [SELECT Id FROM User Limit 1];
        // ToDoオブジェクトテストデータ取得
        Task record = [SELECT Id,JP_AttachmentFlag__c FROM Task Limit 1];
        
        //ToDoを更新
        record.JP_AttachmentFlag__c = FALSE;

        // 添付ファイル作成
        contentversion cv1 = new contentversion();
        cv1.contentlocation = 'S';
        cv1.PathOnClient = 'sample.xlsx';
        cv1.Title = 'sample';
        cv1.VersionData = Blob.valueOf('sample fileOld');
        insert cv1;

        // ContentDocument Id 取得
        contentversion cvDocument = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Title='sample' AND IsLatest=True];

        // ContentDocumentLinkテストデータ作成
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = record.Id;
        cdl.ContentDocumentId = cvDocument.ContentDocumentId;
        insert cdl;

        // 添付ファイル更新
        contentversion cv2 = new contentversion();
        cv2.contentlocation = 'S';
        cv2.PathOnClient = 'sample.msg';
        cv2.Title = 'sample';
        cv2.VersionData = Blob.valueOf('sample fileNew');
        cv2.ContentDocumentId = cvDocument.ContentDocumentId;

        /* ＝＝＝＝＝＝テストメソッド起動＝＝＝＝＝＝ */
        Test.startTest();
        update record;
        insert cv2;
        Test.stopTest();

        /* ＝＝＝＝＝＝結果検証＝＝＝＝＝＝ */
        //Task result = [SELECT Id,JP_AttachmentFlag__c FROM Task Limit 1];
        //System.assertEquals(True, result.JP_AttachmentFlag__c);
    }
    
}