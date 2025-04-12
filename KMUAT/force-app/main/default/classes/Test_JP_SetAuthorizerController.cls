@isTest
private class Test_JP_SetAuthorizerController {
    static List<JP_QuotationDistributor__c> distibutors = JP_TestUtil.Create_JP_QuotationDistributor();
    static List<JP_QuotationContact__c> qcList = [Select Id,Name From JP_QuotationContact__c Where JP_QuotationDistributor__c=:distibutors[0].id Order by Name];
    
    /**
     *Steptypeが'User'の場合
     */
    static testMethod void testMethodO1() {
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
        }
        
        insert qhList;
        
        JP_QuotationHeader__c rec = qhList[0];
        
        PageReference pref = Page.JP_SetAuthorizer;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        
        JP_ApprovalProcessMaster__c apm = Create_JP_ApprovalProcessMaster(1);
        
        Test.startTest();
        
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
        JP_SetAuthorizerController saCtrl = new JP_SetAuthorizerController(sc);
        
        List<String> step1 = saCtrl.step1;
        List<String> step2 = saCtrl.step2;
        List<String> step3 = saCtrl.step3;
        List<String> step4 = saCtrl.step4;
        List<String> step5 = saCtrl.step5;
        List<String> step6 = saCtrl.step6;
        
        Test.stopTest();
        
