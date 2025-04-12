@isTest(SeeAllData=false)
public class Test_JP_CreateOpportunityForLightning {
    // 実行ユーザ指定
    // このテストクラスの実行ユーザを指定しています。
    // 環境ごとにユーザ名が変わるため前方一致にてユーザ選択しています。
    private static User getExcecUser() {
        List<User> userList = new List<User>();
        userList = [select Id From User Where Username like 'jp_motionboard@allied-telesis.co.jp%' ];
        return userList[0];
    }

    /**
     * 管理情報取得メソッドテスト01
     */ 
    static testMethod void testGetManagementNo01() {
        //20231221 テストクラス対応
        Test.startTest();
        User execUser = getExcecUser();
        System.runAs(execUser){
            List<User> userList = createUsers();
            List<Account> accountList = createAccountData();
            List<JP_ContractInformation__c> contractInformation = createContractInformation(accountList);
            List<JP_Management_No__c> managementNo = createManagementNo(contractInformation, userList[0]);
            JP_CreateOpportunityForLightning.getManagementNo(managementNo[0].Id);
        } 
        Test.stopTest();
    }

    /**
     * 管理情報取得メソッドテスト02
     */ 
    static testMethod void testGetManagementNo02() {
        //20231221 テストクラス対応
        Test.startTest();
        User execUser = getExcecUser();
        System.runAs(execUser){
            List<User> userList = createUsers();
            List<Account> accountList = createAccountData();
            List<JP_ContractInformation__c> contractInformation = createContractInformation(accountList);
            List<JP_Management_No__c> managementNo = createManagementNo(contractInformation, userList[0]);
            //JP_CreateOpportunityForLightning.getManagementNo(managementNo[1].Id);
            JP_CreateOpportunityForLightning.getManagementNo(managementNo[0].Id);
        }
        Test.stopTest();
    }

    /**
     * 新規メソッドテスト01
     * 【観点】
     * 　担当営業の有効有無が有効。
     * 　[契約番号].代理店=[契約番号].会社
     */ 
    static testMethod void testCreateNew01() {
        //20231221 テストクラス対応
        Test.startTest();
        User execUser = getExcecUser();
        System.runAs(execUser){
            List<User> userList = createUsers();
            List<Account> accountList = createAccountData();
            List<JP_ContractInformation__c> contractInformation = createContractInformation(accountList);
            List<JP_Management_No__c> managementNo = createManagementNo(contractInformation, userList[0]);
            JP_CreateOpportunityForLightning.createNew(managementNo[0].Id);
    
            // 結果確認：管理番号
            List<JP_Management_No__c> resultManagementNo = getManagementNo(managementNo[0].JP_User_Name__c);
            Id oppId = resultManagementNo[0].JP_Opportunity__c;
            System.assertEquals(1, resultManagementNo.size());
            // 結果確認：商談
            List<Opportunity> opportunity = getOpportunity(oppId);
            System.assertEquals(1, opportunity.size());
            // 結果確認：パートナー
            List<Partner> partner = getPartner(oppId);
            System.assertEquals(0, partner.size());
            // 結果確認：商談チームメンバー
            List<OpportunityTeamMember> opportunityTeamMember = getOpportunityTeamMember(oppId);
            System.assertEquals(1, opportunityTeamMember.size());
        }
        Test.stopTest();
    }

