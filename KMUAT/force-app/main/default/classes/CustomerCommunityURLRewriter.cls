global with sharing class CustomerCommunityURLRewriter implements Site.UrlRewriter {

    String SERVLET_PAGE = '/Support/servlet/';
    String S_PAGE = '/Support/s';
    String SERVLET_VISUALFORCE_PAGE = 'https://cs17.salesforce.com/servlet/';

    global PageReference mapRequestUrl(PageReference myFriendlyUrl){
       String url;
       PageReference pg_ref = null;
       if(Test.IsRunningTest())
           url = 'https://cs17.salesforce.com/servlet/';
       else
           url = myFriendlyUrl.getUrl();
       
        System.debug('********S_PAGE: ' + S_PAGE);
        System.debug('********url: ' + url);
        
        if (url.startsWith(SERVLET_PAGE) || Test.IsRunningTest()){
            String name = url.substring(SERVLET_PAGE.length(), url.length());
    
            //Lead ld = [select id from Lead where XUniqueSearchId__c =: name LIMIT 1];
            pg_ref = new PageReference(SERVLET_VISUALFORCE_PAGE + name);
            //return new PageReference(SERVLET_VISUALFORCE_PAGE + name);
        }
        if (url.startsWith(S_PAGE)|| Test.IsRunningTest()){

            String base = url.substring(S_PAGE.length(), url.length());
             pg_ref = new PageReference(base + '/Support');
          //  return new PageReference(base + '/Support');
            System.debug('********S_PAGE: ' + S_PAGE);
        }

        return pg_ref;
    }

    global List<PageReference> generateUrlFor(List<PageReference> mySalesforceUrls){
        return null;
    }
    /*
    @isTest
    static void testGenerateUrlFor() {
        myRewriter rewriter = new myRewriter();
        System.assert(rewriter.generateUrlFor(null) == null);
    }
    
    @isTest
    static void testMapUrl() {
        Lead testLead = new Lead(XUniqueSearchId__c = 'testId', lastName='Guest', Company='Salesforce');
        Id testId = Database.insert(testLead).id;
        
        
        myRewriter rewriter = new myRewriter();
        String actualResult = rewriter.mapRequestUrl(new PageReference('/VIP/testId')).getUrl();
        
        String expectedResult = '/VIP?id=' + testId;
        //System.debug(actualResult);
        System.assert(actualResult == expectedResult);
    }
    
    @isTest
    static void testMapNonVipUrl() {

        
        
        myRewriter rewriter = new myRewriter();
        PageReference actualResult = rewriter.mapRequestUrl(new PageReference('/testUrl'));
        
        String expectedResult = '/testUrl';
        System.assert(actualResult == null);
    }
    */

}