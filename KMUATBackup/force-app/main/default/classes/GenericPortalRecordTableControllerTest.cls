@isTest
public class GenericPortalRecordTableControllerTest {

    @isTest
    static void testGetRecordDataForProductSeries() {
        // Setup test data using DataSetupUtility
        Account testAccount = DataSetupUtility.createTestAccount('Test Account');
        Entitle_Account__c entitleAccount = DataSetupUtility.createentitleAccount(testAccount);

        Manufacturer__c manufacturer = DataSetupUtility.createTestManufacturer('Test Manufacturer');
        Product_Series__c productSeries = DataSetupUtility.createTestProductSeriesData('Test Product Series');
        Catalog__c catalog = DataSetupUtility.createTestCatalog('Test Catalog', 'NORMAL', 'Active', manufacturer.Id,productSeries.Id);
        Entitle_Line_Item__c entitleLineItem = DataSetupUtility.createentitleLineItem(entitleAccount, catalog);

        User portalUser = DataSetupUtility.createTestPortalUser(
            DataSetupUtility.createTestContact(testAccount, 'John', 'Doe', 'john.doe@example.com', true),
            'testportaluser'
        );

        // Test execution
        System.runAs(portalUser) {
            List<sObject> results = GenericPortalRecordTableController.getRecordData('Product_Series__c', 'Name');

            System.assertEquals(1, results.size(), 'Expected one Product_Series__c record.');
            Product_Series__c result = (Product_Series__c) results[0];
            System.assertEquals('Test Product Series', result.Name, 'Product Series name mismatch.');
        }
    }

    @isTest
    static void testGetRecordDataForFirmware() {
        // Setup test data using DataSetupUtility
        Account testAccount = DataSetupUtility.createTestAccount('Test Account');
        Entitle_Account__c entitleAccount = DataSetupUtility.createentitleAccount(testAccount);
        // Create Manufacturer
        Manufacturer__c manufacturer = DataSetupUtility.createTestManufacturer('Test Manufacturer');

        // Create CatalogdataTableWrapperPreview
        Product_Series__c productSeries = DataSetupUtility.createTestProductSeriesData('Test Product Series');
        Catalog__c catalog = DataSetupUtility.createTestCatalog('Test Catalog', 'NORMAL', 'Active', manufacturer.Id,productSeries.Id);
        Entitle_Line_Item__c entitleLineItem = DataSetupUtility.createentitleLineItem(entitleAccount, catalog);

        Firmware__c firmware = DataSetupUtility.createTestFirmware('Test Firmware', '1.0', Date.today());
        DataSetupUtility.createTestCatalogLineItem(catalog.Id, firmware.Id);

        User portalUser = DataSetupUtility.createTestPortalUser(
            DataSetupUtility.createTestContact(testAccount, 'John', 'Doe', 'john.doe@example.com', true),
            'testportaluser'
        );

        // Test execution
        System.runAs(portalUser) {
            List<sObject> results = GenericPortalRecordTableController.getRecordData('Firmware__c', 'Name,Version__c');

            System.assertEquals(1, results.size(), 'Expected one Firmware__c record.');
            Firmware__c result = (Firmware__c) results[0];
            System.assertEquals('Test Firmware', result.Name, 'Firmware name mismatch.');
            System.assertEquals('1.0', result.Version__c, 'Firmware version mismatch.');
        }
    }

    @isTest
    static void testGetRecordDataNoRecords() {
        User portalUser = DataSetupUtility.createTestPortalUser(
            DataSetupUtility.createTestContact(
                DataSetupUtility.createTestAccount('Test Account'),
                'John', 'Doe', 'john.doe@example.com', true
            ),
            'testportaluser'
        );

        // Test execution
        System.runAs(portalUser) {
            List<sObject> results = GenericPortalRecordTableController.getRecordData('Product_Series__c', 'Name');

            System.assertEquals(0, results.size(), 'Expected no records for Product_Series__c.');
        }
    }
}