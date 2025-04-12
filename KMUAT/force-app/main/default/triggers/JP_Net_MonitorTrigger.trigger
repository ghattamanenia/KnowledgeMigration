/**
 * 
 */

trigger JP_Net_MonitorTrigger on JP_Net_Monitor__c(after update){

    if(Trigger.New.size() <= 50){
        JP_FieldHistory handler = new JP_FieldHistory();
        handler.doNet_Monitor(Trigger.oldMap, Trigger.New);
    }

}