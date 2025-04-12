@isTest
private class Test_JP_ApprovalProcessDAO {

    // 承認プロセス判定1件のケース
    static testMethod void testGetApprovalProcessNo1() {
        Map<String,String> apMap = new Map<String,String>();
        Set<String> keySet = new Set<String>();
        Integer quantity = 1;

        List<JP_DecideApprovalProcess__c> apList = JP_TestUtil.Create_JP_ApprovalProcess(quantity);
        
        for(Integer i = 1; i <= quantity; i++){
            String key = 'A' + String.valueOf(i) + 
                         'B' + String.valueOf(i) + 
                         'C' + String.valueOf(i) + 
                         'D' + String.valueOf(i) + 
                         'E' + String.valueOf(i) + 
                         'F' + String.valueOf(i) + 
                         'G' + String.valueOf(i);
            keySet.add(key);
        }

        Test.StartTest();
        apMap = JP_ApprovalProcess_DAO.getApprovalProcessNo(keySet);
        Test.StopTest();
        
        for(String key : keySet){
            system.assert(apMap.containsKey(key));
            system.assertequals(apMap.values().size(), quantity);
        }
    }
    
    // 承認プロセス判定複数件のケース
    static testMethod void testGetApprovalProcessNo2() {
        Map<String,String> apMap = new Map<String,String>();
        Set<String> keySet = new Set<String>();
        Integer quantity = 5;
        
        List<JP_DecideApprovalProcess__c> apList = JP_TestUtil.Create_JP_ApprovalProcess(quantity);
        
        for(Integer i = 1; i <= quantity; i++){
            String key = 'A' + String.valueOf(i) + 
                         'B' + String.valueOf(i) + 
                         'C' + String.valueOf(i) + 
                         'D' + String.valueOf(i) + 
                         'E' + String.valueOf(i) + 
                         'F' + String.valueOf(i) + 
                         'G' + String.valueOf(i);
            keySet.add(key);
        }

        Test.StartTest();
        apMap = JP_ApprovalProcess_DAO.getApprovalProcessNo(keySet);
        Test.StopTest();
        
        for(String key : keySet){
            system.assert(apMap.containsKey(key));
            system.assertequals(apMap.values().size(), quantity);
        }
    }
    
    static testMethod void testgetApprovalProcessInfoByNo() {
        JP_ApprovalProcessMaster__c apm1 = JP_TestUtil.Create_JP_ApprovalProcessMaster(1);
        
        Test.StartTest();
        JP_ApprovalProcessMaster__c apm2 = JP_ApprovalProcess_DAO.getApprovalProcessInfoByNo(Integer.valueOf(apm1.JP_ApprovalProcessNo__c));
        Test.StopTest();
        
        system.assertequals(apm1.JP_ApprovalProcessNo__c, apm2.JP_ApprovalProcessNo__c);

    }
}