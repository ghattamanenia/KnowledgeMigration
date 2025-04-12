@isTest
public class UserManualControllerTest {
    @isTest
    static void testGetUserManualTree() {
        // Step 1: Create a test account and associated contact
       

        // Step 2: Create Knowledge Base test data using utility
        Knowledge_Base__c parent = DataSetupUtility.createKnowledgeBaseRecord(
            'Parent Manual', 
            'Parent Content', 
            1, 
            'Active', 
            'User Manual', 
            null
        );

        Knowledge_Base__c child = DataSetupUtility.createKnowledgeBaseRecord(
            'Child Manual', 
            'Child Content', 
            1.1, 
            'Active', 
            'User Manual', 
            parent.Id
        );

        DataSetupUtility.createKnowledgeBaseRecord(
            'Inactive Manual', 
            'Inactive Content', 
            2, 
            'Inactive', 
            'User Manual', 
            null
        );

        // Step 3: Call the method under test
        Test.startTest();
        List<Knowledge_Base__c> result = UserManualController.getUserManualTree();
        Test.stopTest();

        // Step 4: Assertions

        System.assertEquals(2, result.size(), 'Only active user manual records should be returned');

        // Validate parent record
        System.assertEquals('Parent Manual', result[0].Title__c, 'First record should be the parent manual');
        System.assertEquals(1, result[0].Order__c, 'Parent record order should match');

        // Validate child record
        System.assertEquals('Child Manual', result[1].Title__c, 'Second record should be the child manual');
        System.assertEquals(1.1, result[1].Order__c, 'Child record order should match');
    }
}