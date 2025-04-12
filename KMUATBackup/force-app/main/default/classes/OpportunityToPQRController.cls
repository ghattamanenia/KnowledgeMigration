public with sharing class OpportunityToPQRController {
	
	public Opportunity opp {get; set;}
	public List<Partner> paList {get; set;}
	public List<OpportunityTeamMember> otmList {get; set;}
	public List<OpportunityLineItem> oliList {get; set;}
	
    public OpportunityToPQRController(ApexPages.StandardController stdController) {
    	Id recId = stdController.getRecord().Id;
    	this.opp = OpportunityDAO.getRecById(recId);
    	
    	//this.paList = PartnerDAO.getRecByOppId(this.opp.Id, this.opp.accountId);
    	this.otmList = OpportunityTeamMemberDAO.getRecByOppId(this.opp.Id);
    	this.oliList = OpportunityLineItemDAO.getOppLineItem(this.opp.Id);
    }
}