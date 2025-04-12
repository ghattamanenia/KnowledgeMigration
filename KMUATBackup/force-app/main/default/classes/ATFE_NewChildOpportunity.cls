public with sharing class ATFE_NewChildOpportunity {
    
    private final Opportunity opp;
    
    public String AccountNameId { get; set; }
    public String OpportunityName { get; set; }
    public String MasterOpportunityID { get; set; }
    public Date CloseDate { get; set; }
    public String Stage { get; set; }
    public Decimal Probability { get; set; }
    public String ForecastCategoryName { get; set; }
    public String Components { get; set; }
    public String ApprovalHierarchy { get; set; }
    public String Fulfillment { get; set; }
    public String OwnerID { get; set; }
    public String ChildPriceBook { get; set; }
    public String ChildRecordType { get; set; }
    public String errorStyle { 
        get {
            errorStyle = '';
            return errorStyle;
        } 
        set; 
    }
    
    public ATFE_NewChildOpportunity(ApexPages.StandardController stdController) {
        try{
            system.debug('start try');
            this.opp = (Opportunity)stdController.getRecord();
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'e: ' + e));
        }
    }
    
    public PageReference save(){
        
        Opportunity mopp = [SELECT ATFE_Applications__c, ATFE_Solutions__c, ATFE_ApplicationsOther__c FROM Opportunity where id =:MasterOpportunityID];
        
        try{
        	opp.ATFE_Applications__c = mopp.ATFE_Applications__c;
        	opp.ATFE_Solutions__c = mopp.ATFE_Solutions__c;
        	opp.ATFE_ApplicationsOther__c = mopp.ATFE_ApplicationsOther__c;
            opp.OwnerId = OwnerID;
            opp.Pricebook2Id = ChildPriceBook;
            opp.ATFE_ChildOpportunityPricebook__c = ChildPriceBook;
            opp.AccountId = AccountNameId;
            opp.ATFE_RelatedOpportunity__c = MasterOpportunityID;
            opp.Name = OpportunityName;
            opp.CloseDate = CloseDate;
            opp.StageName = Stage;
            opp.Probability = Probability;
            opp.ForecastCategoryName = ForecastCategoryName;
            opp.ATFE_Components__c = Components;
            opp.ATFE_ApprovalHierarchy__c = ApprovalHierarchy;
            opp.ATFE_Fulfillment__c = Fulfillment;
            opp.RecordTypeId = ChildRecordType;
            
            insert opp;
            
            PageReference redirect2 = new PageReference('/apex/ATFE_SelectProduct?oppID=' + opp.id + '&pricebook=' + ChildPriceBook);
            redirect2.setRedirect(true);
            return redirect2;
        }
        catch (Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'e: ' + e));
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'your error'));
            errorStyle = 'border-size:2px; border-color:red;border-style:solid;';
            return null;
        }
    }

}