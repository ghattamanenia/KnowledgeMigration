/*******************
Description: This cord is used to upsert a record of CrossViewToDo, and to delete it.
Developer: Hitachi Solutions, Ltd.
Date Created: 11/30/2010
Date Modified: 6/7/2011
*****************/
/**
* This is a Trigger of Task
*/

trigger JP_TRToDoUpsert on Task (after insert, after update, before delete) {

    //The record type name and ID of ToDO are made a list.  
    List<RecordType> RecordTypeList = [select Name,Id from RecordType where SobjectType = 'Task'];
    //The record type name and ID of acquired ToDo are put in Todomap. 。
    Map<String,Id> Todomap = New Map<String,Id>();
    for(Integer i=0; i<RecordTypeList.size(); i++ ){
        Todomap.put(RecordTypeList[i].Name,RecordTypeList[i].Id);
    }
    
    //----------------------------------------------------
    //  Define a variable 
    //----------------------------------------------------
    Boolean isIns;
    //CrossViewToDo Logic
    JP_CLCrossViewToDoUpsert trUps = new JP_CLCrossViewToDoUpsert();

    //The processing when it new makes or it updates it
    if(Trigger.isInsert || Trigger.isUpdate){
        List<Task> List_target = new List<Task>(); //リストを新しく作る。日本語のデータを格納するためのリスト
        for(Integer i=0; i< Trigger.new.size(); i++){
            
            //----------------------------------------------------
            //  This is Japan Logic
            //----------------------------------------------------
            System.debug(Trigger.new[i].RecordTypeId + '★★★' + Todomap.get('JP_Tasks'));
            //When record type ID of the trigger object record is corresponding to "JP_Tasks", it processes it. 
        
            if(Trigger.new[i].RecordTypeId == Todomap.get('JP_Tasks')){
                List_target.add(Trigger.new[i]);
            }
        }
        // At Insert Trigger
        if(Trigger.isInsert){
            isIns = true;
        }
        // At Updeat Trigger
        if(Trigger.isUpdate){
            isIns = false;
        }
        if(0<List_target.size()){
            System.debug('★★★UpdateCrossViewToDo★★★');
            trUps.CrossViewToDo_Upsert(List_target,isIns);
        }
    }
    //The processing when it deletes it
    if(Trigger.isDelete){
        List<Task> List_target = new List<Task>(); //リストを新しく作る。日本語のデータを格納するためのリスト
        for(Integer j=0; j< Trigger.old.size(); j++){

            //----------------------------------------------------
            //  This is Japan Logic
            //----------------------------------------------------
            System.debug(Trigger.old[j].RecordTypeId + '★★★' + Todomap.get('JP_Tasks'));
            //When record type ID of the trigger object record is corresponding to "JP_Tasks", it processes it. 

            if(Trigger.old[j].RecordTypeId == Todomap.get('JP_Tasks')){
                List_target.add(Trigger.old[j]);
            }
        }
        if(0<List_target.size()){
            System.debug('★★★DeleteCrossViewToDo★★★');
            trUps.CrossViewToDo_delete(List_target);
        }
    }

}