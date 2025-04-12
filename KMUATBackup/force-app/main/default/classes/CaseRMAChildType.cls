public class CaseRMAChildType 
{

    public String caseID{get;set;}
    public String caseNumber{get;set;}
    //public String Hw_Asset{get;set;}
    public User user{get;set;}
    public String error{get;set;}
    private map<id,Asset__c> AssetMap;
    private case ParentCase;
    
    public Case submitCase {get;set;}
    
    /* public List<SelectOption> getAssets() {
           List<Asset__c> AllRelAssets = [select id,Name,Serial_Number__c,Start_Date__c from Asset__c where Account__c  = :ApexPages.currentPage().getParameters().get('RelAccountId')];
            AssetMap = new map<id,Asset__c>();
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('--None--','--None--'));
            for(Asset__c HWAsset : AllRelAssets )
            {
                AssetMap.put(HWAsset.id,HWAsset);
                options.add(new SelectOption(HWAsset.id,HWAsset.Name+' Serial No: '+HWAsset.Serial_Number__c));
            }
            return options;
        } */
   
    public CaseRMAChildType() {
    
        Schema.DescribeSObjectResult CaseDescribe = Schema.SObjectType.Case; 
        Map<String,Schema.RecordTypeInfo> CaseRtMapByName = CaseDescribe.getRecordTypeInfosByName();
        
        Id CaseRMAChildRCTypeId = CaseRtMapByName.get('ATI RMA Child Case').getRecordTypeId();
        submitCase  = new case();
        ID rID = [SELECT ID FROM RecordTYpe WHERE SobjectType = 'Case' AND Name = 'ATI RMA Child Case'].ID;
        submitCase.recordtypeId =  rID;
        
        ParentCase    =   [SELECT ID ,Request_Title__c,Description,Origin,TAC_Enginer__c,Impact__c,Urgency__c,ownerid,Priority,CaseNumber  FROM Case where id =:ApexPages.currentPage().getParameters().get('ParentCaseId')];
        submitCase.Impact__c = ParentCase.Impact__c;
        submitCase.Urgency__c = ParentCase.Urgency__c;
       // submitCase.Priority = ParentCase.Priority;
        submitCase.AccountId = ApexPages.currentPage().getParameters().get('RelAccountId');
       // submitCase.RecordTypeId = CaseRMAChildRCTypeId ; -->
    }
    
     public PageReference CancelSubmit() {
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('ParentCaseId'));
    }
    
     public PageReference SubmitCase() {
        
        system.debug('::: SUBMITTING CASE:::');
        Schema.DescribeSObjectResult CaseDescribe = Schema.SObjectType.Case; 
        Map<String,Schema.RecordTypeInfo> CaseRtMapByName = CaseDescribe.getRecordTypeInfosByName();
        
        Id CaseRMAChildRCTypeId = CaseRtMapByName.get('ATI RMA Child Case').getRecordTypeId();
        // RMA child case should not be auto assigned and should remain with user so commenting this code
            /*//Fetching the assignment rules on case
            AssignmentRule AR = new AssignmentRule();
            AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
            //Creating the DMLOptions for "Assign using active assignment rules" checkbox
            Database.DMLOptions dmlOpts = new Database.DMLOptions();
            dmlOpts.EmailHeader.triggerAutoResponseEmail = true;
            dmlOpts.EmailHeader.triggerOtherEmail = true;
            dmlOpts.EmailHeader.triggerUserEmail = true;
            dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
            submitCase.setOptions(dmlOpts);*/
        submitCase.Origin = ParentCase.Origin;
     /*   if(Hw_Asset!='--None--')
        {
            submitCase.Hw_Asset_Name__c = Hw_Asset;
            // Autofill date of purchase on child case
            //  system.debug('submitCase.Hw_Asset_Name__c::->' + Hw_Asset);
            // system.debug('Date of purchase on harware is::->' + Hw_Asset);
           //  Asset__c HWAsset =  AssetMap.get(Id.valueOf(Hw_Asset));
           // submitCase.Date_of_Purchase__c =  HwAsset.Start_Date__c;             
        }*/
        submitCase.AccountId = ApexPages.currentPage().getParameters().get('RelAccountId');
        submitCase.ContactId = ApexPages.currentPage().getParameters().get('RelContactId'); 
        SubmitCase.ParentId = ApexPages.currentPage().getParameters().get('ParentCaseId'); 
        SubmitCase.TAC_Enginer__c = ParentCase.TAC_Enginer__c;
        submitCase.RecordTypeId = CaseRMAChildRCTypeId ;
        
        submitCase.Request_Title__c = ParentCase.Request_Title__c;//'This is a Child case for parent case number ' + ParentCase.CaseNumber ;
        submitCase.Description =  ParentCase.Description;//'This is a Child case for parent case number ' + ParentCase.CaseNumber ;
        //submitCase.ownerid = ParentCase.ownerid;
        
        if(submitCase.Impact__c == '-' || submitCase.Urgency__c == '-' /*|| Hw_Asset == '--None--'*/ || submitCase.Hw_Asset_Name__c == null)
        {
        
           
            if(submitCase.Impact__c == '-')
               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Customer Impact: You must enter a value.'));
            if(submitCase.Urgency__c == '-')
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Customer Urgency: You must enter a value.'));
            //if(Hw_Asset == '--None--')
             //    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'H/W Asset: You must enter a value.'));
            if(submitCase.Hw_Asset_Name__c == null)
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'H/W Asset: You must select a value.'));
         
            
           return null;
        }
        
       List<Warranty_Items__c>  WarrntItem = new List<Warranty_Items__c>();  
       List<Asset__c> HWAsset = new List<Asset__c>();
       WarrntItem  = [select Name,id,HW_Asset__c,Warranty_Start_Date__c,Warranty_End_Date__c from Warranty_Items__c where HW_Asset__c = :submitCase.Hw_Asset_Name__c LIMIT 1];
       HWAsset = [select id,Start_Date__c,End_Date__c from Asset__c where ID = :submitCase.Hw_Asset_Name__c LIMIT 1]; 
        
        /*if(HWAsset.size()>0){
            if((HWAsset[0].Start_Date__c <= date.today()) && (date.today() <= HWAsset[0].End_Date__c))
                submitCase.Warranty__c = 'Active';
            else
                submitCase.Warranty__c = 'InActive';
            
            //submitCase.Warranty_Start_Date__c = HWAsset[0].Start_Date__c;
            //submitCase.Warranty_End_Date__c = HWAsset[0].End_Date__c;
           
         }
             
        if(WarrntItem.size()>0){
            if((WarrntItem[0].Warranty_Start_Date__c <= date.today()) && (date.today() <= (WarrntItem[0].Warranty_End_Date__c)))
                submitCase.Warranty__c = 'Active';
            else
                submitCase.Warranty__c = 'InActive';
            
            submitCase.Warranty_Start_Date__c = WarrntItem[0].Warranty_Start_Date__c;
            submitCase.Warranty_End_Date__c = WarrntItem[0].Warranty_End_Date__c;
        }*/
        List<Service_Asset__c> SA = new List<Service_Asset__c>();
        List<ServiceContract> SC = new List<ServiceContract>(); 
        SA = [select Id, Asset__c,Purchase_Information__c from Service_Asset__c where Asset__c = :submitCase.Hw_Asset_Name__c LIMIT 1 ];
        if(SA.size()>0){
               SC = [select id ,StartDate,EndDate,Service_Asset__c,status from ServiceContract where Service_Asset__c = :SA[0].Id LIMIT 1];
         }
        if(SC.size()>0){
             submitCase.Service_Contract__c = SC[0].Id;
              submitCase.Purchase_Information__c = SA[0].Purchase_Information__c;
        
        }
            
            
        try {
            insert submitCase;
            caseID = submitCase.Id;
        }
        catch (Exception ex) {
            error = ex.getMessage();
            System.debug('The following exception has occurred inserting RMA Child case: ' + ex.getMessage());
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Error creating RMA Child Case:' + ex.getMessage());
            ApexPages.addMessage(myMsg);
        }

        return new PageReference('/' + caseID );
    }


}