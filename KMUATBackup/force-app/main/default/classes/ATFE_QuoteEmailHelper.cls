public with sharing class ATFE_QuoteEmailHelper {
    public static boolean byPassCode = false ;

public static void SendEmailForOppOwner(List<Quote> newQuoteList, Map<Id,Quote> oldMap){
    System.debug('Entering into Sending Email:');
    Set<id> oppId = new Set<Id>();
    Map<id,id> oppOwners = new Map<Id,Id>();
    Map<Id,Id> quoteMap = new Map<Id,Id>();
    Map<Id,String> ownerMails = new Map<Id,String>();
    for(Quote quot : newQuoteList){
        if(quot.ATFE_Approval_Status__c == 'Waiting for Level 1' && oldMap.get(quot.id).ATFE_Approval_Status__c != 'Waiting for Level 1'){
            quoteMap.put(quot.id,quot.OpportunityId);
        }
    }
    if(quoteMap != null && quoteMap.size() > 0){      
        for(Opportunity opp : [select ownerId from Opportunity where id in :quoteMap.values()]){
            oppOwners.put(opp.id,opp.ownerId);
        }
        for(User user : [select Id ,Manager.Email from User where id in :oppOwners.values()]){
            if(user.Manager.Email != null)
                ownerMails.put(user.id , user.Manager.Email);
        }
        if(ownerMails != null && ownerMails.size() > 0)
            sendEmail(ownerMails,oppOwners,quoteMap);
    }
    
}
@future
public static void sendEmail(Map<Id,String> userMails,Map<id,id> oppOwners,Map<Id,Id>  quoteMap){
    System.debug('userMails:'+userMails);
    
 List<Quote> quotesToUpdate = new List<Quote>();
 set<id> quoteIds = new Set<Id>();
   
   try{
      for(QuoteLineItem qli : [select ATFE_Product_Type__c,QuoteId from QuoteLineItem where quoteId in :quoteMap.keySet()]){
          if(qli.ATFE_Product_Type__c != null && qli.ATFE_Product_Type__c == 'T - SERVICE')
              quoteIds.add(qli.QuoteId);
      }
       for(Id quoteId : quoteMap.keySet() ){
              String oppOwner = oppOwners.get(quoteMap.get(quoteId));
               String toAddresses = userMails.get(oppOwner);
              System.debug('oppOwner:'+oppOwner);
              System.debug('quoteId:'+quoteId);
              quote tempQuote = new Quote(id = quoteId , Quote_Opportunity_Owner__c = toAddresses );
              if(quoteIds.contains(quoteId))
                  tempQuote.ATFE_Send_Email_To_Service_Owner__c = true ;
              else
                 tempQuote.ATFE_Send_Email_To_Service_Owner__c = false ;
             quotesToUpdate.add(tempQuote) ;
            
          }
           System.debug('after send mail');
           ATFE_QuoteEmailHelper.byPassCode = true ;
          update quotesToUpdate ;
      }
         catch(Exception e){
             System.debug('exception is : '+e);
 }  
 }       
 /*
   The following Test method is used for covering above code
 
 @isTest(seealldata = true) 
 public static void TestSendEmailForOppOwner(){
   String userRegion = 'NA; EME';
    user userObj = [select id , Manager.Email from User where id =: userInfo.getUserId()];
   System.runAs(userObj){
     Pricebook2 stdPb = [select IsActive,Id,Name from Pricebook2 where isStandard = true limit 1];
        Account acc = new Account(Name = 'TestAccount',BillingCountry='USA',BillingCity='San Jose',BillingStreet='3200 North 1st Street',BillingState='New York',BillingPostalCode='94153',ATFE_AccountType__c ='End Customer', RecordTypeId= '01220000000HctC' , ATFE_Partner_Type__c ='Distributor' );
        insert acc ;
        Opportunity opp = new Opportunity(name ='TestOpp', StageName ='01 - Qualify',AccountId = acc.id,CloseDate = System.today().addDays(2));
        insert opp ;
        ATFE_QuoteCloneWithProducts.byPassQuoteTrigger = true ;
        System.debug('stdPb Id :'+stdPb.id);
        Product2 product1 = new Product2(Name='TestProduct',IsActive = true,ATFE_ProductType__c='T - SERVICE');
        Product2 product2 = new Product2(Name='TestProduct',IsActive = true,ATFE_ProductType__c='Test');
       List<Product2> prodList = new List<Product2>{product1,product2};
       insert prodList ;
   
        PricebookEntry pbe = new PricebookEntry(pricebook2id = stdPb.id, product2id = prodList[0].id, UnitPrice = 100.0, isActive = true,UseStandardPrice = false);
        PricebookEntry pbe1 = new PricebookEntry(pricebook2id = stdPb.id, product2id = prodList[1].id, UnitPrice = 100.0, isActive = true,UseStandardPrice = false);
        List<PricebookEntry> pbeList = new List<PricebookEntry> {pbe,pbe1};
        insert pbeList;
        
        Quote quo1 = new Quote(Pricebook2Id = stdPb.id, OpportunityId = opp.id, Name ='TestQuoe',ATFE_Partner_Name__c = acc.id,Quote_Opportunity_Owner__c = 'travis_phillips@alliedtelesis.com');
        insert quo1 ;
        
        QuoteLineItem qli = new QuoteLineItem(UnitPrice = 50.0,ATFE_MSRP__c = 10.0, QuoteId = quo1.id, Quantity = 2, PricebookEntryId = pbeList[0].id  ,
        PriceBook_Price_Amount__c = 100);
        QuoteLineItem qli1 = new QuoteLineItem(UnitPrice = 50.0,ATFE_MSRP__c = 10.0, QuoteId = quo1.id, Quantity = 2, PricebookEntryId = pbeList[1].id  ,
        PriceBook_Price_Amount__c = 100);
        List<QuoteLineItem> qliList = new List<QuoteLineItem>{qli,qli1};
         insert qliList ; 
         quo1.ATFE_Approval_Status__c = 'Waiting for Level 1' ;
         test.startTest();
         ATFE_QuoteEmailHelper.byPassCode = false ;
         update quo1 ;
         test.stopTest();
         quo1 = [select id, Quote_Opportunity_Owner__c,ATFE_Send_Email_To_Service_Owner__c from Quote where id =:quo1.id];
         System.assertEquals(userObj.Manager.Email ,quo1.Quote_Opportunity_Owner__c);
         System.assertEquals(true ,quo1.ATFE_Send_Email_To_Service_Owner__c);
         
   }
 }  */
 }