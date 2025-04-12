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
@isTest(Seealldata=true)
private class Test_ATFE_ClonePriceBook {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        
        Opportunity opp = [SELECT Id, Name, CloseDate, StageName, Probability, Type, ForecastCategoryName, ATFE_Components__c, ATFE_NSPProject__c, Pricebook2Id,
            ATFE_Application__c, ATFE_EnterpriseProject__c, ATFE_ApprovalHierarchy__c, ATFE_Fulfillment__c, OwnerId, ATFE_ChildOpportunityPricebook__c, RecordTypeId
            FROM Opportunity LIMIT 1];
            
        ApexPages.StandardController  setCon = new ApexPages.StandardController(opp);
        
        //Query to get a Master pricebook
        Pricebook2 pb = [SELECT Id, Name FROM Pricebook2 WHERE Name LIKE 'MasterOppPriceBook%' LIMIT 1][0];
        
        //Test: if child pricebook already exists
        ATFE_ClonePriceBook.ClonePriceBook(opp.Pricebook2Id, pb.Name, opp.id);
        //Test: else create new child pricebook
        ATFE_ClonePriceBook.ClonePriceBook(opp.Pricebook2Id, 'TestPricebook', opp.id);      
            
            
    }
}