public /*with sharing*/ class CustomerCommunityAddAttachmentController {
    public boolean showpage {get;set;}
    public String caseID {get;set;}
    public case CaseDetail{get;set;}
    public Case_Comment__c caseComment{get;set;}
   
    public Attachment attachment{
        get {
            if (attachment == null)
                attachment = new Attachment();
            return attachment;
        }
        set;
    }

/*
    public Document document {
        get {
            if (document == null)
                document = new Document();
            return document;
        }
        set;
    }
*/

    public PageReference BackPage() {
        return new PageReference('/CustomerCommunityCaseDetail?caseId=' + caseId);
    }
 
    public PageReference upload() {
        //document.AuthorId = UserInfo.getUserId();
        //document.FolderId = UserInfo.getUserId(); // put it in running user's folder
        attachment.ParentId = caseId;

        try {
            //insert document;
            insert attachment;
            caseComment = new Case_Comment__c();
            caseComment.Comment__c = 'A new file named "' +attachment.Name+ '" has been attached to the case.';
            caseComment.Case__c = caseId;
            caseComment.Public__c = true;
            caseComment.Comment_Type__c = 'Customer Comment';
            caseComment.OwnerId = CaseDetail.OwnerId; 
            try {
                insert caseComment;
            }
            catch (DMLException e) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error adding comment for this attachment. ' + e.getMessage()));
            return null;
        } 
        } 
        catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file. ' + + e.getMessage()));
            return null;
        } 
        finally {
            attachment.body = null; //-- clears the viewstate
            attachment = new Attachment();
        }

        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File uploaded successfully'));
        //return new PageReference('/CustomerCommunityCaseDetail?caseId=' + caseId);
        return null;
    }

    public CustomerCommunityAddAttachmentController() {
        try {
            showpage = true;
            caseID = ApexPages.currentPage().getParameters().get('caseId');
        }
        catch(Exception ex) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'<div class="errorMsgMargin">Unfortunately, there was an issue with your request.</div> If the issue continues, please contact Allied Telesis Technical Support.'));
            showpage = false;
            return;
        }
    }
    
     public void loadMessages() {
        caseDetail = [SELECT Id,caseNumber, Accountid,OwnerId  FROM Case where id = :caseID];
        User usr = [Select Id, ContactId,Accountid from User where Id =: UserInfo.getUserId()];
        
        if(caseDetail.Accountid != usr.Accountid)
        {
            ApexPages.Message errorMsg = new ApexPages.message(ApexPages.severity.ERROR,'<div class="errorMsgMargin">Unfortunately, there was an issue with your request.</div> If the issue continues, please contact Allied Telesis Technical Support.');
            ApexPages.addMessage(errorMsg); 

            showpage = false;
            return;
        }    
     }
}