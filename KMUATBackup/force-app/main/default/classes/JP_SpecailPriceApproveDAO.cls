public with sharing class JP_SpecailPriceApproveDAO {
    
    /**
     * @param qHeaderId 見積ヘッダーID
     * @return 検索条件に一致した特化承認情報レコード 
     */
    public static List<JP_SpecailPriceApprove__c> getRecByQHeaderId(String qHeaderId){
        String atkk = System.Label.JP_ATKKProduct;
        return [select 
                    JP_SpecailPriceEndDate__c
                from 
                    JP_SpecailPriceApprove__c 
                where 
                    JP_QuotationHeader__c = :qHeaderId 
                and 
                    JP_ProductClassification__c = :atkk 
                order by 
                    LastModifiedDate DESC 
                limit 1];
    }
    
    /**
     * @param qHeaderId 見積ヘッダーID
     * @return 検索条件に一致した特化承認情報レコード 
     */
    public static Map<String, JP_SpecailPriceApprove__c> getRecById(String qHeaderId){
        List<JP_SpecailPriceApprove__c> result 
            = [select 
                    Id
                    ,JP_ProductClassification__c
                    ,CreatedDate
                    ,JP_SpecailPriceEndDate__c
                from 
                    JP_SpecailPriceApprove__c 
                where 
                    JP_QuotationHeader__c = :qHeaderId 
                and
                    JP_ProductClassification__c != 'JP_OtherUnitPriceErrorCheck'
            ];
        
        if(result.size() == 0){
            return null;
        }
        
        Map<String, JP_SpecailPriceApprove__c> resultMap = new Map<String, JP_SpecailPriceApprove__c>();
        for(JP_SpecailPriceApprove__c spa : result){
            system.debug('***特化適用終了期限：' + spa.JP_SpecailPriceEndDate__c);
            if(!resultMap.containsKey(spa.JP_ProductClassification__c)){
                resultMap.put(spa.JP_ProductClassification__c, spa);
            }else{
                JP_SpecailPriceApprove__c spa2 = resultMap.get(spa.JP_ProductClassification__c);
                if(spa.CreatedDate > spa2.CreatedDate){
                    resultMap.remove(spa2.JP_ProductClassification__c);
                    resultMap.put(spa.JP_ProductClassification__c, spa);
                }
            }
        }
        
        return resultMap;
    }
}