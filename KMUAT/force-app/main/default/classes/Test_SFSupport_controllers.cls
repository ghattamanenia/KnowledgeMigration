@isTest
private class Test_SFSupport_controllers {

private  static Id  SFSupport_CaseID;
private  static Id  SFSupportEnhanc_CaseID;
private  static Id  SFSupportData_CaseID;
private  static Id  SFSupportAccess_CaseID;
private  static Id  Dot_Release_ParentID;
private  static Id  Dot_Release_ChildID;
private  static Id  EnhancementprjctID;




   static {      
     
        List<RecordType> AllCaseRT = [SELECT Id, DeveloperName  FROM RecordType where Sobjecttype = 'Case'];
        
        for(RecordType CaseRT : AllCaseRT )
        {
            if(CaseRT.DeveloperName == 'SF_Case')
                SFSupport_CaseID = CaseRT.ID;
            if(CaseRT.DeveloperName == 'SF_Case_Enhancement')
                SFSupportEnhanc_CaseID = CaseRT.ID;
            if(CaseRT.DeveloperName == 'SF_Case_Data')
                SFSupportData_CaseID = CaseRT.ID;
            if(CaseRT.DeveloperName == 'SF_Case_Access')
                SFSupportAccess_CaseID = CaseRT.ID;
        }
        
        List<RecordType> AllprjctRT = [SELECT Id, DeveloperName  FROM RecordType where Sobjecttype = 'Milestone1_Project__c'];
        
        for(RecordType prjctRT : AllprjctRT )
        {
            if(prjctRT.DeveloperName == 'Dot_Release_Parent')
                Dot_Release_ParentID = prjctRT.ID;
            if(prjctRT.DeveloperName == 'Dot_Release_Child')
                Dot_Release_ChildID = prjctRT.ID;
            if(prjctRT.DeveloperName == 'Enhancement')
                EnhancementprjctID = prjctRT.ID;
        }
    }

static testMethod void validate_SFCreateCase_controller() {
    // list<Case> Allcases = new list<Case>();
      Case SF_CASE = new Case();
      SF_CASE.Request_Title__c  = 'Test Request'; //Customer title
      SF_CASE.Description  = 'Test description';  //Customer description
      SF_CASE.Status  = 'New';  //Customer description
      SF_CASE.RecordTypeId = SFSupport_CaseID;
     // Allcases.add(SF_CASE);
      
      insert SF_CASE ;
     /* for(integer i = 0 ; i<9 ;i++) {
          SF_CASE = new Case(); 
          ATI_CASE.RecordTypeId = SFSupport_CaseID;
           Allcases.add(ATI_CASE);
      }
      insert Allcases;*/


        PageReference pageRef = Page.SFSupportCreateCase;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id',SF_CASE.id);
        pageRef.getParameters().put('type','Issue');
        
       SFSupportCreateCaseController createCasecontroller = new SFSupportCreateCaseController(); 
        
       pageRef.getParameters().put('type','Information');
       SFSupportCreateCaseController createCasecontroller1 = new SFSupportCreateCaseController();
       
       pageRef.getParameters().put('type','Access');
       SFSupportCreateCaseController createCasecontroller2 = new SFSupportCreateCaseController();
       
       pageRef.getParameters().put('type','Data');
       SFSupportCreateCaseController createCasecontroller3 = new SFSupportCreateCaseController();
       
       pageRef.getParameters().put('type','User Account');
       SFSupportCreateCaseController createCasecontroller4 = new SFSupportCreateCaseController();
       
       pageRef.getParameters().put('type','Other');
       SFSupportCreateCaseController createCasecontroller5 = new SFSupportCreateCaseController();
       createCasecontroller5.SubmitCase();
       
       pageRef.getParameters().put('Id',null);
       SFSupportCreateCaseController createCasecontroller6 = new SFSupportCreateCaseController();
       createCasecontroller6.SubmitCase();
       createCasecontroller6.CancelCase();
       createCasecontroller6.getRadioVal();
       createCasecontroller6.getUploadTypeVal();
       
       Test.StartTest();
           pageRef.getParameters().put('type','Enhancement');
           SFSupportCreateCaseController createCasecontroller7 = new SFSupportCreateCaseController();
           createCasecontroller7.SubmitCase();
           
           pageRef.getParameters().put('type','Data');
           SFSupportCreateCaseController createCasecontroller8 = new SFSupportCreateCaseController();
           createCasecontroller8.SubmitCase();
           
           pageRef.getParameters().put('type','Access');
           SFSupportCreateCaseController createCasecontroller9 = new SFSupportCreateCaseController();
           createCasecontroller9.SubmitCase();
           
           pageRef.getParameters().put('type','User Account');
           SFSupportCreateCaseController createCasecontroller10 = new SFSupportCreateCaseController();
           createCasecontroller10.SubmitCase();
      Test.StopTest();
       
        
  }
  static testMethod void validate_SFCaseDetail_controller() {
      Case SF_CASE = new Case();
      SF_CASE.Request_Title__c  = 'Test Request'; //Customer title
      SF_CASE.Description  = 'Test description';  //Customer description
      SF_CASE.Status  = 'New';  //Customer description
      SF_CASE.RecordTypeId = SFSupport_CaseID;
     // Allcases.add(SF_CASE);
      SF_CASE.SF_Case_Category__c = 'Issue';
      insert SF_CASE ;
      
      
     
     
      
      
      
      PageReference pageRef = Page.SFSupportCaseDetail;
      Test.setCurrentPage(pageRef);
      pageRef.getParameters().put('Id',SF_CASE.id);
      
      SFSupportCaseDetailController  CaseDetailController = new SFSupportCaseDetailController();
       Test.StartTest();
      CaseDetailController.EditCase();
      CaseDetailController.CloseCase();
      CaseDetailController.CreateComment();
      CaseDetailController.AddAttachment();
      CaseDetailController.Back();
      
      SF_CASE.SF_Case_Category__c = 'Information';
      
      update SF_CASE ;
      SFSupportCaseDetailController  CaseDetailController1 = new SFSupportCaseDetailController();
     
     
     
      
     
        Test.StopTest();
     
  
  }
  
