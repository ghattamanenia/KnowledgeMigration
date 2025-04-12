@isTest
private class Test_serviceConsole_components {
private  static Id AccRCTypeId;
private  static Id ConRCTypeId;
private  static Id  ATI_CaseID;
private  static Id  ATI_RMAParent_CASEID;
private  static Account Acc;
private  static Contact Con;
//private  static ID guestProfileID;
//private  static ID CommunityProfileID;
//private  static User guest_user;
//private  static User com_user;
private  static Product2 newtestproduct;
private  static Product2 newtestservice;
private  static Asset__c TestHW;
private  static Warranty__c WarrantyCode;
private  static Warranty_Items__c W_Item; 
private  static Service_Asset__c TestSW;
//common  test data
static {
   Schema.DescribeSObjectResult AccDescribe = Schema.SObjectType.Account; 
   Map<String,Schema.RecordTypeInfo> AccRtMapByName = AccDescribe.getRecordTypeInfosByName();       
   AccRCTypeId = AccRtMapByName.get('ATI Accounts').getRecordTypeId();
   //Channelinsight.CI_TEST_TestUtils.createBaseInstallData(); Neha commented for model n package uninstallation
   Schema.DescribeSObjectResult ConDescribe = Schema.SObjectType.Contact; 
   Map<String,Schema.RecordTypeInfo> ConRtMapByName = ConDescribe.getRecordTypeInfosByName();
   ConRCTypeId = ConRtMapByName.get('Americas Contacts').getRecordTypeId();
   
   //Get Case record type info through DescribeSObjectResult - this is better as no SOQL is used.
   Schema.DescribeSObjectResult caseDescribe = Schema.SObjectType.Case; 
   Map<String,Schema.RecordTypeInfo> caseRtMapByName = caseDescribe.getRecordTypeInfosByName();
   ATI_CaseID = caseRtMapByName.get('ATI Case').getRecordTypeId();
   ATI_RMAParent_CASEID = caseRtMapByName.get('ATI RMA Parent Case').getRecordTypeId();
   
   //guestProfileID = [SELECT Id,Name FROM Profile where Name = 'Customer Support Profile'].Id;
   //CommunityProfileID = [SELECT Id,Name FROM Profile where Name = 'Customer Support Community'].Id;
  
   
   Acc = new Account(Name='Test Account',ATFE_AccountType__c = 'End Customer',Region__c = 'NA',Sub_Region__c = 'NA',
       ATFE_SalesOrgName__c = 'Sales Ops',website = 'www.none.com.in',RecordTypeId = AccRCTypeId,ATFE_VerticalMarketInit__c = 'Other',
       BillingCity = 'San Jose',BillingCountry = 'United States', BillingPostalCode  = '95134', BillingState = 'California',
       BillingStreet = 'Orchard Pkwy', ShippingCity = 'San Jose',ShippingCountry = 'United States', ShippingPostalCode = '95134', 
       ShippingState = 'California', ShippingStreet = 'Orchard Pkwy' );
   insert Acc ;
   System.assert(Acc.Id!= null);
   Con = new Contact(FirstName  = 'Test FirstName', LastName  = 'Test LastName',RecordTypeId  = ConRCTypeId ,AccountId  = Acc.id, Email = 'none@none.com',
   Phone  = '+9140 80000000' );
    insert Con ;
   System.assert(Con.Id!= null);
   
  
   //new Test hw Asset
  // insert test product - type product
  newtestproduct = new Product2(ATFE_NA__c = true, ATFE_PartStatusDesc__c = 'Active-Active' ,ATFE_ProductRegion__c   = 'NA',
  ATFE_ProductType__c = 'OPTICAL', ATFE_Status__c = 'ACTIVE', CurrencyIsoCode = 'USD', 
  Description  = '500m 850nm 1000Base-SX Small Form Pluggable - Hot Swappable',
  Family = 'PRODUCT',IsActive = true,Name = 'AT-SPSX',ProductCode = '990-001201-00',Warranty__c = 'NA-NA-C-1825,CSA-CCA-L-90'
  );
  
  insert newtestproduct ;
  System.assert(newtestproduct.Id!= null);
 
 // insert test product - type service
  newtestservice = new Product2(ATFE_NA__c = true, ATFE_PartStatusDesc__c = 'Active-Active' ,ATFE_ProductRegion__c   = 'NA',
  ATFE_ProductType__c = 'T - SERVICE', ATFE_Status__c = 'ACTIVE', CurrencyIsoCode = 'USD', ATFE_Service_Product_Type__c='NCB-1',
  Description  = 'PS Bundle Serv 40 Hours',
  Family = 'SERVICE',IsActive = true,Name = 'AT-EFIH-40',ProductCode = '960-20201-40'
  );
  
  insert newtestservice ;
  System.assert(newtestservice.Id!= null);
  // insert test hardware asset.


  TestHW = new Asset__c( Name = 'AT-SPSX' , Product__c = newtestproduct.id, Serial_Number__c = 'A234567890122345',
  Account__c = Acc.Id,  Start_Date__c = date.Today());
  insert TestHW;
  System.assert(TestHW.Id!= null);
  // new warranty code
  WarrantyCode = new Warranty__c(Description__c = '2 Years Warranty',Duration_Days__c = 730.00,Name = 'NA-NA-A-730',Region__c = 'NA',Sub_Region__c = 'NA',Warranty_Type__c = 'K'); 
  insert WarrantyCode ;
  System.assert(WarrantyCode.Id!= null);
  //new warranty item
  W_Item = new Warranty_Items__c(Duration__c = WarrantyCode.Duration_Days__c ,HW_Asset__c = TestHW.Id ,
  Name = WarrantyCode.Name ,Region__c =  WarrantyCode.Region__c,Sub_Region__c = WarrantyCode.Sub_Region__c,
  Warranty_End_Date__c = date.today().addDays(730),Warranty_Start_Date__c = date.today(),Warranty__c = WarrantyCode.Id);
  insert W_Item;
  System.assert(W_Item.Id!= null);
  
  //new service Asset
  UtilSODOFlags.skip_serviceAssetTrigger = true;
  UtilSODOFlags.skip_serviceContactTigger = true;
  TestSW = new Service_Asset__c(Account__c =Acc.Id ,Asset__c = TestHW.Id,Name = 'AT-EFIH-40',Service_Product__c = newtestservice.Id,Start_Date__c =  date.today());
  insert TestSW ;
  System.assert(TestSW.Id!= null);
 
   
}
 

static testMethod void validate_ServiceConsoleSearch_Controller() {
        Case ATI_CASE = new Case();   
        ATI_CASE.Accountid  = Acc.Id ; //Account Name
        ATI_CASE.Contactid  = Con.Id; //Contact Name
        ATI_CASE.Request_Title__c  = 'Test parent Request'; //Customer title
        ATI_CASE.Description  = 'Test parent Request';  //Customer description
        ATI_CASE.Impact__c= 'High'; //Impact
        ATI_CASE.Urgency__c= 'High'; //Impact 
        ATI_CASE.Hw_Asset_Name__c   =  TestHw.Id; 
             
        ATI_CASE.RecordTypeId = ATI_RMAParent_CASEID;
        insert ATI_CASE;
        
        PageReference pageRef = Page.ServiceConsoleSearch;
        Test.setCurrentPage(pageRef);
        
        ServiceConsoleSearchController  ConsoleSearch = new ServiceConsoleSearchController(); 
        ConsoleSearch.keyword = 'Test';
       
        ConsoleSearch.search();
}

}