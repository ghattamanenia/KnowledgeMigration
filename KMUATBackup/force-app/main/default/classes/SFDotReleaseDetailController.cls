public without sharing class SFDotReleaseDetailController {
    public boolean ShowOpen {get; set;}
    public boolean ShowClosed {get;set;}

    public String caseType {get;set;}
    public String description {get;set;}
    public PageReference nextPage;
    //public List<Case> AllCases {get;set;}
    public Integer currentPage {get;set;}
    public Integer lastPage {get;set;}  
    public Integer totalPages {get;set;}  
    
    public Milestone1_Project__c  ParentProject{get;set;} 

    public String error {get;set;}  

    private Id sfPrjEnhancementRCTypeId;
    private Id sfPrjDotRelParentId;
    private Id sfPrjDotRelChildId;
    private Id ParentID;
    
    private Integer total_size;     
    private Integer index = 0;
    private Integer list_size = 10;

    public User user {get;set;}
    private Id ContId;
    private String userId; 
    
    public String CasesByStatus {get;set;}

    public SFDotReleaseDetailController () {

        ShowOpen = true;
        ShowClosed = false;
        
        ParentID = ApexPages.currentPage().getParameters().get('id');

        try {
        
            currentPage = 1;
            Schema.DescribeSObjectResult PrjctDescribe = Schema.SObjectType.Milestone1_Project__c; 
            Map<String,Schema.RecordTypeInfo> PrjctRtMapByName = PrjctDescribe.getRecordTypeInfosByName();
            
            sfPrjEnhancementRCTypeId = PrjctRtMapByName.get('Enhancement').getRecordTypeId();
            sfPrjDotRelParentId = PrjctRtMapByName.get('Dot Release Parent').getRecordTypeId();
            sfPrjDotRelChildId = PrjctRtMapByName.get('Dot Release Child').getRecordTypeId();
            
            
            ParentProject = [SELECT Id, Name, Status__c,Description__c,CreatedDate, RecordTypeId,Deadline__c 
                                FROM Milestone1_Project__c WHERE id = :ParentID ];
            //total_size = [SELECT count() FROM Milestone1_Project__c WHERE CreatedBy.Id =: userId ];  
            //lastPage = (math.mod(total_size, list_size)==0)?((total_size/list_size)):((total_size/list_size)+1);
        }
        catch (Exception ex) {
            error = ex.getMessage();  
            System.debug('The following exception has occurred : ' + ex.getMessage());
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Error:' + ex.getMessage());
            ApexPages.addMessage(myMsg);        
        }
    }

    public void ShowCases() {
       if(CasesByStatus == 'AllProjects') {
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
    
      public List<Milestone1_Project__c> getOpenCases() {
          return null;
      }
    
    public List<Milestone1_Project__c> getAllProjects() {
        try {
            
          

            total_size = [SELECT count() FROM Milestone1_Project__c WHERE Parent_Project__c =:ParentID  ];  
            lastPage = (math.mod(total_size, list_size) == 0)?((total_size/list_size)):((total_size/list_size)+1);
            
            List<Milestone1_Project__c > AllProjects = [SELECT Id, Name, Status__c,Description__c,CreatedDate, RecordTypeId,Deadline__c 
                                FROM Milestone1_Project__c WHERE Parent_Project__c =:ParentID 
                                ORDER BY CreatedDate DESC LIMIT :list_size OFFSET :index];

            
            return AllProjects ;            
        }
        catch (Exception ex) {
            error = ex.getMessage();  
            System.debug('The following exception has occurred : ' + ex.getMessage());
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Error:' + ex.getMessage());
            ApexPages.addMessage(myMsg);        
            return null;
        }
    }  
    
     public List<Milestone1_Project__c> getClosedCases() {
          return null;
          
           //OR Recordtypeid = :sfPrjDotRelParentId
      }
      
    public List<Milestone1_Project__c > getAllParentDotRel() {
        try {        
                    
            
            total_size = [SELECT count() FROM Milestone1_Project__c WHERE status__c = 'Complete' and (Recordtypeid = :sfPrjEnhancementRCTypeId OR Recordtypeid = :sfPrjDotRelParentId ) ];  
            lastPage = (math.mod(total_size, list_size) == 0)?((total_size/list_size)):((total_size/list_size)+1);
            
            List<Milestone1_Project__c > AllProjects = [SELECT Id, Name, Status__c,Description__c, CreatedDate,RecordTypeId,Deadline__c 
                                FROM Milestone1_Project__c WHERE  status__c != 'Completed' AND 
                                (Recordtypeid = :sfPrjDotRelParentId ) 
                                ORDER BY CreatedDate DESC LIMIT :list_size OFFSET :index];
                                
           return AllProjects ;       
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
}