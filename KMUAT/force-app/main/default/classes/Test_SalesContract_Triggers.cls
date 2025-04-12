@isTest
private class Test_SalesContract_Triggers {
     static testMethod void validate_SalesContract_triggers() {
     //Channelinsight.CI_TEST_TestUtils.createBaseInstallData();
              Id AccRCTypeId = [SELECT Id,Name FROM RecordType where DeveloperName = 'Americas_Accounts'].Id;
              Id ConRCTypeId = [SELECT Id,Name FROM RecordType where DeveloperName = 'ATFE_ContractBeforeApproval'].Id;  
              Id ConPRCTypeId = [SELECT Id,Name FROM RecordType where DeveloperName = 'Contracted_Price_Before_Approva'].Id; 
              
              system.debug('##' + ConRCTypeId );
              system.debug('##' + AccRCTypeId );
              system.debug('##' + ConPRCTypeId );
              
              // insert test Account-------------------------------------------------------
              Account acc = new Account(Name = 'TestAccount',BillingCountry='United States',BillingCity='San Jose',BillingStreet='3200 North 1st Street',BillingState='New York',BillingPostalCode='94153',ATFE_AccountType__c ='End Customer', RecordTypeId= AccRCTypeId , ATFE_Partner_Type__c ='Distributor',Region__c = 'NA' , Sub_Region__c = 'NA' , ATFE_SalesOrgName__c ='Strategic-Enterprise',ATFE_VerticalMarketInit__c ='Retail' );
              insert acc ;
              system.debug('## Account ## ' + acc );
              
              
              System.assert(acc.Id!= null);
              
              Account accAfterInsert = [SELECT Id, Name, BillingCountry, ATFE_Price_Book__c FROM Account WHERE Id = :acc.Id];
              System.debug('AccId'+acc.id);
             
             // insert test Contract---------------------------------------------------------
              Contract sc = new Contract(Name = 'TestContract',Status = 'Draft',BillingCountry='United States',BillingCity='San Jose',BillingStreet='3200 North 1st Street',BillingState='New York',BillingPostalCode='94153',ATFE_Contract_End_Date__c =date.Today(),EndDate = date.Today(),StartDate= date.Today(), RecordTypeId=  ConRCTypeId , Accountid = acc.id );
              insert sc ;
              
               System.assert(sc.Id!= null);
              
              Contract contAfterInsert = [SELECT Id, Name, BillingCountry FROM Contract WHERE Id = :sc.Id];
              System.debug('SCId'+sc.id);
              
              // insert test Products-------------------------------------------
              Product2 product1 = new Product2(Name='TestProduct',IsActive = true,ATFE_ProductType__c='TestProduct');
              Product2 product2 = new Product2(Name='TestProduct',IsActive = true,ATFE_ProductType__c='DummyProduct');
              List<Product2> prodList = new List<Product2>{product1,product2};
              insert prodList ;
              
              // insert test ContractedPrices-------------------------------------
              SBQQ__ContractedPrice__c cp = new SBQQ__ContractedPrice__c(Sales_Contract__c  =sc.Id, SBQQ__Price__c = 100 , SBQQ__ExpirationDate__c = sc.EndDate  /*date.Today()*/,SBQQ__EffectiveDate__c= sc.StartDate /*date.Today()*/, RecordTypeId=  ConPRCTypeId , SBQQ__Account__c = acc.id,SBQQ__Product__c = prodList[0].id ,SBQQ__Contract__c = sc.id );
              SBQQ__ContractedPrice__c cp1 = new SBQQ__ContractedPrice__c(Sales_Contract__c  =sc.Id,SBQQ__Price__c = 100 , SBQQ__ExpirationDate__c = sc.EndDate  /*date.Today()*/,SBQQ__EffectiveDate__c= sc.StartDate /*date.Today()*/, RecordTypeId= ConPRCTypeId , SBQQ__Account__c = acc.id,SBQQ__Product__c = prodList[1].id , SBQQ__Contract__c = sc.id);
              List<SBQQ__ContractedPrice__c> cpList = new List<SBQQ__ContractedPrice__c> {cp,cp1};
              insert cpList;
              update sc;
              
              
              System.assert(cp.Id!= null);
              
              SBQQ__ContractedPrice__c conpritAfterInsert = [SELECT Id, Name, SBQQ__Contract__c,SBQQ__EffectiveDate__c,SBQQ__ExpirationDate__c FROM SBQQ__ContractedPrice__c WHERE Id = :cp.Id];
              System.debug('CPId'+cp.id);
              
              // insert test PLM Custom Setting-------------------------------------------------------------
             ATFE_ProductTypePLM__c atfeProdctPLM = new ATFE_ProductTypePLM__c(Name = 'TestProduct',ATFE_Product_Owner__c ='TestOwner');
             ATFE_ProductTypePLM__c atfeProdctPLM1 = new ATFE_ProductTypePLM__c(Name = 'DummyProduct',ATFE_Product_Owner__c ='DummyOwner');
             List<ATFE_ProductTypePLM__c> prodctPLMList = new List<ATFE_ProductTypePLM__c> {atfeProdctPLM,atfeProdctPLM1};
             insert prodctPLMList ;
             
         //    System.assertEquals('DummyOwner,TestOwner',[select ATFE_PLM_s__c from Contract where id =:sc.id].ATFE_PLM_s__c); 
         //    delete sc ;
         //    System.assertEquals('TestOwner',[select ATFE_PLM_s__c from Contract where id =:sc.id].ATFE_PLM_s__c);
             
      }        
 }