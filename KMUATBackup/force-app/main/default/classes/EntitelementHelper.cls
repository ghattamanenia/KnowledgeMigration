public class EntitelementHelper
{

    public static boolean entitelemtUpdate = false;
    public static void entitelementUpdate(map<ID,Entitlement> triggernewmap,map<ID,Entitlement> triggeroldmap)
    {
        system.debug('***ent update');
        set<ID> hwIds = new set<ID>();
        for(Entitlement ent : triggernewmap.values())        
        {
             if(ent.Name != 'Default' && ent.HW_Asset__c != null && ent.status != 'Expired')
             //if(ent.HW_Asset__c != null && ent.status != 'Expired')
             {
                hwIds.add(ent.HW_Asset__c);
             }
        } 
       list<Entitlement>  updateEnts = new list<Entitlement>();
       system.debug('****'+hwids);
      List<Entitlement> AllExistingent = new List<Entitlement>();
      AllExistingent = [SELECT ID,EndDate,StartDate FROM Entitlement  WHERE Name != 'Default' AND HW_Asset__c IN: hwIds AND ID NOT IN: triggernewmap.keyset()];
      system.debug('####AllExistingent####' + AllExistingent  );
        for(Entitlement ent: AllExistingent )
        {
            system.debug('****Old***'+ent.StartDate+'****'+ent.EndDate);
             Entitlement ento = new Entitlement(ID=ent.ID,StartDate=ent.StartDate);            
             ento.EndDate = triggernewmap.values().get(0).StartDate.addDays(-1);
             //ento.EndDate = triggernewmap.values().get(0).StartDate;
             if( ento.StartDate >= triggernewmap.values().get(0).StartDate.addDays(-1))
                 ento.StartDate =triggernewmap.values().get(0).StartDate.addDays(-2);
             
            system.debug('****New***'+ento.StartDate+'****'+ento.EndDate);             
             updateEnts.add(ento);
        
        }
        
        if(updateEnts.size() > 0)
        {
            entitelemtUpdate = true;
            update updateEnts;
        }
        
    }
}