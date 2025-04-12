/**
 * 
 */

trigger JP_PO_DetailTrigger on JP_PO_Detail__c(after update){

    if(Trigger.New.size() <= 50){
        JP_FieldHistory handler = new JP_FieldHistory();
        handler.doPO_Detail(Trigger.oldMap, Trigger.New);
    }
    
}