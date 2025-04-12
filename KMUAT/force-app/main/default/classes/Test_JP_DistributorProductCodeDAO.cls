/**
 *
 * JP_DistributorProductCodeDAOのテストクラス
 *
 **/

@isTest
private class Test_JP_DistributorProductCodeDAO {

     private static testMethod void testDistributorProductCodeDao(){

        String mainCode = 'Code';
        String proCode = '990Code';

        //テストデータ作成
        JP_DistributorProductCode__c dpCode = new JP_DistributorProductCode__c();
        Set<String> codeSet = new Set<String>();
        List<JP_DistributorProductCode__c> dpCodeList = new List<JP_DistributorProductCode__c>();

        dpCode.Name = '11';
        dpCode.JP_DistributorProCode__c = 'test';
        dpCode.JP_MainDistributorCode__c = mainCode;
        dpCode.JP_ProductCode__c = proCode;

        codeSet.add(proCode);
        dpCodeList.add(dpCode);

        insert dpCodeList;

        List<JP_DistributorProductCode__c> result = new List<JP_DistributorProductCode__c>();

        //Test
        Test.startTest();

        result = JP_DistributorProductCodeDAO.selectDistributorProCode(mainCode, codeSet);

        Test.stopTest();

        System.assertEquals(1, result.size());
    }
}