/**
 * 
 */

trigger JP_RequestInformationTrigger on JP_RequestInformation__c(after update){

    if(Trigger.New.size() <= 50){
        JP_FieldHistory handler = new JP_FieldHistory();
        handler.doRequestInformation(Trigger.oldMap, Trigger.New);
    }
    
}