public /*with sharing*/ class CustomerCommunityCretCasHWRegController {
    public String caseID{get;set;}
    public String caseNumber{get;set;}
    public String caseTitle{get;set;}
    public String caseDescription{get;set;}
    public String caseStatus{get;set;}
    public String caseNewExistingInstallation{get;set;}
    public String caseReproducible{get;set;}
    public String caseReproSteps{get;set;}
    public String caseRecentChanges{get;set;}
    public String caseSpecificCircumstances{get;set;}
    public String caseNetworkDown{get;set;}
    public String caseWorkaround{get;set;}
    public String caseServicesDegraded{get;set;}
    public String caseWarranty{get;set;}
    public String casePriority{get;set;}
    public String caseImpact{get;set;}
    public String caseUrgency{get;set;}
    /*public String caseStatusComments{get;set;}
    public String caseCaseOpenDate{get;set;}
    public String caseFirstResponseDate{get;set;}*/
    public String caseClosedDate{get;set;}
    public String caseResolution{get;set;}
    /* public String Hw_Asset{get;set;}*/
    public String productModel{get;set;}
    public string HWSerialNumber{get;set;}
    private list<contact> RelContact;
    // public List<string> RegionproductList{get;set;}
    //public User user{get;set;} // commented By Ravinder
    public Case caseForDateField{get;set;} 

    public String error{get;set;}
    public Boolean showpage{get;set;}
    
    public string shippingstreet {get;set;}
    public string shippingcity {get;set;}
    public string shippingcountry {get;set;}
    public string shippingzipcode {get;set;}
    public string shippingstate {get;set;}
    public boolean rmarequest {get;set;}
    public string phonenumber {get;set;}
    public string name {get;set;}
    public string billingstreet {get;set;}
    public string billingcity {get;set;}
    public string billingcountry {get;set;}
    public string billingzipcode {get;set;}
    public string billingstate {get;set;}
    public string vatnumber {get;set;}
    public boolean billingadddif {get;set;}
    public string BillingCompanyName {get;set;}
    public string ShippingCompanyName {get;set;}
    public boolean showNAterms {get;set;}
    public boolean showEMEAterms {get;set;}
    
    
    // Code we will invoke on page load.
    public PageReference forwardToCustomAuthPage() {

        if((UserInfo.getUserType() == 'Guest') || (Test.IsRunningTest() && UserInfo.getUserType() == 'Standard')){
            system.debug(':::GUEST USER:::');
            return new PageReference('/CustomerCommunityHome');
        }
        else {
            system.debug(':::USER:::' + UserInfo.getUserType());
            return null;
        }
    }
    
    /*public PageReference setProductName() {
     ProductName =  apexpages.currentpage().getparameters().get('prdctstring');
        system.debug('::New product updated:: ' + ProductName );
        return null;
    }*/
    public PageReference SubmitCase() {
        
        updateAccountTimeZone();
        if(caseReproducible == 'Yes' && caseReproSteps == '') {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter steps to reproduce the issue.'));
            return null;
        }
        List<Product2> Rel_prodID;
     
        try {
            Rel_prodID = [Select id FROM Product2  where Family = 'PRODUCT' and (NOT ProductCode like 'Q%')  AND ProductCode != '' and (NOT ProductCode like '%E+%') AND Name = :productModel LIMIT 1];
        }
        catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Error retrieving product model :' + ex.getMessage()));
            return null;
        }
        
        //Get Case record type info
        List<RecordType> AllCaseRT = [SELECT Id, DeveloperName  FROM RecordType where Sobjecttype = 'Case'];
        Id  ATI_CaseID; 
        Id  ATI_HWCaseID; 
        for(RecordType CaseRT : AllCaseRT) {
            if(CaseRT.DeveloperName == 'ATI_Case')
                ATI_CaseID = CaseRT.ID;
            if(CaseRT.DeveloperName == 'ATI_case_create_HW_Asset')
                ATI_HWCaseID= CaseRT.ID;
        }
        
        system.debug('::: SUBMITTING CASE:::');
        //Fetching the assignment rules on case
        Database.DMLOptions dmlOpts = new Database.DMLOptions();
        boolean runningTest =  Test.IsRunningTest();
        
        if(!runningTest) {
            AssignmentRule AR = new AssignmentRule();
            AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
            //Creating the DMLOptions for "Assign using active assignment rules" checkbox
            //dmlOpts = new Database.DMLOptions();
            dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
            dmlOpts.EmailHeader.triggerAutoResponseEmail = true;
            dmlOpts.EmailHeader.triggerOtherEmail = true;
            dmlOpts.EmailHeader.triggerUserEmail = true;
        }
        //Case newCase = new Case(Status = 'New') ;
        //Setting the DMLOption on Case instance
        //newCase.setOptions(dmlOpts);
        //insert newCase ;

        system.debug('productModel is:::' + productModel);
        
        Case submitCase = new Case();
        if(!runningTest )
            submitCase.setOptions(dmlOpts);
            
        submitCase.Request_Title__c = caseTitle;
        submitCase.Description = caseDescription;
        submitCase.New_or_Existing_Installation__c = caseNewExistingInstallation;
        submitCase.Is_it_reproducible__c = caseReproducible;
        submitCase.What_are_the_steps_to_reproduce_it__c = caseReproSteps;
        submitCase.If_existing_were_there_recent_changes__c = caseRecentChanges;
        submitCase.specific_circumstances__c = caseSpecificCircumstances;
        submitCase.Is_your_network_down__c = caseNetworkDown;
        submitCase.Is_there_a_workaround_in_place__c = caseWorkaround;
        submitCase.Have_services_degraded__c = caseServicesDegraded;
        submitCase.Impact__c = caseImpact;
        submitCase.Urgency__c = caseUrgency;
        submitCase.Hw_Asset_Name__c = null;
        
        // Start of Neha's code addition 
        submitCase.Shipping_City__c=shippingcity;
        submitCase.Shipping_Country__c=shippingcountry;
        submitCase.Shipping_State__c=shippingstate;
        submitCase.Shipping_Street__c=shippingstreet;
        submitCase.Shipping_Zip_Code__c=shippingzipcode;
        submitCase.Name__c=name;
        submitCase.Phone_Number__c=phonenumber;
        submitCase.RMA_Request__c=rmarequest;
        submitCase.Shipping_Address_Company_Name__c=ShippingCompanyName;
        
        submitCase.Billing_Street__c=billingstreet;
        submitCase.Billing_City__c=billingcity;
        submitCase.Billing_State__c=billingstate;
        submitCase.Billing_Country1__c=billingcountry;
        submitCase.Billing_Zip_Code__c=billingzipcode;
        submitCase.Is_billing_address_different__c=billingadddif;
        submitCase.VAT_Number__c=vatnumber;
        submitCase.Billing_Address_Company_Name__c=BillingCompanyName;
        
        // End of Neha changes

        //submitCase.Hw_Asset_Name__c = ApexPages.currentPage().getParameters().get('HWId');
        submitCase.AccountId = ApexPages.currentPage().getParameters().get('AccId');
        submitCase.contactId = RelContact[0].id;

        //TODO: validat the number is correct in production
        //ATI Case Type
        submitCase.RecordTypeId = ATI_CaseID;// '01220000000ALEJAA4';  // do ont hardcode
        submitCase.Origin = 'Portal';

        try {
            insert submitCase;
            caseID = submitCase.Id;
            string childCase;
            Case submitCaseChild = new Case();
            
            if(!runningTest) {
                submitCaseChild.setOptions(dmlOpts);
                //submitCaseChild.Request_Title__c = 'Associate Hardware Asset.';
                submitCaseChild.Request_Title__c = 'Create new hardware asset.';
                submitCaseChild.Description = 'Please associate the Hardware Asset number: ' + HWSerialNumber + ' to this Account and work on the parent Case.';
                submitCaseChild.AccountId = ApexPages.currentPage().getParameters().get('AccId');
                submitCaseChild.contactId = RelContact[0].id;
                submitCaseChild.H_W_Serial_Number_reg__c =  HWSerialNumber; 
                submitCaseChild.Date_of_Purchase__c = caseForDateField.Date_of_Purchase__c;             
            }

            if( Rel_prodID.size()>0) {
                submitCaseChild.Product_Mod__c = Rel_prodID[0].id;               
                submitCaseChild.Product_Model_entered_by_customer__c = productModel;
            }
            else {
                submitCaseChild.Product_Model_entered_by_customer__c = productModel+' (product not found)';
            }
            submitCaseChild.parentid = caseID;
            //TODO: validat the number is correct in production
            //ATI Case Type
            submitCaseChild.RecordTypeId = ATI_HWCaseID;//'012g00000000Jd9AAE';//'01220000000ALEJAA4';// do ont hardcode
            submitCaseChild.Origin = 'Portal';

            try {
                insert submitCaseChild;
                //childCase = submitCaseChild.Id;
            }
            catch (Exception ex) {
                System.debug('submitCaseChild ex:::'+ex);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Error creating Hardware Reg Case :' + ex.getMessage()));
                return null;
            }
        }
        catch (Exception ex) {
            System.debug('The following exception has occurred inserting ATI case: ' + ex.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Error creating ATI Case :' + ex.getMessage()));
            return null;
        }

        //return new PageReference('/CustomerCommunityCaseDetail?caseid=' + caseID);
        return new PageReference('/CustomerCommunityLoggedIn');

    }

public void updateAccountTimeZone()
    {
        string accId = ApexPages.currentPage().getParameters().get('AccId');
        list<Account> accs = [SELECT ID, Business__c FROM Account WHERE ID=: accID];
        if(accs[0].Business__c == null)
        {
            Account PortalAccount  = accs.get(0);
            // get user time zone.                
            User loggedinUser = [SELECT ID,TimeZoneSidKey  FROM USER WHERE ID=: userinfo.getUserId()];            
            Schema.DescribeFieldResult fieldResult = User.TimeZoneSidKey.getdescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
            for(Schema.PicklistEntry p : ple)
            {
                String zoneValue = p.getValue();   
                if(loggedinUser.TimeZoneSidKey == zoneValue)
                {
                    system.debug('###'+p.getlabel()+'****'+p.getValue()+'\n');     
                    PortalAccount.Business__c  = p.getlabel();
                }
            }
            update PortalAccount;

        }
        
       
    }
    
    public PageReference BackPage() {
        PageReference prevPage = Page.CustomerCommunityFindHardWare;
        prevPage.setRedirect(true);
        prevPage.getParameters().put('AccId', ApexPages.currentPage().getParameters().get('AccId'));
        return prevPage;
    }
    
    public CustomerCommunityCretCasHWRegController () {
    //Added by Neha 6/22/2020
    User currentuser = new User();
    currentuser=[select Id,contactId,Contact.AccountId,Contact.Account.Region__c from User where Id=:UserInfo.getUserId()];
    showEMEAterms=true;
    if(currentuser.contactId!=null && currentuser.contact.AccountId!=null)
    {
        if(currentuser.Contact.Account.Region__c=='EMEA')
        {
            showEMEAterms=true;
            showNAterms=false;
            
        }
        else
        {
            showEMEAterms=false;
            showNAterms=true;
        }
        
        
        
    }  //end  by neha
        try {
            showpage = true;
            caseForDateField = new Case();
            User usr = [Select Id, ContactId,Accountid from User where Id =: UserInfo.getUserId()];
            RelContact = [select Name,Id from contact where Id = :usr.ContactId ];
          
            if(ApexPages.currentPage().getParameters().get('AccId') != usr.Accountid) {
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'<div class="errorMsgMargin">Unfortunately, there was an issue with your request.</div> If the issue continues, please contact Allied Telesis Technical Support.'));
                 showpage = false;
                 return ;
            }
        }
        catch (Exception ex) {
            error = ex.getMessage();
        }
       system.debug('loading CustomerCommunityCretCasHWRegController ::: ' + UserInfo.getUserType());
    }
    
    
    //public String Hw_Asset() {
    //       PageReference secondPage = Page.CustomerCommunityCreateCase;
    //       secondPage.setRedirect(true);
    //       secondPage.getParameters().put('HWSerialNo',HW_SerialNo); 
    //       return secondPage; 
    //      // return null;
    //   }
}