    /**
     * 新規メソッドテスト02
     * 【観点】
     * 　[契約番号].代理店!=[契約番号].会社
     *  流通登録パターン分岐確認①
     */ 
    static testMethod void testCreateNew02() {
        //20231221 テストクラス対応
        Test.startTest();
        User execUser = getExcecUser();
        System.runAs(execUser){
            List<User> userList = createUsers();
            //List<Account> accountList = createAccountData();
            //202312 テスト対応
            List<Id> Ids = new List<Id>();
            Ids.add(createAccountData()[0].Id);
            Ids.add(createAccountData1()[0].Id);
            Ids.add(createAccountData2()[0].Id);
            Ids.add(createAccountData3()[0].Id);
            Ids.add(createAccountData4()[0].Id);
            Ids.add(createAccountData5()[0].Id);
            Ids.add(createAccountData6()[0].Id);
            List<Account> accountList = createidSet(Ids);
            //
            //List<Account> accountList = createAccountData();
            List<JP_ContractInformation__c> contractInformation = createContractInformation(accountList);
            List<JP_Management_No__c> managementNo = createManagementNo(contractInformation, userList[0]);
            JP_Management_No__c targetManagement = managementNo[1];
            JP_CreateOpportunityForLightning.createNew(targetManagement.Id);
    
            // 結果確認：管理番号
            List<JP_Management_No__c> resultManagementNo = getManagementNo(targetManagement.JP_User_Name__c);
            JP_Management_No__c result = resultManagementNo[0];
            System.assertEquals(1, resultManagementNo.size());
            // 結果確認：商談
            List<Opportunity> opportunity = getOpportunity(result.JP_Opportunity__c);
            System.assertEquals(1, opportunity.size());
            // 結果確認：パートナー
            System.debug('result.JP_Opportunity__c '+ result.JP_Opportunity__c);
            List<Partner> partner = getPartner(result.JP_Opportunity__c);
            System.assertNotEquals(0, partner.size());
            // 結果確認：商談チームメンバー
            List<OpportunityTeamMember> opportunityTeamMember = getOpportunityTeamMember(result.JP_Opportunity__c);
            System.assertEquals(1, opportunityTeamMember.size());
        }
        Test.stopTest();
    }

    /**
     * 新規メソッドテスト03
     * 【観点】
     * 　[契約番号].代理店!=[契約番号].会社
     *  流通登録パターン分岐確認②
     */     
    static testMethod void testCreateNew03() {
        //20231221 テストクラス対応
        Test.startTest();
        User execUser = getExcecUser();
        System.runAs(execUser){
            List<User> userList = createUsers();
            List<Id> Ids = new List<Id>();
            //List<Account> accountList = createAccountData();
            //202312 テスト対応
            Ids.add(createAccountData()[0].Id);
            Ids.add(createAccountData1()[0].Id);
            Ids.add(createAccountData2()[0].Id);
            Ids.add(createAccountData3()[0].Id);
            Ids.add(createAccountData4()[0].Id);
            Ids.add(createAccountData5()[0].Id);
            Ids.add(createAccountData6()[0].Id);
            List<Account> accountList = createidSet(Ids);
            //
            List<JP_ContractInformation__c> contractInformation = createContractInformation(accountList);
            List<JP_Management_No__c> managementNo = createManagementNo(contractInformation, userList[0]);
            JP_Management_No__c targetManagement = managementNo[2];
            JP_CreateOpportunityForLightning.createNew(targetManagement.Id);
    
            // 結果確認：管理番号
            List<JP_Management_No__c> resultManagementNo = getManagementNo(targetManagement.JP_User_Name__c);
            JP_Management_No__c result = resultManagementNo[0];
            System.assertEquals(1, resultManagementNo.size());
            // 結果確認：商談
            List<Opportunity> opportunity = getOpportunity(result.JP_Opportunity__c);
            System.assertNotEquals(0, opportunity.size());
            // 結果確認：パートナー
            List<Partner> partner = getPartner(result.JP_Opportunity__c);
            System.assertEquals(1, partner.size());
            // 結果確認：商談チームメンバー
            List<OpportunityTeamMember> opportunityTeamMember = getOpportunityTeamMember(result.JP_Opportunity__c);
            System.assertEquals(1, opportunityTeamMember.size());
        }
        Test.stopTest();
    }

