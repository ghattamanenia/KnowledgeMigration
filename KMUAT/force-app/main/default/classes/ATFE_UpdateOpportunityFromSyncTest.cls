/******************************************************************************************************************************************************
        Test Method
    *********************************************************************************************************************************************************/  
    @isTest(seealldata = true) 
    Public Class ATFE_UpdateOpportunityFromSyncTest{
    static void Test_ATFE_UpdateOpportunityFromSyncedQuote(){
    /*
        Pricebook2 stdPb = [select IsActive,Id,Name from Pricebook2 where Name = 'Standardpreisbuch' limit 1];
        Account acc = new Account(Name = 'TestAccount',BillingCountry='United States',BillingCity='TestCity',BillingStreet='TestStreet',
                            BillingState='CA',Billingpostalcode='123456' );
        insert acc ;
        System.debug('AccId'+acc.id);
        Opportunity opp = new Opportunity(name ='TestOpp', StageName ='01 - Qualify',AccountId = acc.id,CloseDate = System.today().addDays(2),ATFE_ReasonWonLostCode__c='Loss',Required_Delivery_Date__c=System.today().addDays(3));
        insert opp ;
        
        System.debug('stdPb Id :'+stdPb.id);
        Product2 product1 = new Product2(Name='TestProduct1',IsActive = true);
        insert product1 ;
   
        PricebookEntry pbe = new PricebookEntry(pricebook2id = stdPb.id, product2id = product1.id, UnitPrice = 100.0, isActive = true,UseStandardPrice = false);
        insert pbe;
        
        Quote quo1 = new Quote(Pricebook2Id = stdPb.id, OpportunityId = opp.id, Name ='TestQuoe');
        
        insert quo1 ;
        System.debug('Quote stdPb Id :'+[select Pricebook2Id from Quote where id =: quo1.id ].Pricebook2Id);
        opp.SyncedQuoteId = quo1.Id;
        update opp ;
        list<Quote> Qs = new list<Quote>();
        opp = [select ATFE_ApprovalRequired__c,ATFE_ApprovalStatus__c,ATFE_ApprovalDate__c from Opportunity where id =:opp.id];
        quo1 = [select ATFE_Approval_required__c,ATFE_Approval_Status__c,APAC_ApprovalDate__c,isSyncing from Quote where id =:quo1.id];
        Qs.add(quo1);
         ATFE_UpdateOpportunityFromSyncedQuote atqfs = new ATFE_UpdateOpportunityFromSyncedQuote(Qs,Qs); 
        System.assertEquals(true ,quo1.isSyncing );
        //System.assertEquals(opp.ATFE_ApprovalRequired__c , quo1.ATFE_Approval_required__c);
        //System.assertEquals(opp.ATFE_ApprovalStatus__c , quo1.ATFE_Approval_Status__c);
        //System.assertEquals(opp.ATFE_ApprovalDate__c , quo1.APAC_ApprovalDate__c);
        
        */
        ATFE_UpdateOpportunityFromSyncedQuote auo = new ATFE_UpdateOpportunityFromSyncedQuote();
       
        
    }
 }