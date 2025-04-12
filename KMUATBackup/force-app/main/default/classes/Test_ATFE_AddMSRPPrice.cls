@isTest(SeeAllData=true)
private class Test_ATFE_AddMSRPPrice {
    /*
    
        The following method is used for testing "ATFE_AddMSRPPriceBook"
   
    static testMethod void TestMSRPPrice() {
        User testSystemAdmin = ATFE_TestMethodUtility.getTestUserWithProfileAndRole('System Administrator', 'ATI');
        insert testSystemAdmin;
        
        User testSalesUser = ATFE_TestMethodUtility.getTestUserWithProfileAndRole('Sales User', 'NA Sales');
        insert testSalesUser;
        
        Account acc = new Account(Name = 'TestAccount',BillingCountry='USA',BillingCity='San Jose',BillingStreet='3200 North 1st Street',BillingState='New York',BillingPostalCode='94153',ATFE_AccountType__c ='End Customer', RecordTypeId= '01220000000HctC' , ATFE_Partner_Type__c ='Distributor', OwnerId = testSalesUser.Id );
        System.runAs(testSystemAdmin) {
            insert acc ;
            acc.OwnerId = testSalesUser.Id;
            update acc;
        }       
        
        System.runAs(testSalesUser) {
            Pricebook2 stdPb = [select IsActive,Id,Name from Pricebook2 where isStandard = true limit 1];
            Account accAfterInsert = [SELECT Id, Name, BillingCountry, ATFE_Price_Book__c FROM Account WHERE Id = :acc.Id];
            System.debug('AccId'+acc.id);
            Opportunity opp = new Opportunity(name ='TestOpp', StageName ='01 - Qualify',AccountId = acc.id,CloseDate = System.today().addDays(2));
            insert opp ;
            ATFE_QuoteCloneWithProducts.byPassQuoteTrigger = true ;
            System.debug('stdPb Id :'+stdPb.id);
            Product2 product1 = new Product2(Name='TestProduct1',IsActive = true, ATFE_NA__c = true);
            insert product1 ;
       
            PricebookEntry pbe = new PricebookEntry(pricebook2id = stdPb.id, product2id = product1.id, UnitPrice = 100.0, isActive = true,UseStandardPrice = false);
            insert pbe;
            
            Quote quo1 = new Quote(Pricebook2Id = stdPb.id, OpportunityId = opp.id, Name ='TestQuoe',ATFE_Partner_Name__c = acc.id);
            insert quo1;
            
            Quote quoteAfterInsert = [SELECT ATFE_Partner_Name__c, Pricebook2Id, OpportunityId FROM Quote WHERE Id = :quo1.Id LIMIT 1];
            System.debug('Quote stdPb Id :'+[select Pricebook2Id from Quote where id =: quo1.id ].Pricebook2Id);
            QuoteLineItem qli = new QuoteLineItem(UnitPrice = 50.0,ATFE_MSRP__c = 10.0, QuoteId = quoteAfterInsert.id, Quantity = 2, PricebookEntryId = pbe.id  ,
            PriceBook_Price_Amount__c = 100);
            insert qli ;  
            System.assertEquals(100.0,[select ATFE_MSRP__c from QuoteLineItem where id =:qli.id].ATFE_MSRP__c);      
        }
    }
    
        The following testmethod for testing code "ATFE_UpdatePricebookNA"
    
    static testMethod void TestUpdatePriceBook() {
        
        User testSystemAdmin = ATFE_TestMethodUtility.getTestUserWithProfileAndRole('System Administrator', 'ATI');
        insert testSystemAdmin;
        
        User testSalesUser = ATFE_TestMethodUtility.getTestUserWithProfileAndRole('Sales User', 'NA Sales');
        insert testSalesUser;
        
        Pricebook2 customPb = new Pricebook2(IsActive = true,Name ='Test PriceBook');
        Pricebook2 stdPb = [select IsActive,Id,Name from Pricebook2 where isStandard = true limit 1];
        Account acc = new Account(Name = 'TestAccount',BillingCountry='USA',BillingCity='San Jose',BillingStreet='3200 North 1st Street',BillingState='New York',BillingPostalCode='94153',ATFE_AccountType__c ='End Customer', RecordTypeId= '01220000000HctC' , ATFE_Partner_Type__c ='Distributor', Sub_Region__c = 'NA' );
        
        System.runAs(testSystemAdmin) {
            insert customPb ;
            //acc.ATFE_Price_Book__c = customPb.Id; 
            insert acc ;
            acc.OwnerId = testSalesUser.Id;
            update acc;
        }       
        
        System.runAs(testSalesUser) {
        
            //Account acc = new Account(Name = 'TestAccount',BillingCountry='USA',BillingCity='San Jose',BillingStreet='3200 North 1st Street',BillingState='New York',BillingPostalCode='94153',ATFE_AccountType__c ='End Customer', RecordTypeId= '01220000000HctC' , ATFE_Partner_Type__c ='Distributor' );
            //insert acc ;
            Account accAfterInsert = [SELECT Id, Name, BillingCountry, ATFE_Price_Book__c FROM Account WHERE Id = :acc.Id];
            System.debug('AccId'+acc.id);
            Opportunity opp = new Opportunity(name ='TestOpp', StageName ='01 - Qualify',AccountId = acc.id,CloseDate = System.today().addDays(2), PriceBook2Id = customPb.Id);
            insert opp ;
            System.debug('customPb Id :'+customPb.id);
            Product2 product1 = new Product2(Name='TestProduct1',IsActive = true, ATFE_NA__c = true);
            insert product1 ;
       
            PricebookEntry pbe = new PricebookEntry(pricebook2id = stdPb.id, product2id = product1.id, UnitPrice = 100.0, isActive = true,UseStandardPrice = false);
            insert pbe;
            
            Quote quo1 = new Quote(OpportunityId = opp.id, Name ='TestQuoe',ATFE_Partner_Name__c = acc.id);
            
            insert quo1 ;
            System.assertEquals('NA DIRECT (USD)', [select Pricebook2.Name from Quote where id =: quo1.id ].Pricebook2.Name);
        }
    }
     */
}