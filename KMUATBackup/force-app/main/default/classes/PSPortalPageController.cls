public with sharing class PSPortalPageController {
    @AuraEnabled
    public static List<sObject> fetchSoftwareFileAllocations(String productSeriesId){
        try {
            List<User> loggedInUser = [SELECT Id, AccountId FROM User WHERE Id =: UserInfo.getUserId()];
            if(loggedInUser.size() > 0){
                Set<Id> validFirmwareIds = new Set<Id>();
                System.debug('****PSID'+productSeriesId);
                System.debug(loggedInUser[0].AccountId);
                for(Catalog__c eachCatalog : [SELECT Id, 
                                              (SELECT Id FROM Entitle_Line_Items__r WHERE Entitle_Account__r.Account__c =: loggedInUser[0].AccountId),
                                              (SELECT Id, Firmware__c FROM Catalog_line_Items__r)
                                              FROM Catalog__c 
                                              WHERE Product_Series__c =: productSeriesId]){
                                                System.debug('****SOQL'+eachCatalog.Entitle_Line_Items__r);
                    if(eachCatalog.Entitle_Line_Items__r.size() > 0){
                        for(Catalog_Line_Item__c eachCLI :eachCatalog.Catalog_line_Items__r){
                            validFirmwareIds.add(eachCLI.Firmware__c);
                        }
                    }
                }
                System.debug(validFirmwareIds);
                List<sObject> returnData = [SELECT Id, Firmware__r.Availability__c, Firmware__r.Version__c, Software__r.Name, Firmware__r.Effective_Date__c, Software__r.Uploaded_File_URL__c 
                                            FROM Software_File_Allocation__c 
                                            WHERE Firmware__c IN: validFirmwareIds];
                return returnData;
            }
            return new List<sObject>();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}