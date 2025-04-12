/**
 * 
 */

trigger JP_ContractInformationTrigger on JP_ContractInformation__c(after update){

    if(Trigger.New.size() <= 50){
        JP_FieldHistory handler = new JP_FieldHistory();
        handler.doContractInformation(Trigger.oldMap, Trigger.New);
    }
    
}