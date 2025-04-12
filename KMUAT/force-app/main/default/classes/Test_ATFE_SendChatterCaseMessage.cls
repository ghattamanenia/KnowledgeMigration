@isTest
public class Test_ATFE_SendChatterCaseMessage {
    
    @isTest(SeeAllData=true)
    public static void test_sendChatterMessageOnCaseInsert () {
        //create test users
        User testSystemAdmin = ATFE_TestMethodUtility.getTestUserWithProfileAndRole('System Administrator', 'ATI');
        insert testSystemAdmin;
        
        User testSalesUser = ATFE_TestMethodUtility.getTestUserWithProfileAndRole('Sales User', 'NA Sales');
        insert testSalesUser;
        
        //create a test account
        Account testAccount = ATFE_TestMethodUtility.getTestAccountWithRecordType('ATI Accounts');
        testAccount.Region__c = 'NA';
        System.runAs(testSystemAdmin) {
        //Channelinsight.CI_TEST_TestUtils.createBaseInstallData();
            System.debug('$$$test account: ' + testAccount);
            insert testAccount;
        }
        //insert an account ownership request case
        Case testCase =  ATFE_TestMethodUtility.getTestCaseWithRecordType('ATI Case');
        testCase.ATFE_Submitted_By__c = testSalesUser.Id;
        testCase.Reason = 'Account Ownership Request';
        testCase.AccountId = testAccount.Id;
        System.runAs(testSalesUser) {
            insert testCase;
        }
        //assert that a feed post was inserted
        String testCaseNumber = [SELECT CaseNumber FROM Case WHERE Id = :testCase.Id LIMIT 1].CaseNumber;
        System.debug('$$$testCaseNumber: ' + testCaseNumber );
        Set<Id> userIdSet = new Set<id>();
        for(GroupMember gm : [Select UserOrGroupId,GroupId From GroupMember where  Group.DeveloperName = 'NA_Account_Ops']){
            userIdSet.add(gm.UserOrGroupId);
        }
        if (userIdSet.size() > 0) {
            Integer numberOfPostsAboutCase = 0;
            //must select all FeedItems for each user in the NA_Account_Ops group to verify that the expected FeedItem was inserted,
            //can't filter the query further
            for (FeedItem post : [SELECT Body, Title 
                                  FROM FeedItem WHERE ParentId IN :userIdSet]) {
                System.debug('$$$post.title: ' + post.title);                   
                if (post.Title == testCaseNumber 
                && post.Body == 'An account ownership request case has been created. Please click on the following link.') {
                    numberOfPostsAboutCase++;       
                }
            }                        
            System.assertEquals(userIdSet.size(), numberOfPostsAboutCase);
        }
        
    }
}