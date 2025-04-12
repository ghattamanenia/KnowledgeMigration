@isTest
private class Test_Entitlement_Classes {
    
     
     
     private static Id CasRCId;
     private static Id AccntRCTypeId;
     private static Id ContctRCTypeId;
     private static Account Accnt;
     private static Contact Contct;
     private static Product2 testproduct;
     private static Asset__c TestHarWar;
     private static case ATI_CAS;
   
     
      static {  
     // Channelinsight.CI_TEST_TestUtils.createBaseInstallData(); Neha commented for model n package uninstallation
              CasRCId = Case.SObjectType.getDescribe().getRecordTypeInfosByName().get('ATI Case').getRecordTypeId();
              AccntRCTypeId = Account.SObjectType.getDescribe().getRecordTypeInfosByName().get('ATI Accounts').getRecordTypeId();
              ContctRCTypeId= Contact.SObjectType.getDescribe().getRecordTypeInfosByName().get('Americas Contacts').getRecordTypeId();
              
              Accnt = new Account(Name='Test Account',ATFE_AccountType__c = 'End Customer',Region__c = 'NA',Sub_Region__c = 'NA',
              ATFE_SalesOrgName__c = 'Sales Ops',website = 'www.none.com.in',RecordTypeId = AccntRCTypeId,ATFE_VerticalMarketInit__c = 'Other',
              BillingCity = 'San Jose',BillingCountry = 'United States', BillingPostalCode  = '95134', BillingState = 'California',
              BillingStreet = 'Orchard Pkwy', ShippingCity = 'San Jose',ShippingCountry = 'United States', ShippingPostalCode = '95134', 
              ShippingState = 'California', ShippingStreet = 'Orchard Pkwy' );
              upsert Accnt;
              
              Contct = new Contact(FirstName  = 'TestFirstName', LastName  = 'TestLastName',RecordTypeId  = ContctRCTypeId ,AccountId  = Accnt.id, Email = 'none123@none.com',
              Phone  = '+9140 80000000' );
              upsert Contct;
              
              testproduct = new Product2(ATFE_NA__c = true, ATFE_PartStatusDesc__c = 'Active-Active' ,ATFE_ProductRegion__c   = 'NA',
              ATFE_ProductType__c = 'OPTICAL', ATFE_Status__c = 'ACTIVE', CurrencyIsoCode = 'USD', 
              Description  = '500m 850nm 1000Base-SX Small Form Pluggable - Hot Swappable',
              Family = 'PRODUCT',IsActive = true,Name = 'AT-SPSX',ProductCode = '990-001201-00',Warranty__c = 'NA-NA-C-1825,CSA-CCA-L-90'
              );
              
              upsert testproduct;
              
              TestHarWar = new Asset__c( Name = 'AT-SPSX' , Product__c = testproduct.id, Serial_Number__c = 'A234567890122345',
              Account__c = Accnt.Id,  Start_Date__c = date.Today());
              insert TestHarWar ;
                 
              ATI_CAS = new Case();   
              ATI_CAS.Accountid  = Accnt.Id ; //Account Name
              ATI_CAS.Contactid  = Contct.Id; //Contact Name
              ATI_CAS.Request_Title__c  = 'Test Request'; //Customer title
              ATI_CAS.Description  = 'Test description';  //Customer description
              ATI_CAS.Hw_Asset_Name__c = TestHarWar.Id;
              //ATI_CASE.Warranty__c  = W_Item.id; //Warranty
              ATI_CAS.Impact__c= 'High'; //Impact
              ATI_CAS.Urgency__c= 'High'; //Impact           
              ATI_CAS.RecordTypeId = CasRCId;
              ATI_CAS.Status = 'New';
              ATI_CAS.Priority = 'P1';
              
              upsert ATI_CAS;
      
             
      
      }
      
