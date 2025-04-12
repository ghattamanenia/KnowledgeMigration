@IsTest
private class FAQControllerTest {
    
    @TestSetup
    static void setup() {
        // Create test data
        List<Knowledge_Base__c> faqs = new List<Knowledge_Base__c>{
            new Knowledge_Base__c(Title__c = 'What is Salesforce?', Content__c = 'A CRM platform.', Category__c = 'About the Download Service', Status__c = 'Active', Type__c='FAQ'),
            new Knowledge_Base__c(Title__c = 'How to use LWC?', Content__c = 'Learn the framework.', Category__c = 'About Your Order', Status__c = 'Active', Type__c='FAQ'),
            new Knowledge_Base__c(Title__c = 'Is Salesforce secure?', Content__c = 'Yes, highly secure.', Category__c = 'About the Download Service', Status__c = 'Active',Type__c='FAQ'),
            new Knowledge_Base__c(Title__c = 'Can I automate tasks?', Content__c = 'Yes, using flows.', Category__c = 'About Passwords', Status__c = 'Inactive',Type__c='FAQ')
        };
        insert faqs;
    }
    
    @IsTest
    static void testGetFAQsByCategory() {
        // Test valid input
        Test.startTest();
        List<Knowledge_Base__c> generalFAQs = FAQController.getFAQsByCategory('About the Download Service', 0, 2);
        // Assert the size of the result
        System.assertEquals(2, generalFAQs.size());
        // Test invalid category
        List<Knowledge_Base__c> noFAQs = FAQController.getFAQsByCategory('Nonexistent', 0, 2);
        System.assertEquals(0, noFAQs.size());

        // Test default offset and fetch limit
        List<Knowledge_Base__c> allFAQs = FAQController.getFAQsByCategory('About the Download Service', null, null);
        Test.stopTest();
        System.assertEquals(2, allFAQs.size());
    }

    @IsTest
    static void testGetCategories() {
        setup();
        Test.startTest();
        List<String> categories = FAQController.getCategories();
        system.debug('*****'+categories);
        Test.stopTest();
        // Assert the categories
        System.assertEquals(2, categories.size());
       
    }

    @IsTest
    static void testExceptionHandling() {
        setup();
        // Test blank category
        try {
            Test.startTest();
            FAQController.getFAQsByCategory(null, null, null);
            Test.stopTest();
            System.assert(false, 'Expected an AuraHandledException to be thrown.');
        } catch (AuraHandledException e) {
            
        }
    }
    
    @IsTest
    static void TestFAQsByCategoryException() {
        // Step 1: Set up test data using DataSetupUtility
        Account testAccount = DataSetupUtility.createTestAccount('Test Account');
        Contact testContact = DataSetupUtility.createTestContact(
            testAccount,
            'John',
            'Doe',
            'john.doe@example.com',
            true // Download preference is true for this contact
        );

        User portalUser = DataSetupUtility.createTestPortalUser(testContact, 'portaluser');
        
        // Test getDownloadPreference
        System.runAs(portalUser) {
            // Test blank category
            try {
                Test.startTest();
                FAQController.getFAQsByCategory('test', 50000000, null);
                Test.stopTest();
             
            } catch (AuraHandledException e) {
                
            }
    	}
    }
   
}