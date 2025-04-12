public class JP_ContractInformationDAO {
// 20210407 商談事象作成処理 terrasky add Start
    /**
     * 契約番号情報を取得する。
     * @param contractNo 契約番号のId
     * @return 契約番号情報
     */
    public static JP_ContractInformation__c getContractInformation(Id contractNo) {
        return [SELECT
            		JP_Company__c
                	,JP_Agency__c
                FROM
                	JP_ContractInformation__c
                WHERE
                	Id =:contractNo
        ];
	}
// 20210407 商談事象作成処理 terrasky add End
}