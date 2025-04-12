public without sharing class SFSupportCreateCommentController{
    public String caseID {get;set;}
   // public Case_Comment__c caseComment {get;set;}
   public Comment__c caseComment {get;set;}
    public String userComment {get;set;}
   // private Case caseDetail{get;set;}
    public boolean showpage {get;set;}
    private List<Case> CaseDetail;
    private string IsEhancement;
    

    public SFSupportCreateCommentController() {
        showpage = true;
        caseID = ApexPages.currentPage().getParameters().get('caseid');
        IsEhancement = ApexPages.currentPage().getParameters().get('Enhancement');
        if(caseID == null)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Invalid URL: Parent Case Id missing'));
            return;
        }
        
        CaseDetail = [SELECT Id,OwnerId   FROM Case where Id = :caseID];
        
    }

    public PageReference SubmitComment() {
        try {
           // caseComment = new Case_Comment__c();
           caseComment = new Comment__c();
            caseComment.Comment__c = userComment;
            caseComment.Related_Case__c = caseID;
            caseComment.Public__c = true;
            caseComment.Comment_Type__c = 'Customer Comment';
            caseComment.OwnerId = CaseDetail[0].OwnerId; 
            system.debug('caseComment ::' + caseComment);
            Insert caseComment;
              system.debug('caseComment inserted::' + caseComment);
        }
        catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
        }
        if(IsEhancement == 'true')
            return new PageReference('/apex/SFSupportEnhancementRequestDetail?id=' + caseID);
        else
            return new PageReference('/apex/SFSupportCaseDetail?id=' + caseID);
    }

    public PageReference CancelComment() {
         if(IsEhancement == 'true')
            return new PageReference('/apex/SFSupportEnhancementRequestDetail?id=' + caseID);
        else
            return new PageReference('/apex/SFSupportCaseDetail?id=' + caseID);
    }
}