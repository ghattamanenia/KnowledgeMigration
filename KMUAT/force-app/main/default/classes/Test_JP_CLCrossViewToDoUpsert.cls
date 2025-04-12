/*******************
Description: This cord is a test cord of JP_CLCrossViewToDoUpsert.
Developer: Hitachi Solutions, Ltd.
Date Created: 11/30/2010
Date Modified: 6/7/2011
*****************/
@isTest
private class Test_JP_CLCrossViewToDoUpsert {
/*

    public static void createTestData(){
        List<RecordType> RecordTypeList = [select ID from RecordType where SObjectType ='Account' and DeveloperName ='JP_AccountsBeforeCleansing'];
        Account acc1 = new Account(name = 'testAccount@@@@@1',recordtypeId=RecordTypeList[0].id, Website='http://testtest');
        insert acc1;
        Account acc2 = new Account(name = 'testAccount@@@@@2',recordtypeId=RecordTypeList[0].id, Website='http://testtest');
        insert acc2;
        Contact con = new Contact(LastName = 'testContact@@@@@');
        insert con;
    }
    public static Id testRecData(){
        List<RecordType> recList = [select id from RecordType where name = 'JP_Tasks'];
        return recList[0].Id;
    }   
    public static Id testAccData(){
        List<Account> accList = [select id from Account where name = 'testAccount@@@@@1'];
        return accList[0].Id;
    }
    public static Id testAccData2(){
        List<Account> accList = [select id from Account where name = 'testAccount@@@@@2'];
        return accList[0].Id;
    }
    public static Id testConData(){
        List<Contact> conList = [select id from Contact where name = 'testContact@@@@@'];
        return conList[0].Id;
    }
    
    private static testMethod void JP_CLCrossViewToDo_Insert_001() {
        createTestData();
        Id accId = testAccData();
        Id conId = testConData();
        Id recId = testRecData();
        
        Task tData = new Task();
        tData.Subject = 'testTask@@@@@';
        tData.RecordTypeId = recid;
        tData.WhatId  = accid;
        insert tData;
    }
    private static testMethod void JP_CLCrossViewToDo_Update_Ins_002() {
        createTestData();
        Id accId = testAccData();
        Id conId = testConData();
        Id recId = testRecData();

        Task tData = new Task();
        tData.Subject = 'testTask@@@@@';
        tData.Description = 'testTask@@@@@';
        tData.RecordTypeId = recid;
        insert tData;
        List<Task> tList =  [select id, Subject, WhatId, WhoId from Task where Subject = 'testTask@@@@@' ];
        tList[0].WhatId = accId;
        update tList[0];
    }
    private static testMethod void JP_CLCrossViewToDo_Update_Upd_003() {
        createTestData();
        Id accId = testAccData();
        Id accId2 = testAccData2();
        Id conId = testConData();
        Id recId = testRecData();

        Task tData = new Task();
        tData.Subject = 'testTask@@@@@';
        tData.RecordTypeId = recid;
        tData.WhatId = accId;
        insert tData;
        List<Task> tList = [select id, WhatId, recordTypeId from Task where Subject = 'testTask@@@@@'];
        tList[0].WhatId = accId2;
        update tList[0];
    }
    private static testMethod void JP_CLCrossViewToDo_Update_Del_004() {
        createTestData();
        Id accId = testAccData();
        Id conId = testConData();
        Id recId = testRecData();

        Task tData = new Task();
        tData.Subject = 'testTask@@@@@';
        tData.RecordTypeId = recid;
        tData.WhatId = accId;
        insert tData;
        List<Task> tList = [select id, WhatId, recordTypeId from Task where Subject = 'testTask@@@@@'];
        tList[0].WhatId = null;
        update tList[0];
    }
    private static testMethod void JP_CLCrossViewToDo_Delete_005() {
        createTestData();
        Id accId = testAccData();
        Id conId = testConData();
        Id recId = testRecData();

        Task tData = new Task();
        tData.Subject = 'testTask@@@@@';
        tData.RecordTypeId = recid;
        tData.WhatId  = accid;
        insert tData;
        List<Task> t = [select id from Task where Subject = 'testTask@@@@@'];
        delete t;
    }
*/
}