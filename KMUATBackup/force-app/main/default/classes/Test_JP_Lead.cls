/**
 * TestClass JP_ConvertingLead
 */

@IsTest
private class Test_JP_Lead {

    // JP_ConvertingLead(リード取引開始時)
    static testMethod void testConvertingLead1(){
        Lead ld = createLd();
        JP_callReport__c cr = CreateCr(ld.Id);
        task tsk = CreateTsk(cr.Id);

        Test.startTest();

        // リードの取引開始
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(ld.id);
        lc.setConvertedStatus('承認&トランス通知済み');
        Database.LeadConvertResult lcr = Database.convertLead(lc);

        Test.stopTest();
        
    }

    // リード作成
    static Lead CreateLd(){

        Lead ld = new Lead();
        ld.RecordtypeId = '01220000000AIUl';
        ld.Company = 'テストクラス株式会社';
        ld.LastName = 'テストクラス';
        ld.FirstName = 'テストクラス';
        ld.Email = 'istest03@allied-telesis.co.jp';
        ld.JP_Field05__c = '部署';
        ld.JP_test_rec__c = TRUE;//2024/01/23 仙波追記

        insert ld;
        return ld;
    }

    // コールレポート作成
    static JP_Callreport__c CreateCr(Id ldId){

        JP_Callreport__c cr = new JP_Callreport__c();
        cr.Name = 'test';
        cr.JP_LeadId__c = ldId;

        insert cr;
        return cr;
    }

    // Todo作成
    static Task CreateTsk(Id crId){
        
        Task tsk = new Task();
        tsk.RecordtypeId = '012200000005vdv';
        tsk.Subject = 'test';
        tsk.whatId = crId;

        insert tsk;
        return tsk;
    }
}