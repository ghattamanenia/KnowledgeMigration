/*
 *Wrapperクラス
 * 
 */

public with sharing class WrapProductSearch {
    
    public JP_DistributorPrice__c dp {get;set;}
    public Boolean isChecked {get;set;} 

    public WrapProductSearch(JP_DistributorPrice__c dp) {
        this.dp = dp;
        this.isChecked = false;
        
    }
}