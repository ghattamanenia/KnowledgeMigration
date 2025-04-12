public class MoveToCMT {

    
    public boolean Enhancement{get;set;}
    public boolean DotRelease{get;set;}
    
    public boolean showblock {get;set;}
    public boolean showerror {get;set;}
   
    public String caseID{get;set;}
    public String Name_Selected{get;set;}
  //  public String DotReleaseChildName{get;set;}
  
    
    public String New_Project_Name{get;set;}
    
    public String EnhancementOptionSelected{get;set;}
    
    public String New_Dot_Release_Description{get;set;}
    public case thisCase{get;set;}
   // public List<SelectOption> DotReloptions{get;set;}
    private Id  SF_CaseID = null; 
    private Id  SF_EnhancementID = null;
    private Id  SF_CaseAccessID = null; 
    private Id  SF_CaseDataID = null;
     
    private Id  Prjt_DotReleaseChildID = null;
    private Id  Prjt_DotReleaseParentID = null; 
    private Id  Prjt_EnhancementID = null;
    
    List<Comment__c> AllRelComments = new List<Comment__c>();
      
    List<Comment__c> AllnewRelComments =  new List<Comment__c>();
    
    
    public MoveToCMT() 
    {
       initialization();
    }
    
    private void initialization()
    {
        
        List<RecordType> AllCaseRT = [SELECT Id, DeveloperName  FROM RecordType where Sobjecttype = 'Case'];
        List<RecordType> AllProjectRT = [SELECT Id, DeveloperName  FROM RecordType where Sobjecttype = 'Milestone1_Project__c'];
         
        EnhancementOptionSelected = 'NewProject';
        
        for(RecordType CaseRT : AllCaseRT )
        {
                if(CaseRT.DeveloperName == 'SF_Case')
                    SF_CaseID = CaseRT.ID;
                if(CaseRT.DeveloperName == 'SF_Case_Enhancement')
                    SF_EnhancementID = CaseRT.ID;
                if(CaseRT.DeveloperName == 'SF_Case_Access')
                    SF_CaseAccessID= CaseRT.ID;
                if(CaseRT.DeveloperName == 'SF_Case_Data')
                    SF_CaseDataID = CaseRT.ID;
        }
        
        for(RecordType PrjtRT : AllProjectRT )
        {
                if(PrjtRT.DeveloperName == 'Dot_Release_Child')
                    Prjt_DotReleaseChildID = PrjtRT.ID;
                if(PrjtRT.DeveloperName == 'Dot_Release_Parent')
                    Prjt_DotReleaseParentID = PrjtRT.ID;
                if(PrjtRT.DeveloperName == 'Enhancement')
                    Prjt_EnhancementID = PrjtRT.ID;
        }
        
        
        caseID = ApexPages.currentPage().getParameters().get('caseId');
         
         thisCase =  [SELECT ID,CaseNumber,Status,recordtypeid,CreatedById,Enhancement_Title__c,Requestor_Name__c,Description,BusinessProcessesEffected__c,Explain_legal_requirement__c
         ,Expected_Benefits_to_Allied_Telesis__c,Additional_Comments__c,estimatedCostReduction__c,estimatedRevenueImprovements__c,Explain_cost_Reduction__c,Explain_revenue_improvements__c,
         Region__c,Processes_roles_to_be_effected_by_change__c,Scope_of_Change__c,Technical_impact_of_change__c,
          Priority,ownerid,Copied_to_CMT__c,Resolution_Code__c,caseResolution__c,
          What_are_the_steps_to_reproduce_it__c,Data_Upload_Type__c,Data_Type_Comments__c,Upload_Active_Date__c,SF_Case_Category__c  FROM case WHERE id = :caseID ];
          
         AllRelComments = [Select id,Related_Project__c,Related_Case__c from comment__c where Related_Case__c =:thisCase.id ];
        system.debug('AllRelated comments::' + AllRelComments);
          if(thisCase.Copied_to_CMT__c == false)
          {
            showblock = true;
            showerror = false;
              if(thisCase.recordtypeid == SF_EnhancementID)
              {
                  Enhancement = true;
                  DotRelease = false;
                  
               }
              else
              {
                  Enhancement = false;
                  DotRelease = true;
                  
              }
          }
          else
          {
            showblock = false;
            showerror = true;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'This Case/Enhancement Request has already been moved to CMT.'); 
            ApexPages.addMessage(myMsg); 
            return;
          
          }
          
        
         
        
    }
    
    public List<SelectOption> getRadioOptions() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('NewProject','Create New Project')); 
        options.add(new SelectOption('DotRelease','Add to Existing Dot Release')); 
        return options ;
     }
                   
   
    
    public List<SelectOption> getReleaseNames() {
     List<SelectOption> DotReloptions = new List<SelectOption>();
     List<Milestone1_Project__c> AllProjects = [select id,Name from Milestone1_Project__c where recordtypeid=:Prjt_DotReleaseParentID and status__c != 'Completed']; //remove the hardcode later
     DotReloptions.add(new SelectOption('-- None --','-- None --'));
     for(Milestone1_Project__c prjct : AllProjects )
            {
                DotReloptions.add(new SelectOption(prjct.id,prjct.Name));
            }
     return DotReloptions ;
    }
    
    
     public PageReference Cancel() {
        return new PageReference('/' + caseID );
    }
    
  
    
     public PageReference MoveCase() {
        
        List<Attachment> AllCaseRelAttachments = new List<Attachment>();
        List<Attachment> AllPrjAttachments = new List<Attachment>();
        
      /*  if(thiscase.recordtypeid != SF_EnhancementID && Name_Selected=='-- New --' && New_Project_Name == '')
        {
              ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please give a new Dot release name or choose an existing Dot release.');
              ApexPages.addMessage(errorMsg);
              return null;    
        }
        
        if(thiscase.recordtypeid != SF_EnhancementID && Name_Selected=='-- New --' && New_Project_Name == '')
        {
              ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please give a new Dot release Description.');
              ApexPages.addMessage(errorMsg);
              return null;      
        }*/
        
        if((thiscase.recordtypeid == SF_EnhancementID && New_Project_Name == '') ||
           (thiscase.recordtypeid != SF_EnhancementID && New_Project_Name == '') ||
           (thiscase.recordtypeid != SF_EnhancementID && Name_Selected == '-- None --' ) ||
           (thiscase.recordtypeid == SF_EnhancementID && Name_Selected == '-- None --' && EnhancementOptionSelected == 'DotRelease'))
        {
        
            if(thiscase.recordtypeid == SF_EnhancementID && Name_Selected == '-- None --' && EnhancementOptionSelected == 'DotRelease')
            {
                 ApexPages.Message errorMsg4 = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a Dot release.');
                  ApexPages.addMessage(errorMsg4);
                 
            }
            if(thiscase.recordtypeid == SF_EnhancementID && New_Project_Name == '')
            {
                 ApexPages.Message errorMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,'Please provide a name for this Dot Release Item/Project.');
                  ApexPages.addMessage(errorMsg1);
                   
            }
             if(thiscase.recordtypeid != SF_EnhancementID && Name_Selected == '-- None --' )
            {
                 ApexPages.Message errorMsg3 = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a Dot Release.');
                  ApexPages.addMessage(errorMsg3);
                
            }
            if(thiscase.recordtypeid != SF_EnhancementID && New_Project_Name == '')
            {
                 ApexPages.Message errorMsg2 = new ApexPages.Message(ApexPages.Severity.ERROR,'Please provide a name for this Dot Release Item.');
                  ApexPages.addMessage(errorMsg2);
                   
            }
            
           
            
            
             return null;   
       }
        try
        {
            //thiscase.Copy_to_CMT__c = true;
            Milestone1_Project__c CMT_project =  new Milestone1_Project__c();
            List<Milestone1_Project__c> ParentProject = [select id,Name from Milestone1_Project__c where id= :Name_Selected]; 
          if(thiscase.recordtypeid == SF_EnhancementID)
          {    
                 CMT_project.Name = New_Project_Name;
                 CMT_project.Recordtypeid = Prjt_EnhancementID;
                 CMT_project.Description__c =   thiscase.Description;
                 CMT_project.Business_Process__c = thiscase.BusinessProcessesEffected__c;
                 CMT_project.Explain_Legal_Requirements__c =  thiscase.Explain_legal_requirement__c;
                 CMT_project.Expected_Benefit__c = thiscase.Expected_Benefits_to_Allied_Telesis__c;
                 CMT_project.Additional_Comments__c = thiscase.Additional_Comments__c;
                 CMT_project.Estimated_Cost_Reduction__c = thiscase.estimatedCostReduction__c;
                 CMT_project.Estimated_Sales_Improvement__c = thiscase.estimatedRevenueImprovements__c;
                 CMT_project.Explain_cost_Reduction__c = thiscase.Explain_cost_Reduction__c;
                 CMT_project.Explain_Revenue_Improvements__c = thiscase.Explain_revenue_improvements__c;
                // CMT_project.Department__c = thiscase.Department__c;
                 CMT_project.Regions_Affected__c = thiscase.Region__c;
                 CMT_project.Processes_to_be_effected_by_change__c = thiscase.Processes_roles_to_be_effected_by_change__c;
                 //CMT_project.Resource_Requirements__c = thiscase.Resource_Requirements__c;
                 CMT_project.Scope_of_Change__c = thiscase.Scope_of_Change__c;
                // CMT_project.Technical_components_of_change__c = thiscase.Technical_components_of_change__c;
                 CMT_project.Technical_impact_of_change__c = thiscase.Technical_impact_of_change__c;
                // CMT_project.Developers_person_hours__c = thiscase.Developers_person_hours__c;                      
                // CMT_project.Outsourced_Consultant_Cost__c = thiscase.Outsourced_Consultant_Cost__c;
                // CMT_project.Project_Manager_person_hours__c = thiscase.Project_Manager_person_hours__c;
                // CMT_project.Professional_Services_Cost__c = thiscase.Professional_Services_Cost__c;                         
                // CMT_project.Service_and_Support_Staff_person_hours__c = thiscase.Service_and_Support_Staff_person_hours__c;
                // CMT_project.Total_estimated_capitol_cost__c = thiscase.Total_estimated_capitol_cost__c;                             
                // CMT_project.Capitol_cost_details__c = thiscase.Capitol_cost_details__c;                            
                 //CMT_project.Total_estimated_expense_cost__c = thiscase.Total_estimated_expense_cost__c;                             
                // CMT_project.Expense_cost_details__c = thiscase.Expense_cost_details__c; 
                // CMT_project.Explain_effected_Business_Processes__c = thiscase.Explain_effected_Business_Processes__c;
                 //CMT_project.Explain_effected_Processes_Roles__c = thiscase.Explain_effected_Processes__c;
                 CMT_project.Related_Case__c = thiscase.id;
                 
                 CMT_project.Status__c = 'Analysis';
                                          
                 //CMT_project.Priority__c = thiscase.Priority;
                 CMT_project.ownerid = thiscase.ownerid;
               
                if(thiscase.Requestor_Name__c == null)
                    CMT_project.Requestor_Name__c = thiscase.CreatedById;
                else
                     CMT_project.Requestor_Name__c = thiscase.Requestor_Name__c;
                 
                 /*thiscase.caseResolution__c= 'Your enhancement request has been copied into the Global Change Management system and is now closed in the SF Support system.  Please refer to this Global Change Management project name when communicating about your request: "'+ thiscase.Enhancement_Title__c
                  
                 + '".\r\n\nThese requests are evaluated and scheduled for formal review on a minimum of a quarterly basis.  You may be contacted with a request for additional information before the formal review meeting.  If the request included a justification for an expedited solution, the Global Team will consider this in their assessment of each request.\r\n\n'
                 + 'A team member will update you before the next review meeting.';*/
                if(EnhancementOptionSelected == 'DotRelease' && Name_Selected != '-- None --')
                {
                    CMT_project.Parent_Project__c = ParentProject[0].id;
                      //thiscase.Related_CMT_Parent_Dot_Release__c =  ParentProject[0].id;
                 }
                insert CMT_project;
                thiscase.Related_CMT_Project__c = CMT_project.id;
                
                for(comment__C Rel_cmnt : AllRelComments )
                {
                    Rel_cmnt.Related_Project__c = CMT_project.id;
                    AllnewRelComments.add(Rel_cmnt);
                }
                 system.debug('All comments to be updated enh::'+AllnewRelComments);
                update(AllnewRelComments);
                
                
                
                AllCaseRelAttachments = [SELECT Body,ContentType,Description,Id,IsDeleted,Name,OwnerId,ParentId FROM Attachment where ParentId = :thiscase.id];
                for(Attachment attch : AllCaseRelAttachments )
                {
                    if(attch.IsDeleted == false)
                    {
                    Attachment prjAttach = new Attachment(Body = attch.Body, ContentType = attch.ContentType , Description = attch.Description,Name = attch.Name, ParentId = CMT_project.id );
                    AllPrjAttachments.add(prjAttach);
                    
                    }
                    
                }
                 
                 insert AllPrjAttachments;
            }
            else        
              {
                 // List<Milestone1_Project__c> ParentProject = [select id,Name from Milestone1_Project__c where id= :Name_Selected]; 
                  
                  /*if(ParentProject.size() == 0)
                  {
                       CMT_project.Name = New_Project_Name;
                       CMT_project.Description__c = New_Dot_Release_Description;
                       CMT_project.RecordTypeid = Prjt_DotReleaseParentID;                       
                       insert CMT_project;
                  }*/
                  Milestone1_Project__c CMT_DotRelaseChild =  new Milestone1_Project__c();
                  CMT_DotRelaseChild.Name = New_Project_Name;
                  
                /*  if(ParentProject.size() == 0)
                  {
                      CMT_DotRelaseChild.Parent_Project__c = CMT_project.id;
                      thiscase.Related_CMT_Project__c = CMT_project.id;
                  }
                  else
                  {*/
               CMT_DotRelaseChild.Parent_Project__c = ParentProject[0].id;
                thiscase.Related_CMT_Project__c = ParentProject[0].id;
               //  thiscase.Related_CMT_Parent_Dot_Release__c =  ParentProject[0].id;
                 // }
                      
                  CMT_DotRelaseChild.Description__c =   thiscase.Description;
                  CMT_DotRelaseChild.Steps_to_Reproduce_the_Issue__c =  thiscase.What_are_the_steps_to_reproduce_it__c;
                  CMT_DotRelaseChild.Data_Upload_Type__c = thiscase.Data_Upload_Type__c;
                  CMT_DotRelaseChild.Data_Type_Comments__c = thiscase.Data_Type_Comments__c;
                  CMT_DotRelaseChild.Upload_Active_Date__c = thiscase.Upload_Active_Date__c;
                  CMT_DotRelaseChild.Additional_Comments__c = thiscase.Additional_Comments__c;
                  CMT_DotRelaseChild.ownerid = thiscase.ownerid;                  
                  CMT_DotRelaseChild.Issue_Category__c = thiscase.SF_Case_Category__c;
                  CMT_DotRelaseChild.Related_Case__c = thiscase.id;
                  CMT_DotRelaseChild.Recordtypeid = Prjt_DotReleaseChildID;
                  
                   CMT_DotRelaseChild.ownerid = thiscase.ownerid;
                  
                  CMT_DotRelaseChild.Status__c = 'Analysis';
                  
                  if(thiscase.Requestor_Name__c == null)
                    CMT_DotRelaseChild.Requestor_Name__c = thiscase.CreatedById;
                  else
                     CMT_DotRelaseChild.Requestor_Name__c = thiscase.Requestor_Name__c;
                  insert CMT_DotRelaseChild;
                  
                  
                  
                 thiscase.Related_CMT_Project__c = CMT_DotRelaseChild.id;
                 
                 for(comment__C Rel_cmnt : AllRelComments )
                {
                    Rel_cmnt.Related_Project__c = CMT_DotRelaseChild.id;
                    AllnewRelComments.add(Rel_cmnt);
                }
                system.debug('All comments to be updated::'+AllnewRelComments);
                update(AllnewRelComments);
                 
                 AllCaseRelAttachments = [SELECT Body,ContentType,Description,Id,IsDeleted,Name,OwnerId,ParentId FROM Attachment where ParentId = :thiscase.id];
                for(Attachment attch : AllCaseRelAttachments )
                {
                    if(attch.IsDeleted == false)
                    {
                    Attachment prjAttach = new Attachment(Body = attch.Body, ContentType = attch.ContentType , Description = attch.Description,Name = attch.Name, ParentId = CMT_DotRelaseChild.id );
                    AllPrjAttachments.add(prjAttach);
                    
                    }
                    
                }
                 
                 insert AllPrjAttachments;
                 
              }
              
               //thiscase.Status = 'Moved to CMT';
              thiscase.Copied_to_CMT__c = true;
              // thiscase.Status = 'Closed';
            update thisCase;
         }
        catch (Exception ex) 
        {
              // string error = ex.getMessage();
                System.debug('The following exception has occurred while copying this case to CMT: ' + ex.getMessage());
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Error occured while copying to CMT:' + ex.getMessage());
                ApexPages.addMessage(myMsg);
                return null;
        }
        

        return new PageReference('/' + caseID );
    }


}