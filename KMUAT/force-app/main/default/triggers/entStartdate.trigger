trigger entStartdate on Entitlement (before insert,before update) {
 /*List<Id> lstAsst=new  List<Id>();
 List<Entitlement> lstWarnty=new  List<Entitlement>();
 List <Asset__c> asst = new List <Asset__c>();
 for(Entitlement Wrn: trigger.new){
     lstAsst.add(wrn.HW_Asset__c);
     lstWarnty.add(wrn);
     }
   if(lstAsst.size()>0){
      asst = [Select Id,Start_Date__c from Asset__c where Id In : lstAsst];  
   }     
   if(asst.size()>0){
       for(Asset__c newAsset : asst){
           for(Entitlement wrn1: lstWarnty){
               if(wrn1.HW_Asset__c==newAsset.Id){
                   wrn1.StartDate= newAsset.Start_Date__c;
                   system.debug('***'+wrn1.StartDate );
                   if(wrn1.Term_Days__c !=null){
                       Integer numDays =(Integer)wrn1.Term_Days__c ;
                       if(wrn1.StartDate!= null)// modified by ravinder
                           wrn1.EndDate= wrn1.StartDate.addDays(numDays);
                           
                       }
               }
           } 
       }  
   } */        
           
}