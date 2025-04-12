/**
 * 
 */

trigger JP_Management_NoTrigger on JP_Management_No__c(after update){

    if(Trigger.New.size() <= 50){
        JP_FieldHistory handler = new JP_FieldHistory();
        handler.doManagement_No(Trigger.oldMap, Trigger.New);
    }
    
}