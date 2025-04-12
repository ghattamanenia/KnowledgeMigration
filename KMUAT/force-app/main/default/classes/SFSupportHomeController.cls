public without sharing class SFSupportHomeController {
    public boolean ShowOpen {get; set;}
    public boolean ShowClosed {get;set;}

    public String caseType {get;set;}
    public String description {get;set;}
    public PageReference nextPage;
    public List<Case> AllCases {get;set;}
    public Integer currentPage {get;set;}
    public Integer lastPage {get;set;}  
    public Integer totalPages {get;set;}  

    public String error {get;set;}  

    private Id sfCaseRCTypeId;
    private Id sfCaseAccessRCTypeId;
    private Id sfCaseDataRCTypeId;
    private Id sfCaseEnhancementRCTypeId;

    private Integer total_size;     
    private Integer index = 0;
    private Integer list_size = 10;

    public User user {get;set;}
    private Id ContId;
    private String userId; 
    
    public String CasesByStatus {get;set;}

    public SFSupportHomeController() {

        ShowOpen = true;
        ShowClosed = false;

        try {
            currentPage = 1;
            userId = UserInfo.getUserId();
            
            user = [SELECT Id, AccountId, ContactId from user where Id =: UserInfo.getUserId()];
            ContId = user.ContactId;
            total_size = [SELECT count() FROM Case WHERE CreatedBy.Id =: userId ];  
            lastPage = (math.mod(total_size, list_size)==0)?((total_size/list_size)):((total_size/list_size)+1);
        }
        catch (Exception ex) {
            error = ex.getMessage();  
            System.debug('The following exception has occurred : ' + ex.getMessage());
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Error:' + ex.getMessage());
            ApexPages.addMessage(myMsg);        
        }
    }

    public void ShowCases() {
       if(CasesByStatus == 'OpenCases') {
           ShowOpen = true;
           ShowClosed = false;
           index = 0;
           currentPage = 1;
       }          
       else {
           ShowOpen = false;
           ShowClosed = true;
           index = 0;
           currentPage = 1;
       }
    }
    
    public PageReference Go() {

        if (caseType == null) {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a case type from the dropdown.'));
            return null;
        }
        else if(caseType == 'Enhancement') {
            nextPage = new PageReference('/apex/SFSupportEnancementRequest');
            nextPage.getParameters().put('type', caseType);
        }              
        else {
            nextPage = new PageReference('/apex/SFSupportCreateCase');
            nextPage.getParameters().put('type', caseType); 
        }
        
        return nextPage;
    }
    
    public List<CaseDetail2Status> getOpenCases2status() { 
    
        List<string> ExtStatus = new List<string>();
        List<string> IntStatus = new List<string>();
        SET<ID> AllCaseIds = new SET<ID>();
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
        try {
            Schema.DescribeSObjectResult CaseDescribe = Schema.SObjectType.Case; 
            Map<String,Schema.RecordTypeInfo> CaseRtMapByName = CaseDescribe.getRecordTypeInfosByName();
            
            sfCaseRCTypeId = CaseRtMapByName.get('SF Case').getRecordTypeId();
            sfCaseAccessRCTypeId = CaseRtMapByName.get('SF Case Access').getRecordTypeId();
            sfCaseDataRCTypeId = CaseRtMapByName.get('SF Case Data').getRecordTypeId();
            sfCaseEnhancementRCTypeId = CaseRtMapByName.get('SF Case Enhancement').getRecordTypeId();

            total_size = [SELECT count() FROM Case WHERE CreatedBy.Id = :userId and status != 'Closed' ];  
            lastPage = (math.mod(total_size, list_size) == 0)?((total_size/list_size)):((total_size/list_size)+1);
            
            List<CaseDetail2Status> AllCasesStatus = new  List<CaseDetail2Status>();
            
            List<Case> AllCases = [SELECT Id, CaseNumber, Related_CMT_Project__c,Request_Title__c, Description, CreatedDate, SF_Case_Category__c, CreatedBy.Name, Data_Upload_Type__c, Leaver_Name__c, RecordTypeId, Status 
                                 FROM Case WHERE CreatedBy.Id = :userId AND status != 'Closed' AND 
                                ((RecordTypeId = :sfCaseRCTypeId ) OR (RecordTypeId = :sfCaseAccessRCTypeId) OR (RecordTypeId = :sfCaseDataRCTypeId) OR (RecordTypeId = :sfCaseEnhancementRCTypeId)) 
                                ORDER BY CreatedDate DESC LIMIT :list_size OFFSET :index];

            for (integer i = 0; i < AllCases.size(); i++) {
                if(AllCases[i].SF_Case_Category__c  == 'Data') {                
                    AllCases[i].Description = 'Request for a data upload.';
                }
                else if(AllCases[i].SF_Case_Category__c == 'User Account') {
                    AllCases[i].Description = 'Requset for an account termination.';
                }
               AllCaseIds.add(AllCases[i].id);
             }
              
                
           List<Milestone1_Project__c>  relatedProject = new List<Milestone1_Project__c>();
           
           relatedProject = [SELECT Id, Name, Status__c,Status_Comments__c ,Deadline__c ,Parent_Project__c,Parent_Project__r.Name From Milestone1_Project__c WHERE Related_Case__r.Id IN :AllCaseIds];
                   
            for(case cs: AllCases ) {
                 if(cs.Related_CMT_Project__c != null) {
                         for(Milestone1_Project__c projct : relatedProject ) {
                             if(projct.id == cs.Related_CMT_Project__c){
                                 for(integer i=0;i<IntStatus.size();i++){
                                    if(projct.Status__c == IntStatus[i]){
                                        AllCasesStatus.add(new CaseDetail2Status(cs,ExtStatus[i])) ;
                                        break;
                                    }
                                 }
                             }
                         }
                     }
                     else{
                        AllCasesStatus.add(new CaseDetail2Status(cs,cs.Status)) ;
                     }
            }  
                 
           
            return AllCasesStatus;            
        }
        catch (Exception ex) {
            error = ex.getMessage();  
            System.debug('The following exception has occurred : ' + ex.getMessage());
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Error:' + ex.getMessage());
            ApexPages.addMessage(myMsg);        
            return null;
        }
    }
    
    public List<Case> getOpenCases() {
        try {
            Schema.DescribeSObjectResult CaseDescribe = Schema.SObjectType.Case; 
            Map<String,Schema.RecordTypeInfo> CaseRtMapByName = CaseDescribe.getRecordTypeInfosByName();
            
            sfCaseRCTypeId = CaseRtMapByName.get('SF Case').getRecordTypeId();
            sfCaseAccessRCTypeId = CaseRtMapByName.get('SF Case Access').getRecordTypeId();
            sfCaseDataRCTypeId = CaseRtMapByName.get('SF Case Data').getRecordTypeId();
            sfCaseEnhancementRCTypeId = CaseRtMapByName.get('SF Case Enhancement').getRecordTypeId();

            total_size = [SELECT count() FROM Case WHERE CreatedBy.Id = :userId and status != 'Closed' ];  
            lastPage = (math.mod(total_size, list_size) == 0)?((total_size/list_size)):((total_size/list_size)+1);
            
            List<Case> AllCases = [SELECT Id, CaseNumber, Request_Title__c, Description, CreatedDate, SF_Case_Category__c, CreatedBy.Name, Data_Upload_Type__c, Leaver_Name__c, RecordTypeId, Status 
                                 FROM Case WHERE CreatedBy.Id = :userId AND status != 'Closed' AND 
                                ((RecordTypeId = :sfCaseRCTypeId ) OR (RecordTypeId = :sfCaseAccessRCTypeId) OR (RecordTypeId = :sfCaseDataRCTypeId) OR (RecordTypeId = :sfCaseEnhancementRCTypeId)) 
                                ORDER BY CreatedDate DESC LIMIT :list_size OFFSET :index];

            for (integer i = 0; i < AllCases.size(); i++) {
                if(AllCases[i].SF_Case_Category__c  == 'Data') {                
                    AllCases[i].Description = 'Request for a data upload.';
                }
                else if(AllCases[i].SF_Case_Category__c == 'User Account') {
                    AllCases[i].Description = 'Requset for an account termination.';
                }
                
                 
            }
            return AllCases;            
        }
        catch (Exception ex) {
            error = ex.getMessage();  
            System.debug('The following exception has occurred : ' + ex.getMessage());
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Error:' + ex.getMessage());
            ApexPages.addMessage(myMsg);        
            return null;
        }
    }  

    public List<Case> getClosedCases() {
        try {        
            Schema.DescribeSObjectResult CaseDescribe = Schema.SObjectType.Case; 
            Map<String,Schema.RecordTypeInfo> CaseRtMapByName = CaseDescribe.getRecordTypeInfosByName();
            
            sfCaseRCTypeId = CaseRtMapByName.get('SF Case').getRecordTypeId();
            sfCaseAccessRCTypeId = CaseRtMapByName.get('SF Case Access').getRecordTypeId();
            sfCaseDataRCTypeId = CaseRtMapByName.get('SF Case Data').getRecordTypeId();
            sfCaseEnhancementRCTypeId = CaseRtMapByName.get('SF Case Enhancement').getRecordTypeId();        
            
            total_size = [SELECT count() FROM Case WHERE CreatedBy.Id = :userId and status = 'Closed']; 
            lastPage = (math.mod(total_size, list_size)==0)?(total_size/list_size):((total_size/list_size)+1);
            
            List<Case> AllCases = [SELECT CaseNumber, Request_Title__c, Description, CreatedDate, ClosedDate, SF_Case_Category__c, CreatedBy.Name, 
                                RecordTypeId FROM Case WHERE CreatedBy.Id =: userId AND status = 'Closed' AND
                                ((RecordTypeId = :sfCaseRCTypeId ) OR (RecordTypeId = :sfCaseAccessRCTypeId) OR (RecordTypeId = :sfCaseDataRCTypeId) OR (RecordTypeId = :sfCaseEnhancementRCTypeId)) 
                                ORDER BY CreatedDate DESC LIMIT :list_size OFFSET :index];
            
            for (integer i = 0; i < AllCases.size(); i++) {
                if(AllCases[i].SF_Case_Category__c  == 'Data') {                
                    AllCases[i].Description = 'Request for a data upload.';
                }
                else if(AllCases[i].SF_Case_Category__c == 'User Account') {
                    AllCases[i].Description = 'Request for an account termination.';
                }            
            }
            return AllCases;
        }
        catch (Exception ex) {
            error = ex.getMessage();  
            System.debug('The following exception has occurred : ' + ex.getMessage());
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Error:' + ex.getMessage());
            ApexPages.addMessage(myMsg);        
            return null;
        }        
    }  

    /* Pagination methods starts */
    public PageReference Beginning() { //user clicked beginning
        index = 0;
        currentPage = 1;
        return null;
    }
    public PageReference Previous() { //user clicked previous button
        index -= list_size;
        currentPage--;
        return null;
    }
    public PageReference Next() { //user clicked next button
        index += list_size;
        currentPage++;
        return null;
    }
    public PageReference End() { //user clicked end
        index = (math.mod(total_size, list_size) == 0)?((total_size - list_size)-1):(total_size - math.mod(total_size, list_size));
        currentPage = lastPage;
        return null;
    }
    public Boolean getDisablePrevious() { 
        //this will disable the previous and beginning buttons
        if (index > 0) return false; else return true;
    }
    public Boolean getDisableNext() { //this will disable the next and end buttons
        if (index + list_size < total_size) return false; else return true;
    }
    public Integer getTotal_size() {
        return total_size;
    }
    public Integer getPageNumber() {
        return index/list_size + 1;
    }
    public Integer getTotalPages() {
        if (math.mod(total_size, list_size) == 0) {
            return total_size/list_size;
        } 
        else {
            return total_size/list_size + 1;
        }
    }
    /* Pagination ends */
    
    public class CaseDetail2Status {
         public Case cs {get; set;}
        public string status {get; set;}
        public CaseDetail2Status(Case c,String Stat) {
            cs = c;
            status = Stat;
        }
    }

}