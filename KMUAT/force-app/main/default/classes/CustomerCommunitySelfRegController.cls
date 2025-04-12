/**
 * An apex page controller that supports self registration of users in communities that allow self registration
 */
public class CustomerCommunitySelfRegController{

    public String firstName {get; set;}
    public String lastName {get; set;}
    public String email {get; set;}
    public String phone {get; set;} 
    public String communityNickname {get; set { communityNickname = value == null ? value : value.trim(); } }
    
    public String accountName {get; set;}
    public String website{get; set;}
    public String street {get; set;}
    public String city {get; set;}
    public String state {get; set;}
    public String zipCode {get; set;}
    public String countryCode {get; set;}
    private String country;
    public String pickLabel {get; set;}
    public List<SelectOption> allSelectOptions{get; set;}
    public String selectedCountry{get; set;}
    public String error {get;set;}
    public String userId;
    public List<String> countries;
    public Map<string,string> countryISO;
    
    public List<SelectOption> countryOptions {get; set;}

    public CustomerCommunitySelfRegController() {
        error = '';
        allSelectOptions = new List<SelectOption>();
        countryOptions = new List<SelectOption>();
        try {
            // get the describe field result for the user timezone field
            Schema.DescribeFieldResult userTimezoneDescribe = Schema.sObjectType.User.fields.TimeZoneSidKey;
            // get the list of picklist entries for the timezone field
            List<Schema.PicklistEntry> allPicklistEntries = userTimezoneDescribe.getPicklistValues();
            
             SelectOption optiontime = new SelectOption('', '-- Select One --');
             allSelectOptions.add(optiontime);
            // loop through the picklist entries and debug each value and label
            for(Schema.PicklistEntry entry : allPicklistEntries) {
                String pickValue1 = entry.getValue(); 
                String pickLabel1 = entry.getLabel();

                //SelectOption option = new SelectOption(pickLabel, pickLabel);
                optiontime = new SelectOption(pickValue1,pickLabel1 );
                allSelectOptions.add(optiontime);
            }

           
            // Find all the countries in the custom setting
            Map<String, CountryRegionMapping__c > Allcountries = CountryRegionMapping__c.getAll();
            
           
            CountryRegionMapping__c CountrytoRegion;
            String ISO_Code;
            String CountryName;
            
            countries= new List<String>();
            countries.addAll(Allcountries.keySet());
            countries.Sort();
            SelectOption option = new SelectOption('', '-- Select One --');
            countryOptions.add(option);
            List<SelectOption> countryOpt = new List<SelectOption>();
            for (String keyName : countries) {
                CountrytoRegion = CountryRegionMapping__c.getValues(keyName);
                ISO_Code = CountrytoRegion.Name;
                CountryName = CountrytoRegion.Country_Name__c;
                option = new SelectOption(ISO_Code, CountryName );
                countryOpt.add(option);
            }
             // Sort these by name
            countryOpt = SortSelectOptions.selectOptionSortByLabel(countryOpt);
            countryOptions.addAll(countryOpt );
        }
        catch (Exception ex) {
            error = ex.getMessage();          
        }
         
      

    }
    
    public PageReference BackPage() {
        PageReference page = new PageReference('/CustomerCommunityHome');
        page.setRedirect(true);
        return page;
    }

    