        System.assertEquals(saCtrl.apm.JP_Step1type__c, saCtrl.QHeader.JP_Step1type__c);
        System.assertEquals(saCtrl.apm.JP_Step2type__c, saCtrl.QHeader.JP_Step2type__c);
        System.assertEquals(saCtrl.apm.JP_Step3type__c, saCtrl.QHeader.JP_Step3type__c);
        System.assertEquals(saCtrl.apm.JP_Step4type__c, saCtrl.QHeader.JP_Step4type__c);
        System.assertEquals(saCtrl.apm.JP_Step5type__c, saCtrl.QHeader.JP_Step5type__c);
        System.assertEquals(saCtrl.apm.JP_Step6type__c, saCtrl.QHeader.JP_Step6type__c);
    }
    
    
    /**
     *Steptypeが'Queue'の場合
     */
    static testMethod void testMethodO2() {
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
        }
        
        insert qhList;
        
        JP_QuotationHeader__c rec = qhList[0];
        
        PageReference pref = Page.JP_SetAuthorizer;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        
        JP_ApprovalProcessMaster__c apm = Create_JP_ApprovalProcessMaster(1);
        apm.JP_Step1type__c = 'Queue';
        apm.JP_Step2type__c = 'Queue';
        apm.JP_Step3type__c = 'Queue';
        apm.JP_Step4type__c = 'Queue';
        apm.JP_Step5type__c = 'Queue';
        apm.JP_Step6type__c = 'Queue';
        apm.JP_Step1Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step2Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step3Approver__c = JP_Const.MANAGER;
        apm.JP_Step4Approver__c = JP_Const.MANAGER;
        apm.JP_Step5Approver__c = JP_Const.GENERAL_MANAGER;
        apm.JP_Step6Approver__c = JP_Const.GENERAL_MANAGER;
        
        update apm;
        
        Test.startTest();
        
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
        JP_SetAuthorizerController saCtrl = new JP_SetAuthorizerController(sc);
        
        Test.stopTest();
        
        System.assertEquals(true, saCtrl.STEP1Queue);
        System.assertEquals(true, saCtrl.STEP2Queue);
        System.assertEquals(true, saCtrl.STEP3Queue);
        System.assertEquals(true, saCtrl.STEP4Queue);
        System.assertEquals(true, saCtrl.STEP5Queue);
        System.assertEquals(true, saCtrl.STEP6Queue);
        
        System.assertEquals('JP_' + saCtrl.apm.JP_Step1Approver__c, saCtrl.QUEUE1NAME);
        System.assertEquals('JP_' + saCtrl.apm.JP_Step2Approver__c, saCtrl.QUEUE2NAME);
        System.assertEquals('JP_' + saCtrl.apm.JP_Step3Approver__c, saCtrl.QUEUE3NAME);
        System.assertEquals('JP_' + saCtrl.apm.JP_Step4Approver__c, saCtrl.QUEUE4NAME);
        System.assertEquals('JP_' + saCtrl.apm.JP_Step5Approver__c, saCtrl.QUEUE5NAME);
        System.assertEquals('JP_' + saCtrl.apm.JP_Step6Approver__c, saCtrl.QUEUE6NAME);
        
        System.assertEquals(saCtrl.QHeader.JP_Step1type__c, saCtrl.apm.JP_Step1type__c + ':' + saCtrl.apm.JP_Step1Approver__c);
        System.assertEquals(saCtrl.QHeader.JP_Step2type__c, saCtrl.apm.JP_Step2type__c + ':' + saCtrl.apm.JP_Step2Approver__c);
        System.assertEquals(saCtrl.QHeader.JP_Step3type__c, saCtrl.apm.JP_Step3type__c + ':' + saCtrl.apm.JP_Step3Approver__c);
        System.assertEquals(saCtrl.QHeader.JP_Step4type__c, saCtrl.apm.JP_Step4type__c + ':' + saCtrl.apm.JP_Step4Approver__c);
        System.assertEquals(saCtrl.QHeader.JP_Step5type__c, saCtrl.apm.JP_Step5type__c + ':' + saCtrl.apm.JP_Step5Approver__c);
        System.assertEquals(saCtrl.QHeader.JP_Step6type__c, saCtrl.apm.JP_Step6type__c + ':' + saCtrl.apm.JP_Step6Approver__c);
        
        System.assertEquals(0, saCtrl.step1.size());
        System.assertEquals(0, saCtrl.step2.size());
        System.assertEquals(0, saCtrl.step3.size());
        System.assertEquals(0, saCtrl.step4.size());
        System.assertEquals(0, saCtrl.step5.size());
        System.assertEquals(0, saCtrl.step6.size());
    }
    
    
    /**
     *Steptypeが空白の場合
     */
    static testMethod void testMethodO3() {
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
        }
        
        insert qhList;
        
        JP_QuotationHeader__c rec = qhList[0];
        
        PageReference pref = Page.JP_SetAuthorizer;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        
        JP_ApprovalProcessMaster__c apm = Create_JP_ApprovalProcessMaster(1);
        apm.JP_Step1type__c = '';
        apm.JP_Step2type__c = '';
        apm.JP_Step3type__c = '';
        apm.JP_Step4type__c = '';
        apm.JP_Step5type__c = '';
        apm.JP_Step6type__c = '';
        update apm;
        
        Test.startTest();
        
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
        JP_SetAuthorizerController saCtrl = new JP_SetAuthorizerController(sc);
        
        Test.stopTest();
        
        System.assertEquals(0, saCtrl.step1.size());
        System.assertEquals(0, saCtrl.step2.size());
        System.assertEquals(0, saCtrl.step3.size());
        System.assertEquals(0, saCtrl.step4.size());
        System.assertEquals(0, saCtrl.step5.size());
        System.assertEquals(0, saCtrl.step6.size());
    }
    
    
    /**
     *Step1ApproverがJP_SectionChiefの場合、StepCnt＝1の場合
     */
    static testMethod void testMethod1101() {
        User usr = JP_TestUtil.Create_ApproverUser('A121_課長');

        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
            qh.JP_Step1Approver__c = usr.Id;
            qh.JP_SectionChief__c = usr.Id;
        }
        
        insert qhList;
        
        JP_QuotationHeader__c rec = qhList[0];
        
        PageReference pref = Page.JP_SetAuthorizer;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        
        JP_ApprovalProcessMaster__c apm = Create_JP_ApprovalProcessMaster(1);
        apm.JP_Step1Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_StepCnt__c = 1;
        update apm;
        
        Test.startTest();
        
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
        JP_SetAuthorizerController saCtrl = new JP_SetAuthorizerController(sc);
        
        List<String> step1 = saCtrl.step1;
        List<String> step2 = saCtrl.step2;
        List<String> step3 = saCtrl.step3;
        List<String> step4 = saCtrl.step4;
        List<String> step5 = saCtrl.step5;
        List<String> step6 = saCtrl.step6;
        saCtrl.doSave();
        
        Test.stopTest();
        
        System.assertEquals(saCtrl.QHeader.JP_SectionChief__c, saCtrl.QHeader.JP_step1Approver__c);
    }
    
    
    /**
     *Step1ApproverがJP_Managerの場合、StepCnt＝1の場合、JP_Step1type__c≠'User'の場合
     */
    static testMethod void testMethod1102() {
        User usr = JP_TestUtil.Create_ApproverUser('A131_部長');
        
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
            qh.JP_Step1Approver__c = usr.Id;
            qh.JP_Manager__c = usr.Id;
        }
        
        insert qhList;
        
        JP_QuotationHeader__c rec = qhList[0];
        
        PageReference pref = Page.JP_SetAuthorizer;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        
        JP_ApprovalProcessMaster__c apm = Create_JP_ApprovalProcessMaster(1);
        apm.JP_Step1Approver__c = JP_Const.MANAGER;
        apm.JP_StepCnt__c = 1;
        apm.JP_Step1type__c = '';
        update apm;
        
        Test.startTest();
        
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
        JP_SetAuthorizerController saCtrl = new JP_SetAuthorizerController(sc);
        
        List<String> step1 = saCtrl.step1;
        List<String> step2 = saCtrl.step2;
        List<String> step3 = saCtrl.step3;
        List<String> step4 = saCtrl.step4;
        List<String> step5 = saCtrl.step5;
        List<String> step6 = saCtrl.step6;
        saCtrl.doSave();
        
        Test.stopTest();
        
        System.assertEquals(saCtrl.QHeader.JP_Manager__c, saCtrl.QHeader.JP_step1Approver__c);
    }
    
    
    /**
     *Step1ApproverがJP_GeneralManagerの場合、StepCnt＝1の場合
     */
    static testMethod void testMethod1103() {
        User usr = JP_TestUtil.Create_ApproverUser('A141_本部長');
        
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
            qh.JP_Step1Approver__c = usr.Id;
            qh.JP_GeneralManager__c = usr.Id;
        }
        
        insert qhList;
        
        JP_QuotationHeader__c rec = qhList[0];
        
        PageReference pref = Page.JP_SetAuthorizer;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        
        JP_ApprovalProcessMaster__c apm = Create_JP_ApprovalProcessMaster(1);
        apm.JP_Step1Approver__c = JP_Const.GENERAL_MANAGER;
        apm.JP_StepCnt__c = 1;
        update apm;
        
        Test.startTest();
        
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
        JP_SetAuthorizerController saCtrl = new JP_SetAuthorizerController(sc);
        
        List<String> step1 = saCtrl.step1;
        List<String> step2 = saCtrl.step2;
        List<String> step3 = saCtrl.step3;
        List<String> step4 = saCtrl.step4;
        List<String> step5 = saCtrl.step5;
        List<String> step6 = saCtrl.step6;
        saCtrl.doSave();
        
        Test.stopTest();
        
        System.assertEquals(saCtrl.QHeader.JP_GeneralManager__c, saCtrl.QHeader.JP_step1Approver__c);
    }
    
    
    /**
     *Step2ApproverがJP_Managerの場合、StepCnt＝2の場合
     */
    static testMethod void testMethod1201() {
        User usr1 = JP_TestUtil.Create_ApproverUser('A121_課長');
        
        User usr2 = JP_TestUtil.Create_ApproverUser('A131_部長');
        
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
            qh.JP_Step1Approver__c = usr1.Id;
            qh.JP_Step2Approver__c = usr2.Id;
            qh.JP_SectionChief__c = usr1.Id;
            qh.JP_Manager__c = usr2.Id;
        }
        
        insert qhList;
        
        JP_QuotationHeader__c rec = qhList[0];
        
        PageReference pref = Page.JP_SetAuthorizer;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        
        JP_ApprovalProcessMaster__c apm = Create_JP_ApprovalProcessMaster(1);
        apm.JP_Step1Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step2Approver__c = JP_Const.MANAGER;
        apm.JP_StepCnt__c = 2;
        update apm;
        
        Test.startTest();
        
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
        JP_SetAuthorizerController saCtrl = new JP_SetAuthorizerController(sc);
        
        List<String> step1 = saCtrl.step1;
        List<String> step2 = saCtrl.step2;
        List<String> step3 = saCtrl.step3;
        List<String> step4 = saCtrl.step4;
        List<String> step5 = saCtrl.step5;
        List<String> step6 = saCtrl.step6;
        saCtrl.doSave();
        
        Test.stopTest();
        
        System.assertEquals(saCtrl.QHeader.JP_Manager__c, saCtrl.QHeader.JP_step2Approver__c);
    }
    
    
    /**
     *Step2ApproverがJP_GeneralManagerの場合、StepCnt＝2の場合、JP_Step2type__c≠'User'の場合
     */
    static testMethod void testMethod1202() {
        User usr1 = JP_TestUtil.Create_ApproverUser('A121_課長');
        
        User usr2 = JP_TestUtil.Create_ApproverUser('A141_本部長');
        
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
            qh.JP_Step1Approver__c = usr1.Id;
            qh.JP_Step2Approver__c = usr2.Id;
            qh.JP_SectionChief__c = usr1.Id;
            qh.JP_GeneralManager__c = usr2.Id;
        }
        
        insert qhList;
        
        JP_QuotationHeader__c rec = qhList[0];
        
        PageReference pref = Page.JP_SetAuthorizer;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        
        JP_ApprovalProcessMaster__c apm = Create_JP_ApprovalProcessMaster(1);
        apm.JP_Step1Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step2Approver__c = JP_Const.GENERAL_MANAGER;
        apm.JP_StepCnt__c = 2;
        apm.JP_Step2type__c = '';
        update apm;
        
        Test.startTest();
        
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
        JP_SetAuthorizerController saCtrl = new JP_SetAuthorizerController(sc);
        
        List<String> step1 = saCtrl.step1;
        List<String> step2 = saCtrl.step2;
        List<String> step3 = saCtrl.step3;
        List<String> step4 = saCtrl.step4;
        List<String> step5 = saCtrl.step5;
        List<String> step6 = saCtrl.step6;
        saCtrl.doSave();
        
        Test.stopTest();
        
        System.assertEquals(saCtrl.QHeader.JP_GeneralManager__c, saCtrl.QHeader.JP_step2Approver__c);
    }
    
    
    /**
     *Step3ApproverがJP_SectionChiefの場合、StepCnt＝3の場合
     */
    static testMethod void testMethod1301() {
        List<User> usrs = new List<User>();
        User usr1 = JP_TestUtil.Create_ApproverUser('A121_課長');
        
        User usr2 = JP_TestUtil.Create_ApproverUser('A131_部長');
        
        User usr3 = JP_TestUtil.Create_ApproverUser('A141_本部長');
        
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
            qh.JP_Step1Approver__c = usr1.Id;
            qh.JP_Step2Approver__c = usr1.Id;
            qh.JP_Step3Approver__c = usr1.Id;
            qh.JP_SectionChief__c = usr1.Id;
        }
        
        insert qhList;
        
        JP_QuotationHeader__c rec = qhList[0];
        
        PageReference pref = Page.JP_SetAuthorizer;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        
        JP_ApprovalProcessMaster__c apm = Create_JP_ApprovalProcessMaster(1);
        apm.JP_Step1Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step2Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step3Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_StepCnt__c = 3;
        update apm;
        
        Test.startTest();
        
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
        JP_SetAuthorizerController saCtrl = new JP_SetAuthorizerController(sc);
        
        List<String> step1 = saCtrl.step1;
        List<String> step2 = saCtrl.step2;
        List<String> step3 = saCtrl.step3;
        List<String> step4 = saCtrl.step4;
        List<String> step5 = saCtrl.step5;
        List<String> step6 = saCtrl.step6;
        saCtrl.doSave();
        
        Test.stopTest();
        
        System.assertEquals(saCtrl.QHeader.JP_SectionChief__c, saCtrl.QHeader.JP_step3Approver__c);
    }
    
    
    /**
     *Step3ApproverがJP_Managerの場合、StepCnt＝3の場合、JP_Step3type__c≠'User'の場合
     */
    static testMethod void testMethod1302() {
        List<User> usrs = new List<User>();
        User usr1 = JP_TestUtil.Create_ApproverUser('A121_課長');
        
        User usr2 = JP_TestUtil.Create_ApproverUser('A131_部長');
        
        User usr3 = JP_TestUtil.Create_ApproverUser('A141_本部長');
        
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
            qh.JP_Step1Approver__c = usr1.Id;
            qh.JP_Step2Approver__c = usr2.Id;
            qh.JP_Step3Approver__c = usr2.Id;
            qh.JP_SectionChief__c = usr1.Id;
            qh.JP_Manager__c = usr2.Id;
        }
        
        insert qhList;
        
        JP_QuotationHeader__c rec = qhList[0];
        
        PageReference pref = Page.JP_SetAuthorizer;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        
        JP_ApprovalProcessMaster__c apm = Create_JP_ApprovalProcessMaster(1);
        apm.JP_Step1Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step2Approver__c = JP_Const.MANAGER;
        apm.JP_Step3Approver__c = JP_Const.MANAGER;
        apm.JP_StepCnt__c = 3;
        apm.JP_Step3type__c = '';
        update apm;
        
        Test.startTest();
        
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
        JP_SetAuthorizerController saCtrl = new JP_SetAuthorizerController(sc);
        
        List<String> step1 = saCtrl.step1;
        List<String> step2 = saCtrl.step2;
        List<String> step3 = saCtrl.step3;
        List<String> step4 = saCtrl.step4;
        List<String> step5 = saCtrl.step5;
        List<String> step6 = saCtrl.step6;
        saCtrl.doSave();
        
        Test.stopTest();
        
        System.assertEquals(saCtrl.QHeader.JP_Manager__c, saCtrl.QHeader.JP_step3Approver__c);
    }
    
    
    /**
     *Step3ApproverがJP_GeneralManager__cの場合、StepCnt＝3の場合
     */
    static testMethod void testMethod1303() {
        List<User> usrs = new List<User>();
        User usr1 = JP_TestUtil.Create_ApproverUser('A121_課長');
        
        User usr2 = JP_TestUtil.Create_ApproverUser('A131_部長');
        
        User usr3 = JP_TestUtil.Create_ApproverUser('A141_本部長');
        
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
            qh.JP_Step1Approver__c = usr1.Id;
            qh.JP_Step2Approver__c = usr2.Id;
            qh.JP_Step3Approver__c = usr3.Id;
            qh.JP_SectionChief__c = usr1.Id;
            qh.JP_Manager__c = usr2.Id;
            qh.JP_GeneralManager__c = usr3.Id;
        }
        
        insert qhList;
        
        JP_QuotationHeader__c rec = qhList[0];
        
        PageReference pref = Page.JP_SetAuthorizer;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        
        JP_ApprovalProcessMaster__c apm = Create_JP_ApprovalProcessMaster(1);
        apm.JP_Step1Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step2Approver__c = JP_Const.MANAGER;
        apm.JP_Step3Approver__c = JP_Const.GENERAL_MANAGER;
        apm.JP_StepCnt__c = 3;
        update apm;
        
        Test.startTest();
        
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
        JP_SetAuthorizerController saCtrl = new JP_SetAuthorizerController(sc);
        
        List<String> step1 = saCtrl.step1;
        List<String> step2 = saCtrl.step2;
        List<String> step3 = saCtrl.step3;
        List<String> step4 = saCtrl.step4;
        List<String> step5 = saCtrl.step5;
        List<String> step6 = saCtrl.step6;
        saCtrl.doSave();
        
        Test.stopTest();
        
        System.assertEquals(saCtrl.QHeader.JP_GeneralManager__c, saCtrl.QHeader.JP_step3Approver__c);
    }
    
    
    /**
     *Step4ApproverがJP_SectionChiefの場合、StepCnt＝4の場合
     */
    static testMethod void testMethod1401() {
        List<User> usrs = new List<User>();
        User usr1 = JP_TestUtil.Create_ApproverUser('A121_課長');
        
        User usr2 = JP_TestUtil.Create_ApproverUser('A131_部長');
        
        User usr3 = JP_TestUtil.Create_ApproverUser('A141_本部長');
        
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
            qh.JP_Step1Approver__c = usr1.Id;
            qh.JP_Step2Approver__c = usr1.Id;
            qh.JP_Step3Approver__c = usr1.Id;
            qh.JP_Step4Approver__c = usr1.Id;
            qh.JP_SectionChief__c = usr1.Id;
        }
        
        insert qhList;
        
        JP_QuotationHeader__c rec = qhList[0];
        
        PageReference pref = Page.JP_SetAuthorizer;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        
        JP_ApprovalProcessMaster__c apm = Create_JP_ApprovalProcessMaster(1);
        apm.JP_Step1Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step2Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step3Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step4Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_StepCnt__c = 4;
        update apm;
        
        Test.startTest();
        
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
        JP_SetAuthorizerController saCtrl = new JP_SetAuthorizerController(sc);
        
        List<String> step1 = saCtrl.step1;
        List<String> step2 = saCtrl.step2;
        List<String> step3 = saCtrl.step3;
        List<String> step4 = saCtrl.step4;
        List<String> step5 = saCtrl.step5;
        List<String> step6 = saCtrl.step6;
        saCtrl.doSave();
        
        Test.stopTest();
        
        System.assertEquals(saCtrl.QHeader.JP_SectionChief__c, saCtrl.QHeader.JP_step4Approver__c);
    }
    
    
    /**
     *Step4ApproverがJP_Managerの場合、StepCnt＝4の場合
     */
    static testMethod void testMethod1402() {
        List<User> usrs = new List<User>();
        User usr1 = JP_TestUtil.Create_ApproverUser('A121_課長');
        
        User usr2 = JP_TestUtil.Create_ApproverUser('A131_部長');
        
        User usr3 = JP_TestUtil.Create_ApproverUser('A141_本部長');
        
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
            qh.JP_Step1Approver__c = usr1.Id;
            qh.JP_Step2Approver__c = usr2.Id;
            qh.JP_Step3Approver__c = usr2.Id;
            qh.JP_Step4Approver__c = usr2.Id;
            qh.JP_SectionChief__c = usr1.Id;
            qh.JP_Manager__c = usr2.Id;
        }
        
        insert qhList;
        
        JP_QuotationHeader__c rec = qhList[0];
        
        PageReference pref = Page.JP_SetAuthorizer;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        
        JP_ApprovalProcessMaster__c apm = Create_JP_ApprovalProcessMaster(1);
        apm.JP_Step1Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step2Approver__c = JP_Const.MANAGER;
        apm.JP_Step3Approver__c = JP_Const.MANAGER;
        apm.JP_Step4Approver__c = JP_Const.MANAGER;
        apm.JP_StepCnt__c = 4;
        update apm;
        
        Test.startTest();
        
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
        JP_SetAuthorizerController saCtrl = new JP_SetAuthorizerController(sc);
        
        List<String> step1 = saCtrl.step1;
        List<String> step2 = saCtrl.step2;
        List<String> step3 = saCtrl.step3;
        List<String> step4 = saCtrl.step4;
        List<String> step5 = saCtrl.step5;
        List<String> step6 = saCtrl.step6;
        saCtrl.doSave();
        
        Test.stopTest();
        
        System.assertEquals(saCtrl.QHeader.JP_Manager__c, saCtrl.QHeader.JP_step4Approver__c);
    }
    
    
    /**
     *Step4ApproverがJP_GeneralManager__cの場合、StepCnt＝4の場合
     */
    static testMethod void testMethod1403() {
        List<User> usrs = new List<User>();
        User usr1 = JP_TestUtil.Create_ApproverUser('A121_課長');
        
        User usr2 = JP_TestUtil.Create_ApproverUser('A131_部長');
        
        User usr3 = JP_TestUtil.Create_ApproverUser('A141_本部長');
        
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
            qh.JP_Step1Approver__c = usr1.Id;
            qh.JP_Step2Approver__c = usr2.Id;
            qh.JP_Step3Approver__c = usr2.Id;
            qh.JP_Step4Approver__c = usr3.Id;
            qh.JP_SectionChief__c = usr1.Id;
            qh.JP_Manager__c = usr2.Id;
            qh.JP_GeneralManager__c = usr3.Id;
        }
        
        insert qhList;
        
        JP_QuotationHeader__c rec = qhList[0];
        
        PageReference pref = Page.JP_SetAuthorizer;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        
        JP_ApprovalProcessMaster__c apm = Create_JP_ApprovalProcessMaster(1);
        apm.JP_Step1Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step2Approver__c = JP_Const.MANAGER;
        apm.JP_Step3Approver__c = JP_Const.MANAGER;
        apm.JP_Step4Approver__c = JP_Const.GENERAL_MANAGER;
        apm.JP_StepCnt__c = 4;
        update apm;
        
        Test.startTest();
        
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
        JP_SetAuthorizerController saCtrl = new JP_SetAuthorizerController(sc);
        
        List<String> step1 = saCtrl.step1;
        List<String> step2 = saCtrl.step2;
        List<String> step3 = saCtrl.step3;
        List<String> step4 = saCtrl.step4;
        List<String> step5 = saCtrl.step5;
        List<String> step6 = saCtrl.step6;
        saCtrl.doSave();
        
        Test.stopTest();
        
        System.assertEquals(saCtrl.QHeader.JP_GeneralManager__c, saCtrl.QHeader.JP_step4Approver__c);
    }
    
    
    /**
     *Step4ApproverがJP_GeneralManager__cの場合、StepCnt＝4の場合、JP_Step4type__c≠'User'、JP_Step4Approver__c = 'ATKK'の場合
     */
    static testMethod void testMethod1404() {
        List<User> usrs = new List<User>();
        User usr1 = JP_TestUtil.Create_ApproverUser('A121_課長');
        
        User usr2 = JP_TestUtil.Create_ApproverUser('A131_部長');
        
        User usr3 = JP_TestUtil.Create_ApproverUser('A141_本部長');
        
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
            qh.JP_Step1Approver__c = usr1.Id;
            qh.JP_Step2Approver__c = usr2.Id;
            qh.JP_Step3Approver__c = usr2.Id;
            qh.JP_Step4Approver__c = usr3.Id;
            qh.JP_SectionChief__c = usr1.Id;
            qh.JP_Manager__c = usr2.Id;
            qh.JP_GeneralManager__c = usr3.Id;
        }
        
        insert qhList;
        
        JP_QuotationHeader__c rec = qhList[0];
        
        PageReference pref = Page.JP_SetAuthorizer;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        
        JP_ApprovalProcessMaster__c apm = Create_JP_ApprovalProcessMaster(1);
        apm.JP_Step1Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step2Approver__c = JP_Const.MANAGER;
        apm.JP_Step3Approver__c = JP_Const.MANAGER;
        apm.JP_Step4Approver__c = JP_Const.GENERAL_MANAGER;
        apm.JP_StepCnt__c = 4;
        apm.JP_Step4type__c = '';
        apm.JP_Step4Approver__c = 'ATKK';
        update apm;
        
        Test.startTest();
        
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
        JP_SetAuthorizerController saCtrl = new JP_SetAuthorizerController(sc);
        
        List<String> step1 = saCtrl.step1;
        List<String> step2 = saCtrl.step2;
        List<String> step3 = saCtrl.step3;
        List<String> step4 = saCtrl.step4;
        List<String> step5 = saCtrl.step5;
        List<String> step6 = saCtrl.step6;
        saCtrl.doSave();
        
        Test.stopTest();
        
        System.assertEquals(system.label.JP_ATKK, saCtrl.QHeader.JP_ApprovalLV__c);
    }
    
    
    /**
     *Step4ApproverがJP_GeneralManager__cの場合、StepCnt＝4の場合、JP_Step4type__c≠'User'、JP_Step4Approver__c = 'Partner'の場合
     */
    static testMethod void testMethod1405() {
        List<User> usrs = new List<User>();
        User usr1 = JP_TestUtil.Create_ApproverUser('A121_課長');
        
        User usr2 = JP_TestUtil.Create_ApproverUser('A131_部長');
        
        User usr3 = JP_TestUtil.Create_ApproverUser('A141_本部長');
        
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
            qh.JP_Step1Approver__c = usr1.Id;
            qh.JP_Step2Approver__c = usr2.Id;
            qh.JP_Step3Approver__c = usr2.Id;
            qh.JP_Step4Approver__c = usr3.Id;
            qh.JP_SectionChief__c = usr1.Id;
            qh.JP_Manager__c = usr2.Id;
            qh.JP_GeneralManager__c = usr3.Id;
        }
        
        insert qhList;
        
        JP_QuotationHeader__c rec = qhList[0];
        
        PageReference pref = Page.JP_SetAuthorizer;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        
        JP_ApprovalProcessMaster__c apm = Create_JP_ApprovalProcessMaster(1);
        apm.JP_Step1Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step2Approver__c = JP_Const.MANAGER;
        apm.JP_Step3Approver__c = JP_Const.MANAGER;
        apm.JP_Step4Approver__c = JP_Const.GENERAL_MANAGER;
        apm.JP_StepCnt__c = 4;
        apm.JP_Step4type__c = '';
        apm.JP_Step4Approver__c = 'Partner';
        update apm;
        
        Test.startTest();
        
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
        JP_SetAuthorizerController saCtrl = new JP_SetAuthorizerController(sc);
        
        List<String> step1 = saCtrl.step1;
        List<String> step2 = saCtrl.step2;
        List<String> step3 = saCtrl.step3;
        List<String> step4 = saCtrl.step4;
        List<String> step5 = saCtrl.step5;
        List<String> step6 = saCtrl.step6;
        saCtrl.doSave();
        
        Test.stopTest();
        
        System.assertEquals(system.label.JP_Partner, saCtrl.QHeader.JP_ApprovalLV__c);
    }
    
    
    /**
     *Step4ApproverがJP_GeneralManager__cの場合、StepCnt＝4の場合、JP_Step4type__c≠'User'、JP_Step4Approver__c = 'Warranty'の場合
     */
    static testMethod void testMethod1406() {
        List<User> usrs = new List<User>();
        User usr1 = JP_TestUtil.Create_ApproverUser('A121_課長');
        
        User usr2 = JP_TestUtil.Create_ApproverUser('A131_部長');
        
        User usr3 = JP_TestUtil.Create_ApproverUser('A141_本部長');
        
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
            qh.JP_Step1Approver__c = usr1.Id;
            qh.JP_Step2Approver__c = usr2.Id;
            qh.JP_Step3Approver__c = usr2.Id;
            qh.JP_Step4Approver__c = usr3.Id;
            qh.JP_SectionChief__c = usr1.Id;
            qh.JP_Manager__c = usr2.Id;
            qh.JP_GeneralManager__c = usr3.Id;
        }
        
        insert qhList;
        
        JP_QuotationHeader__c rec = qhList[0];
        
        PageReference pref = Page.JP_SetAuthorizer;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        
        JP_ApprovalProcessMaster__c apm = Create_JP_ApprovalProcessMaster(1);
        apm.JP_Step1Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step2Approver__c = JP_Const.MANAGER;
        apm.JP_Step3Approver__c = JP_Const.MANAGER;
        apm.JP_Step4Approver__c = JP_Const.GENERAL_MANAGER;
        apm.JP_StepCnt__c = 4;
        apm.JP_Step4type__c = '';
        apm.JP_Step4Approver__c = 'Warranty';
        update apm;
        
        Test.startTest();
        
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
        JP_SetAuthorizerController saCtrl = new JP_SetAuthorizerController(sc);
        
        List<String> step1 = saCtrl.step1;
        List<String> step2 = saCtrl.step2;
        List<String> step3 = saCtrl.step3;
        List<String> step4 = saCtrl.step4;
        List<String> step5 = saCtrl.step5;
        List<String> step6 = saCtrl.step6;
        saCtrl.doSave();
        
        Test.stopTest();
        
        System.assertEquals(system.label.JP_Warranty, saCtrl.QHeader.JP_ApprovalLV__c);
    }
    
    
    /**
     *Step4ApproverがJP_GeneralManager__cの場合、StepCnt＝4の場合、JP_Step4type__c≠'User'、JP_Step4Approver__c = 'ATKK_Partner'の場合
     */
    static testMethod void testMethod1407() {
        List<User> usrs = new List<User>();
        User usr1 = JP_TestUtil.Create_ApproverUser('A121_課長');
        
        User usr2 = JP_TestUtil.Create_ApproverUser('A131_部長');
        
        User usr3 = JP_TestUtil.Create_ApproverUser('A141_本部長');
        
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
            qh.JP_Step1Approver__c = usr1.Id;
            qh.JP_Step2Approver__c = usr2.Id;
            qh.JP_Step3Approver__c = usr2.Id;
            qh.JP_Step4Approver__c = usr3.Id;
            qh.JP_SectionChief__c = usr1.Id;
            qh.JP_Manager__c = usr2.Id;
            qh.JP_GeneralManager__c = usr3.Id;
        }
        
        insert qhList;
        
        JP_QuotationHeader__c rec = qhList[0];
        
        PageReference pref = Page.JP_SetAuthorizer;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        
        JP_ApprovalProcessMaster__c apm = Create_JP_ApprovalProcessMaster(1);
        apm.JP_Step1Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step2Approver__c = JP_Const.MANAGER;
        apm.JP_Step3Approver__c = JP_Const.MANAGER;
        apm.JP_Step4Approver__c = JP_Const.GENERAL_MANAGER;
        apm.JP_StepCnt__c = 4;
        apm.JP_Step4type__c = '';
        apm.JP_Step4Approver__c = 'ATKK_Partner';
        update apm;
        
        Test.startTest();
        
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
        JP_SetAuthorizerController saCtrl = new JP_SetAuthorizerController(sc);
        
        List<String> step1 = saCtrl.step1;
        List<String> step2 = saCtrl.step2;
        List<String> step3 = saCtrl.step3;
        List<String> step4 = saCtrl.step4;
        List<String> step5 = saCtrl.step5;
        List<String> step6 = saCtrl.step6;
        saCtrl.doSave();
        
        Test.stopTest();
        
        System.assertEquals(system.label.JP_ATKK_Partner.replace('<br/>',','), saCtrl.QHeader.JP_ApprovalLV__c);
    }
    
    
    /**
     *Step4ApproverがJP_GeneralManager__cの場合、StepCnt＝4の場合、JP_Step4type__c≠'User'、JP_Step4Approver__c = 'ATKK_Warranty'の場合
     */
    static testMethod void testMethod1408() {
        List<User> usrs = new List<User>();
        User usr1 = JP_TestUtil.Create_ApproverUser('A121_課長');
        
        User usr2 = JP_TestUtil.Create_ApproverUser('A131_部長');
        
        User usr3 = JP_TestUtil.Create_ApproverUser('A141_本部長');
        
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
            qh.JP_Step1Approver__c = usr1.Id;
            qh.JP_Step2Approver__c = usr2.Id;
            qh.JP_Step3Approver__c = usr2.Id;
            qh.JP_Step4Approver__c = usr3.Id;
            qh.JP_SectionChief__c = usr1.Id;
            qh.JP_Manager__c = usr2.Id;
            qh.JP_GeneralManager__c = usr3.Id;
        }
        
        insert qhList;
        
        JP_QuotationHeader__c rec = qhList[0];
        
        PageReference pref = Page.JP_SetAuthorizer;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        
        JP_ApprovalProcessMaster__c apm = Create_JP_ApprovalProcessMaster(1);
        apm.JP_Step1Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step2Approver__c = JP_Const.MANAGER;
        apm.JP_Step3Approver__c = JP_Const.MANAGER;
        apm.JP_Step4Approver__c = JP_Const.GENERAL_MANAGER;
        apm.JP_StepCnt__c = 4;
        apm.JP_Step4type__c = '';
        apm.JP_Step4Approver__c = 'ATKK_Warranty';
        update apm;
        
        Test.startTest();
        
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
        JP_SetAuthorizerController saCtrl = new JP_SetAuthorizerController(sc);
        
        List<String> step1 = saCtrl.step1;
        List<String> step2 = saCtrl.step2;
        List<String> step3 = saCtrl.step3;
        List<String> step4 = saCtrl.step4;
        List<String> step5 = saCtrl.step5;
        List<String> step6 = saCtrl.step6;
        saCtrl.doSave();
        
        Test.stopTest();
        
        System.assertEquals(system.label.JP_ATKK_Warranty.replace('<br/>',','), saCtrl.QHeader.JP_ApprovalLV__c);
    }
    
    
    /**
     *Step4ApproverがJP_GeneralManager__cの場合、StepCnt＝4の場合、JP_Step4type__c≠'User'、JP_Step4Approver__c = 'Partner_Warranty'の場合
     */
    static testMethod void testMethod1409() {
        List<User> usrs = new List<User>();
        User usr1 = JP_TestUtil.Create_ApproverUser('A121_課長');

        User usr2 = JP_TestUtil.Create_ApproverUser('A131_部長');
        
        User usr3 = JP_TestUtil.Create_ApproverUser('A141_本部長');

        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
            qh.JP_Step1Approver__c = usr1.Id;
            qh.JP_Step2Approver__c = usr2.Id;
            qh.JP_Step3Approver__c = usr2.Id;
            qh.JP_Step4Approver__c = usr3.Id;
            qh.JP_SectionChief__c = usr1.Id;
            qh.JP_Manager__c = usr2.Id;
            qh.JP_GeneralManager__c = usr3.Id;
        }
        
        insert qhList;
        
        JP_QuotationHeader__c rec = qhList[0];
        
        PageReference pref = Page.JP_SetAuthorizer;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        
        JP_ApprovalProcessMaster__c apm = Create_JP_ApprovalProcessMaster(1);
        apm.JP_Step1Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step2Approver__c = JP_Const.MANAGER;
        apm.JP_Step3Approver__c = JP_Const.MANAGER;
        apm.JP_Step4Approver__c = JP_Const.GENERAL_MANAGER;
        apm.JP_StepCnt__c = 4;
        apm.JP_Step4type__c = '';
        apm.JP_Step4Approver__c = 'Partner_Warranty';
        update apm;
        
        Test.startTest();
        
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
        JP_SetAuthorizerController saCtrl = new JP_SetAuthorizerController(sc);
        
        List<String> step1 = saCtrl.step1;
        List<String> step2 = saCtrl.step2;
        List<String> step3 = saCtrl.step3;
        List<String> step4 = saCtrl.step4;
        List<String> step5 = saCtrl.step5;
        List<String> step6 = saCtrl.step6;
        saCtrl.doSave();
        
        Test.stopTest();
        
        System.assertEquals(system.label.JP_Partner_Warranty.replace('<br/>',','), saCtrl.QHeader.JP_ApprovalLV__c);
    }
    
    
    /**
     *Step4ApproverがJP_GeneralManager__cの場合、StepCnt＝4の場合、JP_Step4type__c≠'User'、JP_Step4Approver__c = 'ATKK_Partner_Warranty'の場合
     */
    static testMethod void testMethod1410() {
        List<User> usrs = new List<User>();
        User usr1 = JP_TestUtil.Create_ApproverUser('A121_課長');
        
        User usr2 = JP_TestUtil.Create_ApproverUser('A131_部長');

        User usr3 = JP_TestUtil.Create_ApproverUser('A141_本部長');
        
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
            qh.JP_Step1Approver__c = usr1.Id;
            qh.JP_Step2Approver__c = usr2.Id;
            qh.JP_Step3Approver__c = usr2.Id;
            qh.JP_Step4Approver__c = usr3.Id;
            qh.JP_SectionChief__c = usr1.Id;
            qh.JP_Manager__c = usr2.Id;
            qh.JP_GeneralManager__c = usr3.Id;
        }
        
        insert qhList;
        
        JP_QuotationHeader__c rec = qhList[0];
        
        PageReference pref = Page.JP_SetAuthorizer;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        
        JP_ApprovalProcessMaster__c apm = Create_JP_ApprovalProcessMaster(1);
        apm.JP_Step1Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step2Approver__c = JP_Const.MANAGER;
        apm.JP_Step3Approver__c = JP_Const.MANAGER;
        apm.JP_Step4Approver__c = JP_Const.GENERAL_MANAGER;
        apm.JP_StepCnt__c = 4;
        apm.JP_Step4type__c = '';
        apm.JP_Step4Approver__c = 'ATKK_Partner_Warranty';
        update apm;
        
        Test.startTest();
        
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
        JP_SetAuthorizerController saCtrl = new JP_SetAuthorizerController(sc);
        
        List<String> step1 = saCtrl.step1;
        List<String> step2 = saCtrl.step2;
        List<String> step3 = saCtrl.step3;
        List<String> step4 = saCtrl.step4;
        List<String> step5 = saCtrl.step5;
        List<String> step6 = saCtrl.step6;
        saCtrl.doSave();
        
        Test.stopTest();
        
        System.assertEquals(system.label.JP_ATKK_Partner_Warranty.replace('<br/>',','), saCtrl.QHeader.JP_ApprovalLV__c);
    }
    
    
    /**
     *Step5ApproverがJP_SectionChiefの場合
     */
    static testMethod void testMethod1501() {
        List<User> usrs = new List<User>();
        User usr1 = JP_TestUtil.Create_ApproverUser('A121_課長');
        
        User usr2 = JP_TestUtil.Create_ApproverUser('A131_部長');
        
        User usr3 = JP_TestUtil.Create_ApproverUser('A141_本部長');
        
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
            qh.JP_SectionChief__c = usr1.Id;
        }
        
        insert qhList;
        
        JP_QuotationHeader__c rec = qhList[0];
        
        PageReference pref = Page.JP_SetAuthorizer;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        
        JP_ApprovalProcessMaster__c apm = Create_JP_ApprovalProcessMaster(1);
        apm.JP_Step1Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step2Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step3Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step4Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step5Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_StepCnt__c = 5;
        update apm;
        
        Test.startTest();
        
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
        JP_SetAuthorizerController saCtrl = new JP_SetAuthorizerController(sc);
        
        List<String> step1 = saCtrl.step1;
        List<String> step2 = saCtrl.step2;
        List<String> step3 = saCtrl.step3;
        List<String> step4 = saCtrl.step4;
        List<String> step5 = saCtrl.step5;
        List<String> step6 = saCtrl.step6;
        saCtrl.doSave();
        
        Test.stopTest();
        
        System.assertEquals(saCtrl.QHeader.JP_SectionChief__c, saCtrl.QHeader.JP_step5Approver__c);
    }
    
    
    /**
     *Step5ApproverがJP_Managerの場合
     */
    static testMethod void testMethod1502() {
        List<User> usrs = new List<User>();
        User usr1 = JP_TestUtil.Create_ApproverUser('A121_課長');
        
        User usr2 = JP_TestUtil.Create_ApproverUser('A131_部長');
        
        User usr3 = JP_TestUtil.Create_ApproverUser('A141_本部長');
        
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
            qh.JP_SectionChief__c = usr1.Id;
            qh.JP_Manager__c = usr2.Id;
        }
        
        insert qhList;
        
        JP_QuotationHeader__c rec = qhList[0];
        
        PageReference pref = Page.JP_SetAuthorizer;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        
        JP_ApprovalProcessMaster__c apm = Create_JP_ApprovalProcessMaster(1);
        apm.JP_Step1Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step2Approver__c = JP_Const.MANAGER;
        apm.JP_Step3Approver__c = JP_Const.MANAGER;
        apm.JP_Step4Approver__c = JP_Const.MANAGER;
        apm.JP_Step5Approver__c = JP_Const.MANAGER;
        apm.JP_StepCnt__c = 5;
        update apm;
        
        Test.startTest();
        
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
        JP_SetAuthorizerController saCtrl = new JP_SetAuthorizerController(sc);
        
        List<String> step1 = saCtrl.step1;
        List<String> step2 = saCtrl.step2;
        List<String> step3 = saCtrl.step3;
        List<String> step4 = saCtrl.step4;
        List<String> step5 = saCtrl.step5;
        List<String> step6 = saCtrl.step6;
        saCtrl.doSave();
        
        Test.stopTest();
        
        System.assertEquals(saCtrl.QHeader.JP_Manager__c, saCtrl.QHeader.JP_step5Approver__c);
    }
    
    
    /**
     *Step5ApproverがJP_GeneralManager__cの場合
     */
    static testMethod void testMethod1503() {
        List<User> usrs = new List<User>();
        User usr1 = JP_TestUtil.Create_ApproverUser('A121_課長');
        
        User usr2 = JP_TestUtil.Create_ApproverUser('A131_部長');
        
        User usr3 = JP_TestUtil.Create_ApproverUser('A141_本部長');
        
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
            qh.JP_SectionChief__c = usr1.Id;
            qh.JP_Manager__c = usr2.Id;
            qh.JP_GeneralManager__c = usr3.Id;
        }
        
        insert qhList;
        
        JP_QuotationHeader__c rec = qhList[0];
        
        PageReference pref = Page.JP_SetAuthorizer;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        
        JP_ApprovalProcessMaster__c apm = Create_JP_ApprovalProcessMaster(1);
        apm.JP_Step1Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step2Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step3Approver__c = JP_Const.MANAGER;
        apm.JP_Step4Approver__c = JP_Const.MANAGER;
        apm.JP_Step5Approver__c = JP_Const.GENERAL_MANAGER;
        apm.JP_StepCnt__c = 5;
        update apm;
        
        Test.startTest();
        
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
        JP_SetAuthorizerController saCtrl = new JP_SetAuthorizerController(sc);
        
        List<String> step1 = saCtrl.step1;
        List<String> step2 = saCtrl.step2;
        List<String> step3 = saCtrl.step3;
        List<String> step4 = saCtrl.step4;
        List<String> step5 = saCtrl.step5;
        List<String> step6 = saCtrl.step6;
        saCtrl.doSave();
        
        Test.stopTest();
        
        System.assertEquals(saCtrl.QHeader.JP_GeneralManager__c, saCtrl.QHeader.JP_step5Approver__c);
    }
    
    
    /**
     *Step5ApproverがJP_GeneralManager__cの場合、StepCnt＝5の場合、JP_Step5type__c≠'User'、JP_Step5Approver__c = 'ATKK'の場合
     */
    static testMethod void testMethod1504() {
        List<User> usrs = new List<User>();
        User usr1 = JP_TestUtil.Create_ApproverUser('A121_課長');

        User usr2 = JP_TestUtil.Create_ApproverUser('A131_部長');

        User usr3 = JP_TestUtil.Create_ApproverUser('A141_本部長');
        
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
            qh.JP_Step1Approver__c = usr1.Id;
            qh.JP_Step2Approver__c = usr1.Id;
            qh.JP_Step3Approver__c = usr2.Id;
            qh.JP_Step4Approver__c = usr2.Id;
            qh.JP_Step5Approver__c = usr3.Id;
            qh.JP_SectionChief__c = usr1.Id;
            qh.JP_Manager__c = usr2.Id;
            qh.JP_GeneralManager__c = usr3.Id;
        }
        
        insert qhList;
        
        JP_QuotationHeader__c rec = qhList[0];
        
        PageReference pref = Page.JP_SetAuthorizer;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        
        JP_ApprovalProcessMaster__c apm = Create_JP_ApprovalProcessMaster(1);
        apm.JP_Step1Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step2Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step3Approver__c = JP_Const.MANAGER;
        apm.JP_Step4Approver__c = JP_Const.MANAGER;
        apm.JP_Step5Approver__c = JP_Const.GENERAL_MANAGER;
        apm.JP_StepCnt__c = 5;
        apm.JP_Step5type__c = '';
        apm.JP_Step5Approver__c = 'ATKK';
        update apm;
        
        Test.startTest();
        
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
        JP_SetAuthorizerController saCtrl = new JP_SetAuthorizerController(sc);
        
        List<String> step1 = saCtrl.step1;
        List<String> step2 = saCtrl.step2;
        List<String> step3 = saCtrl.step3;
        List<String> step4 = saCtrl.step4;
        List<String> step5 = saCtrl.step5;
        List<String> step6 = saCtrl.step6;
        saCtrl.doSave();
        
        Test.stopTest();
        
        System.assertEquals(system.label.JP_ATKK, saCtrl.QHeader.JP_ApprovalLV__c);
    }
    
    
    /**
     *Step5ApproverがJP_GeneralManager__cの場合、StepCnt＝5の場合、JP_Step5type__c≠'User'、JP_Step5Approver__c = 'Partner'の場合
     */
    static testMethod void testMethod1505() {
        List<User> usrs = new List<User>();
        User usr1 = JP_TestUtil.Create_ApproverUser('A121_課長');
        
        User usr2 = JP_TestUtil.Create_ApproverUser('A131_部長');
        
        User usr3 = JP_TestUtil.Create_ApproverUser('A141_本部長');
        
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
            qh.JP_Step1Approver__c = usr1.Id;
            qh.JP_Step2Approver__c = usr1.Id;
            qh.JP_Step3Approver__c = usr2.Id;
            qh.JP_Step4Approver__c = usr2.Id;
            qh.JP_Step5Approver__c = usr3.Id;
            qh.JP_SectionChief__c = usr1.Id;
            qh.JP_Manager__c = usr2.Id;
            qh.JP_GeneralManager__c = usr3.Id;
        }
        
        insert qhList;
        
        JP_QuotationHeader__c rec = qhList[0];
        
        PageReference pref = Page.JP_SetAuthorizer;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        
        JP_ApprovalProcessMaster__c apm = Create_JP_ApprovalProcessMaster(1);
        apm.JP_Step1Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step2Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step3Approver__c = JP_Const.MANAGER;
        apm.JP_Step4Approver__c = JP_Const.MANAGER;
        apm.JP_Step5Approver__c = JP_Const.GENERAL_MANAGER;
        apm.JP_StepCnt__c = 5;
        apm.JP_Step5type__c = '';
        apm.JP_Step5Approver__c = 'Partner';
        update apm;
        
        Test.startTest();
        
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
        JP_SetAuthorizerController saCtrl = new JP_SetAuthorizerController(sc);
        
        List<String> step1 = saCtrl.step1;
        List<String> step2 = saCtrl.step2;
        List<String> step3 = saCtrl.step3;
        List<String> step4 = saCtrl.step4;
        List<String> step5 = saCtrl.step5;
        List<String> step6 = saCtrl.step6;
        saCtrl.doSave();
        
        Test.stopTest();
        
        System.assertEquals(system.label.JP_Partner, saCtrl.QHeader.JP_ApprovalLV__c);
    }
    
    
    /**
     *Step5ApproverがJP_GeneralManager__cの場合、StepCnt＝5の場合、JP_Step5type__c≠'User'、JP_Step5Approver__c = 'Warranty'の場合
     */
    static testMethod void testMethod1506() {
        List<User> usrs = new List<User>();
        User usr1 = JP_TestUtil.Create_ApproverUser('A121_課長');

        User usr2 = JP_TestUtil.Create_ApproverUser('A131_部長');

        User usr3 = JP_TestUtil.Create_ApproverUser('A141_本部長');
        
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
            qh.JP_Step1Approver__c = usr1.Id;
            qh.JP_Step2Approver__c = usr1.Id;
            qh.JP_Step3Approver__c = usr2.Id;
            qh.JP_Step4Approver__c = usr2.Id;
            qh.JP_Step5Approver__c = usr3.Id;
            qh.JP_SectionChief__c = usr1.Id;
            qh.JP_Manager__c = usr2.Id;
            qh.JP_GeneralManager__c = usr3.Id;
        }
        
        insert qhList;
        
        JP_QuotationHeader__c rec = qhList[0];
        
        PageReference pref = Page.JP_SetAuthorizer;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        
        JP_ApprovalProcessMaster__c apm = Create_JP_ApprovalProcessMaster(1);
        apm.JP_Step1Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step2Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step3Approver__c = JP_Const.MANAGER;
        apm.JP_Step4Approver__c = JP_Const.MANAGER;
        apm.JP_Step5Approver__c = JP_Const.GENERAL_MANAGER;
        apm.JP_StepCnt__c = 5;
        apm.JP_Step5type__c = '';
        apm.JP_Step5Approver__c = 'Warranty';
        update apm;
        
        Test.startTest();
        
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
        JP_SetAuthorizerController saCtrl = new JP_SetAuthorizerController(sc);
        
        List<String> step1 = saCtrl.step1;
        List<String> step2 = saCtrl.step2;
        List<String> step3 = saCtrl.step3;
        List<String> step4 = saCtrl.step4;
        List<String> step5 = saCtrl.step5;
        List<String> step6 = saCtrl.step6;
        saCtrl.doSave();
        
        Test.stopTest();
        
        System.assertEquals(system.label.JP_Warranty, saCtrl.QHeader.JP_ApprovalLV__c);
    }
    
    
    
    /**
     *Step5ApproverがJP_GeneralManager__cの場合、StepCnt＝5の場合、JP_Step5type__c≠'User'、JP_Step5Approver__c = 'ATKK_Partner'の場合
     */
    static testMethod void testMethod1507() {
        List<User> usrs = new List<User>();
        User usr1 = JP_TestUtil.Create_ApproverUser('A121_課長');
        
        User usr2 = JP_TestUtil.Create_ApproverUser('A131_部長');

        User usr3 = JP_TestUtil.Create_ApproverUser('A141_本部長');
        
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
            qh.JP_Step1Approver__c = usr1.Id;
            qh.JP_Step2Approver__c = usr1.Id;
            qh.JP_Step3Approver__c = usr2.Id;
            qh.JP_Step4Approver__c = usr2.Id;
            qh.JP_Step5Approver__c = usr3.Id;
            qh.JP_SectionChief__c = usr1.Id;
            qh.JP_Manager__c = usr2.Id;
            qh.JP_GeneralManager__c = usr3.Id;
        }
        
        insert qhList;
        
        JP_QuotationHeader__c rec = qhList[0];
        
        PageReference pref = Page.JP_SetAuthorizer;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        
        JP_ApprovalProcessMaster__c apm = Create_JP_ApprovalProcessMaster(1);
        apm.JP_Step1Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step2Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step3Approver__c = JP_Const.MANAGER;
        apm.JP_Step4Approver__c = JP_Const.MANAGER;
        apm.JP_Step5Approver__c = JP_Const.GENERAL_MANAGER;
        apm.JP_StepCnt__c = 5;
        apm.JP_Step5type__c = '';
        apm.JP_Step5Approver__c = 'ATKK_Partner';
        update apm;
        
        Test.startTest();
        
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
        JP_SetAuthorizerController saCtrl = new JP_SetAuthorizerController(sc);
        
        List<String> step1 = saCtrl.step1;
        List<String> step2 = saCtrl.step2;
        List<String> step3 = saCtrl.step3;
        List<String> step4 = saCtrl.step4;
        List<String> step5 = saCtrl.step5;
        List<String> step6 = saCtrl.step6;
        saCtrl.doSave();
        
        Test.stopTest();
        
        System.assertEquals(system.label.JP_ATKK_Partner.replace('<br/>',','), saCtrl.QHeader.JP_ApprovalLV__c);
    }
    
    
    /**
     *Step5ApproverがJP_GeneralManager__cの場合、StepCnt＝5の場合、JP_Step5type__c≠'User'、JP_Step5Approver__c = 'ATKK_Warranty'の場合
     */
    static testMethod void testMethod15048() {
        List<User> usrs = new List<User>();
        User usr1 = JP_TestUtil.Create_ApproverUser('A121_課長');
        User usr2 = JP_TestUtil.Create_ApproverUser('A131_部長');
        
        User usr3 = JP_TestUtil.Create_ApproverUser('A141_本部長');
        
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
            qh.JP_Step1Approver__c = usr1.Id;
            qh.JP_Step2Approver__c = usr1.Id;
            qh.JP_Step3Approver__c = usr2.Id;
            qh.JP_Step4Approver__c = usr2.Id;
            qh.JP_Step5Approver__c = usr3.Id;
            qh.JP_SectionChief__c = usr1.Id;
            qh.JP_Manager__c = usr2.Id;
            qh.JP_GeneralManager__c = usr3.Id;
        }
        
        insert qhList;
        
        JP_QuotationHeader__c rec = qhList[0];
        
        PageReference pref = Page.JP_SetAuthorizer;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        
        JP_ApprovalProcessMaster__c apm = Create_JP_ApprovalProcessMaster(1);
        apm.JP_Step1Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step2Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step3Approver__c = JP_Const.MANAGER;
        apm.JP_Step4Approver__c = JP_Const.MANAGER;
        apm.JP_Step5Approver__c = JP_Const.GENERAL_MANAGER;
        apm.JP_StepCnt__c = 5;
        apm.JP_Step5type__c = '';
        apm.JP_Step5Approver__c = 'ATKK_Warranty';
        update apm;
        
        Test.startTest();
        
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
        JP_SetAuthorizerController saCtrl = new JP_SetAuthorizerController(sc);
        
        List<String> step1 = saCtrl.step1;
        List<String> step2 = saCtrl.step2;
        List<String> step3 = saCtrl.step3;
        List<String> step4 = saCtrl.step4;
        List<String> step5 = saCtrl.step5;
        List<String> step6 = saCtrl.step6;
        saCtrl.doSave();
        
        Test.stopTest();
        
        System.assertEquals(system.label.JP_ATKK_Warranty.replace('<br/>',','), saCtrl.QHeader.JP_ApprovalLV__c);
    }
    
    
    /**
     *Step5ApproverがJP_GeneralManager__cの場合、StepCnt＝5の場合、JP_Step5type__c≠'User'、JP_Step5Approver__c = 'Partner_Warranty'の場合
     */
    static testMethod void testMethod1509() {
        List<User> usrs = new List<User>();
        User usr1 = JP_TestUtil.Create_ApproverUser('A121_課長');
        
        User usr2 = JP_TestUtil.Create_ApproverUser('A131_部長');

        User usr3 = JP_TestUtil.Create_ApproverUser('A141_本部長');

        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
            qh.JP_Step1Approver__c = usr1.Id;
            qh.JP_Step2Approver__c = usr1.Id;
            qh.JP_Step3Approver__c = usr2.Id;
            qh.JP_Step4Approver__c = usr2.Id;
            qh.JP_Step5Approver__c = usr3.Id;
            qh.JP_SectionChief__c = usr1.Id;
            qh.JP_Manager__c = usr2.Id;
            qh.JP_GeneralManager__c = usr3.Id;
        }
        
        insert qhList;
        
        JP_QuotationHeader__c rec = qhList[0];
        
        PageReference pref = Page.JP_SetAuthorizer;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        
        JP_ApprovalProcessMaster__c apm = Create_JP_ApprovalProcessMaster(1);
        apm.JP_Step1Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step2Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step3Approver__c = JP_Const.MANAGER;
        apm.JP_Step4Approver__c = JP_Const.MANAGER;
        apm.JP_Step5Approver__c = JP_Const.GENERAL_MANAGER;
        apm.JP_StepCnt__c = 5;
        apm.JP_Step5type__c = '';
        apm.JP_Step5Approver__c = 'Partner_Warranty';
        update apm;
        
        Test.startTest();
        
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
        JP_SetAuthorizerController saCtrl = new JP_SetAuthorizerController(sc);
        
        List<String> step1 = saCtrl.step1;
        List<String> step2 = saCtrl.step2;
        List<String> step3 = saCtrl.step3;
        List<String> step4 = saCtrl.step4;
        List<String> step5 = saCtrl.step5;
        List<String> step6 = saCtrl.step6;
        saCtrl.doSave();
        
        Test.stopTest();
        
        System.assertEquals(system.label.JP_Partner_Warranty.replace('<br/>',','), saCtrl.QHeader.JP_ApprovalLV__c);
    }
    
    
    /**
     *Step5ApproverがJP_GeneralManager__cの場合、StepCnt＝5の場合、JP_Step5type__c≠'User'、JP_Step5Approver__c = 'ATKK_Partner_Warranty'の場合
     */
    static testMethod void testMethod1510() {
        List<User> usrs = new List<User>();
        User usr1 = JP_TestUtil.Create_ApproverUser('A121_課長');
        
        User usr2 = JP_TestUtil.Create_ApproverUser('A131_部長');
        
        User usr3 = JP_TestUtil.Create_ApproverUser('A141_本部長');
        
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
            qh.JP_Step1Approver__c = usr1.Id;
            qh.JP_Step2Approver__c = usr1.Id;
            qh.JP_Step3Approver__c = usr2.Id;
            qh.JP_Step4Approver__c = usr2.Id;
            qh.JP_Step5Approver__c = usr3.Id;
            qh.JP_SectionChief__c = usr1.Id;
            qh.JP_Manager__c = usr2.Id;
            qh.JP_GeneralManager__c = usr3.Id;
        }
        
        insert qhList;
        
        JP_QuotationHeader__c rec = qhList[0];
        
        PageReference pref = Page.JP_SetAuthorizer;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        
        JP_ApprovalProcessMaster__c apm = Create_JP_ApprovalProcessMaster(1);
        apm.JP_Step1Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step2Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step3Approver__c = JP_Const.MANAGER;
        apm.JP_Step4Approver__c = JP_Const.MANAGER;
        apm.JP_Step5Approver__c = JP_Const.GENERAL_MANAGER;
        apm.JP_StepCnt__c = 5;
        apm.JP_Step5type__c = '';
        apm.JP_Step5Approver__c = 'ATKK_Partner_Warranty';
        update apm;
        
        Test.startTest();
        
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
        JP_SetAuthorizerController saCtrl = new JP_SetAuthorizerController(sc);
        
        List<String> step1 = saCtrl.step1;
        List<String> step2 = saCtrl.step2;
        List<String> step3 = saCtrl.step3;
        List<String> step4 = saCtrl.step4;
        List<String> step5 = saCtrl.step5;
        List<String> step6 = saCtrl.step6;
        saCtrl.doSave();
        
        Test.stopTest();
        
        System.assertEquals(system.label.JP_ATKK_Partner_Warranty.replace('<br/>',','), saCtrl.QHeader.JP_ApprovalLV__c);
    }
    
    
    /**
     *Step6ApproverがJP_SectionChiefの場合
     */
    static testMethod void testMethod1601() {
        List<User> usrs = new List<User>();
        User usr1 = JP_TestUtil.Create_ApproverUser('A121_課長');
        usr1.JP_Class__c = '';
        usrs.add(usr1);

        
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
            qh.JP_SectionChief__c = usr1.Id;
        }
        
        insert qhList;
        
        JP_QuotationHeader__c rec = qhList[0];
        
        PageReference pref = Page.JP_SetAuthorizer;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        
        JP_ApprovalProcessMaster__c apm = Create_JP_ApprovalProcessMaster(1);
        apm.JP_Step1Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step2Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step3Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step4Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step5Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step6Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_StepCnt__c = 6;
        update apm;
        
        Test.startTest();
        
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
        JP_SetAuthorizerController saCtrl = new JP_SetAuthorizerController(sc);
        
        List<String> step1 = saCtrl.step1;
        List<String> step2 = saCtrl.step2;
        List<String> step3 = saCtrl.step3;
        List<String> step4 = saCtrl.step4;
        List<String> step5 = saCtrl.step5;
        List<String> step6 = saCtrl.step6;
        saCtrl.doSave();
        
        Test.stopTest();
        
        System.assertEquals(saCtrl.QHeader.JP_SectionChief__c, saCtrl.QHeader.JP_step6Approver__c);
    }
    
    
    /**
     *Step6ApproverがJP_Managerの場合
     */
    static testMethod void testMethod1602() {
        List<User> usrs = new List<User>();
        User usr1 = JP_TestUtil.Create_ApproverUser('A121_課長');
        
        User usr2 = JP_TestUtil.Create_ApproverUser('A131_部長');
        
        User usr3 = JP_TestUtil.Create_ApproverUser('A141_本部長');
        
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
            qh.JP_SectionChief__c = usr1.Id;
            qh.JP_Manager__c = usr2.Id;
        }
        
        insert qhList;
        
        JP_QuotationHeader__c rec = qhList[0];
        
        PageReference pref = Page.JP_SetAuthorizer;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        
        JP_ApprovalProcessMaster__c apm = Create_JP_ApprovalProcessMaster(1);
        apm.JP_Step1Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step2Approver__c = JP_Const.MANAGER;
        apm.JP_Step3Approver__c = JP_Const.MANAGER;
        apm.JP_Step4Approver__c = JP_Const.MANAGER;
        apm.JP_Step5Approver__c = JP_Const.MANAGER;
        apm.JP_Step6Approver__c = JP_Const.MANAGER;
        apm.JP_StepCnt__c = 6;
        update apm;
        
        Test.startTest();
        
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
        JP_SetAuthorizerController saCtrl = new JP_SetAuthorizerController(sc);
        
        List<String> step1 = saCtrl.step1;
        List<String> step2 = saCtrl.step2;
        List<String> step3 = saCtrl.step3;
        List<String> step4 = saCtrl.step4;
        List<String> step5 = saCtrl.step5;
        List<String> step6 = saCtrl.step6;
        saCtrl.doSave();
        
        Test.stopTest();
        
        System.assertEquals(saCtrl.QHeader.JP_Manager__c, saCtrl.QHeader.JP_step6Approver__c);
    }
    
    
    /**
     *Step6ApproverがJP_GeneralManager__cの場合
     */
    static testMethod void testMethod1603() {
        List<User> usrs = new List<User>();
        User usr1 = JP_TestUtil.Create_ApproverUser('A121_課長');
        
        User usr2 = JP_TestUtil.Create_ApproverUser('A131_部長');
        
        User usr3 = JP_TestUtil.Create_ApproverUser('A141_本部長');
        
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
            qh.JP_SectionChief__c = usr1.Id;
            qh.JP_Manager__c = usr2.Id;
            qh.JP_GeneralManager__c = usr3.Id;
        }
        
        insert qhList;
        
        JP_QuotationHeader__c rec = qhList[0];
        
        PageReference pref = Page.JP_SetAuthorizer;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        
        JP_ApprovalProcessMaster__c apm = Create_JP_ApprovalProcessMaster(1);
        apm.JP_Step1Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step2Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step3Approver__c = JP_Const.MANAGER;
        apm.JP_Step4Approver__c = JP_Const.MANAGER;
        apm.JP_Step5Approver__c = JP_Const.GENERAL_MANAGER;
        apm.JP_Step6Approver__c = JP_Const.GENERAL_MANAGER;
        apm.JP_StepCnt__c = 6;
        update apm;
        
        Test.startTest();
        
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
        JP_SetAuthorizerController saCtrl = new JP_SetAuthorizerController(sc);
        
        List<String> step1 = saCtrl.step1;
        List<String> step2 = saCtrl.step2;
        List<String> step3 = saCtrl.step3;
        List<String> step4 = saCtrl.step4;
        List<String> step5 = saCtrl.step5;
        List<String> step6 = saCtrl.step6;
        saCtrl.doSave();
        
        Test.stopTest();
        
        System.assertEquals(saCtrl.QHeader.JP_GeneralManager__c, saCtrl.QHeader.JP_step6Approver__c);
    }
    
    
    /**
     *Step6ApproverがJP_GeneralManager__cの場合、StepCnt＝6の場合、JP_Step6type__c≠'User'、JP_Step6Approver__c = 'ATKK'の場合
     */
    static testMethod void testMethod1604() {
        List<User> usrs = new List<User>();
        User usr1 = JP_TestUtil.Create_ApproverUser('A121_課長');
        
        User usr2 = JP_TestUtil.Create_ApproverUser('A131_部長');

        User usr3 = JP_TestUtil.Create_ApproverUser('A141_本部長');

        
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
            qh.JP_Step1Approver__c = usr1.Id;
            qh.JP_Step2Approver__c = usr1.Id;
            qh.JP_Step3Approver__c = usr2.Id;
            qh.JP_Step4Approver__c = usr2.Id;
            qh.JP_Step5Approver__c = usr3.Id;
            qh.JP_Step6Approver__c = usr3.Id;
            qh.JP_SectionChief__c = usr1.Id;
            qh.JP_Manager__c = usr2.Id;
            qh.JP_GeneralManager__c = usr3.Id;
        }
        
        insert qhList;
        
        JP_QuotationHeader__c rec = qhList[0];
        
        PageReference pref = Page.JP_SetAuthorizer;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        
        JP_ApprovalProcessMaster__c apm = Create_JP_ApprovalProcessMaster(1);
        apm.JP_Step1Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step2Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step3Approver__c = JP_Const.MANAGER;
        apm.JP_Step4Approver__c = JP_Const.MANAGER;
        apm.JP_Step5Approver__c = JP_Const.GENERAL_MANAGER;
        apm.JP_Step6Approver__c = JP_Const.GENERAL_MANAGER;
        apm.JP_StepCnt__c = 6;
        apm.JP_Step6type__c = '';
        apm.JP_Step6Approver__c = 'ATKK';
        update apm;
        
        Test.startTest();
        
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
        JP_SetAuthorizerController saCtrl = new JP_SetAuthorizerController(sc);
        
        List<String> step1 = saCtrl.step1;
        List<String> step2 = saCtrl.step2;
        List<String> step3 = saCtrl.step3;
        List<String> step4 = saCtrl.step4;
        List<String> step5 = saCtrl.step5;
        List<String> step6 = saCtrl.step6;
        saCtrl.doSave();
        
        Test.stopTest();
        
        System.assertEquals(system.label.JP_ATKK, saCtrl.QHeader.JP_ApprovalLV__c);
    }
    
    
    /**
     *Step6ApproverがJP_GeneralManager__cの場合、StepCnt＝6の場合、JP_Step6type__c≠'User'、JP_Step6Approver__c = 'Partner'の場合
     */
    static testMethod void testMethod1605() {
        List<User> usrs = new List<User>();
        User usr1 = JP_TestUtil.Create_ApproverUser('A121_課長');
        
        User usr2 = JP_TestUtil.Create_ApproverUser('A131_部長');
        
        User usr3 = JP_TestUtil.Create_ApproverUser('A141_本部長');
        
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
            qh.JP_Step1Approver__c = usr1.Id;
            qh.JP_Step2Approver__c = usr1.Id;
            qh.JP_Step3Approver__c = usr2.Id;
            qh.JP_Step4Approver__c = usr2.Id;
            qh.JP_Step5Approver__c = usr3.Id;
            qh.JP_Step6Approver__c = usr3.Id;
            qh.JP_SectionChief__c = usr1.Id;
            qh.JP_Manager__c = usr2.Id;
            qh.JP_GeneralManager__c = usr3.Id;
        }
        
        insert qhList;
        
        JP_QuotationHeader__c rec = qhList[0];
        
        PageReference pref = Page.JP_SetAuthorizer;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        
        JP_ApprovalProcessMaster__c apm = Create_JP_ApprovalProcessMaster(1);
        apm.JP_Step1Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step2Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step3Approver__c = JP_Const.MANAGER;
        apm.JP_Step4Approver__c = JP_Const.MANAGER;
        apm.JP_Step5Approver__c = JP_Const.GENERAL_MANAGER;
        apm.JP_Step6Approver__c = JP_Const.GENERAL_MANAGER;
        apm.JP_StepCnt__c = 6;
        apm.JP_Step6type__c = '';
        apm.JP_Step6Approver__c = 'Partner';
        update apm;
        
        Test.startTest();
        
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
        JP_SetAuthorizerController saCtrl = new JP_SetAuthorizerController(sc);
        
        List<String> step1 = saCtrl.step1;
        List<String> step2 = saCtrl.step2;
        List<String> step3 = saCtrl.step3;
        List<String> step4 = saCtrl.step4;
        List<String> step5 = saCtrl.step5;
        List<String> step6 = saCtrl.step6;
        saCtrl.doSave();
        
        Test.stopTest();
        
        System.assertEquals(system.label.JP_Partner, saCtrl.QHeader.JP_ApprovalLV__c);
    }
    
    
    /**
     *Step6ApproverがJP_GeneralManager__cの場合、StepCnt＝6の場合、JP_Step6type__c≠'User'、JP_Step6Approver__c = 'Warranty'の場合
     */
    static testMethod void testMethod1606() {
        List<User> usrs = new List<User>();
        User usr1 = JP_TestUtil.Create_ApproverUser('A121_課長');
        
        User usr2 = JP_TestUtil.Create_ApproverUser('A131_部長');

        User usr3 = JP_TestUtil.Create_ApproverUser('A141_本部長');

        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
            qh.JP_Step1Approver__c = usr1.Id;
            qh.JP_Step2Approver__c = usr1.Id;
            qh.JP_Step3Approver__c = usr2.Id;
            qh.JP_Step4Approver__c = usr2.Id;
            qh.JP_Step5Approver__c = usr3.Id;
            qh.JP_Step6Approver__c = usr3.Id;
            qh.JP_SectionChief__c = usr1.Id;
            qh.JP_Manager__c = usr2.Id;
            qh.JP_GeneralManager__c = usr3.Id;
        }
        
        insert qhList;
        
        JP_QuotationHeader__c rec = qhList[0];
        
        PageReference pref = Page.JP_SetAuthorizer;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        
        JP_ApprovalProcessMaster__c apm = Create_JP_ApprovalProcessMaster(1);
        apm.JP_Step1Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step2Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step3Approver__c = JP_Const.MANAGER;
        apm.JP_Step4Approver__c = JP_Const.MANAGER;
        apm.JP_Step5Approver__c = JP_Const.GENERAL_MANAGER;
        apm.JP_Step6Approver__c = JP_Const.GENERAL_MANAGER;
        apm.JP_StepCnt__c = 6;
        apm.JP_Step6type__c = '';
        apm.JP_Step6Approver__c = 'Warranty';
        update apm;
        
        Test.startTest();
        
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
        JP_SetAuthorizerController saCtrl = new JP_SetAuthorizerController(sc);
        
        List<String> step1 = saCtrl.step1;
        List<String> step2 = saCtrl.step2;
        List<String> step3 = saCtrl.step3;
        List<String> step4 = saCtrl.step4;
        List<String> step5 = saCtrl.step5;
        List<String> step6 = saCtrl.step6;
        saCtrl.doSave();
        
        Test.stopTest();
        
        System.assertEquals(system.label.JP_Warranty, saCtrl.QHeader.JP_ApprovalLV__c);
    }
    
    
    /**
     *Step6ApproverがJP_GeneralManager__cの場合、StepCnt＝6の場合、JP_Step6type__c≠'User'、JP_Step6Approver__c = 'ATKK_Partner'の場合
     */
    static testMethod void testMethod1607() {
        List<User> usrs = new List<User>();
        User usr1 = JP_TestUtil.Create_ApproverUser('A121_課長');
        
        User usr2 = JP_TestUtil.Create_ApproverUser('A131_部長');
        
        User usr3 = JP_TestUtil.Create_ApproverUser('A141_本部長');

        
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
            qh.JP_Step1Approver__c = usr1.Id;
            qh.JP_Step2Approver__c = usr1.Id;
            qh.JP_Step3Approver__c = usr2.Id;
            qh.JP_Step4Approver__c = usr2.Id;
            qh.JP_Step5Approver__c = usr3.Id;
            qh.JP_Step6Approver__c = usr3.Id;
            qh.JP_SectionChief__c = usr1.Id;
            qh.JP_Manager__c = usr2.Id;
            qh.JP_GeneralManager__c = usr3.Id;
        }
        
        insert qhList;
        
        JP_QuotationHeader__c rec = qhList[0];
        
        PageReference pref = Page.JP_SetAuthorizer;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        
        JP_ApprovalProcessMaster__c apm = Create_JP_ApprovalProcessMaster(1);
        apm.JP_Step1Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step2Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step3Approver__c = JP_Const.MANAGER;
        apm.JP_Step4Approver__c = JP_Const.MANAGER;
        apm.JP_Step5Approver__c = JP_Const.GENERAL_MANAGER;
        apm.JP_Step6Approver__c = JP_Const.GENERAL_MANAGER;
        apm.JP_StepCnt__c = 6;
        apm.JP_Step6type__c = '';
        apm.JP_Step6Approver__c = 'ATKK_Partner';
        update apm;
        
        Test.startTest();
        
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
        JP_SetAuthorizerController saCtrl = new JP_SetAuthorizerController(sc);
        
        List<String> step1 = saCtrl.step1;
        List<String> step2 = saCtrl.step2;
        List<String> step3 = saCtrl.step3;
        List<String> step4 = saCtrl.step4;
        List<String> step5 = saCtrl.step5;
        List<String> step6 = saCtrl.step6;
        saCtrl.doSave();
        
        Test.stopTest();
        
        System.assertEquals(system.label.JP_ATKK_Partner.replace('<br/>',','), saCtrl.QHeader.JP_ApprovalLV__c);
    }
    
    
    /**
     *Step6ApproverがJP_GeneralManager__cの場合、StepCnt＝6の場合、JP_Step6type__c≠'User'、JP_Step6Approver__c = 'ATKK_Warranty'の場合
     */
    static testMethod void testMethod1608() {
        List<User> usrs = new List<User>();
        User usr1 = JP_TestUtil.Create_ApproverUser('A121_課長');
        
        User usr2 = JP_TestUtil.Create_ApproverUser('A131_部長');
        
        User usr3 = JP_TestUtil.Create_ApproverUser('A141_本部長');
        
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
            qh.JP_Step1Approver__c = usr1.Id;
            qh.JP_Step2Approver__c = usr1.Id;
            qh.JP_Step3Approver__c = usr2.Id;
            qh.JP_Step4Approver__c = usr2.Id;
            qh.JP_Step5Approver__c = usr3.Id;
            qh.JP_Step6Approver__c = usr3.Id;
            qh.JP_SectionChief__c = usr1.Id;
            qh.JP_Manager__c = usr2.Id;
            qh.JP_GeneralManager__c = usr3.Id;
        }
        
        insert qhList;
        
        JP_QuotationHeader__c rec = qhList[0];
        
        PageReference pref = Page.JP_SetAuthorizer;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        
        JP_ApprovalProcessMaster__c apm = Create_JP_ApprovalProcessMaster(1);
        apm.JP_Step1Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step2Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step3Approver__c = JP_Const.MANAGER;
        apm.JP_Step4Approver__c = JP_Const.MANAGER;
        apm.JP_Step5Approver__c = JP_Const.GENERAL_MANAGER;
        apm.JP_Step6Approver__c = JP_Const.GENERAL_MANAGER;
        apm.JP_StepCnt__c = 6;
        apm.JP_Step6type__c = '';
        apm.JP_Step6Approver__c = 'ATKK_Warranty';
        update apm;
        
        Test.startTest();
        
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
        JP_SetAuthorizerController saCtrl = new JP_SetAuthorizerController(sc);
        
        List<String> step1 = saCtrl.step1;
        List<String> step2 = saCtrl.step2;
        List<String> step3 = saCtrl.step3;
        List<String> step4 = saCtrl.step4;
        List<String> step5 = saCtrl.step5;
        List<String> step6 = saCtrl.step6;
        saCtrl.doSave();
        
        Test.stopTest();
        
        System.assertEquals(system.label.JP_ATKK_Warranty.replace('<br/>',','), saCtrl.QHeader.JP_ApprovalLV__c);
    }
    
    
    /**
     *Step6ApproverがJP_GeneralManager__cの場合、StepCnt＝6の場合、JP_Step6type__c≠'User'、JP_Step6Approver__c = 'ATKK_Warranty'の場合
     */
    static testMethod void testMethod1609() {
        List<User> usrs = new List<User>();
        User usr1 = JP_TestUtil.Create_ApproverUser('A121_課長');
        
        User usr2 = JP_TestUtil.Create_ApproverUser('A131_部長');
        
        User usr3 = JP_TestUtil.Create_ApproverUser('A141_本部長');
        
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
            qh.JP_Step1Approver__c = usr1.Id;
            qh.JP_Step2Approver__c = usr1.Id;
            qh.JP_Step3Approver__c = usr2.Id;
            qh.JP_Step4Approver__c = usr2.Id;
            qh.JP_Step5Approver__c = usr3.Id;
            qh.JP_Step6Approver__c = usr3.Id;
            qh.JP_SectionChief__c = usr1.Id;
            qh.JP_Manager__c = usr2.Id;
            qh.JP_GeneralManager__c = usr3.Id;
        }
        
        insert qhList;
        
        JP_QuotationHeader__c rec = qhList[0];
        
        PageReference pref = Page.JP_SetAuthorizer;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        
        JP_ApprovalProcessMaster__c apm = Create_JP_ApprovalProcessMaster(1);
        apm.JP_Step1Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step2Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step3Approver__c = JP_Const.MANAGER;
        apm.JP_Step4Approver__c = JP_Const.MANAGER;
        apm.JP_Step5Approver__c = JP_Const.GENERAL_MANAGER;
        apm.JP_Step6Approver__c = JP_Const.GENERAL_MANAGER;
        apm.JP_StepCnt__c = 6;
        apm.JP_Step6type__c = '';
        apm.JP_Step6Approver__c = 'Partner_Warranty';
        update apm;
        
        Test.startTest();
        
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
        JP_SetAuthorizerController saCtrl = new JP_SetAuthorizerController(sc);
        
        List<String> step1 = saCtrl.step1;
        List<String> step2 = saCtrl.step2;
        List<String> step3 = saCtrl.step3;
        List<String> step4 = saCtrl.step4;
        List<String> step5 = saCtrl.step5;
        List<String> step6 = saCtrl.step6;
        saCtrl.doSave();
        
        Test.stopTest();
        
        System.assertEquals(system.label.JP_Partner_Warranty.replace('<br/>',','), saCtrl.QHeader.JP_ApprovalLV__c);
    }
    
    
    /**
     *Step6ApproverがJP_GeneralManager__cの場合、StepCnt＝6の場合、JP_Step6type__c≠'User'、JP_Step6Approver__c = 'ATKK_Partner_Warranty'の場合
     */
    static testMethod void testMethod1610() {
        List<User> usrs = new List<User>();
        User usr1 = JP_TestUtil.Create_ApproverUser('A121_課長');
        
        User usr2 = JP_TestUtil.Create_ApproverUser('A131_部長');
        
        User usr3 = JP_TestUtil.Create_ApproverUser('A141_本部長');
        
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
            qh.JP_Step1Approver__c = usr1.Id;
            qh.JP_Step2Approver__c = usr1.Id;
            qh.JP_Step3Approver__c = usr2.Id;
            qh.JP_Step4Approver__c = usr2.Id;
            qh.JP_Step5Approver__c = usr3.Id;
            qh.JP_Step6Approver__c = usr3.Id;
            qh.JP_SectionChief__c = usr1.Id;
            qh.JP_Manager__c = usr2.Id;
            qh.JP_GeneralManager__c = usr3.Id;
        }
        
        insert qhList;
        
        JP_QuotationHeader__c rec = qhList[0];
        
        PageReference pref = Page.JP_SetAuthorizer;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        
        JP_ApprovalProcessMaster__c apm = Create_JP_ApprovalProcessMaster(1);
        apm.JP_Step1Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step2Approver__c = JP_Const.SECTION_CHIEF;
        apm.JP_Step3Approver__c = JP_Const.MANAGER;
        apm.JP_Step4Approver__c = JP_Const.MANAGER;
        apm.JP_Step5Approver__c = JP_Const.GENERAL_MANAGER;
        apm.JP_Step6Approver__c = JP_Const.GENERAL_MANAGER;
        apm.JP_StepCnt__c = 6;
        apm.JP_Step6type__c = '';
        apm.JP_Step6Approver__c = 'ATKK_Partner_Warranty';
        update apm;
        
        Test.startTest();
        
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
        JP_SetAuthorizerController saCtrl = new JP_SetAuthorizerController(sc);
        
        List<String> step1 = saCtrl.step1;
        List<String> step2 = saCtrl.step2;
        List<String> step3 = saCtrl.step3;
        List<String> step4 = saCtrl.step4;
        List<String> step5 = saCtrl.step5;
        List<String> step6 = saCtrl.step6;
        saCtrl.doSave();
        
        Test.stopTest();
        
        System.assertEquals(system.label.JP_ATKK_Partner_Warranty.replace('<br/>',','), saCtrl.QHeader.JP_ApprovalLV__c);
    }
    
    
    /**
     *StepApproverがJP_Directorの場合
     */
    static testMethod void testMethod14() {
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
        }
        
        insert qhList;
        
        JP_QuotationHeader__c rec = qhList[0];
        
        PageReference pref = Page.JP_SetAuthorizer;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        
        JP_ApprovalProcessMaster__c apm = Create_JP_ApprovalProcessMaster(1);
        apm.JP_StepCnt__c = 4;
        update apm;
        
        Test.startTest();
        
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
        JP_SetAuthorizerController saCtrl = new JP_SetAuthorizerController(sc);
        
        List<String> step1 = saCtrl.step1;
        List<String> step2 = saCtrl.step2;
        List<String> step3 = saCtrl.step3;
        List<String> step4 = saCtrl.step4;
        List<String> step5 = saCtrl.step5;
        List<String> step6 = saCtrl.step6;
        saCtrl.doSave();
        
        Test.stopTest();
        
        System.assertEquals(saCtrl.QHeader.JP_Director__c, saCtrl.QHeader.JP_Step1Approver__c);
    }
    
    
    /**
     *retURL≠NULLの場合
     */
    static testMethod void testMethod1801() {
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
        }
        
        insert qhList;
        
        JP_QuotationHeader__c rec = qhList[0];
        
        PageReference pref = Page.JP_SetAuthorizer;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',qhList[0].id);
        
        JP_ApprovalProcessMaster__c apm = Create_JP_ApprovalProcessMaster(1);
        apm.JP_StepCnt__c = 1;
        update apm;
        
        Test.startTest();
        
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
        JP_SetAuthorizerController saCtrl = new JP_SetAuthorizerController(sc);
        
        List<String> step1 = saCtrl.step1;
        Pagereference returnPage = saCtrl.doCancel();
        
        Test.stopTest();
        
        System.assertEquals(saCtrl.QHeader.Id, returnPage.getUrl());
    }
    
    
    /**
     *retURL=NULLの場合
     */
    static testMethod void testMethod1802() {
        List<JP_QuotationHeader__c> qhList = JP_TestUtil.Create_JP_QuotationHeader(1);
        for(JP_QuotationHeader__c qh :qhList){
            setQuotationHeaderDefault(qh);
        }
        
        insert qhList;
        
        JP_QuotationHeader__c rec = qhList[0];
        
        PageReference pref = Page.JP_SetAuthorizer;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('retURL',NULL);
        
        JP_ApprovalProcessMaster__c apm = Create_JP_ApprovalProcessMaster(1);
        apm.JP_StepCnt__c = 1;
        update apm;
        
        Test.startTest();
        
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(rec);
        JP_SetAuthorizerController saCtrl = new JP_SetAuthorizerController(sc);
        
        List<String> step1 = saCtrl.step1;
        Pagereference returnPage = saCtrl.doCancel();
        
        Test.stopTest();
        
        System.assertEquals('/home/home.jsp', returnPage.getUrl());
    }
    
    
    /**
     *承認プロセス管理マスタ作成
     */
    static JP_ApprovalProcessMaster__c Create_JP_ApprovalProcessMaster(Integer apNo){
        
        JP_ApprovalProcessMaster__c ap = new JP_ApprovalProcessMaster__c();
        ap.JP_ApprovalProcessNo__c = apNo;
        ap.JP_Step1exec__c = true;
        ap.JP_Step1type__c = 'User';
        ap.JP_Step1Approver__c = JP_Const.DIRECTOR;
        
        ap.JP_Step2exec__c = true;
        ap.JP_Step2type__c = 'User';
        ap.JP_Step2Approver__c = JP_Const.DIRECTOR;
        
        ap.JP_Step3exec__c = true;
        ap.JP_Step3type__c = 'User';
        ap.JP_Step3Approver__c = JP_Const.DIRECTOR;
        
        ap.JP_Step4exec__c = true;
        ap.JP_Step4type__c = 'User';
        ap.JP_Step4Approver__c = JP_Const.DIRECTOR;
        
        ap.JP_Step5exec__c = true;
        ap.JP_Step5type__c = 'User';
        ap.JP_Step5Approver__c = JP_Const.DIRECTOR;
        
        ap.JP_Step6exec__c = true;
        ap.JP_Step6type__c = 'User';
        ap.JP_Step6Approver__c = JP_Const.DIRECTOR;
        
        insert ap;
        
        return ap;
    }
    
    
    /**
     *製品見積のデフォルト値を設定する
     */
    static void setQuotationHeaderDefault(JP_QuotationHeader__c qh) {
    //Channelinsight.CI_TEST_TestUtils.createBaseInstallData();Neha commented for model n package uninstallation
        qh.Name = '見積コピーテスト';
        qh.JP_PlannedDeliveryDate__c = 'テスト予定納期';
        qh.JP_PaymentCondition__c = 'テスト支払条件';
        qh.JP_QuotationEffectiveTerm__c = '90';
        qh.JP_Postcode__c = '123-4567';
        qh.JP_Adress1__c = '東京都';
        qh.JP_Adress2__c = '中央区日本橋一丁目3番13号';
        qh.JP_Building__c = '東京建物日本橋ビル';
        qh.JP_Department1__c = 'ソリューション本部';
        qh.JP_Department2__c = '金融ソリューション部';
        qh.JP_QuotationDistCD__c = distibutors[0].Id;
        qh.JP_QuotationContact__c = qcList[0].Id;
        qh.JP_Title__c = '様';
        qh.JP_TelNo__c = '03-1234-5678';
        qh.JP_FaxNo__c = '03-1234-5677';
        qh.JP_ATKK_Postcode__c = '987-6543';
        qh.JP_ATKK_Address1__c = '東京都';
        qh.JP_ATKK_Address2__c = '千代田区千代田１−１';
        qh.JP_ATKK_Building__c = 'テストビル';
        qh.JP_ATKK_Company__c = 'テストカンパニー';
        qh.JP_atkkDepartment1__c = 'テスト部';
        qh.JP_Outside__c = JP_TestUtil.Create_User('011_OUT').Id;
        qh.JP_Inside__c = JP_TestUtil.Create_User('010_IN').Id;
        qh.JP_atkkTellNo__c = '05-1234-5678';
        qh.JP_atkkFaxNo__c = '05-1234-5677';
        qh.JP_QuotationCondition__c = 'テスト見積条件';
        qh.JP_OpportunityNo__c = JP_TestUtil.Create_Opportunity().Id;
        qh.JP_E_U_CompanyName__c = 'テストE/U会社名';
        qh.JP_Distributor__c = 'DIS';
        qh.JP_DeliveryRoute__c = 'テスト納入経路';
        qh.JP_DeliveryDateForApproval__c = 'テスト納期';
        qh.JP_OpportunitySummary__c = 'テスト案件概要';
        qh.JP_CompetitionInfoDetail__c = 'テストコンペ情報の詳細';
        qh.JP_DiscountReason__c = 'テスト値引金額の根拠';
        qh.JP_BusinessPotential__c = 'テスト特価による今後の案件の展開、メリット等';
        qh.JP_OtherRequestReason__c = 'テストその他申請理由';
        qh.JP_TotalAmount__c = 1;
        qh.JP_TotalStandardAmount__c = 1;
        qh.JP_PreSave__c = true;
        qh.JP_QuotationApprovalProcessNo__c = '1';
    }
}