    /**
     * 新規メソッドテスト04
     * 【観点】
     * 　[契約番号].代理店!=[契約番号].会社
     *  流通登録パターン分岐確認④
     */   
    static testMethod void testCreateNew04() {
        //20231221 テストクラス対応
        Test.startTest();
        User execUser = getExcecUser();
        System.runAs(execUser){
            List<User> userList = createUsers();
            //202312 テスト対応
            List<Id> Ids = new List<Id>();
            Ids.add(createAccountData()[0].Id);
            Ids.add(createAccountData1()[0].Id);
            Ids.add(createAccountData2()[0].Id);
            Ids.add(createAccountData3()[0].Id);
            Ids.add(createAccountData4()[0].Id);
            Ids.add(createAccountData5()[0].Id);
            Ids.add(createAccountData6()[0].Id);
            List<Account> accountList = createidSet(Ids);
            //
            //List<Account> accountList = createAccountData();
            List<JP_ContractInformation__c> contractInformation = createContractInformation(accountList);
            List<JP_Management_No__c> managementNo = createManagementNo(contractInformation, userList[0]);
            JP_Management_No__c targetManagement = managementNo[3];
            JP_CreateOpportunityForLightning.createNew(targetManagement.Id);
    
            // 結果確認：管理番号
            List<JP_Management_No__c> resultManagementNo = getManagementNo(targetManagement.JP_User_Name__c);
            JP_Management_No__c result = resultManagementNo[0];
            System.assertEquals(1, resultManagementNo.size());
            // 結果確認：商談
            List<Opportunity> opportunity = getOpportunity(result.JP_Opportunity__c);
            System.assertEquals(1, opportunity.size());
            // 結果確認：パートナー
            List<Partner> partner = getPartner(result.JP_Opportunity__c);
            System.assertNotEquals(0, partner.size());
            // 結果確認：商談チームメンバー
            List<OpportunityTeamMember> opportunityTeamMember = getOpportunityTeamMember(result.JP_Opportunity__c);
            System.assertEquals(1, opportunityTeamMember.size());
        }
        Test.stopTest();
    }

    /**
     * 新規メソッドテスト05
     * 【観点】
     * 　[契約番号].代理店!=[契約番号].会社
     *  流通登録パターン分岐確認⑤
     */ 
    static testMethod void testCreateNew05() {
        //20231221 テストクラス対応
        Test.startTest();
        User execUser = getExcecUser();
        System.runAs(execUser){
            List<User> userList = createUsers();
            //202312 テスト対応
            List<Id> Ids = new List<Id>();
            Ids.add(createAccountData()[0].Id);
            Ids.add(createAccountData1()[0].Id);
            Ids.add(createAccountData2()[0].Id);
            Ids.add(createAccountData3()[0].Id);
            Ids.add(createAccountData4()[0].Id);
            Ids.add(createAccountData5()[0].Id);
            Ids.add(createAccountData6()[0].Id);
            List<Account> accountList = createidSet(Ids);
            //
            //List<Account> accountList = createAccountData();
            List<JP_ContractInformation__c> contractInformation = createContractInformation(accountList);
            List<JP_Management_No__c> managementNo = createManagementNo(contractInformation, userList[0]);
            JP_Management_No__c targetManagement = managementNo[4];
            JP_CreateOpportunityForLightning.createNew(targetManagement.Id);
    
            // 結果確認：管理番号
            List<JP_Management_No__c> resultManagementNo = getManagementNo(targetManagement.JP_User_Name__c);
            JP_Management_No__c result = resultManagementNo[0];
            System.assertEquals(1, resultManagementNo.size());
            // 結果確認：商談
            List<Opportunity> opportunity = getOpportunity(result.JP_Opportunity__c);
            System.assertEquals(1, opportunity.size());
            // 結果確認：パートナー
            List<Partner> partner = getPartner(result.JP_Opportunity__c);
            System.assertNotEquals(0, partner.size());
            // 結果確認：商談チームメンバー
            List<OpportunityTeamMember> opportunityTeamMember = getOpportunityTeamMember(result.JP_Opportunity__c);
            System.assertEquals(1, opportunityTeamMember.size());
        }
        Test.stopTest();
    }

