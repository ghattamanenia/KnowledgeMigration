public with sharing class TaskTriggerHandler {
   /*
    * 削除前呼び出し
    * @param Trigger.old => List<Task> oldList
    * @return void
    */
    public static void BeforeDelete(List<Task> oldList) {
        //削除ユーザプロファイルチェック
        for(Task todo : oldList){
	        TaskTriggerAction.deleteActivityHistory(oldList);
        }
	}
}