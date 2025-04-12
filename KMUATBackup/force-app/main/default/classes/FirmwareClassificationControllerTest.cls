@isTest
public class FirmwareClassificationControllerTest {

    @testSetup
    static void setupTestData() {
       // Create Manufacturer
        Manufacturer__c manufacturer = DataSetupUtility.createTestManufacturer('Test Manufacturer');

        // Create CatalogdataTableWrapperPreview
        Product_Series__c productSeries = DataSetupUtility.createTestProductSeriesData('Test Product Series');
        Catalog__c catalog = DataSetupUtility.createTestCatalog('Test Catalog', 'NORMAL', 'Active', manufacturer.Id,productSeries.Id);

        // Create Firmware records
        Firmware__c firmware1 = DataSetupUtility.createTestFirmware('Firmware 1', '1.0', Date.today());
        Firmware__c firmware2 = DataSetupUtility.createTestFirmware('Firmware 2', '2.0', Date.today().addDays(1));

        // Create Catalog Line Items
        DataSetupUtility.createTestCatalogLineItem(catalog.Id, firmware1.Id);
        DataSetupUtility.createTestCatalogLineItem(catalog.Id, firmware2.Id);

        // Create Software File and Allocation records
        Software_File__c softwareFile1 = new Software_File__c(Name = 'Software File 1');
        Software_File__c softwareFile2 = new Software_File__c(Name = 'Software File 2');
        insert new List<Software_File__c>{ softwareFile1, softwareFile2 };

        DataSetupUtility.createTestSoftwareFileAllocation(firmware1.Id, softwareFile1.Id);
        DataSetupUtility.createTestSoftwareFileAllocation(firmware1.Id, softwareFile2.Id);
    }

    @isTest
    static void testGetFirmwareRecords() {
        Catalog__c catalog = [SELECT Id FROM Catalog__c LIMIT 1];

        Test.startTest();
        List<Catalog_Line_Item__c> firmwareRecords = FirmwareClassificationController.getFirmwareRecords(catalog.Id);
        Test.stopTest();

        System.assertNotEquals(null, firmwareRecords);
        System.assertEquals(2, firmwareRecords.size());
    }

    @isTest
    static void testGetAssociatedSoftware() {
        Firmware__c firmware = [SELECT Id FROM Firmware__c LIMIT 1];

        Test.startTest();
        List<Software_File_Allocation__c> associatedSoftware = FirmwareClassificationController.getAssociatedSoftware(firmware.Id);
        Test.stopTest();

        System.assertNotEquals(null, associatedSoftware);
        System.assertEquals(2, associatedSoftware.size());
    }
}