public without sharing class ATFE_UpdateQuotePriceBookOnQuoteToChange {
public ATFE_UpdateQuotePriceBookOnQuoteToChange()
{
    system.debug('@@@Dummy');
}
/*

    public ATFE_UpdateQuotePriceBookOnQuoteToChange(Quote[] pTriggerOld, Quote[] pTriggerNew) {
        
        //loop through the updated quotes and check if their Quote To field has changed
        Quote [] quotesToUpdatePB = new Quote[]{};
        Set<Id> accountIds = new Set<Id>();
        for (Integer i=0; i<pTriggerOld.size(); i++) {
            Quote quoteBeforeUpdate = pTriggerOld[i];
            Quote quoteAfterUpdate = pTriggerNew[i];
            
            if (quoteBeforeUpdate.ATFE_Partner_Name__c != quoteAfterUpdate.ATFE_Partner_Name__c && quoteAfterUpdate.ATFE_Partner_Name__c != null) {
                quotesToUpdatePB.add(quoteAfterUpdate);
                accountIds.add(quoteAfterUpdate.ATFE_Partner_Name__c);
            }
        }
        
        if (quotesToUpdatePB.size() > 0) {
            queryForRelatedAccountsAndSetNewQuotePB(accountIds, quotesToUpdatePB);
        }
    }

    private void queryForRelatedAccountsAndSetNewQuotePB(Set<Id> pAccountIds, Quote [] pQuotesToUpdatePB) {
        Map<Id, Account> relatedAccounts = new Map<Id, Account>([SELECT ATFE_Price_Book__c FROM Account WHERE Id IN :pAccountIds]);
        
        Set<String> priceBookNames = new Set<String>();
        Map<String, Id> priceBookNameToId = New Map<String, Id>(); 
        
        for (Account acct : relatedAccounts.values()) {
            if (acct.ATFE_Price_Book__c != null) {
                priceBookNames.add(acct.ATFE_Price_Book__c);
            }
        }
        
        for(Pricebook2 pricebook : [SELECT Name FROM Pricebook2 WHERE Name IN :priceBookNames]) {
            priceBookNameToId.put(pricebook.Name, pricebook.Id);
        }
          
        for (Quote updatedQuote : pQuotesToUpdatePB) {
            String relatedAccountPBName = relatedAccounts.get(updatedQuote.ATFE_Partner_Name__c).ATFE_Price_Book__c;
            Id newPriceBookId = priceBookNameToId.get(relatedAccountPBName);
            updatedQuote.Pricebook2Id = newPriceBookId;
        }  
    }
    
    /**** Test Methods ****/
    /*
    @isTest(seeAllData=true)
    public static void test_ATFE_UpdateQuotePriceBookOnQuoteToChange() {
        //create test users
      //  User testSystemAdmin = ATFE_TestMethodUtility.getTestUserWithProfileAndRole('System Administrator', 'ATI');
       // insert testSystemAdmin;
       // User testSalesUser = ATFE_TestMethodUtility.getTestUserWithProfileAndRole('Sales User', 'NA Sales');
      Profile p1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
      UserRole r1 = [SELECT Id FROM UserRole WHERE Name = 'ATI'];
 
       
      Profile p = [SELECT Id FROM Profile WHERE Name = 'Sales User'];
      UserRole r = [SELECT Id FROM UserRole WHERE Name = 'NA Sales'];
      User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
      system.runAs(thisUser)
      {
      User u = new User(LastName = 'last',Email = 'puserff000@amamama.com',ProfileId=p1.Id,
     Username = 'puser000fff@amamama.com' + System.currentTimeMillis(),
     CompanyName = 'TEST',Isactive=true,
     Title = 'title',
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     EmailEncodingKey = 'UTF-8',
     LanguageLocaleKey = 'en_US',
     LocaleSidKey = 'en_US',
     UserRoleId = r1.Id);
     insert u;
      User  testSystemAdmin = [Select id,name from user where isActive = true and profileid = :p1.id  and  UserRoleId = :r1.Id and 
                TimeZoneSidKey = 'America/Los_Angeles' LIMIT 1];
       User testSalesUser = [Select id,name from user where isActive = true and profileid = :p.id  and  UserRoleId = :r.Id and 
                TimeZoneSidKey = 'America/Los_Angeles' LIMIT 1];
      //  insert testSalesUser;
        
        Account testAccount1 = ATFE_TestMethodUtility.getTestAccountWithRecordType('ATI Accounts');
        testAccount1.BillingCountry = 'United States';
        Account testAccount2 = ATFE_TestMethodUtility.getTestAccountWithRecordType('ATI Accounts');
        testAccount2.ATFE_AccountType__c = 'Partner';
        testAccount2.ATFE_Partner_Type__c = 'Direct';       
        System.runAs(testSystemAdmin) {
            //insert test accounts
            insert testAccount1;
//ikeda 20160707            
            insert testAccount2;
            //update the owner of one test account to be the sales user
            testAccount1.OwnerId = testSalesUser.Id;
            update testAccount1;
        }
        
        //need to select these accounts after inserting so their price book fields are not null because they are formulas
        testAccount1 = [SELECT ATFE_Price_Book__c FROM Account WHERE Id = :testAccount1.Id]; 
//ikeda 20160707        
testAccount2 = [SELECT ATFE_Price_Book__c FROM Account WHERE Id = :testAccount2.Id];
        
        Opportunity testOppty = ATFE_TestMethodUtility.getTestOpportunityWithRecordType('ATI Opportunity');
        Quote testQuote = ATFE_TestMethodUtility.getQuoteWithRecordType('ATFE_Quote Before Approval');
        Test.StartTest();
        System.runAs(testSalesUser) {
            //insert a test oppty
            testOppty.AccountId = testAccount1.Id;
            insert testOppty;
            
            //insert a test quote
            testQuote.OpportunityId = testOppty.Id;
            testQuote.ATFE_Partner_Name__c = testAccount1.Id; 
            insert testQuote;
            ATFE_QuoteEmailHelper.byPassCode=false;
            update testQuote;
            List<Quote> qas = new List<Quote>();
            List<Quote> qas1 = new List<Quote>();
            qas.add(testQuote);
            testQuote.ATFE_Partner_Name__c =testAccount2.Id;
            qas1.add(testQuote);
            
            ATFE_UpdateQuotePriceBookOnQuoteToChange aup = new ATFE_UpdateQuotePriceBookOnQuoteToChange(qas1,qas);
           
            
            //update the quote's Quote To Name
//ikeda 20160707            
testQuote.ATFE_Partner_Name__c = testAccount2.Id;
//ikeda 20160707            
update testQuote;
            
            //get the quote's current state from the database
            testQuote = [SELECT Pricebook2Id, Pricebook2.Name FROM Quote WHERE Id = :testQuote.Id];
        }
         Test.StopTest();
        //Assert that the quote's price book matches the price book of the new account in Quote To Name 
       // System.assertEquals(testAccount2.ATFE_Price_Book__c, testQuote.Pricebook2.Name);
    }
    }
    */
    
}