  /*  private boolean createcontact(string lastName,string firstname, Id ConRCTypeId, Id accId, string email, string phone, Contact cont) 
    {
         
         boolean rslt = false;
         cont.LastName = lastName ;
         cont.FirstName = firstname;
         cont.RecordTypeId = ConRCTypeId;
         cont.AccountId = accId;
         cont.Email = email;
         cont.Phone = phone;

         try 
         {
            ID ConOwnerId = [SELECT Id,ownerid FROM Account where Id =  :accId].ownerid;
            cont.ownerid = ConOwnerId;
            insert cont;
             rslt = true;
         }
         catch(DmlException e) 
         {
           //System.debug('The following exception has occurred inserting contact: ' + e.getMessage());
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Error creating Contact :' + e.getMessage()));
         }
        
        return rslt;
       
    }

    private boolean createAccount(string accountName,string street ,String city ,String state ,String zipCode ,String countryCode, string website,Id AccRCTypeId, Account accnt) 
    {
        CountryRegionMapping__c CountrytoRegion = CountryRegionMapping__c.getValues(countryCode);
        String Region = CountrytoRegion.Region__c;
        String Sub_Region = CountrytoRegion.Sub_Region__c;
        String Sales_dep = CountrytoRegion.Sales_Department__c;
        String country = CountrytoRegion.Country_Name__c;
        system.debug('Region::' + Region + 'Sub_Region::'+ Sub_Region + 'Sales_dep::' + Sales_dep);
        
        boolean rslt = false;
        accnt.name = accountName;
        accnt.website = website;

        accnt.RecordTypeId = AccRCTypeId ;
        accnt.ATFE_AccountType__c = 'End Customer';
        accnt.Region__c = Region;
        accnt.Sub_Region__c = Sub_Region;
        accnt.ATFE_SalesOrgName__c = Sales_dep;
        accnt.ATFE_VerticalMarketInit__c = 'Other';
        accnt.BillingCity = city;
        accnt.BillingCountry = country;
        accnt.BillingPostalCode = zipCode ;
        accnt.BillingState = state;
        accnt.BillingStreet = street ;
        accnt.ShippingCity =  city;
        accnt.ShippingCountry = country;
        accnt.ShippingPostalCode = zipCode ;
        accnt.ShippingState = state;
        accnt.ShippingStreet = street ;
        
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
         else
             AccOwners = [SELECT UserOrGroupId FROM GroupMember where GroupId IN (SELECT Id FROM Group where DeveloperName = 'APAC_Support_New_Account_Owner')];
          
         if(AccOwners.size()>0)
         {
             accnt.ownerid = AccOwners[0].UserOrGroupId ;
         }
                 
            
            insert accnt;
            rslt = true;
        }
         catch(DmlException e) 
        {
            System.debug('The following exception has occurred inserting Account:-> ' + e.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Error creating Account:->' + e.getMessage()));

        }
        system.debug('account data::' + accnt);
        return rslt;
       
    }*/
    
    
    public static void sendSingleMail(id objId,List<string> emailAddr ) {
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'atsupport@alliedtelesis.com'];
        
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        if ( owea.size() > 0 ) {
            mail.setOrgWideEmailAddressId(owea.get(0).Id);
           
        }
        
         mail.setToAddresses(emailAddr );
         mail.setSubject('Allied Telesis Portal Account Request');
         mail.setHtmlBody('Hello,<br/><br/>Thank you for requesting an account on the Allied Telesis Customer Portal.<br/>The support team expects to review your request and reply within one business day.<br/><br/>Thank you,<br/>Allied Telesis Customer Support<br/>http://www.alliedtelesis.com/support');

        mail.setPlainTextBody('Hello, Thank you for requesting an account on the Allied Telesis Customer Portal.The support team expects to review your request and reply within one business day. Thank you,Allied Telesis Customer Support http://www.alliedtelesis.com/support');       
        mail.saveAsActivity = false;        
       
    
        try 
        {
            Messaging.sendEmail(new Messaging.SingleEmailmessage[] {mail});
        }
        catch(DmlException e) 
        {
            
            System.debug('The following exception has occurred while sending email: ' + e.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Error sending email :' + e.getMessage()));
        }
    }
    
