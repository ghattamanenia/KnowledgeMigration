@isTest(seealldata=true)
global class OpptyLineItemsRestControllerTest
{
    global static testmethod void meth()
    {
        Test.startTest();
        user u = new user();
        u=[select id from user where profile.name='System Administrator' and isactive=true limit 1];
        
       
        // Create First Account
        Account ac = new Account();
        ac.Name='Test Account';
        ac.ATFE_Active__c=true;
        ac.Region__c='APAC';
        ac.Sub_Region__c='Australia';
        ac.ATFE_AccountType__c='End Customer';
        ac.ATFE_SalesOrgName__c='Aviation-Defense-Federal';
        ac.Partner_Status__c='Silver';
        ac.ATFE_VerticalMarketInit__c='Government';
        ac.Website='www.csc.com';
        insert ac;
        system.debug('@@@@ac'+ac.Id);
        
        // Create Second Account
        Account ac1 = new Account();
        ac1.Name='Test Account';
        ac1.ATFE_Active__c=true;
        ac1.Region__c='APAC';
        ac1.Sub_Region__c='Australia';
        ac1.ATFE_AccountType__c='End Customer';
        ac1.ATFE_SalesOrgName__c='Aviation-Defense-Federal';
        ac1.Partner_Status__c='Silver';
        ac1.ATFE_VerticalMarketInit__c='Government';
        ac1.Website='www.csc.com';
        insert ac1;
        system.debug('@@@@ac'+ac1.Id);
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
        opp.Special_Opportunity__c=true;
        opp.ForecastCategoryName='Best Case';
        opp.pricebook2Id=pb[0].Id;
        opp.CurrencyIsoCode='USD';
        opp.Nextstep='Testing Step';
        system.runas(u){
        insert opp;}
        system.debug('@@@opp.Nextstep'+opp.Nextstep);
        // Create Partner Account
        AccountPartner ap = new AccountPartner();
        // ap.AccountFromId=ac.Id;
        ap.AccountToId=ac1.Id;
        ap.Role='Distributor';
        ap.OpportunityId=opp.Id;
        insert ap;
        
        OpportunityPartner OPartner= new OpportunityPartner();
        OPartner.isprimary=true;
        OPartner.Role='Distributor';
        OPartner.OpportunityId=opp.Id;
        OPartner.AccountToId=ac1.Id;
        insert OPartner; 
        
        // Create Product
        list<Product2> products = new list<Product2>();
        products.add(new Product2(Name='Test Product1',ATFE_ProdAvailCode__c='EOS'));
        products.add(new Product2(Name='Test Product2'));
        insert products;
        update products;
        
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
        
         
        datetime dt1 = Datetime.newInstanceGmt(datetime.now().year(), datetime.now().month(), datetime.now().day()-3, datetime.now().hour(), datetime.now().minute(), datetime.now().second()); 
        datetime dt2 = Datetime.newInstanceGmt(datetime.now().year(), datetime.now().month(), datetime.now().day()+5, datetime.now().hour(), datetime.now().minute(), datetime.now().second());
        system.debug('@@@dt1'+dt1);
        system.debug('@@@dt2'+dt2);
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeDateTimeField('startDateTime', dt1);
        gen.writeDateTimeField('endDateTime', dt2);
        gen.writeEndObject();
        String JsonStr= gen.getAsString();
        
        RestRequest request = new RestRequest();
        request.requestUri =TestDataUtility.OpptyLineItemsRestControllerURL;
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(JsonStr);
        RestContext.request = request;
        
        list<OpptyLineItemsWapper> OpptyLineWraps = OpptyLineItemsRestController.doPost(dt1,dt2);
        
         
        Test.stoptest();
        
        
        
    }
}