    /**
     * 新規メソッドテスト06
     * 【観点】
     * 　[契約番号].代理店!=[契約番号].会社
     *  流通登録パターン分岐確認⑥
     */ 
    static testMethod void testCreateNew06() {
        //20231221 テストクラス対応
        Test.startTest();
        User execUser = getExcecUser();
        System.runAs(execUser){
            List<User> userList = createUsers();
            //202312 テスト対応
            List<Id> Ids = new List<Id>();
            Ids.add(createAccountData()[0].Id);
            Ids.add(createAccountData1()[0].Id);
            Ids.add(createAccountData2()[0].Id);
            Ids.add(createAccountData3()[0].Id);
            Ids.add(createAccountData4()[0].Id);
            Ids.add(createAccountData5()[0].Id);
            Ids.add(createAccountData6()[0].Id);
            List<Account> accountList = createidSet(Ids);
            //
            //List<Account> accountList = createAccountData();
            List<JP_ContractInformation__c> contractInformation = createContractInformation(accountList);
            List<JP_Management_No__c> managementNo = createManagementNo(contractInformation, userList[0]);
            JP_Management_No__c targetManagement = managementNo[5];
            JP_CreateOpportunityForLightning.createNew(targetManagement.Id);
    
            // 結果確認：管理番号
            List<JP_Management_No__c> resultManagementNo = getManagementNo(targetManagement.JP_User_Name__c);
            JP_Management_No__c result = resultManagementNo[0];
            System.assertEquals(1, resultManagementNo.size());
            // 結果確認：商談
            List<Opportunity> opportunity = getOpportunity(result.JP_Opportunity__c);
            System.assertEquals(1, opportunity.size());
            // 結果確認：パートナー
            List<Partner> partner = getPartner(result.JP_Opportunity__c);
            System.assertNotEquals(0, partner.size());
            // 結果確認：商談チームメンバー
            List<OpportunityTeamMember> opportunityTeamMember = getOpportunityTeamMember(result.JP_Opportunity__c);
            System.assertEquals(1, opportunityTeamMember.size());
        }
        Test.stopTest();
    }

    /**
     * 新規メソッドテスト07
     * 【観点】
     * 　[契約番号].代理店!=[契約番号].会社
     *  流通登録パターン分岐確認⑦
     */ 
    static testMethod void testCreateNew07() {
        //20231221 テストクラス対応
        Test.startTest();
        User execUser = getExcecUser();
        System.runAs(execUser){
            List<User> userList = createUsers();
            //202312 テスト対応
            List<Id> Ids = new List<Id>();
            Ids.add(createAccountData()[0].Id);
            Ids.add(createAccountData1()[0].Id);
            Ids.add(createAccountData2()[0].Id);
            Ids.add(createAccountData3()[0].Id);
            Ids.add(createAccountData4()[0].Id);
            Ids.add(createAccountData5()[0].Id);
            Ids.add(createAccountData6()[0].Id);
            List<Account> accountList = createidSet(Ids);
            //
            //List<Account> accountList = createAccountData();
            List<JP_ContractInformation__c> contractInformation = createContractInformation(accountList);
            List<JP_Management_No__c> managementNo = createManagementNo(contractInformation, userList[0]);
            JP_Management_No__c targetManagement = managementNo[6];
            JP_CreateOpportunityForLightning.createNew(targetManagement.Id);
    
            // 結果確認：管理番号
            List<JP_Management_No__c> resultManagementNo = getManagementNo(targetManagement.JP_User_Name__c);
            JP_Management_No__c result = resultManagementNo[0];
            System.assertEquals(1, resultManagementNo.size());
            // 結果確認：商談
            List<Opportunity> opportunity = getOpportunity(result.JP_Opportunity__c);
            System.assertEquals(1, opportunity.size());
            // 結果確認：パートナー
            List<Partner> partner = getPartner(result.JP_Opportunity__c);
            System.assertNotEquals(0, partner.size());
            // 結果確認：商談チームメンバー
            List<OpportunityTeamMember> opportunityTeamMember = getOpportunityTeamMember(result.JP_Opportunity__c);
            System.assertEquals(1, opportunityTeamMember.size());
        }
        Test.stopTest();
    }
    
    /**
     * 更新メソッドテスト01
     * 【観点】
     * 　担当営業の有効有無が有効。
     * 　[契約番号].代理店=[契約番号].会社
     */ 
    static testMethod void testCreateUpdate01() {
        //20231221 テストクラス対応
        Test.startTest();
        User execUser = getExcecUser();
        System.runAs(execUser){
            List<User> userList = createUsers();
            List<Account> accountList = createAccountData();
            List<JP_ContractInformation__c> contractInformation = createContractInformation(accountList);
            List<JP_Management_No__c> managementNo = createManagementNo(contractInformation, userList[0]);
            JP_CreateOpportunityForLightning.createUpdate(managementNo[0].Id);
            
            // 結果確認：管理番号
            List<JP_Management_No__c> resultManagementNo = getManagementNo(managementNo[0].JP_User_Name__c);
            Id oppId = resultManagementNo[0].JP_Opportunity__c;
            System.assertEquals(1, resultManagementNo.size());
            // 結果確認：商談
            List<Opportunity> opportunity = getOpportunity(oppId);
            System.assertEquals(1, opportunity.size());
            // 結果確認：パートナー
            List<Partner> partner = getPartner(oppId);
            System.assertEquals(0, partner.size());
            // 結果確認：商談チームメンバー
            List<OpportunityTeamMember> opportunityTeamMember = getOpportunityTeamMember(oppId);
            System.assertEquals(1, opportunityTeamMember.size());
        }
        Test.stopTest();
    }
    
