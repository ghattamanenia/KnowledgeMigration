@isTest
private class JP_PurchaseOrderUploadControllerTest {

    public static testMethod void testJP_PurchaseOrderUploadController_OK01() {
        String fileName = 'testFileName_' + system.now();

        JP_Order520SalesRepresentative__c sr = new JP_Order520SalesRepresentative__c();
        sr.JP_Order520_Filed004__c = true;
        sr.Name = 'test担当者名';
        sr.JP_Order520_Filed001__c = '164E01010';
        insert sr;

        Blob file = Blob.valueOf( 'testBody' );

        Document doc = new Document();
        doc.FolderId = UserInfo.getUserId();
        doc.body = file;
        doc.Name = fileName + '.txt';
        doc.Description = 'Upload Temporary';
        doc.contentType = 'text/plain';
        insert doc;

        List<JP_QuotationDistributor__c> qd = JP_TestUtil.Create_JP_QuotationDistributor();
        List<JP_QuotationHeader__c> qhlist = JP_TestUtil.Create_JP_QuotationHeader(1);
        qhlist[0].JP_QuotationDistCD__c = qd[0].Id;
        qhlist[0].JP_QuotationEffectiveTerm__c = '999';
        qhlist[0].JP_AllowMixOfPriceYearMonth__c = false;
        insert qhlist;

        JP_QuotationHeader__c qh = [select JP_QuotationNo__c from JP_QuotationHeader__c where Id = :qhlist[0].Id limit 1];

        // 「JP_PurchaseOrderUpload」をテスト対象のページに設定
        PageReference pageRef = Page.JP_PurchaseOrderUpload;
        Test.setCurrentPage( pageRef );

        JP_Order010PurchaseOrder__c obj = new JP_Order010PurchaseOrder__c();

        ApexPages.StandardController stdController = new ApexPages.StandardController(obj);
        JP_PurchaseOrderUploadController controller = new JP_PurchaseOrderUploadController(stdController);

        //controller.docId = doc.Id;
        controller.init();
        controller.record.JP_Order010_Filed002__c = 'A02_本社SM';
        controller.quotationNo = qh.JP_QuotationNo__c;
        //controller.uploadFile();
        PageReference result = controller.doSave();

        //List<JP_Order010PurchaseOrder__c> amResultList = [Select Id, Name, JP_Order010_Filed013__c, ( Select Id, Name, ParentId From Attachments ) From JP_Order010PurchaseOrder__c];
        List<JP_Order010PurchaseOrder__c> amResultList = [Select Id, Name, JP_Order010_Filed013__c From JP_Order010PurchaseOrder__c Where Name = :fileName];
        List<ContentVersion> cvList = [Select Id,Title From ContentVersion Where FirstPublishLocationId = :amResultList[0].Id];

        List<Document> docList = [Select Id, Name From Document Where Name = :doc.Name];

        System.assertEquals( amResultList[0].Name, cvList[0].Title.substringBeforeLast('.') );
        System.assertEquals( '起票', amResultList[0].JP_Order010_Filed013__c );
        System.assertEquals( 0, docList.size() );

    }
    
    public static testMethod void testJP_PurchaseOrderUploadController_DELETE() {

        JP_Order520SalesRepresentative__c sr = new JP_Order520SalesRepresentative__c();
        sr.JP_Order520_Filed004__c = true;
        sr.Name = 'test担当者名';
        sr.JP_Order520_Filed001__c = '164E01010';
        insert sr;

        Blob file = Blob.valueOf( 'testBody' );

        // 「JP_PurchaseOrderUpload」をテスト対象のページに設定
        PageReference pageRef = Page.JP_PurchaseOrderUpload;
        Test.setCurrentPage( pageRef );

        JP_Order010PurchaseOrder__c obj = new JP_Order010PurchaseOrder__c();

        ApexPages.StandardController stdController = new ApexPages.StandardController(obj);
        JP_PurchaseOrderUploadController controller = new JP_PurchaseOrderUploadController(stdController);

        controller.init();
        controller.body = 'testBodyString';
        
        JP_PurchaseOrder po1 = new JP_PurchaseOrder(new Document());
        controller.fileName = 'testFileName.txt';
        controller.uploadFile();
        
        JP_PurchaseOrder po2 = new JP_PurchaseOrder(new Document());
        controller.fileName = 'testFileName2.txt';
        controller.uploadFile();

        controller.orders[0].selected = true;
        controller.orders[1].selected = true;
        controller.doDelete();
    }
    
