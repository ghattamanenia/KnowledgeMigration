public  without sharing class UpdateRelContact {
    @future
    public static void UpdateRelContacts(Set<ID> conts){
        system.debug('## conts ##' + conts);  
        List<Contact> Rel_Conts = new List<contact>();
        Rel_Conts = [Select id, Service_Portal_User_Activated__c from contact where id IN:conts];
        for(contact con : Rel_Conts){
                con.Service_Portal_User_Activated__c = false;        
        }
         system.debug('## Rel_Conts ##' + Rel_Conts);  
        if(Rel_Conts.size()>0){
                 update Rel_Conts;
        }
    }
    
    @future
    public static void UpdateRelContactsInsert( SET<ID> relconts ){
        
        List<Contact> Rel_Conts = new List<contact>();
        Rel_Conts = [Select id, Service_Portal_User_Activated__c from contact where id IN:relconts];
        for(contact con : Rel_Conts){
                con.Service_Portal_User_Activated__c = true;        
        }
         system.debug('## Rel_Conts ##' + Rel_Conts);  
        if(Rel_Conts.size()>0){
                 update Rel_Conts;
        }
    }
}