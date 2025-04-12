/*******************
Description: This cord is interface for price list choice functions.
Developer: Hitachi Solutions, Ltd.
Date Created: 10/1/2010
Date Modified: 6/7/2011
*****************/
/**
 * 価格表選択機能用インターフェース -
 */
public interface ATFE_IF_PricebookManager {
        
    /* get a Pricebook List */
    List<Selectoption> getPriceBooks();

}