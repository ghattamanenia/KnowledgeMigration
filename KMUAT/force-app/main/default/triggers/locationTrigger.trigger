trigger locationTrigger on Account (before insert, after insert,before update/*,after update*/) {

  //skip only when it is executed by Sansan
  if(trigger.isInsert){
    for(Account acc : Trigger.New){
      if(string.isBlank(acc.Sansan_CI__Sansan_CompanyId_FK__c) == false){
        return;
      }
    }
  }

  if(trigger.isbefore && trigger.Isinsert){
       for(Account a : trigger.new)
         a.Timezone_Updated__c = true;
   }
  else{
    List<Id> accountIds = new List<Id>();
    List<Id> uAccountIds = new List<Id>();
    string businessString ;
    List<Account> accountList = new List<Account>();
    
    if(trigger.IsInsert) {
       for(Account a : trigger.new)
         accountIds.add(a.Id);
    
    }
    else{
        for(Account a : trigger.new){
            if(a.Business__c == null && a.Timezone_Updated__c == false)  //Timezone_Updated__c = true means system has already tried to update timezone but failed to do so.. so now this needs to be done manually.
                uAccountIds.add(a.Id);
                
               a.Timezone_Updated__c = true;
        }
    }
    if(trigger.IsInsert){
        if(LocationCallouts.skipcallout == false)
        LocationCallouts.getLocation(accountIds);
        system.debug('***Inserted');
    }
    else{
        if(uAccountIds.size()>0){
            if(LocationCallouts.skipcallout == false)
                LocationCallouts.getLocation(uAccountIds);
            system.debug('***Updated');
        }
    }  
    if(trigger.Isupdate && trigger.isbefore){
        for(Account a : trigger.new){ 
            if(a.Business__c != null){
                businessString = a.Business__c;
                List<String> ss = businessString.split('\\(');
                integer i = ss[1].length();
                string sss = ss[1].substring(0,i-1);
                a.TimeZoneName__c = sss;
             }
           }
         }     
  }              
}