    /**
     * 更新メソッドテスト02
     * 【観点】
     * 　担当営業の有効有無が無効。
     * 　[契約番号].代理店=[契約番号].会社
     */
    static testMethod void testCreateUpdate02() {
        //20231221 テストクラス対応
        Test.startTest();
        User execUser = getExcecUser();
        System.runAs(execUser){
            List<User> userList = createUsers();
            List<Account> accountList = createAccountData();
            List<JP_ContractInformation__c> contractInformation = createContractInformation(accountList);
            List<JP_Management_No__c> managementNo = createManagementNo(contractInformation, userList[1]);
            JP_CreateOpportunityForLightning.createUpdate(managementNo[0].Id);
            
            // 結果確認：管理番号
            List<JP_Management_No__c> resultManagementNo = getManagementNo(managementNo[0].JP_User_Name__c);
            Id oppId = resultManagementNo[0].JP_Opportunity__c;
            System.assertEquals(1, resultManagementNo.size());
            // 結果確認：商談
            List<Opportunity> opportunity = getOpportunity(oppId);
            System.assertEquals(1, opportunity.size());
            // 結果確認：パートナー
            List<Partner> partner = getPartner(oppId);
            System.assertEquals(0, partner.size());
            // 結果確認：商談チームメンバー
            List<OpportunityTeamMember> opportunityTeamMember = getOpportunityTeamMember(oppId);
            System.assertEquals(0, opportunityTeamMember.size());
        }
        Test.stopTest();
    }
    