  static testMethod void validate_SFCaseDetail_controller1() {
      Case SF_CASE = new Case();
      SF_CASE.Request_Title__c  = 'Test Request'; //Customer title
      SF_CASE.Description  = 'Test description';  //Customer description
      SF_CASE.Status  = 'New';  //Customer description
      SF_CASE.RecordTypeId = SFSupport_CaseID;
     // Allcases.add(SF_CASE);
    
      
      SF_CASE.SF_Case_Category__c = 'Access';
      insert SF_CASE ;
      PageReference pageRef = Page.SFSupportCaseDetail;
      Test.setCurrentPage(pageRef);
      pageRef.getParameters().put('Id',SF_CASE.id);
      SFSupportCaseDetailController  CaseDetailController2 = new SFSupportCaseDetailController();
      
      Test.StartTest();
      SF_CASE.SF_Case_Category__c = 'User Account';
      update SF_CASE ;
      SFSupportCaseDetailController  CaseDetailController3 = new SFSupportCaseDetailController();
      
      SF_CASE.SF_Case_Category__c = 'Data';
      update SF_CASE ;
      SFSupportCaseDetailController  CaseDetailController4 = new SFSupportCaseDetailController();
      Test.StopTest();
      
      
  }
  static testMethod void validate_SFCaseDetail_controller2() {
  
       Milestone1_Project__c prjctParent = new Milestone1_Project__c();
      prjctParent.RecordTypeId = Dot_Release_ParentID;
      prjctParent.Name = 'Parent';
      prjctParent.Description__c = 'Parent';
      insert prjctParent;
      
      Case SF_CASE = new Case();
      SF_CASE.Request_Title__c  = 'Test Request'; //Customer title
      SF_CASE.Description  = 'Test description';  //Customer description
      SF_CASE.Status  = 'New';  //Customer description
      SF_CASE.RecordTypeId = SFSupport_CaseID;
     // Allcases.add(SF_CASE);
      SF_CASE.SF_Case_Category__c = 'Issue';
      insert SF_CASE ;
      PageReference pageRef = Page.SFSupportCaseDetail;
      Test.setCurrentPage(pageRef);
      pageRef.getParameters().put('Id',SF_CASE.id);
      
      Milestone1_Project__c prjct = new Milestone1_Project__c();
      prjct.RecordTypeId = Dot_Release_ChildID;
      prjct.Parent_Project__c = prjctParent.id;
      prjct.Related_Case__c = SF_CASE.id;
      prjct.Name = 'Child';
      prjct.Description__c = 'Child';
      
      Test.StartTest();
      insert prjct;
      
      SF_CASE.SF_Case_Category__c = 'Other';
      SF_CASE.Related_CMT_Project__c = prjct.id;
      update SF_CASE ;
      SFSupportCaseDetailController  CaseDetailController5 = new SFSupportCaseDetailController();
     Test.StopTest();
  
  }
  static testMethod void validate_SFCaseDetailEnhancementDetail_controller() {
      Case SF_CASE = new Case();
      SF_CASE.Request_Title__c  = 'Test Request'; //Customer title
      SF_CASE.Description  = 'Test description';  //Customer description
      SF_CASE.Status  = 'New';  //Customer description
      SF_CASE.RecordTypeId = SFSupportEnhanc_CaseID;
     // Allcases.add(SF_CASE);
      SF_CASE.SF_Case_Category__c = 'Issue';
      insert SF_CASE ;
      
      
      
      
      Milestone1_Project__c prjct = new Milestone1_Project__c();
      prjct.RecordTypeId = EnhancementprjctID;
     // prjct.Parent_Project__c = prjctParent.id;
      prjct.Related_Case__c = SF_CASE.id;
      prjct.Name = 'Child';
      prjct.Description__c = 'Child';
      insert prjct;
     
      
      
      
      PageReference pageRef = Page.SFSupportEnhancementRequestDetail;
      Test.setCurrentPage(pageRef);
      pageRef.getParameters().put('Id',SF_CASE.id);
      
      SFSupportEnhancementDetailController CaseDetailController = new SFSupportEnhancementDetailController();
      
      //CaseDetailController.EditCase();
      CaseDetailController.CloseCase();
      CaseDetailController.CreateComment();
      CaseDetailController.AddAttachment();
      CaseDetailController.Back();
      
      SF_CASE.Related_CMT_Project__c = prjct.id;
      update SF_CASE ;
      SFSupportEnhancementDetailController CaseDetailController5 = new SFSupportEnhancementDetailController();
  
  }
  
