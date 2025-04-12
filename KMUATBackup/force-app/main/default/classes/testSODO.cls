@isTest
public class testSODO
{
@isTest(SeeAllData=true)  
static void validateSODOtest1()
    {
        //Channelinsight.CI_TEST_TestUtils.createBaseInstallData();
        //test.startTest();
    UtilSODOFlags.skip_caseTrigges = true;
    Schema.DescribeSObjectResult AccDescribe = Schema.SObjectType.Account; 
       Map<String,Schema.RecordTypeInfo> AccRtMapByName = AccDescribe.getRecordTypeInfosByName();       
       Id AccRCTypeId = AccRtMapByName.get('ATI Accounts').getRecordTypeId();
    /*Account acc = new Account(Name='Test Account',
                              Region__c='EMEA',
                              Sub_Region__c='Middle East',
                              ATFE_SalesOrgName__c='Middle East',
                              ATFE_AccountType__c='Partner',
                              BillingCountry='Billing country',
                              BillingCity = 'billing city',
                              BillingStreet = 'billing street',
                              BillingPostalCode = 'billing postal code',
                              BillingState = 'Wisconsin');
        insert acc;    */
    Account acc = new Account(Name='Test Account',ATFE_AccountType__c = 'End Customer',Region__c = 'NA',Sub_Region__c = 'NA',
           ATFE_SalesOrgName__c = 'Sales Ops',website = 'www.none.com.in',RecordTypeId = AccRCTypeId,ATFE_VerticalMarketInit__c = 'Other',
           BillingCity = 'San Jose',BillingCountry = 'United States', BillingPostalCode  = '95134', BillingState = 'California',
           BillingStreet = 'Orchard Pkwy', ShippingCity = 'San Jose',ShippingCountry = 'United States', ShippingPostalCode = '95134', 
           ShippingState = 'California', ShippingStreet = 'Orchard Pkwy' );
       test.startTest();
       insert acc ;
       test.stopTest();
       System.assert(Acc.Id!= null);
    Pricebook2 pricbook =  [select id,CurrencyIsoCode from Pricebook2 where IsStandard = true AND isActive = true];
    
      // Insert product 
     list<Product2> products = new list<Product2>();
      
          
      Product2 pr = new Product2();
             pr.Name = 'TESTProduct1';
             pr.Description = 'test Desc';
             pr.Family = 'PRODUCT';
             pr.IsActive = true;
           //  pr.productcode = '960-002642';
           //  pr.PriceBook2Id =pricbookId ;
             pr.ATFE_Service_Product_Type__c = 'PC-1';
             products.add(pr);
             //insert pr;  
          
      Product2 pr1 = new Product2();
             pr1.Name = 'TESTProduct2';
             pr1.Description = 'test Desc';
             pr1.Family = 'SERVICE';
           //  pr1.productcode = '960-002642';
             pr1.ATFE_Service_Product_Type__c = 'NCB-3';             
             pr1.IsActive = true;
             products.add(pr1);
             //insert pr1;          
            insert products;
       system.debug('*****products***'+products);       
     for(Product2 oProduct : products)
     {
        if(oProduct.Name == 'TESTProduct1')
            pr = products[0];
        else
            pr1 = products[1];
     }
            
      PricebookEntry prEntry = new PricebookEntry();
            prEntry.IsActive = true;
            prEntry.Pricebook2Id = pricbook.ID;
            prEntry.Product2Id = pr1.ID;
            prEntry.UnitPrice  = 56;
            prEntry.CurrencyIsoCode = pricbook.CurrencyIsoCode;
            
        insert prEntry;            
                                                                  
       // Insert SAP SODO                             
      SAP_SODO__c SODO1 = new SAP_SODO__c();    
          sodo1.Name = 'test sodo';
          sodo1.Service_Product__c = pr1.ID;
          insert sodo1;
       
    list<SODO_Line_Item__c> SODOLineitems = new list<SODO_Line_Item__c>();
              
       // Insert SAP SODO Line Item
      SODO_Line_Item__c sodolineitem1 = new SODO_Line_Item__c();      
        sodolineitem1.SAP_SODO__c = sodo1.ID;
        sodolineitem1.Name = 'test liem item1';
        sodolineitem1.Product__c = pr.ID;
        sodolineitem1.Productcode__c  = '960-002642444';
        sodolineitem1.DO_Ship_Date__c = system.today();
        SODOLineitems.add(sodolineitem1);
       // insert sodolineitem1;
        
      SODO_Line_Item__c sodolineitem2 = new SODO_Line_Item__c();      
        sodolineitem2.SAP_SODO__c = sodo1.ID;
        sodolineitem2.Name = 'test liem item2';
        sodolineitem2.Product__c = pr1.ID;
        sodolineitem2.DO_Ship_Date__c = system.today();
        sodolineitem2.Productcode__c  = '960-002642678';
        SODOLineitems.add(sodolineitem2);        
        //insert sodolineitem2;
        insert SODOLineitems;        
        
        for(SODO_Line_Item__c lineitem : SODOLineitems)
        {
                if(lineitem.Name == 'test liem item1')              
                    sodolineitem1 = new SODO_Line_Item__c(ID=lineitem.Id);
                else
                    sodolineitem2 = new SODO_Line_Item__c(ID=lineitem.Id);
                
        }
            
      SAP_SODO__c  SAPSODO = new SAP_SODO__c();
          SAPSODO.Name = 'SAPSODO TESt Name';
          insert SAPSODO ;
          
        list<asset__c> hAssets = new list<asset__c>();
        
        asset__c  HWasset1 = new asset__c();
            HWasset1.Name = 'Test HW1';
            HWasset1.Product__c = pr.ID;
            HWasset1.Start_Date__c = system.today(); 
            HWasset1.Account__c = acc.ID;
            //insert HWasset1;
            hAssets.add(HWasset1);

        asset__c  HWasset2 = new asset__c();
            HWasset2.Name = 'Test HW2';
            HWasset2.Product__c = pr.ID;
            HWasset2.Start_Date__c = system.today(); 
            HWasset2.Account__c = acc.ID;
            hAssets.add(HWasset2);                       
            //insert HWasset2;                                       
        insert   hAssets;
           
        for(asset__c oAsset :hAssets )
        {
            if(oAsset.Name == 'Test HW1')
                HWasset1 = new asset__c(ID=oAsset.ID);
            else
                HWasset2 = new asset__c(ID=oAsset.ID);
        }       
            
     list<Service_Asset__c>    serviceAssets = new list<Service_Asset__c>();
     
      Service_Asset__c ServiceA = new Service_Asset__c();
          ServiceA.Name = 'Test SA';
          ServiceA.Account__c = acc.ID;
          ServiceA.SAP_SODO__c = SAPSODO.ID; 
          ServiceA.Service_Product__c = pr1.ID;
          ServiceA.SODO_Line_Item__c = sodolineitem1.ID;
          //insert ServiceA;
          serviceAssets.add(ServiceA);

      Service_Asset__c ServiceB = new Service_Asset__c();
          ServiceB.Name = 'Test SB';
          ServiceB.SAP_SODO__c = SAPSODO.ID; 
          ServiceB.Account__c = acc.ID;
          ServiceB.Service_Product__c = pr1.ID;
          ServiceB.asset__c  = HWasset1.ID;
          ServiceB.SODO_Line_Item__c = sodolineitem1.ID;
          //insert ServiceB;
          serviceAssets.add(ServiceB);
          insert serviceAssets;
          
          list<Service_Asset__c> serviceAssets2 = new list<Service_Asset__c>();
          
          for(Service_Asset__c os : serviceAssets)
          {
                Service_Asset__c osNew = new Service_Asset__c(Id=os.ID);
                
                if(os.Name == 'TEST SA')
                    osNew.Asset__c = HWasset1.ID;                                                       
                else
                    osNew.Asset__c = null;
                
            serviceAssets2.add(osNew);  
          }  
          UtilSODOFlags.skip_serviceAssetTrigger = false;                                     
          update serviceAssets2;
          //ServiceB.asset__c  = HWasset2.ID;                    
          //update ServiceB;          
          
       ServiceContract newS = new ServiceContract();
          //newS.AccountId = newAcc.Id;
          newS.Name = 'Name';
          news.SAP_SODO__c   = SAPSODO.ID; 
          newS.PriceBook2Id = pricbook.Id;
          newS.Service_Asset__c  = ServiceA.ID;
       insert newS;       
       /*EntitlementTemplate et = new EntitlementTemplate();
        et.Name = 'NCB-3';
        et.Term = 20;
        insert et;*/

        ApexPages.StandardController controller = new ApexPages.StandardController(newS); 
         ContractLineItemController ctrl = new ContractLineItemController(controller);                 
    }
static testMethod void validateSODOtest2()
    {
      //Channelinsight.CI_TEST_TestUtils.createBaseInstallData();
      Schema.DescribeSObjectResult AccDescribe = Schema.SObjectType.Account; 
       Map<String,Schema.RecordTypeInfo> AccRtMapByName = AccDescribe.getRecordTypeInfosByName();       
       Id AccRCTypeId = AccRtMapByName.get('ATI Accounts').getRecordTypeId();
        UtilSODOFlags.skip_serviceContactTigger = true; 
       Account Acc = new Account(Name='Test Account',ATFE_AccountType__c = 'End Customer',Region__c = 'NA',Sub_Region__c = 'NA',
           ATFE_SalesOrgName__c = 'Sales Ops',website = 'www.none.com.in',RecordTypeId = AccRCTypeId,ATFE_VerticalMarketInit__c = 'Other',
           BillingCity = 'San Jose',BillingCountry = 'United States', BillingPostalCode  = '95134', BillingState = 'California',
           BillingStreet = 'Orchard Pkwy', ShippingCity = 'San Jose',ShippingCountry = 'United States', ShippingPostalCode = '95134', 
           ShippingState = 'California', ShippingStreet = 'Orchard Pkwy' );
       insert Acc ;
       System.assert(Acc.Id!= null);
       
       // insert test product - type product
      Product2 newtestproduct = new Product2(ATFE_NA__c = true, ATFE_PartStatusDesc__c = 'Active-Active' ,ATFE_ProductRegion__c   = 'NA',
      ATFE_ProductType__c = 'OPTICAL', ATFE_Status__c = 'ACTIVE', CurrencyIsoCode = 'USD', 
      Description  = '500m 850nm 1000Base-SX Small Form Pluggable - Hot Swappable',
      Family = 'PRODUCT',IsActive = true,Name = 'AT-SPSX',ProductCode = '990-001201-00',Warranty__c = 'NA-NA-C-1825,CSA-CCA-L-90'
      );
      insert newtestproduct ;
      System.assert(newtestproduct.Id!= null);
      
       // insert test product - type service
      Product2 newtestservice = new Product2(ATFE_NA__c = true, ATFE_PartStatusDesc__c = 'Active-Active' ,ATFE_ProductRegion__c   = 'NA',
      ATFE_ProductType__c = 'T - SERVICE', ATFE_Status__c = 'ACTIVE', CurrencyIsoCode = 'USD', ATFE_Service_Product_Type__c='NCB-1',
      Description  = 'PS Bundle Serv 40 Hours',
      Family = 'SERVICE',IsActive = true,Name = 'AT-EFIH-40',ProductCode = '960-20201-40'
      );
      insert newtestservice ;
      System.assert(newtestservice.Id!= null);
      
      
      Asset__c TestHW = new Asset__c( Name = 'AT-SPSX' , Product__c = newtestproduct.id, Serial_Number__c = 'A234567890122345',
      Account__c = Acc.Id,  Start_Date__c = system.Today().addDays(-1));
      insert TestHW;
      System.assert(TestHW.Id!= null);
      
      Service_Asset__c TestSW = new Service_Asset__c(Account__c =Acc.Id ,Asset__c = TestHW.Id,Name = 'AT-EFIH-40',Service_Product__c = newtestservice.Id,Start_Date__c =  date.today());
      insert TestSW ;
      
      // new warranty code
      Warranty__c WarrantyCode = new Warranty__c(Description__c = '2 Years Warranty',Duration_Days__c = 730.00,Name = 'NA-NA-A-730',Region__c = 'NA',Sub_Region__c = 'NA',Warranty_Type__c = 'K'); 
      insert WarrantyCode ;
      System.assert(WarrantyCode.Id!= null);
      //new warranty item
      Warranty_Items__c W_Item = new Warranty_Items__c(Duration__c = WarrantyCode.Duration_Days__c ,HW_Asset__c = TestHW.Id ,
      Name = WarrantyCode.Name ,Region__c =  WarrantyCode.Region__c,Sub_Region__c = WarrantyCode.Sub_Region__c,
      Warranty_End_Date__c = date.today().addDays(730),Warranty_Start_Date__c = date.today(),Warranty__c = WarrantyCode.Id);
      insert W_Item;
      System.assert(W_Item.Id!= null);
       TestHW.Name = 'AT-SPSX1';
      TestHW.Start_Date__c =  system.today();
      update TestHW;
      
    }
}