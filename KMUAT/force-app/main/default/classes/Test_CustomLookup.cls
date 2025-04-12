@isTest
private class Test_CustomLookup 
{

@isTest(SeeAllData=true)  
    public static void myUnitTest1() 
    {
        // TO DO: implement unit test
           
    UtilSODOFlags.skip_caseTrigges = true;
    
    Account acc = new Account(Name='Test Account',
                              Region__c='EMEA',
                              Sub_Region__c='Middle East',
                              ATFE_SalesOrgName__c='Middle East',
                              ATFE_AccountType__c='Partner',
                              BillingCountry='India',
                              BillingCity = 'billing city',
                              BillingStreet = 'billing street',
                              BillingPostalCode = 'billing postal code',
                              BillingState = 'Wisconsin');
        insert acc;    
    
    Pricebook2 pricbook =  [select id,CurrencyIsoCode from Pricebook2 where IsStandard = true AND isActive = true];
     
      
          
      Product2 pr = new Product2();
             pr.Name = 'TESTProduct1';
             pr.Description = 'test Desc';
             pr.Family = 'PRODUCT';
             pr.IsActive = true;
           //  pr.productcode = '960-002642';
           //  pr.PriceBook2Id =pricbookId ;
             pr.ATFE_Service_Product_Type__c = 'PC-1';
             
             insert pr;  
          
      Product2 pr2 = new Product2();
             pr2.Name = 'TESTProduct2';
             pr2.Description = 'test Desc';
             pr2.Family = 'SERVICE';
             pr2.IsActive = true;
           //  pr.productcode = '960-002642';
           //  pr.PriceBook2Id =pricbookId ;
             pr2.ATFE_Service_Product_Type__c = 'PC-1';
             
             insert pr2;  
             
                       
        user u = [SELECT ID,Price_Book_Region__c FROM USER WHERE ID=:userinfo.getUserId()];  
       u.Price_Book_Region__c = 'NA;EMEA;APAC;';
       update u;
       test.startTest();
       system.runAs(u)
       {      
           ServiceSearchCTRL searchService1 = new ServiceSearchCTRL();
            searchService1.ProductString = 'TESTProduct2';              
            searchService1.getTextBox();
            searchService1.getFormTag();
            searchService1.FilterService();
            searchService1.getProducts();                       
            searchService1.first();
            searchService1.last();
            searchService1.previous();
            searchService1.next();              
            searchService1.refresh();
                        
           ServiceSearchCTRL searchService2 = new ServiceSearchCTRL();
            searchService2.FilterService();
            searchService1.getProducts();
            
           productSearchCTRL searchHardware1 = new productSearchCTRL();
            searchHardware1.ProductString = 'TESTProduct1';                 
            searchHardware1.getTextBox();
            searchHardware1.getFormTag();
            searchHardware1.FilterProduct();
            searchHardware1.getProducts();                          
            searchHardware1.first();
            searchHardware1.last();
            searchHardware1.previous();
            searchHardware1.next();             
            searchHardware1.refresh();

           productSearchCTRL searchHardware2 = new productSearchCTRL();
            searchHardware2.FilterProduct();
            searchHardware2.getProducts();
            
            PageReference page1 = Page.HardwareAssetNew;
            Test.setCurrentPage(page1);
            
            ApexPages.currentPage().getParameters().put(label.AccountCFID, acc.Id);
            ApexPages.currentPage().getParameters().put('prodid', pr.ID);
            ApexPages.currentPage().getParameters().put('accountid', acc.ID);
            ApexPages.currentPage().getParameters().put('serialnum', 'TEST NUMBER');
            
            Asset__c newAsset1 = new Asset__c();            
            ApexPages.StandardController sc1 = new ApexPages.standardController(newAsset1);             
            AssetCTRL AssetCTRL1 = new AssetCTRL(sc1);
            AssetCTRL1.save();              
            AssetCTRL1.cancel();
           
            newAsset1 = new Asset__c();
            ApexPages.StandardController sc2 = new ApexPages.standardController(newAsset1);             
            AssetCTRL AssetCTRL2 = new AssetCTRL(sc2);
            AssetCTRL2.savenew();               
                              
            PageReference page2 = Page.NewServiceAssetNew;
            Test.setCurrentPage(page2);
            
            serviceAssetcontroller.isTestRunning = true;
                        
            ApexPages.currentPage().getParameters().put(label.AccountCFIDS, acc.Id);
            system.debug('*******pr2***'+pr2.ID);
            Service_Asset__c newServiceAsset1 = new Service_Asset__c();
            newServiceAsset1.Account__c = acc.ID;
            newServiceAsset1.Service_Product__c = pr2.ID;
            newServiceAsset1.Start_Date__c = system.today();
               
            
            ApexPages.StandardController sc3 = new ApexPages.standardController(newServiceAsset1);              
            serviceAssetcontroller ServiceAssetCTRL1 = new serviceAssetcontroller(sc3);
            newServiceAsset1.Service_Product__c = pr2.ID;
            newServiceAsset1.Start_Date__c = system.today();
             
            ServiceAssetCTRL1.save();               
            ServiceAssetCTRL1.cancel();

            
            newServiceAsset1 = new Service_Asset__c();
            
            newServiceAsset1.Account__c = acc.ID;
            newServiceAsset1.Service_Product__c = pr2.ID;
            newServiceAsset1.Start_Date__c = system.today();
                        
            ApexPages.StandardController sc4 = new ApexPages.standardController(newServiceAsset1);              
            serviceAssetcontroller ServiceAssetCTRL2 = new serviceAssetcontroller(sc4);
            
            ServiceAssetCTRL2.savenew();             
            
           
            
            
       }    
        test.stopTest(); 
                       
    }
@isTest(SeeAllData=true)  
    public static void myUnitTest2() 
    {
        // TO DO: implement unit test
        //   test.startTest();
    UtilSODOFlags.skip_caseTrigges = true;
    
    Account acc = new Account(Name='Test Account',
                              Region__c='EMEA',
                              Sub_Region__c='Middle East',
                              ATFE_SalesOrgName__c='Middle East',
                              ATFE_AccountType__c='Partner',
                              BillingCountry='India',
                              BillingCity = 'billing city',
                              BillingStreet = 'billing street',
                              BillingPostalCode = 'billing postal code',
                              BillingState = 'Wisconsin');
        insert acc;    
    
    Pricebook2 pricbook =  [select id,CurrencyIsoCode from Pricebook2 where IsStandard = true AND isActive = true];
     
      
          
      Product2 pr = new Product2();
             pr.Name = 'TESTProduct1';
             pr.Description = 'test Desc';
             pr.Family = 'PRODUCT';
             pr.IsActive = true;
           //  pr.productcode = '960-002642';
           //  pr.PriceBook2Id =pricbookId ;
             pr.ATFE_Service_Product_Type__c = 'PC-1';
             
             insert pr;  
          
      Product2 pr2 = new Product2();
             pr2.Name = 'TESTProduct2';
             pr2.Description = 'test Desc';
             pr2.Family = 'SERVICE';
             pr2.IsActive = true;
           //  pr.productcode = '960-002642';
           //  pr.PriceBook2Id =pricbookId ;
             pr2.ATFE_Service_Product_Type__c = 'PC-1';
             
             insert pr2;  
             
                       
        user u = [SELECT ID,Price_Book_Region__c FROM USER WHERE ID=:userinfo.getUserId()];  
       u.Price_Book_Region__c = 'NA;EMEA;APAC;';
       update u;
       test.startTest();
       system.runAs(u)
       {      
           ServiceSearchCTRL searchService1 = new ServiceSearchCTRL();
            searchService1.ProductString = 'TESTProduct2';              
            searchService1.getTextBox();
            searchService1.getFormTag();
            searchService1.FilterService();
            searchService1.getProducts();                       
            searchService1.first();
            searchService1.last();
            searchService1.previous();
            searchService1.next();              
            searchService1.refresh();
                        
           ServiceSearchCTRL searchService2 = new ServiceSearchCTRL();
            searchService2.FilterService();
            searchService1.getProducts();
            
           productSearchCTRL searchHardware1 = new productSearchCTRL();
            searchHardware1.ProductString = 'TESTProduct1';                 
            searchHardware1.getTextBox();
            searchHardware1.getFormTag();
            searchHardware1.FilterProduct();
            searchHardware1.getProducts();                          
            searchHardware1.first();
            searchHardware1.last();
            searchHardware1.previous();
            searchHardware1.next();             
            searchHardware1.refresh();

           productSearchCTRL searchHardware2 = new productSearchCTRL();
            searchHardware2.FilterProduct();
            searchHardware2.getProducts();
            
            PageReference page1 = Page.HardwareAssetNew;
            Test.setCurrentPage(page1);
            
            ApexPages.currentPage().getParameters().put(label.AccountCFID, acc.Id);
            ApexPages.currentPage().getParameters().put('prodid', pr.ID);
            ApexPages.currentPage().getParameters().put('accountid', acc.ID);
            ApexPages.currentPage().getParameters().put('serialnum', 'TEST NUMBER');
            
            Asset__c newAsset1 = new Asset__c();  
            newAsset1.Account__c = acc.Id;
            newAsset1.Product__c = pr.ID;
            newAsset1.Serial_Number__c = 'TEST NUMBER';
            newAsset1.Start_Date__c = system.today();
            
            insert newAsset1;          
            
            ApexPages.StandardController sc1 = new ApexPages.standardController(newAsset1);             
            AssetCTRL AssetCTRL1 = new AssetCTRL(sc1);
            AssetCTRL1.save();              
            AssetCTRL1.cancel();     
             
            newAsset1 = new Asset__c();
            ApexPages.StandardController sc2 = new ApexPages.standardController(newAsset1);             
            AssetCTRL AssetCTRL2 = new AssetCTRL(sc2);
            AssetCTRL2.savenew();               
                        
            
            PageReference page2 = Page.NewServiceAssetNew;
            Test.setCurrentPage(page2);
            
            serviceAssetcontroller.isTestRunning = true;
                        
            ApexPages.currentPage().getParameters().put(label.AccountCFIDS, acc.Id);
            system.debug('*******pr2***'+pr2.ID);
            Service_Asset__c newServiceAsset1 = new Service_Asset__c();
            newServiceAsset1.Account__c = acc.ID;
            newServiceAsset1.Service_Product__c = pr2.ID;
            newServiceAsset1.Start_Date__c = system.today();
            insert  newServiceAsset1;  
            
            ApexPages.StandardController sc3 = new ApexPages.standardController(newServiceAsset1);              
            serviceAssetcontroller ServiceAssetCTRL1 = new serviceAssetcontroller(sc3);                           
            ServiceAssetCTRL1.save();
            ServiceAssetCTRL1.cancel(); 
                        
            ApexPages.StandardController sc4 = new ApexPages.standardController(newServiceAsset1);              
            serviceAssetcontroller ServiceAssetCTRL2 = new serviceAssetcontroller(sc4);
            
           // ServiceAssetCTRL2.savenew();             
            
           
            
            
       }    
        test.stopTest();
                       
    }    
}