  static testMethod void validate_SFCreateComment_controller() {
      PageReference pageRef = Page.SFSupportCreateComment;
      Test.setCurrentPage(pageRef);
      pageRef.getParameters().put('caseid',null);
      SFSupportCreateCommentController  CreateCmnt = new SFSupportCreateCommentController();
          Case SF_CASE = new Case();
          SF_CASE.Request_Title__c  = 'Test Request'; //Customer title
          SF_CASE.Description  = 'Test description';  //Customer description
          SF_CASE.Status  = 'New';  //Customer description
          SF_CASE.RecordTypeId = SFSupportEnhanc_CaseID;
         // Allcases.add(SF_CASE);
          SF_CASE.SF_Case_Category__c = 'Issue';
          insert SF_CASE ;
     
       pageRef.getParameters().put('caseid',SF_CASE.id);
       SFSupportCreateCommentController  CreateCmnt1 = new SFSupportCreateCommentController();
       CreateCmnt1.userComment = 'testcomment';
       CreateCmnt1.SubmitComment();
       CreateCmnt1.CancelComment();
       
       pageRef.getParameters().put('caseid',SF_CASE.id);
       pageRef.getParameters().put('Enhancement','true');
       SFSupportCreateCommentController  CreateCmnt2 = new SFSupportCreateCommentController();
       CreateCmnt2.userComment = 'testcomment';
       CreateCmnt2.SubmitComment();
       CreateCmnt2.CancelComment();
       
       }
      
