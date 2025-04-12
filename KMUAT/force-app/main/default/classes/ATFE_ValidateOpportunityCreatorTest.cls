@isTest
public class ATFE_ValidateOpportunityCreatorTest {
     static testmethod void test_ValidateOpportunityCreator_userNotOwnerOrOnTeamWithAccessToEditOpps() {
        User testSystemAdmin = ATFE_TestMethodUtility.getTestUserWithProfileAndRole('System Administrator', 'ATI');
        insert testSystemAdmin;
        
        User testSalesUser = ATFE_TestMethodUtility.getTestUserWithProfileAndRole('Sales User', 'NA Sales');
        insert testSalesUser;
        Account testAccount = new Account();
        System.runAs(testSystemAdmin) {
        testAccount = ATFE_TestMethodUtility.getTestAccountWithRecordType('ATI Accounts');
       // Channelinsight.CI_TEST_TestUtils.createBaseInstallData();
            insert testAccount;
            //acc.OwnerId = testSalesUser.Id;
            //update acc;
        }
        
        System.runAs(testSalesUser) {
            Opportunity testOppty = ATFE_TestMethodUtility.getTestOpportunityWithRecordType('ATI Opportunity');
            testOppty.AccountId = testAccount.Id;
            
            try {
                insert testOppty;
            } catch (DMLException ex) {
                //System.assertEquals(INVALID_OPP_CREATOR_ERROR, ex.getDMLMessage(0));
            }
        } 
    }
    
    
     static testmethod void test_ValidateOpportunityCreator_userIsOwner() {
        User testSystemAdmin = ATFE_TestMethodUtility.getTestUserWithProfileAndRole('System Administrator', 'ATI');
        insert testSystemAdmin;
        
        User testSalesUser = ATFE_TestMethodUtility.getTestUserWithProfileAndRole('Sales User', 'NA Sales');
        insert testSalesUser;
        Account testAccount = new Account();
        Opportunity testOppty = new opportunity();
        system.runAs(testSystemAdmin)
        {
       // Channelinsight.CI_TEST_TestUtils.createBaseInstallData();
        testAccount = ATFE_TestMethodUtility.getTestAccountWithRecordType('ATI Accounts');
        
            insert testAccount;
            testAccount.OwnerId = testSalesUser.Id;
            update testAccount;
        }
        
        System.runAs(testSalesUser) {
        testOppty = ATFE_TestMethodUtility.getTestOpportunityWithRecordType('ATI Opportunity');
        
            testOppty.AccountId = testAccount.Id;
            
            insert testOppty;
        } 
        
        Opportunity opptyAfterInsert = [SELECT OwnerId FROM Opportunity WHERE Id = :testOppty.Id LIMIT 1];
        System.assertEquals(testSalesUser.Id, opptyAfterInsert.OwnerId);
        
    }
    
   
     static testmethod void test_ValidateOpporunityCreator_userIsOnAccountTeamWithAccessToEditOpps() {
        User testSystemAdmin = ATFE_TestMethodUtility.getTestUserWithProfileAndRole('System Administrator', 'ATI');
        insert testSystemAdmin;
        
        User testSalesUser = ATFE_TestMethodUtility.getTestUserWithProfileAndRole('Sales User', 'NA Sales');
        insert testSalesUser;
        Account testAccount = new Account();
        Opportunity testOppty = new Opportunity();
        System.runAs(testSystemAdmin) {
       // Channelinsight.CI_TEST_TestUtils.createBaseInstallData();
        testAccount = ATFE_TestMethodUtility.getTestAccountWithRecordType('ATI Accounts');
        
            insert testAccount;
            AccountTeamMember atm = new AccountTeamMember(UserId = testSalesUser.Id, AccountId = testAccount.Id);
            insert atm;
            //Have to manually insert the Account Share record.  Salesforce seems to automatically create an Account Share record 
            //when saving an AccountTeamMember in the front end, but is doesn't happen when creating an AccountTeamMember in apex.
            AccountShare accShare = new AccountShare(UserOrGroupId = testSalesUser.Id, AccountId= testAccount.Id, AccountAccessLevel = 'Read', OpportunityAccessLevel = 'Edit');
            insert accShare;
        }
        
        System.runAs(testSalesUser) {
        testOppty = ATFE_TestMethodUtility.getTestOpportunityWithRecordType('ATI Opportunity');
        testOppty.AccountId = testAccount.Id;
            
            insert testOppty;
        } 
    }

}