       static testmethod  void test_Batch_Recycling_Case() {
       //Channelinsight.CI_TEST_TestUtils.createBaseInstallData();Neha commented for model n package uninstallation
       
              id rmaCaseId = Case.SObjectType.getDescribe().getRecordTypeInfosByName().get('ATI RMA Child Case').getRecordTypeId();
             // Id AccRCTypeId = Account.SObjectType.getDescribe().getRecordTypeInfosByName().get('ATI Accounts').getRecordTypeId();
            //  Id ConRCTypeId = Contact.SObjectType.getDescribe().getRecordTypeInfosByName().get('Americas Contacts').getRecordTypeId();
              
             /* Account Acc = new Account(Name='Test Account',ATFE_AccountType__c = 'End Customer',Region__c = 'NA',Sub_Region__c = 'NA',
              ATFE_SalesOrgName__c = 'Sales Ops',website = 'www.none.com.in',RecordTypeId = AccRCTypeId,ATFE_VerticalMarketInit__c = 'Other',
              BillingCity = 'San Jose',BillingCountry = 'United States', BillingPostalCode  = '95134', BillingState = 'California',
              BillingStreet = 'Orchard Pkwy', ShippingCity = 'San Jose',ShippingCountry = 'United States', ShippingPostalCode = '95134', 
              ShippingState = 'California', ShippingStreet = 'Orchard Pkwy' );
              upsert Acc ;
              
              Contact Con = new Contact(FirstName  = 'TestFirstName', LastName  = 'TestLastName',RecordTypeId  = ConRCTypeId ,AccountId  = Acc.id, Email = 'none@none.com',
              Phone  = '+9140 80000000' );
                Test.startTest();
              upsert Con;*/
                 
              Case ATI_child_CASE = new Case();   
              ATI_child_CASE.Accountid  = Accnt.Id ; //Account Name
              ATI_child_CASE.Contactid  = Contct.Id; //Contact Name
              ATI_child_CASE.Request_Title__c  = 'Test Request'; //Customer title
              ATI_child_CASE.Description  = 'Test description';  //Customer description
              //ATI_CASE.Hw_Asset_Name__c = TestHW.Id;
              //ATI_CASE.Warranty__c  = W_Item.id; //Warranty
              ATI_child_CASE.Impact__c= 'High'; //Impact
              ATI_child_CASE.Urgency__c= 'High'; //Impact           
              ATI_child_CASE.RecordTypeId = rmaCaseId;
              ATI_child_CASE.Status = 'New';
              ATI_child_CASE.RMA_Status__c= 'Awaiting Shipment';
             // ATI_child_CASE.X1_Hour_Notification__c = true;
             // ATI_child_CASE.X4_Hr_Notification__c = true;
       Test.startTest();
              upsert ATI_child_CASE;
     
            Batch_Recycling_Case rL = new Batch_Recycling_Case ();
           database.executebatch(rL);
       Test.stopTest();
     
     }
      
