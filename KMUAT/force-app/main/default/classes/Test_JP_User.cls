/**
 * TestClass JP_User
 */

@IsTest
private class Test_JP_User{
    @isTest
    static void test01() {
        
        Test.startTest(); 
        string  EMAIL   =   'telemat@allied-telesis.co.jp';
        string  LASTNAME    =   'jptest';
        string  FIRSTNAME   =   'telema';
        string  kana    =   'テレマ テスト';
        string  kanji   =   'テレマ テスト';
        string  DIVISION    =   'ﾀﾞｲﾚｸﾄﾏｰｹｯﾄｸﾞﾙｰﾌﾟ';
        string  DEPARTMENT  =   '';
        string  DeptCode    =   '';
        string  GroupCode   =   '';
        string  USERROLEID  =   '00E20000000kLloEAE';
        string  PROFILEID   =   '00e200000019sg3AAA';
        string  Clas    =   'C110_TLM';
        string  Pardot      =   'Marketing';
        boolean UserPermissionsMarketingUser    =   TRUE;

        String newUserId = JP_User.newUser(email,
                              lastName, firstName, kana, kanji,
                              Division, Department, DeptCode, GroupCode, UserRoleId, ProfileId, Clas,
                              Pardot, UserPermissionsMarketingUser);
        Test.stopTest();           
        
    }

    // 既存ユーザ
    @isTest
    static void test02(){
        
        User u = JP_TestUtil.Create_User('new1');

        Test.startTest();
        string  EMAIL   =   'terraskyTest_new1@test.allied-telesis.co.jp';
        string  LASTNAME    =   'jptest';
        string  FIRSTNAME   =   'telema';
        string  kana    =   'テレマ テスト';
        string  kanji   =   'テレマ テスト';
        string  DIVISION    =   'ﾀﾞｲﾚｸﾄﾏｰｹｯﾄｸﾞﾙｰﾌﾟ';
        string  DEPARTMENT  =   '';
        string  DeptCode    =   '';
        string  GroupCode   =   '';
        string  USERROLEID  =   '00E20000000kLloEAE';
        string  PROFILEID   =   '00e200000019sg3AAA';
        string  Clas    =   'C110_TLM';
        string  Pardot      =   'Marketing';
        boolean UserPermissionsMarketingUser    =   TRUE;

        String newUserId = JP_User.newUser(email,
                              lastName, firstName, kana, kanji,
                              Division, Department, DeptCode, GroupCode, UserRoleId, ProfileId, Clas,
                              Pardot, UserPermissionsMarketingUser);
        Test.stopTest();
    }


    // ユーザ有効化
    @isTest
    static void test03(){
        
        User u = JP_TestUtil.Create_User('new1');
        u.IsActive = false;
        update u;

        Test.startTest();
        string  EMAIL   =   'terraskyTest_new1@test.allied-telesis.co.jp';
        string  LASTNAME    =   'jptest';
        string  FIRSTNAME   =   'telema';
        string  kana    =   'テレマ テスト';
        string  kanji   =   'テレマ テスト';
        string  DIVISION    =   'ﾀﾞｲﾚｸﾄﾏｰｹｯﾄｸﾞﾙｰﾌﾟ';
        string  DEPARTMENT  =   '';
        string  DeptCode    =   '';
        string  GroupCode   =   '';
        string  USERROLEID  =   '00E20000000kLloEAE';
        string  PROFILEID   =   '00e200000019sg3AAA';
        string  Clas    =   'C110_TLM';
        string  Pardot      =   'Marketing';
        boolean UserPermissionsMarketingUser    =   TRUE;

        String newUserId = JP_User.newUser(email,
                              lastName, firstName, kana, kanji,
                              Division, Department, DeptCode, GroupCode, UserRoleId, ProfileId, Clas,
                              Pardot, UserPermissionsMarketingUser);
        Test.stopTest();
    }

    // ユーザ無効化(disableUser)
    @isTest 
    static void testDisableUser01() {

        User u = JP_TestUtil.Create_User('disable1');

        Test.startTest();
        JP_User.disableUser();
        Test.stopTest();
    }

    // ユーザ退職(retiredUser) テスト
    @isTest 
    static void testRetiredUser01() {

        User u = JP_TestUtil.Create_User('Retired1');

        Set<String> retiredUserSet = new Set<String>();
        retiredUserSet.add('テスト テスト');

        Test.startTest();
        JP_User.retiredUser(retiredUserSet, true);
        Test.stopTest();
    }
    
    // ユーザ退職(retiredUser)
    @isTest 
    static void testRetiredUser02() {

        User u = JP_TestUtil.Create_User('Retired1');

        Set<String> retiredUserSet = new Set<String>();
        retiredUserSet.add('テスト テスト');

        Test.startTest();
        JP_User.retiredUser(retiredUserSet, false);
        Test.stopTest();
    }

    // OPRO
    @isTest 
    static void testOpro() {

        Test.startTest();
        //ID userId = '0052000000180De';
        //JP_User.authorizationOpro(userId);

        Test.stopTest();
    }

}