/**
 * 
 */

trigger JP_Allied_HikariTrigger on JP_Allied_Hikari__c(after update){

    if(Trigger.New.size() <= 50){
        JP_FieldHistory handler = new JP_FieldHistory();
        handler.doAllied_Hikari(Trigger.oldMap, Trigger.New);
    }
    
}