  static testMethod void validate_SFAddAttachment_controller() {
  
      Case SF_CASE = new Case();
      SF_CASE.Request_Title__c  = 'Test Request'; //Customer title
      SF_CASE.Description  = 'Test description';  //Customer description
      SF_CASE.Status  = 'New';  //Customer description
      SF_CASE.RecordTypeId = SFSupport_CaseID;
     // Allcases.add(SF_CASE);
      SF_CASE.SF_Case_Category__c = 'Issue';
      insert SF_CASE ;
      
      
      Milestone1_Project__c prjctParent = new Milestone1_Project__c();
      prjctParent.RecordTypeId = Dot_Release_ParentID;
      prjctParent.Name = 'Parent';
      prjctParent.Description__c = 'Parent';
      insert prjctParent;
      
      Milestone1_Project__c prjct = new Milestone1_Project__c();
      prjct.RecordTypeId = Dot_Release_ChildID;
      prjct.Parent_Project__c = prjctParent.id;
      prjct.Related_Case__c = SF_CASE.id;
      prjct.Name = 'Child';
      prjct.Description__c = 'Child';
      insert prjct;    
      
       //Attachment attach = new Attachment();
        Blob b = Blob.valueOf('A');
       // attach.Body = b;
       // attach.ContentType = 'application/pdf';
       // attach.Name = 'Test';
      
      PageReference pageRef = Page.SFSupportAddAttachment;
      Test.setCurrentPage(pageRef);
      pageRef.getParameters().put('caseid',SF_CASE.id);
      SFSupportAddAttachmentController AddAttachment = new SFSupportAddAttachmentController();
      AddAttachment.attachment.Body = b ;
      AddAttachment.attachment.Name = 'Test';
      AddAttachment.upload();
      AddAttachment.BackPage();
      
      SF_CASE.Related_CMT_Project__c = prjct.id;
      update SF_CASE ;
      
      
      pageRef.getParameters().put('caseid',SF_CASE.id);
      pageRef.getParameters().put('Enhancement','true');
      SFSupportAddAttachmentController AddAttachment1 = new SFSupportAddAttachmentController();
      AddAttachment.attachment.Body = b ;
      AddAttachment.attachment.Name = 'Test';
      AddAttachment1.upload();
      AddAttachment1.BackPage();
      
      
  }          
     
   static testMethod void validate_SFHome_controller() {       
      list<Case> Allcases = new list<Case>();
      Case SF_CASE = new Case();
      SF_CASE.Request_Title__c  = 'Test Request'; //Customer title
      SF_CASE.Description  = 'Test description';  //Customer description
      SF_CASE.Status  = 'New';  //Customer description
      SF_CASE.RecordTypeId = SFSupport_CaseID;
      Allcases.add(SF_CASE);
      
      //insert SF_CASE ;
     for(integer i = 0 ; i<9 ;i++) {
          SF_CASE = new Case(); 
          SF_CASE.RecordTypeId = SFSupport_CaseID;
           Allcases.add(SF_CASE);
      }
      insert Allcases;
      
      Milestone1_Project__c prjct = new Milestone1_Project__c();
      prjct.RecordTypeId = Dot_Release_ChildID;
      prjct.Related_Case__c = Allcases[0].id;
      prjct.Name = 'Child';
      prjct.Description__c = 'Child';
      insert prjct;
      
      PageReference pageRef = Page.SFSupportHome;
      Test.setCurrentPage(pageRef);
      SFSupportHomeController HomeTest = new SFSupportHomeController();
      HomeTest.showCases();
      HomeTest.CasesByStatus = 'OpenCases';
      HomeTest.showCases();
      
      HomeTest.getOpenCases2status();
      HomeTest.getOpenCases();
      HomeTest.getClosedCases();
      HomeTest.Beginning();
      HomeTest.Previous();
      HomeTest.Next();
      HomeTest.End();
      HomeTest.getDisablePrevious();
      HomeTest.getDisableNext();
      HomeTest.getTotal_size();
      HomeTest.getPageNumber();
      HomeTest.getTotalPages();
      HomeTest.Go();
      
      HomeTest.caseType = 'Enhancement';
      HomeTest.Go();
      HomeTest.caseType = 'Other';
      HomeTest.Go();
      
       
  }
  
