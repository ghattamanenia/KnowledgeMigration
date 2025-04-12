public class EventTriggerHandler {
    /*
    * 削除前呼び出し
    * @param Trigger.old => List<Event> oldList
    * @return void
    */
    public static void BeforeDelete(List<Event> oldList) {
        //削除ユーザプロファイルチェック
        for(Event event : oldList){
	        EventTriggerAction.deleteActivityHistory(oldList);
        }
	}
}