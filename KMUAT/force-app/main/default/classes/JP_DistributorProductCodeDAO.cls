/**
     * 代理店専用製品コードDAO
     */

public with sharing class JP_DistributorProductCodeDAO {
    /**
     * 見積画面商品検索用
     * @param mainDistributorCd 親代理店コード
     * @param productCodeSet 990コードセット
     *
     * @return 検索条件に一致した代理店専用製品コードリスト 
     */
    public static List<JP_DistributorProductCode__c> selectDistributorProCode (String mainDistributorCd , Set<String> productCodeSet) {
        system.debug('========== START selectDistributorProCode ==========');

        List<JP_DistributorProductCode__c> codeList = new List<JP_DistributorProductCode__c>();
        codeList = [ select 
                            JP_DistributorProCode__c
                           ,JP_MainDistributorCode__c
                           ,JP_ProductCode__c
                      from
                            JP_DistributorProductCode__c
                      where
                            JP_MainDistributorCode__c = :mainDistributorCd
                      and
                            JP_ProductCode__c = :productCodeSet
                    ];
        
        return codeList;
    }
}