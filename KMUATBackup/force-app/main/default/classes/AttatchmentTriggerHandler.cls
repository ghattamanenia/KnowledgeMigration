public with sharing class AttatchmentTriggerHandler {   
   /*
    * 削除時処理
    * @param Trigger.new => List<Attachment> newList
    * @return void
    */
    public static void BeforeDelete(List<Attachment> oldList){

        for(Attachment att: oldList){
            //削除ユーザプロファイルチェック
            AttatchmentTriggerAction.deleteAttachment(oldList);
        }
    }
}