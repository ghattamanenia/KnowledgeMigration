global class Schedul_Batch_update_Account implements Schedulable{
    global void execute(SchedulableContext sc) {
        List<Account> Acc = new List<Account>();
        Acc   = [SELECT id from Account where Business__c = null and BillingCountry != null and Timezone_Updated__c = false limit 5];
       
        system.debug('***'+ Acc   );
        try{
            Database.update(Acc,false);
        }catch(Exception e){
            System.debug('Query Exception*******>'+e);
        }
    }
}