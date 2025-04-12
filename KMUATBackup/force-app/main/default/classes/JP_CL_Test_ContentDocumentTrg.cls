@isTest
private class JP_CL_Test_ContentDocumentTrg {
    //testSetupデータ準備
    @testSetup
    static void setup() {
        User u = new User();
        u.LastName = 'テスト';
        u.FirstName = '太郎';
        u.Email = 'testsemba2@test.com';
        u.UserName = 'GLS_testsemba2@test.com.sample';
        u.Alias = 'glstest';
        u.ProfileId = UserInfo.getProfileId();
        u.EmailEncodingKey = 'ISO-2022-JP';
        u.TimeZoneSidKey = 'Asia/Tokyo';
        u.LocaleSidKey = 'ja_JP';
        u.LanguageLocaleKey = 'ja';
        insert u;

        Task ts = new Task();
        ts.Subject = '問合せ対応';
        ts.Status = 'Not begun';
        ts.Priority = 'Normal';
        insert ts;

    }

    @isTest static void beforeDeleteTest01() {
        /* ＝＝＝＝＝＝テストデータ準備＝＝＝＝＝＝ */
        // ToDoオブジェクトテストデータ取得
        Task record = [SELECT Id FROM Task Limit 1];

        // 添付ファイル作成
        contentversion cv = new contentversion();
        cv.contentlocation = 'S';
        cv.PathOnClient = 'sample.xlsx';
        cv.Title = 'sample';
        cv.VersionData = Blob.valueOf('sample file');
        insert cv;

        // ContentDocument Id 取得
        contentversion cvDocument = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Title='sample' AND IsLatest=True];

        // ContentDocumentLinkテストデータ作成
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = record.Id;
        cdl.ContentDocumentId = cvDocument.ContentDocumentId;
        insert cdl;

        /* ＝＝＝＝＝＝テストメソッド起動＝＝＝＝＝＝ */
        Test.startTest();
        delete [SELECT Id FROM ContentDocument];
        Test.stopTest();

        /* ＝＝＝＝＝＝結果検証＝＝＝＝＝＝ */
        Task result = [SELECT Id,JP_AttachmentFlag__c FROM Task Limit 1];
        System.assertEquals(False, result.JP_AttachmentFlag__c);
    }


    @isTest static void beforeDeleteTest02() {
        /* ＝＝＝＝＝＝テストデータ準備＝＝＝＝＝＝ */
        // ユーザテストデータ取得
        //user record = [SELECT Id FROM user Limit 1];
        
        // ToDoオブジェクトテストデータ取得
        Task record = [SELECT Id FROM Task Limit 1];

        // 添付ファイル1作成
        contentversion cv1 = new contentversion();
        cv1.contentlocation = 'S';
        cv1.PathOnClient = 'sample1.xlsx';
        cv1.Title = 'sample1';
        cv1.VersionData = Blob.valueOf('sample file1');
        insert cv1;

        // 添付ファイル2作成
        contentversion cv2 = new contentversion();
        cv2.contentlocation = 'S';
        cv2.PathOnClient = 'sample2.xlsx';
        cv2.Title = 'sample2';
        cv2.VersionData = Blob.valueOf('sample file2');
        insert cv2;

        // ContentDocument Id 取得
        contentversion cvDocument = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Title='sample1' AND IsLatest=True];

        // ContentDocumentLinkテストデータ作成
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = record.Id;
        cdl.ContentDocumentId = cvDocument.ContentDocumentId;
        insert cdl;

        /* ＝＝＝＝＝＝テストメソッド起動＝＝＝＝＝＝ */
        Test.startTest();
        delete [SELECT Id FROM ContentDocument];
        Test.stopTest();

        /* ＝＝＝＝＝＝結果検証＝＝＝＝＝＝ */
        //Task result = [SELECT Id,JP_AttachmentFlag__c FROM Task Limit 1];
        //System.assertEquals(True, result.JP_AttachmentFlag__c);
    }

    @isTest static void afterDeleteTest01() {
        /* ＝＝＝＝＝＝テストデータ準備＝＝＝＝＝＝ */
        // ToDoオブジェクトテストデータ取得
        Task record = [SELECT Id FROM Task];

        // 添付ファイル作成
        contentversion cv = new contentversion();
        cv.contentlocation = 'S';
        cv.PathOnClient = 'sample.xlsx';
        cv.Title = 'sample';
        cv.VersionData = Blob.valueOf('sample file');
        insert cv;

        // ContentDocument Id 取得
        contentversion cvDocument = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Title='sample' AND IsLatest=True];

        // ContentDocumentLinkテストデータ作成
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = record.Id;
        cdl.ContentDocumentId = cvDocument.ContentDocumentId;
        insert cdl;

        /* ＝＝＝＝＝＝テストメソッド起動＝＝＝＝＝＝ */
        Test.startTest();
        delete cdl;
        Test.stopTest();

        /* ＝＝＝＝＝＝結果検証＝＝＝＝＝＝ */
        Task result = [SELECT Id,JP_AttachmentFlag__c FROM Task Limit 1];
        System.assertEquals(False, result.JP_AttachmentFlag__c);
    }

}