      static testmethod  void test_warrnty_controller () {
     // Channelinsight.CI_TEST_TestUtils.createBaseInstallData();
       Id AccRCTypeId = Account.SObjectType.getDescribe().getRecordTypeInfosByName().get('ATI Accounts').getRecordTypeId();
              
       /*  Account Acc = new Account(Name='Test Account',ATFE_AccountType__c = 'End Customer',Region__c = 'NA',Sub_Region__c = 'NA',
              ATFE_SalesOrgName__c = 'Sales Ops',website = 'www.none.com.in',RecordTypeId = AccRCTypeId,ATFE_VerticalMarketInit__c = 'Other',
              BillingCity = 'San Jose',BillingCountry = 'United States', BillingPostalCode  = '95134', BillingState = 'California',
              BillingStreet = 'Orchard Pkwy', ShippingCity = 'San Jose',ShippingCountry = 'United States', ShippingPostalCode = '95134', 
              ShippingState = 'California', ShippingStreet = 'Orchard Pkwy' );
              insert Acc ;*/
     
     
     Product2 newtestproduct = new Product2(ATFE_NA__c = true, ATFE_PartStatusDesc__c = 'Active-Active' ,ATFE_ProductRegion__c   = 'NA',
      ATFE_ProductType__c = 'OPTICAL', ATFE_Status__c = 'ACTIVE', CurrencyIsoCode = 'USD', 
      Description  = '500m 850nm 1000Base-SX Small Form Pluggable - Hot Swappable',
      Family = 'PRODUCT',IsActive = true,Name = 'AT-SPSX',ProductCode = '990-00**^^1201-00',Warranty__c = 'NA-NA-C-1825,CSA-CCA-L-90'
      );
     
      upsert newtestproduct ;
       Test.StartTest();
      Asset__c TestHW = new Asset__c( Name = 'AT-SPSX' , Product__c = newtestproduct.id, Serial_Number__c = 'A234567890122345',
      Account__c = Accnt.Id,  Start_Date__c = date.Today());
      upsert TestHW;
      
      Warranty__c WarrantyCode = new Warranty__c(Description__c = '2 Years Warranty',Duration_Days__c = 730.00,Name = 'NA-NA-A-730',Region__c = 'NA',Sub_Region__c = 'NA',Warranty_Type__c = 'K'); 
      upsert WarrantyCode ;
      
      Warranty_Items__c W_Item = new Warranty_Items__c(Duration__c = WarrantyCode.Duration_Days__c ,HW_Asset__c = TestHW.Id ,
      Name = WarrantyCode.Name ,Region__c =  WarrantyCode.Region__c,Sub_Region__c = WarrantyCode.Sub_Region__c,
      Warranty_End_Date__c = date.today().addDays(730),Warranty_Start_Date__c = date.today(),Warranty__c = WarrantyCode.Id);
      upsert W_Item;
      Test.StopTest();
      PageReference pageRef = Page.Warranty_Related_List;
      pageRef.getParameters().put('id', TestHW.id);
      Test.setCurrentPage(pageRef);
      
      warrnty_controller WC = new warrnty_controller();
      
      pageRef.getParameters().put('id', WarrantyCode.id);
      Test.setCurrentPage(pageRef);
      
      warrnty_controller WC1 = new warrnty_controller();
     
     
     }
     @isTest(SeeAllData=true)
     static void test_Milestone_controller () {
             //Channelinsight.CI_TEST_TestUtils.createBaseInstallData();
             PageReference pageRef = Page.MileStone_Related_List;
             pageRef.getParameters().put('id', ATI_CAS.id);
             Test.setCurrentPage(pageRef);
             
             Milestone_controller MC = new Milestone_controller();
     
     }
     
