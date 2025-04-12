@isTest
private class Test_contact_User_Trigger {
    static testMethod void validate_UpdateRelContact() {
    //Channelinsight.CI_TEST_TestUtils.createBaseInstallData();
         Id AccRCTypeId = [SELECT Id,Name FROM RecordType where DeveloperName = 'Americas_Accounts'].Id;
         Id ConRCTypeId = [SELECT Id,Name FROM RecordType where DeveloperName = 'Americas_Contacts'].Id;   
         
          // Set up the Account record.
              Account Acc = new Account(Name='Test Account',ATFE_AccountType__c = 'End Customer',Region__c = 'NA',Sub_Region__c = 'NA',
              ATFE_SalesOrgName__c = 'Sales Ops',website = 'www.none.com.in',RecordTypeId = AccRCTypeId,ATFE_VerticalMarketInit__c = 'Other',
              BillingCity = 'San Jose',BillingCountry = 'United States', BillingPostalCode  = '95134', BillingState = 'California',
              BillingStreet = 'Orchard Pkwy', ShippingCity = 'San Jose',ShippingCountry = 'United States', ShippingPostalCode = '95134', 
              ShippingState = 'California', ShippingStreet = 'Orchard Pkwy',Business__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)' );
              insert Acc ;
              
              System.assert(Acc.Id!= null);
              
              // test contact
              Contact Con = new Contact(FirstName  = 'TestFirstName', LastName  = 'TestLastName',RecordTypeId  = ConRCTypeId ,AccountId  = Acc.id, Email = 'none@none.com',Service_Portal_User_Activated__c = true,
              Phone  = '+9140 80000000' );
              insert Con;
              System.assert(Con.Id!= null);
             set<id> conts =  new set<id>();
             conts.add(con.id);
             UpdateRelContact.UpdateRelContacts(conts);
             UpdateRelContact.UpdateRelContactsInsert(conts);
              
              
             
    
    }    
}