   static testMethod void validate_AllProjectsList_controller() {
   
   SFSupportAllProjectsListController AllProjects = new SFSupportAllProjectsListController();
   AllProjects.ShowCases();
   AllProjects.CasesByStatus =  'AllProjects';
   AllProjects.ShowCases();
   AllProjects.Go();
   AllProjects.caseType = 'Enhancement' ;
   AllProjects.Go();
   AllProjects.caseType = 'Other';
   AllProjects.Go();
   AllProjects.getOpenCases();
   AllProjects.getAllProjects();
   AllProjects.getAllParentDotRel();
   AllProjects.Beginning();
   AllProjects.Previous();
   AllProjects.Next();
   AllProjects.End();
   AllProjects.getDisablePrevious();
   AllProjects.getDisableNext();
   AllProjects.getTotal_size();
   AllProjects.getPageNumber();
   AllProjects.getTotalPages();
   AllProjects.getClosedCases();
   
   
   }
   
   static testMethod void validate_DotReleaseDetail_controller() {
   
   SFDotReleaseDetailController DotRelDetail = new SFDotReleaseDetailController();
   DotRelDetail.ShowCases();
   DotRelDetail.CasesByStatus = 'AllProjects';
   DotRelDetail.ShowCases();
   DotRelDetail.Go();
   DotRelDetail.caseType = 'Enhancement';
   DotRelDetail.Go();
   DotRelDetail.caseType = 'Other';
   DotRelDetail.getOpenCases();
   DotRelDetail.getAllProjects();
   DotRelDetail.getClosedCases();
   DotRelDetail.getAllParentDotRel();
   DotRelDetail.Beginning();
   DotRelDetail.Previous();
   DotRelDetail.Next();
   DotRelDetail.End();
   DotRelDetail.getDisablePrevious();
   DotRelDetail.getDisableNext();
   DotRelDetail.getTotal_size();
   DotRelDetail.getPageNumber();
   DotRelDetail.getTotalPages();
   }
         
   static testMethod void validate_ChatterFileAdmin_controller() {
   
       Tag__c tg = new Tag__c(Tag__c='test');
       insert tg;
       Blob b = Blob.valueOf('A');
       ContentVersion CV = new ContentVersion(VersionData=b,Title='TestFile',PathOnClient='Test.pdf' );
       insert CV;
       contentDocument CD = [Select Title,id,LatestPublishedVersionId from contentDocument where LatestPublishedVersionId = :CV.id];
       
       
       FileTag__c FT = new FileTag__c(DocumentID__c = CD.Id,Document_Name__c=CV.Title,Tag__c = tg.id );
       
       PageReference pageRef = Page.SFChatterFileAdmin;
       Test.setCurrentPage(pageRef);
       
       SFChatterFileAdminController SFC = new SFChatterFileAdminController();
       pageRef.getParameters().put('indexval','0');
       pageRef.getParameters().put('searchtxt','es');
       SFChatterFileAdminController SFC1 = new SFChatterFileAdminController();
       SFC1.EditTags();
       SFC1.getpageinfo();
       //SFC.setpageTotal();
       //SFC.setpagenum();
       SFC1.ShowFiles();
       SFC1.searchfiles();
       SFC1.getFiles();
       SFC1.beginning();
       SFC1.previous();
       SFC1.next();
       SFC1.end();
       SFC1.getprev();
       SFC1.getnxt();
       SFC1.getTotal_size();
       
   
   
   }   
  
