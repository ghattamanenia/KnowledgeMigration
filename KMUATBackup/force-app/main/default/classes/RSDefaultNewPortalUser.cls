public with sharing class RSDefaultNewPortalUser implements IRSNewPortalUser 
{

 // final static String categoryName = 'User Account';
 // final static String assignmentQName = 'Admin';
  //final static String urgencyName = 'LOW';
 // final static String impactName = 'HIGH';
 // final static String descr = 'Portal account requested';
  
  public PageReference execute(User user, String accountId, String password) {
    
   /* //lastName is a required field on user, but if it isn't specified, we'll default it to the usernam

       String userId = Site.createPortalUser(user, accountId, password);
        System.debug('UserId: '+userId);
        if (userId != null || Test.isRunningTest()) { 
    //  
              
              String catId = [select Id from BMCServiceDesk__Category__c where Name = :categoryName LIMIT 1].Id;
        String queueId = [select Id from Group where Name = :assignmentQName LIMIT 1].Id;
        String urgencyId = [select Id from BMCServiceDesk__Urgency__c where Name = :urgencyName LIMIT 1].Id;
        String impactId = [select Id from BMCServiceDesk__Impact__c where Name = :impactName LIMIT 1].Id;
        }
              
              
             // BMCServiceDesk__Incident__c inc  = new BMCServiceDesk__Incident__c(BMCServiceDesk__IncidentDescription__c=descr,BMCServiceDesk__FKClient__c=userId,BMCServiceDesk__FKCategory__c=catId,OwnerId=queueId,BMCServiceDesk__FKUrgency__c=urgencyId,  BMCServiceDesk__FKImpact__c=impactId);
              
              
              
              //if(!Test.isRunningTest())
            //  insert inc;
              
              
              
              
               // PageReference page = System.Page.SiteRegisterConfirm;
               // page.setRedirect(true);
               // return page;
               //return null;
            
       // }
   // else 
    
    //return null;
    
    
  } */
  return null;
  }


}