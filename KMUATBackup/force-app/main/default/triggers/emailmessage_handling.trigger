trigger emailmessage_handling on EmailMessage (before insert, after insert) 
{
   system.debug(':: This is email trigger:::');
   
   /* if (Trigger.isBefore) 
    {
    
     // String AltirisAdmin = 'Altiris_Admin@alliedtelesis.com'; ITHelpdeskNA@alliedtelesis.com; // do not know which one to use.
      String InSubject,ToEmail;
     String SalesForceSupportAddress = 'salesforcesupport-test@alliedtelesis.com';
     //String NewHireSubject = 'Salesforce Account Request for New Hire';
     //String LeaverSubject =  'Salesforce Account Request for Leaver';
     
     for(EmailMessage NewEmailMsg: trigger.new)
     {
         //FromEmail = NewEmailMsg.FromAddress;
         ToEmail = NewEmailMsg.ToAddress;
         //InSubject = NewEmailMsg.Subject;
         if(NewEmailMsg.Incoming == true && ToEmail.contains(SalesForceSupportAddress) )
         {
            // if(!(InSubject.contains(NewHireSubject) || InSubject.contains(LeaverSubject )) )
             //{
               //  NewEmailMsg.addError('New SF support case is allowed only for new hire or leaver:' + NewEmailMsg.ParentId); 
             //}
             if(NewEmailMsg.parentid == null)
             {
                     system.debug('::::Creating error ::::');
             
             }
             else
                 system.debug(':: NewEmailMsg.parentid:::' + NewEmailMsg.parentid);
         }
     }
    }*/
    
    Set<Id> EmIds = new Set<Id>();
    for(EmailMessage Em:Trigger.new)
    {
        if(Em.ParentId!=null && String.ValueOf(Em.ParentId).Startswith('500'))
        {
            EmIds.add(Em.parentId);
        }
    }

    system.debug('@@@EmIds'+EmIds);
    
    
    if (Trigger.isAfter && !EmIds.isEmpty()) 
    {
    
        // Below lines of code is added by Neha on 4th of Feb 2020.
        EmailMessageTriggerHandler.netMonitorProcessing(trigger.newMap);


        
        // end of Neha code changes
        //ID ATI_CaseID = [select Name,Id from RecordType where DeveloperName = 'ATI_Case'].Id;
        List<RecordType> AllCaseRT = [SELECT Id, DeveloperName  FROM RecordType where Sobjecttype = 'Case']; //get all case recordtypeIds
        Id  ATI_CaseID = null; 
        Id  ATI_RMAParentID  = null; 
        Id  SF_CaseID = null; 
        Id  SF_EnhanCasID = null; 
        Id  SF_CaseAccessID = null; 
        Id  SF_CaseDataID = null;
        Id  ATI_RMA_Child_CaseID = null; 
        Id  ATI_Community_RegistrationID = null; 
        Id  ATI_case_create_HWID = null;    
       
        //save record values in variables
        for(RecordType CaseRT : AllCaseRT )
        {
            if(CaseRT.DeveloperName == 'ATI_Case')
                ATI_CaseID= CaseRT.ID;
            if(CaseRT.DeveloperName == 'ATI_RMA_Parent_Case')
                ATI_RMAParentID = CaseRT.ID;
            if(CaseRT.DeveloperName == 'ATI_RMA_Child_Case')
                ATI_RMA_Child_CaseID = CaseRT.ID;
            if(CaseRT.DeveloperName == 'ATI_Community_Registration')
                ATI_Community_RegistrationID = CaseRT.ID;
            if(CaseRT.DeveloperName == 'ATI_case_create_HW_Asset')
                ATI_case_create_HWID = CaseRT.ID;
            if(CaseRT.DeveloperName == 'SF_Case')
                SF_CaseID = CaseRT.ID;
            if(CaseRT.DeveloperName == 'SF_Case_Enhancement')
                SF_EnhanCasID = CaseRT.ID;
            if(CaseRT.DeveloperName == 'SF_Case_Access')
                SF_CaseAccessID = CaseRT.ID;
            if(CaseRT.DeveloperName == 'SF_Case_Data')
                SF_CaseDataID = CaseRT.ID;
        }
    
    
         Set<ID> parentCase_ID = new Set<ID>();
         List<Case> CommentsONCases = new List<Case>();
         List<Case_Comment__c> CaseComments = new  List<Case_Comment__c>();
         List<Comment__c> Comments = new  List<Comment__c>();
         String ATSupportEmailStringtestbox = 'atsupport-test@alliedtelesis.com';
         String ATSupportEmailString = 'atsupport@alliedtelesis.com';
         String SFSupportEmailStringTestbox = 'salesforcesupport-test@alliedtelesis.com';
         String SFSupportEmailStringprod = 'salesforcesupport@alliedtelesis.com';
         String FromEmail;
         List<String> ToEmail = new List<String>();
         List<String> CCEmail = new List<String>();
         List<String> BCCEmail = new List<String>();
         List<String> ALL_Addresses = new List<String>();
         boolean IsPublic;
         //get all parent IDs
         for(EmailMessage NewEmailMsg: trigger.new)
         {
             parentCase_ID.add(NewEmailMsg.ParentId);
         }
         // get all cases    
         CommentsONCases = [select Id,RecordTypeId,ownerid from Case where ID IN :parentCase_ID];
         for(EmailMessage NewEmailMsg: trigger.new)
         {
             IsPublic = false;
             FromEmail = null;
             ToEmail.clear();
             CCEmail.clear();
             BCCEmail.clear();
             ALL_Addresses.clear();
             
             // Added by Neha to fix the issue with outlook for salesforce
             if(NewEmailMsg.FromAddress!=null)
             FromEmail = NewEmailMsg.FromAddress;
             if( NewEmailMsg.ToAddress!=null)
                 ToEmail = NewEmailMsg.ToAddress.split(';');
             if( NewEmailMsg.CcAddress!=null)
                 CCEmail = NewEmailMsg.CcAddress.split(';');
             if( NewEmailMsg.BccAddress!=null)
                 BCCEmail = NewEmailMsg.BccAddress.split(';');
             system.debug('### TO EMAIL ###' + ToEmail);
             system.debug('### CC EMAIL ###' + CCEmail);
             system.debug('### CC EMAIL ###' + BCCEmail);
             if(FromEmail!=null)
             ALL_Addresses.add(FromEmail);
             if(ToEmail!=null)
             ALL_Addresses.addAll(ToEmail);
             if(CCEmail!=null)
             ALL_Addresses.addAll(CCEmail);
             if(BCCEmail!=null)
             ALL_Addresses.addAll(BCCEmail); 
             
             system.debug('###  ALL_Addresses ###' +  ALL_Addresses);
             
             for(string add : ALL_Addresses){
                system.debug('### add ###' + add);
                 if(!add.contains('@alliedtelesis.com')){
                     IsPublic = true;                 
                 }
             
             }
              
             for(case Cases: CommentsONCases )
             {   
                 
                 if(Cases.Id == NewEmailMsg.ParentId && 
                 ((Cases.RecordTypeId == ATI_CaseID) || ( Cases.RecordTypeId == ATI_RMAParentID )|| (Cases.RecordTypeId == ATI_RMA_Child_CaseID) || (Cases.RecordTypeId == ATI_Community_RegistrationID) ||( Cases.RecordTypeId == ATI_case_create_HWID)) 
                 && NewEmailMsg.Incoming == true && (!FromEmail.equalsIgnoreCase(ATSupportEmailString )) && (!FromEmail.equalsIgnoreCase(ATSupportEmailStringtestbox )))
                 {
                     Case_Comment__c CC = new Case_Comment__c();
                     CC.Case__c = NewEmailMsg.ParentId;
                     CC.Comment_Type__c = 'Inbound Email';
                     CC.Related_Email_Id__c = NewEmailMsg.Id;
                     CC.Comment__c = NewEmailMsg.TextBody;
                     if(IsPublic && (Cases.RecordTypeId != ATI_RMA_Child_CaseID) && (Cases.RecordTypeId != ATI_Community_RegistrationID) && ( Cases.RecordTypeId != ATI_case_create_HWID))
                         CC.Public__c = true;
                     CC.Ownerid = Cases.ownerid;
                     CaseComments.add(CC);
                  }
                 if(Cases.Id == NewEmailMsg.ParentId && (Cases.RecordTypeId == SF_CaseID || Cases.RecordTypeId == SF_EnhanCasID || Cases.RecordTypeId == SF_CaseDataID || Cases.RecordTypeId == SF_CaseAccessID ) && NewEmailMsg.Incoming == true && (!FromEmail.equalsIgnoreCase(SFSupportEmailStringTestbox ) && !FromEmail.equalsIgnoreCase(SFSupportEmailStringprod )))
                 {
                 // if email coming from Altaris no need to add comment.
                     Comment__c Cmnt = new Comment__c();
                     Cmnt.Related_Case__c = NewEmailMsg.ParentId;
                     Cmnt.Comment_Type__c = 'Inbound Email';
                     Cmnt.Related_Email_Id__c = NewEmailMsg.Id;
                     Cmnt.Comment__c = NewEmailMsg.TextBody;
                     Cmnt.Public__c = true;
                     Cmnt.Ownerid = Cases.ownerid;
                     Comments.add(Cmnt);
                     
                     
                  }
                 if(Cases.Id == NewEmailMsg.ParentId && 
                 ((Cases.RecordTypeId == ATI_CaseID) || ( Cases.RecordTypeId == ATI_RMAParentID )|| (Cases.RecordTypeId == ATI_RMA_Child_CaseID) || (Cases.RecordTypeId == ATI_Community_RegistrationID) ||( Cases.RecordTypeId == ATI_case_create_HWID)) 
                 && NewEmailMsg.Incoming == false )
                 {
                     Case_Comment__c CC = new Case_Comment__c();
                     CC.Case__c = NewEmailMsg.ParentId;
                     CC.Comment_Type__c = 'Outbound Email';
                     CC.Related_Email_Id__c = NewEmailMsg.Id;
                     CC.Comment__c = NewEmailMsg.TextBody;
                     if(IsPublic && (Cases.RecordTypeId != ATI_RMA_Child_CaseID) && (Cases.RecordTypeId != ATI_Community_RegistrationID) && ( Cases.RecordTypeId != ATI_case_create_HWID))
                        CC.Public__c = true;
                     CC.Ownerid = Cases.ownerid;
                     CaseComments.add(CC);
                  }
                 if(Cases.Id == NewEmailMsg.ParentId && (Cases.RecordTypeId == SF_CaseID || Cases.RecordTypeId == SF_EnhanCasID || Cases.RecordTypeId == SF_CaseDataID || Cases.RecordTypeId == SF_CaseAccessID ) && NewEmailMsg.Incoming == false )
                 {
                 // if email coming from Altaris no need to add comment.
                     Comment__c Cmnt = new Comment__c();
                     Cmnt.Related_Case__c = NewEmailMsg.ParentId;
                     Cmnt.Comment_Type__c = 'Outbound Email';
                     Cmnt.Related_Email_Id__c = NewEmailMsg.Id;
                     Cmnt.Comment__c = NewEmailMsg.TextBody;
                     Cmnt.Public__c = false;
                     Cmnt.Ownerid = Cases.ownerid;
                     Comments.add(Cmnt);
                     
                     
                  }
             }
             
         }
         if(CaseComments.size() > 0)
             insert CaseComments;   
          if(Comments.size() > 0)
             insert Comments;    
    }
    
}