   static testMethod void validate_PublisherActiondesktopfile_controller() {
   
      Tag__c tg = new Tag__c(Tag__c='test');
      insert tg;
      Case SF_CASE = new Case();
      SF_CASE.Request_Title__c  = 'Test Request'; //Customer title
      SF_CASE.Description  = 'Test description';  //Customer description
      SF_CASE.Status  = 'New';  //Customer description
      SF_CASE.RecordTypeId = SFSupport_CaseID;
     // Allcases.add(SF_CASE);
      SF_CASE.SF_Case_Category__c = 'Issue';
      insert SF_CASE ;
      
      
      Milestone1_Project__c prjctParent = new Milestone1_Project__c();
      prjctParent.RecordTypeId = Dot_Release_ParentID;
      prjctParent.Name = 'Parent';
      prjctParent.Description__c = 'Parent';
      insert prjctParent;
      
      Milestone1_Project__c prjct = new Milestone1_Project__c();
      prjct.RecordTypeId = Dot_Release_ChildID;
      prjct.Parent_Project__c = prjctParent.id;
      prjct.Related_Case__c = SF_CASE.id;
      prjct.Name = 'Child';
      prjct.Description__c = 'Child';
      insert prjct;
      
      PageReference page = new PageReference(prjct.id);
      System.test.setCurrentpage(page);
        
        
        // Instantitate ext
        ApexPages.standardController controller = new ApexPages.StandardController(prjct);
        PublisherActionOnProject_desktopfile pubextDesk = new PublisherActionOnProject_desktopfile( controller );
        pubextDesk.attach.body = Blob.valueOf('A');
        pubextDesk.attach.name= 'Test';
        pubextDesk.post.Body = 'Test';
        pubextDesk.AdditionalTags = 'a,b,cd,e';
        pubextDesk.TagSelected.add(tg.id);
        pubextDesk.createpost();
        pubextDesk.updatepostdata();
       
        pubextDesk.getAllTags();
        pubextDesk.getunSelectedValues();
        pubextDesk.getSelectedValues();
        pubextDesk.selectclick();
        pubextDesk.unselectclick();
   }
  
   static testMethod void validate_EditTags_controller() {
       Blob b = Blob.valueOf('A');
       ContentVersion CV = new ContentVersion(VersionData=b,Title='TestFile',PathOnClient='Test.pdf' );
       insert CV;
       
       List<Tag__c> AllTags = new List<Tag__c>();
       
       for(integer i=0 ; i<10; i++){
           Tag__c tg = new Tag__c(Tag__c='test' + i);
           AllTags.add(tg);
       
       }       
       insert AllTags;
       
       contentDocument CD = [Select Title,id,LatestPublishedVersionId from contentDocument where LatestPublishedVersionId = :CV.id];
       
       FileTag__c FT = new FileTag__c(DocumentID__c=CD.id, Document_Name__c=CV.Title, Tag__c = AllTags[0].id );
       
       PageReference pageRef = Page.EditChatterFileTags;
       Test.setCurrentPage(pageRef);
       pageRef.getParameters().put('FileId',CD.Id);
       pageRef.getParameters().put('indexval','0');
       pageRef.getParameters().put('searchtxt','es');
       pageRef.getParameters().put('FileName',CV.Title);
       
       EditChatterFileTagsController EChatterTagFile = new EditChatterFileTagsController();
       EChatterTagFile.AdditionalTags = 'Ab,cd,fc';
       
       EChatterTagFile.showAddButton();
       EChatterTagFile.getAllFileTags();
       EChatterTagFile.getAllTags();
       EChatterTagFile.RemoveTags();
       EChatterTagFile.AddTags();
       EChatterTagFile.getunSelectedValuesToRm();
       EChatterTagFile.getSelectedValuesToRm();
       EChatterTagFile.selectclickToRm();
       EChatterTagFile.unselectclickToRm();
       EChatterTagFile.getunSelectedValuesToAdd();
       EChatterTagFile.getSelectedValuesToAdd();
       EChatterTagFile.selectclickToAdd();
       EChatterTagFile.unselectclickToAdd();
       EChatterTagFile.DoneTagging();
   
   }
    @isTest(SeeAllData=true)
    static void validate_ProjectAndfileTag_trigger() {
      Case SF_CASE = new Case();
      SF_CASE.Request_Title__c  = 'Test Request'; //Customer title
      SF_CASE.Description  = 'Test description';  //Customer description
      SF_CASE.Status  = 'New';  //Customer description
      SF_CASE.RecordTypeId = SFSupport_CaseID;
     // Allcases.add(SF_CASE);
      SF_CASE.SF_Case_Category__c = 'Issue';
      insert SF_CASE ;
      
      
      Milestone1_Project__c prjctParent = new Milestone1_Project__c();
      prjctParent.RecordTypeId = Dot_Release_ParentID;
      prjctParent.Name = 'Parent';
      prjctParent.Description__c = 'Parent';
      insert prjctParent;
      
      Milestone1_Project__c prjct = new Milestone1_Project__c();
      prjct.RecordTypeId = Dot_Release_ChildID;
      prjct.Parent_Project__c = prjctParent.id;
      prjct.Related_Case__c = SF_CASE.id;
      prjct.Name = 'Child';
      prjct.Description__c = 'Child';
      insert prjct;
      
      prjct.Deadline__c = Date.today();
      update prjct;
      
     FeedItem post = new FeedItem();
       
            post.Body = 'Test';
            post.ParentId = prjct.id;
            post.type = 'ContentPost';
            post.ContentData = Blob.valueOf('A');
            post.ContentFileName = 'Test';
            post.Title = 'Test';
            
            
            
            insert post;
            
            ContentVersion CV = [SELECT id,ContentDocumentId,Description,FirstPublishLocationId,Title FROM ContentVersion where FirstPublishLocationId = :post.ParentId and Title = :post.Title order by createddate desc limit 1];
            update CV; // This result in sharing the file with System admins using Trigger FileTag_Sync
           
    } 
    
