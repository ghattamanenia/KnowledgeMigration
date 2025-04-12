public without sharing class SFSupportCaseDetailController 
{
    public Boolean showDescription {get;set;} 
    public Boolean showStepsToRepro {get;set;} 
    public Boolean showRequestor { get; set; }
    public Boolean showBusinessReq { get; set; }
    public Boolean showTypeOfData {get;set;} 
    public Boolean showTargetDate {get;set;} 
    public Boolean showAdditionalComments {get;set;} 
    public Boolean showLeaver {get;set;} 
    public Boolean showTerminateDate {get;set;} 
    public Boolean showAuthEmail {get;set;} 
    public Boolean showCloseBtn {get;set;}
    public Boolean showComments {get;set;}
    public Boolean showAttachments {get;set;}
    public Boolean showDataTypeComments {get;set;}
    public Boolean showProjectList {get;set;}
    public Boolean showDotReleaseList {get;set;}
    
    public Boolean showProjectStatus {get;set;}
    public Boolean showcaseStatus {get;set;} 
    
    public List<string> ExtStatus {get;set;}
    public List<string> IntStatus {get;set;}
    
    public string PrjStatus{get;set;}
    
    public Case SFSupport_Case {get;set;}
    public Milestone1_Project__c relatedProject {get;set;}
    public List<Comment__c> caseComments {get;set;}
    
     public List<Attachment> AttachmentList {get;set;}
    //public List<Question_Answer__kav> relatedArticles {get;set;}
    public PageReference editPage;
    private String category {get;set;} 

    //private ApexPages.StandardController standardCaseController;
    public SFSupportCaseDetailController() 
    {
    
        showProjectStatus = false;
        showcaseStatus = true;
        
        ExtStatus = new List<string>();
        IntStatus = new List<string>();
        //(index 0)   
        IntStatus.add('Analysis');
        ExtStatus.add('Analysis');
        //(index 1)
        IntStatus.add('TRB Review');
        ExtStatus.add('Submitted for approval');
        //(index 2)
        IntStatus.add('Global IT Review');
        ExtStatus.add('Submitted for approval');
        //(index 3)
        IntStatus.add('Approved-Pending Schedule');
        ExtStatus.add('Approved-Pending Schedule');
        //(index 4)
        IntStatus.add('Scheduled');
        ExtStatus.add('Scheduled');
        //(index 5)
        IntStatus.add('Requirements/Supporting Docs');
        ExtStatus.add('In Process');
        //(index 6)
        IntStatus.add('Design');
        ExtStatus.add('In Process');
        //(index 7)
        IntStatus.add('Build');
        ExtStatus.add('In Process');
        //(index 8)
        IntStatus.add('Internal Test');
        ExtStatus.add('In Process');
        //(index 9)
        IntStatus.add('Peer Review');
        ExtStatus.add('In Process');
        //(index 10)
        IntStatus.add('UAT');
        ExtStatus.add('UAT');
        //(index 11)
        IntStatus.add('Deployment');
        ExtStatus.add('Deployment');
        //(index 12)
        IntStatus.add('Completed');
        ExtStatus.add('Completed');
        //(index 13)
        IntStatus.add('Pending');
        ExtStatus.add('In Process');
        //(index 14)
        IntStatus.add('Deferred');
        ExtStatus.add('Deferred');
        //(index 15)
        IntStatus.add('Dependency');
        ExtStatus.add('In Process');
        //(index 16)
        IntStatus.add('Cancelled');
        ExtStatus.add('Cancelled');
        
        Id id = ApexPages.currentPage().getParameters().get('id');
        SFSupport_Case = [SELECT Id,CaseNumber, ATFE_Status_Comments__c,Request_Title__c, Description, RecordTypeid, User_Termination_Date__c,
                        CreatedDate, ClosedDate, Status, Resolution_Code__c, CaseResolution__c, BusinessProcessesEffected__c,
                        SF_Case_Category__c,Requestor_Name__c, Additional_Comments__c, LastModifiedBy.Name,createdby.Name, 
                        What_are_the_steps_to_reproduce_it__c, Data_Upload_Type__c, Data_Type_Comments__c,
                        Leaver_Name__c, Authorizing_Email__c, Upload_Active_Date__c, Business_requirement_for_access__c,
                        Related_CMT_Project__c, Rel_CMT_Parent_Dot_Release__c
                        FROM Case WHERE Id =: id];
                        
        if(SFSupport_Case.Related_CMT_Project__c != null) {
            relatedProject = [SELECT Id, Name, Status__c,Status_Comments__c ,Deadline__c ,Parent_Project__c,Parent_Project__r.Name From Milestone1_Project__c WHERE Related_Case__r.Id =: id];
            showProjectStatus = true;
            showcaseStatus = false;
            if(relatedProject.Parent_Project__c != null)  {
                showProjectList = false;      
                showDotReleaseList = true;   
            }  
            else {
                showProjectList = true;      
                showDotReleaseList = false;               
            }  
            
            for(integer i=0;i<IntStatus.size();i++){
                if(relatedProject.Status__c == IntStatus[i]){
                    PrjStatus = ExtStatus[i];
                    break;
                }
            
            }       
        }
        else {
            showProjectList = false;      
            showDotReleaseList = false;        
        }
                        
        /*
        if(relatedProject != null) {
            if(relatedProject.Id == null) {
            
            }  
            else if(relatedProject.Parent_Project__c != null)  {
                showProjectList = false;      
                showDotReleaseList = true;   
            }  
            else {
                showProjectList = true;      
                showDotReleaseList = false;               
            }  
        }
        */
         
        // ID rID = [SELECT ID FROM RecordTYpe WHERE SobjectType = 'Case' AND DeveloperName = 'SF_Case'].ID;
        // SF_IssueCase.RecordTypeid = rID; 
       
        category = SFSupport_Case.SF_Case_Category__c;

        if(category == 'Issue') {
            showDescription = showStepsToRepro = true;
            showRequestor = showBusinessReq = showTypeOfData = showDataTypeComments = showTargetDate = showAdditionalComments = showLeaver = showAuthEmail = showTerminateDate = false;
        } 
        else if(category == 'Information') {
            showDescription = true;
            showStepsToRepro = showRequestor = showBusinessReq = showTypeOfData = showDataTypeComments = showTargetDate = showAdditionalComments = showLeaver = showAuthEmail = showTerminateDate = false;
        }
        else if(category == 'Access') {
            showDescription = showBusinessReq = showRequestor = true;
            showStepsToRepro = showTypeOfData = showDataTypeComments = showTargetDate = showAdditionalComments = showLeaver = showAuthEmail = showTerminateDate = false;          
        }
        else if(category == 'User Account') {
            showLeaver = showAuthEmail = showRequestor = showTerminateDate = true; 
            showDescription = showStepsToRepro = showBusinessReq = showTypeOfData = showDataTypeComments = showTargetDate = showAdditionalComments = showAuthEmail = false;
        }
        else if(category == 'Data') {
            showTypeOfData = showDataTypeComments = showTargetDate = showRequestor = true;
            showDescription = showStepsToRepro = showAdditionalComments = showBusinessReq = showLeaver = showAuthEmail = showTerminateDate = false;
        }
        else if(category == 'Other') {
            showDescription = showRequestor = true;
            showStepsToRepro = showBusinessReq = showTypeOfData = showDataTypeComments = showTargetDate = showAdditionalComments = showLeaver = showAuthEmail = showTerminateDate = false; 
        }

        if(SFSupport_Case.Requestor_Name__c == null) {
            showRequestor = false;
        }

        if(SFSupport_Case.Status != 'Closed' && showcaseStatus == true) {
            showCloseBtn = true;
        }
        else {
            showCloseBtn = false;            
        }      


        Set<ID> knowledgeArticleIds = new Set<ID>();
        List<CaseArticle> caseArticles = [SELECT Id, CaseId, KnowledgeArticleId FROM CaseArticle WHERE CaseId =:SFSupport_Case.id];
        
        for(CaseArticle CA : caseArticles)
        {
            knowledgeArticleIds.add(CA.KnowledgeArticleId);
        }
        
        //relatedArticles = [SELECT Id, KnowledgeArticleId, Title, UrlName, Summary, ArticleNumber, 
        //                    Question__c, Answers__c FROM Question_Answer__kav WHERE PublishStatus='Online' AND KnowledgeArticleId IN :knowledgeArticleIds];
        
         caseComments = [SELECT Id, Case_Contact_Email__c, CreatedBy.Name, Case_Ref__c, Related_Case__c, Comment_Type__c, Comment__c, 
                            CreatedById, CreatedDate, IsDeleted, LastModifiedById, LastModifiedDate, 
                            Name, OwnerId, Related_Email__c
                            FROM Comment__c WHERE Related_Case__c= :SFSupport_Case.id and Public__c = true order by CreatedDate desc];
       
         if(SFSupport_Case.Related_CMT_Project__c != null) {
            AttachmentList = [SELECT BodyLength, ContentType, CreatedById, CreatedBy.Name, CreatedDate, Description, Id,
                                IsDeleted, IsPrivate, LastModifiedById, LastModifiedDate, Name, OwnerId, ParentId
                                FROM Attachment WHERE ParentId = :SFSupport_Case.Related_CMT_Project__c and IsDeleted = false ];
         }else{
            AttachmentList = [SELECT BodyLength, ContentType, CreatedById, CreatedBy.Name, CreatedDate, Description, Id,
                             IsDeleted, IsPrivate, LastModifiedById, LastModifiedDate, Name, OwnerId, ParentId
                             FROM Attachment WHERE ParentId = :SFSupport_Case.id and IsDeleted = false ];
         
         }
                          

        if(caseComments.size() > 0) {
            showComments = true;
        }
        else {
            showComments = false;
        }

        if(AttachmentList.size() > 0) {
            showAttachments = true;
        }
        else {
            showAttachments = false;
        }
    }

    public PageReference EditCase() 
    {
        //  upsert SF_IssueCase; 
        //return (new ApexPages.StandardController(SF_IssueCase)).view();
        if(SFSupport_Case.SF_Case_Category__c == 'Enhancement') {
            editPage = new PageReference('/apex/SFSupportRequest?id=' + SFSupport_Case.Id);
            editPage.getParameters().put('type', 'Enhancement');
        }
        else {
            editPage = new PageReference('/apex/SFSupportCreateCase?id=' + SFSupport_Case.Id);
            editPage.getParameters().put('type', SFSupport_Case.SF_Case_Category__c); 
        }
        return editPage;
    }
    
     public PageReference CloseCase() 
    {
        if(SFSupport_Case.Status != 'Closed')
        {
            SFSupport_Case.Status = 'Closed';
            SFSupport_Case.caseResolution__c = 'This case has been closed by ' + UserInfo.getName();
            SFSupport_Case.Resolution_Code__c = 'Closed by Submitter';
            
            try 
            {
                update SFSupport_Case;
                
                SFSupport_Case = [SELECT Id,CaseNumber, ATFE_Status_Comments__c,Request_Title__c, Description, RecordTypeid, CreatedDate, ClosedDate, Status,
                                Resolution_Code__c, CaseResolution__c, SF_Case_Category__c,Additional_Comments__c, 
                                LastModifiedBy.Name, createdby.Name, What_are_the_steps_to_reproduce_it__c, Business_requirement_for_access__c, 
                                Requestor_Name__c, Data_Upload_Type__c, Data_Type_Comments__c, Leaver_Name__c, Authorizing_Email__c,
                                Related_CMT_Project__c, Rel_CMT_Parent_Dot_Release__c,
                                Upload_Active_Date__c FROM Case WHERE Id = :SFSupport_Case.id];

                showCloseBtn = false;
                
                return new PageReference('/apex/SFSupportCaseDetail?id='+ SFSupport_Case.id);
            }
            catch (DMLException e) 
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error Closing Case. ' + e.getMessage()));
                return new PageReference('/apex/SFSupportCaseDetail?id='+ SFSupport_Case.id);
            } 
        }
        else
        {
            return new PageReference('/apex/SFSupportCaseDetail?id='+ SFSupport_Case.id);
        }
    }
    
    public PageReference CreateComment() 
    {
       
        return new PageReference('/apex/SFSupportCreateComment?caseid=' + SFSupport_Case.Id);
    }
    
    public PageReference AddAttachment() 
    {
       
        return new PageReference('/apex/SFSupportAddAttachment?caseid=' + SFSupport_Case.Id);
    }
    

    public PageReference Back() 
    {
        //upsert SF_IssueCase; 
        //return (new ApexPages.StandardController(SF_IssueCase)).view();
        return new PageReference('/apex/SFSupportHome');
    }
 
}