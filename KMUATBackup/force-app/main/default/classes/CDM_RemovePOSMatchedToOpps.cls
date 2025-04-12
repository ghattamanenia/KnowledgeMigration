/**
 * Class CDM_RemovePOSMatchedToOpps
 *
 * This batch job will remove all of the matched POS from their Opportunities so that they can be rematched.
 */
 global without sharing class CDM_RemovePOSMatchedToOpps implements Database.Batchable<sObject> {
/*
Create the START Method.
*/
    global Database.QueryLocator start(Database.BatchableContext BC) {
     
        String fields = 'Id ';
        String table = 'Account';
        String conditions = 'Id=Null';
        String query = 'select ' + fields + ' from ' + table + ' where ' + conditions;
        return Database.getQueryLocator(query);
     
     
     
     } 
      
       
        
        
        
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        
         for(sObject s : scope) {}
        Update Scope;
        
        
    }
    
/*
Create the FINISH Method.
*/
    global void finish(Database.BatchableContext BC) {
        // Nothing to do here
    }
}