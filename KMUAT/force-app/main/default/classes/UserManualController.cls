public with sharing class UserManualController {
    @AuraEnabled(cacheable=true)
    public static List<Knowledge_Base__c> getUserManualTree() {
        return [
            SELECT Id, Title__c, Content__c, Order__c, Parent_Knowledge_Base__c
            FROM Knowledge_Base__c
            WHERE Status__c = 'Active' AND Type__c ='User Manual'
            ORDER BY Parent_Knowledge_Base__c, Order__c
        ];
    }
}