public without sharing class Case_Reg_NewUser{

public static void RegUser(List<Case> CaseList, Map<id,Case> CaseOldMap){
    
   
      //ID RegCasRecTypeID = [SELECT Id FROM RecordType where Sobjecttype = 'Case' and DeveloperName = 'ATI_Community_Registration' LIMIT 1].id;      
      //ID CommunityProfileID = [SELECT Id,Name FROM Profile where Name = 'Customer Support Community'].Id;
      //Id AccRCTypeId = [SELECT Id,Name FROM RecordType where DeveloperName = 'Americas_Accounts'].Id;
      //Id ConRCTypeId = [SELECT Id,Name FROM RecordType where DeveloperName = 'Americas_Contacts'].Id;   

      RecordTypesSingleTon rt = RecordTypesSingleTon.getInstance();
      
      ID CommunityProfileID = [SELECT Id,Name FROM Profile where Name = 'Customer Support Community'].Id;
      ID RegCasRecTypeID = rt.RtMap.get('ATI_Community_Registration').ID;
      Id AccRCTypeId = rt.RtMap.get('Americas_Accounts').ID;
      Id ConRCTypeId = rt.RtMap.get('Americas_Contacts').ID;

            
      
      SET<string> AllEmails = new SET<string>();

    
      for(case CaseUpdate: CaseList)
      {
          if(CaseUpdate.RecordTypeId == RegCasRecTypeID )         
              AllEmails.add(CaseUpdate.Email__c);
      }
     List<user> ExistingUsers = new List<user>();
     set<id> AllContactIds = new set<id>();
     map<id,user> ExistinguserMap = new map<id,user>();
     system.debug('## AllEmails ##' + AllEmails);
     //ExistingUsers  = [select id,email,username,ContactId,IsActive,createddate   from user where username IN :AllEmails and IsActive = true];

      for(case cs : CaseList){
          AllContactIds.add(cs.contactid);
      }
      
     ExistingUsers.addall([select id,email,username,ContactId,IsActive,createddate   from user where ContactId  IN :AllContactIds and IsActive = true]);
     for(user usr : ExistingUsers  )
     {
         if(!ExistinguserMap.containsKey((string)usr.contactid))
              ExistinguserMap.put(usr.contactid,usr);
      }
      
     
     system.debug('## ExistingUsers  ##' + ExistingUsers  );
       system.debug('## ExistingUsersmap  ##' + ExistingUsers  );
      for(case CaseUpdate: CaseList)
      {
          if(CaseUpdate.RecordTypeId == RegCasRecTypeID )
          {
              CaseUpdate.Service_portal_user_Exists__c = false;
              CaseUpdate.New_Account_Created__c = false;
              CaseUpdate.New_Contact_Created__c = false;
              CaseUpdate.Service_portal_user_enabled__c = false;
              CaseUpdate.Service_Portal_User_Active__c = false;
              CaseUpdate.Service_Portal_User_Password_Reset__c = false;
              CaseUpdate.Service_Portal_User_created_date__c = null;
                
              Case oldCase = CaseOldMap.get(CaseUpdate.Id);
              system.debug('## CaseUpdate.contactid ##' + CaseUpdate.contactid);
               system.debug('## Existinguser ##' + ExistinguserMap.get(CaseUpdate.contactid));
              if((CaseUpdate.contactid != null) && (ExistinguserMap.get(CaseUpdate.contactid) !=null )){
                   CaseUpdate.Service_portal_user_Exists__c = true;
                   CaseUpdate.Service_Portal_User_created_date__c = (ExistinguserMap.get(CaseUpdate.contactid).createddate).date();
                  if(ExistinguserMap.get(CaseUpdate.contactid).IsActive == true)
                      CaseUpdate.Service_Portal_User_Active__c = true;
                      
                    system.debug('## Is Enabled ##' + CaseUpdate.Service_portal_user_enabled__c + '##is Active: ##' + CaseUpdate.Service_Portal_User_Active__c);
              }
              
                
              // create new user for customer registration cases 
              system.debug('CaseUpdate.Status = ' + CaseUpdate.Status +  ' && oldCase.Status = ' + oldCase.Status);
              if(CaseUpdate.RecordTypeId == RegCasRecTypeID && CaseUpdate.Status == 'Closed' && oldCase.Status != 'Closed')
              {
                      if(CaseUpdate.User_Accepted__c == 'Yes')
                      {
                      
                       // check if it just a password reset.
                       if((CaseUpdate.contactid!= null) && (ExistinguserMap.get(CaseUpdate.contactid) !=null ) && (ExistinguserMap.get(CaseUpdate.contactid).IsActive == true)){
                         if(CaseUpdate.Reset_Password_If_User_Exists__c == true){
                             system.resetPassword(ExistinguserMap.get(CaseUpdate.contactid).id, true); 
                             CaseUpdate.Service_Portal_User_Password_Reset__c = true;
                         }
                       }else
                       {
                       for(user usr : ExistingUsers  )
                       {
                           if((usr.username == CaseUpdate.Email__c) && ExistinguserMap.get(CaseUpdate.contactid).id != usr.id ){
                               system.debug('Error: User with username ' +  CaseUpdate.Email__c + ' already Exists. Contact Link : ' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + usr.ContactId );
                               CaseUpdate.addError('A different User with username ' +  CaseUpdate.Email__c + ' already Exists. Contact Link : '+ URL.getSalesforceBaseUrl().toExternalForm() + '/' + usr.ContactId );
                               return;
                             }                   
                       }
                       if(CaseUpdate.Accountid == null)  
                       {
                           Account acc = new Account();
                            
                           if(createAccount(CaseUpdate,AccRCTypeId, acc))
                           {
                             CaseUpdate.New_Account_Created__c = true;
                             contact cont = new contact();
                             if(CaseUpdate.contactid == null)
                             {
                                CaseUpdate.New_Contact_Created__c = true;
                               createcontact(CaseUpdate,ConRCTypeId , acc.Id, cont );                                
                             }
                                                    
     
                           }
                       } 

                      system.debug('CaseUpdate.contactid = ' + CaseUpdate.contactid);
                       if(CaseUpdate.Accountid != null && CaseUpdate.contactid == null)
                       {
                          contact cont = new contact();                                   
                          CaseUpdate.New_Contact_Created__c = true;
                          createcontact(CaseUpdate,ConRCTypeId , CaseUpdate.Accountid , cont );                                
                       } 
                       
                      if(ExistinguserMap.get(CaseUpdate.contactid) != null)
                      {
                           system.debug('Service Portal user is already enabled for this contact: ' + CaseUpdate.contactid);
                      } else
                      {
                        createuser(CaseUpdate, CommunityProfileID );
                         CaseUpdate.Service_portal_user_enabled__c = true;
                      }
                     }
                   }
              }
          } 
      }
   }
                          
private static boolean createAccount(case CaseUpdate, Id AccRCTypeId, Account accnt) 
{
    CountryRegionMapping__c CountrytoRegion = CountryRegionMapping__c.getValues(CaseUpdate.CountryISOCode__c);
    String Region = CountrytoRegion.Region__c;
    String Sub_Region = CountrytoRegion.Sub_Region__c;
    String Sales_dep = CountrytoRegion.Sales_Department__c;
    String country = CountrytoRegion.Country_Name__c;
    system.debug('Region::' + Region + 'Sub_Region::'+ Sub_Region + 'Sales_dep::' + Sales_dep);
    
    boolean rslt = false;
    accnt.name =  CaseUpdate.Company_Name__c;
    accnt.website = CaseUpdate.Website__c;

    accnt.RecordTypeId = AccRCTypeId ;
    accnt.ATFE_AccountType__c = 'End Customer';
    accnt.Region__c = Region;
    accnt.Sub_Region__c = Sub_Region;
    accnt.ATFE_SalesOrgName__c = Sales_dep;
    accnt.ATFE_VerticalMarketInit__c = 'Other';
    accnt.BillingCity = CaseUpdate.City__c;
    accnt.BillingCountry = country;
    accnt.BillingPostalCode = CaseUpdate.Zip_Postal_Code__c;
    accnt.BillingState = CaseUpdate.State_Province__c;
    accnt.BillingStreet = CaseUpdate.Street__c ;
    accnt.ShippingCity =  CaseUpdate.City__c;
    accnt.ShippingCountry = country;
    accnt.ShippingPostalCode = CaseUpdate.Zip_Postal_Code__c;
    accnt.ShippingState = CaseUpdate.State_Province__c;
    accnt.ShippingStreet = CaseUpdate.Street__c;
    
    system.debug('account data::' + accnt);
    try 
    {
     LIST<GroupMember>  AccOwners ;
     if(Region  == 'NA')
          AccOwners = [SELECT UserOrGroupId FROM GroupMember where GroupId IN (SELECT Id FROM Group where DeveloperName = 'NA_Support_New_Account_Owner')] ;
     else if(Region  == 'EMEA')
          AccOwners = [SELECT UserOrGroupId FROM GroupMember where GroupId IN (SELECT Id FROM Group where DeveloperName = 'EMEA_Support_New_Account_Owner')];
     else if(Region  == 'CSA')
          AccOwners = [SELECT UserOrGroupId FROM GroupMember where GroupId IN (SELECT Id FROM Group where DeveloperName = 'CSA_Support_New_Account_Owner')];
     else if(Sub_Region == 'Australia')
          AccOwners = [SELECT UserOrGroupId FROM GroupMember where GroupId IN (SELECT Id FROM Group where DeveloperName = 'APAC_Australia_Support_New_Account_Owner')];
     else if(Sub_Region == 'China')
          AccOwners = [SELECT UserOrGroupId FROM GroupMember where GroupId IN (SELECT Id FROM Group where DeveloperName = 'APAC_China_Support_New_Account_Owner')];
     else if(Sub_Region == 'India')
          AccOwners = [SELECT UserOrGroupId FROM GroupMember where GroupId IN (SELECT Id FROM Group where DeveloperName = 'APAC_India_Support_New_Account_Owner')];
     else if(Sub_Region == 'Indonesia')
           AccOwners = [SELECT UserOrGroupId FROM GroupMember where GroupId IN (SELECT Id FROM Group where DeveloperName = 'APAC_Indonesia_Support_New_Account_Owner')];
     else if(Sub_Region == 'Korea')
           AccOwners = [SELECT UserOrGroupId FROM GroupMember where GroupId IN (SELECT Id FROM Group where DeveloperName = 'APAC_Korea_Support_New_Account_Owner')];
     else if(Sub_Region == 'Malaysia')
           AccOwners = [SELECT UserOrGroupId FROM GroupMember where GroupId IN (SELECT Id FROM Group where DeveloperName = 'APAC_Malaysia_Support_New_Account_Owner')];
     else if(Sub_Region == 'Philippines')
           AccOwners = [SELECT UserOrGroupId FROM GroupMember where GroupId IN (SELECT Id FROM Group where DeveloperName = 'APAC_Philippin_Support_New_Account_Owner')];
     else if(Sub_Region == 'Singapore')
           AccOwners = [SELECT UserOrGroupId FROM GroupMember where GroupId IN (SELECT Id FROM Group where DeveloperName = 'APAC_Singapore_Support_New_Account_Owner')];
     else if(Sub_Region == 'Myanmar')
           AccOwners = [SELECT UserOrGroupId FROM GroupMember where GroupId IN (SELECT Id FROM Group where DeveloperName = 'APAC_Myanmar_Support_New_Account_Owner')];
     else if(Sub_Region == 'Cambodia')
       AccOwners = [SELECT UserOrGroupId FROM GroupMember where GroupId IN (SELECT Id FROM Group where DeveloperName = 'APAC_Cambodia_Support_New_Account_Owner')];
     else if(Sub_Region == 'Taiwan')
           AccOwners = [SELECT UserOrGroupId FROM GroupMember where GroupId IN (SELECT Id FROM Group where DeveloperName = 'APAC_Taiwan_Support_New_Account_Owner')];
     else if(Sub_Region == 'Thailand')
           AccOwners = [SELECT UserOrGroupId FROM GroupMember where GroupId IN (SELECT Id FROM Group where DeveloperName = 'APAC_Thailand_Support_New_Account_Owner')];
     else if(Sub_Region == 'New Zealand')
           AccOwners = [SELECT UserOrGroupId FROM GroupMember where GroupId IN (SELECT Id FROM Group where DeveloperName = 'APAC_NewZealan_Support_New_Account_Owner')];
     else if(Sub_Region == 'Vietnam')
           AccOwners = [SELECT UserOrGroupId FROM GroupMember where GroupId IN (SELECT Id FROM Group where DeveloperName = 'APAC_Vietnam_Support_New_Account_Owner')];
         else     
             AccOwners = [SELECT UserOrGroupId FROM GroupMember where GroupId IN (SELECT Id FROM Group where DeveloperName = 'APAC_Support_New_Account_Owner')];
      
     if(AccOwners.size()>0)
     {
         accnt.ownerid = AccOwners[0].UserOrGroupId ;
     }
             
        
        insert accnt;
        CaseUpdate.accountid = accnt.id;
        rslt = true;
    }
     catch(DmlException e) 
    {
        System.debug('The following exception has occurred inserting Account:-> ' + e.getMessage());
       CaseUpdate.addError('The following exception has occurred creating Account: ' + e.getMessage());

    }
    system.debug('account data::' + accnt);
    return rslt;
   
}

private  static boolean createcontact(case CaseUpdate, Id ConRCTypeId, Id accId, Contact cont) 
{
     
     boolean rslt = false;
     cont.LastName = CaseUpdate.Last_Name__c;
     cont.FirstName = CaseUpdate.First_Name__c;
     cont.RecordTypeId = ConRCTypeId;
     cont.AccountId = accId;
     cont.Email = CaseUpdate.Email__c;
     cont.Phone = CaseUpdate.Phone__c;
     cont.ATFE_Active__c = true;

     try 
     {
        ID ConOwnerId = [SELECT Id,ownerid FROM Account where Id =  :accId].ownerid;
        cont.ownerid = ConOwnerId;
        insert cont;
        
         CaseUpdate.contactid = cont.id;
         rslt = true;
     }
     catch(DmlException e) 
     {
       //System.debug('The following exception has occurred inserting contact: ' + e.getMessage());
       CaseUpdate.addError('The following exception has occurred creating contact: ' + e.getMessage());
     }
    
    return rslt;
   
}

private static boolean createuser(case CaseUpdate,ID CommunityProfileID ){
    boolean rslt = false;
    
    user u = new user();
    u.Username = CaseUpdate.Email__c;
    u.Email = CaseUpdate.Email__c;
    u.FirstName = CaseUpdate.First_Name__c;
    u.LastName = CaseUpdate.Last_Name__c;
    u.CommunityNickname = CaseUpdate.CommunityNickname__c;
    u.ProfileId = CommunityProfileID ;
    u.ContactId = CaseUpdate.contactid;
    u.Alias = CaseUpdate.Last_Name__c.left(4); 
    u.TimeZoneSidKey = CaseUpdate.User_Time_Zone__c;
    u.LocaleSidKey = 'en_US';                 //hardcoding for now
    u.EmailEncodingKey = 'ISO-8859-1';        //hardcoding
    u.LanguageLocaleKey = 'en_US'; 

    
    //Database.DMLOptions dlo = new Database.DMLOptions();
    //dlo.EmailHeader.triggerUserEmail = true;
   // database.insert(user,dlo);
   
    try
    {
        insert u;
        //system.resetPassword(u.id, true); 
       system.debug('inserted user' + u);
       CaseUpdate.Service_portal_user_Exists__c = true;
       CaseUpdate.Service_Portal_User_created_date__c = date.today();
       CaseUpdate.Service_Portal_User_Active__c = true;
       rslt = true;
    }
    catch (Exception e) 
    {
        System.debug('The following exception has occurred creating user: ' + e.getMessage()); 
        CaseUpdate.addError('The following exception has occurred creating user: ' + e.getMessage());
   }
 return rslt;
}

}