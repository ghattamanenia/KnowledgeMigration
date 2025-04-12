/*******************
Description: This cord is a list of price lists level making class.
Developer: Hitachi Solutions, Ltd.
Date Created: 12/18/2010
Date Modified: 6/7/2011
*****************/
/**
 * 価格表のリスト値作成クラス -
 */
public class JP_CLPricebookSelectPricebook {

    //リターン用のリスト用意
    List<selectOption> prbOptions = new List<selectOption>();

    // デフォルト値の保持
    String defaultVal;

    // リターン用のリスト(価格表型)を用意
    List<Pricebook2> prbList;

    // 選択された代理店の価格表コード
    String selectedPrbCode;

    /**
     * 価格表リスト作成メソッド - 
     * @param  Opportunity targetopp  : 呼び出し元の商談 -
     * @return List<selectOption> prbOptions ： 価格表リストに表示される価格表リスト -
     * @throws なし -
     */
    public List<selectOption> prbValOption(Opportunity targetOpp, Map<String, String>disPrbMap, String disCode){
        ATFE_Exception expWord = new ATFE_Exception();
        System.debug('●●●disCode'+disCode);
        System.debug('●●●targetOpp.JP_TargetDistributorCode__c'+ targetOpp.JP_TargetDistributorCode__c); 

        // 代理店リストで選択した代理店の価格表コードを取得
        selectedPrbCode = disPrbMap.get(disCode);
        System.debug('●●●selectedPrbCode'+ selectedPrbCode);
        
        //代理店リストで選択した値が代理店レコードのマップにあるか判断
        System.debug('●●●selectedPrbCode/'+selectedPrbCode);
        if(selectedPrbCode == null){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, expWord.MSG_SelectDistriError));
        }else{
            // 該当する価格表コードを持つ価格表を取得
            prbList = [select id, name, description from pricebook2 where description =: selectedPrbCode
                                                                    and description != null 
                                                                    and IsActive = true];
            System.debug('●●●prbListのサイズ'+prbList.size());

            if(prbList.size()==0){
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, expWord.MSG_NoPricebooksExist));
            }else{
                // リターン用リストの設定
                for(Integer i=0;i<prbList.size();i++){
                    prbOptions.add(new selectOption (prbList[i].id, prbList[i].Name));
                    System.debug('●●●リストへ追加する値  価格表ID：'+prbList[i].id + '/価格表コード'+prbList[i].description+'/価格表名:'+prbList[i].Name);
                }
                // デフォルト値の設定
                for(Integer i=0;I<prbOptions.size();i++){
                    if(prbOptions[i].getValue() == targetOpp.pricebook2Id){
                        defaultVal = targetOpp.pricebook2id;
                    }
                }
                if(defaultVal == null){
                    defaultVal = prbOptions[0].getValue();
                }
            }
        }
        return prbOptions;
    }
    /**
     * 価格表リストデフォルト値取得 - 
     * @param なし -
     * @return String defaultVal ： 価格表のリストのデフォルト値 -
     * @throws なし -
     */
    public String getDefaultVal(){
        return defaultVal;
    }
    /**
     * 価格表リスト取得 - 
     * @param なし -
     * @return List<Pricebook2> prbList ： 価格表のリスト -
     * @throws なし -
     */
    public List<Pricebook2> getPrbList(){
        return prbList;
    }
}