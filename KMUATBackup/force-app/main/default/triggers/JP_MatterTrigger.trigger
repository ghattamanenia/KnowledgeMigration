/**
 * 
 */

trigger JP_MatterTrigger on JP_Matter__c(after update){

    if(Trigger.New.size() <= 50){
        JP_FieldHistory handler = new JP_FieldHistory();
        handler.doMatter(Trigger.oldMap, Trigger.New);
    }

}