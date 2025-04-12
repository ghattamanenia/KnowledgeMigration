/**
* @File Name : EmailPreferenceController.cls
* @Description :
* @Author :
* @Last Modified By :
* @Last Modified On : November 22, 2024
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | November 22, 2024 |   | Initial Version
**/

public with sharing class EmailPreferenceController {
    @AuraEnabled(cacheable=true)
    public static String getEmailPreference() {
        // Get the current community user contact
        User currentUser = [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        
        if (currentUser.ContactId == null) {
            throw new AuraHandledException('Current user is not associated with a contact.');
        }

        // Retrieve the Contact record associated with the current user
        Contact contactRecord = [SELECT Id, 
                                        No_emails_only_Password_Finder_emails__c, 
                                        No_Product_Update_Only_System_emails__c, 
                                        Send_me_all_system_emails__c 
                                   FROM Contact 
                                   WHERE Id = :currentUser.ContactId 
                                   LIMIT 1];

        // Determine the selected preference
        if (contactRecord.No_emails_only_Password_Finder_emails__c) {
            return 'No_emails_only_Password_Finder_emails__c';
        } else if (contactRecord.No_Product_Update_Only_System_emails__c) {
            return 'No_Product_Update_Only_System_emails__c';
        } else if (contactRecord.Send_me_all_system_emails__c) {
            return 'Send_me_all_system_emails__c';
        }

        return null;
    }

    @AuraEnabled
    public static void saveEmailPreference(String preference) {
        // Existing logic for saving preferences
        User currentUser = [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        
        if (currentUser.ContactId == null) {
            throw new AuraHandledException('Current user is not associated with a contact.');
        }

        Contact contactRecord = [SELECT Id, No_emails_only_Password_Finder_emails__c, 
                                        No_Product_Update_Only_System_emails__c, 
                                        Send_me_all_system_emails__c 
                                   FROM Contact 
                                   WHERE Id = :currentUser.ContactId 
                                   LIMIT 1];

        // Reset all preference fields
        contactRecord.No_emails_only_Password_Finder_emails__c = false;
        contactRecord.No_Product_Update_Only_System_emails__c = false;
        contactRecord.Send_me_all_system_emails__c = false;

        // Update the selected preference
        if (preference == 'No_emails_only_Password_Finder_emails__c') {
            contactRecord.No_emails_only_Password_Finder_emails__c = true;
        } else if (preference == 'No_Product_Update_Only_System_emails__c') {
            contactRecord.No_Product_Update_Only_System_emails__c = true;
        } else if (preference == 'Send_me_all_system_emails__c') {
            contactRecord.Send_me_all_system_emails__c = true;
        } else {
            throw new AuraHandledException('Invalid preference value received.');
        }

        update contactRecord;
    }
}