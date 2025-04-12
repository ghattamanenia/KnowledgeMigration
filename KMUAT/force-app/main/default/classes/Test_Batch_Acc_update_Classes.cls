@isTest
private class Test_Batch_Acc_update_Classes {
    
    static testmethod void test_Batch_update_Accounts() {
    //Channelinsight.CI_TEST_TestUtils.createBaseInstallData();
    Id AccRCTypeId = Account.SObjectType.getDescribe().getRecordTypeInfosByName().get('ATI Accounts').getRecordTypeId();
      
      Account Acc = new Account(Name='Test Account',ATFE_AccountType__c = 'End Customer',Region__c = 'NA',Sub_Region__c = 'NA',
      ATFE_SalesOrgName__c = 'Sales Ops',website = 'www.none.com.in',RecordTypeId = AccRCTypeId,ATFE_VerticalMarketInit__c = 'Other',
      BillingCity = 'San Jose',BillingCountry = 'United States', BillingPostalCode  = '95134', BillingState = 'California',
      BillingStreet = 'Orchard Pkwy', ShippingCity = 'San Jose',ShippingCountry = 'United States', ShippingPostalCode = '95134', 
      ShippingState = 'California', ShippingStreet = 'Orchard Pkwy' );
      upsert Acc ;
   
     String CRON_EXP = '0 0 0 15 3 ? 2030';
     Test.startTest();
     
    String jobId = System.schedule('ScheduleApexClassTest',
                        CRON_EXP, 
                        new Schedul_Batch_update_Account());
      Test.stopTest();
    //Batch_update_Accounts rL = new Batch_update_Accounts();
   // database.executebatch(rL,2000);
    }
}