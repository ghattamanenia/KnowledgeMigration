/*******************
Description: This cord is a test cord of JP_CLContactGradeE.
Developer: Hitachi Solutions, Ltd.
Date Created: 10/1/2010
Date Modified: 5/22/2011
*****************/
/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 *
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Test_JP_CLContactGradeE {

    //'JP_Contacts'のレコードタイプを取得する
    public static Id getJPConRecordTypeId () {  
        List<RecordType> otherRec = [select id from RecordType where name = 'JP_Contacts' and SObjectType = 'Contact'];
        return otherRec[0].Id;
    }
    
    //'JP_Accounts'のレコードタイプを取得する
    public static Id getJPAccRecordTypeId () { 
        List<RecordType> accRec = [select id from RecordType where name = 'JP_Accounts' and SObjectType = 'Account'];
        return accRec[0].Id;
    }
    
    //'JP_SalesUser'のプロファイルのユーザを取得する
    public static User getJPTestUser () {    
        List<User> tUser = [select id from User where Profile.name='JP_SalesUser' and isActive=true limit 1];
        return tUser[0];
    }

    
    // ■Check JP_CLContactGradeE■
    private static testMethod void myUnitTest1() {
        
        Test.Starttest();
        List<Contact> targetCon = new List<Contact>();
        targetCon.add(new Contact(Lastname = 'テストクラスの顧客@@@@@', JP_Grade__c = 'E', recordtypeId = getJPConRecordTypeId() ));     
            insert targetCon;
        Test.StopTest();
        
        //CHECH--------
        Contact con = [SELECT Name From Contact WHERE id=:targetCon[0].id];
        System.assertEquals(JP_CLContactGradeE.NGWORD+'テストクラスの顧客@@@@@', con.Name);
    }
    
    private static testMethod void myUnitTest2() {

        List<Contact> targetCon = new List<Contact>();
        targetCon.add(new Contact(Lastname = 'テストクラスの顧客@@@@@', JP_Grade__c = 'E', recordtypeId = getJPConRecordTypeId() )); 
        insert targetCon;       
        Test.Starttest();
            List<Contact>updCon = [select id , JP_Grade__c from Contact where id=:targetCon[0].id];
            updCon[0].JP_Grade__c = 'B';
            update updCon[0];
        Test.StopTest();
        
        //CHECK--------
        Contact con = [SELECT Name From Contact WHERE id=:targetCon[0].id];
        System.assertEquals('テストクラスの顧客@@@@@', con.Name);
    }
    
    private static testMethod void myUnitTest3() {
        
        //会社を用意
        Account acc01 = new Account(Name='AccountTest', RecordtypeId=getJPAccRecordTypeId(),website='http://testtest.test.test');
        acc01.BillingCountry = 'Japan';
        insert acc01;

        //ダミー会社を用意        
        Account acc02 = new Account(Name='エンド不明', RecordtypeId=getJPAccRecordTypeId(),website='http://dummytest.test.test');
        acc02.BillingCountry = 'Japan';
        insert acc02;
        
        //顧客を用意
        List<Contact> targetCon = new List<Contact>();
        targetCon.add(new Contact(Lastname = 'テストクラスの顧客@@@@@', recordtypeId = getJPConRecordTypeId(),Accountid=acc01.id)); 
        insert targetCon;
        
        //ユーザを用意
        User u = getJPTestUser();

        System.runAs(u) {        
            ApexPages.StandardController sc = new ApexPages.StandardController(targetCon[0]);
            Test.Starttest();
            JP_CLMakeOppFromContact MakeOpp = new JP_CLMakeOppFromContact(sc);
            MakeOpp.makeOpp();
            Test.StopTest();
        }
    }
}