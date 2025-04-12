trigger Contact_EnableCustomerUser on Contact (after insert, after update) {

    List<User> usr = new List<User>();
    List<User> sameNickNameusr = new List<User>();
    map<Id,User> UsrConMap = new map<Id,User>();
    usr = [Select id,contactid from user where contactid IN :trigger.new];
    List<Id> RelAcnts = new List<ID>();
    
    Schema.DescribeFieldResult fieldResult = User.TimeZoneSidKey.getdescribe();
    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
   
    ID CommunityProfileID = [SELECT Id,Name FROM Profile where Name = 'Customer Support Community'].Id;
    List<User> EnabledUsers = new List<User>();
    
    for(contact cont : trigger.new)
      RelAcnts.add(cont.accountid);
    
    map<id,Account> AcntMap = new map<id,Account>([select id,Business__c,Name from Account where id IN :RelAcnts] );
    
    for(user u : usr)
        UsrConMap.put(u.contactid,u);
        
  
    for(contact cont : trigger.new){
     if( (Trigger.Isupdate && (Trigger.oldMap.get(cont.id).Service_Portal_User_Activated__c != cont.Service_Portal_User_Activated__c)) ||  Trigger.IsInsert){
           system.debug('### user detail ### ' + UsrConMap.get(cont.id));
            if(cont.Service_Portal_User_Activated__c == true && UsrConMap.get(cont.id) == null){
              if(cont.Email == null){
                  cont.adderror('Contact\'s email is required to enable customer user.');
                  return;
               }
               
              if( cont.FirstName == null){
                  cont.adderror('Contact\'s first name is required to enable customer user.');
                  return;
              
              }
              
                 
                  user u = new user();
                  u.Username = cont.Email;
                  u.Email = cont.Email;
                  u.FirstName = cont.FirstName;
                  u.LastName = cont.LastName;
                  u.CommunityNickname = cont.FirstName + ' ' + cont.LastName;
                  u.ProfileId = CommunityProfileID ;
                  u.ContactId = cont.Id;
                  u.Alias = cont.LastName.left(4);
                  if((AcntMap.get(cont.accountid).business__c != null) && (AcntMap.get(cont.accountid).business__c != '') && (AcntMap.get(cont.accountid).business__c != '--None--')){
                    for(Schema.PicklistEntry p : ple)
                    {
                    system.debug('###'+p.getlabel()+'****'+p.getValue()+'\n'); 
                     
                      //if(AcntMap.get(cont.accountid).business__c == p.getlabel())
                      string AccTimezone = AcntMap.get(cont.accountid).business__c;
                      system.debug('### AccTimezone ### ' + AccTimezone);
                       system.debug('### Value### ' + p.getValue());
                        if(AccTimezone.contains(p.getValue()))
                        {
                          system.debug('### Matched ### ' );
                            system.debug('###'+p.getlabel()+'****'+p.getValue()+'\n');     
                            u.TimeZoneSidKey  = p.getValue();
                            break;
                        }
                    }
                     
                      system.debug('### timezone on business ###' + u.TimeZoneSidKey);
                      }
                  else{
                      cont.adderror('Please update "Billing Address Time Zone" on Account : ' + AcntMap.get(cont.accountid).Name + ' related to this contact to enable the user.');
                      return;
                   }
                  u.LocaleSidKey = 'en_US';                 //hardcoding for now
                  u.EmailEncodingKey = 'ISO-8859-1';        //hardcoding
                  u.LanguageLocaleKey = 'en_US'; 
                  system.debug('### user ###' + u);
                  EnabledUsers.add(u);
                 
            
            }
            
            
     }
    }
    if(EnabledUsers.size()>0){
        insert EnabledUsers;
        system.debug(' ## EnabledUsers ## ' + EnabledUsers);
        }

}