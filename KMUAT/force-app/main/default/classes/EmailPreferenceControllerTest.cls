@isTest
public class EmailPreferenceControllerTest {

    @isTest
    static void testSaveEmailPreference_PositiveScenario() {
        // Setup test data
        Account testAccount = DataSetupUtility.createTestAccount('Test Account');
        Contact testContact = DataSetupUtility.createTestContact(testAccount, 'Jane', 'Doe', 'jane.doe@test.com', true);
        User testUser = DataSetupUtility.createTestPortalUser(testContact, 'testportaluser');
        // Run as the test user
        System.runAs(testUser) {
            Test.startTest();
            
            // Call the method with a valid preference
            EmailPreferenceController.saveEmailPreference('Send_me_all_system_emails__c');
            
            Test.stopTest();

            // Verify the preference is updated
            Contact updatedContact = [SELECT No_emails_only_Password_Finder_emails__c, 
                                              No_Product_Update_Only_System_emails__c, 
                                              Send_me_all_system_emails__c 
                                       FROM Contact 
                                       WHERE Id = :testContact.Id];
            System.assertEquals(false, updatedContact.No_emails_only_Password_Finder_emails__c, 'No_emails_only_Password_Finder_emails__c should be false.');
            System.assertEquals(false, updatedContact.No_Product_Update_Only_System_emails__c, 'No_Product_Update_Only_System_emails__c should be false.');
            System.assertEquals(true, updatedContact.Send_me_all_system_emails__c, 'Send_me_all_system_emails__c should be true.');
        }
    }

  @isTest
static void testSaveEmailPreference_NoContactAssociated() {
    // Create a user without a contact
    Profile adminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
    User testUser = new User(
        FirstName = 'Test',
        LastName = 'NoContact',
        Email = 'nocontactuser@test.com',
        Username = 'nocontactuser' + DateTime.now().getTime() + '@test.com',
        Alias = 'nocont',
        TimeZoneSidKey = 'America/Los_Angeles',
        LocaleSidKey = 'en_US',
        EmailEncodingKey = 'UTF-8',
        LanguageLocaleKey = 'en_US',
        ProfileId = adminProfile.Id
    );
    insert testUser;

    // Run as the test user
    System.runAs(testUser) {
        Test.startTest();
        
        Boolean exceptionThrown = false;
        try {
            // Call the method to trigger the exception
            EmailPreferenceController.saveEmailPreference('Send_me_all_system_emails__c');
        } catch (AuraHandledException e) {
            exceptionThrown = true; // Exception caught
        }

        // Assert that an exception was thrown
        System.assert(exceptionThrown, 'An AuraHandledException should have been thrown for a user without a contact.');

        Test.stopTest();
    }
}



    @isTest
    static void testSaveEmailPreference_InvalidPreference() {
        // Setup test data
        Account testAccount = DataSetupUtility.createTestAccount('Test Account');
        Contact testContact = DataSetupUtility.createTestContact(testAccount, 'Jane', 'Doe', 'jane.doe@test.com', true);
        User testUser = DataSetupUtility.createTestPortalUser(testContact, 'testportaluser');

        // Run as the test user
        System.runAs(testUser) {
            Test.startTest();
            
            // Call the method with an invalid preference
            try {
                EmailPreferenceController.saveEmailPreference('InvalidPreference');
                System.assert(false, 'Exception should have been thrown for an invalid preference.');
            } catch (AuraHandledException e) {
    
            }
            
            Test.stopTest();
        }
    }

