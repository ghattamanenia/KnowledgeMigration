/**
 *
 *　製品検索画面コントローラテストクラス
 *
 **/
@isTest
private class Test_ProductSearchController {
    private final static String SYSTEM_ADMIN = system.label.JP_SystemAdministrator_ProfileName;
    private final static String PRODUCT_NAME = 'testProductName';
    private final static String CATEGORY_1 = 'testcode1';
    private final static String CATEGORY_2 = 'testcate2';
    private final static String INPUT_PRICE_YEAR_MONTH = 'JP 2015/12';
    private final static String PRICE_LIST_TYPE = 'TL';
    private final static String PRODUCT_CODE = 'testcode';
    private final static String PARENT_DISTRIBUTOR_CD = 'OYA00010';
    private final static Integer LIST_INDEX = 0;
    private final static String PRODUCT_CATALOG_CODE = 'testCatalogCode';

    @testSetup static void setup(){

    //------------------代理店仕切価格表テストデータ----------------------------
        List<JP_DistributorPrice__c> dpList = new List<JP_DistributorPrice__c>();

        for(Integer i = 1 ; i <= 2 ; i++){

            JP_DistributorPrice__c distributorPrice = new JP_DistributorPrice__c();

            distributorPrice.Name = 'Name' + i;
            distributorPrice.JP_Category1__c = CATEGORY_1;
            distributorPrice.JP_Category2__c = CATEGORY_2;
            distributorPrice.JP_OutputableQuotation__c = true;
            distributorPrice.JP_PriceYearMonth__c = INPUT_PRICE_YEAR_MONTH;
            distributorPrice.JP_Price_list_type__c = PRICE_LIST_TYPE;
            distributorPrice.JP_ProductCatalogCode__c = PRODUCT_CATALOG_CODE +i;
            distributorPrice.JP_ProductCode__c = PRODUCT_CODE ;
            distributorPrice.JP_ProductName__c = PRODUCT_NAME;
            distributorPrice.JP_SearchItemKey1__c =  PRICE_LIST_TYPE + '_' + PRODUCT_CATALOG_CODE +i;
            distributorPrice.JP_SearchItemKey2__c = PRICE_LIST_TYPE + '_' + INPUT_PRICE_YEAR_MONTH;
            distributorPrice.JP_IsSpecialDistributorProduct__c = true;
            distributorPrice.JP_PiStock__c = true;
            distributorPrice.JP_WholeSaleKey__c = String.valueOf(1+i) ;
            distributorPrice.JP_CampaignStartDate__c = String.valueOf(System.today());

            dpList.add(distributorPrice);

        }
            insert dpList;

    //-------------------代理店専用製品コードテストデータ--------------------
            JP_TestUtil.Create_DistributorProductCode(PRODUCT_CODE);

    //---------------------------ユーザ作成--------------------------------
            Profile profile = [Select Id, Name From Profile Where Name = :SYSTEM_ADMIN Limit 1];
            User user = new User(
                      Lastname = 'tstest'
                    , Username = 'tstest@terrasky.atkk'
                    , Email = 'tstest@terrasky.atkktesting'
                    , ProfileId = profile.Id
                    , Alias = 'tstest'
                    , TimeZoneSidKey = UserInfo.getTimeZone().getID()
                    , LocaleSidKey = UserInfo.getLocale()
                    , EmailEncodingKey = 'UTF-8'
                    , LanguageLocaleKey = 'ja'
                    , JP_DeptCode__c = '00001');
            insert user;

            JP_TestUtil.Create_JP_Department();
        JP_TestUtil.Create_JP_QuotationCondition();
    }

    private static testMethod void testProductSearchController() {

        User user = [SELECT Id from User WHERE Username = 'tstest@terrasky.atkk' Limit 1];

        System.runAs(user){

            PageReference pageHeader = Page.JP_QuotationEdit;
            Test.setCurrentPage(pageHeader);

            Test.startTest();

            ProductSearchController productSearchController = new ProductSearchController();

            Test.stopTest();
        }

    }

    private static testMethod void testGetPriceYearMonthList() {

        List<SelectOption> optionList = new List<SelectOption>();

        User user = [SELECT Id from User WHERE Username = 'tstest@terrasky.atkk' Limit 1];

        System.runAs(user){

            Test.startTest();

            ProductSearchController pscont = new ProductSearchController();
            pscont.price_list_type = PRICE_LIST_TYPE;
            optionList = pscont.getPriceYearMonthList();

            Test.stopTest();
        }

        System.assertEquals(1,optionList.size());

    }

