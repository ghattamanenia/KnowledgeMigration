/*******************
Description: This cord is a price list instance generation class according to each Region.
Developer: Hitachi Solutions, Ltd.
Date Created: 10/1/2010
Date Modified: 5/8/2012
*****************/
/**
 * 各Region別価格表インスタンス生成クラス -
 */
public with sharing class ATFE_PricebookManagerFactory {
    
    /**
     * 各Region別価格表インスタンス取得 -
     * @param [String]地域 -
     * @return [ATFE_PricebookManager]価格表管理インスタンス -
     * @throws なし -
     */
    public ATFE_PricebookManager getInstance(String argRegion){
        
        ATFE_PricebookManager rtnPBMng = null;
        
        //各Region別 Pricebook管理クラス生成 -
        if('EMEA'.equals(argRegion)){
            rtnPBMng = new ATFE_PricebookManagerEMEA();
        }
        else if('NA'.equals(argRegion)|| 'Americas'.equals(argRegion)){
            rtnPBMng = new ATFE_PricebookManagerNA();
        }
        //【注意】日本の価格表選択はコントローラのシナリオメソッドから呼び出すため本処理は行われない
        else if('JP'.equals(argRegion)){
            rtnPBMng = new ATFE_PricebookManagerJP();
        }
        //2012/5/8 [ADD]   -- Logic for APAC -- START
        else if('APAC'.equals(argRegion)){
            rtnPBMng = new ATFE_PricebookManagerAPAC();
        }
        //2012/5/8 [ADD]   -- Logic for APAC --  END
        
        return rtnPBMng;
    }
}