public without sharing class SFSupportAddAttachmentController {
    public boolean showpage {get;set;}
    public String caseID {get;set;}
    public case CaseDetail{get;set;}
    public Comment__c caseComment{get;set;}
    private string IsEhancement;
   
    public Attachment attachment{
        get {
            if (attachment == null)
                attachment = new Attachment();
            return attachment;
        }
        set;
    }

    public PageReference BackPage() {
    
        if(IsEhancement == 'true')
            return new PageReference('/apex/SFSupportEnhancementRequestDetail?id=' + caseID);
        else
            return new PageReference('/apex/SFSupportCaseDetail?id=' + caseID);
        
    }
 
    public PageReference upload() {
        //document.AuthorId = UserInfo.getUserId();
        //document.FolderId = UserInfo.getUserId(); // put it in running user's folder
        if(caseDetail.Related_CMT_Project__c != null )
            attachment.ParentId = caseDetail.Related_CMT_Project__c;
        else
            attachment.ParentId = caseId;

        try 
        {
            //insert document;
            insert attachment;
            caseComment = new Comment__c();
            caseComment.Comment__c = 'A new file named "' +attachment.Name+ '" has been attached to the case.';
            caseComment.Related_Case__c = caseId;
            caseComment.Public__c = true;
            caseComment.Comment_Type__c = 'Customer Comment';
            caseComment.OwnerId = CaseDetail.OwnerId; 
            try 
            {
                insert caseComment;
            }
            catch (DMLException e) 
            {
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
        return null;
        
         
    }

    public SFSupportAddAttachmentController () {
        
            showpage = true;
            caseID = ApexPages.currentPage().getParameters().get('caseid');
            IsEhancement = ApexPages.currentPage().getParameters().get('Enhancement');
            caseDetail = [SELECT Id,caseNumber, OwnerId,Related_CMT_Project__c  FROM Case where id = :caseID];
            
       
    }

   
}