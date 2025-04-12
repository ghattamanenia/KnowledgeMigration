public class portalAccountManagementController {

    public List<Schema.PicklistEntry> ple = new List<Schema.PicklistEntry>();
    public string CommunityProfileId;

    public static void portalAccountCreation(Map<Id,Contact> oldContacts,Map<Id,Contact> newContacts)
    {
        for(Contact con:newContacts.values())
        {
            if((trigger.Isupdate && oldContacts.get(con.Id).Service_Portal_User_Activated__c != con.Service_Portal_User_Activated__c) || trigger.isInsert) {
                if(con.Service_Portal_User_Activated__c==true)
                {
                    // if(trigger.isInsert){

                        if(con.Email=='' || con.Email==null)
                        {
                            con.adderror('Contact\'s email is required to enable customer user.');
                            return;
                        }
                        if(con.FirstName=='' || con.FirstName==null)
                        {
                            con.adderror('Contact\'s first name is required to enable customer user.');
                            return;
                        }
                    // }
                    CreatePortalUser(newContacts);

                }
                
            }
        }
        
    }

    public static void CreatePortalUser(Map<Id,Contact> newContacts) {

        list<User> portalUsersToCreate = new list<user>();
        List<User> usersToEnable = new List<User>();
        String TimezoneSid;
        set<Id> AccIds = new Set<Id>();
        List<Schema.PicklistEntry> ple = new List<Schema.PicklistEntry>();
        string CommunityProfileId;
        Schema.DescribeFieldResult fieldResult = User.TimeZoneSidKey.getdescribe();
        ple = fieldResult.getPicklistValues();
        CommunityProfileID = [SELECT Id,Name FROM Profile where Name = 'Portal Customer Community Login'].Id;

        for(Contact c:newContacts.values()){
            if(c.AccountId!=null)
            AccIds.add(c.AccountId);
        }
        map<id,Account> AcntMap = new map<id,Account>([select id,Business__c,Name from Account where id IN :AccIds] );

        for(Contact cont:newContacts.values()){
            User u = new user();
            u.username=cont.Email;
            u.Email=cont.Email;
            u.FirstName=cont.FirstName;
            u.LastName=cont.lastName;
            u.CommunityNickName=cont.FirstName + ' ' + Cont.LastName;
            u.ProfileId=CommunityProfileId;
            u.contactId=cont.Id;
            u.alias=cont.LastName.left(4);
            if((AcntMap.get(cont.accountid).business__c != null) && (AcntMap.get(cont.accountid).business__c != '') && (AcntMap.get(cont.accountid).business__c != '--None--')){
                for(Schema.PicklistEntry p : ple)
                {
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
            u.LocaleSidKey = 'en_US';                 
            u.EmailEncodingKey = 'ISO-8859-1';        
            u.LanguageLocaleKey = 'en_US'; 
            system.debug('### user ###' + u);
            usersToEnable.add(u);
        }
        if(!usersToEnable.isempty())
        insert usersToEnable;
        Set<Id> resultIds = (new Map<Id,SObject>(usersToEnable)).keySet();
        system.debug('@@@resultIds'+resultIds);
        portalPermissionSetAssignments(resultIds);
        

    }
    @future
    public static void portalPermissionSetAssignments(set<Id> uIds)
    {
        String PSG=[Select Id,developerName from permissionSetGroup where developerName='Portal_User_PSG' limit 1].Id;
        list<PermissionSetAssignment> psalst = new list<PermissionSetAssignment>();
        for(Id uId:uIds){
            psalst.add(new PermissionSetAssignment(permissionSetGroupId=PSG,AssigneeId=uId));
        }
        if(!psalst.isempty())
        insert psalst;
    }


}