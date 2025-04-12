/**
 * EMEA用価格表管理クラス -
 */
public with sharing class ATFE_PricebookManager_EMEA extends ATFE_PricebookManager{
    
    /**
     * 該当地域名取得用関数 -
     * @param なし -
     * @return [String]地域名(EMEA) -
     * @throws なし -
     */  
    public override String getRegion(){
        return 'EMEA';
    }
    
}