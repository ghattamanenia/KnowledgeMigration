public with sharing class QuoteAccountSelectorController {
    public Account[] availableAccounts {get; private set;}
    public String selectedAccountId {get; set;}
    public String nextUrl {get; set;}
    public boolean errorOccured {get;set;}
    private Id opportunityId;
    private Map<String,String> params;
    
    public QuoteAccountSelectorController(ApexPages.StandardController stdController) {
    }
    
    public PageReference onInit() {
        params = new Map<String,String>(ApexPages.currentPage().getParameters());
        opportunityId = params.get('CF00Nw0000008qsxF_lkid');
        if (opportunityId == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You must create quote from Opportunity detail page'));
        } else {
            Opportunity opp = [SELECT Account.Name FROM Opportunity WHERE Id = :opportunityId];
            availableAccounts = new Account[]{opp.Account};
            for (OpportunityPartner partner : [SELECT AccountTo.Name, Role FROM OpportunityPartner WHERE OpportunityId = :opportunityId]) {
                if (partner.AccountTo.Id != opp.Account.Id) {
                    availableAccounts.add(partner.AccountTo);
                }
            }
        }
        return null;
    }
    
    public PageReference onSelect() {
        String custbillingstate ='';
        String cusshippingstreet ='';
        String cusshippingcity ='';
        String cusshippingpostcode ='';
        String cusshippingcountry ='';
        String cusshippingstate ='';
        Account[] quoteTo = [SELECT Id, Name, Region__c,ATFE_Price_Book__c, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry,  ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry FROM Account WHERE Id = :selectedAccountId]; // Kranthi
         if (quoteTo.isEmpty()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Please select an Account.'));  //Kranthi
            errorOccured = true;
            return null;
        }
        
        if( quoteTo[0].Region__c == 'EMEA' || quoteTo[0].Region__c == 'NA' || quoteTo[0].Region__c == 'CSA' || quoteTo[0].Region__c == 'APAC')
        {                        
            if(quoteTo[0].BillingStreet == null)     
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, quoteTo[0].Name + 'Please select "BillingStreet".'));  //Kranthi
                errorOccured  = true;
                return null;
            }        
            if(quoteTo[0].BillingState == null && quoteTo[0].Region__c != 'EMEA')
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, quoteTo[0].Name + ' is missing "BillingState".'));  //Kranthi
                errorOccured  = true;
                return null;
            }                                 
            if(quoteTo[0].BillingCity == null)     
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, quoteTo[0].Name + ' is missing "BillingCity".'));  //Kranthi
                errorOccured  = true;
                return null;
            }
            if(quoteTo[0].BillingCountry == null)     
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, quoteTo[0].Name + ' is missing "BillingCountry".'));  //Kranthi
                errorOccured  = true;            
                return null;
            }
             if(quoteTo[0].BillingPostalCode == null)     
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, quoteTo[0].Name + ' is missing "BillingPostalCode".'));  //Kranthi
                errorOccured  = true;            
                return null;
            }
             if(quoteTo[0].ATFE_Price_Book__c == null)     
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, quoteTo[0].Name + ' is missing "Price Book". Please work with Sales Operations to update the Account.'));  //Kranthi
                errorOccured  = true;            
                return null;
            }
        }
        
        errorOccured = false;
             
        Pricebook2[] pbs = [SELECT Id FROM Pricebook2 WHERE Name = :quoteTo[0].ATFE_Price_Book__c AND IsActive = true];
   /*     if (pbs.isEmpty()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, quoteTo[0].Name + ' is missing price book. Please work with Sales Operations to update the Account.'));
            return null;
        }  */

        
        Opportunity opp = [SELECT Pricebook2Id FROM Opportunity WHERE Id = :opportunityId];
        if (opp.Pricebook2Id != pbs[0].Id) {
            // Delete any existing products since we are switching pricebook.
            delete [SELECT Id FROM OpportunityLineItem WHERE OpportunityId = :opportunityId];
            opp.Pricebook2Id=pbs[0].Id;
            update opp;
        }
        
        /* PageReference pref = Page.SBQQ__NewQuote;
        pref.getParameters().putAll(params);
        params = pref.getParameters(); */
        
        params.put('CF00Nw0000003E9hK', quoteTo[0].Name);  //Kranthi
        params.put('CF00Nw0000003E9hK_lkid', quoteTo[0].Id);   //Kranthi
        params.put('nooverride','1');
        

        // Default billing address
        params.put('00Nw0000003E9hQ', quoteTo[0].Name); //SBQQ__BillingName__c
        params.put('00Nw0000003E9hT', quoteTo[0].BillingStreet);//SBQQ__BillingStreet__c
        params.put('00Nw0000003E9hO', quoteTo[0].BillingCity);//SBQQ__BillingCity__c
                 
        if(quoteTo[0].Region__c != 'EMEA')   //Kranthi
        {
            params.put('00Nw0000003E9hS', quoteTo[0].BillingState); //BillingState  
            custbillingstate =  quoteTo[0].BillingState;
        }              
        params.put('00Nw0000003E9hR', quoteTo[0].BillingPostalCode); //BillingPostalCode
        params.put('00Nw0000003E9hP', quoteTo[0].BillingCountry);  //BillingCountry
        
        // Default shipping address
        params.put('00Nw0000003E9hv', quoteTo[0].Name);  //ShippingName
        params.put('00Nw0000003E9hy', (quoteTo[0].ShippingStreet != null) ? quoteTo[0].ShippingStreet : quoteTo[0].BillingStreet);  //ShippingStreet
        params.put('00Nw0000003E9ht', (quoteTo[0].ShippingCity != null) ? quoteTo[0].ShippingCity : quoteTo[0].BillingCity);   //ShippingCity
        
        cusshippingstreet = quoteTo[0].ShippingStreet != null ? quoteTo[0].ShippingStreet : quoteTo[0].BillingStreet;
        cusshippingcity = quoteTo[0].ShippingCity != null ? quoteTo[0].ShippingCity : quoteTo[0].BillingCity;

        if(quoteTo[0].Region__c != 'EMEA')   //Kranthi
        {
            params.put('00Nw0000003E9hx', (quoteTo[0].ShippingState != null) ? quoteTo[0].ShippingState : quoteTo[0].BillingState);   //ShippingState    
            cusshippingstate = quoteTo[0].ShippingState != null ? quoteTo[0].ShippingState : quoteTo[0].BillingState;
        }
        params.put('00Nw0000003E9hw', (quoteTo[0].ShippingPostalCode != null) ? quoteTo[0].ShippingPostalCode : quoteTo[0].BillingPostalCode);  //ShippingPostalCode
        params.put('00Nw0000003E9hu', (quoteTo[0].ShippingCountry != null) ? quoteTo[0].ShippingCountry : quoteTo[0].BillingCountry);  //ShippingCountry
        
        cusshippingpostcode = quoteTo[0].ShippingPostalCode != null ? quoteTo[0].ShippingPostalCode : quoteTo[0].BillingPostalCode;
        cusshippingcountry = quoteTo[0].ShippingCountry != null ? quoteTo[0].ShippingCountry : quoteTo[0].BillingCountry;

        
        
        
        
        
        
        if(UserInfo.getUiThemeDisplayed() == 'Theme3') // Classic Page
        {
            //classic code
            nextUrl  = '/' + SBQQ__Quote__c.sObjectType.getDescribe().getKeyPrefix() + '/e' + '?';
            for (String key : params.keySet()) {
            system.debug('****key***'+key);
                if(params.containskey(key) && params.get(key) != null)
                nextUrl += (key + '=' + EncodingUtil.urlEncode(params.get(key), 'UTF-8') + '&');
            }
        }
        else // LEX Code
        { 
          nextUrl= '/lightning/o/SBQQ__Quote__c/new?nooverride=1&defaultFieldValues=SBQQ__Account__c='+quoteTo[0].Id+',SBQQ__Opportunity2__c='+opportunityId+',SBQQ__BillingName__c='+quoteTo[0].Name+',SBQQ__BillingStreet__c='
          +quoteTo[0].BillingStreet+',SBQQ__BillingCity__c='+quoteTo[0].BillingCity+',SBQQ__BillingState__c='+custbillingstate+',SBQQ__BillingPostalCode__c='+quoteTo[0].BillingPostalCode+',SBQQ__BillingCountry__c='
          +quoteTo[0].BillingCountry+',SBQQ__ShippingName__c='+quoteTo[0].Name+',SBQQ__ShippingStreet__c='+cusshippingstreet+',SBQQ__ShippingCity__c='+cusshippingcity+',SBQQ__ShippingState__c='+cusshippingstate+',SBQQ__ShippingPostalCode__c='+cusshippingpostcode+',SBQQ__ShippingCountry__c='+cusshippingcountry+'&cancelURL='+quoteTo[0].Id;
        }
        
        
        PageReference pg = new PageReference(nextUrl);
        pg.setRedirect(true);
        return pg;
      //   return new PageReference('/' + nextUrl );  //Kranthi
    }
    
    public PageReference onCancel() {
        return new PageReference('/' + opportunityId);
    }
}