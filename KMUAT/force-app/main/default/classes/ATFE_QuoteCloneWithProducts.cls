//This class handles requests to clone a product with quotes, or without quotes
public without sharing class ATFE_QuoteCloneWithProducts {
    Id quoteId ; 
    public Quote quoteObj {get;set;}
    public Opportunity opp {get;set;}
    public Account relatedAccount {get;set;}
    public String selectedPartnerOrAccountForQuoteTo {get;set;}
    public String selectedPartnerOrAccountForBillTo {get;set;}
    public String selectedPartnerOrAccountForShipTo {get;set;}
    public Map<Id, Partner> relatedPartners {get;set;}
    public static boolean byPassQuoteTrigger = false ;
    private boolean cloneProducts = true; //APM
    public String cloneQuoteTitle {get; set;} //APM
    
    public ATFE_QuoteCloneWithProducts(ApexPages.StandardController std){
        //APM -- Start
        String cloneProdParam = ApexPages.currentPage().getParameters().get('cloneProducts');
        
        if (cloneProdParam == 'false') {
            this.cloneProducts = false;
        }
        if (this.cloneProducts == false) {
            this.cloneQuoteTitle = 'Clone Quote';
        } else {
            this.cloneQuoteTitle = 'Clone Quote with Products'; 
        }//APM -- End
        
        quoteId = std.getId();
        String fieldNames = '';   
        String query;
           
        fieldNames = ATFE_SchemaDetailsHelper.getFieldDetails('Quote');
        query = 'select '+fieldNames+' from Quote where Id=\''+quoteId+'\'';    
        System.debug('Quote Query :'+query);    
        quoteObj = DataBase.query(query);   
        
        this.opp = [SELECT Name, AccountId, Account.Name FROM Opportunity WHERE Id = :quoteObj.OpportunityId];
        this.relatedAccount = [SELECT Id, Name, ShippingStreet, ShippingState, ShippingPostalCode, ShippingCountry, ShippingCity,
                                                                  BillingCountry, BillingPostalCode, BillingState, BillingCity, BillingStreet
                                                           FROM Account WHERE id = :this.opp.AccountId];
         this.relatedPartners = new Map<Id, Partner>();
         for (Partner partner : [SELECT OpportunityId, AccountToId, AccountTo.Name, AccountTo.ShippingStreet, AccountTo.ShippingCity,AccountTo.BillingCity,AccountTo.BillingCountry,AccountTo.BillingPostalCode,
                                        AccountTo.BillingStreet,AccountTo.BillingState, 
                                        AccountTo.ShippingState, AccountTo.ShippingPostalCode, AccountTo.ShippingCountry 
                                        FROM Partner WHERE OpportunityId = :this.opp.Id]) {
            this.relatedPartners.put(partner.AccountToId, partner);                                                         
        }
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
    
    public PageReference SaveQuote(){
        Savepoint sp = Database.setSavepoint();
        Id quoteBeforeApprovalRTid = getQuoteBeforeApprovalRTid();
        Quote cloneQuote = quoteObj.clone(false);
        cloneQuote.ATFE_ApprovalDate__c  = null ;
        cloneQuote.ExpirationDate  = null ;
        cloneQuote.ATFESPQ_Approved__c = false ;
        cloneQuote.ATFE_Approval_Status__c = '';
        cloneQuote.RecordTypeId = quoteBeforeApprovalRTid;
        
        String fieldNames = '';
        String query;
         List<QuoteLineItem> qliToclone = new List<QuoteLineItem>();
        try {
            ATFE_QuoteCloneWithProducts.byPassQuoteTrigger = true ;
            insert cloneQuote;
            /*
                Clone Products
            */
            
            if (this.cloneProducts) { //APM
                System.debug('cloning products');
                fieldNames = ATFE_SchemaDetailsHelper.getFieldDetails('QuoteLineItem');
                query = 'select '+fieldNames+' from QuoteLineItem where quoteId=\''+quoteId+'\'';
                for(QuoteLineItem qli :  DataBase.query(query)){
                    QuoteLineItem cloneQli = qli.clone(false);
                    cloneQli.QuoteId = cloneQuote.id ;
                    cloneQli.PriceBook_Price_Amount__c = 0 ;
                    qliToclone.add(cloneQli);
                }
                insert qliToclone ;
            }
         }catch(Exception e){
            System.debug('Exception Occured while cloning quote :'+e.getMessage());
            Database.rollback(sp);
         }
         return new PageReference('/'+cloneQuote.id);
    }
    
    /*
        For Getting Quote Details
    */
    public PageReference setAddressFieldsForQuoteTo(){
        System.debug('******************************************:'+this.selectedPartnerOrAccountForQuoteTo);
        //Account acc = [Select ShippingStreet, ShippingState, ShippingPostalCode, ShippingCountry, ShippingCity From Account where id = :selectedPartner];
        
        if (this.relatedPartners.keySet().contains(this.selectedPartnerOrAccountForQuoteTo)) {
                System.debug('selected is a partner');
                Partner selectedPartner = this.relatedPartners.get(this.selectedPartnerOrAccountForQuoteTo);
                this.quoteObj.QuoteToCity = selectedPartner.AccountTo.ShippingCity ;
                this.quoteObj.QuoteToCountry = selectedPartner.AccountTo.ShippingCountry;
                this.quoteObj.QuoteToPostalCode = selectedPartner.AccountTo.ShippingPostalCode;
                this.quoteObj.QuoteToState = selectedPartner.AccountTo.ShippingState; 
                this.quoteObj.QuoteToStreet = selectedPartner.AccountTo.ShippingStreet;
                return null;
        } else if (this.selectedPartnerOrAccountForQuoteTo == this.relatedAccount.Id) {
                System.debug('selected is the related account');
                this.quoteObj.QuoteToCity = this.relatedAccount.ShippingCity ;
                this.quoteObj.QuoteToCountry = this.relatedAccount.ShippingCountry;
                this.quoteObj.QuoteToPostalCode = this.relatedAccount.ShippingPostalCode;
                this.quoteObj.QuoteToState = this.relatedAccount.ShippingState; 
                this.quoteObj.QuoteToStreet = this.relatedAccount.ShippingStreet;
                return null;
        }
        return null;
    }
    
    public PageReference setAddressFieldsForBillTo(){
        System.debug('******************************************Selected for Bill to:'+this.selectedPartnerOrAccountForBillTo);
        //Account acc = [Select ShippingStreet, ShippingState, ShippingPostalCode, ShippingCountry, ShippingCity From Account where id = :selectedPartner];
        
        if (this.relatedPartners.keySet().contains(this.selectedPartnerOrAccountForBillTo)) {
                System.debug('selected is a partner');
                Partner selectedPartner = this.relatedPartners.get(this.selectedPartnerOrAccountForBillTo);
                        this.quoteObj.BillingCity = selectedPartner.AccountTo.ShippingCity ;
                this.quoteObj.BillingCountry = selectedPartner.AccountTo.ShippingCountry;
                this.quoteObj.BillingPostalCode = selectedPartner.AccountTo.ShippingPostalCode;
                this.quoteObj.BillingState = selectedPartner.AccountTo.ShippingState; 
                this.quoteObj.BillingStreet = selectedPartner.AccountTo.ShippingStreet;
                return null;
        } else if (this.selectedPartnerOrAccountForBillTo == this.relatedAccount.Id) {
                System.debug('selected is the related account');
                this.quoteObj.BillingCity = this.relatedAccount.ShippingCity ;
                this.quoteObj.BillingCountry = this.relatedAccount.ShippingCountry;
                this.quoteObj.BillingPostalCode = this.relatedAccount.ShippingPostalCode;
                this.quoteObj.BillingState = this.relatedAccount.ShippingState; 
                this.quoteObj.BillingStreet = this.relatedAccount.ShippingStreet;
                return null;
        }
        return null;
    }
    
    public PageReference setAddressFieldsForShipTo(){
        System.debug('******************************************Selected for Ship to:'+this.selectedPartnerOrAccountForShipTo);
        //Account acc = [Select ShippingStreet, ShippingState, ShippingPostalCode, ShippingCountry, ShippingCity From Account where id = :selectedPartner];
        
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
    
    public static Id getQuoteBeforeApprovalRTid() {
        Schema.DescribeSObjectResult quoteDescribe = Schema.SObjectType.Quote; 
        Map<String, Schema.RecordTypeInfo> quoteRtMapByName = quoteDescribe.getRecordTypeInfosByName();
        Id beforeApprovalId = quoteRtMapByName.get('ATFE_Quote After Approval').getRecordTypeId();
        
        return beforeApprovalId;
    }
    
    /*
        For Cancel
    */
    public PageReference Cancel(){
        
        return new PageReference('/'+quoteId);
    }
}