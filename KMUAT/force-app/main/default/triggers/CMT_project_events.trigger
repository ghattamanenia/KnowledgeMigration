trigger CMT_project_events on Milestone1_Project__c (after update) {

     Set<ID> AllPrjctids = new Set<ID>();
     Set<ID> AllrelCasesIds = new Set<ID>();
     List<Milestone1_Project__c> AllPrjcts = new List<Milestone1_Project__c>();
     
     for(Milestone1_Project__c updatedPrjct: trigger.new)
     {
        Milestone1_Project__c oldprjctVal = Trigger.oldMap.get(updatedPrjct.ID);
        if((oldprjctVal.Deadline__c != updatedPrjct.Deadline__c) || (oldprjctVal.Parent_Project__c != updatedPrjct.Parent_Project__c) || 
        (oldprjctVal.Status__c != updatedPrjct.Status__c) && (updatedPrjct.Status__c == 'Completed') )
        {
        system.debug('::reached here::');
         AllPrjctids.add(updatedPrjct.ID);
         AllPrjcts.add(updatedPrjct);
        }
     }
    List<Milestone1_Project__c> AllchildProjects = [select Id,Related_Case__c from Milestone1_Project__c where Parent_Project__c IN :AllPrjctids];

    AllPrjcts.addAll(AllchildProjects);
    
    for(Milestone1_Project__c updtdPrjct: AllPrjcts)
     {
        AllrelCasesIds.add(updtdPrjct.Related_Case__c);
       
     }
     List<case> AllCases = [Select id from case where id IN :AllrelCasesIds];
    update AllCases;
}