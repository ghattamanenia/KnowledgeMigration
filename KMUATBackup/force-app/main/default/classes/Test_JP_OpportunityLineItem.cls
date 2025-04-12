/**
 * TestClass JP_OpportunityLineItem
 */

@IsTest
private class Test_JP_OpportunityLineItem{
    static testMethod void test01(){

        // テスト用データ作成
        PriceBookEntry pbe = JP_TestUtil.CreateProduct();      // 価格表と商品作成
        Opportunity opp = JP_TestUtil.Create_Opportunity();    // 商談作成
        JP_TestUtil.CreateOpportunityLineItem(opp.Id, pbe.Id); // 商談商品1作成
        JP_TestUtil.CreateOpportunityLineItem(opp.Id, pbe.Id); // 商談商品2作成　※商談商品2件以上のときに通るコードがあったので2を作成

        Test.startTest();  // startとstopの間がガバナ制限カウント対象になる。(テスト用データを作成したコードはカウント対象外)

        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(opp);  // Standardcontrollerに作成した商談を設定
        JP_OpportunityLineItem ConClass = new JP_OpportunityLineItem(sc);  // ApexにStandardcontrollerを渡して実行

        Test.stopTest();
        
    }

}