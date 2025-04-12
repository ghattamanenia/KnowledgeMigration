@isTest
public class DataTableWrapperControllerTest {
    @isTest
    static void testGetFieldDetailsWithRelationships() {
        // Setup test data
        Account testAccount = DataSetupUtility.createTestAccount('Test Account');
        System.debug('Test Account: ' + testAccount);

        Contact testContact = DataSetupUtility.createTestContact(
            testAccount,
            'John',
            'Doe',
            'john.doe@example.com',
            true
        );
        System.debug('Test Contact: ' + testContact);

        // Define inputs
        String objectName = 'Contact';
        String fieldsToQuery = 'Id, FirstName, LastName, AccountId, Account.Name';
        String filters = 'Name=\'Test\'';

       

        // Debug inputs
        System.debug('Object Name: ' + objectName);
        System.debug('Fields To Query: ' + fieldsToQuery);
        System.debug('Filters: ' + filters);

        // Execute method
          List<SObject> getrecord;
         Map<String, Map<String, String>> fieldDetails;
        try {
          	Test.startTest();
       		 getrecord = DataTableWrapperController.getRecords(objectName, fieldsToQuery, filters);
            fieldDetails = DataTableWrapperController.getFieldDetails(objectName, fieldsToQuery, filters);
            Test.stopTest();
            System.debug('Field Details: ' + fieldDetails);
        } catch (Exception e) {
            System.assert(false, 'Error occurred while getting field details: ' + e.getMessage());
            return;
        }

        // Assertions for direct fields
        System.assert(fieldDetails.containsKey('firstname'), 'Field details should contain "firstname".');
        System.assertEquals('First Name', fieldDetails.get('firstname').get('label'), 'Field label for "firstname" should match.');

        // Assertions for relationship fields
        System.assert(fieldDetails.containsKey('account.name'), 'Field details should contain "account.name".');
        Map<String, String> accountNameDetails = fieldDetails.get('account.name');

        // Dynamically retrieve the expected label
        String expectedAccountIdLabel = Schema.getGlobalDescribe().get('Contact')
            .getDescribe().fields.getMap().get('AccountId').getDescribe().getLabel();
        String expectedAccountNameLabel = Schema.getGlobalDescribe().get('Account')
            .getDescribe().fields.getMap().get('Name').getDescribe().getLabel();
        String expectedLabel = expectedAccountIdLabel + ' - ' + expectedAccountNameLabel;

        // Validate label
        System.assertEquals(expectedLabel, accountNameDetails.get('label'), 'Label should match.');

        // Validate API name and display type
        System.assertEquals('text', accountNameDetails.get('displaytype'), 'Display type should match.');
    }
}