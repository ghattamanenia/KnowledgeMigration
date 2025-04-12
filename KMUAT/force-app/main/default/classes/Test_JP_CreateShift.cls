/**
 * JP_CreateShiftのテストクラス
 */
@isTest 
private class Test_JP_CreateShift {

    // 通常
    @isTest 
    static void testNormal01() {

        User telema1 = JP_TestUtil.Create_User('test');
        JP_Shift__c shift = Create_JP_Shift(telema1.Id);

        Test.startTest();
        JP_CreateShift.specifiedPeriodUser(date.newinstance(2020, 12, 1), date.newinstance(2020, 12, 31), '');
        Test.stopTest();
    }

    // マスタ指定
    @isTest 
    static void testNormal02() {

        User telema1 = JP_TestUtil.Create_User('test');
        JP_Shift__c shift = Create_JP_Shift(telema1.Id);

        Test.startTest();
        JP_CreateShift.specifiedPeriodUser(date.newinstance(2020, 12, 1), date.newinstance(2020, 12, 31), 'user');
        Test.stopTest();
    }

    // マスタレコード作成
    static JP_Shift__c Create_JP_Shift(Id userId){
        
        JP_Shift__c shift = new JP_Shift__c();
        shift.JP_User__c = userId;
        shift.ownerId = userId;
        shift.JP_Master__c = true;
        
        insert shift;
        return shift;
    }
}