    private static testMethod void testSearchProduct_noResult(){
        ProductSearchController pscont = new ProductSearchController();
        pscont.price_list_type = PRICE_LIST_TYPE;
        pscont.productCatalogCode = PRODUCT_CATALOG_CODE ;

        JP_DistributorPrice__c distributorPrice = new JP_DistributorPrice__c();

      User user = [SELECT Id from User WHERE Username = 'tstest@terrasky.atkk' Limit 1];

        System.runAs(user){

          Test.startTest();

            pscont.searchProduct2();

          Test.stopTest();

          System.assertEquals(pscont.alertMessage ,JP_Const.ERR_MESSAGE_PRODUCT_NUMBER_IS_0);

        }

    }

    private static testMethod void testSearchProduct_haveResult(){
        ProductSearchController pscont = new ProductSearchController();
        pscont.productName = PRODUCT_NAME;
        pscont.category1 = CATEGORY_1;
        pscont.category2 = CATEGORY_2;
        pscont.inputPriceYearMonth = INPUT_PRICE_YEAR_MONTH;
        pscont.price_list_type = PRICE_LIST_TYPE;
        pscont.productCatalogCode = PRODUCT_CATALOG_CODE +'2';

      User user = [SELECT Id from User WHERE Username = 'tstest@terrasky.atkk' Limit 1];

        System.runAs(user){

            Test.startTest();

            pscont.searchProduct2();

            Test.stopTest();

        System.assertEquals(1 ,pscont.wrapList.size());

        }

    }

    private static testMethod void testAddProduct(){
      //----------------テストデータを作ります------------------
        ProductSearchController pscont = new ProductSearchController();
        pscont.inputPriceYearMonth = INPUT_PRICE_YEAR_MONTH;
        pscont.price_list_type = PRICE_LIST_TYPE;

        pscont.searchProduct2();

        for(WrapProductSearch wps : pscont.wrapList){
            wps.isChecked = true;
            wps.dp.JP_IsSpecialDistributorProduct__c = true;
            wps.dp.JP_PiStock__c = true;
        }

      //---------------------見積明細リストテストデータ----------------------
        List<JP_QuotationDetailSelect> detailList = new List<JP_QuotationDetailSelect>();
        JP_QuotationDetail__c qd = new JP_QuotationDetail__c();
        qd.JP_DetailsNo__c = 1;
        qd.JP_Sort__c = 1;
        qd.JP_Quantity__c = 1;
        qd.JP_ProductName__c = 'testproname';
        JP_QuotationDetailSelect qds = new JP_QuotationDetailSelect(qd);
        detailList.add(qds);
        
        System.assertEquals(1 ,detailList.size());

        User user = [SELECT Id from User WHERE Username = 'tstest@terrasky.atkk' Limit 1];

        System.runAs(user){

            Test.startTest();

            //PageReference pageHeader = Page.JP_QuotationEdit;
            //Test.setCurrentPage(pageHeader);

            pscont.detailList = detailList;
            pscont.addProduct();

            Test.stopTest();
        System.assertEquals(3 ,pscont.detailList.size());

        }
}


    private static testMethod void testUpdateProduct(){
    //-----------------------------テストデータ------------------------------
        ProductSearchController pscont = new ProductSearchController();

        pscont.inputPriceYearMonth = INPUT_PRICE_YEAR_MONTH;
        pscont.price_list_type = PRICE_LIST_TYPE;
        pscont.listIndex = LIST_INDEX;
        pscont.productCatalogCode = PRODUCT_CATALOG_CODE  +'2';

        pscont.searchProduct2();

        for(WrapProductSearch wps : pscont.wrapList){
            wps.isChecked = true;
            wps.dp.JP_IsSpecialDistributorProduct__c = true;
            wps.dp.JP_PiStock__c = true;
        }

    //---------------------見積明細リストテストデータ----------------------
        List<JP_QuotationDetailSelect> detailList = new List<JP_QuotationDetailSelect>();
        JP_QuotationDetail__c qd = new JP_QuotationDetail__c();
        qd.JP_DetailsNo__c = 1;
        qd.JP_Sort__c = 1;
        qd.JP_Quantity__c = 1;
        qd.JP_ProductName__c = 'testproname';
        JP_QuotationDetailSelect qds = new JP_QuotationDetailSelect(qd);
        detailList.add(qds);

        //実行前商品名検証
        System.assertEquals('testproname' ,detailList[LIST_INDEX].obj.JP_ProductName__c);

        User user = [SELECT Id from User WHERE Username = 'tstest@terrasky.atkk' Limit 1];

        System.runAs(user){

            Test.startTest();

            pscont.detailList = detailList;
            pscont.updateProduct();

            Test.stopTest();
        }

        //実行後商品名検証
        System.assertEquals(PRODUCT_NAME ,pscont.detailList[LIST_INDEX].obj.JP_ProductName__c);

    }