    @isTest
    static void testSaveEmailPreference_UpdateOtherPreferences() {
        // Setup test data
        Account testAccount = DataSetupUtility.createTestAccount('Test Account');
        Contact testContact = DataSetupUtility.createTestContact(testAccount, 'Jane', 'Doe', 'jane.doe@test.com', true);
        User testUser = DataSetupUtility.createTestPortalUser(testContact, 'testportaluser');

        // Run as the test user
        System.runAs(testUser) {
            Test.startTest();
            
            // Call the method with a different valid preference
            EmailPreferenceController.saveEmailPreference('No_Product_Update_Only_System_emails__c');
            
            Test.stopTest();

            // Verify the correct preference is updated
            Contact updatedContact = [SELECT No_emails_only_Password_Finder_emails__c, 
                                              No_Product_Update_Only_System_emails__c, 
                                              Send_me_all_system_emails__c 
                                       FROM Contact 
                                       WHERE Id = :testContact.Id];
            System.assertEquals(false, updatedContact.No_emails_only_Password_Finder_emails__c, 'No_emails_only_Password_Finder_emails__c should be false.');
            System.assertEquals(true, updatedContact.No_Product_Update_Only_System_emails__c, 'No_Product_Update_Only_System_emails__c should be true.');
            System.assertEquals(false, updatedContact.Send_me_all_system_emails__c, 'Send_me_all_system_emails__c should be false.');
        }
    }
    @isTest
    static void testSaveEmailPreference_Updatenoemailsonlypassword() {
        // Setup test data
        Account testAccount = DataSetupUtility.createTestAccount('Test Account');
        Contact testContact = DataSetupUtility.createTestContact(testAccount, 'Jane', 'Doe', 'jane.doe@test.com', true);
        User testUser = DataSetupUtility.createTestPortalUser(testContact, 'testportaluser');

        // Run as the test user
        System.runAs(testUser) {
            Test.startTest();
            
            // Call the method with a different valid preference
            EmailPreferenceController.saveEmailPreference('No_emails_only_Password_Finder_emails__c');
            
            Test.stopTest();

            // Verify the correct preference is updated
            Contact updatedContact = [SELECT No_emails_only_Password_Finder_emails__c, 
                                              No_Product_Update_Only_System_emails__c, 
                                              Send_me_all_system_emails__c 
                                       FROM Contact 
                                       WHERE Id = :testContact.Id];
            System.assertEquals(true, updatedContact.No_emails_only_Password_Finder_emails__c, 'No_emails_only_Password_Finder_emails__c should be false.');
            System.assertEquals(false, updatedContact.No_Product_Update_Only_System_emails__c, 'No_Product_Update_Only_System_emails__c should be true.');
            System.assertEquals(false, updatedContact.Send_me_all_system_emails__c, 'Send_me_all_system_emails__c should be false.');
        }
    }
    
    @isTest
    static void testGetEmailPreference_PositiveScenario() {
        // Setup test data
        Account testAccount = DataSetupUtility.createTestAccount('Test Account');
        Contact testContact = DataSetupUtility.createTestContact(testAccount, 'Jane', 'Doe', 'jane.doe@test.com', true);
        User testUser = DataSetupUtility.createTestPortalUser(testContact, 'testportaluser');

        // Set specific preferences on the Contact
        testContact.No_emails_only_Password_Finder_emails__c = false;
        testContact.No_Product_Update_Only_System_emails__c = true;
        testContact.Send_me_all_system_emails__c = false;
        update testContact;

        // Run as the test user
        System.runAs(testUser) {
            Test.startTest();
            
            // Call the method and assert the correct preference is returned
            String emailPreference = EmailPreferenceController.getEmailPreference();
            
            Test.stopTest();
            
            System.assertEquals('No_Product_Update_Only_System_emails__c', emailPreference, 
                'The email preference should match the Contact record.');
        }
    }

    @isTest
    static void testGetEmailPreference_NoContactAssociated() {
        // Create a user without a Contact
        Profile adminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'NoContact',
            Email = 'nocontactuser@test.com',
            Username = 'nocontactuser' + DateTime.now().getTime() + '@test.com',
            Alias = 'nocont',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ProfileId = adminProfile.Id
        );
        insert testUser;

        // Run as the test user
        System.runAs(testUser) {
            Test.startTest();
            
            Boolean exceptionThrown = false;
            String exceptionMessage = '';
            try {
                // Call the method to trigger the exception
                EmailPreferenceController.getEmailPreference();
            } catch (AuraHandledException e) {
                exceptionThrown = true;
                exceptionMessage = e.getMessage();
            }
            
            Test.stopTest();
            
            
        }
    }

    @isTest
    static void testGetEmailPreference_NoPreferencesSet() {
        // Setup test data
        Account testAccount = DataSetupUtility.createTestAccount('Test Account');
        Contact testContact = DataSetupUtility.createTestContact(testAccount, 'Jane', 'Doe', 'jane.doe@test.com', true);
        User testUser = DataSetupUtility.createTestPortalUser(testContact, 'testportaluser');

        // Ensure no preferences are set
        testContact.No_emails_only_Password_Finder_emails__c = false;
        testContact.No_Product_Update_Only_System_emails__c = false;
        testContact.Send_me_all_system_emails__c = false;
        update testContact;

        // Run as the test user
        System.runAs(testUser) {
            Test.startTest();
            
            // Call the method and expect a null response
            String emailPreference = EmailPreferenceController.getEmailPreference();
            
            Test.stopTest();
            
            System.assertEquals(null, emailPreference, 
                'If no preferences are set, the method should return null.');
        }
    }
    
}