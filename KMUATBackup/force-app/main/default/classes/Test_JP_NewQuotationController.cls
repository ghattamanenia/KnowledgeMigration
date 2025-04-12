@isTest
public class Test_JP_NewQuotationController {

    private static testMethod void  successTest(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
            // 1.コントローラを利用するvisualforceページをテスト実行時の画面として設定
            PageReference pageRef = Page.JP_NewQuotation;
            Test.setCurrentPage(pageRef);

            // 2.画面で操作するオブジェクトを生成
            List<JP_QuotationDistributor__c> qdList = JP_TestUtil.Create_JP_QuotationDistributor();
            JP_QuotationDistributor__c obj = qdList.get(0);

            // 3.標準コントローラを生成
            //   オブジェクトを渡してインスタンス化する
            ApexPages.StandardController stdController = new ApexPages.StandardController(obj);

            // 4.コントローラ拡張を生成
            //   標準コントローラを渡してインスタンス化する
            JP_NewQuotationController extController = new JP_NewQuotationController(stdController);

            // 5.コントローラ拡張の独自メソッドを実行
            extController.QuotationCreate();
        }
    }

    private static testMethod void  ErrorTest(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
            // 1.コントローラを利用するvisualforceページをテスト実行時の画面として設定
            PageReference pageRef = Page.JP_NewQuotation;
            Test.setCurrentPage(pageRef);

            // 2.画面で操作するオブジェクトを生成
            List<JP_QuotationDistributor__c> qdList = JP_TestUtil.Create_JP_QuotationDistributor();
            JP_QuotationDistributor__c obj = qdList.get(0);
            obj.JP_QuotationCreatableFlag__c = false;
            update obj;

            // 3.標準コントローラを生成
            //   オブジェクトを渡してインスタンス化する
            ApexPages.StandardController stdController = new ApexPages.StandardController(obj);

            // 4.コントローラ拡張を生成
            //   標準コントローラを渡してインスタンス化する
            JP_NewQuotationController extController = new JP_NewQuotationController(stdController);

            // 5.コントローラ拡張の独自メソッドを実行
            extController.QuotationCreate();
        }
    }
}