/**
 * JP_PriceYearMonthDAOクラスのテストクラス
 */
@isTest
private class Test_JP_PriceYearMonthDAO {
    
    /**
     * selectFromPreviousMonthメソッドのテストケース
     */
    @isTest static void test_selectFromPreviousMonth() {
        // テストデータ作成
        JP_PriceYearMonth__c pym = JP_TestUtil.Create_JP_PriceYearMonth(1).get(0);
        pym.JP_Price_List_Type__c = '01';
        String yearMonth = String.valueOf(Date.today().addMonths(-1).year()) + '/' + String.valueOf(Date.today().addMonths(-1).month()).leftPad(2, '0');
        pym.JP_PriceYearMonth__c = 'JP ' + yearMonth;
        insert pym;

        // テスト開始
        Test.startTest();
        System.assertEquals(1, JP_PriceYearMonthDAO.selectFromPreviousMonth(pym.JP_Price_List_Type__c).size());
        Test.stopTest();
    }

}