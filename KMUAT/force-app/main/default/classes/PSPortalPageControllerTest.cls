@isTest
public class PSPortalPageControllerTest{
    @isTest
    static void FetchSoftwareFileAllocationsData() {
        // Step 1: Set up test data using DataSetupUtility

        // Create a test account
        Account testAccount = DataSetupUtility.createTestAccount('Test Account');

        // Create a test contact
        Contact testContact = DataSetupUtility.createTestContact(testAccount, 'John', 'Doe', 'john.doe@example.com', true);

        // Create a test portal user
        User testUser = DataSetupUtility.createTestPortalUser(testContact, 'testuser');

        // Create a test product series
        Product_Series__c testProductSeries = DataSetupUtility.createTestProductSeriesData('Test Product Series');

        // Create a manufacturer
        Manufacturer__c testManufacturer = DataSetupUtility.createTestManufacturer('Test Manufacturer');

        // Create a catalog
        Catalog__c testCatalog = DataSetupUtility.createTestCatalog(
            'Test Catalog',
            'NORMAL',
            'Active',
            testManufacturer.Id,
            testProductSeries.Id
        );

        // Create a firmware
        Firmware__c testFirmware = DataSetupUtility.createTestFirmware(
            'Test Firmware',
            '1.0.0',
            Date.today()
        );

        // Create a catalog line item
        Catalog_Line_Item__c testCatalogLineItem = DataSetupUtility.createTestCatalogLineItem(
            testCatalog.Id,
            testFirmware.Id
        );

        // Create a software file
        Software_File__c testSoftwareFile = DataSetupUtility.createTestSoftwareFile();

        // Create a software file allocation
        Software_File_Allocation__c testSoftwareFileAllocation = DataSetupUtility.createTestSoftwareFileAllocation(
            testFirmware.Id,
            testSoftwareFile.Id
        );

        // Create an entitlement account
        Entitle_Account__c testEntitleAccount = DataSetupUtility.createentitleAccount(testAccount);

        // Create an entitlement line item
        Entitle_Line_Item__c testEntitleLineItem = DataSetupUtility.createentitleLineItem(
            testEntitleAccount,
            testCatalog
        );

        
    }
    @isTest
    static void FetchSoftwareFileAllocationpasitive() {
        FetchSoftwareFileAllocationsData();
        Contact testCon = [select id from Contact limit 1];
        User testUser = [Select id from User where contactid=:testCon.id limit 1];
        Product_Series__c testProductSeries = [select id from Product_Series__c limit 1];
        // Step 2: Run the method under test using System.runAs
        Test.startTest();
        System.runAs(testUser) {
            List<sObject> result = PSPortalPageController.fetchSoftwareFileAllocations(testProductSeries.Id);

            // Verify results
            System.assertNotEquals(0, result.size(), 'The result list should not be empty.');
            for (sObject record : result) {
                Software_File_Allocation__c allocation = (Software_File_Allocation__c) record;
                System.assertEquals(
                    '1.0.0',
                    allocation.Firmware__r.Version__c,
                    'The firmware version should match the test data.'
                );
            }
        }
        Test.stopTest();
    }
    @isTest
    static void testFetchSoftwareFileAllocationsNoData() {
        FetchSoftwareFileAllocationsData();
        Contact testCon = [select id from Contact limit 1];
        User testUser = [Select id from User where contactid=:testCon.id limit 1];
        // Step 2: Run the method under test using System.runAs
        Test.startTest();
        System.runAs(testUser) {
            List<sObject> result = PSPortalPageController.fetchSoftwareFileAllocations(null);

            // Verify the result
            System.assertEquals(0, result.size(), 'The result list should be empty when no data is provided.');
        }
        Test.stopTest();
    }
    @isTest
    static void testFetchSoftwareFileAllocationException() {
        //FetchSoftwareFileAllocationsData();
      
        User testUser = [Select id from User where Profile.Name='System Administrator' and isActive=TRUE limit 1];
        // Step 2: Run the method under test using System.runAs
        Test.startTest();
        System.runAs(testUser) {
            try {
            List<sObject> result = PSPortalPageController.fetchSoftwareFileAllocations('sftesting');

            // Verify the result
            System.assertEquals(0, result.size(), 'The result list should be empty when no data is provided.');
            } 
            catch (Exception e) {
               system.debug('****TestExp'+e.getMessage()); 
            }
        }
        Test.stopTest();
    }
}