    //upload時の重複テスト
    public static testMethod void testJP_PurchaseOrderUploadController_DUPLICATE1() {

        JP_Order520SalesRepresentative__c sr = new JP_Order520SalesRepresentative__c();
        sr.JP_Order520_Filed004__c = true;
        sr.Name = 'test担当者名';
        sr.JP_Order520_Filed001__c = '164E01010';
        insert sr;

        Blob file = Blob.valueOf( 'testBody' );

        // 「JP_PurchaseOrderUpload」をテスト対象のページに設定
        PageReference pageRef = Page.JP_PurchaseOrderUpload;
        Test.setCurrentPage( pageRef );

        JP_Order010PurchaseOrder__c obj = new JP_Order010PurchaseOrder__c();

        ApexPages.StandardController stdController = new ApexPages.StandardController(obj);
        JP_PurchaseOrderUploadController controller = new JP_PurchaseOrderUploadController(stdController);

        controller.init();
        controller.body = 'testBodyString';
        
        JP_PurchaseOrder po1 = new JP_PurchaseOrder(new Document());
        controller.fileName = 'testFileName.txt';
        controller.uploadFile();
        
        JP_PurchaseOrder po2 = new JP_PurchaseOrder(new Document());
        controller.fileName = 'testFileName.txt';
        controller.uploadFile();
    }
    
    //保存＆添付時の重複テスト
    public static testMethod void testJP_PurchaseOrderUploadController_DUPLICATE2() {

        String fileName = 'testFileName_' + system.now();

        JP_Order520SalesRepresentative__c sr = new JP_Order520SalesRepresentative__c();
        sr.JP_Order520_Filed004__c = true;
        sr.Name = 'test担当者名';
        sr.JP_Order520_Filed001__c = '164E01010';
        insert sr;

        JP_Order010PurchaseOrder__c po = new JP_Order010PurchaseOrder__c();
        po.Name = fileName;
        insert po;

        Blob file = Blob.valueOf( 'testBody' );

        Document doc = new Document();
        doc.FolderId = UserInfo.getUserId();
        doc.body = file;
        doc.Name = fileName + '.txt';
        doc.Description = 'Upload Temporary';
        doc.contentType = 'text/plain';
        insert doc;
        
        List<JP_QuotationDistributor__c> qd = JP_TestUtil.Create_JP_QuotationDistributor();
        List<JP_QuotationHeader__c> qhlist = JP_TestUtil.Create_JP_QuotationHeader(1);
        qhlist[0].JP_QuotationDistCD__c = qd[0].Id;
        qhlist[0].JP_QuotationEffectiveTerm__c = '999';
        qhlist[0].JP_AllowMixOfPriceYearMonth__c = false;
        insert qhlist;

        JP_QuotationHeader__c qh = [select JP_QuotationNo__c from JP_QuotationHeader__c where Id = :qhlist[0].Id limit 1];

        // 「JP_PurchaseOrderUpload」をテスト対象のページに設定
        PageReference pageRef = Page.JP_PurchaseOrderUpload;
        Test.setCurrentPage( pageRef );

        JP_Order010PurchaseOrder__c obj = new JP_Order010PurchaseOrder__c();

        ApexPages.StandardController stdController = new ApexPages.StandardController(obj);
        JP_PurchaseOrderUploadController controller = new JP_PurchaseOrderUploadController(stdController);

        controller.init();
        controller.quotationNo = qh.JP_QuotationNo__c;
        obj.JP_Order010_Filed002__c = 'A02_本社SM';
        controller.body = 'testBodyString';
        
        JP_PurchaseOrder po1 = new JP_PurchaseOrder(new Document());
        controller.fileName = 'testFileName.txt';
        //controller.uploadFile();
        controller.doSave();
    }

    // ファイル添付が行われていないテスト
    public static testMethod void testJP_PurchaseOrderUploadController_NG03() {

        String fileName = 'testFileName_' + system.now();

        JP_Order520SalesRepresentative__c sr = new JP_Order520SalesRepresentative__c();
        sr.JP_Order520_Filed004__c = true;
        sr.Name = 'test担当者名';
        sr.JP_Order520_Filed001__c = '164E01010';
        insert sr;

        JP_Order010PurchaseOrder__c po = new JP_Order010PurchaseOrder__c();
        po.Name = fileName;
        insert po;

        Blob file = Blob.valueOf( 'testBody' );

        Document doc = new Document();
        doc.FolderId = UserInfo.getUserId();
        doc.body = file;
        doc.Name = fileName + '.txt';
        doc.Description = 'Upload Temporary';
        doc.contentType = 'text/plain';
        insert doc;
        
        List<JP_QuotationDistributor__c> qd = JP_TestUtil.Create_JP_QuotationDistributor();
        List<JP_QuotationHeader__c> qhlist = JP_TestUtil.Create_JP_QuotationHeader(1);
        qhlist[0].JP_QuotationDistCD__c = qd[0].Id;
        qhlist[0].JP_QuotationEffectiveTerm__c = '999';
        qhlist[0].JP_AllowMixOfPriceYearMonth__c = false;
        insert qhlist;

        JP_QuotationHeader__c qh = [select JP_QuotationNo__c from JP_QuotationHeader__c where Id = :qhlist[0].Id limit 1];
        
        // 「JP_PurchaseOrderUpload」をテスト対象のページに設定
        PageReference pageRef = Page.JP_PurchaseOrderUpload;
        Test.setCurrentPage( pageRef );

        JP_Order010PurchaseOrder__c obj = new JP_Order010PurchaseOrder__c();

        ApexPages.StandardController stdController = new ApexPages.StandardController(obj);
        JP_PurchaseOrderUploadController controller = new JP_PurchaseOrderUploadController(stdController);

        controller.init();
        
        controller.record.JP_Order010_Filed002__c = 'A02_本社SM';
        controller.quotationNo = qh.JP_QuotationNo__c;

        controller.doSave();

        List<Apexpages.Message> messages = ApexPages.getMessages();

        System.debug( messages[0].getDetail() );

        System.assertEquals( '下記注文書のファイル名が重複しています。ファイル名を変更してください。<br/> ・' + fileName, messages[0].getDetail() );
    }

