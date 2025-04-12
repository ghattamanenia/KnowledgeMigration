@isTest(SeeAllData=true)
public class ATFE_ChangeQuoteQuicklyRecordTypeTest
{
    public static testmethod void testm()
    {
        user u = new user();
        u=[select id from user where profile.name='System Administrator' and isactive=true limit 1];
        
        //Channelinsight.CI_TEST_TestUtils.createBaseInstallData();
        // Create Account
        Account ac = new Account();
        ac.Name='Test Account';
        ac.ATFE_Active__c=true;
        ac.Region__c='NA';
        ac.Sub_Region__c='USA';
        ac.ATFE_AccountType__c='End Customer';
        ac.ATFE_SalesOrgName__c='Aviation-Defense-Federal';
        //ac.Partner_Status__c='Silver';
        ac.ATFE_VerticalMarketInit__c='Government';
        ac.Website='www.csc.com';
        UtilSODOFlags.skip_caseTrigges=TRUE;
        insert ac;
        system.debug('@@@@ac'+ac.Id);
        // Create Opportunity
        
         list<Pricebook2> pb = new list<Pricebook2>();
        pb=[select id,Name from Pricebook2 where Name='APAC DIST (USD)'];
        
        opportunity opp = new Opportunity();
        opp.Name='Test oppty';
        opp.ATFE_Opportunity_Type__c='Standard';
        opp.AccountId=ac.Id;
        opp.CloseDate=system.today();
        opp.Required_Delivery_Date__c=system.today()+1;
        opp.ATFE_Solution_Application__c='Enterprise: IP Video Surveillance';
        opp.ATFE_Competitor__c='Not Applicable';
        opp.ATFE_Fulfillment__c='Direct';
        // opp.stageName='Final Negotiation/Review';
        opp.stageName='Engagement/Value Proposition';
        opp.ForecastCategoryName='Best Case';
        opp.pricebook2Id=pb[0].Id;
        opp.CurrencyIsoCode='USD';
        system.runas(u){
        insert opp;}
        // Create Product
        list<Product2> products = new list<Product2>();
        products.add(new Product2(Name='Test Product1'));
        products.add(new Product2(Name='Test Product2'));
        insert products;
        
        // Create price book entry
       
        
        Pricebook2 standardPB = new Pricebook2();
        standardPB=[select id from Pricebook2 where isStandard=true];
        
        list<PricebookEntry> standardPrice = new list<PricebookEntry>();
        standardPrice.add(new PricebookEntry(Pricebook2Id = standardPB.Id, CurrencyIsoCode='USD', Product2Id =products[0].Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false));
        standardPrice.add(new PricebookEntry(Pricebook2Id = standardPB.Id, CurrencyIsoCode='USD', Product2Id =products[1].Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false));
        insert standardPrice;
        
        system.debug('@@@@@@@pb'+pb[0]);
        system.debug('@@@@@@Products[0].Id'+Products[0].Id);
        system.debug('@@@@@Products[1].Id'+Products[1].Id);
        
        list<Pricebookentry> pricebookentries = new list<Pricebookentry>();
        pricebookentries.add(new Pricebookentry(UnitPrice=2000,Pricebook2Id=pb[0].id,Product2Id=products[0].Id,IsActive=true,UseStandardPrice = false));
        pricebookentries.add(new Pricebookentry(UnitPrice=3000,Pricebook2Id=pb[0].id,Product2Id=products[1].Id,IsActive=true,UseStandardPrice = false));
        
        insert pricebookentries;
        
        
        // Create Opportunity Line Items
        
        List<OpportunityLineItem> OppLineItems = new list<OpportunityLineItem>();
        OppLineItems.add(new OpportunityLineItem(OpportunityId=opp.Id,Product2Id=Products[0].Id,Quantity=3,TotalPrice=1000));
        OppLineItems.add(new OpportunityLineItem(OpportunityId=opp.Id,Product2Id=Products[1].Id,Quantity=4,TotalPrice=2000));
        
        system.runas(u)
        {
            insert OppLineItems;
        }
        
        
        // Create Quote
        
        Schema.DescribeSObjectResult quoteDescribe = Schema.SObjectType.SBQQ__Quote__c; 
        Map<String,Schema.RecordTypeInfo> quoteRtMapByName = quoteDescribe.getRecordTypeInfosByName();
        string quoteBeforeRTId =  quoteRtMapByName.get('ATFE_Quote Before Approval').getRecordTypeId();
        string quoteAfterRTId =  quoteRtMapByName.get('ATFE_Quote After Approval').getRecordTypeId();
        
         list<SBQQ__Quote__c> Quotes = new list<SBQQ__Quote__c>();
         Quotes.add(new SBQQ__Quote__c(ATFE_SPQ_Approved__c=true,SBQQ__Opportunity2__c=opp.Id,SBQQ__Account__c=ac.Id,RecordTypeId=quoteAfterRTId,SBQQ__ExpirationDate__c=system.today()));
         Quotes.add(new SBQQ__Quote__c(ATFE_SPQ_Approved__c=true,SBQQ__Opportunity2__c=opp.Id,SBQQ__Account__c=ac.Id,RecordTypeId=quoteAfterRTId,SBQQ__ExpirationDate__c=system.today()));
         Quotes.add(new SBQQ__Quote__c(ATFE_SPQ_Approved__c=true,SBQQ__Opportunity2__c=opp.Id,SBQQ__Account__c=ac.Id,RecordTypeId=quoteAfterRTId,SBQQ__ExpirationDate__c=system.today()));
         insert Quotes;
         
        
        // Create Quote Line Items
        
        List<SBQQ__QuoteLine__c> QuoteLinesToCreate = new list<SBQQ__QuoteLine__c>();
        QuoteLinesToCreate.add(new SBQQ__QuoteLine__c(SBQQ__Product__c=Products[0].Id,SBQQ__Quantity__c=200,MSRP_Price__c=5008,SBQQ__Quote__c=Quotes[0].Id));
        QuoteLinesToCreate.add(new SBQQ__QuoteLine__c(SBQQ__Product__c=Products[0].Id,SBQQ__Quantity__c=200,MSRP_Price__c=5090,SBQQ__Quote__c=Quotes[1].Id));
        QuoteLinesToCreate.add(new SBQQ__QuoteLine__c(SBQQ__Product__c=Products[1].Id,SBQQ__Quantity__c=200,MSRP_Price__c=5007,SBQQ__Quote__c=Quotes[1].Id));
        QuoteLinesToCreate.add(new SBQQ__QuoteLine__c(SBQQ__Product__c=Products[0].Id,SBQQ__Quantity__c=200,MSRP_Price__c=5005,SBQQ__Quote__c=Quotes[0].Id));
        QuoteLinesToCreate.add(new SBQQ__QuoteLine__c(SBQQ__Product__c=Products[0].Id,SBQQ__Quantity__c=200,MSRP_Price__c=50005,SBQQ__Quote__c=Quotes[0].Id));
        QuoteLinesToCreate.add(new SBQQ__QuoteLine__c(SBQQ__Product__c=Products[0].Id,SBQQ__Quantity__c=200,MSRP_Price__c=5003,SBQQ__Quote__c=Quotes[0].Id));
        QuoteLinesToCreate.add(new SBQQ__QuoteLine__c(SBQQ__Product__c=Products[0].Id,SBQQ__Quantity__c=200,MSRP_Price__c=5002,SBQQ__Quote__c=Quotes[0].Id));
        QuoteLinesToCreate.add(new SBQQ__QuoteLine__c(SBQQ__Product__c=Products[0].Id,SBQQ__Quantity__c=200,MSRP_Price__c=5002,SBQQ__Quote__c=Quotes[0].Id));
        
        insert QuoteLinesToCreate;
        
        ATFE_ChangeQuoteQuicklyRecordType qqr = new ATFE_ChangeQuoteQuicklyRecordType();
        qqr.execute(null);
        
        
    }
 }