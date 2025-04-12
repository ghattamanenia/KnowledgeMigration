public without sharing class SFSupportCreateCaseController {
    public Case SupportCase {get;set;}
    public String Type {get;set;}
    public String PageName {get;set;}
    public String HeaderText {get;set;}
    public String HeaderHelpText {get;set;}    
    public String DescLabel {get;set;}
    public String IsDesc {get;set;}
    public String IsAdditionalDesc {get;set;}
    public String AdditionalDescLabel {get;set;}    
    public String IsAttachment {get;set;}
    public String IsOnBehalfOf {get;set;}
    public String IsAttachmentForData {get;set;}
    public String radio {get;set;}
    public String uploadType {get;set;}
    public String Error {get;set;}
    
    public SFSupportCreateCaseController() {
      Id id = ApexPages.currentPage().getParameters().get('id');
      Type = ApexPages.currentPage().getParameters().get('type');
       
      if(Type == 'Issue') {
        HeaderText = 'I\'m reporting an issue with Salesforce';   
        HeaderHelpText = '';                         
        DescLabel = 'Please describe the Salesforce issue';
        IsDesc = 'table-row';     
        IsAdditionalDesc = 'table-row';     
        AdditionalDescLabel = '';
        IsOnBehalfOf = 'none';  
        IsAttachment = 'table-row';                
        IsAttachmentForData = 'none';                 
      }
      else if(Type == 'Information') {
        HeaderText = 'I have a question about Salesforce'; 
        HeaderHelpText = '';                           
        DescLabel = 'What is your question?';
        IsDesc = 'table-row';     
        IsAdditionalDesc = 'none';
        IsOnBehalfOf = 'none';                  
        IsAttachment = 'table-row';               
        IsAttachmentForData = 'none';                 
      }

      else if(Type == 'Access') {
        HeaderText = 'I\'m requesting a change to an user\'s access in Salesforce?';
        HeaderHelpText = '';                           
        DescLabel = 'What are the access changes you’re requesting?';  
        IsDesc = 'table-row';     
        IsAdditionalDesc = 'none';            
        IsOnBehalfOf = 'table-row';
        IsAttachment = 'none';                
        IsAttachmentForData = 'none';                 
      }
      else if(Type == 'Data') {
        HeaderText = 'I\'m requesting a data upload to Salesforce';
        HeaderHelpText = 'Only pre-authorized users may request a data upload.';                           
        IsDesc = 'none';             
        IsAdditionalDesc = 'none';          
        IsOnBehalfOf = 'table-row';
        IsAttachment = 'none';       
        IsAttachmentForData = 'table-row';         
      }
      else if(Type == 'User Account') {
        HeaderText = 'I\'m requesting termination of an existing Salesforce user';
        IsDesc = 'none';             
        IsAdditionalDesc = 'none';     
        IsOnBehalfOf = 'table-row';
        IsAttachment = 'none';
        IsAttachmentForData = 'none';                         
      }      
      else if(Type == 'Other') {
        HeaderText = 'I have a request that was not listed';
        HeaderHelpText = '';                           
        IsAdditionalDesc = 'none';
        DescLabel = 'Please describe your request';
        IsOnBehalfOf = 'table-row';                      
        IsAttachment = 'table-row';                
        IsAttachmentForData = 'none';                 
      }
    
      if(id == null) {
        SupportCase = new Case();
        // ID SFCase_ID = [SELECT ID FROM RecordTYpe WHERE SobjectType = 'Case' AND DeveloperName = 'SF_Case'].ID;
        // ID SFEnhancement_ID = [SELECT ID FROM RecordTYpe WHERE SobjectType = 'Case' AND DeveloperName = 'SF_Case_Enhancement'].ID;
        
        List<RecordType> AllCaseRT = [SELECT Id, DeveloperName  FROM RecordType where Sobjecttype = 'Case'];
        Id  SF_CaseID = null; 
        Id  SF_EnhancementID = null; 
        Id  SF_CaseAccessID = null; 
        Id  SF_CaseDataID = null; 
    
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
        if(Type == 'Enhancement')
             SupportCase.RecordTypeid = SF_EnhancementID; 
        else if(Type == 'Data')
        { 
             SupportCase.Description = 'Please upload the data as requested.';
             SupportCase.RecordTypeid = SF_CaseDataID; 
        }
        else if(Type == 'Access')
        {
             SupportCase.RecordTypeid = SF_CaseAccessID; 
        }
        else if(Type == 'User Account') 
        {
             SupportCase.Description = 'Please deactivate the salesforce user mentioned in this request.';
             SupportCase.RecordTypeid = SF_CaseAccessID; 
        }
        else
             SupportCase.RecordTypeid = SF_CaseID;
           
      }
      else {
        SupportCase = [SELECT Id, Request_Title__c, Description, Authorizing_Email__c, Leaver_Name__c, 
                    BusinessProcessesEffected__c, Explain_effected_Business_Processes__c,Additional_Comments__c,
                    estimatedCostReduction__c, estimatedRevenueImprovements__c, 
                    Explain_revenue_improvements__c, Explain_cost_Reduction__c, Explain_legal_requirement__c,
                    Data_Upload_Type__c, Upload_Active_Date__c, Requestor_Name__c, User_Termination_Date__c, 
                    Business_requirement_for_access__c, Data_Type_Comments__c, RecordTypeid 
                    FROM Case WHERE Id =: id];
      }   
      radio = 'No'; 

      /*** Multi select example ***/
      //selectedBusinessProcesses = new List<SelectOption>();
    }  

    public List<SelectOption> getRadioVal() {
      List<SelectOption> options = new List<SelectOption>(); 
      options.add(new SelectOption('Yes','Yes')); 
      options.add(new SelectOption('No','No')); 
      return options; 
    }

    public List<SelectOption> getUploadTypeVal() {
      List<SelectOption> options = new List<SelectOption>();
      options.add(new SelectOption('','--Please Select One--'));
      options.add(new SelectOption('Price Book','Price Book'));
      options.add(new SelectOption('Product','Product'));
      options.add(new SelectOption('Other','Other'));
      return options;
    }

    /*** Multi select example ***/
    //public List<SelectOption> getSelectedBusinessProcesses() {
    //  List<SelectOption> options = new List<SelectOption>();
    //  options.add(new SelectOption('Sales','Sales'));
    //  options.add(new SelectOption('Marketing','Marketing'));
    //  options.add(new SelectOption('Service','Service'));
    //  options.add(new SelectOption('Logistics','Logistics'));
    //  options.add(new SelectOption('Other','Other'));
    //  return options;
    //}
    public PageReference CancelCase() {
      return new PageReference('/apex/SFSupportHome');
    }
    
    public Attachment attachment{
        get {
            if (attachment == null)
                attachment = new Attachment();
            return attachment;
        }
        set;
    }

    public PageReference SubmitCase() {
      try {   
        if(radio == 'No' && SupportCase.Requestor_Name__c != null) {
          SupportCase.Requestor_Name__c = null;
        }
         
        if(SupportCase.Requestor_Name__c == null) {
          SupportCase.Requestor_Name__c = UserInfo.getUserId();          
        }

        PageName = Apexpages.currentPage().getUrl().remove('/apex/');

        AssignmentRule AR = new AssignmentRule();
        AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
        //Creating the DMLOptions for "Assign using active assignment rules" checkbox
        Database.DMLOptions dmlOpts = new Database.DMLOptions();
        //dmlOpts.EmailHeader.triggerAutoResponseEmail = true;
        //dmlOpts.EmailHeader.triggerOtherEmail = true;
        dmlOpts.EmailHeader.triggerUserEmail = true;
        dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
        SupportCase.setOptions(dmlOpts);

        SupportCase.SF_Case_Category__c = Type;          
        SupportCase.Origin = 'SF Support Request';
        SupportCase.Data_Upload_Type__c = uploadType;
        
        /*** Multi select example ***/
        //List<String> businessProceeses = new List<String>();

        //String businessProceeses = '';
        //Boolean fisrt = true;
        //if(!selectedBusinessProcesses.isEmpty()) {
        //  for ( String so : selectedBusinessProcesses ) {
        //    if(fisrt) {
        //      businessProceeses = so;
        //      fisrt = false;
        //    }
        //    else {
        //      businessProceeses = businessProceeses + ';' + so;
        //    }
        //  }          
        //}
        //SupportCase.BusinessProcessesEffected__c = businessProceeses;

        upsert SupportCase;          
        upload();  

        if(Type == 'Enhancement')
          return new PageReference('/apex/SFSupportEnhancementRequestDetail?id='+ SupportCase.id);
        else
          return new PageReference('/apex/SFSupportCaseDetail?id='+ SupportCase.id);
      }
      catch(Exception ex) {
        Error = ex.getMessage();  

        System.debug('The following exception has occurred : ' + ex.getMessage());
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Error:' + ex.getMessage());
        ApexPages.addMessage(myMsg);        
        return null;
      }
    }

    private void upload() 
    {
      attachment.ParentId = SupportCase.Id;

      try 
      {
        insert attachment;
      }
      catch (Exception e) 
      {
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Case saved successfully but error attaching file.' + e.getMessage()));
      } 
         
    }
    
    /*** Multi select example ***/
    /*public PageReference save() {
        message = 'Selected Business Processes: ';
        Boolean first = true;
        for ( SelectOption so : selectedBusinessProcesses ) {
            if (!first) {
                message += ', ';
            }
            message += so.getLabel()
            first = false;
        }
        
        return null;       
    }*/
}