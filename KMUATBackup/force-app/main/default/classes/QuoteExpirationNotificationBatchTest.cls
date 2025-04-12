@isTest
public class QuoteExpirationNotificationBatchTest
{
    public static testmethod void testm()
    {
        //Channelinsight.CI_TEST_TestUtils.createBaseInstallData();
        // Create Account 
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('ATI Accounts').getRecordTypeId();
        Account acc = new Account();
        acc.Name='Test Account';
        acc.RecordTypeId=devRecordTypeId;
        acc.Region__c='NA';
        acc.ATFE_AccountType__c='End Customer';
        acc.ATFE_VerticalMarketInit__c='Defense';
        acc.Website='www.csc.com';
        insert acc;
        /*
        list<Pricebook2> pb = new list<Pricebook2>();
        pb=[select id,Name from Pricebook2 where Name='APAC DIST (USD)'];
        */
        
        opportunity opp = new Opportunity();
        opp.Name='Test oppty';
        opp.ATFE_Opportunity_Type__c='Standard';
        opp.AccountId=acc.Id;
        opp.CloseDate=system.today();
        opp.Required_Delivery_Date__c=system.today()+1;
        opp.ATFE_Solution_Application__c='Enterprise: IP Video Surveillance';
        opp.ATFE_Competitor__c='Not Applicable';
        opp.ATFE_Fulfillment__c='Direct';
        // opp.stageName='Final Negotiation/Review';
        opp.stageName='Engagement/Value Proposition';
        opp.ForecastCategoryName='Best Case';
        // opp.pricebook2Id=pb[0].Id;
        opp.CurrencyIsoCode='USD';
        insert opp;
        
        
        
        // Create Quote
        
         list<SBQQ__Quote__c> Quotes = new list<SBQQ__Quote__c>();
         Quotes.add(new SBQQ__Quote__c(ATFE_SPQ_Approved__c=true,SBQQ__Opportunity2__c=opp.Id,SBQQ__Account__c=acc.Id,SBQQ__ExpirationDate__c=system.today()+3,SBQQ__Primary__c=true));
         // Quotes.add(new SBQQ__Quote__c(ATFE_SPQ_Approved__c=true,SBQQ__Opportunity2__c=opp.Id,SBQQ__Account__c=acc.Id,SBQQ__ExpirationDate__c=system.today()+1,SBQQ__Primary__c=true));
         // Quotes.add(new SBQQ__Quote__c(ATFE_SPQ_Approved__c=true,SBQQ__Opportunity2__c=opp.Id,SBQQ__Account__c=acc.Id,SBQQ__ExpirationDate__c=system.today()+2,SBQQ__Primary__c=true));
         insert Quotes;
         
         system.debug('@@@@Quotes in test class'+Quotes);
         Quotes[0].SBQQ__ExpirationDate__c=system.today()+3;
         update Quotes[0];
         
         
          
         // call the schedule class pertaining to batch class 
         
         QuoteExpirationNotificationBatchSchdl iob = new QuoteExpirationNotificationBatchSchdl ();
         iob.execute(null); 
         /*
         Id i=database.executebatch(new QuoteExpirationNotificationBatch()); */
         
    }
}