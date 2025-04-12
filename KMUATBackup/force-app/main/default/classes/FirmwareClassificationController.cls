public without sharing class FirmwareClassificationController {
    @AuraEnabled(cacheable=true)
    public static List<Catalog_Line_Item__c> getFirmwareRecords(Id catalogRecordId) {
        return [
            SELECT Firmware__r.Availability__c, Firmware__r.Id, Firmware__r.Name,Firmware__r.Effective_Date__c,Firmware__r.Version__c
            FROM Catalog_Line_Item__c
            WHERE Catalog_Item__r.Id = :catalogRecordId order by Effective_Date__c DESC 
        ];
    }
    @AuraEnabled(cacheable=true)
    public static List<Software_File_Allocation__c> getAssociatedSoftware(Id firmwareId) {
        return [
            SELECT Id, Software__c, Software__r.Name, Software__r.File_Description__c,Software__r.File_Key__c,Software__r.File_Status__c,CreatedDate,LastModifiedDate 
            FROM Software_File_Allocation__c  WHERE Firmware__r.Id = :firmwareId 
            Order by LastModifiedDate DESC
        ];
    }
}