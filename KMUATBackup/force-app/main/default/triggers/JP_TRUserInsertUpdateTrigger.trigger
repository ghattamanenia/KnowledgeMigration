/**
 * Description: This is a Trigger of User.
 * Developer Name: Yuki Fukakusa
 * Created Date: 07/14/2011
 * LastModified Date: 01/27/2012
 */
trigger JP_TRUserInsertUpdateTrigger on User (after insert, after update) {

    JP_CLSynchronizeRMAPICWithUser.InsertUpdatepdateUserDataFuture(trigger.newMap.keySet(),trigger.isInsert);

    /*
    //Create execution class instance.
    JP_CLSynchronizeRMAPICWithUser synPIC = new JP_CLSynchronizeRMAPICWithUser();

    //対象ProfileのIdを格納したSet
    Set<Id> targetProfileIds = JP_CLCommonConst.PROFILENAME_ALLJP();

    //Insert record List.
    List<User> InsertList = new List<User>();
    //Update record List.
    List<User> UpdateList = new List<User>();

    //When users are insert, make records to JP_RMAPersonInCharge.
    if(trigger.isInsert) {
        for(Integer i = 0; i<trigger.new.size(); i++){
            if(targetProfileIds.contains(trigger.new[i].ProfileId)){
                InsertList.add(Trigger.new[i]);
            }
        }
        if(InsertList.size() > 0){
            //Execute insert JP_RMAPersonInCharge records.
            synPIC.insertNewUser(InsertList);
        }
    //When users are updated, upsert or delete JP_RMAPersonInCharge records.
    } else if(trigger.isUpdate) {
        for(Integer i=0; i<trigger.new.size(); i++){
            if(targetProfileIds.contains(trigger.new[i].ProfileId) || targetProfileIds.contains(trigger.old[i].ProfileId)){
                UpdateList.add(trigger.new[i]);
            }
        }
        if(UpdateList.size() > 0){
            //Execute update/delete JP_RMAPersonInCharge records.
            synPIC.updateUserData(UpdateList);
        }
    }
    */
}