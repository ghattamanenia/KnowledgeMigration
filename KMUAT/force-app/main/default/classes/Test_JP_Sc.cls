/**
 * Apexスケジュールのテストクラス
 */
@isTest 
private class Test_JP_Sc {
public static String CRON_EXP = '0 0 0 15 3 ?';

    @isTest 
    static void testEveryMonth() {

        Test.startTest();
        String jobId = System.schedule('ScheduledApexTest',
        CRON_EXP, 
        new JP_Sc_EveryMonth());         

        Test.stopTest();
    }
        
    @isTest 
    static void testUser() {

        Test.startTest();
        String jobId = System.schedule('ScheduledApexTest',
        CRON_EXP, 
        new JP_Sc_User());         

        Test.stopTest();
    }
    
    @isTest 
    static void testShift() {

        Test.startTest();
        String jobId = System.schedule('ScheduledApexTest',
        CRON_EXP, 
        new JP_Sc_Shift());         

        Test.stopTest();
    }
    
    @isTest 
    static void testEveryWeek() {

        Test.startTest();
        String jobId = System.schedule('ScheduledApexTest',
        CRON_EXP, 
        new JP_Sc_EveryWeek());         

        Test.stopTest();
    }
    
}