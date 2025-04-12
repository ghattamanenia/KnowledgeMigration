/**
 * リードの取引開始したときプロセスビルダーから呼び出される
 */
public Without sharing class JP_ConvertingLead{
    @InvocableMethod
    public static void doAction(List<ID> ldIdList){

        // 取引開始したリードのコールレポートに紐づくTodoを変換先顧客に紐づける
        List<task> updateTsList = new List<task>();

        List<JP_CallReport__c> crList = [SELECT Id, JP_LeadID__c, JP_LeadID__r.convertedContactId, (SELECT Id, whoid, subject FROM Tasks)
                                         FROM   JP_CallReport__c
                                         WHERE  JP_LeadID__c IN :ldIdList];

        for(JP_CallReport__c cr : crList){
            for(Task ts : cr.Tasks) {
                ts.whoid = cr.JP_LeadID__r.convertedContactId;

                updateTsList.add(ts);
            }
        }
        update updateTsList;
    }
}