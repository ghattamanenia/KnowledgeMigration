public with sharing class ATFE_CloneWithProducts {

    private Opportunity opp {get;set;}

    public ATFE_CloneWithProducts(ApexPages.StandardController stdController) {
        try{
            opp = (Opportunity)stdController.getRecord();
        }
        catch(Exception e){
            system.debug('exception found: ' + e);  
        }
    }

	// - Query for the Opportunity Products
	// - Deep clone each one and store it in a list of Opportunity Products
	// - insert your cloned Opportunity
	// - update the deep cloned Opportunity Products with the new cloned Opportunity Id
	// - insert your cloned Opportunity Products

    public PageReference CloneWithItems() {
        // setup the save point for rollback
        Savepoint sp = Database.setSavepoint();
        
        try {
            opp = [SELECT ATFE_OpportunityDuration__c, ATFE_3rdParty__c, AccountId, Amount, ATFE_Application__c, ATFE_ApprovalDate__c, ATFE_ApprovalHierarchy__c, EMEA_ApprovalNote__c, NA_ApprovalNote__c, 
                ATFE_ApprovalRequiredDate__c, ATFE_ApprovalStatus__c, ATFE_ApprovalStatusHidden__c, ATFE_ApprovalUpdateInfo__c, NA_ApprovalRequired__c, EMEA_ApprovalRequired__c, ATFE_Level1__c, 
                ATFE_Level2__c, ATFE_Level3__c, ATFE_Level4__c, ATFE_Level5__c, ATFE_ApprovedByNSPLevel6__c, ATFE_Budget__c, CampaignId, ATFE_DateStageAge__c, ATFE_ChildOpportunityPricebook__c, 
                ATFE_ChildTotalAmount__c, CloseDate, IsClosed, ATFE_CompetitorsInvolvedInProject__c, ATFE_Components__c, ATFE_ConvertedCreatedDate__c, CreatedById, CreatedDate, ATFE_DecisionCriteria__c, 
                IsDeleted, ATFE_DeliveryCondition__c, Description, ATFE_Discount__c, ATFE_EnterpriseProject__c, ATFE_ExportComplianceCheck__c, ATFE_FirstMeetingDate__c, Fiscal, FiscalQuarter, 
                FiscalYear, ForecastCategory, ForecastCategoryName, ATFE_ForecastChangeDate__c, ATFE_FrameContract__c, ATFE_Fulfillment__c, ATFE_FundingType__c, HasOpportunityLineItem, ATFE_InternalApprovalComments__c, 
                LastActivityDate, LastModifiedById, LastModifiedDate, LeadSource, ATFE_MFGProID__c, ATFE_Margin__c, ATFE_MasterOpportunity__c, ATFE_MeetingNotes__c, ATFE_NSPProject__c, Name, NextStep, ATFE_OppIDName__c, 
                ATFE_OppID__c, ATFE_OpportunityAge__c, CurrencyIsoCode, Id, Type, ATFE_OurBenefits__c, ATFE_OurStrategy__c, ATFE_OurStrategyDescription__c, ATFE_OurUSPs__c, ATFE_OurValueProposition__c, OwnerId, 
                ATFE_PPASentToDistributor__c, ATFE_PartnerReseller__c, ATFE_PartnerResellerCity__c, ATFE_PartnerResellerCountry__c, ATFE_PartnerResellerName__c, ATFE_PartnerResellerPhone__c, ATFE_PartnerResellerPostalCode__c, 
                ATFE_PartnerResellerStreet__c, ATFE_PaymentTerm__c, Pricebook2Id, Probability, ATFE_ProjectDescription__c, ATFE_Promotion__c, ATFE_QuoteDate__c, ATFE_QuoteValidThrough__c, 
                RecordTypeId, ATFE_RelatedOpportunity__c, ATFE_SFID__c, ATFE_SPQApprovalStatusMergeField__c, ATFE_SPQApproved__c, ATFE_SPQExpirationDate__c, 
                ATFE_ServiceProject__c, StageName, ATFE_StageAlertDate__c, SystemModstamp, ATFE_TimeTillBookingPurchase__c, ATFE_TimelineToImplement__c, ATFE_TotalCOGS__c, ATFE_TotalListPrice__c, 
                ATFE_WhereIsTheProjectInTheCycle__c, ATFE_WhereIsTheProjectInTheCycleOther__c, IsWon FROM Opportunity where id =:opp.id];
            
            Date newclosedate = opp.CloseDate.addMonths(1);
            
            Opportunity newopp = opp.clone(false, true);
            newopp.Name = 'CLONED OPP - PLEASE RENAME ME';
            newopp.StageName = 'Prospect/Qualification';
            newopp.ForecastCategoryName = 'Pipeline';
            newopp.Probability = 25;
            newopp.CloseDate = newclosedate;    
            
            insert newopp;
            
            OpportunityLineItem[] oldPLI = [SELECT ATFE_Cost__c , ATFE_COGS__c, ATFE_COGSTotal__c, ATFE_COGSAmount__c, CreatedById, CreatedDate, CurrencyIsoCode, IsDeleted, ATFE_DiscountInPercent__c, LastModifiedById, 
                LastModifiedDate, Description, Id, ATFE_LineItemId__c, ListPrice, ATFE_ListPriceAmount__c, ATFE_Margin__c, OpportunityId, PricebookEntryId, ATFE_ProductNameForLinks__c, Quantity, UnitPrice, SortOrder, 
                ATFE_Status__c From OpportunityLineItem where OpportunityId = :opp.Id]; //TotalPrice
            OpportunityLineItem[] newPLI = oldPLI.deepClone(false);
            
            for (OpportunityLineItem x : newPLI)
            {
               x.OpportunityId = newopp.Id;
            }
            
            insert newPLI;
            
            PageReference redirect2 = new PageReference('/' + newopp.id);
            redirect2.setRedirect(true);
            return redirect2;
        }
        catch (Exception e){
             // roll everything back in case of error
            Database.rollback(sp);
            system.debug('exception found in NA_CloneWithProducts: ' + e);  
            return null;                
        }
    
    }
    
    public PageReference CloneWithoutItems() {
        // setup the save point for rollback
        Savepoint sp = Database.setSavepoint();
        
        try {       
            opp = [SELECT ATFE_OpportunityDuration__c, ATFE_3rdParty__c, AccountId, Amount, ATFE_Application__c, ATFE_ApprovalDate__c, ATFE_ApprovalHierarchy__c, EMEA_ApprovalNote__c, NA_ApprovalNote__c, 
                ATFE_ApprovalRequiredDate__c, ATFE_ApprovalStatus__c, ATFE_ApprovalStatusHidden__c, ATFE_ApprovalUpdateInfo__c, NA_ApprovalRequired__c, EMEA_ApprovalRequired__c, ATFE_Level1__c, 
                ATFE_Level2__c, ATFE_Level3__c, ATFE_Level4__c, ATFE_Level5__c, ATFE_ApprovedByNSPLevel6__c, ATFE_Budget__c, CampaignId, ATFE_DateStageAge__c, ATFE_ChildOpportunityPricebook__c, 
                ATFE_ChildTotalAmount__c, CloseDate, IsClosed, ATFE_CompetitorsInvolvedInProject__c, ATFE_Components__c, ATFE_ConvertedCreatedDate__c, CreatedById, CreatedDate, ATFE_DecisionCriteria__c, 
                IsDeleted, ATFE_DeliveryCondition__c, Description, ATFE_Discount__c, ATFE_EnterpriseProject__c, ATFE_ExportComplianceCheck__c, ATFE_FirstMeetingDate__c, Fiscal, FiscalQuarter, 
                FiscalYear, ForecastCategory, ForecastCategoryName, ATFE_ForecastChangeDate__c, ATFE_FrameContract__c, ATFE_Fulfillment__c, ATFE_FundingType__c, HasOpportunityLineItem, ATFE_InternalApprovalComments__c, 
                LastActivityDate, LastModifiedById, LastModifiedDate, LeadSource, ATFE_MFGProID__c, ATFE_Margin__c, ATFE_MasterOpportunity__c, ATFE_MeetingNotes__c, ATFE_NSPProject__c, Name, NextStep, ATFE_OppIDName__c, 
                ATFE_OppID__c, ATFE_OpportunityAge__c, CurrencyIsoCode, Id, Type, ATFE_OurBenefits__c, ATFE_OurStrategy__c, ATFE_OurStrategyDescription__c, ATFE_OurUSPs__c, ATFE_OurValueProposition__c, OwnerId, 
                ATFE_PPASentToDistributor__c, ATFE_PartnerReseller__c, ATFE_PartnerResellerCity__c, ATFE_PartnerResellerCountry__c, ATFE_PartnerResellerName__c, ATFE_PartnerResellerPhone__c, ATFE_PartnerResellerPostalCode__c, 
                ATFE_PartnerResellerStreet__c, ATFE_PaymentTerm__c, Pricebook2Id, Probability, ATFE_ProjectDescription__c, ATFE_Promotion__c, ATFE_QuoteDate__c, ATFE_QuoteValidThrough__c, 
                RecordTypeId, ATFE_RelatedOpportunity__c, ATFE_SFID__c, ATFE_SPQApprovalStatusMergeField__c, ATFE_SPQApproved__c, ATFE_SPQExpirationDate__c, 
                ATFE_ServiceProject__c, StageName, ATFE_StageAlertDate__c, SystemModstamp, ATFE_TimeTillBookingPurchase__c, ATFE_TimelineToImplement__c, ATFE_TotalCOGS__c, ATFE_TotalListPrice__c, 
                ATFE_WhereIsTheProjectInTheCycle__c, ATFE_WhereIsTheProjectInTheCycleOther__c, IsWon FROM Opportunity where id =:opp.id];
            
            Date newclosedate = opp.CloseDate.addMonths(1);
            
            Opportunity newopp = opp.clone(false, true);
            newopp.Name = 'CLONED OPP - PLEASE RENAME ME';
            newopp.StageName = 'Prospect/Qualification';
            newopp.ForecastCategoryName = 'Pipeline';
            newopp.Amount = 0;
            newopp.Probability = 25;
            newopp.CloseDate = newclosedate;    
            
            insert newopp;

            PageReference redirect2 = new PageReference('/' + newopp.id);
            redirect2.setRedirect(true);
            return redirect2;
        }
        catch (Exception e){
             // roll everything back in case of error
            Database.rollback(sp);
            system.debug('exception found in NA_CloneWithProducts: ' + e);  
            return null;                
        }
    }

}