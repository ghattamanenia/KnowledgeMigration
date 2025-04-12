trigger AttachmentTrigger on Attachment (before delete) {

    //削除時
    if(Trigger.IsBefore && Trigger.IsDelete){
        AttatchmentTriggerHandler.BeforeDelete(Trigger.old);
    }
}