/*******************
Description: This cord is used to change the record type of the customer, the name by grade.
Developer: Hitachi Solutions, Ltd.
Date Created: 10/1/2010
Date Modified: 6/7/2011
*****************/
/**
 * This is a Trigger of Contact
 *
 * ----Check below.----
 * At Unit test, we tried to make trigger-duplicate-execution-block function.
 * It is function that block trigger-duplicate-execution during workflow is moving.
 * We want to change this parameter value from true to false after first insert logic and back the value to true after second insert logic..
 * But this function haven't moved, because after second insert logic, the parameter "exeTR" defined at JP_CLContactGradeE, is taken over to update logic too.
 * So, now this function's code is comment-outed.
 */
trigger JP_TRContactUpsert on Contact (before insert, before update) {

    //Customer's record type name and ID are made a list. 
    List<RecordType> RecordTypeList = [select Name,ID from RecordType where SObjectType ='Contact' order by name];
    //The record type name and ID are put in RecordTypeMap. 
    Map<String, Id> RecordTypeMap = new Map<String, Id>();
    for(Integer i = 0; i < RecordTypeList.size(); i++){
        RecordTypeMap.put(RecordTypeList[i].Name,RecordTypeList[i].Id);
    }

    //----------------------------------------------------
    //  Define a variable
    //----------------------------------------------------
    List<Contact> JP_oList = new List<Contact>();
    List<Contact> JP_nList = new List<Contact>();
    Boolean isIns = false;


    for(Integer i=0; i< Trigger.new.size(); i++){

        //----------------------------------------------------
        //  This is Japan Logic
        //----------------------------------------------------
        System.debug(Trigger.new[i].RecordTypeId + '★★★'+ RecordTypeMap.get('JP_Contacts(GradeE)') + '★★★'+ RecordTypeMap.get('JP_Contacts') + '★★★' + RecordTypeMap.get('JP_ContactsBeforeCleansing'));
        //record type ID of the trigger object record is corresponding to record type ID of Japan Record Type, it processes it. 
        if((Trigger.new[i].RecordTypeId ==RecordTypeMap.get('JP_Contacts(GradeE)') || Trigger.new[i].RecordTypeId ==RecordTypeMap.get('JP_Contacts') || Trigger.new[i].RecordTypeId ==RecordTypeMap.get('JP_ContactsBeforeCleansing') )){
            // insert and update logic
            if(Trigger.new[i].JP_NoTriggerFlag__c != true){
                JP_nList.add(Trigger.new[i]);
                // insert logic
                if(Trigger.isInsert){
                    isIns = true;
                }
                // update logic
                if(Trigger.isUpdate){
                    JP_oList.add(Trigger.old[i]);
                }
            }
            Trigger.new[i].JP_NoTriggerFlag__c = false;
        }
        
    }

    //----------------------------------------------------
    //  This is Japan Logic
    //----------------------------------------------------
    if(JP_nList.size() > 0){
        // Execute change contact's grade logic
        System.debug('★★★GradeE★★★');
        JP_CLContactGradeE trUps = new JP_CLContactGradeE();
        trUps.grade_e_Rename(JP_oList,JP_nList,isIns);
        trUps.grade_e_Backname(JP_oList,JP_nList,isIns);
    }

}