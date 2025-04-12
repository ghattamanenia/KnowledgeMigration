@isTest
public class OpportunityTriggerHandlerTest
{
    public static testmethod void OpptyStageValidation()
    {
        user u = new user();
        u=[select id from user where profile.name='System Administrator' and isactive=true limit 1];
        
       // Channelinsight.CI_TEST_TestUtils.createBaseInstallData();Neha commented for model n package uninstallation
        // Create Account
        Account ac = new Account();
        ac.Name='Test Account';
        ac.ATFE_Active__c=true;
        ac.Region__c='NA';
        ac.Sub_Region__c='USA';
        ac.ATFE_AccountType__c='End Customer';
        ac.ATFE_SalesOrgName__c='Aviation-Defense-Federal';
        ac.Partner_Status__c='Silver';
        ac.ATFE_VerticalMarketInit__c='Government';
        ac.Website='www.csc.com';
        insert ac;
        system.debug('@@@@ac'+ac.Id);
        // Create Opportunity
        
         list<Pricebook2> pb = new list<Pricebook2>();
        // pb=[select id,Name from Pricebook2 where Name='APAC DIST (USD)'];
        
        opportunity opp = new Opportunity();
        opp.Name='Test oppty';
        opp.ATFE_Opportunity_Type__c='Standard';
        opp.AccountId=ac.Id;
        opp.CloseDate=system.today();
        opp.Required_Delivery_Date__c=system.today()+1;
        opp.ATFE_Solution_Application__c='Enterprise: IP Video Surveillance';
        opp.ATFE_Competitor__c='Not Applicable';
        opp.ATFE_Fulfillment__c='Direct';
        //opp.stageName='Final Negotiation/Review';
         opp.stageName='Engagement/Value Proposition';
        opp.ForecastCategoryName='Best Case';
        // opp.pricebook2Id=pb[0].Id;
        opp.CurrencyIsoCode='USD';
        system.runas(u){
        insert opp;}
        
         list<SBQQ__Quote__c> Quotes = new list<SBQQ__Quote__c>();
         Quotes.add(new SBQQ__Quote__c(ATFE_SPQ_Approved__c=true,SBQQ__Opportunity2__c=opp.Id,SBQQ__Account__c=ac.Id,SBQQ__ExpirationDate__c=system.today()-2,SBQQ__Primary__c=true));
         Quotes.add(new SBQQ__Quote__c(ATFE_SPQ_Approved__c=true,SBQQ__Opportunity2__c=opp.Id,SBQQ__Account__c=ac.Id,SBQQ__ExpirationDate__c=system.today()-2));
         Quotes.add(new SBQQ__Quote__c(ATFE_SPQ_Approved__c=true,SBQQ__Opportunity2__c=opp.Id,SBQQ__Account__c=ac.Id,SBQQ__ExpirationDate__c=system.today()-2));
         insert Quotes;
         
         opp.stageName='Booking (Forecast)';
         try
         {
             update opp;
         }catch(exception e){}
         
         
        
        
        
        
        
        
        
        
        
        
        
    }
}