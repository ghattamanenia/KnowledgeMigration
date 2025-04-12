/*******************
Description: This cord is a price list management class for NA.
Developer: Hitachi Solutions, Ltd.
Date Created: 10/1/2010
Date Modified: 6/7/2011
*****************/
/**
 * NA用価格表管理クラス -
 */
public with sharing class ATFE_PricebookManagerNA extends ATFE_PricebookManager{
    
    /**
     * 該当地域名取得用関数 -
     * @param なし -
     * @return [String]地域名(NA) -
     * @throws なし -
     */
    public override String getRegion(){
        return 'NA';
    }
    
}