@isTest
public class CreateEntitlementControllerTest {
	
    @testSetup
    static void setupData(){
        Account testAccount = new Account();
        testAccount.Name = 'Test Account';
        insert testAccount;
        
        Manufacturer__c testManufacturer = new Manufacturer__c();
        testManufacturer.Name = 'Test Manufacturer';
        testManufacturer.Manufacturer_ID__c = 'Test Manufacturer';
        insert testManufacturer;
        
        Catalog__c testCatalog = new Catalog__c();
        testCatalog.Name = 'Test Catalog';
        testCatalog.Catalog_Name__c = 'Test Catalog';
        testCatalog.Catalog_Type__c = 'NORMAL';
        testCatalog.Default_Duration_Year__c = '2';
        testCatalog.Default_Duration_Month__c = '2';
        testCatalog.Duration__c = '2';
        testCatalog.Catalog_Manufacturer__c = testManufacturer.Id;
        insert testCatalog;
    }
    
    @isTest
    static void testUploadFile(){
        Account parentAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        String testFileData = 'Test Document';
        
        Test.startTest();
        Id contentDocumentId = CreateEntitlementController.uploadFile(EncodingUtil.base64Encode(Blob.valueOf(testFileData)), 'Test Document.txt', parentAccount.Id);
        Assert.areNotEqual(contentDocumentId, null, 'Content Document Id should be generated');
        Test.stopTest();
    }
    
    @isTest
    static void testCreateEntitlement(){
        Account parentAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        Catalog__c parentCatalog = [SELECT Id FROM Catalog__c WHERE Name = 'Test Catalog' LIMIT 1];
        
        String entitlementJson = '{"Order_Id__c":"12345","Account__c":"'+ parentAccount.Id +'"}';
        String lineItemJson = '[{"Effective_Date__c":"2020-01-01","Expiration_Date__c":"2025-01-01","Catalog_Item__c":"'+ parentCatalog.Id +'"}]';
        
        Test.startTest();
        CreateEntitlementController.createEntitlement(entitlementJson, lineItemJson);
        List<Entitle_Account__c> createdEntitlements = [SELECT Id FROM Entitle_Account__c LIMIT 1];
        Assert.areEqual(createdEntitlements.isEmpty(), false, 'Entitlement should be created');
        Test.stopTest();
    }
    
    @isTest
    static void testCreateEntitlementWithException(){
        String entitlementJson = '{}';
        String lineItemJson = '[{}]';
        
        Test.startTest();
        try{
            CreateEntitlementController.createEntitlement(entitlementJson, lineItemJson);
        } catch(Exception ex){
            Assert.areEqual(ex.getMessage(), 'Script-thrown exception', 'An exception should occur');
        }
        Test.stopTest();
    }
}