    static testMethod void GIT_Events_Controller() {
    
      Milestone1_Project__c prjct = new Milestone1_Project__c();
      prjct.RecordTypeId = Dot_Release_ChildID;
      //prjct.Parent_Project__c = prjctParent.id;
      //prjct.Related_Case__c = SF_CASE.id;
      prjct.Name = 'Child';
      prjct.Description__c = 'Child';
      insert prjct;
      
      Global_IT_Events__c GIT = new Global_IT_Events__c(Global_Business_Owner_Prioritization__c = date.today(), Global_SFDC_Board__c= date.today(), Technical_Review_Board__c= date.today() );
      insert GIT;
         ApexPages.standardController controller = new ApexPages.StandardController(prjct);
         
        GIT_Events_Controller  GIT_cont1 = new GIT_Events_Controller( controller );
        GIT_Events_Controller  GIT_cont2 = new GIT_Events_Controller();
        
        
         
         
    }
    
    static testMethod void validate_customecomment_controller() {
    
    Case SF_CASE = new Case();
      SF_CASE.Request_Title__c  = 'Test Request'; //Customer title
      SF_CASE.Description  = 'Test description';  //Customer description
      SF_CASE.Status  = 'New';  //Customer description
      SF_CASE.RecordTypeId = SFSupport_CaseID;
     // Allcases.add(SF_CASE);
      SF_CASE.SF_Case_Category__c = 'Issue';
      insert SF_CASE ;
      
      Milestone1_Project__c prjct = new Milestone1_Project__c();
      prjct.RecordTypeId = Dot_Release_ChildID;
      //prjct.Parent_Project__c = prjctParent.id;
      //prjct.Related_Case__c = SF_CASE.id;
      prjct.Name = 'Child';
      prjct.Description__c = 'Child';
      insert prjct;
      
      Comment__c cmnt = new Comment__c(Related_Case__c = SF_CASE.id);
      
      Comment__c cmnt1 = new Comment__c(Related_Project__c = prjct.id);
      
    
     ApexPages.standardController controller = new ApexPages.StandardController(cmnt);
     NewCommentCustom  ccmnt= new NewCommentCustom( controller );
     
      ApexPages.standardController controller1 = new ApexPages.StandardController(cmnt1);
     NewCommentCustom  ccmnt1= new NewCommentCustom( controller1 );

    }
    

}