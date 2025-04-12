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
@isTest(seealldata=true)
private class Test_ATFE_QuoteNewOverride {

    static testMethod void TestQuoteNewOverride() {
      
        Pricebook2 stdPb = [select IsActive,Id,Name from Pricebook2 where isStandard = true limit 1];
        Account acc = new Account(Name = 'TestAccount',BillingCountry='United States',BillingCity='TestCity',BillingStreet='TestStreet',
                            BillingState='CA',Billingpostalcode='123456' );
        Account acc1 = new Account(Name = 'TestAccount1',BillingCountry='United States',BillingCity='TestCity',BillingStreet='TestStreet',
                            BillingState='CA',Billingpostalcode='123456' );
        
        insert acc ;
        insert acc1 ;
        System.debug('AccId'+acc.id);
        Opportunity opp = new Opportunity(name ='TestOpp', StageName ='01 - Qualify',AccountId = acc.id,CloseDate = System.today().addDays(2),Required_Delivery_Date__c=system.today().addDays(3),ATFE_ReasonWonLostCode__c='Loss');
        insert opp ;
         Product2 product11 = new Product2(Name='TestProduct11',IsActive = true);
         insert product11 ;
         Partner p1 = new Partner(OpportunityId = opp.id, AccountToId = acc1.id );
         insert p1 ;
        System.debug('stdPb Id :'+stdPb.id);
        Product2 product1 = new Product2(Name='TestProduct1',IsActive = true,RelatedProduct__c= product11.id);
        Product2 product2 = new Product2(Name='TestProduct2',IsActive = true,RelatedProduct__c = product11.id);
        List<Product2> prodList = new List<Product2>{product1,product2};
        insert prodList ;   
   
        PricebookEntry pbe = new PricebookEntry(pricebook2id = stdPb.id, product2id = prodList[0].id, UnitPrice = 100.0, isActive = true,UseStandardPrice = false);
        PricebookEntry pbe1 = new PricebookEntry(pricebook2id = stdPb.id, product2id = product11.id, UnitPrice = 100.0, isActive = true,UseStandardPrice = false);
         List<PricebookEntry> pbList = new List<PricebookEntry> {pbe,pbe1};
        insert pbList;
       // ATFE_QuoteCloneWithProducts.byPassQuoteTrigger = true ;
         ApexPages.currentPage().getParameters().put('oppid',opp.id);
         ApexPages.Standardcontroller std = new  ApexPages.Standardcontroller(opp);
         ATFE_QuoteNewOverrideController quote = new ATFE_QuoteNewOverrideController(std);
         quote.getPartners();
         quote.setAddressFieldsForQuoteTo();
         quote.setAddressFieldsForBillTo();
         quote.setAddressFieldsForShipTo();
         quote.saveQuote();
         quote.Cancel();
         System.assertEquals(1, [select count() from Quote where OpportunityId =: opp.id]);
         quote.relatedAccount = acc ;
         quote.selectedPartnerOrAccountForQuoteTo = acc1.id ;
         quote.selectedPartnerOrAccountForBillTo = acc1.id;
         quote.selectedPartnerOrAccountForShipTo = acc1.id;
         
        quote.setAddressFieldsForQuoteTo();
        quote.setAddressFieldsForShipTo();
        quote.setAddressFieldsForBillTo();
       
    }
    
    /*
        The following method is used for testing Clone With Products controller
    */
     static testMethod void TestQuoteCloneWithProducts() {
      
        Pricebook2 stdPb = [select IsActive,Id,Name from Pricebook2 where isStandard = true limit 1];
        Account acc = new Account(Name = 'TestAccount',BillingCountry='United States',BillingCity='TestCity',BillingStreet='TestStreet',
                            BillingState='CA',Billingpostalcode='123456' );
        Account acc1 = new Account(Name = 'TestAccount1',BillingCountry='United States',BillingCity='TestCity',BillingStreet='TestStreet',
                            BillingState='CA',Billingpostalcode='123456' );
        
        insert acc ;
        insert acc1 ;
        System.debug('AccId'+acc.id);
        Opportunity opp = new Opportunity(name ='TestOpp', StageName ='01 - Qualify',AccountId = acc.id,CloseDate = System.today().addDays(2),ATFE_ReasonWonLostCode__c='Loss',Required_Delivery_Date__c=system.today().adddays(3));
        insert opp ;
         Product2 product11 = new Product2(Name='TestProduct11',IsActive = true);
         insert product11 ;
         Partner p1 = new Partner(OpportunityId = opp.id, AccountToId = acc1.id );
         insert p1 ;
        System.debug('stdPb Id :'+stdPb.id);
        Product2 product1 = new Product2(Name='TestProduct1',IsActive = true,RelatedProduct__c= product11.id);
        Product2 product2 = new Product2(Name='TestProduct2',IsActive = true,RelatedProduct__c = product11.id);
        List<Product2> prodList = new List<Product2>{product1,product2};
        insert prodList ;   
   
        PricebookEntry pbe = new PricebookEntry(pricebook2id = stdPb.id, product2id = prodList[0].id, UnitPrice = 100.0, isActive = true,UseStandardPrice = false);
        PricebookEntry pbe1 = new PricebookEntry(pricebook2id = stdPb.id, product2id = product11.id, UnitPrice = 100.0, isActive = true,UseStandardPrice = false);
         List<PricebookEntry> pbList = new List<PricebookEntry> {pbe,pbe1};
        insert pbList;
       // ATFE_QuoteCloneWithProducts.byPassQuoteTrigger = true ;
      
        Quote quot = new Quote(Pricebook2Id = stdPb.id, OpportunityId = opp.id, Name ='TestQuoe');
         insert quot ;
         QuoteLineItem qli = new QuoteLineItem(UnitPrice = 50.0,ATFE_MSRP__c = 10.0, QuoteId = quot.id, Quantity = 2, PricebookEntryId = pbList[0].id  ,
        PriceBook_Price_Amount__c = 100);
      // insert qli ;
         ApexPages.currentPage().getParameters().put('cloneProducts','true');
         ApexPages.Standardcontroller std = new  ApexPages.Standardcontroller(quot);
         ATFE_QuoteCloneWithProducts quote = new ATFE_QuoteCloneWithProducts(std);
         
         quote.getPartners();
         quote.setAddressFieldsForQuoteTo();
         quote.setAddressFieldsForBillTo();
         quote.setAddressFieldsForShipTo();
         quote.saveQuote();
         quote.Cancel();
        System.assertEquals(2, [select count() from Quote where OpportunityId =: opp.id]);
        /* quote.relatedAccount = acc ;
         quote.selectedPartnerOrAccountForQuoteTo = acc1.id ;
         quote.selectedPartnerOrAccountForBillTo = acc1.id;
         quote.selectedPartnerOrAccountForShipTo = acc1.id;
         
        quote.setAddressFieldsForQuoteTo();
        quote.setAddressFieldsForShipTo();
        quote.setAddressFieldsForBillTo();
       */
    }
}