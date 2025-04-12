/*******************
Description: This cord is a list level making class of the customer.
Developer: Hitachi Solutions, Ltd.
Date Created: 12/2/2010
Date Modified: 6/7/2011
*****************/
/**
 * 顧客のリスト値作成クラス -
 */
public class JP_CLPricebookSendToContact {

    //商談で参照している顧客情報を重複なしで保持
    Set<String> setConId = new Set<String>();
    
    // 顧客のリスト値の保持
    List<selectOption> conOptions = new List<selectOption>();

    // デフォルト値の保持
    String defaultVal;

    /**
     * 顧客リスト作成メソッド - 
     * @param Opportunity targetopp : 呼び出し元の商談 -
     * @param String accId          : 会社のリストから選択した宛名会社の値 -
     * @return List<selectOption> conOptions ： 顧客のリスト値 -
     * @throws なし -
     */
    public List<selectOption> createSendToContact(Opportunity targetOpp, String accId ){
        System.debug('●●●引数確認 accId：'+accId);

        //関係顧客から値を取得
//        if(targetOpp.JP_RelatedContact__c != null){
//            setConId.add(targetOpp.JP_RelatedContact__c);
//        }
//        System.debug('●●●関係顧客追加処理終了/関係顧客ID：'+targetOpp.JP_RelatedContact__c+'/関係顧客名：'+targetOpp.JP_RelatedContact__r.name);
        //担当者(エンド)から値を取得
//        if(targetOpp.JP_ContactEnduser__c != null){
//            setConId.add(targetOpp.JP_ContactEnduser__c);
//        }
//        System.debug('●●●担当者(エンド)追加処理終了/担当者(エンド)ID：'+targetOpp.JP_ContactEnduser__c+'/担当者(エンド)名：'+targetOpp.JP_ContactEnduser__r.name);
        //商談顧客の役割から値を取得
        List<OpportunityContactRole> oppConRole = [select contactId, OpportunityId from OpportunityContactRole where opportunityId = :targetopp.Id];
        for(integer i = 0; i < oppConRole.size(); i++){
            // 関係顧客、担当者(エンド)との重複チェック
            if(oppConRole[i].contactId != null ){
                setConId.add(oppConRole[i].contactId);
                System.debug('●●●商談顧客の役割追加処理/商談顧客の役割ID：'+oppConRole[i].contactId);
            }
        }
        System.debug('●●●SetConIdの総数：'+setConId.size());
        //対象顧客の取得
        List<Contact> conTmpList = new List<Contact>();
        conTmpList = [select id, name, accountId from Contact where accountId =: accId and id in: setConId];
        if(conTmpList.size()>0){
            for(Integer i=0; i< conTmpList.size();i++){
                System.debug('●●●'+conTmpList[i].Id+'/'+conTmpList[i].Name+'/'+conTmpList[i].accountId);
                conOptions.add(new selectOption(conTmpList[i].Id, conTmpList[i].name));
            }
        }
        // 顧客名なしを追加
        conOptions.add(new selectoption('special_value', '顧客名なし'));
        System.debug('●●●リスト値数'+conOptions.size());

        // デフォルト値を設定
        defaultVal = null;
        // 宛名顧客として顧客名なしが商談に保持されている場合
        System.debug('●●●targetOpp.JP_NoSendToContactFlag__c'+targetOpp.JP_NoSendToContactFlag__c);
        System.debug('●●●targetOpp.JP_SendToContact__c'+targetOpp.JP_SendToContact__c);
        if( targetOpp.JP_NoSendToContactFlag__c == true && targetOpp.JP_SendToContact__c == null ){
                defaultVal = 'special_value';
                System.debug('●●●宛名顧客に顧客名なしを発見');
        }
        // 宛名顧客の値をリターン用リストに保持している場合
        if(defaultVal == null){
            for(Integer i=0;i<conOptions.size();i++){
                if( String.valueof(targetOpp.JP_SendToContact__c) == conOptions[i].getValue()){
                    defaultVal = targetOpp.JP_SendToContact__c;
                }
            }
        }
        System.debug('●●●デフォルト値(リスト内の宛名顧客と同じ値)'+defaultVal);
        // 宛名顧客の値をリターン用リストに保持していない場合
        if(defaultVal == null){
            defaultVal = conOptions[0].getValue();
        }
        System.debug('●●●デフォルト値(リスト内の初期値)'+defaultVal);

        return conOptions;
    }
    /**
     * 顧客リストデフォルト値取得 - 
     * @param なし -
     * @return String defaultVal ： 顧客のリストのデフォルト値 -
     * @throws なし -
     */
    public string getDefaultVal(){
        return defaultVal;
    } 
}