    // 取引先作成
    private static List<Account> createAccountData(){
        String[] arrayName = new String[]{'テスト会社'};  /*{'テスト会社' , 'テスト会社2' , JP_Const.CONPANY_NAME_DIS, 
            JP_Const.CONPANY_NAME_SIT, JP_Const.CONPANY_NAME_SBB, JP_Const.CONPANY_NAME_OTS, JP_Const.CONPANY_NAME_STL}; */
        List<Account> accountList = new List<Account>();
        for (String name : arrayName) {
            Account acc = new Account();
            acc.Name = name;
            acc.Phone = '0312345678';
            accountList.add(acc);
		}
        System.debug('accountList ' + accountList);
        insert accountList;
        return accountList;
        //
    }    
    private static List<Account> createAccountData1(){
        String[] arrayName1 = new String[]{'テスト会社2'};  /*{'テスト会社' , 'テスト会社2' , JP_Const.CONPANY_NAME_DIS, 
            JP_Const.CONPANY_NAME_SIT, JP_Const.CONPANY_NAME_SBB, JP_Const.CONPANY_NAME_OTS, JP_Const.CONPANY_NAME_STL}; */
        List<Account> accountList1 = new List<Account>();
        for (String name : arrayName1) {
            Account acc = new Account();
            acc.Name = name;
            acc.Phone = '0312345678';
            accountList1.add(acc);
		}
        System.debug('accountList1 ' + accountList1);
        insert accountList1;
        return accountList1;
    }
    private static List<Account> createAccountData2(){    
        String[] arrayName2 = new String[]{'JP_Const.CONPANY_NAME_DIS'};  /*{'テスト会社' , 'テスト会社2' , JP_Const.CONPANY_NAME_DIS, 
            JP_Const.CONPANY_NAME_SIT, JP_Const.CONPANY_NAME_SBB, JP_Const.CONPANY_NAME_OTS, JP_Const.CONPANY_NAME_STL}; */
        List<Account> accountList2 = new List<Account>();
        for (String name : arrayName2) {
            Account acc = new Account();
            acc.Name = name;
            acc.Phone = '0312345678';
            accountList2.add(acc);
		}
        insert accountList2;
        return accountList2;
    }
    private static List<Account> createAccountData3(){    
        String[] arrayName3 = new String[]{'JP_Const.CONPANY_NAME_SIT'};  /*{'テスト会社' , 'テスト会社2' , JP_Const.CONPANY_NAME_DIS, 
        JP_Const.CONPANY_NAME_SIT, JP_Const.CONPANY_NAME_SBB, JP_Const.CONPANY_NAME_OTS, JP_Const.CONPANY_NAME_STL}; */
        List<Account> accountList3 = new List<Account>();
        for (String name : arrayName3) {
        Account acc = new Account();
        acc.Name = name;
        acc.Phone = '0312345678';
        accountList3.add(acc);
        }
        insert accountList3;
        return accountList3;
    }
    private static List<Account> createAccountData4(){    
        String[] arrayName4 = new String[]{'JP_Const.CONPANY_NAME_SBB'};  /*{'テスト会社' , 'テスト会社2' , JP_Const.CONPANY_NAME_DIS, 
        JP_Const.CONPANY_NAME_SIT, JP_Const.CONPANY_NAME_SBB, JP_Const.CONPANY_NAME_OTS, JP_Const.CONPANY_NAME_STL}; */
        List<Account> accountList4 = new List<Account>();
        for (String name : arrayName4) {
        Account acc = new Account();
        acc.Name = name;
        acc.Phone = '0312345678';
        accountList4.add(acc);
        }
        insert accountList4;
        return accountList4;
    }
    private static List<Account> createAccountData5(){
        String[] arrayName5 = new String[]{'JP_Const.CONPANY_NAME_OTS'};  /*{'テスト会社' , 'テスト会社2' , JP_Const.CONPANY_NAME_DIS, 
        JP_Const.CONPANY_NAME_SIT, JP_Const.CONPANY_NAME_SBB, JP_Const.CONPANY_NAME_OTS, JP_Const.CONPANY_NAME_STL}; */
        List<Account> accountList5 = new List<Account>();
        for (String name : arrayName5) {
        Account acc = new Account();
        acc.Name = name;
        acc.Phone = '0312345678';
        accountList5.add(acc);
        }
        System.debug('accountList5 ' + accountList5);
        insert accountList5;
        return accountList5;
    } 
    private static List<Account> createAccountData6(){   
        String[] arrayName6 = new String[]{'JP_Const.CONPANY_NAME_STL'};  /*{'テスト会社' , 'テスト会社2' , JP_Const.CONPANY_NAME_DIS, 
        JP_Const.CONPANY_NAME_SIT, JP_Const.CONPANY_NAME_SBB, JP_Const.CONPANY_NAME_OTS, JP_Const.CONPANY_NAME_STL}; */
        List<Account> accountList6 = new List<Account>();
        for (String name : arrayName6) {
        Account acc = new Account();
        acc.Name = name;
        acc.Phone = '0312345678';
        accountList6.add(acc);
        }
        System.debug('accountList6 ' + accountList6);
        insert accountList6;
        return accountList6;
    }
    
    //Idの集約
    private static List<Account> createidSet(List<Id> Ids) {        
        List<Account> accountList = new List<Account>();
    
        String[] arrayName = new String[]{'テスト会社2', 'テスト会社3', JP_Const.CONPANY_NAME_DIS, 
                                          JP_Const.CONPANY_NAME_SIT, JP_Const.CONPANY_NAME_SBB, 
                                          JP_Const.CONPANY_NAME_OTS, JP_Const.CONPANY_NAME_STL};                                   
        //
        for (Integer i = 0; i < arrayName.size(); i++) {
            Account acc = new Account();
            acc.Id = Ids[i];
            acc.Name = arrayName[i];
            acc.Phone = '0312345678';
            accountList.add(acc);
        }
    
        return accountList;
    }
    
