/*******************
Description: This cord is a list of distributor level making class.
Developer: Hitachi Solutions, Ltd.
Date Created: 12/9/2010
Date Modified: 6/7/2011
*****************/
public class JP_CLPricebookSelectDistributor {

    // 代理店のリスト値の保持
    List<selectOption> disOptions = new List<selectOption>();

    // 代理店IDの保持
    Set<String> setDisId = new Set<String>();

    //代理店ID、価格表コードのマップを保持
    Map<String, String> disPrbMap = new Map<String, String>();

    //デフォルト値の保持
    String defaultVal;

    /**
     * 代理店リスト作成メソッド - 
     * @param Opportunity targetopp : 呼び出し元の商談 -
     * @return List<selectOption> disOptions ： 代理店のリスト値 -
     * @throws なし -
     */
    public List<selectOption> disValOption(Opportunity targetOpp, Id accId, Set<String> setAccId){
        system.debug('●●●引数の確認  accId:'+accId+'/setAccIdサイズ:'+setAccId.size());

        //使用仕切表のリスト作成
        List<JP_PricebookMapping__c> prbMappingList = [select id, JP_Distributor__c, JP_Distributor__r.name, JP_DistributorCode__c, JP_UsePricebookCode__c 
                                                        from JP_PricebookMapping__c 
                                                        where JP_DistributorCode__c != null and JP_UsePricebookCode__c != null and JP_Distributor__r.JP_Account__r.Id =: accid and JP_Distributor__r.JP_DeleteFlag__c = false];
        System.debug('●●●prbMappingList取得件数：'+prbMappingList.size()+'件');

        //宛名のリスト作成
        List<JP_SendTo__c> sendToList               = [select id, JP_PbUsingDistributor__c, JP_PbUsingDistributor__r.name, JP_SPMSCode__c, JP_PricebookCode__c, JP_SendToAccount__c  
                                                        from JP_SendTo__c 
                                                        where JP_SPMSCode__c != null and JP_SendToAccount__c  =: accId and JP_PricebookCode__c != null and JP_PbUsingDistributor__r.JP_Account__r.Id in: setAccId and JP_PbUsingDistributor__r.JP_DeleteFlag__c = false];
        System.debug('●●●sendToList取得件数：'+sendToList.size()+'件');

        //使用仕切表から代理店IDのSet、ID、価格表コードのリストを取得
        for(Integer i=0; i<prbMappingList.size();i++){
            System.debug('●●●使用仕切表の代理店コード'+i+'件目'+prbMappingList[i].JP_Distributor__c);
            setDisId.add(prbMappingList[i].JP_Distributor__c);
            disPrbMap.put(prbMappingList[i].JP_DistributorCode__c, prbMappingList[i].JP_UsePricebookCode__c);
            System.debug('●●●prbMappingList[i].JP_DistributorCode__c:'+prbMappingList[i].JP_DistributorCode__c+'/prbMappingList[i].JP_UsePricebookCode__c:'+prbMappingList[i].JP_UsePricebookCode__c);
        } 
        //宛名から代理店IDのSet、ID、価格表コードのリストを取得
        for(Integer i=0; i<sendToList.size();i++){
            System.debug('●●●宛名の代理店コード'+i+'件目'+sendToList[i].JP_SPMSCode__c);
            setDisId.add(sendToList[i].JP_PbUsingDistributor__c);
            disPrbMap.put(sendToList[i].JP_SPMSCode__c, sendToList[i].JP_PricebookCode__c);
            System.debug('●●●sendToList[i].JP_SPMSCode__c:'+sendToList[i].JP_SPMSCode__c+'/sendToList[i].JP_PricebookCode__c:'+sendToList[i].JP_PricebookCode__c);
        }
        System.debug('●●●代理店検索用のsetDisIdの総数：'+setDisId.size());

        // リターン用のリストの値設定、および価格表選択用の代理店、価格表コードのマップ設定
        List<JP_Distributor__c> disList = [select id, Name, JP_DistributorCode__c, JP_PriceList__c from JP_Distributor__c where id in:setDisId and JP_DeleteFlag__c = false];
        // 代理店リストの作成に利用
        Map<String, String> disMap = new Map<String, String>();
        // 価格表リストの作成に利用
                            
        for(Integer i=0; i<disList.size();i++){
            disMap.put(disList[i].id, disList[i].Name);
        }
        System.debug('●●●disListの総数：'+disList.size()+'/disMapの総数：'+disMap.size());

        for(Integer i=0; i<prbMappingList.size();i++){
            disOptions.add(new selectOption(prbMappingList[i].JP_DistributorCode__c, prbMappingList[i].JP_DistributorCode__c+' / '+disMap.get(prbMappingList[i].JP_Distributor__c)));
            System.debug('●●●disOption中身/バリュー:'+prbMappingList[i].JP_DistributorCode__c+'/ラベル:'+prbMappingList[i].JP_DistributorCode__c+' / '+disMap.get(prbMappingList[i].JP_Distributor__c));
        }
        for(Integer i=0; i<sendToList.size();i++){
            disOptions.add(new selectOption(sendToList[i].JP_SPMSCode__c, sendToList[i].JP_SPMSCode__c+' / '+disMap.get(sendToList[i].JP_PbUsingDistributor__c)));
            System.debug('●●●disOption中身/バリュー:'+sendToList[i].JP_SPMSCode__c+'/ラベル:'+sendToList[i].JP_SPMSCode__c+' / '+disMap.get(sendToList[i].JP_PbUsingDistributor__c));
        }
        disPrbMap.put('SS', 'SS');
        disOptions.add(new selectoption('SS', '標準価格'));

        //デフォルト値の設定
        defaultVal = null;
        // SPMS検索用代理店コードの値をリターン用リストに保持している場合
        for(Integer i=0;I<disOptions.size();i++){
            if(disOptions[i].getValue() == targetOpp.JP_TargetDistributorCode__c){
                defaultVal = targetOpp.JP_TargetDistributorCode__c;
            }
        }
        // SPMS検索用代理店コードの値をリターン用リストに保持していない場合
        if(defaultVal == null){
            defaultVal = disOptions[0].getValue();
        }
        return disOptions;
    }
    /**
     * 代理店リストデフォルト値取得 - 
     * @param なし -
     * @return String defaultVal ： 代理店のリストのデフォルト値 -
     * @throws なし -
     */
    public String getDefaultVal(){
        return defaultVal;
    }
    /**
     * 代理店の価格表コード値取得 - 
     * @param なし -
     * @return Map<String, String> disMap ： 価格表リスト作成時に使用する代理店と代理店の価格表コードのリスト -
     * @throws なし -
     */
    public Map<String, String> getDisPrbMap(){
        return disPrbMap;
    }
}