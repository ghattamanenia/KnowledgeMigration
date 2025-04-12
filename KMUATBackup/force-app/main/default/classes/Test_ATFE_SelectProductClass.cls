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
@isTest
private class Test_ATFE_SelectProductClass {

    /*static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        //PageReference pageRef = new PageReference('/apex/SelectProduct');
        PageReference pageRef = Page.ATFE_SelectProduct;
        Test.setCurrentPage(pageRef);
                
        //ApexPages.currentPage().getParameters().put('pricebook', '01s200000001sBQ');
        //ApexPages.currentPage().getParameters().put('searchText', '8000');
        
        ATFE_SelectProductClass sp = new ATFE_SelectProductClass(new ApexPages.Standardcontroller(new OpportunityLineItem()));
        //sp = new SelectProductClass();
        
        Pricebook2 pb = [SELECT Id, Name FROM Pricebook2 where Name LIKE 'NA DIST (USD)%' AND IsActive=true LIMIT 1];
        sp.pricebook = pb.Id; //01s200000001sBQAAY //01s200000001sBQAAY  //01s20000000ApuqAAC
        
        //Opportunity opp = [SELECT Id, Pricebook2Id FROM Opportunity WHERE Pricebook2Id=:pb.Id AND Name LIKE '%test%' LIMIT 1];
        Opportunity opp = [SELECT Id, Pricebook2Id FROM Opportunity WHERE id = '0062000000JjDo6'];
        sp.oppID=opp.Id;
        sp.searchText = '8000';
        sp.productQuanity=2;
        
        sp.search();
        sp.back();
        sp.getProductData();
        sp.getProducts();
        sp.dataList[0].selected=true;
        sp.next();
        sp.save();
    }*/
}