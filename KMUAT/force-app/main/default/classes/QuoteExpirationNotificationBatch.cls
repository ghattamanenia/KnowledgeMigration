global class QuoteExpirationNotificationBatch implements Database.Batchable<sObject>,database.stateful
{
   
  string query='Select Id,Name,OwnerId,Owner.Name,Owner.Email from SBQQ__Quote__c where SBQQ__Primary__c=true and SBQQ__ExpirationDate__c=NEXT_N_DAYS:7 and SBQQ__Opportunity2__r.isclosed=False';
   Map<Id,User> UserMap = new Map<Id,User>();
   Map<Id,list<SBQQ__Quote__c>> OwnerIdQuoteList = new Map<Id,List<SBQQ__Quote__c>>();
   Map<Id,String> QuoteOwnerIdEmail = new Map<Id,string>();
   global Database.QueryLocator start(Database.BatchableContext BC)
   {
        return Database.getQueryLocator(query);
   }
   
   global QuoteExpirationNotificationBatch()
   {
       UserMap=new Map<Id,user>([select Id,Email from User where isactive=true]);
   }

   global void execute(Database.BatchableContext BC,List<sObject> scope)
   {
      string QuoteId='';
      set<string> QuoteIds = new set<string>();
      for(Sobject s : scope)
      {
        SBQQ__Quote__c Quote = new SBQQ__Quote__c();
        Quote=(SBQQ__Quote__c)s;
        system.debug('@@@@@Quote'+Quote);
        QuoteId=Quote.Id;
        QuoteIds.add(QuoteId);
        list<SBQQ__Quote__c> Quotetys = new list<SBQQ__Quote__c>();
        if(OwnerIdQuoteList.keyset().contains(Quote.OwnerId))
        {
            Quotetys=OwnerIdQuoteList.get(Quote.ownerId);
        }
        Quotetys.add(Quote);
        OwnerIdQuoteList.put(Quote.OwnerId,Quotetys);
        
      }   

       system.debug('@@@@@ final map of OwnerIdQuoteList'+OwnerIdQuoteList);
       
       //   here you go 
        string str='';
        for(SBQQ__Quote__c ol:[Select Id,Name,OwnerId,Owner.Email from SBQQ__Quote__c where Id IN :QuoteIds])
        {
            if(UserMap.keyset().contains(ol.OwnerId))
            QuoteOwnerIdEmail.put(ol.OwnerId,UserMap.get(ol.OwnerId).Email);
        }
        
              
   }

   global void finish(Database.BatchableContext BC)
   {
        
        system.debug('@@@@@@OwnerIdQuoteList in finish'+OwnerIdQuoteList);
        system.debug('@@@@@@QuoteOwnerIdEmail in finish'+QuoteOwnerIdEmail);
        if(!OwnerIdQuoteList.isempty())
        QuoteExpirationNotificationBatchHelper.sendNotification(OwnerIdQuoteList,QuoteOwnerIdEmail);
        
        
   }

}