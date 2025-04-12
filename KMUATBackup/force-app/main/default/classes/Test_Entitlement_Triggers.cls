@isTest
private class Test_Entitlement_Triggers {
 @isTest(SeeAllData=true)
 static void test_updateFirstResponse_Trigger() {
              id CasRCId = Case.SObjectType.getDescribe().getRecordTypeInfosByName().get('ATI Case').getRecordTypeId();
             
              
              List<CaseMilestone> CM = new List<CaseMilestone>();
              
              CM = [select Id, completionDate,TargetDate,startdate, CaseId,case.status from CaseMilestone cm where cm.MilestoneType.Name= 'Response' and completionDate = null and case.status ='New' and case.Recordtypeid = :CasRCId  limit 1]; 
              
              if(CM.size() > 0){
                  Case ATI_CAS = [select id,Accountid ,status, Contactid from Case where id = :CM[0].Caseid LIMIT 1]  ;
                  Case_Comment__c CC = new Case_Comment__c();
                  CC.Case__c = ATI_CAS.id;
                  CC.Comment__c = 'Test_comment';
                  CC.Comment_Type__c = 'TAC Comment';
                  CC.Public__c = true;
                  insert CC;
              
              }
              
              CM = [select Id, completionDate,TargetDate,startdate, CaseId,case.status from CaseMilestone cm where cm.MilestoneType.Name= 'First response' and completionDate = null and case.status ='New' and case.Recordtypeid = :CasRCId limit 1]; 
              
              if(CM.size() > 0){
                  Case ATI_CAS = [select id,Accountid ,status, Contactid from Case where id = :CM[0].Caseid LIMIT 1]  ;
                  Case_Comment__c CC = new Case_Comment__c();
                  CC.Case__c = ATI_CAS.id;
                  CC.Comment__c = 'Test_comment';
                  CC.Comment_Type__c = 'TAC Comment';
                  CC.Public__c = true;
                  insert CC;
              
              }
              
 }
 @isTest(SeeAllData=true)
  static void test_entDateChange_controller () {
              id CasRCId = Case.SObjectType.getDescribe().getRecordTypeInfosByName().get('ATI Case').getRecordTypeId();
              id AccntRCTypeId = Account.SObjectType.getDescribe().getRecordTypeInfosByName().get('ATI Accounts').getRecordTypeId();
              id ContctRCTypeId= Contact.SObjectType.getDescribe().getRecordTypeInfosByName().get('Americas Contacts').getRecordTypeId();
              
              Account Accnt = new Account(Name='Test Account',ATFE_AccountType__c = 'End Customer',Region__c = 'NA',Sub_Region__c = 'NA',
              ATFE_SalesOrgName__c = 'Sales Ops',website = 'www.none.com.in',RecordTypeId = AccntRCTypeId,ATFE_VerticalMarketInit__c = 'Other',
              BillingCity = 'San Jose',BillingCountry = 'United States', BillingPostalCode  = '95134', BillingState = 'California',
              BillingStreet = 'Orchard Pkwy', ShippingCity = 'San Jose',ShippingCountry = 'United States', ShippingPostalCode = '95134', 
              ShippingState = 'California', ShippingStreet = 'Orchard Pkwy' );
              insert Accnt;
              
              Contact Contct = new Contact(FirstName  = 'TestFirstName', LastName  = 'TestLastName',RecordTypeId  = ContctRCTypeId ,AccountId  = Accnt.id, Email = 'none1234@none.com',
              Phone  = '+9140 80000000' );
              insert Contct;
              
              Product2 testproduct = new Product2(ATFE_NA__c = true, ATFE_PartStatusDesc__c = 'Active-Active' ,ATFE_ProductRegion__c   = 'NA',
              ATFE_ProductType__c = 'OPTICAL', ATFE_Status__c = 'ACTIVE', CurrencyIsoCode = 'USD', 
              Description  = '500m 850nm 1000Base-SX Small Form Pluggable - Hot Swappable',
              Family = 'PRODUCT',IsActive = true,Name = 'AT-SPSX',ProductCode = '990-001201-00',Warranty__c = 'NA-NA-C-1825,CSA-CCA-L-90'
              );
              
              insert testproduct;
              
              Asset__c TestHarWar = new Asset__c( Name = 'AT-SPSX' , Product__c = testproduct.id, Serial_Number__c = 'A234567890122345',
              Account__c = Accnt.Id,  Start_Date__c = date.Today());
              insert TestHarWar ;
              
              // insert test product - type service
              Product2 newtestservice = new Product2(ATFE_NA__c = true, ATFE_PartStatusDesc__c = 'Active-Active' ,ATFE_ProductRegion__c   = 'NA',
              ATFE_ProductType__c = 'T - SERVICE', ATFE_Status__c = 'ACTIVE', CurrencyIsoCode = 'USD', ATFE_Service_Product_Type__c='NCB-1',
              Description  = 'PS Bundle Serv 40 Hours',
              Family = 'SERVICE',IsActive = true,Name = 'AT-EFIH-40',ProductCode = '960-20201-40'
              );
              
              insert newtestservice ;
              
              // new warranty code
              Warranty__c WarrantyCode = new Warranty__c(Description__c = '2 Years Warranty',Duration_Days__c = 730.00,Name = 'NA-NA-A-730',Region__c = 'NA',Sub_Region__c = 'NA',Warranty_Type__c = 'K'); 
              insert WarrantyCode ;
              
             
              
              Service_Asset__c TestSW = new Service_Asset__c(Account__c =Accnt.Id ,Asset__c = TestHarWar.Id,Name = 'AT-EFIH-40',Service_Product__c = newtestservice.Id,Start_Date__c =  date.today());
              Warranty_Items__c W_Item = new Warranty_Items__c(Duration__c = WarrantyCode.Duration_Days__c ,HW_Asset__c = TestHarWar.Id ,
              Name = WarrantyCode.Name ,Region__c =  WarrantyCode.Region__c,Sub_Region__c = WarrantyCode.Sub_Region__c,
              Warranty_End_Date__c = date.today().addDays(730),Warranty_Start_Date__c = date.today(),Warranty__c = WarrantyCode.Id);
              insert W_Item;
              Test.StartTest();
             
              insert TestSW;
              
               Test.StopTest();  
  }
  /** 
    @isTest(SeeAllData=true)
    static void test_rmaTrigger() {
    
         id rmaCaseId = Case.SObjectType.getDescribe().getRecordTypeInfosByName().get('ATI RMA Child Case').getRecordTypeId();
              Id AccRCTypeId = Account.SObjectType.getDescribe().getRecordTypeInfosByName().get('ATI Accounts').getRecordTypeId();
              Id ConRCTypeId = Contact.SObjectType.getDescribe().getRecordTypeInfosByName().get('Americas Contacts').getRecordTypeId();
              
              Account Acc = new Account(Name='Test Account',ATFE_AccountType__c = 'End Customer',Region__c = 'NA',Sub_Region__c = 'NA',
              ATFE_SalesOrgName__c = 'Sales Ops',website = 'www.none.com.in',RecordTypeId = AccRCTypeId,ATFE_VerticalMarketInit__c = 'Other',
              BillingCity = 'San Jose',BillingCountry = 'United States', BillingPostalCode  = '95134', BillingState = 'California',
              BillingStreet = 'Orchard Pkwy', ShippingCity = 'San Jose',ShippingCountry = 'United States', ShippingPostalCode = '95134', 
              ShippingState = 'California', ShippingStreet = 'Orchard Pkwy' );
              insert Acc ;
              
              Account Accnt = new Account(Name='Test Account1',ATFE_AccountType__c = 'End Customer',Region__c = 'NA',Sub_Region__c = 'NA',
              ATFE_SalesOrgName__c = 'Sales Ops',website = 'www.none.com.in',RecordTypeId = AccRCTypeId,ATFE_VerticalMarketInit__c = 'Other',
              BillingCity = 'San Jose',BillingCountry = 'United States', BillingPostalCode  = '95134', BillingState = 'California',
              BillingStreet = 'Orchard Pkwy', ShippingCity = 'San Jose',ShippingCountry = 'United States', ShippingPostalCode = '95134', 
              ShippingState = 'California', ShippingStreet = 'Orchard Pkwy' );
              insert Accnt ;
              
              Contact Cont = new Contact(FirstName  = 'TestFirstName', LastName  = 'TestLastName',RecordTypeId  = ConRCTypeId ,AccountId  = Accnt.id, Email = 'none@none.com',
              Phone  = '+9140 80000000' );
              insert Cont;
              
              Contact Con = new Contact(FirstName  = 'TestFirstName', LastName  = 'TestLastName',RecordTypeId  = ConRCTypeId ,AccountId  = Acc.id, Email = 'none@none.com',
              Phone  = '+9140 80000000' );
              insert Con;
              
              Product2 testproduct = new Product2(ATFE_NA__c = true, ATFE_PartStatusDesc__c = 'Active-Active' ,ATFE_ProductRegion__c   = 'NA',
              ATFE_ProductType__c = 'OPTICAL', ATFE_Status__c = 'ACTIVE', CurrencyIsoCode = 'USD', 
              Description  = '500m 850nm 1000Base-SX Small Form Pluggable - Hot Swappable',
              Family = 'PRODUCT',IsActive = true,Name = 'AT-SPSX',ProductCode = '990-001201-00',Warranty__c = 'NA-NA-C-1825,CSA-CCA-L-90'
              );
              
              insert testproduct;
              
              Asset__c TestHarWar = new Asset__c( Name = 'AT-SPSX' , Product__c = testproduct.id, Serial_Number__c = 'A234567890122345',
              Account__c = Acc.Id,  Start_Date__c = date.Today(),End_Date__c = date.Today());
              insert TestHarWar ;
              
              // insert test product - type service
              Product2 newtestservice = new Product2(ATFE_NA__c = true, ATFE_PartStatusDesc__c = 'Active-Active' ,ATFE_ProductRegion__c   = 'NA',
              ATFE_ProductType__c = 'T - SERVICE', ATFE_Status__c = 'ACTIVE', CurrencyIsoCode = 'USD', ATFE_Service_Product_Type__c='NCB-1',
              Description  = 'PS Bundle Serv 40 Hours',
              Family = 'SERVICE',IsActive = true,Name = 'AT-EFIH-40',ProductCode = '960-20201-40'
              );
              
              // new warranty code
              Warranty__c WarrantyCode = new Warranty__c(Description__c = '2 Years Warranty',Duration_Days__c = 730.00,Name = 'NA-NA-A-730',Region__c = 'NA',Sub_Region__c = 'NA',Warranty_Type__c = 'K'); 
              insert WarrantyCode ;
              
             
              
              Service_Asset__c TestSW = new Service_Asset__c(Account__c =Accnt.Id ,Asset__c = TestHarWar.Id,Name = 'AT-EFIH-40',Service_Product__c = newtestservice.Id,Start_Date__c =  date.today());
              
              Warranty_Items__c W_Item = new Warranty_Items__c(Duration__c = WarrantyCode.Duration_Days__c ,HW_Asset__c = TestHarWar.Id ,
              Name = WarrantyCode.Name ,Region__c =  WarrantyCode.Region__c,Sub_Region__c = WarrantyCode.Sub_Region__c,
              Warranty_End_Date__c = date.today().addDays(730),Warranty_Start_Date__c = date.today(),Warranty__c = WarrantyCode.Id);
              insert W_Item;
              
              system.debug('### W_Item ###' + W_Item);
                 
              Test.StartTest();
              //TestHarWar.End_Date__c = date.Today().addDays(1);
              //TestHarWar.Account__c = Accnt.id;
              
              update TestHarWar ;
              
              Case ATI_child_CASE = new Case();   
              ATI_child_CASE.Accountid  = Acc.Id ; //Account Name
              ATI_child_CASE.Contactid  = Con.Id; //Contact Name
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
              
              insert  ATI_child_CASE;
              
             Test.StopTest();
    
    }
**/
}