@isTest(seealldata=true)
private class Test_ATFE_Services {

    static testMethod void TestService() {
        ATFE_QuoteCloneWithProducts.byPassQuoteTrigger = true ;
        
        Pricebook2 stdPb = [select IsActive,Id,Name from Pricebook2 where isStandard = true limit 1];
        Account acc = new Account(Name = 'TestAccount',BillingCountry='United States',BillingCity='TestCity',BillingStreet='TestStreet',
                            BillingState='CA',Billingpostalcode='123456' );
        insert acc ;
        System.debug('AccId'+acc.id);
        Opportunity opp = new Opportunity(name ='TestOpp', StageName ='01 - Qualify',AccountId = acc.id,CloseDate = System.today().addDays(2),ATFE_ReasonWonLostCode__c='Loss',Required_Delivery_Date__c=system.today().adddays(3));
        insert opp ;
        Product2 product11 = new Product2(Name='TestProduct11',IsActive = true);
        insert product11 ;
        System.debug('stdPb Id :'+stdPb.id);
        Product2 product1 = new Product2(Name='TestProduct1',IsActive = true,RelatedProduct__c= product11.id);
        Product2 product2 = new Product2(Name='TestProduct2',IsActive = true,RelatedProduct__c = product11.id);
        List<Product2> prodList = new List<Product2>{product1,product2};
        insert prodList ; 
   
        PricebookEntry pbe = new PricebookEntry(pricebook2id = stdPb.id, product2id = prodList[0].id, UnitPrice = 100.0, isActive = true,UseStandardPrice = false);
        PricebookEntry pbe1 = new PricebookEntry(pricebook2id = stdPb.id, product2id = product11.id, UnitPrice = 100.0, isActive = true,UseStandardPrice = false);
        List<PricebookEntry> pbList = new List<PricebookEntry> {pbe,pbe1};
        insert pbList;
        
         pbe = [select product2id from PricebookEntry where id = :pbe.id];
          ATFE_Product_Service__c productService  = new ATFE_Product_Service__c(ATFE_Product_Id__c = product1.id,ATFE_Service_Id__c = product1.id);
        insert productService ;
        
        Quote quo1 = new Quote(Pricebook2Id = stdPb.id, OpportunityId = opp.id, Name ='TestQuoe');
        
        insert quo1 ;
        System.debug('Quote stdPb Id :'+[select Pricebook2Id from Quote where id =: quo1.id ].Pricebook2Id);
        QuoteLineItem qli = new QuoteLineItem(UnitPrice = 50.0,ATFE_MSRP__c = 10.0, QuoteId = quo1.id, Quantity = 2, PricebookEntryId = pbList[0].id  ,
        PriceBook_Price_Amount__c = 100);
        QuoteLineItem qli1 = new QuoteLineItem(UnitPrice = 50.0,ATFE_MSRP__c = 10.0, QuoteId = quo1.id, Quantity = 2, PricebookEntryId = pbList[1].id  ,
        PriceBook_Price_Amount__c = 100);
        List<QuoteLineItem> qliList = new List<QuoteLineItem>{qli,qli1} ;
        insert qliList; 
        String qliIdList = qliList[0].id +','+ qliList[1].id;
        Apexpages.currentpage().getparameters().put('qliItems',qliIdList);   
        ATFE_Services ser = new ATFE_Services();
        ser.GetProductDetails();
        ser.getLogicalOptions();
        ser.getProductFieldDetails();
        ser.services[0].checked = true ;
        ser.process();
        ser.cancel();
        ser.saveLineItem();
        ser.services[0].Quantity = 2 ;
       
        ser.saveLineItem();
        ser.createLineItems();
    }
}