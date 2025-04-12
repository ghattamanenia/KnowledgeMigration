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
private class Test_ATFE_NewChildOpportunity {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        Opportunity opp = [SELECT Id, Name, CloseDate, StageName, Probability, Type, ForecastCategoryName, ATFE_Components__c,
            ATFE_Application__c, ATFE_ApprovalHierarchy__c, ATFE_Fulfillment__c, OwnerId, ATFE_ChildOpportunityPricebook__c, RecordTypeId
            FROM Opportunity LIMIT 1];
        Opportunity mopp = [SELECT Id, Name FROM Opportunity LIMIT 1];
        Account acc = [SELECT id, Name FROM Account LIMIT 1];
        
        ApexPages.StandardController  setCon = new ApexPages.StandardController(opp);
        
        //Create the object
        ATFE_NewChildOpportunity childOpp = new ATFE_NewChildOpportunity(setCon);
        
        
        //Set variables
        //childOpp.AccountName = acc.Name;
        childOpp.AccountNameId = acc.Id;
        childOpp.OpportunityName = opp.Name;
        childOpp.CloseDate = opp.CloseDate;
        childOpp.Stage = opp.StageName;
        childOpp.Probability = opp.Probability;
        childOpp.ForecastCategoryName = opp.ForecastCategoryName;
        childOpp.Components = opp.ATFE_Components__c;
        childOpp.ApprovalHierarchy = opp.ATFE_ApprovalHierarchy__c;
        childOpp.Fulfillment = opp.ATFE_Fulfillment__c;
        childOpp.OwnerID = opp.OwnerId;
        childOpp.ChildPriceBook = opp.ATFE_ChildOpportunityPricebook__c;
        childOpp.ChildRecordType = opp.RecordTypeId;
        childOpp.MasterOpportunityID = mopp.Id;
        
        childOpp.save();
        
        //Change Project Type
        //childOpp.ProjectType = 'ENT';
        
        //childOpp.save();
        
    }
}