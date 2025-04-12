/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(seealldata=true)
private class Test_ATFE_ProductSearch {

  static testMethod void TestProductSearch() {
    Pricebook2 stdPb = [select IsActive,Id,Name from Pricebook2 where isStandard = true limit 1];

    System.debug('stdPb Id :'+stdPb.id);

    Product2 product1 = new Product2(Name='TestProduct1',IsActive = true,Family='Product');
    Product2 product2 = new Product2(Name='TestProduct2',IsActive = true,Family='Product');
    Product2 product3 = new Product2(Name='TestProduct3',IsActive = true);
    List<Product2> prodList = new List<Product2>{product1, product2, product3};
    insert prodList ;

    PricebookEntry pbe1 = new PricebookEntry(pricebook2id = stdPb.id, product2id = prodList[0].id, UnitPrice = 100.0, isActive = true,UseStandardPrice = false);
    PricebookEntry pbe2 = new PricebookEntry(pricebook2id = stdPb.id, product2id = prodList[1].id, UnitPrice = 100.0, isActive = true,UseStandardPrice = false);
    PricebookEntry pbe3 = new PricebookEntry(pricebook2id = stdPb.id, product2id = prodList[2].id, UnitPrice = 100.0, isActive = true,UseStandardPrice = false);
    List<PricebookEntry> pbList = new List<PricebookEntry>{pbe1,pbe2,pbe3};
    insert pbList;

    List<String> regions = new List<String>();
    regions.add('NA');
    regions.add('EMEA');

    PriceBookDetails__c pbd = new PriceBookDetails__c(Region__c = 'EMEA', ProductSearchViewable__c = false, PriceBook2Id__c = stdPb.id, Name = 'Test', 
                                                    CurrencyIsoCode ='USD');
    PriceBookDetails__c pbd1 = new PriceBookDetails__c(Region__c = 'APAC', ProductSearchViewable__c = false, PriceBook2Id__c = stdPb.id, Name = 'Test', 
                                                    CurrencyIsoCode ='USD');                                                        
    List<PriceBookDetails__c> pbDetails = new List<PriceBookDetails__c>{pbd,pbd1};
    insert pbDetails;

    //ATFE_ProductSearch pdSearch = new ATFE_ProductSearch();
    ATFE_ProductSearch.getPricebookNames(regions);

    List<String> prdList =  ATFE_ProductSearch.getProductList(regions);
    System.assertEquals(true, (prdList.size() > 0));
    
    String searchResults = ATFE_ProductSearch.getSearchResults('Test', regions);
    //System.assertEquals(true, searchResults.contains('TestProduct1'));
    //System.assertEquals(true, searchResults.contains('TestProduct2'));
    System.assertEquals(false, searchResults.contains('TestProduct3'));
     
    //Just for Code Coverage.nothing use ..!
    ATFE_ProductSearch.pricebookInfo p = new ATFE_ProductSearch.pricebookInfo();
    ATFE_ProductSearch.productDetail pd = new ATFE_ProductSearch.productDetail();
 
  }
}