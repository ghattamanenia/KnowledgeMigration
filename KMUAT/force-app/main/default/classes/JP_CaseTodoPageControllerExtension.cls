public class JP_CaseTodoPageControllerExtension {

    private final Case ca;

    public JP_CaseTodoPageControllerExtension(ApexPages.StandardController stdController) {
        ca = (Case)stdController.getRecord();
    }
//20241120 semba update データの並び順を件名の昇順に変更(14行目)
    public List<Task> getTasks() {
        List<Task> results = Database.query(
            'SELECT Id, CreatedDate, Subject, WhoId, Who.Name, ActivityDate, OwnerId, Owner.Name, WhatId, What.Name, Status, JP_AttachmentFlag__c, LastModifiedDate, Description ' +
            'FROM Task ' +
            'WHERE WhatId = \'' + ca.Id + '\' ' +
            'ORDER BY Subject ASC ' +
            'LIMIT 10000'
        );
        return results;
    }

}