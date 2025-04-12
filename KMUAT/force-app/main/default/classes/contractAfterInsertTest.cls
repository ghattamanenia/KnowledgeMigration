@isTest
public class contractAfterInsertTest
{
    public static testmethod void testm()
    {
      //Channelinsight.CI_TEST_TestUtils.createBaseInstallData();
       
       Id devAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('ATI Accounts').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId=devAccRecordTypeId;
        acc.Name='Test Acc';
        acc.ATFE_AccountType__c='DIRECT (USD)';
        acc.Region__c='NA';
        acc.ATFE_VerticalMarketInit__c='Education';
        acc.Website='aff@gmail.com';
        insert acc;
        
        

 

        Id devRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('ATFE_ContractAfterApproval').getRecordTypeId();
        
        Contract contracts1 = new contract();
        contracts1.recordtypeId = devRecordTypeId;
        contracts1.StartDate=system.today();
        // contracts.status='Activated';
        contracts1.status='Draft';
        contracts1.AccountId=acc.Id;
        
        insert contracts1;
        
        
        Contract contracts = new contract();
        contracts.recordtypeId = devRecordTypeId;
        contracts.StartDate=system.today();
        // contracts.status='Activated';
        contracts.status='Draft';
        contracts.AccountId=acc.Id;
        contracts.Clone_From__c=contracts1.Id;
        insert contracts;
        
    }
   
}