@isTest
public class JP_CaseTodoPageControllerExtensionTest {
    public static testMethod void testCaseTodoPageController() {
        Case cas = new Case(Subject = 'test');
        insert cas;
        Task tsk = new Task(Subject = 'TaskTest', WhatId = cas.Id);
        insert tsk;
        PageReference pageRef = Page.JP_CaseTodoPage;
        pageRef.getParameters().put('Id', cas.Id);
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(cas);
        Test.startTest();
        JP_CaseTodoPageControllerExtension cc = new JP_CaseTodoPageControllerExtension(sc);
        System.assertEquals(tsk.Id, cc.getTasks().get(0).Id);
        System.assertEquals(tsk.Subject, cc.getTasks().get(0).Subject);
        System.assertEquals(tsk.WhatId, cc.getTasks().get(0).WhatId);
        Test.stopTest();
    }
}