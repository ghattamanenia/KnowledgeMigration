/*******************
Description:This cord is a list of companies level making class.
Developer: Hitachi Solutions, Ltd.
Date Created: 11/30/2010
Date Modified: 6/7/2011
*****************/
/**
 * 会社のリスト値作成クラス -
 */
public class JP_CLPricebookSendToAccount {

    //商談で参照している会社情報を重複なしで保持
    set<String> setAccId = new set<String>();

    // 会社のリスト値の保持
    List<selectOption> accOptions = new List<selectOption>();

    // デフォルト値の保持
    String defaultVal;

    /**
     * 会社リスト作成メソッド - 
     * @param Opportunity targetopp : 呼び出し元の商談 -
     * @return List<selectOption> accOptions ： 会社のリスト値 -
     * @throws なし -
     */
    public List<selectOption> createSendToAccount(Opportunity targetOpp){
        
        // 会社名から値を取得
        if(targetOpp.AccountId != null){
            setAccId.add(targetOpp.AccountId);
        }
        // エンドから値を取得
//        if(targetOpp.JP_Enduser__c != null ){
//            setAccId.add(targetOpp.JP_Enduser__c);
//        }
        // パートナーから値を取得
        List<OpportunityPartner> oppP = [select accountToId, OpportunityId from OpportunityPartner where opportunityId = :targetopp.Id];
        for(integer i = 0; i < oppP.size(); i++){
                System.debug('●●●' +i+'件目');
            // 他の項目との重複チェック
            if(oppP[i].accountToId != null){
                setAccId.add(oppP[i].accountToId);
            }
        }
        // リターン用リストの設定
        List<Account> tmpOptions = [select id, name from Account where id in: setAccId ];
        for(Integer i=0;i<tmpOptions.size();i++){
            accOptions.add(new selectoption(tmpoptions[i].Id, tmpoptions[i].Name));
        }
        // デフォルト値の設定
        // 宛名会社の値をリターン用リストに保持している場合
        for(Integer i=0;I<accOptions.size();i++){
            System.debug('●●●代入前デフォルト値'+defaultVal+'商談の宛名会社'+targetOpp.JP_SendToAccount__c);
            if(accOptions[i].getValue() == targetOpp.JP_SendToAccount__c){
                defaultVal = targetOpp.JP_SendToAccount__c;

            }
            System.debug('●●●宛名顧客が商談中の会社を保持している場合,デフォルト値は'+defaultVal);
        }
        // 宛名会社の値をリターン用リストに保持していない場合
        if(defaultVal == null){
            defaultVal = accOptions[0].getValue();
            System.debug('●●●宛名顧客がNullの場合、デフォルト値は'+defaultVal);
        }
        System.debug('●●●設定後のデフォルト値'+defaultVal);
        return accOptions;
    }
    /**
     * 会社リストデフォルト値取得 - 
     * @param なし -
     * @return String defaultVal ： 会社のリストのデフォルト値 -
     * @throws なし -
     */
    public String getDefaultVal(){
        return defaultVal;
    }
    /**
     * 商談で参照する会社のID取得（重複なし） - 
     * @param なし -
     * @return Set<String> setAccId ： 会社のリスト値 -
     * @throws なし -
     */
    public Set<String> getSetAccId(){
        return setAccId;
    }
}