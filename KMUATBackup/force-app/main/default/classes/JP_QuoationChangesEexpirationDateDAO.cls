public with sharing class JP_QuoationChangesEexpirationDateDAO {
    
    /**
     * @param strPrefix 見積No
     * @return 検索条件に一致した見積有効期限変更履歴レコード 
     */
    public static JP_QuoationChangesEexpirationDate__c getRecByQuotationNoMax(String strPrefix){
        
        String strLike = strPrefix + '%';
        JP_QuoationChangesEexpirationDate__c[] rec = [SELECT Name From JP_QuoationChangesEexpirationDate__c
                                           WHERE Name LIKE :strLike ORDER BY Name DESC LIMIT 1];
        
        if(rec.size() > 0){
            return rec[0];
        } else {
            return null;
        }
    }
}