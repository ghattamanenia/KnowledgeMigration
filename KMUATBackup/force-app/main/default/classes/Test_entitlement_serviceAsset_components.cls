@isTest
private class Test_entitlement_serviceAsset_components{
private  static Id AccRCTypeId;
private  static Account Acc;
private  static Product2 newtestproduct;
private  static Product2 newtestservice;
private  static Asset__c TestHW;

static {
        
       Schema.DescribeSObjectResult AccDescribe = Schema.SObjectType.Account; 
       Map<String,Schema.RecordTypeInfo> AccRtMapByName = AccDescribe.getRecordTypeInfosByName();       
       AccRCTypeId = AccRtMapByName.get('ATI Accounts').getRecordTypeId();
       //Channelinsight.CI_TEST_TestUtils.createBaseInstallData();
       Acc = new Account(Name='Test Account',ATFE_AccountType__c = 'End Customer',Region__c = 'NA',Sub_Region__c = 'NA',
           ATFE_SalesOrgName__c = 'Sales Ops',website = 'www.none.com.in',RecordTypeId = AccRCTypeId,ATFE_VerticalMarketInit__c = 'Other',
           BillingCity = 'San Jose',BillingCountry = 'United States', BillingPostalCode  = '95134', BillingState = 'California',
           BillingStreet = 'Orchard Pkwy', ShippingCity = 'San Jose',ShippingCountry = 'United States', ShippingPostalCode = '95134', 
           ShippingState = 'California', ShippingStreet = 'Orchard Pkwy' );
       insert Acc ;
       System.assert(Acc.Id!= null);
      // insert test product - type product
      newtestproduct = new Product2(ATFE_NA__c = true, ATFE_PartStatusDesc__c = 'Active-Active' ,ATFE_ProductRegion__c   = 'NA',
      ATFE_ProductType__c = 'OPTICAL', ATFE_Status__c = 'ACTIVE', CurrencyIsoCode = 'USD', 
      Description  = '500m 850nm 1000Base-SX Small Form Pluggable - Hot Swappable',
      Family = 'PRODUCT',IsActive = true,Name = 'AT-SPSX',ProductCode = '990-001201-00',Warranty__c = 'NA-NA-C-1825,CSA-CCA-L-90'
      );
      insert newtestproduct ;
      System.assert(newtestproduct.Id!= null);
      
      TestHW = new Asset__c( Name = 'AT-SPSX' , Product__c = newtestproduct.id, Serial_Number__c = 'A234567890122345',
      Account__c = Acc.Id,  Start_Date__c = date.Today());
      insert TestHW;
      System.assert(TestHW.Id!= null);
      
       // insert test product - type service
      newtestservice = new Product2(ATFE_NA__c = true, ATFE_PartStatusDesc__c = 'Active-Active' ,ATFE_ProductRegion__c   = 'NA',
      ATFE_ProductType__c = 'T - SERVICE', ATFE_Status__c = 'ACTIVE', CurrencyIsoCode = 'USD', ATFE_Service_Product_Type__c='NCB-1',
      Description  = 'PS Bundle Serv 40 Hours',
      Family = 'SERVICE',IsActive = true,Name = 'AT-EFIH-40',ProductCode = '960-20201-40'
      );
      
      insert newtestservice ;
      System.assert(newtestservice.Id!= null);
}
       
static testMethod void validate_EntitlRelList_Controller() {
        PageReference pageRef = Page.Entitlements_Custom_RelatedListAcc;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', TestHW.Id);
        EntitlRelList_Controller Entitle_rel = new EntitlRelList_Controller(); 
        ApexPages.currentPage().getParameters().put('id', Acc.Id);
        EntitlRelList_Controller Entitle_rel1 = new EntitlRelList_Controller(); 
        
        
}

static testMethod void validate_createEntitlement_trigger() {
       
        //new service Asset
      UtilSODOFlags.skip_serviceContactTigger = true; 
     Asset__c TestHW1 = new Asset__c( Name = 'AT-S1PSX1' , Product__c = newtestproduct.id, Serial_Number__c = 'A234567890122245',
      Account__c = Acc.Id,  Start_Date__c = date.Today());
      insert TestHW1;
     // System.assert(TestHW1.Id!= null);
      Service_Asset__c TestSW = new Service_Asset__c(Account__c =Acc.Id ,Asset__c = TestHW.Id,Name = 'AT-EFIH-40',Service_Product__c = newtestservice.Id,Start_Date__c =  date.today());
      insert TestSW ;
      System.assert(TestSW.Id!= null);
      TestSW.Name = 'AT-EFIH-41';
      TestSW.Asset__c = TestHW1.Id;
       Test.StartTest();
      update TestSW ;
      
     
          TestSW.Asset__c = null;
          update TestSW;
         // TestSW.Name = 'AT-EFIH-41';
          //TestSW.Asset__c = TestHW.Id;
          //update TestSW ;
      Test.StopTest();
      
        
}

}