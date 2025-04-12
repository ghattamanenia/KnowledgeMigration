@isTest
public class Test_JP_DistributorPriceTriggerAction {

    
    private static testMethod void  testInsert(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
            List<JP_DistributorPrice__c> dpList = JP_TestUtil.Create_JP_DistributorPriceForTrigger(9);    
            insert dpList;
            List<JP_PriceYearMonth__c> checkList = [SELECT ID FROM JP_PriceYearMonth__c];
            System.assertEquals(9,checkList.size());
        }
    }

    private static testMethod void  testUpdate(){
        User testUsr = JP_TestUtil.Create_AdminUser('te');
        System.runAs(testUsr){
            List<JP_DistributorPrice__c> dpList = JP_TestUtil.Create_JP_DistributorPriceForTrigger(9);    
            insert dpList;
            List<JP_DistributorPrice__c> dpInsertedList = [ SELECT ID FROM JP_DistributorPrice__c WHERE ID IN :dpList];
            update dpInsertedList;
            List<JP_PriceYearMonth__c> checkList = [SELECT ID FROM JP_PriceYearMonth__c];
            System.assertEquals(9,checkList.size());
        }
    }

}