    // 契約情報作成
    private static List<JP_ContractInformation__c> createContractInformation(List<Account> accountList) {

        List<JP_ContractInformation__c> listCon = new List<JP_ContractInformation__c>();
        for (Integer i = 0; i < accountList.size(); i++) {
            JP_ContractInformation__c contractInfo = new JP_ContractInformation__c();
            if (0 == i) {
				contractInfo.JP_Company__c = accountList[i].Id;
				contractInfo.JP_Agency__c = accountList[i].Id;
            } else {
				contractInfo.JP_Company__c = accountList[i - 1].Id;
				contractInfo.JP_Agency__c = accountList[i].Id;
            }
            listCon.add(contractInfo);
        }
        insert listCon;
        return listCon;
    }
    
    // 管理情報作成
    private static List<JP_Management_No__c> createManagementNo(List<JP_ContractInformation__c> listCon, User user) {
        List<JP_Management_No__c> listMana = new List<JP_Management_No__c>();
        for (Integer i = 0; i < listCon.size(); i++) {
            JP_Management_No__c mana = new JP_Management_No__c();
            mana.JP_Contract_No__c = listCon[i].Id;
            mana.JP_Sales_Reference__c = user.Id;
            mana.JP_User_Name__c = 'createTestテストお客様名00' + i;

            if (i == 0) {
            	mana.JP_User_Address__c = '東京品川';
            } else if (i == 1) {
            	mana.JP_User_Address__c = '北海道釧市111';
            } else if (i == 2) {
            	mana.JP_User_Address__c = '神奈川県川崎111';
            } else if (i == 3) {
            	mana.JP_User_Address__c = '千葉県';
            } else {
            	mana.JP_User_Address__c = '東京都品川区111';
            }

            mana.JP_StaYmd__c = Date.Today();
            mana.JP_Claim_Name__c = 'テストお客様代理店';
            mana.JP_Service_Type__c = 'Net.AMF_ライト';
            listMana.add(mana);
		}
        System.debug('listMana' + listMana);
        insert listMana;
        return listMana;
    }
    
    // ユーザ作成
	private static List<User> createUsers() {
        Profile Profile = getProfile('システム管理者');
		List<User> users = new List<User>();
		for (Integer i = 1; i <= 2; i++) {
			User user = new User();
            user.LastName = 'テラスカイ';
            user.FirstName = String.valueOf(i);
            user.Alias = 'user';
            user.Email = 'testuser@terrasky.co.jp';
            user.UserName = 'testCreateOpp'+ i + Profile.Id +  '@terrasky.co.jp.test';
            user.EmailEncodingKey = 'ISO-2022-JP';
            user.TimeZoneSidKey = 'Asia/Tokyo ';
            user.LocaleSidKey = 'ja_JP';
            user.LanguageLocaleKey = 'ja';
            user.ProfileId = Profile.Id;
            user.Department = 'TEST部';
            user.Title = 'TEST役職';
            if (i == 2) {
                user.IsActive = false;
            } else {
                user.IsActive = true;
            }
			users.add(user);
		}
		insert users;
		return users;
	}
   
    //プロファイル取得
    private static Profile getProfile(String PROFILE_NAME) {
        return [select Id,Name from Profile where Name =: PROFILE_NAME limit 1];
    }
    
    // 管理番号取得
    private static List<JP_Management_No__c> getManagementNo(String userName) {
        System.debug('userName' + userName);
        List<JP_Management_No__c> ManagementNoList = [
            select Id, JP_Opportunity__c from JP_Management_No__c where JP_User_Name__c =:userName
        ];
        System.debug('ManagementNoList ' + ManagementNoList);
        return ManagementNoList;
	}
    
    // 商談取得
    private static List<Opportunity> getOpportunity(Id oppId) {
        List<Opportunity> opportunityList = [
            select Id from Opportunity where Id =:oppId
        ];
        return opportunityList;
	}

    // パートナー取得
    private static List<Partner> getPartner(Id oppId) {
        System.debug('oppId ' + oppId);
        List<Partner> partnerList = [
            select Id from Partner where OpportunityId =:oppId
        ];
        System.debug('partnerList ' + partnerList);
        return partnerList;
	}
    
    // 商談チームメンバー取得
    private static List<OpportunityTeamMember> getOpportunityTeamMember(Id oppId) {
        List<OpportunityTeamMember> opportunityTeamMemberList = [
            select Id from OpportunityTeamMember where OpportunityId =:oppId
        ];
        return opportunityTeamMemberList;
	}
    

}