public class JP_ManagementNoDAO {
// 20210407 商談事象作成処理 terrasky add Start
    /**
     * 管理番号情報を取得する。
     * @param managementId 管理番号のId
     * @return 管理番号情報
     */
    public static JP_Management_No__c getManagementNo(Id managementId) {
        return [SELECT
               		Name
               		,JP_Contract_No__r.Name
                	,JP_Sales_Reference__c
                	,JP_User_Name__c
                	,JP_User_Address__c
                	,JP_Opportunity__c
                	,JP_StaYmd__c
                	,JP_Claim_Name__c
                	,JP_Service_Type__c
                	,JP_SO_Total__c
                FROM
                	JP_Management_No__c
                WHERE
                	Id =:managementId
		];
	}
// 20210407 商談事象作成処理 terrasky add End
}