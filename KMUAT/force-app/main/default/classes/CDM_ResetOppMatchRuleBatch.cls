global class CDM_ResetOppMatchRuleBatch implements Database.Batchable<sObject> {
    
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