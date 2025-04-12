@isTest(seeallData = true)
private class Test_QuoteQuickly_Triggers {
     static testMethod void validate_QuoteQuickly_triggers() {
              Id AccRCTypeId = [SELECT Id,Name FROM RecordType where DeveloperName = 'Americas_Accounts'].Id;
              Id OppRCTypeId = [SELECT Id,Name FROM RecordType where DeveloperName = 'NA_Opportunity'].Id;  
              Id QutRCTypeId = [SELECT Id,Name FROM RecordType where DeveloperName = 'ATFE_QQuote_After_Approval'].Id; 
              
              system.debug('##' + OppRCTypeId );
              system.debug('##' + AccRCTypeId );
              system.debug('##' + QutRCTypeId );
              
                Test.starttest();
              /* Pricebook2 pricebk1 = new Pricebook2(Name='TestPricebook',IsActive = true,IsStandard = true);
               Pricebook2 pricebk2= new Pricebook2(Name='TestPricebook',IsActive = true,IsStandard= true);
            // insert pricebook1 ;
               List<Pricebook2> pricbkList = new List<Pricebook2>{pricebk1,pricebk2};
               insert pricbkList ; */
               
                Pricebook2 stdPb = [select IsActive,Id,Name from Pricebook2 where isStandard = true limit 1];
              
              // insert test Account-------------------------------------------------------
              Account acc = new Account(Name = 'TestAccount',BillingCountry='United States',BillingCity='San Jose',BillingStreet='3200 North 1st Street',BillingState='New York',BillingPostalCode='94153',ATFE_AccountType__c ='End Customer', RecordTypeId= AccRCTypeId , ATFE_Partner_Type__c ='Distributor',Region__c = 'NA' , Sub_Region__c = 'NA' , ATFE_SalesOrgName__c ='Strategic-Enterprise',ATFE_VerticalMarketInit__c ='Retail' );
              insert acc ;
              system.debug('## Account ## ' + acc );
              
              System.assert(acc.Id!= null);
              
              Account accAfterInsert = [SELECT Id, Name, BillingCountry, ATFE_Price_Book__c FROM Account WHERE Id = :acc.Id];
              System.debug('AccId'+acc.id);
             
             // insert test Opportunity-------------------------------------------------------
              Opportunity opp = new Opportunity(name ='TestOpp', StageName ='Prospect/Qualification',AccountId = acc.id,RecordTypeId= OppRCTypeId,CloseDate = System.today().addDays(2),Required_Delivery_Date__c=system.today().adddays(3));
              insert opp ;
            
              Product2 product1 = new Product2(Name='TestProduct',IsActive = true,ATFE_ProductType__c='TestProduct');
              Product2 product2 = new Product2(Name='TestProduct',IsActive = true,ATFE_ProductType__c='DummyProduct');
            // insert product1 ;
             List<Product2> prodList = new List<Product2>{product1,product2};
             insert prodList ;
   
             PricebookEntry pbe = new PricebookEntry(pricebook2id = stdPb.id , product2id = prodList[0].id, UnitPrice = 100.0, isActive = true,UseStandardPrice = false);
             PricebookEntry pbe1 = new PricebookEntry(pricebook2id = stdPb.id, product2id = prodList[1].id, UnitPrice = 100.0, isActive = true,UseStandardPrice = false);
             List<PricebookEntry> pbeList = new List<PricebookEntry> {pbe,pbe1};
             insert pbeList;
             

            SBQQ__Quote__c quo1 = new SBQQ__Quote__c(Quote_To_Pricebook_Name__c = stdPb.Name, SBQQ__Opportunity2__c = opp.id,RecordTypeId= QutRCTypeId, ATFE_Quote_Name__c ='TestQuoe',SBQQ__Account__c = acc.id);
            insert quo1 ;            
             
            ATFE_ProductTypePLM__c atfeProdctPLM = new ATFE_ProductTypePLM__c(Name = 'TestProduct',ATFE_Product_Owner__c ='TestOwner');
            ATFE_ProductTypePLM__c atfeProdctPLM1 = new ATFE_ProductTypePLM__c(Name = 'DummyProduct',ATFE_Product_Owner__c ='DummyOwner');
            List<ATFE_ProductTypePLM__c> prodctPLMList = new List<ATFE_ProductTypePLM__c> {atfeProdctPLM,atfeProdctPLM1};
            insert prodctPLMList ; 
            
            
        //  System.debug('Quote stdPb Id :'+[select Pricebook2Id from Quote where id =: quo1.id ].Pricebook2Id);
            
            
            SBQQ__QuoteLine__c qli = new SBQQ__QuoteLine__c(SBQQ__ListPrice__c = 50.0,MSRP_Price__c = 10.0, SBQQ__Discount__c = 10 ,SBQQ__Quote__c = quo1.id, SBQQ__Quantity__c = 2, SBQQ__Product__c = prodList[0].id  ,
            SBQQ__NetPrice__c = 100);
            SBQQ__QuoteLine__c qli1 = new SBQQ__QuoteLine__c(SBQQ__ListPrice__c = 50.0,MSRP_Price__c = 10.0, SBQQ__Quote__c = quo1.id,SBQQ__Discount__c = 5 , SBQQ__Quantity__c = 2, SBQQ__Product__c = prodList[1].id  ,
            SBQQ__NetPrice__c = 100);
            List<SBQQ__QuoteLine__c> qliList = new List<SBQQ__QuoteLine__c>{qli,qli1};
            insert qliList ; 
            update  quo1;
            delete qliList ; 
            update  quo1;
            
            
         /*   System.assertEquals('DummyOwner,TestOwner',[select ATFE_PLM_s__c from Quote where id =:quo1.id].ATFE_PLM_s__c); 
            delete qli1 ;
            System.assertEquals('TestOwner',[select ATFE_PLM_s__c from Quote where id =:quo1.id].ATFE_PLM_s__c);     */
            
            Test.StopTest();
  
    }  
static testMethod void validate_Opportunity_controller() {
        
              Id AccRCTypeId = [SELECT Id,Name FROM RecordType where DeveloperName = 'Americas_Accounts'].Id;
              Id OppRCTypeId = [SELECT Id,Name FROM RecordType where DeveloperName = 'NA_Opportunity'].Id;  
              Id QutRCTypeId = [SELECT Id,Name FROM RecordType where DeveloperName = 'ATFE_QQuote_After_Approval'].Id; 
              Test.StartTest();
        
              Account acc = new Account(Name = 'TestAccount',BillingCountry='United States',BillingCity='San Jose',BillingStreet='3200 North 1st Street',BillingState='New York',BillingPostalCode='94153',ATFE_AccountType__c ='End Customer', RecordTypeId= AccRCTypeId , ATFE_Partner_Type__c ='Distributor',Region__c = 'NA' , Sub_Region__c = 'NA' , ATFE_SalesOrgName__c ='Strategic-Enterprise',ATFE_VerticalMarketInit__c ='Retail' );
              insert acc ;
             
              System.assert(acc.Id!= null);
        
        

        PageReference pageRef = Page.Opportunitiy;
        Test.setCurrentPage(pageRef);
        
        Opportunity Opp = new Opportunity();

        Opp.Name = 'test';
        Opp.StageName ='Prospect/Qualification';
        Opp.AccountId = acc.id;
        Opp.RecordTypeId = OppRCTypeId;
        Opp.CloseDate = System.today().addDays(2);
        Opp.Required_Delivery_Date__c=system.today().adddays(3);
        insert Opp;

    ApexPages.currentPage().getParameters().put('lc', Opp.id);
    ApexPages.StandardController stdopp = new ApexPages.StandardController(Opp);
    OpportunityExtn objoppextn = new OpportunityExtn(stdopp );
    objoppextn.verifyRecordType();
    objoppextn.getOpplineitems();
    Test.stopTest();

    }
    
static testMethod void validate_Quote_controller() {
        
              Id AccRCTypeId = [SELECT Id,Name FROM RecordType where DeveloperName = 'Americas_Accounts'].Id;
              Id OppRCTypeId = [SELECT Id,Name FROM RecordType where DeveloperName = 'NA_Opportunity'].Id;  
              Id QutRCTypeId = [SELECT Id,Name FROM RecordType where DeveloperName = 'ATFE_QQuote_After_Approval'].Id; 
              
              Test.StartTest();
        
        Pricebook2 stdPb = [select IsActive,Id,Name from Pricebook2 where isStandard = true limit 1];
        
        Account acc = new Account(Name = 'TestAccount',BillingCountry='United States',BillingCity='San Jose',BillingStreet='3200 North 1st Street',BillingState='New York',BillingPostalCode='94153',ATFE_AccountType__c ='End Customer', RecordTypeId= AccRCTypeId , ATFE_Partner_Type__c ='Distributor',Region__c = 'NA' , Sub_Region__c = 'NA' , ATFE_SalesOrgName__c ='Strategic-Enterprise',ATFE_VerticalMarketInit__c ='Retail' );
            insert acc ;
             
              System.assert(acc.Id!= null);
        Account accAfterInsert = [SELECT Id, Name, BillingCountry, ATFE_Price_Book__c FROM Account WHERE Id = :acc.Id];
             System.debug('AccId'+acc.id);
             
   // insert test Opportunity-------------------------------------------------------
        Opportunity opp = new Opportunity(name ='TestOpp', StageName ='Prospect/Qualification',AccountId = acc.id,RecordTypeId= OppRCTypeId,CloseDate = System.today().addDays(2),Required_Delivery_Date__c=system.today().adddays(3));
            insert opp ;


        PageReference pageRef = Page.Quote;
        Test.setCurrentPage(pageRef);
        
        SBQQ__Quote__c Qut = new SBQQ__Quote__c();

        Qut.Quote_To_Pricebook_Name__c = stdPb.Name;
        Qut.SBQQ__Opportunity2__c = opp.id;
        Qut.SBQQ__Account__c = acc.id;
        Qut.RecordTypeId = QutRCTypeId;
        Qut.ATFE_Quote_Name__c = 'TestQuoe';
        insert Qut;

    ApexPages.currentPage().getParameters().put('lc', Qut.id);
    ApexPages.StandardController stdopp = new ApexPages.StandardController(Qut);
    QuoteViewExtn  objQutextn = new QuoteViewExtn (stdopp );
    objQutextn.verifyRecordType();
    objQutextn.getQlineitems();
    
    Test.StopTest();

    }    
     
 }