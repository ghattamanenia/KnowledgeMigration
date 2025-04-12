@isTest
private class Test_JP_TestUtil {

    static testMethod void testCreate_JP_QuotationTemplate(){
        Test.startTest();
        JP_TestUtil.Create_JP_QuotationTemplate();
        Test.stopTest();
    }
    
    static testMethod void testCreate_JP_ApprovalProcessMaster(){
        test.startTest();
        JP_ApprovalProcessMaster__c apm = JP_TestUtil.Create_JP_ApprovalProcessMaster(1);
        test.stopTest();
    }
    
    static testMethod void testCreate_JP_ApprovalProcess(){
        test.startTest();
        List<JP_DecideApprovalProcess__c> daps = JP_TestUtil.Create_JP_ApprovalProcess(1);
        test.stopTest();
    }
    
    static testMethod void tesetCreate_JP_QuotationHeader(){
        test.startTest();
        List<JP_QuotationHeader__c> qhs = JP_TestUtil.Create_JP_QuotationHeader(1);
        test.stopTest();
    }
    
    static testMethod void testCreate_JP_CustomerInfo2(){
        test.startTest();
        List<JP_QuotationHeader__c> qhs = JP_TestUtil.Create_JP_QuotationHeader(1);
        List<JP_CustomerInfo2__c> cis = JP_TestUtil.Create_JP_CustomerInfo2(qhs[0].Id,1);
        test.stopTest();
    }
    
    static testMethod void testCreate_JP_QuotationHeaderForTrigger(){
        test.startTest();
        JP_QuotationHeader__c qh = JP_TestUtil.Create_JP_QuotationHeaderForTrigger(1);
        test.stopTest();
    }
    
    static testMethod void testCreate_PreJP_QuotationHeader(){
        test.startTest();
        JP_QuotationHeader__c qh = JP_TestUtil.Create_PreJP_QuotationHeader(1);
        test.stopTest();
    }
    
    static testMethod void testCreate_JP_QuotationDetail(){
        test.startTest();
        JP_QuotationHeader__c qh = JP_TestUtil.Create_PreJP_QuotationHeader(1);
        List<JP_QuotationDetail__c> qds = JP_TestUtil.Create_JP_QuotationDetail(qh.Id,1);
        test.stopTest();
    }
    
    
    static testMethod void testCreate_JP_DistributorPrice(){
        test.startTest();
        List<JP_DistributorPrice__c> dps = JP_TestUtil.Create_JP_DistributorPrice(1);
        test.stopTest();
    }
    
    static testMethod void testCreate_JP_DistributorPriceForTrigger(){
        test.startTest();
        List<JP_DistributorPrice__c> dps = JP_TestUtil.Create_JP_DistributorPriceForTrigger(1);
        test.stopTest();
    }
    
    static testMethod void testCreate_JP_Department(){
        test.startTest();
        JP_TestUtil.Create_JP_Department();
        test.stopTest();
    }
    
    static testMethod void testCreate_JP_QuotationCondition(){
        test.startTest();
        JP_TestUtil.Create_JP_QuotationCondition();
        test.stopTest();
    }
    
    static testMethod void testCreate_JP_QuotationDistributor(){
        test.startTest();
        List<JP_QuotationDistributor__c> qds = JP_TestUtil.Create_JP_QuotationDistributor();
        test.stopTest();
    }
    
    static testMethod void testCreate_JP_QuotationContact(){
        test.startTest();
        List<JP_QuotationDistributor__c> qds = JP_TestUtil.Create_JP_QuotationDistributor();
        JP_TestUtil.Create_JP_QuotationContact(qds);
        test.stopTest();
    }
    
    static testMethod void testCreate_JP_PriceYearMonth(){
        test.startTest();
        List<JP_PriceYearMonth__c> pyms = JP_TestUtil.Create_JP_PriceYearMonth(1);
        test.stopTest();
    }
    
    static testMethod void testCreate_AdminUser(){
        test.startTest();
        User u = JP_TestUtil.Create_AdminUser('A');
        test.stopTest();
    }
    
    static testMethod void testCreate_ApproverUser(){
        test.startTest();
        User u = JP_TestUtil.Create_ApproverUser('A');
        test.stopTest();
    }
    
    static testMethod void testCreate_User(){
        test.startTest();
        User u = JP_TestUtil.Create_User('A');
        test.stopTest();
    }
    
    static testMethod void testCreateAccount(){
        test.startTest();
        List<Account> accs = JP_TestUtil.CreateAccount(1);
        test.stopTest();
    }
    
    static testMethod void testCreate_Opportunity(){
        test.startTest();
        Opportunity opp = JP_TestUtil.Create_Opportunity();
        test.stopTest();
    }
    
    static testMethod void testCreatePartner(){
        test.startTest();
        List<Account> accs = JP_TestUtil.CreateAccount(1);
        Opportunity opp = JP_TestUtil.Create_Opportunity();
        JP_TestUtil.CreatePartner(opp.Id,accs[0].Id);
        test.stopTest();
    }
    
    static testMethod void testCreateOpportunityTeamMember(){
        test.startTest();
        Opportunity opp = JP_TestUtil.Create_Opportunity();
        User u = JP_TestUtil.Create_AdminUser('A');
        JP_TestUtil.CreateOpportunityTeamMember(opp.Id,u.Id);
        test.stopTest();
    }
    
    static testMethod void testCreateProduct(){
        test.startTest();
        PriceBookEntry pbe = JP_TestUtil.CreateProduct();
        test.stopTest();
    }
    
    static testMethod void testCreateOpportunityLineItem(){
        test.startTest();
        Opportunity opp = JP_TestUtil.Create_Opportunity();
        PriceBookEntry pbe = JP_TestUtil.CreateProduct();
        JP_TestUtil.CreateOpportunityLineItem(opp.Id,pbe.Id);
        test.stopTest();
    }
    
    static testMethod void testCreate_DistributorProductCode(){
        test.startTest();
        JP_TestUtil.Create_DistributorProductCode('a');
        test.stopTest();
    }
    
    static testMethod void testCreate_JP_SpecailPriceApprove(){
        test.startTest();
        List<JP_QuotationHeader__c> qhs = JP_TestUtil.Create_JP_QuotationHeader(1);
        JP_SpecailPriceApprove__c spa = JP_TestUtil.Create_JP_SpecailPriceApprove(qhs[0]);
        test.stopTest();
    } 
    
    static testMethod void testCreate_JP_SpecailPriceApproveList(){
        test.startTest();
        List<JP_QuotationHeader__c> qhs = JP_TestUtil.Create_JP_QuotationHeader(1);
        List<JP_SpecailPriceApprove__c> spas = JP_TestUtil.Create_JP_SpecailPriceApprove(qhs[0],1);
        test.stopTest();
    } 
}