     @isTest(SeeAllData=true)
     static void test_BusinessHour () {
              //Channelinsight.CI_TEST_TestUtils.createBaseInstallData();
              Id CaseRCId = Case.SObjectType.getDescribe().getRecordTypeInfosByName().get('ATI Case').getRecordTypeId();
              
              Id AccRCTypeId = Account.SObjectType.getDescribe().getRecordTypeInfosByName().get('ATI Accounts').getRecordTypeId();
              Id ConRCTypeId = Contact.SObjectType.getDescribe().getRecordTypeInfosByName().get('Americas Contacts').getRecordTypeId();
              
             /* Account Acc = new Account(Name='Test Account',ATFE_AccountType__c = 'End Customer',Region__c = 'NA',Sub_Region__c = 'NA',
              ATFE_SalesOrgName__c = 'Sales Ops',website = 'www.none.com.in',RecordTypeId = AccRCTypeId,ATFE_VerticalMarketInit__c = 'Other',
              BillingCity = 'San Jose',BillingCountry = 'United States', BillingPostalCode  = '95134', BillingState = 'California',
              BillingStreet = 'Orchard Pkwy', ShippingCity = 'San Jose',ShippingCountry = 'United States', ShippingPostalCode = '95134', 
              ShippingState = 'California', ShippingStreet = 'Orchard Pkwy' );
              upsert Acc ;*/
              
              /*Contact Con = new Contact(FirstName  = 'TestFirstName', LastName  = 'TestLastName',RecordTypeId  = ConRCTypeId ,AccountId  = Acc.id, Email = 'none@none.com',
              Phone  = '+9140 80000000' );
              upsert Con;*/
              
              Product2 newtestproduct = new Product2(ATFE_NA__c = true, ATFE_PartStatusDesc__c = 'Active-Active' ,ATFE_ProductRegion__c   = 'NA',
              ATFE_ProductType__c = 'OPTICAL', ATFE_Status__c = 'ACTIVE', CurrencyIsoCode = 'USD', 
              Description  = '500m 850nm 1000Base-SX Small Form Pluggable - Hot Swappable',
              Family = 'PRODUCT',IsActive = true,Name = 'AT-SPSX',ProductCode = '990-zzz*01201-00',Warranty__c = 'NA-NA-C-1825,CSA-CCA-L-90'
              );
              
              upsert newtestproduct ;
              
              Asset__c TestHW = new Asset__c( Name = 'AT-SPSX' , Product__c = newtestproduct.id, Serial_Number__c = 'A234567890122345',
              Account__c = Accnt.Id,  Start_Date__c = date.Today());
              upsert TestHW;
              
            
              List<Case> ALLCases = new List<Case>();
             for(integer i=0;i<1;i++)
             {
              case  ATI_CASE = new Case();   
              ATI_CASE.Accountid  = Accnt.Id ; //Account Name
              ATI_CASE.Contactid  = Contct.Id; //Contact Name
              ATI_CASE.Request_Title__c  = 'Test Request'; //Customer title
              ATI_CASE.Description  = 'Test description';  //Customer description
              ATI_CASE.Hw_Asset_Name__c = TestHW.Id;
              //ATI_CASE.Warranty__c  = W_Item.id; //Warranty
              ATI_CASE.Impact__c= 'High'; //Impact
              ATI_CASE.Urgency__c= 'High'; //Impact           
              ATI_CASE.RecordTypeId = CaseRCId;
              ATI_CASE.Status = 'New';
              ATI_CASE.Priority = 'P1';
             ALLCases.add(ATI_CASE);
             
             
             }
           // test.startTest();
             //upsert ALLCases;
            // test.stopTest();
             UtilSODOFlags.skip_caseTrigges =  true;
              BusinessHour BH = new BusinessHour();
              BusinessHour.updatCase(ALLCases,true);
         
     }
     
      @isTest(SeeAllData=true)
     static void test_LocationCallouts () {
     //Channelinsight.CI_TEST_TestUtils.createBaseInstallData();
         Id CaseRCId = Case.SObjectType.getDescribe().getRecordTypeInfosByName().get('ATI Case').getRecordTypeId();
              
              Id AccRCTypeId = Account.SObjectType.getDescribe().getRecordTypeInfosByName().get('ATI Accounts').getRecordTypeId();
              Id ConRCTypeId = Contact.SObjectType.getDescribe().getRecordTypeInfosByName().get('Americas Contacts').getRecordTypeId();
              
/*              Account Acc = new Account(Name='Test Account1',ATFE_AccountType__c = 'End Customer',Region__c = 'NA',Sub_Region__c = 'NA',
              ATFE_SalesOrgName__c = 'Sales Ops',website = 'www.none.com.in',RecordTypeId = AccRCTypeId,ATFE_VerticalMarketInit__c = 'Other',
              BillingCity = 'San Jose',BillingCountry = 'United States', BillingPostalCode  = '95134', BillingState = 'California',
              BillingStreet = 'Orchard Pkwy', ShippingCity = 'San Jose',ShippingCountry = 'United States', ShippingPostalCode = '95134', 
              ShippingState = 'California', ShippingStreet = 'Orchard Pkwy' );
              Test.StartTest();
              insert Acc ;
              
              List<Id> Accnts = new List<Id>();
              Accnts.add(Acc.id);
            
              
              //StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
                //mock.setStaticResource('[{"location" : {"lat" : 37.42291810, "lng" : -122.08542120}}]');
               // mock.setStatusCode(200);
                //mock.setHeader('Content-Type', 'application/json');
        
        // Set the mock callout mode
        //Test.setMock(HttpCalloutMock.class, mock);
        
//             Test.setMock(HttpCalloutMock.class, fakeResponse); 
              LocationCallouts.getLocation(Accnts);
              Test.StopTest();
*/     
     }
     


}