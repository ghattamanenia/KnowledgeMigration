@isTest
private class Test_EmailMessage_Trigger {

private  static Id  ATI_CaseID;
private  static Id  SFSupport_CaseID;
private  static Id  SFSupportEnhanc_CaseID;
private  static Id  SFSupportData_CaseID;
private  static Id  SFSupportAccess_CaseID;

static {      
     
        List<RecordType> AllCaseRT = [SELECT Id, DeveloperName  FROM RecordType where Sobjecttype = 'Case'];
        
        for(RecordType CaseRT : AllCaseRT )
        {
            if(CaseRT.DeveloperName == 'ATI_Case')
                ATI_CaseID = CaseRT.ID;
            if(CaseRT.DeveloperName == 'SF_Case')
                SFSupport_CaseID = CaseRT.ID;
            if(CaseRT.DeveloperName == 'SF_Case_Enhancement')
                SFSupportEnhanc_CaseID = CaseRT.ID;
            if(CaseRT.DeveloperName == 'SF_Case_Data')
                SFSupportData_CaseID = CaseRT.ID;
            if(CaseRT.DeveloperName == 'SF_Case_Access')
                SFSupportAccess_CaseID = CaseRT.ID;
        }
        }
    
    static testMethod void validate_EmailMessage_Trigger () {
     Case SF_CASEATI = new Case();
      SF_CASEATI.Request_Title__c  = 'Test Request'; //Customer title
      SF_CASEATI.Description  = 'Test description';  //Customer description
      SF_CASEATI.Status  = 'New';  //Customer description
      SF_CASEATI.RecordTypeId = ATI_CaseID ;
      
      insert SF_CASEATI;
      
      Case SF_CASE = new Case();
      SF_CASE.Request_Title__c  = 'Test Request'; //Customer title
      SF_CASE.Description  = 'Test description';  //Customer description
      SF_CASE.Status  = 'New';  //Customer description
      SF_CASE.RecordTypeId = SFSupport_CaseID;
     // Allcases.add(SF_CASE);
      
      insert SF_CASE ;
    
    EmailMessage[] newEmail = new EmailMessage[0];
 
    newEmail.add(new EmailMessage(FromAddress = 'test@abc.org', Incoming = True, ToAddress= 'salesforcesupport@alliedtelesis.com', Subject = 'Test email', TextBody = '23456 ', ParentId = SF_CASE.Id)); 
 
    insert newEmail;
    
    EmailMessage[] newEmailATI = new EmailMessage[0];
 
    newEmailATI.add(new EmailMessage(FromAddress = 'test@abc.org', Incoming = True, ToAddress= 'salesforcesupport@alliedtelesis.com', Subject = 'Test email', TextBody = '23456 ', ParentId = SF_CASEATI.Id)); 
 
    insert newEmailATI;
    
    }
}