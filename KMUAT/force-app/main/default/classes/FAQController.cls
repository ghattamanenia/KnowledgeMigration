/**
 * @description       : 
 * @author            : Sampath Arjunan
 * @group             : 
 * @last modified on  : 16-11-2024
 * @last modified by  : Sampath Arjunan
**/

public with sharing class FAQController {
    
    @AuraEnabled(cacheable=true)
    public static List<Knowledge_Base__c> getFAQsByCategory(String category, Integer offset, Integer fetchLimit) {
        // Validate inputs
        if (String.isBlank(category)) {
            throw new AuraHandledException('Category cannot be blank.');
        }
        if (offset == null || offset < 0) {
            offset = 0;
        }
        if (fetchLimit == null || fetchLimit <= 0) {
            fetchLimit = 10; // Default fetch limit
        }

        try {
            return [
                SELECT Id, Title__c, Content__c, Category__c
                FROM Knowledge_Base__c
                WHERE Category__c = :category AND Status__c = 'Active' AND Type__c = 'FAQ'
                ORDER BY CreatedDate DESC
                LIMIT :fetchLimit OFFSET :offset
            ];
        } catch (Exception e) {
            throw new AuraHandledException('Error fetching FAQs: ' + e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getCategories() {
       
            List<AggregateResult> results = [
                SELECT Category__c FROM Knowledge_Base__c WHERE Status__c = 'Active' AND Type__c = 'FAQ' GROUP BY Category__c
            ];

            List<String> categories = new List<String>();
            for (AggregateResult result : results) {
                categories.add((String) result.get('Category__c'));
            }
            return categories;
    }
}