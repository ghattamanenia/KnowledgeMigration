/*******************
Description: This cord is a price list management class for APAC.
Developer: Hitachi Solutions, Ltd.
Date Created: 5/8/2012
Date Modified: 5/8/2012
*****************/
/**
 * APAC用価格表管理クラス -
 */
public with sharing class ATFE_PricebookManagerAPAC extends ATFE_PricebookManager{
    
    /**
     * 該当地域名取得用関数 -
     * @param なし -
     * @return [String]地域名(APAC) -
     * @throws なし -
     */  
    public override String getRegion(){
    	
        return 'APAC';
    }
    
}