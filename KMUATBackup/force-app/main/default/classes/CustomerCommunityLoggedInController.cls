public /*with sharing*/ class CustomerCommunityLoggedInController {

    public String getGetcaseResult() {
        return null;
    }

    public String name{get;set;}
    public String caseStatus{get;set;}
    public List<Question_Answer__kav> qa{get;set;}
    //public List<Case> caseResult{get;set;}
    //public Account account{get;set;}
    //public Contact contact{get;set;}
    public User user{get;set;}
    public String searchTerm {get;set;}
    public String error{get;set;}
    public Integer currentPage{get;set;}
    public Integer lastPage{get;set;}
    
    private integer totalRecs = 0;     
    private integer index = 0;
    private integer blockSize = 10;
    
    private Id CaseATIRCTypeId;
    // private Id CaseRMAChildTypeId;
    // private Id CaseAddHwTypeId;
    private id CaseRMAParentTypeId;
    private Id ContId;
    // Code we will invoke on page load.
    public PageReference forwardToCustomAuthPage() {

        if((UserInfo.getUserType() == 'Guest') || (Test.IsRunningTest() && UserInfo.getUserType() == 'Standard')){
            return new PageReference('/CustomerCommunityHome');
        }
        else{
            return null;
        }
    }
    public List<Case> getcaseRslt() 
    {
       // membs = Database.Query('SELECT Name, Age__c FROM Member__c LIMIT :blockSize OFFSET :index');
     // string QueryString = 'SELECT Id, Request_Title__c, CaseNumber, CreatedDate, Description, Status, ContactId,RecordTypeId  from Case Where ContactId = \''+ ContId +'\' AND ((RecordTypeId = \''+ CaseATIRCTypeId +'\') OR (RecordTypeId = \''+ CaseRMAParentTypeId +'\') ) LIMIT '+ blockSize+' OFFSET '+ index;
       //system.debug('::SARVINDER QUERY:::' + QueryString );
       
      string QueryString = 'SELECT Id, Request_Title__c, CaseNumber, CreatedDate, Description, Status, ContactId,RecordTypeId  from Case Where ContactId = \''+ ContId +'\' AND ((RecordTypeId = \''+ CaseATIRCTypeId +'\') OR (RecordTypeId = \''+ CaseRMAParentTypeId +'\') ) order by CreatedDate desc LIMIT '+ blockSize+' OFFSET '+ index;
       
       
        List<Case>  caseResult = Database.Query(QueryString );
       // AND ((RecordTypeId = '+ CaseATIRCTypeId' +) OR (RecordTypeId = '+CaseRMAChildTypeId+') OR (RecordTypeId = '+CaseAddHwTypeId+' ))LIMIT :blockSize OFFSET :index'
           
        //System.debug('Values are ' + caseResult );

        for (integer i = 0; i < caseResult.size(); i++){
            if(caseResult[i].Status != 'New' && caseResult[i].Status != 'Closed'){
                caseResult[i].Status = 'Open';
            }
        }

        return caseResult ;
    }    
     
    public void beginning()
    {
        index = 0;
        currentPage = 1;
    }
    
    public void previous()
    {
        index = index - blockSize;
        currentPage--;
    }
    
    public void next()
    {
        index = index + blockSize;
        currentPage++;
    }

    public void end()
    {
        //index = totalrecs - math.mod(totalRecs,blockSize);
        if(math.mod(totalRecs, blockSize)==0)
            index = totalrecs - blockSize; 
        else
        index = totalrecs - math.mod(totalRecs, blockSize);
        currentPage = lastPage;
    }  
    
     public boolean getprev()
    {
        if(index == 0)
            return true;
        else
            return false;
    }  
    
    public boolean getnxt()
    {
        if((index + blockSize) >= totalRecs)
            return true;
        else
            return false;
    }     

    public PageReference searchKB() {        
        PageReference KBArticlesListPage = Page.CustomerCommunityArticlesList;
        KBArticlesListPage.setRedirect(true);
        KBArticlesListPage.getParameters().put('searchTerm', searchTerm); 
        return KBArticlesListPage; 
    }

    public CustomerCommunityLoggedInController() {
        error = '';
        currentPage = 1;
        name = UserInfo.getName();
        
        system.debug('userid' + UserInfo.getUserId());
        
        List<RecordType> AllCaseRT = [SELECT Id, DeveloperName  FROM RecordType where Sobjecttype = 'Case'];
       
        for(RecordType CaseRT : AllCaseRT )
        {
            if(CaseRT.DeveloperName == 'ATI_Case')
                CaseATIRCTypeId = CaseRT.ID;
            if(CaseRT.DeveloperName == 'ATI_RMA_Parent_Case')
                CaseRMAParentTypeId = CaseRT.ID;
        }
    
        
        try{
            qa = [SELECT Id, KnowledgeArticleId, PublishStatus, VersionNumber, IsLatestVersion, IsVisibleInCsp, 
                    IsVisibleInPrm, IsVisibleInApp, IsVisibleInPkb, Language, Title, UrlName, Summary, ArticleNumber, 
                    IsOutOfDate, ArticleType, Question__c, Answers__c FROM Question_Answer__kav 
                    WHERE PublishStatus='Online' AND Language = 'en_US' LIMIT 5] ;//AND (IsVisibleInPkb = true OR IsVisibleInCsp = true) AND IsVisibleInApp = true];
            system.debug('query result:::->' + qa.size());
            // Getting Case Info
          
            user = [SELECT Id, AccountId, ContactId from user where Id =: UserInfo.getUserId()];
            ContId = user.ContactId; //user.ContactId;
            totalRecs  = [select count()  from Case Where ContactId =:ContId  AND ((RecordTypeId = :CaseATIRCTypeId) OR (RecordTypeId = :CaseRMAParentTypeId ) )];
            lastPage = (math.mod(totalRecs, blockSize)==0)?(totalrecs/blockSize):((totalrecs/blockSize)+1);
            //totalRecs  = caseResult.size();
            //contact = [SELECT Id, AccountId from contact where Id =:user.ContactId];
            //account = [SELECT Id from Account where Id =: contact.AccountId]; 
           // ApexPages.currentPage().getParameters().put('AccId', user.AccountId);
        }
        catch (Exception ex) {
            error = ex.getMessage();  
            System.debug('The following exception has occurred : ' + ex.getMessage());
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Error:' + ex.getMessage());
            ApexPages.addMessage(myMsg);        
        }

    }
}