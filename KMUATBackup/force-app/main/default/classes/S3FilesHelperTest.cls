@isTest
public class S3FilesHelperTest {
    
    @isTest
    static void testGetConfig() {
        // Arrange
        Account testAccount = DataSetupUtility.createTestAccount('Test Account');
        Contact testContact = DataSetupUtility.createTestContact(testAccount, 'John', 'Doe', 'john.doe@example.com', true);
        Manufacturer__c manufacturer = DataSetupUtility.createTestManufacturer('Test Manufacturer');
        Product_Series__c productSeries = DataSetupUtility.createTestProductSeriesData('Test Product Series');
        Catalog__c testCatalog = DataSetupUtility.createTestCatalog('Test Catalog', 'NORMAL', 'Active', manufacturer.Id,productSeries.Id);
        Entitle_Account__c testEntitleAcc = DataSetupUtility.createentitleAccount(testAccount);
        Entitle_Line_Item__c testEntitleLineItem = DataSetupUtility.createentitleLineItem(testEntitleAcc,testCatalog);
        Firmware__c firmware = DataSetupUtility.createTestFirmware('Test Firmware', '1.0', Date.today());
        Catalog_Line_Item__c testCataloglineitem = DataSetupUtility.createTestCatalogLineItem(testCatalog.id, firmware.id);
        Software_File__c softwareFile = DataSetupUtility.createTestSoftwareFile();
		Software_File_Allocation__c allocation = DataSetupUtility.createTestSoftwareFileAllocation(firmware.Id, softwareFile.Id);

        // Act
        S3FilesHelper.Config config;
        Test.startTest();
        config = S3FilesHelper.getConfig(testCatalog.Id);
        Test.stopTest();

        // Assert
        System.assertNotEquals(null, config, 'Config should not be null');
        System.assertNotEquals(null, config.bucket, 'Bucket should be configured');
    }

    @isTest
    static void testCreateSoftwareRecord() {
        // Arrange
        String fileName = 'TestFile.txt';
        String fileKey = 'files/TestFile.txt';
        String fileUrl = 'https://s3.amazonaws.com/bucket/files/TestFile.txt';
        Long fileSize = 12345;
        String etag = 'abc123etag';
        Date createdDate = Date.today();

        // Act
        Id softwareFileId;
        Test.startTest();
        softwareFileId = S3FilesHelper.createSoftwareRecord(fileName, fileKey, fileUrl, fileSize, etag, createdDate, null);
        Test.stopTest();

        // Assert
        Software_File__c softwareFile = [SELECT Id, Name, File_Key__c FROM Software_File__c WHERE Id = :softwareFileId];
        System.assertNotEquals(null, softwareFile, 'Software_File__c record should be created');
        System.assertEquals(fileName, softwareFile.Name, 'File name should match');
    }

@isTest
static void testGetSoftwareFile_ValidRecord() {
    testGetConfig();
    
    // Step 1: Create a portal user linked to the contact
    Contact con = [SELECT Id,Accountid, Name FROM Contact limit 1];
    User portaluser = DataSetupUtility.createTestPortalUser(con, 'portaluser1');
    System.runAs(portaluser) {
        Software_File__c softwareFile = [SELECT Id, Name, File_Key__c FROM Software_File__c limit 1];
        S3FilesHelper.getSoftwareFile(softwareFile.Id);
    }
}


    @isTest
    static void testGetSoftwareFile_InvalidRecord() {
		testGetConfig();
    
        // Step 1: Create a portal user linked to the contact
        Contact con = [SELECT Id,Accountid, Name FROM Contact limit 1];
        User portaluser = DataSetupUtility.createTestPortalUser(con, 'portaluser1');
        System.runAs(portaluser) {
            Software_File_Allocation__c softwareFileAllocation = [SELECT Id, Name FROM Software_File_Allocation__c limit 1];
            try{
               S3FilesHelper.getSoftwareFile(softwareFileAllocation.Id); 
            }
            catch (Exception ex) {
                // Capture the exception message for validation
                System.debug('Caught exception: ' + ex.getMessage());
                
            }
            
        }
       

    }

    @isTest
static void testGetConfig_MissingMetadata() {
    // Start test
    Test.startTest();
    Boolean exceptionThrown = false;
    try {
        // Pass null as the catalog ID
        S3FilesHelper.getConfig(null);
    } catch (NullPointerException e) {
        exceptionThrown = true;
        System.debug('Expected NullPointerException thrown: ' + e.getMessage());
    }
    Test.stopTest();

    // Assert
    System.assert(exceptionThrown, 'System.NullPointerException should be thrown when catalogId is null');
}
    
@isTest
static void testCreateSoftwareRecord_WithUpdate() {
    // Arrange: Create an initial Software_File__c record
    Software_File__c existingSoftwareFile = new Software_File__c(
        Name = 'Existing File',
        File_Key__c = 'files/ExistingFile.txt',
        Uploaded_File_URL__c = 'https://s3.amazonaws.com/bucket/files/ExistingFile.txt',
        File_Size_bytes__c = 1000
    );
    insert existingSoftwareFile;

    // Updated details
    String fileName = 'UpdatedFile.txt';
    String fileKey = 'files/UpdatedFile.txt';
    String fileUrl = 'https://s3.amazonaws.com/bucket/files/UpdatedFile.txt';
    Long fileSize = 2000;
    String etag = 'updated123etag';
    Date createdDate = Date.today();

    // Act: Call the method with the existing record ID
    Test.startTest();
    Id softwareFileId = S3FilesHelper.createSoftwareRecord(fileName, fileKey, fileUrl, fileSize, etag, createdDate, existingSoftwareFile.Id);
    Test.stopTest();

    // Assert: Verify the record was updated
    Software_File__c updatedSoftwareFile = [SELECT Id, Name, File_Key__c, Uploaded_File_URL__c, File_Status__c FROM Software_File__c WHERE Id = :softwareFileId];
    System.assertEquals(existingSoftwareFile.Id, updatedSoftwareFile.Id, 'The existing record ID should remain unchanged');
    System.assertEquals(fileName, updatedSoftwareFile.Name, 'The file name should be updated');
    System.assertEquals(fileKey, updatedSoftwareFile.File_Key__c, 'The file key should be updated');
    System.assertEquals(fileUrl, updatedSoftwareFile.Uploaded_File_URL__c, 'The file URL should be updated');
    System.assertEquals('Loaded', updatedSoftwareFile.File_Status__c, 'The file status should be updated to "Loaded"');
}

}