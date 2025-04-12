/*******************
Description: This cord is used to reflect the department of the owner in the field. 
Developer: Hitachi Solutions, Ltd.
Date Created: 10/4/2010
Date Modified: 6/7/2011
*****************/
/**
 * This is a Trigger of Opportunity
 *
 * ----Check below.----
 * At Unit test, we tried to make trigger-duplicate-execution-block function.
 * It is function that block trigger-duplicate-execution during workflow is moving.
 * We want to change this parameter value from true to false after first insert logic and back the value to true after second insert logic..
 * But this function haven't moved, because after second insert logic, the parameter "exeTR" defined at JP_CLContactGradeE, is taken over to update logic too.
 * So, now this function's code is comment-outed.
 */
trigger JP_TROpporunityUpsert on Opportunity (before insert, before update) {

    //The opportunity record type name and ID are made a list. 
    List<RecordType> RecordTypeList = [select Name,ID from RecordType where SobjectType ='Opportunity'];
    //The record type name and ID are put in oppmap.
    Map<String,Id> oppmap = new Map<String,Id>();
    for(Integer j=0; j<RecordTypeList.size(); j++){
        oppmap.put(RecordTypeList[j].Name,RecordTypeList[j].Id);
    }

    //----------------------------------------------------
    //  Define a variable
    //----------------------------------------------------

    List<Opportunity> JP_nList = new List<Opportunity>();
    Set <String> JP_strSet = new Set<String>();


    for(Integer i=0; i< Trigger.new.size(); i++){

        //----------------------------------------------------
        //  This is Japan Logic
        //----------------------------------------------------
        //record type ID of the trigger object record is corresponding to record type ID of "JP_Opportunity", it processes it.       
        if(Trigger.new[i].RecordTypeId == oppmap.get('JP_Opportunity')){
            // insert and update logic
            if((Trigger.isInsert) || (Trigger.new[i].OwnerId != Trigger.old[i].OwnerId)){
                if(Trigger.new[i].JP_NoTriggerFlag__c != true){
                    JP_nList.add(Trigger.new[i]);
                    JP_strSet.add(trigger.new[i].ownerId);
                }
            }
            Trigger.new[i].JP_NoTriggerFlag__c = false;
        }

    }

    //----------------------------------------------------
    //  This is Japan Logic
    //----------------------------------------------------
    if(JP_nList.size()>0){
        // Set opportunity owner department.
        System.debug('★★★Opportunity★★★');
        JP_CLOpportunityOwnerDept oppOwnerDept = new JP_CLOpportunityOwnerDept();
        oppOwnerDept.deptValChange(JP_nList,JP_strSet);
    }

}