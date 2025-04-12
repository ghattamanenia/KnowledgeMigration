trigger ExpireEntitlement on Service_Asset__c ( after update) {
/*
     List<Entitlement> lstEnt = new List<Entitlement>();
     List<Entitlement> lstEntupdate = new List<Entitlement>();
     lstEnt = [Select Id,Status,EndDate,StartDate,HW_Asset__c,Service_Asset__c from Entitlement where Status = 'Active' AND Service_Asset__c In :  trigger.newmap.keyset()];
     system.debug('### ExpireEntitlement before update ###' + lstEnt );
     for(Service_Asset__c SA : trigger.new){
         for(Entitlement Ent : lstEnt){
             if((SA.Asset__c == null)){ // && (Ent.Status == 'Active')){
                       Ent.EndDate = Date.today().addDays(-1);
                 if(Ent.StartDate>=Ent.EndDate)
                     Ent.StartDate = Ent.EndDate.addDays(-1);
                
                lstEntupdate.add(Ent);         
             }
         
         }
     }
     
     if(lstEntupdate.size()>0){
         Utils.DoNotRun_entitlementTrigger = true;
         system.debug('### ExpireEntitlement after update ###' + lstEntupdate);
         update lstEntupdate;
         }*/
}