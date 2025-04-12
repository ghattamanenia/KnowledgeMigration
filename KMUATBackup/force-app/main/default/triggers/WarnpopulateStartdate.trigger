trigger WarnpopulateStartdate on Warranty_Items__c (before insert/*,before update*/) {
 List<Id> lstAsst=new  List<Id>();
 List<Warranty_Items__c > lstWarnty=new  List<Warranty_Items__c >();
 
 for(Warranty_Items__c Wrn: trigger.new){
     lstAsst.add(wrn.HW_Asset__c);
     lstWarnty.add(wrn);
     }
   List <Asset__c> asst = [Select Id,Start_Date__c from Asset__c where Id In : lstAsst];
   list<Asset__c> asstList = new list<Asset__c>();
   
   for(Asset__c newAsset : asst){
       for(Warranty_Items__c wrn1: lstWarnty){
           if(wrn1.HW_Asset__c==newAsset.Id){
               wrn1.Warranty_Start_Date__c= newAsset.Start_Date__c;
               system.debug('****Duration in days***1'+wrn1.Duration__c);
               if(wrn1.Duration__c !=null){
                   Integer numDays =(Integer)wrn1.Duration__c;
                   wrn1.Warranty_End_Date__c = wrn1.Warranty_Start_Date__c.addDays(numDays);
                   system.debug('****Duration in days***1'+wrn1.Duration__c);                   
                   asstList.add(new Asset__c(ID=newAsset.ID,End_Date__c=wrn1.Warranty_End_Date__c));
                   }
           }
       } 
   } 
   
   if(asstList != null && asstList.size() >0)
   {
    update asstList;
   }
   
         
           
}