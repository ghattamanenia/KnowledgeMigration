public with sharing class PublisherActionCaseCommentController {

    private final SObject parent;
    public Case_Comment__c theCaseComment {get; set;}
    public String lastError {get; set;}
    
    public PublisherActionCaseCommentController(ApexPages.StandardController controller) {
        parent = controller.getRecord();
        theCaseComment = new Case_Comment__c();// Case();
        theCaseComment.Case__c = parent.id;
        lastError = '';
    }
      
    public PageReference createCaseComment() {
        createNewCaseComment();
        theCaseComment = new Case_Comment__c();
        theCaseComment.Case__c = parent.id;
        return null;
    }  

       
     private void createNewCaseComment() {      
        try {
            insert theCaseComment;
           
           /* String publicStatus = 'No'; // commented by sarvinder - inserting case comment 'll add a feed too 

            if (theCaseComment.Public__c == true){
                publicStatus = 'Yes';
            }
            
            //ApexPages.currentPage().getHeaders().get('Host') + '/' + theCaseComment.id +' \n'
            
            FeedItem post = new FeedItem();
            post.ParentId = ApexPages.currentPage().getParameters().get('id');
            post.type = 'LinkPost'; 
            post.LinkUrl = '/' + theCaseComment.id;
            post.Title = 'Case Comment Link';
            post.Body = 'Case Comment: \n '
                        + 'Public: ' + publicStatus + '\n'
                        + theCaseComment.Comment__c;
            insert post;*/
        } 
        catch(System.Exception ex){
           lastError = ex.getMessage();
           System.debug('*****Error*****' + lastError);
        }
    }   



}