/**
 * 
 */

trigger JP_ConsignmentInformationTrigger on JP_ConsignmentInformation__c(after update){

    if(Trigger.New.size() <= 50){
        JP_FieldHistory handler = new JP_FieldHistory();
        handler.doConsignmentInformation(Trigger.oldMap, Trigger.New);
    }
    
}