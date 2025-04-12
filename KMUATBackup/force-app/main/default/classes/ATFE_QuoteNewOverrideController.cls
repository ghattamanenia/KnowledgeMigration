public without sharing class ATFE_QuoteNewOverrideController {
    public Id oppId;
    public String partnerId{get;set;}
    public String selectedPartnerOrAccountForQuoteTo {get;set;}
    public String selectedPartnerOrAccountForBillTo {get;set;}
    public String selectedPartnerOrAccountForShipTo {get;set;}
    public Opportunity opp {get;set;}
    public Account relatedAccount {get;set;}
    public Quote quoteObj {get;set;}
    public Map<Id, Partner> relatedPartners {get;set;}
    public ApexPages.StandardController quoteStd ;
    public Contact con {get;set;}
    
    public ATFE_QuoteNewOverrideController(ApexPages.StandardController std){
        this.oppId = ApexPages.currentPage().getParameters().get('oppid');
        System.debug('this.quoteObj.ContactId :'+this.quoteObj.ContactId);
  
        this.opp = [SELECT Name, AccountId, Account.Name FROM Opportunity WHERE Id = :this.oppId];
        this.relatedAccount = [SELECT Id, Name, ShippingStreet, ShippingState, ShippingPostalCode, ShippingCountry, ShippingCity,
                                      BillingCountry, BillingPostalCode, BillingState, BillingCity, BillingStreet
                               FROM Account WHERE id = :this.opp.AccountId];
        this.quoteObj = new Quote(OpportunityId = this.oppId, Name = '-- please enter a name --',
                                  BillingName = this.relatedAccount.Name,
                                  BillingStreet = this.relatedAccount.BillingStreet,
                                  BillingCity = this.relatedAccount.BillingCity, 
                                  BillingState = this.relatedAccount.BillingState,  
                                  BillingPostalCode = this.relatedAccount.BillingPostalCode,
                                  BillingCountry = this.relatedAccount.BillingCountry,
                                  ShippingName = this.relatedAccount.Name, 
                                  ShippingStreet = this.relatedAccount.ShippingStreet,
                                  ShippingCity = this.relatedAccount.ShippingCity,
                                  ShippingState = this.relatedAccount.ShippingState,
                                  ShippingPostalCode = this.relatedAccount.ShippingPostalCode,
                                  ShippingCountry = this.relatedAccount.ShippingCountry, 
                                  QuoteToStreet = this.relatedAccount.BillingStreet, 
                                  QuoteToCity = this.relatedAccount.BillingCity, 
                                  QuoteToState = this.relatedAccount.BillingState, 
                                  QuoteToPostalCode = this.relatedAccount.BillingPostalCode, 
                                  QuoteToCountry = this.relatedAccount.BillingCountry,email = null
                              );
       
        //populate the relatedPartners map with all Opportunity partners
        this.relatedPartners = new Map<Id, Partner>();
   
        for (Partner partner : [SELECT OpportunityId, AccountToId, AccountTo.Name, 
                         AccountTo.ShippingStreet, AccountTo.ShippingCity, AccountTo.ShippingState,
                         AccountTo.ShippingCountry, AccountTo.ShippingPostalCode,
                         AccountTo.BillingStreet, AccountTo.BillingCity, AccountTo.BillingState,   
                                     AccountTo.BillingCountry, AccountTo.BillingPostalCode
                                FROM Partner 
                                WHERE OpportunityId = :this.oppId and AccountToId != :this.relatedAccount.Id]) {
                this.relatedPartners.put(partner.AccountToId, partner);                                                         
        }
        System.debug('this.relatedPartners: ' + this.relatedPartners);
        this.selectedPartnerOrAccountForQuoteTo = this.relatedAccount.Id;
        this.selectedPartnerOrAccountForBillTo = this.relatedAccount.Id;
        this.selectedPartnerOrAccountForShipTo = this.relatedAccount.Id;
    }

    /*
        The following Method for getting Partners
    */
    public List<SelectOption> getPartners(){
        List<SelectOption> partners = new List<SelectOption>();
        Set<Id> accId = new Set<id>();
        partners.add(new SelectOption('',' -None- '));
        partners.add(new SelectOption(this.relatedAccount.Id, this.relatedAccount.Name));
        accId.add(this.relatedAccount.Id);
        for(Partner pt : this.relatedPartners.values()){
            if(!accId.contains(pt.AccountToId)){
                partners.add(new SelectOption(pt.AccountToId, pt.AccountTo.Name));
                accId.add(pt.AccountToId);
            }
        }
        return partners;
    }
    
   /*
       The following method is for getting contact details for Selected contact
   */
   public pageReference queryContactDetails(){
        //PageReference pageRef = ApexPages.currentPage();
        if (this.quoteObj.ContactId != null) {
            this.con = [select id , Phone , Email ,Fax from Contact where id =:this.quoteObj.ContactId];
	        System.debug('Selected contact :'+con);
	        this.quoteObj.Email = con.Email;
	        this.quoteObj.Phone = con.Phone;
	        this.quoteObj.fax = con.Fax ;
        }
        //pageRef.setRedirect(true);
   
       //return pageRef ;
       return null;
   } 
    
    /*
        The following method for Saving Quote 
    */
    public PageReference saveQuote(){
        if(this.selectedPartnerOrAccountForQuoteTo == null || this.selectedPartnerOrAccountForQuoteTo == ''){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please select Quote To Name'));
             return null;
        }
                        
        this.quoteObj.ATFE_Partner_Name__c = this.selectedPartnerOrAccountForQuoteTo;
        this.quoteObj.ATFE_Bill_To_Name__c = this.selectedPartnerOrAccountForBillTo;
        this.quoteObj.ATFE_Ship_To_Name__c = this.selectedPartnerOrAccountForShipTo;
        quoteStd = new ApexPages.StandardController(this.quoteObj);
        quoteStd.save();
        return new PageReference('/' + quoteStd.getId());
    }
    
    /*
        For Getting Quote Details
    */
    public PageReference setAddressFieldsForQuoteTo(){
        System.debug('******************************************:'+this.selectedPartnerOrAccountForQuoteTo);
        System.debug('******************************************:'+this.relatedAccount.Id);
        
        if (this.relatedPartners.keySet().contains(this.selectedPartnerOrAccountForQuoteTo)) {
                System.debug('selected is a partner');
                Partner selectedPartner = this.relatedPartners.get(this.selectedPartnerOrAccountForQuoteTo);
                this.quoteObj.QuoteToCity = selectedPartner.AccountTo.BillingCity ;
                this.quoteObj.QuoteToCountry = selectedPartner.AccountTo.BillingCountry;
                this.quoteObj.QuoteToPostalCode = selectedPartner.AccountTo.BillingPostalCode;
                this.quoteObj.QuoteToState = selectedPartner.AccountTo.BillingState; 
                this.quoteObj.QuoteToStreet = selectedPartner.AccountTo.BillingStreet;
                return null;
        } else if (this.selectedPartnerOrAccountForQuoteTo == this.relatedAccount.Id) {
                System.debug('selected is the related account');
                this.quoteObj.QuoteToCity = this.relatedAccount.BillingCity ;
                this.quoteObj.QuoteToCountry = this.relatedAccount.BillingCountry;
                this.quoteObj.QuoteToPostalCode = this.relatedAccount.BillingPostalCode;
                this.quoteObj.QuoteToState = this.relatedAccount.BillingState; 
                this.quoteObj.QuoteToStreet = this.relatedAccount.BillingStreet;
                return null;
        }
        return null;
    }
    
    public PageReference setAddressFieldsForBillTo(){
        System.debug('******************************************Selected for Bill to:'+this.selectedPartnerOrAccountForBillTo);
        
        if (this.relatedPartners.keySet().contains(this.selectedPartnerOrAccountForBillTo)) {
                System.debug('selected is a partner');
                Partner selectedPartner = this.relatedPartners.get(this.selectedPartnerOrAccountForBillTo);
                this.quoteObj.BillingCity = selectedPartner.AccountTo.BillingCity ;
                this.quoteObj.BillingCountry = selectedPartner.AccountTo.BillingCountry;
                this.quoteObj.BillingPostalCode = selectedPartner.AccountTo.BillingPostalCode;
                this.quoteObj.BillingState = selectedPartner.AccountTo.BillingState; 
                this.quoteObj.BillingStreet = selectedPartner.AccountTo.BillingStreet;
                return null;
        } else if (this.selectedPartnerOrAccountForBillTo == this.relatedAccount.Id) {
                System.debug('selected is the related account');
                this.quoteObj.BillingCity = this.relatedAccount.BillingCity ;
                this.quoteObj.BillingCountry = this.relatedAccount.BillingCountry;
                this.quoteObj.BillingPostalCode = this.relatedAccount.BillingPostalCode;
                this.quoteObj.BillingState = this.relatedAccount.BillingState; 
                this.quoteObj.BillingStreet = this.relatedAccount.BillingStreet;
                return null;
        }
        return null;
    }
    
     public PageReference setAddressFieldsForShipTo(){
        System.debug('******************************************Selected for Ship to:'+this.selectedPartnerOrAccountForShipTo);
        
        if (this.relatedPartners.keySet().contains(this.selectedPartnerOrAccountForShipTo)) {
                System.debug('selected is a partner');
                Partner selectedPartner = this.relatedPartners.get(this.selectedPartnerOrAccountForShipTo);
                this.quoteObj.ShippingCity = selectedPartner.AccountTo.ShippingCity ;
                this.quoteObj.ShippingCountry = selectedPartner.AccountTo.ShippingCountry;
                this.quoteObj.ShippingPostalCode = selectedPartner.AccountTo.ShippingPostalCode;
                this.quoteObj.ShippingState = selectedPartner.AccountTo.ShippingState; 
                this.quoteObj.ShippingStreet = selectedPartner.AccountTo.ShippingStreet;
                return null;
        } else if (this.selectedPartnerOrAccountForShipTo == this.relatedAccount.Id) {
                System.debug('selected is the related account');
                this.quoteObj.ShippingCity = this.relatedAccount.ShippingCity ;
                this.quoteObj.ShippingCountry = this.relatedAccount.ShippingCountry;
                this.quoteObj.ShippingPostalCode = this.relatedAccount.ShippingPostalCode;
                this.quoteObj.ShippingState = this.relatedAccount.ShippingState; 
                this.quoteObj.ShippingStreet = this.relatedAccount.ShippingStreet;
                return null;
        }
        return null;
    }
    
    /*
        For Cancel
    */
    public PageReference Cancel(){
                return new PageReference('/' + oppId);
    }
}