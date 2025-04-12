@isTest(seeallData = true)  
public class ATFE_PLMUpdateOnQuoteHelperTest {
     /*
        The following method is used for covering PLM Update on Quote code  
    */
    
    static Testmethod void TestPLMUpdateOnQuote()
    {
        Pricebook2 stdPb = [select IsActive,Id,Name from Pricebook2 where isStandard = true limit 1];
        Account acc = new Account(Name = 'TestAccount',BillingCountry='United States',BillingCity='San Jose',BillingStreet='3200 North 1st Street',BillingState='New York',BillingPostalCode='94153',ATFE_AccountType__c ='End Customer', RecordTypeId= '01220000000HctC' , ATFE_Partner_Type__c ='Distributor' );
        insert acc ;
        Account accAfterInsert = [SELECT Id, Name, BillingCountry, ATFE_Price_Book__c FROM Account WHERE Id = :acc.Id];
        System.debug('AccId'+acc.id);
        Opportunity opp = new Opportunity(name ='TestOpp', StageName ='01 - Qualify',AccountId = acc.id,CloseDate = System.today().addDays(2),Required_Delivery_Date__c=system.today().addDays(3),ATFE_ReasonWonLostCode__c='Loss');
        insert opp ;
        ATFE_QuoteCloneWithProducts.byPassQuoteTrigger = true ;
        System.debug('stdPb Id :'+stdPb.id);
        Product2 product1 = new Product2(Name='TestProduct',IsActive = true,ATFE_ProductType__c='TestProduct');
        Product2 product2 = new Product2(Name='TestProduct',IsActive = true,ATFE_ProductType__c='DummyProduct');
        // insert product1 ;
        List<Product2> prodList = new List<Product2>{product1,product2};
        insert prodList ;
   
        PricebookEntry pbe = new PricebookEntry(pricebook2id = stdPb.id, product2id = prodList[0].id, UnitPrice = 100.0, isActive = true,UseStandardPrice = false);
        PricebookEntry pbe1 = new PricebookEntry(pricebook2id = stdPb.id, product2id = prodList[1].id, UnitPrice = 100.0, isActive = true,UseStandardPrice = false);
        List<PricebookEntry> pbeList = new List<PricebookEntry> {pbe,pbe1};
        insert pbeList;
        
        Quote quo1 = new Quote(Pricebook2Id = stdPb.id, OpportunityId = opp.id, Name ='TestQuoe',ATFE_Partner_Name__c = acc.id);
        insert quo1 ;
        ATFE_ProductTypePLM__c atfeProdctPLM = new ATFE_ProductTypePLM__c(Name = 'TestProduct',ATFE_Product_Owner__c ='TestOwner');
        ATFE_ProductTypePLM__c atfeProdctPLM1 = new ATFE_ProductTypePLM__c(Name = 'DummyProduct',ATFE_Product_Owner__c ='DummyOwner');
        List<ATFE_ProductTypePLM__c> prodctPLMList = new List<ATFE_ProductTypePLM__c> {atfeProdctPLM,atfeProdctPLM1};
        insert prodctPLMList ;
        
        System.debug('Quote stdPb Id :'+[select Pricebook2Id from Quote where id =: quo1.id ].Pricebook2Id);
        
        QuoteLineItem qli = new QuoteLineItem(UnitPrice = 50.0,ATFE_MSRP__c = 10.0, ATFE_Discount__c = 10 ,QuoteId = quo1.id, Quantity = 2, PricebookEntryId = pbeList[0].id  ,
        PriceBook_Price_Amount__c = 100);
        QuoteLineItem qli1 = new QuoteLineItem(UnitPrice = 50.0,ATFE_MSRP__c = 10.0, QuoteId = quo1.id,ATFE_Discount__c = 5 , Quantity = 2, PricebookEntryId = pbeList[1].id  ,
        PriceBook_Price_Amount__c = 100);
        List<QuoteLineItem> qliList = new List<QuoteLineItem>{qli,qli1};
        insert qliList ;  
        // System.assertEquals('DummyOwner,TestOwner',[select ATFE_PLM_s__c from Quote where id =:quo1.id].ATFE_PLM_s__c); 
        delete qli1 ;
        // System.assertEquals('TestOwner',[select ATFE_PLM_s__c from Quote where id =:quo1.id].ATFE_PLM_s__c);    
    }

}