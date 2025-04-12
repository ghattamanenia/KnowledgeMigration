/**
 * An apex page controller that takes the user to the right start page based on credentials or lack thereof
 */
public with sharing class CustomerCommunityHomeController {

    public String username{get;set;}
    public String password{get;set;}
    public List<Question_Answer__kav> qa{get;set;}
    public String searchTerm {get;set;}
    public String error{get;set;}

    public PageReference forwardToCustomAuthPage() {
    
        system.debug('###usertype###' + UserInfo.getUserType());
        if((UserInfo.getUserType() == 'Guest') || (Test.IsRunningTest() && UserInfo.getUserType() == 'Standard')){
            return null;
        }
        else{
            return new PageReference('/CustomerCommunityLoggedIn');
        }
       
    }
    
    public PageReference selfreg() {
        return new PageReference( '/CustomerCommunitySelfReg');
    }
    
    public PageReference ForgotPassword () {
        return null;
    }
    
    public PageReference login() {
        if(username == '' || password == '' )
        {
            if(username == '')
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'User Name: Value is required.'));
            if(password == '')
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Password: Value is required.'));   
            return null;
        }
        
        PageReference result = Site.login(username, password, '/CustomerCommunityLoggedIn');
        system.debug('login result : ' + System.currentPageReference().getParameters());
        return result;
    }

    public PageReference searchKB() {        
        PageReference KBArticlesListPage = Page.CustomerCommunityArticlesList;
        KBArticlesListPage.setRedirect(true);
        KBArticlesListPage.getParameters().put('searchTerm',searchTerm); 
        return KBArticlesListPage; 
    }

    public CustomerCommunityHomeController() {
        error = '';        
        try{
            qa = [SELECT Id, KnowledgeArticleId, Language, Title, UrlName, Summary, ArticleNumber,  
                    Question__c, Answers__c FROM Question_Answer__kav 
                    WHERE PublishStatus='Online' AND Language = 'en_US' LIMIT 5];// AND IsVisibleInPkb = true  AND IsVisibleInApp = true];
        }
        catch (Exception ex) {
            error = ex.getMessage();
        }
    }
}