    private static testMethod void testSearchDistributorProductCode(){
        //----------------テストデータを作ります------------------
        ProductSearchController pscont = new ProductSearchController();
        pscont.inputPriceYearMonth = INPUT_PRICE_YEAR_MONTH;
        pscont.price_list_type = PRICE_LIST_TYPE;
        //pscont.productCode = 'testcode';
        pscont.parentDistributorCD = PARENT_DISTRIBUTOR_CD;

        pscont.searchProduct2();

        //実行前990コード検証
        System.assertEquals(1 ,pscont.codeSet.size());
        System.assertEquals(true ,pscont.codeSet.contains(PRODUCT_CODE));

        User user = [SELECT Id from User WHERE Username = 'tstest@terrasky.atkk' Limit 1];

        System.runAs(user){

            Test.startTest();

            pscont.searchDistributorProductCode();

            Test.stopTest();
        }

        //実行後代理店専用製品コード検証
        System.assertEquals(1 ,pscont.codeMap.size());
        System.assertEquals('DPC2222' ,pscont.codeMap.get(PRODUCT_CODE));

    }

    private static testMethod void testChooseAndChangeToDetailSelect_add(){
        //----------------テストデータを作ります------------------
        ProductSearchController pscont = new ProductSearchController();
        pscont.inputPriceYearMonth = INPUT_PRICE_YEAR_MONTH;
        pscont.price_list_type = PRICE_LIST_TYPE;
        pscont.parentDistributorCD = PARENT_DISTRIBUTOR_CD;

        pscont.searchProduct2();
        for(WrapProductSearch wps : pscont.wrapList){
            wps.isChecked = true;
        }

        //実行前wrapListサイズ証
        System.assertEquals(2 ,pscont.wrapList.size());

        User user = [SELECT Id from User WHERE Username = 'tstest@terrasky.atkk' Limit 1];

        System.runAs(user){

            Test.startTest();

            pscont.chooseCheckedAndChangeToDetailSelect('Add');

            Test.stopTest();
        }

        //実行後selectedListサイズ証
        System.assertEquals(2 ,pscont.selectedList.size());

    }

    private static testMethod void testChooseAndChangeToDetailSelect_update(){
        //----------------テストデータを作ります------------------
        ProductSearchController pscont = new ProductSearchController();
        List<JP_QuotationDetailSelect> detailList = new List<JP_QuotationDetailSelect>();

        pscont.inputPriceYearMonth = INPUT_PRICE_YEAR_MONTH;
        pscont.price_list_type = PRICE_LIST_TYPE;
        pscont.listIndex = LIST_INDEX;
        pscont.productCatalogCode = PRODUCT_CATALOG_CODE +'2';

        pscont.searchProduct2();
        for(WrapProductSearch wps : pscont.wrapList){
            wps.isChecked = true;
        }

        JP_QuotationDetail__c qd = new JP_QuotationDetail__c();
        JP_QuotationDetailSelect qds = new JP_QuotationDetailSelect(qd);
        detailList.add(qds);

        //実行前wrapList内商品コード検証
        System.assertEquals(PRODUCT_NAME,pscont.wrapList[0].dp.JP_ProductName__c);

        User user = [SELECT Id from User WHERE Username = 'tstest@terrasky.atkk' Limit 1];

        System.runAs(user){

            Test.startTest();

            pscont.detailList = detailList;
            pscont.chooseCheckedAndChangeToDetailSelect('Update');

            Test.stopTest();
        }

        //実行後selectedList内商品コード検証
        System.assertEquals(PRODUCT_NAME ,pscont.selectedList[0].obj.JP_ProductName__c);

    }

    private static testMethod void testSetPropaties(){
        ProductSearchController pscont = new ProductSearchController();
        Map<String, String> codeMap = new Map<String,String>();
        codeMap.put('a','a');

        JP_DistributorPrice__c dp = new JP_DistributorPrice__c();
        dp.JP_ProductName__c = PRODUCT_NAME;
        dp.JP_ProductCode__c = '';
        WrapProductSearch wps = new WrapProductSearch(dp);

        JP_QuotationDetail__c qd = new JP_QuotationDetail__c();
        qd.JP_ProductName__c = '';
        qd.JP_CampaignDecision__c = true;

        User user = [SELECT Id from User WHERE Username = 'tstest@terrasky.atkk' Limit 1];
        JP_QuotationDetailSelect qds;

        System.runAs(user){

            Test.startTest();

            pscont.codeMap = codeMap;
            qds = pscont.setPropaties(qd, wps);

            Test.stopTest();
        }

        //実行後selectedList内商品コード＆キャンペーンフラグ検証
        System.assertEquals(PRODUCT_NAME ,qds.obj.JP_ProductName__c);
        System.assertEquals(false,qds.obj.JP_CampaignDecision__c);

    }

}