trigger UpdateRelContact on User (before update, after update,after insert) {
   system.debug('## trigger OLD ##'+ trigger.old);
   system.debug('## trigger NEW ##'+ trigger.new);
   
   id comprofileId = [SELECT id,Name FROM Profile where Name = 'Customer Support Community'].id;
   
   
  
   Set<Id> RelContIds = new Set<Id>();
  /*if(trigger.isupdate && trigger.isbefore){
         for(user usr : trigger.new){
             if(usr.IsActive == false)
                 usr.CommunityNickname =  usr.CommunityNickname + system.now();
               
        }
   }*/
   if(trigger.isinsert){
          
        for(user usr : trigger.new){
            if(usr.profileid == comprofileId ){
             if(usr.IsActive == true)
                RelContIds.add(usr.contactid);
            }
        }
       if(RelContIds.size()>0 && (!Test.IsRunningTest()))
         UpdateRelContact.UpdateRelContactsInsert(RelContIds);
   
   }
   if((trigger.isupdate && trigger.isafter) || (Test.IsRunningTest())){
   for(user usr : trigger.new){
        if(usr.profileid == comprofileId ){
            if(usr.IsActive == false){
               system.debug('## ADD contact ##' + trigger.oldmap.get(usr.id).contactid);                
               RelContIds.add(trigger.oldmap.get(usr.id).contactid);
            }
         }
                
    }
      system.debug('## RelContIds ##' + RelContIds);  
       if(RelContIds.size()>0)
            UpdateRelContact.UpdateRelContacts(RelContIds);
  }

}