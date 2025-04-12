/**
 * 
 */

trigger JP_Net_CyberSecurityTrigger on JP_Net_CyberSecurity__c(after update){

    if(Trigger.New.size() <= 50){
        JP_FieldHistory handler = new JP_FieldHistory();
        handler.doNet_CyberSecurity(Trigger.oldMap, Trigger.New);
    }
    
}