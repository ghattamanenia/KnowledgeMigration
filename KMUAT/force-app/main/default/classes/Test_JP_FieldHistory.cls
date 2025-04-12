/**
 * TestClass JP_FieldHistory 
 */

@IsTest
private class Test_JP_FieldHistory {
    
    // 契約番号
    static testMethod void testContractInformation(){

        List<Account> accList = JP_TestUtil.CreateAccount(1);
        JP_ContractInformation__c contractInfo = JP_TestUtilContract.createContractInformation(accList[0]);
        
        Test.startTest();
        contractInfo.JP_Service_Type__c= 'アライド光';
        update contractInfo;
        Test.stopTest();
        
    }

    // 管理番号
    static testMethod void testManagement_No(){

        List<Account> accList = JP_TestUtil.CreateAccount(1);
        JP_ContractInformation__c contractInfo = JP_TestUtilContract.createContractInformation(accList[0]);
        User user = JP_TestUtil.Create_User('011_OUT');
        JP_Management_No__c managementNo = JP_TestUtilContract.createManagementNo(contractInfo, user);
        
        Test.startTest();
        managementNo.JP_EndYmd__c = Date.Today()+1;
        update managementNo;
        Test.stopTest();
        
    }
    
    // 契約顧客
    static testMethod void testMatter(){

        List<Account> accList = JP_TestUtil.CreateAccount(1);
        Contact con = JP_TestUtilContract.CreateCon(accList[0]);
        JP_Matter__c matter = JP_TestUtilContract.CreateMatter(con);
        
        Test.startTest();
        matter.JP_Contract_Status__c = '運用準備';
        update matter;
        Test.stopTest();
        
    }

    // Net.Monitor
    static testMethod void testNet_Monitor(){

        JP_Net_Monitor__c Net_Monitor = JP_TestUtilContract.CreateNet_Monitor();
        
        Test.startTest();
        Net_Monitor.JP_Others__c = '0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012340123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890';
        update Net_Monitor;
        Test.stopTest();
        
    }
    
    // 契約機器
    static testMethod void testMachineInformation(){

        List<Account> accList = JP_TestUtil.CreateAccount(1);
        JP_ContractInformation__c contractInfo = JP_TestUtilContract.createContractInformation(accList[0]);
        JP_MachineInformation__c MachineInformation = JP_TestUtilContract.CreateMachineInformation(contractInfo);
        
        Test.startTest();
        MachineInformation.JP_Maintenance_EndYmd_Temp__c = Date.Today()+1;
        update MachineInformation;
        Test.stopTest();
        
    }
    
    // SO
    static testMethod void testSo(){

        List<Account> accList = JP_TestUtil.CreateAccount(1);
        JP_ContractInformation__c contractInfo = JP_TestUtilContract.createContractInformation(accList[0]);
        User user = JP_TestUtil.Create_User('011_OUT');
        JP_Management_No__c managementNo = JP_TestUtilContract.createManagementNo(contractInfo, user);
        JP_RequestInformation__c so = JP_TestUtilContract.CreateSo(managementNo);

        Test.startTest();
        so.JP_SO_Header_Common1__c = 'test';
        update so;
        Test.stopTest();
        
    }

    // SO明細
    static testMethod void testSod(){

        List<Account> accList = JP_TestUtil.CreateAccount(1);
        JP_ContractInformation__c contractInfo = JP_TestUtilContract.createContractInformation(accList[0]);
        User user = JP_TestUtil.Create_User('011_OUT');
        JP_Management_No__c managementNo = JP_TestUtilContract.createManagementNo(contractInfo, user);
        JP_ConsignmentInformation__c po = JP_TestUtilContract.CreatePo(managementNo);
        JP_SO_Detail__c sod = JP_TestUtilContract.CreateSod(managementNo);

        Test.startTest();
        sod.JP_SO_Item_Common1__c = 'test';
        update sod;
        Test.stopTest();
        
    }
    
    // PO
    static testMethod void testPo(){

        List<Account> accList = JP_TestUtil.CreateAccount(1);
        JP_ContractInformation__c contractInfo = JP_TestUtilContract.createContractInformation(accList[0]);
        User user = JP_TestUtil.Create_User('011_OUT');
        JP_Management_No__c managementNo = JP_TestUtilContract.createManagementNo(contractInfo, user);
        JP_ConsignmentInformation__c po = JP_TestUtilContract.CreatePo(managementNo);

        Test.startTest();
        po.JP_Header_Text1__c = 'test';
        update po;
        Test.stopTest();
        
    }

    // PO明細
    static testMethod void testPod(){

        List<Account> accList = JP_TestUtil.CreateAccount(1);
        JP_ContractInformation__c contractInfo = JP_TestUtilContract.createContractInformation(accList[0]);
        User user = JP_TestUtil.Create_User('011_OUT');
        JP_Management_No__c managementNo = JP_TestUtilContract.createManagementNo(contractInfo, user);
        JP_ConsignmentInformation__c po = JP_TestUtilContract.CreatePo(managementNo);
        JP_PO_Detail__c pod = JP_TestUtilContract.CreatePod(po);

        Test.startTest();
        pod.JP_ItemText__c = 'test';
        update pod;
        Test.stopTest();
        
    }

    // CyberSecurity
    static testMethod void testNetCyber(){

        List<Account> accList = JP_TestUtil.CreateAccount(1);
        JP_ContractInformation__c contractInfo = JP_TestUtilContract.createContractInformation(accList[0]);
        JP_Net_CyberSecurity__c NetCyber = JP_TestUtilContract.CreateNetCyber(contractInfo);

        Test.startTest();
        NetCyber.Name = 'update';
        update NetCyber;
        Test.stopTest();
        
    }

    // アライド光
    static testMethod void testAlliedHikari(){

        JP_Allied_Hikari__c AlliedHikari = JP_TestUtilContract.CreateAlliedHikari();

        Test.startTest();
        AlliedHikari.Name = 'update';
        update AlliedHikari;
        Test.stopTest();
        
    }

}