    private boolean createcase(/*string accId, string conId, */ string communityNickname, String timezone
    ,string accountName,string street ,String city ,String state ,String zipCode ,String countryCode, 
    string website,string lastName,string firstname, string email, string phone) 
    {
        boolean rslt = false;
        
        Id americasCaseCusCumValRtId = [SELECT Id,Name FROM RecordType where DeveloperName = 'ATI_Community_Registration'].Id;
        
       
        system.debug('::: SUBMITTING CASE:::');
        //Fetching the assignment rules on case
        boolean RunningTest = Test.isRunningTest();
        AssignmentRule AR;    
        Database.DMLOptions dmlOpts;   
        if(!RunningTest)
        {
            AR = new AssignmentRule();
            AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
            //Creating the DMLOptions for "Assign using active assignment rules" checkbox
            dmlOpts = new Database.DMLOptions();
           // dmlOpts.EmailHeader.triggerAutoResponseEmail = true; // This option does not work here as Contact is still not created, enbaling this will cause exception
           // dmlOpts.EmailHeader.triggerOtherEmail = true; // This option does not work here as Contact is still not created, enbaling this will cause exception
            dmlOpts.EmailHeader.triggerUserEmail = true;
            dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
        }
        
       
    
        //Setting the DMLOption on Case instance
       
        
        Case serviceOpsCase = new Case();
        if(!RunningTest)
            serviceOpsCase.setOptions(dmlOpts);
        //serviceOpsCase.AccountId = accId;
        //serviceOpsCase.ContactId = conId;
        serviceOpsCase.Status = 'New';
        serviceOpsCase.Description = 'Validate  Account, Contact and create user id ';
        serviceOpsCase.RecordTypeId = americasCaseCusCumValRtId; 
        serviceOpsCase.CommunityNickname__c = communityNickname;
        serviceOpsCase.User_Time_Zone__c = timezone;
        serviceOpsCase.Origin = 'Portal';
       
        serviceOpsCase.Company_Name__c = accountName;
        serviceOpsCase.First_Name__c = firstname;
        serviceOpsCase.Last_Name__c = lastName;
        serviceOpsCase.CommunityNickname__c = communityNickname;
        serviceOpsCase.Phone__c = phone;
        serviceOpsCase.Website__c = website; 
        serviceOpsCase.Email__c = email;
        serviceOpsCase.Street__c = street ;
        serviceOpsCase.City__c = city;
        serviceOpsCase.State_Province__c = state;
        serviceOpsCase.Zip_Postal_Code__c = zipCode;
        serviceOpsCase.User_Time_Zone__c = timezone;
        serviceOpsCase.Country__c = country;
        serviceOpsCase.CountryISOCode__c = countryCode;
        //sarvinder- fix for case 108558 start
        CountryRegionMapping__c CountrytoRegion = CountryRegionMapping__c.getValues(countryCode);
        serviceOpsCase.Region_AccountReg__c = CountrytoRegion.Region__c;
        serviceOpsCase.Sub_Region_AccountReg__c = CountrytoRegion.Sub_Region__c;
        //sarvinder- fix for case 108558 end
        
    
                                          
        //serviceOpsCase.setOptions(dmlOpts);
        try 
        {
            insert serviceOpsCase ;
            rslt = true;
            List<string> toemails = new List<string>();
            toemails.add(serviceOpsCase.Email__c);
            sendSingleMail(serviceOpsCase.id, toemails);
                
            system.debug( ' CASE DETAILS :: ' + serviceOpsCase);
        }
        catch(DmlException e) 
        {
            
            System.debug('The following exception has occurred inserting case: ' + e.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Error creating Case:' + e.getMessage()));
        }
        return rslt;
    }

    public PageReference registerUser() {
         
        if(firstName == '' || lastName == '' || accountName == '' || street == '' || city == '' || state == '' || zipCode == '' || String.isEmpty(countryCode) || website == '' || phone == '' || email == '' || String.isEmpty(pickLabel) || communityNickname == '')
        {
            if(firstName == '')
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'First Name: Value is required.'));
            if(lastName == '')
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Last Name: Value is required.'));   
            if(accountName == '')
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Company Name: Value is required.'));
            if(street == '')
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Street: Value is required.'));            
            if(city == '')
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'City: Value is required.'));
            if(state == '')
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'State/Province: Value is required.'));
            if(zipCode == '')
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Zip/Postal Code: Value is required.'));
            if(String.isEmpty(countryCode))
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Country: Value is required.'));
            if(website == '')
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Website: Value is required.'));
            if(communityNickname == '')
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Nickname: Value is required.'));
            if(phone == '')
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Phone: Value is required.'));
            if(email == '')
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Email: Value is required.'));
            if(String.isEmpty(pickLabel))
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Time Zone: Value is required.'));
            return null;
        }
        CountryRegionMapping__c Country2Region = CountryRegionMapping__c.getValues(countryCode);
        country = Country2Region.Country_Name__c;
        
        List<user> ExistingUserEmail = [select id,name from user where username = :email];
        if(ExistingUserEmail.size() > 0)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'User with this email already exists. Please use "forgot your password?" link on home page to retrieve your password.'));
             return null;
        }
        
        List<user> ExistingUserAlias = [select Alias,id from user where CommunityNickname = :communityNickname];
        if(ExistingUserAlias.size() > 0)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'This Nickname is already in use. Please try a different one.'));
             return null;
        
        }
        
        system.debug(' trying to register User');
        
        Id AccRCTypeId = [SELECT Id,Name FROM RecordType where DeveloperName = 'Americas_Accounts'].Id;
       
        Id ConRCTypeId = [SELECT Id,Name FROM RecordType where DeveloperName = 'Americas_Contacts'].Id;      
        
        String roleEnum = null; // To be filled in by customer.
       
       
       createcase(communityNickname, pickLabel,
                    accountName,  street ,city ,state ,zipCode , countryCode ,website,
                    lastName,firstName ,email,phone);
        //Account acc;
        //Contact con;
        
       /* List<Account> accntExisting = [SELECT Id,Name,BillingCity,BillingCountry,BillingPostalCode,BillingState,BillingStreet,
        ShippingCity,ShippingCountry,ShippingPostalCode,ShippingState,ShippingStreet FROM Account
        where((BillingCity = :city AND BillingCountry = :country AND BillingPostalCode = :zipCode AND BillingState = :state AND BillingStreet = :street) OR 
        (ShippingCity= :city AND ShippingCountry= :country AND ShippingPostalCode= :zipCode AND ShippingState= :state AND ShippingStreet= :street))];
         system.debug(':::found existing Account::: size ' +accntExisting.size() );
        if(accntExisting.size() == 1)// should not get more than one
        {
            system.debug(':::found existing Account:::');
            acc = accntExisting[0];
            List<Contact> ExistsingContact = [SELECT Id,firstName,lastname,email,phone,AccountId from contact where firstName = :firstName AND lastname = :lastname 
            AND email = :email AND phone =: phone AND AccountId = :acc.id];
             system.debug(':::found existing contact::: size ' +ExistsingContact.size() );
            if(ExistsingContact.size()== 1) // should not get more than one
            {
              system.debug(':::found existing contact::: '+ ExistsingContact);
                con = ExistsingContact[0]; 
                if(!createcase(acc.Id, con.Id,communityNickname, pickLabel,
                    accountName,  street ,city ,state ,zipCode , countryCode ,website,
                    lastName,firstName ,email,phone))
                    return null;          
            }
            else
            {
                con = new Contact();
                system.debug(':::creating new contact::: ');
                if(createcontact(lastName,firstName ,ConRCTypeId,acc.Id,email,phone,con))
                {
                system.debug(':::new contact::: ' + con);
                    if(!createcase(acc.Id, con.Id,communityNickname, pickLabel,
                    accountName,  street ,city ,state ,zipCode , countryCode ,website,
                    lastName,firstName ,email,phone))
                    
   
                    return null; 
                }
            }

        }
        else
        {
            acc = new Account();
            system.debug('create new account');
            if(createAccount(accountName,  street ,city ,state ,zipCode , countryCode ,website,AccRCTypeId, acc))
            {
                system.debug('create new contact' + lastName + ' ' + firstName + ' ' + ConRCTypeId);
                con = new Contact();

                if(createcontact(lastName,firstName ,ConRCTypeId,acc.Id,email,phone,con))
                {
                    system.debug('create new case :: ' + acc.Id + '::' + con.Id );
                     if(!createcase(acc.Id, con.Id,communityNickname, pickLabel,
                    accountName,  street ,city ,state ,zipCode , countryCode ,website,
                    lastName,firstName ,email,phone))
                    return null; 
                }
                else
                {
                    return null;
                }
       
            }
            else
            {
                return null;
            }
        }*/
        return new PageReference('/CustomerCommunitySelfRegSuccess');
    }
    
    
}