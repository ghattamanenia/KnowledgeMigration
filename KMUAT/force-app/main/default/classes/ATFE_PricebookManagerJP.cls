/*******************
Description: This cord is a price list management class for JP.
Developer: Hitachi Solutions, Ltd.
Date Created: 10/1/2010
Date Modified: 6/7/2011
*****************/
/**
 * JP用価格表管理クラス -
 * 【注意】JP用価格表はController中のシナリオメソッドから呼び出しているため、本クラスは利用しない。
 */
public with sharing class ATFE_PricebookManagerJP extends ATFE_PricebookManager{
    
    /**
     * 該当地域名取得用関数 -
     * @param なし -
     * @return [String]地域名(JP) -
     * @throws なし -
     */ 
    public override String getRegion(){
        return 'JP';
    }   
    
    /**
     * JP用 価格表取得処理 -
     * 【注意】本メソッドコール前に、setOppAccount()をコールしメンバ変数：oppAccount をセットしておくこと -
     * @param なし -
     * @return [List<Selectoption>]使用可能な価格表一覧 -
     * @throws なし -
     */
    public  override List<Selectoption> getPriceBooks(){
        
        List<Selectoption> options = new List<Selectoption>();
        
        for(JP_PricebookMapping__c pb: [SELECT id From JP_PricebookMapping__c ]){
            options.add(new SelectOption('test', '00'));
            system.debug('☆☆☆☆' + options.size());
        }
                
        return options;
    }
}