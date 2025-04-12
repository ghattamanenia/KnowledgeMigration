public with sharing class JP_Matter_ViewCase{

    private Final JP_Matter__c matter;
    public List<Case> caseList {get; set;}
    
    public JP_Matter_ViewCase(ApexPages.StandardController controller) {
        this.matter = (JP_Matter__c)controller.getRecord();
        
        caseList = new List<Case>();
        caseList = getCase(this.matter.JP_Client__c);
        
    }

    private static List<Case> getCase(Id conId){

        List<Case> wkCaseList = new List<Case>();
        if(conId != null){
            wkCaseList = [SELECT Id, CaseNumber, CreatedDate, ClosedDate,
                                 Origin, Subject, JP_InquiryCategory__c,
                                 Contact.Name, Status, JP_OpenCaseSortFomula__c,
                                 owner.Name,  ownerId
                          FROM   Case
                          WHERE  ContactId=:conId];
        }
        return wkCaseList;
    }

}