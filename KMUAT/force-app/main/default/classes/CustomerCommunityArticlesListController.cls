public with sharing class CustomerCommunityArticlesListController {
    // public List<Question_Answer__kav> articles {get;set;}
    public String searchTerm {get;set;}

    public CustomerCommunityArticlesListController() {
        try {        
            searchTerm = ApexPages.currentPage().getParameters().get('searchTerm');
            String articleId = ApexPages.currentPage().getParameters().get('articleId');
            String keyword = '%' + searchTerm + '%';
            system.debug('@@keyword'+keyword);
            system.debug('@@searchTerm '+searchTerm );
            /*if(searchTerm!='')
            articles = [SELECT Id, KnowledgeArticleId, Language, Title, UrlName, Summary, ArticleNumber, ArticleType, 
                        Question__c, Answers__c FROM Question_Answer__kav WHERE PublishStatus='Online' AND Language = 'en_US' 
                        AND (Title like :keyword OR Summary like :keyword)];
             // Below condition is added by Neha for Article size limit from custom label         
            else
            {
               
            integer i=integer.valueof(label.Article_Limit);
            string query=' SELECT Id, KnowledgeArticleId, Language, Title, UrlName, Summary, ArticleNumber, ArticleType, Question__c, Answers__c FROM Question_Answer__kav WHERE PublishStatus=\'Online\' AND Language=\'en_US\' limit '+i;
            system.debug(query);
            articles=database.query(query);  
            
            } */
        }
        catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 
            'There was an error while searching your request. ' + ex)
            );
            
            return;
        }
    }

    public PageReference BackPage() {        
        PageReference prevPage = Page.CustomerCommunityLoggedIn;
        prevPage.setRedirect(true);
        return prevPage; 
    }

    public void searchKB() {
    /*
    system.debug('@@@@ searchTerm '+searchTerm);
        try {
            
            
            String keyword = '%' + searchTerm + '%';
            if(searchTerm!='')
            {
             articles = [SELECT Id, KnowledgeArticleId, Language, Title, UrlName, Summary, ArticleNumber, ArticleType, 
                        Question__c, Answers__c FROM Question_Answer__kav WHERE PublishStatus='Online' AND Language = 'en_US'
                        AND Title like: keyword]; 
            } 
            else
            {
                integer i=integer.valueof(label.Article_Limit);
                string query=' SELECT Id, KnowledgeArticleId, Language, Title, UrlName, Summary, ArticleNumber, ArticleType, Question__c, Answers__c FROM Question_Answer__kav WHERE PublishStatus=\'Online\' AND Language=\'en_US\' limit '+i;
                system.debug(query);
                articles=database.query(query);
            }
            
                 
        }
        catch (Exception ex) {
            //System.debug('An exception occurred retrieving article: ' + e.getMessage());
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 
                'There was an error while searching your request. ' + ex)
            );
           
            return;
        } */
       
    }
    
   
    
}