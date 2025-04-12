/**
 * 
 */

trigger JP_SO_DetailTrigger on JP_SO_Detail__c(after update){

    if(Trigger.New.size() <= 50){
        JP_FieldHistory handler = new JP_FieldHistory();
        handler.doSO_Detail(Trigger.oldMap, Trigger.New);
    }
    
}