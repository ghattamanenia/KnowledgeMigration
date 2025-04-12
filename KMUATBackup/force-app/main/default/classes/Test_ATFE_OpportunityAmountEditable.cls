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
private class Test_ATFE_OpportunityAmountEditable {

    static testMethod void myUnitTest() {
    
   // Channelinsight.CI_TEST_TestUtils.createBaseInstallData(); Neha commented for model n package uninstallation
        
        Opportunity objOpp = new Opportunity();
        objOpp.Name = 'Test Opp1';
        objOpp.StageName = 'Test Stage';
        objOpp.closedate = Date.today();
        objOpp.Required_Delivery_Date__c=system.today().adddays(3);
        objOpp.ATFE_ReasonWonLostCode__c='Loss';
        Insert objOpp ;
        
        objOpp.Probability = 25;
        update objOpp;
        
        User user = [SELECT Id, Name FROM User WHERE Name like 'NA%' AND isActive = True limit 1];
        //System.RunAs(user)
        //{
            Opportunity objOpp2 = new Opportunity();
            objOpp2.Name = 'Test Opp2';
            objOpp2.StageName = 'Prospect/Qualification';
            objOpp2.closedate = Date.today();
            objOpp2.Required_Delivery_Date__c=system.today().adddays(3);
            objOpp2.ATFE_ReasonWonLostCode__c='Loss';
            Insert objOpp2 ;
            
            objOpp2.StageName = 'Test Stage';
            update objOpp2;
        //}
    }
}