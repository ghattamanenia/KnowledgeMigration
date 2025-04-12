public /*with sharing*/ class CustomerCommunityArticleController {
  // public Question_Answer__kav article{get;set;} 
  public boolean showpage {get;set;}
  public boolean showattach1{get;set;}
  public boolean showattach2{get;set;}
  public boolean showattach3{get;set;}
  public boolean showattach4{get;set;}
  public boolean showattach5{get;set;}
  public boolean showattachSection{get;set;}
  
  public CustomerCommunityArticleController() {
    String articleId = ApexPages.currentPage().getParameters().get('articleId');

    // article = [SELECT Id, KnowledgeArticleId, Language, Title, UrlName, Summary, ArticleNumber, 
    // Question__c, Answers__c FROM Question_Answer__kav WHERE Id = :articleId AND PublishStatus='Online' AND Language = 'en_US'];
    try 
    {
      showpage = true;     
      showattach1 = false; 
      showattach2 = false; 
      showattach3 = false; 
      showattach4 = false; 
      showattach5 = false; 
      showattachSection = false;
      /* 
      article = [SELECT Id, KnowledgeArticleId, Language, Title, UrlName, Summary, ArticleNumber, 
            Question__c, Answers__c,
            Attachment1__Length__s,Attachment2__Length__s,Attachment3__Length__s,Attachment4__Length__s,Attachment5__Length__s, 
            Attachment1__Name__s ,Attachment2__Name__s ,Attachment3__Name__s ,Attachment4__Name__s ,Attachment5__Name__s , 
            Attachment1__Body__s ,Attachment2__Body__s ,Attachment3__Body__s ,Attachment4__Body__s ,Attachment5__Body__s
            FROM Question_Answer__kav WHERE Id = :articleId AND PublishStatus='Online' AND Language = 'en_US'];    
       
       if(article.Attachment1__Length__s > 0)
           showattach1 = true;
       if(article.Attachment2__Length__s > 0)
           showattach2 = true;
       if(article.Attachment3__Length__s > 0)
           showattach3 = true;
       if(article.Attachment4__Length__s > 0)
           showattach4 = true;
       if(article.Attachment5__Length__s > 0)
           showattach5 = true;
       
       showattachSection = showattach1 || showattach2 || showattach3 || showattach4 || showattach5;  
         */  
    } 
    catch(Exception e) 
    {
      //System.debug('An exception occurred retrieving article: ' + e.getMessage());
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'<div class="errorMsgMargin">Unfortunately, there was an issue with your request.</div> If the issue continues, please contact Allied Telesis Technical Support.'));
      showpage = false;
      return;
    } 
    finally 
    {
           
    }
  }
}