/**
 * 部署オブジェクトのDAOクラス 
 */

public with sharing class JP_DepartmentDAO {

    public static List<JP_Department__c> getRecByUsrDepartment(String usrDepartment){
        return [Select 
                       Id,
                       Name,
                       JP_DeptCode__c,
                       JP_Company__c,
                       JP_Building__c,
                       JP_Postcode__c,
                       JP_Address1__c,
                       JP_Address2__c,
                       JP_Address3__c,
                       JP_TelNo__c,
                       JP_FaxNo__c
                From 
                    JP_Department__c
                Where 
                    JP_DeptCode__c =:usrDepartment
                Limit 1
                ];

    }
}