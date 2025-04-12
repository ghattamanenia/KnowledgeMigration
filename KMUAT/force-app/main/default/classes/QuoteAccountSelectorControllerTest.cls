@isTest
public class QuoteAccountSelectorControllerTest
{
    public static testmethod void testm()
    {
        Test.StartTest();
        RecordType recType = new RecordType();
        recType=[Select Id,Name from RecordType where Name='ATI Accounts'];
        //Channelinsight.CI_TEST_TestUtils.createBaseInstallData();  Neha commented for model n package uninstallation
        
        // Create Account
        
        Account acc = new Account();
        acc.Name='Test Account';
        acc.Region__c='NA';
        acc.ATFE_AccountType__c='End Customer';
        acc.ATFE_VerticalMarketInit__c='Defense';
        acc.Website='www.hotmail.com';
        acc.RecordTypeId=recType.Id;
        acc.Sub_Region__c='USA';
        acc.ATFE_SalesOrgName__c='Channel';
       // acc.ATFE_Partner_Type__c='Consultant';
        
        
        insert acc;
        
        system.debug('@@@@@@@acc.Price Book in test class'+acc.ATFE_Price_Book__c);
        system.debug('@@@@@@@acc.ATFE_Partner_Type__c in test class'+acc.ATFE_Partner_Type__c);
        
        

        
        // Create Account
        
        Account acc1 = new Account();
        acc1.Name='Test Account';
        acc1.Region__c='NA';
        acc1.ATFE_AccountType__c='End Customer';
        acc1.ATFE_VerticalMarketInit__c='Defense';
        acc1.Website='www.hotmail.com';
        acc1.RecordTypeId=recType.Id;
        insert acc1;
        
        // Create Opportunity
        
        RecordType recOppType = new RecordType();
        recOppType=[Select Id,Name from RecordType where Name='ATI Opportunity'];
        
        Opportunity Opp = new Opportunity();
        opp.recordtypeid=recOppType.id;
        opp.AccountId=acc.Id;
        opp.Name='Test Opportunity';
        opp.ATFE_Solution_Application__c='Business to Consumer (B2C)';
        opp.ATFE_Opportunity_Type__c='Standard';
        opp.closedate=system.today()+2;
        opp.StageName='Prospect/Qualification';
        opp.ForecastCategoryName='Pipeline';
        opp.ATFE_Competitor__c='Aerohive';
        opp.ATFE_Fulfillment__c='Direct';
        opp.Required_Delivery_Date__c=system.today()+3;
        
        insert opp;
        
       // Create Quote
        
        Schema.DescribeSObjectResult quoteDescribe = Schema.SObjectType.SBQQ__Quote__c; 
        Map<String,Schema.RecordTypeInfo> quoteRtMapByName = quoteDescribe.getRecordTypeInfosByName();
        string quoteBeforeRTId =  quoteRtMapByName.get('ATFE_Quote Before Approval').getRecordTypeId();
        string quoteAfterRTId =  quoteRtMapByName.get('ATFE_Quote After Approval').getRecordTypeId();
        
         list<SBQQ__Quote__c> Quotes = new list<SBQQ__Quote__c>();
         Quotes.add(new SBQQ__Quote__c(ATFE_SPQ_Approved__c=true,SBQQ__Opportunity2__c=opp.Id,SBQQ__Account__c=acc.Id,RecordTypeId=quoteAfterRTId,SBQQ__ExpirationDate__c=system.today()));
         Quotes.add(new SBQQ__Quote__c(ATFE_SPQ_Approved__c=true,SBQQ__Opportunity2__c=opp.Id,SBQQ__Account__c=acc.Id,RecordTypeId=quoteAfterRTId,SBQQ__ExpirationDate__c=system.today()));
         
         insert Quotes;
         
        
         OpportunityPartner opart = new OpportunityPartner();
         opart.OpportunityId=opp.Id;
         opart.AccountToId=acc1.Id;
         opart.Role='Distributor';
         opart.IsPrimary=true;
         insert opart;
         
         
         
         ApexPages.StandardController sc = new ApexPages.StandardController(Quotes[0]);
         
         QuoteAccountSelectorController qas = new QuoteAccountSelectorController(sc);
         
         ApexPages.currentPage().getParameters().put('CF00Nw0000008qsxF_lkid',Opp.Id);
         
         qas.onInit();
         
         qas.selectedAccountId=acc.Id;
         
         qas.onSelect();
         
         acc.BillingStreet='S olive';
         update acc;
         qas.onSelect();
         
         acc.BillingStreet='';
         acc.Billingstate='CA';
         update acc;
         qas.onSelect();
         
         acc.BillingStreet='S Olive';
         acc.BillingState='CA';
         update acc;
         qas.onselect();
         
         acc.BillingStreet='S Olive';
         acc.BillingState='CA';
         acc.BillingCity='LA';
         update acc;
         qas.onselect();
         
         acc.BillingStreet='S Olive';
         acc.BillingState='CA';
         acc.BillingCity='LA';
         acc.BillingCountry='United States';
         update acc;
         qas.onselect();
         Pricebook2 customPB = new Pricebook2(Name='NA DIRECT (USD)', isActive=true);
        insert customPB;
        /*
         acc.BillingStreet='S Olive';
         acc.BillingState='CA';
         acc.BillingCity='LA';
         acc.BillingCountry='United States';
         acc.BillingPostalCode='90012';
         update acc;
         qas.onselect(); */
         
          acc.BillingStreet='S Olive';
         acc.BillingState='CA';
         acc.BillingCity='LA';
         acc.BillingCountry='United States';
         acc.BillingPostalCode='90012';
         update acc;
         qas.onselect();
         qas.onCancel();          
        
        Test.StopTest();
    }
}