public /*with sharing*/ class CustomerCommunityCaseEditController {

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
    public String caseStatusComments{get;set;}
    public String caseCaseOpenDate{get;set;}
    public String caseFirstResponseDate{get;set;}
    public String caseClosedDate{get;set;}
    public String caseResolution{get;set;}
    public String caseRMANumber{get;set;}
    public String caseRMAStatus{get;set;}
    
    public boolean showfield{get;set;}
    
    public boolean showpage{get;set;}

    public String error{get;set;}

    public Case caseDetail{get;set;}
    
    // Below lines are added by Neha on 5/25
    
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
    
    // End of code changes by Neha

    // Code we will invoke on page load.
    public PageReference forwardToCustomAuthPage() {

        if((UserInfo.getUserType() == 'Guest') || (Test.IsRunningTest() && UserInfo.getUserType() == 'Standard')){
            return new PageReference('/CustomerCommunityHome');
        }
        else{
            return null;
        }
    }

    public PageReference SaveCase(){

         if(caseReproducible == 'Yes' && caseReproSteps == '') {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter steps to reproduce the issue.'));
            return null;
        }

        Case updateCase = [SELECT Id from Case where Id = :caseID];

        updateCase.Request_Title__c = caseTitle;
        updateCase.Description = caseDescription;
        updateCase.New_or_Existing_Installation__c = caseNewExistingInstallation;
        updateCase.Is_it_reproducible__c = caseReproducible;
        updateCase.What_are_the_steps_to_reproduce_it__c = caseReproSteps;
        updateCase.If_existing_were_there_recent_changes__c = caseRecentChanges;
        updateCase.specific_circumstances__c = caseSpecificCircumstances;
        updateCase.Is_your_network_down__c = caseNetworkDown;
        updateCase.Is_there_a_workaround_in_place__c = caseWorkaround;
        updateCase.Have_services_degraded__c = caseServicesDegraded;
        updateCase.Impact__c = caseImpact;
        updateCase.Urgency__c = caseUrgency;
        
         // Start of Neha's code addition 
        updateCase.Shipping_City__c=shippingcity;
        updateCase.Shipping_Country__c=shippingcountry;
        updateCase.Shipping_State__c=shippingstate;
        updateCase.Shipping_Street__c=shippingstreet;
        updateCase.Shipping_Zip_Code__c=shippingzipcode;
        updateCase.Name__c=name;
        updateCase.Phone_Number__c=phonenumber;
        updateCase.RMA_Request__c=rmarequest;
        updateCase.Shipping_Address_Company_Name__c=ShippingCompanyName;
        
        updateCase.Billing_Street__c=billingstreet;
        updateCase.Billing_City__c=billingcity;
        updateCase.Billing_State__c=billingstate;
        updateCase.Billing_Country1__c=billingcountry;
        updateCase.Billing_Zip_Code__c=billingzipcode;
        updateCase.Is_billing_address_different__c=billingadddif;
        updateCase.VAT_Number__c=vatnumber;
        updateCase.Billing_Address_Company_Name__c=BillingCompanyName;
        
        // End of Neha changes

        try {
            update updateCase;
        }
        catch (Exception ex) {
            error = ex.getMessage();
        }
        return new PageReference('/CustomerCommunityCaseDetail?caseid=' + caseID);
    }

    public PageReference BackPage() {
        PageReference prevPage = Page.CustomerCommunityCaseDetail;
        prevPage.setRedirect(true);
        prevPage.getParameters().put('caseid', ApexPages.currentPage().getParameters().get('caseid'));
        return prevPage;
    }

    public CustomerCommunityCaseEditController() {
    
    //Added by Neha 8/8/2020
    User currentuser = new User();
    currentuser=[select Id,contactId,Contact.AccountId,Contact.Account.Region__c from User where Id=:UserInfo.getUserId()];
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
    
        error = '';
        showpage = true;
        try {
            caseID = ApexPages.currentPage().getParameters().get('caseid');
            
            caseDetail = [SELECT Id, CaseNumber,Accountid, Request_Title__c, Description, Status, New_or_Existing_Installation__c, 
            Is_it_reproducible__c, What_are_the_steps_to_reproduce_it__c, Urgency__c, Impact__c, 
            If_existing_were_there_recent_changes__c, specific_circumstances__c, 
            Is_your_network_down__c, Is_there_a_workaround_in_place__c, Have_services_degraded__c, 
            warranty__c, priority, ATFE_status_comments__c, case_opened_date__c, first_response__c, 
            closeddate, caseResolution__c, RMA_Number__c, RMA_Status__c,Hw_Asset_Name__c FROM Case where id = :caseID];

            User usr = [Select Id, ContactId,Accountid from User where Id =: UserInfo.getUserId()];
          
            if(caseDetail.Accountid != usr.Accountid)
            {
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'<div class="errorMsgMargin">Unfortunately, there was an issue with your request.</div> If the issue continues, please contact Allied Telesis Technical Support.'));
                 showpage = false;
                 return ;
            }
            
            if(caseDetail.Hw_Asset_Name__c != null) {
                showfield = true;
            } else {
                showfield = false;
            }
            
            caseNumber = caseDetail.CaseNumber;
            caseTitle = caseDetail.Request_Title__c;
            caseDescription = caseDetail.Description;
            caseStatus = caseDetail.Status;
            caseNewExistingInstallation = caseDetail.New_or_Existing_Installation__c;
            caseReproducible = caseDetail.Is_it_reproducible__c;
            caseReproSteps = caseDetail.What_are_the_steps_to_reproduce_it__c;
            caseRecentChanges = caseDetail.If_existing_were_there_recent_changes__c;
            caseSpecificCircumstances = caseDetail.specific_circumstances__c;
            caseNetworkDown = caseDetail.Is_your_network_down__c;
            caseWorkaround = caseDetail.Is_there_a_workaround_in_place__c;
            caseServicesDegraded = caseDetail.Have_services_degraded__c;
            caseRMANumber = caseDetail.RMA_Number__c;
            caseRMAStatus = caseDetail.RMA_Status__c;
            caseWarranty = caseDetail.warranty__c;
            casePriority = caseDetail.priority;
            caseImpact = caseDetail.Impact__c;
            caseUrgency = caseDetail.Urgency__c;
            caseStatusComments = caseDetail.ATFE_status_comments__c;
            if (caseDetail.case_opened_date__c != NULL) {
                caseCaseOpenDate = caseDetail.case_opened_date__c.format();
            }
            else {
                caseCaseOpenDate = '';
            }
            if (caseDetail.first_response__c != NULL) {
                caseFirstResponseDate = caseDetail.first_response__c.format();
            }
            else {
                caseFirstResponseDate = '';
            }
            if (caseDetail.closeddate != NULL) {
                caseClosedDate = caseDetail.closeddate.format();
            }
            else {
                caseClosedDate = '';
            }
            caseResolution = caseDetail.caseResolution__c;

        }
        catch (Exception ex) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            //error = ex.getMessage();
        }
    }
}