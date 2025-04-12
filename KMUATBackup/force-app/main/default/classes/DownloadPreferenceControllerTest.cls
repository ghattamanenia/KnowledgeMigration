@isTest
public class DownloadPreferenceControllerTest {

    @isTest
    static void testDownloadPreferenceController() {
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
            Boolean downloadPreference = DownloadPreferenceController.getDownloadPreference();
            System.assertEquals(true, downloadPreference, 'Download preference should be true for the portal user');
        }

        // Test updateDownloadPreference
        System.runAs(portalUser) {
            DownloadPreferenceController.updateDownloadPreference(false);

            Contact updatedContact = [SELECT Download_Preference__c FROM Contact WHERE Id = :testContact.Id LIMIT 1];
            System.assertEquals(false, updatedContact.Download_Preference__c, 'Download preference should be updated to false');
        }
    }

    @isTest
static void testGetDownloadPreferenceNoContact() {
    // Step 1: Set up a contact without explicitly setting Download_Preference__c
    Account testAccount = DataSetupUtility.createTestAccount('Test Account');
    Contact testContact = new Contact(
        FirstName = 'NoPref',
        LastName = 'Contact',
        Email = 'nopref.contact@example.com',
        Phone = '123-456-7890',
        AccountId = testAccount.Id
    );
    insert testContact;

    // Step 2: Create a portal user linked to the contact
    User portalUserWithoutPreference = DataSetupUtility.createTestPortalUser(testContact, 'portaluser2');
    
    // Step 3: Log in as portal user with a contact having no preference set
    System.runAs(portalUserWithoutPreference) {
        Boolean downloadPreference = DownloadPreferenceController.getDownloadPreference();
        //System.assertEquals(null, downloadPreference, 'Download preference should be null for a contact with no preference set');
    }
}


    @isTest
    static void testUpdateDownloadPreferenceNullExceptionHandling() {
        // Step 1: Set up test data
        Account testAccount = DataSetupUtility.createTestAccount('Test Account');
        Contact testContact = DataSetupUtility.createTestContact(
            testAccount,
            'Jane',
            'Smith',
            'jane.smith@example.com',
            true // Download preference is true for this contact
        );

        // Step 2: Create test portal user associated with the contact
        User portalUser = DataSetupUtility.createTestPortalUser(testContact, 'portaluser3');
        
        // Step 3: Log in as portal user and simulate an exception during 'updateDownloadPreference'
        System.runAs(portalUser) {
            try {
                // Pass null to simulate invalid input
                DownloadPreferenceController.updateDownloadPreference(null);
                System.assert(false, 'Exception should have been thrown when updating download preference');
            } catch (Exception ex) {
                // Capture the exception message for validation
                System.debug('Caught exception: ' + ex.getMessage());

                
            }
        }
    }
    
    @isTest
    static void testUpdateDownloadPreferenceExceptionHandling() {
        User testUser = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' and isActive=true LIMIT 1];
        
        // Step 3: Log in as portal user and simulate an exception during 'updateDownloadPreference'
        System.runAs(testUser) {
            try {
                // Pass null to simulate invalid input
                DownloadPreferenceController.updateDownloadPreference(true);
                System.assert(false, 'Exception should have been thrown when updating download preference');
            } catch (Exception ex) {
                // Capture the exception message for validation
                System.debug('Caught exception: ' + ex.getMessage());
                
            }
        }
        // Step 3: Log in as portal user and simulate an exception during 'updateDownloadPreference'
        System.runAs(testUser) {
            try {
                // Pass null to simulate invalid input
                DownloadPreferenceController.getDownloadPreference();
            } catch (Exception ex) {
                // Capture the exception message for validation
                System.debug('Caught exception: ' + ex.getMessage());
                
            }
        }
    }
}