    // 拠点が選択されていないテスト
    public static testMethod void testJP_PurchaseOrderUploadController_NG04() {

        String fileName = 'testFileName_' + system.now();

        JP_Order520SalesRepresentative__c sr = new JP_Order520SalesRepresentative__c();
        sr.JP_Order520_Filed004__c = true;
        sr.Name = 'test担当者名';
        sr.JP_Order520_Filed001__c = '164E01010';
        insert sr;

        JP_Order010PurchaseOrder__c po = new JP_Order010PurchaseOrder__c();
        po.Name = fileName;
        insert po;

        Blob file = Blob.valueOf( 'testBody' );

        Document doc = new Document();
        doc.FolderId = UserInfo.getUserId();
        doc.body = file;
        doc.Name = fileName + '.txt';
        doc.Description = 'Upload Temporary';
        doc.contentType = 'text/plain';
        insert doc;
        
        List<JP_QuotationDistributor__c> qd = JP_TestUtil.Create_JP_QuotationDistributor();
        List<JP_QuotationHeader__c> qhlist = JP_TestUtil.Create_JP_QuotationHeader(1);
        qhlist[0].JP_QuotationDistCD__c = qd[0].Id;
        qhlist[0].JP_QuotationEffectiveTerm__c = '999';
        qhlist[0].JP_AllowMixOfPriceYearMonth__c = false;
        insert qhlist;

        JP_QuotationHeader__c qh = [select JP_QuotationNo__c from JP_QuotationHeader__c where Id = :qhlist[0].Id limit 1];
        
        // 「JP_PurchaseOrderUpload」をテスト対象のページに設定
        PageReference pageRef = Page.JP_PurchaseOrderUpload;
        Test.setCurrentPage( pageRef );

        JP_Order010PurchaseOrder__c obj = new JP_Order010PurchaseOrder__c();

        ApexPages.StandardController stdController = new ApexPages.StandardController(obj);
        JP_PurchaseOrderUploadController controller = new JP_PurchaseOrderUploadController(stdController);

        controller.init();

        controller.quotationNo = qh.JP_QuotationNo__c;

        controller.doSave();

        List<Apexpages.Message> messages = ApexPages.getMessages();

        System.debug( messages[0].getDetail() );

        System.assertEquals( '拠点が空欄です。拠点を選択してください。', messages[0].getDetail() );
    }

    // 存在しない見積書番号で検索のテスト
    public static testMethod void testJP_PurchaseOrderUploadController_NG05() {

        String fileName = 'testFileName_' + system.now();

        JP_Order520SalesRepresentative__c sr = new JP_Order520SalesRepresentative__c();
        sr.JP_Order520_Filed004__c = true;
        sr.Name = 'test担当者名';
        sr.JP_Order520_Filed001__c = '164E01010';
        insert sr;

        JP_Order010PurchaseOrder__c po = new JP_Order010PurchaseOrder__c();
        po.Name = fileName;
        insert po;

        Blob file = Blob.valueOf( 'testBody' );

        Document doc = new Document();
        doc.FolderId = UserInfo.getUserId();
        doc.body = file;
        doc.Name = fileName + '.txt';
        doc.Description = 'Upload Temporary';
        doc.contentType = 'text/plain';
        insert doc;
        
        // 「JP_PurchaseOrderUpload」をテスト対象のページに設定
        PageReference pageRef = Page.JP_PurchaseOrderUpload;
        Test.setCurrentPage( pageRef );

        JP_Order010PurchaseOrder__c obj = new JP_Order010PurchaseOrder__c();

        ApexPages.StandardController stdController = new ApexPages.StandardController(obj);
        JP_PurchaseOrderUploadController controller = new JP_PurchaseOrderUploadController(stdController);

        controller.init();

        controller.quotationNo = 'aaaaa';

        controller.doSave();


        List<Apexpages.Message> messages = ApexPages.getMessages();

        System.debug( messages[0].getDetail() );

        System.assertEquals( '該当の製品見積が見つかりません', messages[0].getDetail() );
    }
}