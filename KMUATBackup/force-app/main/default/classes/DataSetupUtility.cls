@isTest
public class DataSetupUtility {
    /**
     * Create a test account.
     */
    public static Account createTestAccount(String name) {
        Account testAccount = new Account(
            Name = name,
            Industry = 'Technology',
            Business__c='Arabian Standard Time (Asia/Kuwait)'
        );
        insert testAccount;
        return testAccount;
    }

    /**
     * Create a test contact associated with an account.
     */
    public static Contact createTestContact(Account account, String firstName, String lastName, String email, Boolean downloadPreference) {
        Contact testContact = new Contact(
            FirstName = firstName,
            LastName = lastName,
            Email = email,
            Phone = '123-456-7890',
            Download_Preference__c = downloadPreference,
            AccountId = account.Id
        );
        insert testContact;
        return testContact;
    }

    /**
     * Create a test portal user associated with a contact and assign a permission set.
     */
    public static User createTestPortalUser(Contact contact, String usernamePrefix) {
        Profile portalProfile = [SELECT Id FROM Profile WHERE Name = 'Portal Customer Community Login' LIMIT 1];
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'PortalUser',
            Email = usernamePrefix + '@example.com',
            Username = usernamePrefix + DateTime.now().getTime() + '@example.com',
            Alias = 'tpuser',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ProfileId = portalProfile.Id,
            ContactId = contact.Id
        );
        insert testUser;
        
        
        // Assign the permission set in a separate transaction using System.runAs
        assignPermissionSetToUser(testUser.Id);
    
        return testUser;
    }

    /**
     * Assign a permission set to a user.
     */
    @TestVisible
    private static void assignPermissionSetToUser(Id userId) {
        User testRunAsUser = [SELECT Id FROM User WHERE profile.Name='System Administrator' and IsActive = true LIMIT 1];
        System.runAs(testRunAsUser) {
            PermissionSet permissionSet = [SELECT Id FROM PermissionSet WHERE Name = 'License_Management_External' LIMIT 1];
            if (permissionSet != null) {
                PermissionSetAssignment psa = new PermissionSetAssignment(
                    AssigneeId = userId,
                    PermissionSetId = permissionSet.Id
                );
                insert psa;
            }
        }
    }



    /**
     * Create a Knowledge_Base__c record.
     */
    public static Knowledge_Base__c createKnowledgeBaseRecord(
        String title, 
        String content, 
        Decimal order, 
        String status, 
        String type, 
        Id parentId
    ) {
        Knowledge_Base__c knowledgeBase = new Knowledge_Base__c(
            Title__c = title,
            Content__c = content,
            Order__c = order,
            Status__c = status,
            Type__c = type,
            Parent_Knowledge_Base__c = parentId
        );
        insert knowledgeBase;
        return knowledgeBase;
    }

    /**
     * Create multiple Knowledge_Base__c records.
     */
    public static List<Knowledge_Base__c> createKnowledgeBaseRecords(List<Knowledge_Base__c> knowledgeBaseList) {
        insert knowledgeBaseList;
        return knowledgeBaseList;
    }
  //FirmwareClassification Data setup
  
    //Manufacturer__C
      public static Manufacturer__c createTestManufacturer(String name) {
            Manufacturer__c manufacturer = new Manufacturer__c(
                Name = name
            );
            insert manufacturer;
            return manufacturer;
        }
    
    // Product Series Data Setup
    
    public static Product_Series__c createTestProductSeriesData(String name) {
            Product_Series__c productSeries = new Product_Series__c (
                Name = name
            );
            insert productSeries ;
            return productSeries;
        }
    //Catalog__C
    public static Catalog__c createTestCatalog(String name, String catalogType, String catalogStatus, Id manufacturerId, Id productSeriesId) {
        Catalog__c catalog = new Catalog__c(
            Name = name,
            Catalog_Type__c = catalogType,
            Catalog_Status__c = catalogStatus,
            Catalog_Manufacturer__c = manufacturerId,
            Product_Series__c = productSeriesId
            
        );
        insert catalog;
        return catalog;
    }
    //Firmware
    
    public static Firmware__c createTestFirmware(String name, String version, Date effectiveDate) {
        Firmware__c firmware = new Firmware__c(
            Name = name,
            Version__c = version,
            Effective_Date__c = effectiveDate,
            Expiration_Date__c = effectiveDate.addYears(1)
        );
        insert firmware;
        return firmware;
    }
    //Catalog Line Item
    public static Catalog_Line_Item__c createTestCatalogLineItem(Id catalogId, Id firmwareId) {
        Catalog_Line_Item__c catalogLineItem = new Catalog_Line_Item__c(
            Catalog_Item__c = catalogId,
            Firmware__c = firmwareId
        );
        insert catalogLineItem;
        return catalogLineItem;
    }
    
    // SoftwareFile Creation
     public static Software_File__c createTestSoftwareFile() {
        Software_File__c softwareFile = new Software_File__c(
            Name = 'Testing Software File Insert',
            File_Key__c = 'software/TestingSoftwareFile.txt'
        );
        insert softwareFile;
        return softwareFile;
    }
    
    // Software file Allocation
    public static Software_File_Allocation__c createTestSoftwareFileAllocation(Id firmwareId, Id softwareFileId) {
        Software_File_Allocation__c allocation = new Software_File_Allocation__c(
            Firmware__c = firmwareId,
            Software__c = softwareFileId
        );
        insert allocation;
        return allocation;
    }
    
    //Sample Entitle Account Data
    
    public static Entitle_Account__c createentitleAccount(Account account) {
        Entitle_Account__c entitleAccount = new Entitle_Account__c(
            Account__c = account.Id, // Reference to the related Account
            Order_Date__c = Date.today(), // Example past date
            Order_Id__c = 'ORD123456',
            Entitlement_Note__c = 'Sample entitlement note',
            Invoice_Date__c = Date.today().addDays(-5), // Example invoice date
            Invoice_ID__c = 'INV987654'
        );
        insert entitleAccount;
        return entitleAccount;
    }
    
    //Sample Entitle Account Data
    
    public static Entitle_Line_Item__c createentitleLineItem(Entitle_Account__c EntitleAccount,Catalog__c catalog) {
        Entitle_Line_Item__c entitleLineItem = new Entitle_Line_Item__c(
            effective_Date__c = Date.today().addDays(-5),
            Entitle_Account__c = EntitleAccount.id, // Replace with a valid Entitle_Account__c record Id
            Expiration_Date__c = Date.today().addYears(1),
            Extended_Price__c = 999.99,
            Catalog_Item__c  = catalog.Id
        );
        insert entitleLineItem;
        return entitleLineItem;
    }
    
         
        
    
}