/**
 * 
 */

trigger JP_MachineInformationTrigger on JP_MachineInformation__c(after update){

    if(Trigger.New.size() <= 50){
        JP_FieldHistory handler = new JP_FieldHistory();
        handler.doMachineInformation(Trigger.oldMap, Trigger.New);
    }
    
}