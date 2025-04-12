@isTest
public class Test_JP_ApprovalSetController {

    private static testMethod void  successTest(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
            // 1.コントローラを利用するvisualforceページをテスト実行時の画面として設定
            PageReference pageRef = Page.JP_ApprovalSet;
            Test.setCurrentPage(pageRef);

            // 2.画面で操作するオブジェクトを生成
            JP_QuotationHeader__c obj = JP_TestUtil.Create_JP_QuotationHeaderForTrigger(-5);
            obj.JP_QuotationApprovalProcessNo__c = '1';
            insert obj;

            // 3.標準コントローラを生成
            //   オブジェクトを渡してインスタンス化する
            ApexPages.StandardController stdController = new ApexPages.StandardController(obj);

            // 4.コントローラ拡張を生成
            //   標準コントローラを渡してインスタンス化する
            JP_ApprovalSetController extController = new JP_ApprovalSetController(stdController);

            // 5.コントローラ拡張の独自メソッドを実行
            extController.approvalSet();
        }
    }

    private static testMethod void  ErrorTest(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
            // 1.コントローラを利用するvisualforceページをテスト実行時の画面として設定
            PageReference pageRef = Page.JP_ApprovalSet;
            Test.setCurrentPage(pageRef);

            // 2.画面で操作するオブジェクトを生成
            JP_QuotationHeader__c obj = JP_TestUtil.Create_JP_QuotationHeaderForTrigger(-5);
            insert obj;

            // 3.標準コントローラを生成
            //   オブジェクトを渡してインスタンス化する
            ApexPages.StandardController stdController = new ApexPages.StandardController(obj);

            // 4.コントローラ拡張を生成
            //   標準コントローラを渡してインスタンス化する
            JP_ApprovalSetController extController = new JP_ApprovalSetController(stdController);

            // 5.コントローラ拡張の独自メソッドを実行
            extController.approvalSet();
        }
    }
}