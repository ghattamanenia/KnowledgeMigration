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
@isTest (SeeAllData=true)
private class Test_CreateChildOpportunityPriceBook {

    static testMethod void myUnitTest() {
       Schema.DescribeSObjectResult AccDescribe = Schema.SObjectType.Account; 
       Map<String,Schema.RecordTypeInfo> AccRtMapByName = AccDescribe.getRecordTypeInfosByName();       
       Id AccRCTypeId = AccRtMapByName.get('ATI Accounts').getRecordTypeId();
      
       Schema.DescribeSObjectResult ConDescribe = Schema.SObjectType.Contact; 
       Map<String,Schema.RecordTypeInfo> ConRtMapByName = ConDescribe.getRecordTypeInfosByName();
       Id ConRCTypeId = ConRtMapByName.get('Americas Contacts').getRecordTypeId();
        // TO DO: implement unit test
        ID rt_Child_Opportunity = [SELECT Id FROM RecordType WHERE Name = 'Child Opportunity'].Id;
        //Create Dummy Account
        account acc = new Account(Name='Test Account',ATFE_AccountType__c = 'End Customer',Region__c = 'NA',Sub_Region__c = 'NA',
           ATFE_SalesOrgName__c = 'Sales Ops',website = 'www.none.com.in',RecordTypeId = AccRCTypeId,ATFE_VerticalMarketInit__c = 'Other',
           BillingCity = 'San Jose',BillingCountry = 'United States', BillingPostalCode  = '95134', BillingState = 'California',
           BillingStreet = 'Orchard Pkwy', ShippingCity = 'San Jose',ShippingCountry = 'United States', ShippingPostalCode = '95134', 
           ShippingState = 'California', ShippingStreet = 'Orchard Pkwy' );
       insert acc ;
 
                
        //Create Master Opportunity
        Opportunity masteropp = new Opportunity(Name='testOpp23', Account=acc, ATFE_Components__c='Product and Services',
            CloseDate=Date.today(),Amount = 100.00,ATFE_ApprovalHierarchy__c='North America', StageName='Prospect/Qualification', ForecastCategoryName='Pipeline', ATFE_Fulfillment__c='Direct', ATFE_EnterpriseProject__c=true,ATFE_ReasonWonLostCode__c='Loss',Required_Delivery_Date__c=system.today().adddays(3));
        insert masteropp;
        
        Opportunity opp = new Opportunity(recordtypeId = rt_Child_Opportunity,Name='testOpp', Account=acc, ATFE_Components__c='Product and Services',
            CloseDate=Date.today(),ATFE_RelatedOpportunity__c = masteropp.Id,Amount = 100.00,ATFE_ApprovalHierarchy__c='North America', StageName='Prospect/Qualification', ForecastCategoryName='Pipeline', ATFE_Fulfillment__c='Direct', ATFE_EnterpriseProject__c=true);
           //Test trigger: ChildOpportunityPriceBookCreation insert
        Test.StartTest();
        insert opp;
        
        //Get Pricebook name
        Pricebook2 pb = [select Id, Name from PriceBook2 where Name LIKE '%NA%' and IsActive=true LIMIT 1]; 
                
        //Test trigger: ChildOpportunityPriceBookCreation udpate 
      //  utility.isFutureUpdate = false;
       ATFE_utility.isFutureUpdate = false;
        opp.Pricebook2Id=pb.Id;
        opp.Amount = 200.00;
//        opp.ATFE_RelatedOpportunity__c = parentopp.Id;        
        opp.ATFE_MasterOpportunity__c=true;
        update opp;
     Test.StopTest();
        
    }
}