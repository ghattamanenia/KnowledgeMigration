/*******************
Description: This cord is a price list management base class.
Developer: Hitachi Solutions, Ltd.
Date Created: 10/1/2010
Date Modified: 8/25/2011
*****************/
/**
 * 価格表管理ベースクラス -
 */
public virtual class ATFE_PricebookManager implements ATFE_IF_PricebookManager{
    
    /**
     * opportunity's account
     */
    protected String oppAccount = null;
    
    
    /**
     * 該当地域名取得用関数 -
     * @param なし -
     * @return [String]地域名 -
     * @throws なし -
     */ 
    public virtual String getRegion(){
        return null;
    }
    
    
    /**
     * accountセット -
     * @param なし -
     * @return [String]地域名 -
     * @throws なし -
     */ 
    public void setOppAccount(String argOppAccounid){
        this.oppAccount = argOppAccounid;
    }
    
    /**
     * 価格表取得処理 -
     * 【注意】基本動作としてプロファイルで指定されてRegionと同名の価格表を取得する処理を実装している -
     * @param なし -
     * @return [List<Selectoption>]使用可能な価格表一覧 -
     * @throws なし -
     */
    public virtual List<Selectoption> getPriceBooks(){
        
        List<Selectoption> options = new List<Selectoption>();
        
        String sKeyWord = this.getRegion() + '%';
        System.debug(sKeyWord);
        
        for(pricebook2 pb: [SELECT name From Pricebook2 where isActive=true and Name like :sKeyWord]){
            options.add(new SelectOption(pb.id,pb.name));
            system.debug('★★★★' + options.size());      
        }
        return options ;
     }
}