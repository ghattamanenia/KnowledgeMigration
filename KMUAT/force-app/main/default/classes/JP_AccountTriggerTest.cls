/**
 * TestClass JP_AccountTrigger/JP_AccountHistory
 */

@IsTest
private class JP_AccountTriggerTest {
    @isTest static void testAccountHistory() {
        //Channelinsight.CI_TEST_TestUtils.createBaseInstallData();   // Added by Neha to fix Model  N change    Neha commented for model n package uninstallation
        Account acc = insertAcc();
        
        Test.startTest();
        acc = updateAcc(acc);
        Test.stopTest();
        
    }

    @isTest static void testAccountHistoryError() {
        String str255 = '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000';
        //Channelinsight.CI_TEST_TestUtils.createBaseInstallData();  // Added by Neha to fix Model  N change
        Account oldAcc = new Account(Name = '株式会社1',
                                     Website = 'https://www.google.co.jp',
                                     RecordTypeId = '012200000005vdoAAA',
                                     JP_Field01__c = 'test');
        Account newAcc = new Account(Name = '株式会社1',
                                     Website = 'https://www.google.co.jp',
                                     RecordTypeId = '012200000005vdoAAA',
                                     JP_Field01__c = str255);
        
        List<Account> newAccList = new List<Account>{newAcc};
        Map<Id,Account> oldAccMap = new Map<Id,Account>{null => oldAcc};
        
        Test.startTest();
        JP_AccountHistory AccountHistory = new JP_AccountHistory();
        AccountHistory.CreateAccHistory(newAccList, oldAccMap);
        Test.stopTest();
        
    }

    static Account insertAcc(){
        Account acc = new Account(Name = '株式会社',
                                  Website = 'https://www.google.co.jp',
                                  RecordTypeId = '012200000005vdoAAA');
        insert acc;
        return acc;
    }

    static Account updateAcc(Account acc){
        acc.JP_Field01__c= '1';
        update acc;
        return acc;
    }

    // Apexをを先にリリースするため
    @isTest static void executeApex() {
   // Channelinsight.CI_TEST_TestUtils.createBaseInstallData();   // Added by Neha to fix Model  N change
        Account oldAcc = new Account(Name = '株式会社1',
                                     Website = 'https://www.google.co.jp',
                                     RecordTypeId = '012200000005vdoAAA',
                                     JP_Field01__c = 'test1');
        Account newAcc = new Account(Name = '株式会社1',
                                     Website = 'https://www.google.co.jp',
                                     RecordTypeId = '012200000005vdoAAA',
                                     JP_Field01__c = 'test2');
        
        List<Account> newAccList = new List<Account>{newAcc};
        Map<Id,Account> oldAccMap = new Map<Id,Account>{null => oldAcc};
        
        Test.startTest();
        JP_AccountHistory AccountHistory = new JP_AccountHistory();
        AccountHistory.CreateAccHistory(newAccList, oldAccMap);
        JP_Flag Flag = new JP_Flag();
        Test.stopTest();
        
    }

}