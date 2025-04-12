public with sharing class DownloadPreferenceController {
    
    @AuraEnabled(cacheable=true)
    public static Boolean getDownloadPreference() {
        // Get the current user's contact ID
        String contactId = [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId()].ContactId;
        if (contactId == null) {
            return null; // Return null if no contact is associated
        }
        
        // Query the Download_Preference__c field from the Contact
        Contact contactRecord = [SELECT Download_Preference__c FROM Contact WHERE Id = :contactId LIMIT 1];
        return contactRecord.Download_Preference__c;
    }
    
    @AuraEnabled
    public static void updateDownloadPreference(Boolean downloadPreference) {
    try {
        // Get the current user's contact ID
        String contactId = [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId()].ContactId;
        if (contactId == null) {
            throw new AuraHandledException('No associated Contact found for the logged-in user.');
        }
        
        // Update the Download_Preference__c field
        Contact contactToUpdate = new Contact(Id = contactId, Download_Preference__c = downloadPreference);
        update contactToUpdate;
    } catch (DmlException ex) {
        throw new AuraHandledException('Failed to update preference: ' + ex.getMessage());
    }
}
}