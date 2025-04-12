@isTest
public class Test_JP_CopyQuotationController {

    private static testMethod void  takeoverflgTrueTest(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
            // 1.コントローラを利用するvisualforceページをテスト実行時の画面として設定
            PageReference pageRef = Page.JP_CopyQuotation;
            Test.setCurrentPage(pageRef);

            // 2.画面で操作するオブジェクトを生成
            JP_QuotationHeader__c obj = JP_TestUtil.Create_JP_QuotationHeaderForTrigger(-5);

            // 3.標準コントローラを生成
            //   オブジェクトを渡してインスタンス化する
            ApexPages.StandardController stdController = new ApexPages.StandardController(obj);

            // 4.コントローラ拡張を生成
            //   標準コントローラを渡してインスタンス化する
            JP_CopyQuotationController extController = new JP_CopyQuotationController(stdController);

            // 5.コントローラ拡張の独自メソッドを実行
            extController.setTakeoverFlgTrue();

            // 6.実行結果をテスト
            System.assertEquals(true, extController.takeoverFlg);
        }
    }

    private static testMethod void  takeoverflgFalseTest(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
            // 1.コントローラを利用するvisualforceページをテスト実行時の画面として設定
            PageReference pageRef = Page.JP_CopyQuotation;
            Test.setCurrentPage(pageRef);

            // 2.画面で操作するオブジェクトを生成
            JP_QuotationHeader__c obj = JP_TestUtil.Create_JP_QuotationHeaderForTrigger(-5);

            // 3.標準コントローラを生成
            //   オブジェクトを渡してインスタンス化する
            ApexPages.StandardController stdController = new ApexPages.StandardController(obj);

            // 4.コントローラ拡張を生成
            //   標準コントローラを渡してインスタンス化する
            JP_CopyQuotationController extController = new JP_CopyQuotationController(stdController);

            // 5.コントローラ拡張の独自メソッドを実行
            extController.setTakeoverFlgFalse();

            // 6.実行結果をテスト
            System.assertEquals(false, extController.takeoverFlg);
        }
    }

    private static testMethod void  doCopyTest(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
            // 1.コントローラを利用するvisualforceページをテスト実行時の画面として設定
            PageReference pageRef = Page.JP_CopyQuotation;
            Test.setCurrentPage(pageRef);

            // 2.画面で操作するオブジェクトを生成
            JP_QuotationHeader__c obj = JP_TestUtil.Create_JP_QuotationHeaderForTrigger(-5);

            // 3.標準コントローラを生成
            //   オブジェクトを渡してインスタンス化する
            ApexPages.StandardController stdController = new ApexPages.StandardController(obj);

            // 4.コントローラ拡張を生成
            //   標準コントローラを渡してインスタンス化する
            JP_CopyQuotationController extController = new JP_CopyQuotationController(stdController);

            // 5.コントローラ拡張の独自メソッドを実行
            extController.setTakeoverFlgTrue();
            extController.doCopy();
        }
    }
}