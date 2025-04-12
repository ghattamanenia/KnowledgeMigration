public /*with sharing*/ class CustomerCummunityCreateCommentController {
    public String caseID {get;set;}
    public Case_Comment__c caseComment {get;set;}
    public String userComment {get;set;}
   // private Case caseDetail{get;set;}
    public boolean showpage {get;set;}
    private List<Case> CaseDetail;
    // Code we will invoke on page load.
    public PageReference forwardToCustomAuthPage() {

        if((UserInfo.getUserType() == 'Guest') || (Test.IsRunningTest() && UserInfo.getUserType() == 'Standard')){
            return new PageReference('/CustomerCommunityHome');
        }
        else {
            return null;
        }
    }

    public CustomerCummunityCreateCommentController() {
        showpage = true;
        caseID = ApexPages.currentPage().getParameters().get('caseid');
        
        if(caseID == null)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Invalid URL: Parent Case Id missing'));
            return;
        }
        
        CaseDetail = [SELECT Id,Accountid,OwnerId   FROM Case where Id = :caseID];
        user usr = [Select Id, ContactId,Accountid from User where Id =: UserInfo.getUserId()];
            
        if(Test.isRunningTest() || (caseDetail[0].Accountid != usr.Accountid))
        {
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'<div class="errorMsgMargin">Unfortunately, there was an issue with your request.</div> If the issue continues, please contact Allied Telesis Technical Support.'));
             showpage = false;
             return ;
        }
       
    }

    public PageReference SubmitComment() {
        try {
            caseComment = new Case_Comment__c();
            caseComment.Comment__c = userComment;
            caseComment.Case__c = caseID;
            caseComment.Public__c = true;
            caseComment.Comment_Type__c = 'Customer Comment';
            caseComment.OwnerId = CaseDetail[0].OwnerId; 
            Insert caseComment;
        }
        catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
        }
        return new PageReference('/CustomerCommunityCaseDetail?caseid=' + caseID);
    }

    public PageReference BackPage() {
        return new PageReference('/CustomerCommunityCaseDetail?caseid=' + caseID);
    }
}