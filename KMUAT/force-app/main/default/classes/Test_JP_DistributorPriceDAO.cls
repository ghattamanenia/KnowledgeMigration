/**
 * JP_DistributorPriceDAOのテストクラス
 */
@isTest
private class Test_JP_DistributorPriceDAO {
    /**
     * selectForQuotationEditメソッドのテストケース
     */
    private static testMethod void testSelectForQuotationEdit() {
        // テストデータ作成
        List<JP_DistributorPrice__c> dpList = JP_TestUtil.Create_JP_DistributorPrice(1);
        JP_DistributorPrice__c dp = dpList.get(0);
        dp.JP_ProductCatalogCode__c = 'testcode';
        dp.JP_Price_List_Type__c = 'A';
        dp.JP_PriceYearMonth__c = '2015年8月';
        dp.JP_OutputableQuotation__c = true;
        dp.JP_SearchItemKey1__c = dp.JP_Price_List_Type__c + '_' + dp.JP_ProductCatalogCode__c;
        dp.JP_SearchItemKey2__c = dp.JP_Price_List_Type__c + '_' + dp.JP_PriceYearMonth__c;
        dp.JP_WholeSaleKey__c = dp.JP_Price_List_Type__c + '_' + dp.JP_ProductCatalogCode__c + '_' + dp.JP_PriceYearMonth__c;
        insert dpList;

        // テスト開始
        Test.startTest();
        System.assertEquals(1, JP_DistributorPriceDAO.selectForQuotationEdit(new Set<String>{dp.JP_ProductCatalogCode__c}, dp.JP_Price_List_Type__c, dp.JP_PriceYearMonth__c).size());
        Test.stopTest();
    }

    /**
     * selectListForProductSearchメソッドのテストケース
     *
     **/
    private static testMethod void testSelectListForProductSearch(){
        // テストデータ作成
        String priceListType = 'TD';
        String priceYearMonth = 'testYM';
        String productCatalogCode = 'testCode';
        String category1 = 'testCate1';
        String category2 = 'testCate2';
        String productName = 'testName';


        List<JP_DistributorPrice__c> dpList = JP_TestUtil.Create_JP_DistributorPrice(1);
        JP_DistributorPrice__c dp = dpList.get(0);
        dp.JP_ProductCatalogCode__c = productCatalogCode;
        dp.JP_ProductName__c = productName;
        dp.JP_Price_List_Type__c = priceListType;
        dp.JP_PriceYearMonth__c = priceYearMonth;
        dp.JP_Category1__c = category1;
        dp.JP_Category2__c = category2;
        dp.JP_SearchItemKey1__c = priceListType + '_' + productCatalogCode;
        dp.JP_SearchItemKey2__c = priceListType + '_' + priceYearMonth;
        dp.JP_OutputableQuotation__c = true;
        insert dpList;

        List<JP_DistributorPrice__c> resultList = new List<JP_DistributorPrice__c>();
        

        Test.startTest();
        resultList = JP_DistributorPriceDAO.selectListForProductSearch(dp, priceListType, priceYearMonth);
        Test.stopTest();

        System.assertEquals(1 , resultList.size());

     }
    /**
     * getDistributorPriceByAEメソッドのテストケース
     *
     **/
    private static testMethod void testgetDistributorPriceByAE(){
        // テストデータ作成
        JP_DistributorPrice__c distributorPrice = new JP_DistributorPrice__c(JP_WholeSaleKey__c= 'Test', JP_ProductCatalogCode__c = 'TestCatalogCode',JP_Price_List_Type__c = 'AE', JP_WholeSalePrice__c= 100);
        insert distributorPrice;
        Set<String> ProductCatalogCodeSet = new Set<String>();
        ProductCatalogCodeSet.add('TestCatalogCode');



       List<JP_DistributorPrice__c> resultList = new List<JP_DistributorPrice__c>();
       
       Map<String,Decimal> distributorPriceMap;
       Test.startTest();
       distributorPriceMap = JP_DistributorPriceDAO.getDistributorPriceByAE(ProductCatalogCodeSet);
       Test.stopTest();

       System.assertEquals(1 , distributorPriceMap.size());

    }

}