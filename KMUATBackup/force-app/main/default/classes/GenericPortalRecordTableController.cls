public with sharing class GenericPortalRecordTableController {
    @AuraEnabled
    public static List<sObject> getRecordData(String objectName, String fields){
        try {
            List<User> loggedInUser = [SELECT Id, AccountId FROM User WHERE Id =: UserInfo.getUserId()];
            if(loggedInUser.size() > 0){
                system.debug('&&&'+objectName);
                if(objectName == 'Product_Series__c'){
                    Set<Id> pscatalogIdSet = new Set<Id>();
                    Set<Id> productseriesIdSet = new Set<Id>();
                    for(Entitle_Line_Item__c eachELI : [SELECT Id, Catalog_Item__c FROM Entitle_Line_Item__c WHERE Entitle_Account__r.Account__c =: loggedInUser[0].AccountId]){
                        pscatalogIdSet.add(eachELI.Catalog_Item__c);
                    }
                    for(Catalog__c  eachCI : [SELECT Id,Product_Series__c  FROM Catalog__c  WHERE Id IN: pscatalogIdSet]){
                        productseriesIdSet.add(eachCI.Product_Series__c);
                    }
                    String query = 'SELECT Id,';
                    query += fields;
                    query += ' FROM Product_Series__c';
                    query += ' WHERE Id IN : productseriesIdSet';
                    System.debug(query);
                    return Database.query(query);
                } 
                else if(objectName == 'Firmware__c'){
                    Set<Id> catalogIdSet = new Set<Id>();
                    Set<Id> firmwareIdSet = new Set<Id>();
                    for(Entitle_Line_Item__c eachELI : [SELECT Id, Catalog_Item__c FROM Entitle_Line_Item__c WHERE Entitle_Account__r.Account__c =: loggedInUser[0].AccountId]){
                        catalogIdSet.add(eachELI.Catalog_Item__c);
                    }
                    for(Catalog_line_Item__c eachCLI : [SELECT Id, Firmware__c FROM Catalog_line_Item__c WHERE Catalog_Item__c IN: catalogIdSet]){
                        firmwareIdSet.add(eachCLI.Firmware__c);
                    }
                    String query = 'SELECT Id,';
                    query += fields;
                    query += ' FROM Firmware__c';
                    query += ' WHERE Id IN : firmwareIdSet';
                    query += ' AND Effective_Date__c <= TODAY AND Expiration_Date__c >= TODAY';
                    System.debug(query);
                    return Database.query(query);
                }
            }
            return new List<sObject>();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}