trigger SFSupport_case_events on Case (before insert, before update) 
{
  if(UtilSODOFlags.skip_caseTrigges)
    return;  
    
    List<RecordType> AllCaseRT = [SELECT Id, DeveloperName  FROM RecordType where Sobjecttype = 'Case'];
    Id  SF_CaseID = null; 
    Id  SF_EnhancementID = null;
    Id  SF_CaseAccessID = null; 
    Id  SF_CaseDataID = null;  
    
     system.debug('::new SF case find record type');
    for(RecordType CaseRT : AllCaseRT )
    {
            if(CaseRT.DeveloperName == 'SF_Case')
                SF_CaseID = CaseRT.ID;
            if(CaseRT.DeveloperName == 'SF_Case_Enhancement')
                SF_EnhancementID = CaseRT.ID;
            if(CaseRT.DeveloperName == 'SF_Case_Access')
                SF_CaseAccessID= CaseRT.ID;
            if(CaseRT.DeveloperName == 'SF_Case_Data')
                SF_CaseDataID = CaseRT.ID;
    }
    
  
   String  caseSubject = '';   
  // String SalesForceSupportAddress = 'salesforcesupport-test@alliedtelesis.com';
  // String NewHireSubject = 'Salesforce Account Request for New Hire';
  // String LeaverSubject =  'Salesforce Account Request for Leaver'; 
   
   if (Trigger.isBefore ) 
    {
       /* if(Trigger.isUpdate)
        {
             for(case Newcase: trigger.new)
             {
                 system.debug('related project status::' +  Newcase.Related_CMT_Project_Status__c);
                 if((Newcase.Copied_to_CMT__c == True) &&  (Newcase.Status != 'Closed') && (Newcase.Related_CMT_Project_Status__c == 'Completed'))
                 {
                     system.debug(':: Inside 1::');
                     Newcase.Status = 'Closed';
                     Newcase.Resolution_Code__c = 'Fixed & Deployed';
                     
                 }
                 if((Newcase.Copied_to_CMT__c == True) && (Newcase.Target_Release_Date__c != null)  && (Newcase.Status != 'Closed') && (Newcase.Related_CMT_Project_Status__c != 'Completed'))
                 {
                     system.debug(':: Inside 2::');
                     Newcase.Status = 'Approved – Scheduled';
                    
                 }
                 
                 if((Newcase.Copied_to_CMT__c == True) && (Newcase.Target_Release_Date__c == null)  && (Newcase.Status != 'Closed') && (Newcase.Related_CMT_Project_Status__c != 'Completed'))
                 {
                     system.debug(':: Inside 3::');
                     Newcase.Status = 'Approved – Pending';
                    
                 }
                 
                 
             }
        
        }*/
        for(case Newcase: trigger.new)
         {
     
            if(Newcase.Recordtypeid == SF_CaseID && Newcase.Origin == 'Email to SF Support' )
            {
               // Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                //message.setTemplateId([select id from EmailTemplate where DeveloperName ='SFSupport_email_to_case_response'].id);
                //message.setToAddresses(new String[] {Newcase.SuppliedEmail});
                //Messaging.sendEmail(new Messaging.Email[] {message});
                //Messaging.reserveSingleEmailCapacity(2);
                //Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

                // Strings to hold the email addresses to which you are sending the email.
                //String[] toAddresses = new String[] {Newcase.SuppliedEmail}; 
                //String[] toAddresses = new String[] {'sarvinder_sandhu@alliedtelesis.com'}; 
                //String[] ccAddresses = new String[] {'smith@gmail.com'};
                  
                
                // Assign the addresses for the To and CC lists to the mail object.
               // mail.setToAddresses(toAddresses);
               // mail.setCcAddresses(ccAddresses);
                
                // Specify the address used when the recipients reply to the email. 
               // mail.setReplyTo('salesforcesupport-test@alliedtelesis.com');
                
                // Specify the name used as the display name.
                //mail.setSenderDisplayName('Allied Telesis Salesforce Support');
                
                // Specify the subject line for your email address.
                //mail.setSubject('New Case Created : ' );
                
                // Set to True if you want to BCC yourself on the email.
                //mail.setBccSender(false);
                
                // Optionally append the salesforce.com email signature to the email.
                // The email address of the user executing the Apex Code will be used.
               // mail.setUseSignature(false);
                
                // Specify the text content of the email.
               // mail.setPlainTextBody('Your Case could not been created.');
                
               // mail.setHtmlBody('Your case has been created.<p>'+
                //     'To view your case <a href=https://c.cs18.visual.force.com/apex/SFSupportHome>click here.</a>');
                
                // Send the email you have created.
             //   Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                
                 Newcase.addError('New SF support case is not allowed from email.' ); 
            }
        }
    
    }
   
   
    
   /* if (Trigger.isupdate) 
   {
     for(case Newcase: trigger.new)
     {
        if(Newcase.Copied_to_CMT__c == true)
        {
             Newcase.addError(' This Enhancement request/case has already been copied to CMT. No modifictions are now allowed on this case. Please use CMT to make changes to this request/case.' );
        }
     }
   }
  List<Milestone1_Project__c> AllCMT_Enhancements =  new List<Milestone1_Project__c>(); 
   for(case Newcase: trigger.new)
     {
         //Case  OldValues  = System.Trigger.oldMap.get(Newcase.Id);
        if(Newcase.Recordtypeid == SF_EnhancementID)
        {
            if(Newcase.Copied_to_CMT__c == false)
            {
               if((Newcase.Copy_to_CMT__c == true) && (Newcase.Status == 'Closed'))
               {
                 Milestone1_Project__c CMT_Enhancement =  new Milestone1_Project__c();
                 
                 CMT_Enhancement.Name = Newcase.Enhancement_Title__c;
                 CMT_Enhancement.Requestor_Name__c  =  Newcase.Requestor_Name__c;
                 CMT_Enhancement.Description__c =   Newcase.Description;
                 CMT_Enhancement.Business_Process__c = Newcase.BusinessProcessesEffected__c;
                 CMT_Enhancement.Explain_Legal_Requirements__c =  Newcase.Explain_legal_requirement__c;
                 CMT_Enhancement.Expected_Benefit__c = Newcase.Expected_Benefits_to_Allied_Telesis__c;
                 CMT_Enhancement.Additional_Comments__c = Newcase.Additional_Comments__c;
                 CMT_Enhancement.Estimated_Cost_Reduction__c = Newcase.estimatedCostReduction__c;
                 CMT_Enhancement.Estimated_Sales_Improvement__c = Newcase.estimatedRevenueImprovements__c;
                 CMT_Enhancement.Explain_cost_Reduction__c = Newcase.Explain_cost_Reduction__c;
                 CMT_Enhancement.Explain_Revenue_Improvements__c = Newcase.Explain_revenue_improvements__c;
                 CMT_Enhancement.Department__c = Newcase.Department__c;
                 CMT_Enhancement.Regions_Affected__c = Newcase.Region__c;
                 CMT_Enhancement.Processes_to_be_effected_by_change__c = Newcase.Processes_roles_to_be_effected_by_change__c;
                 CMT_Enhancement.Resource_Requirements__c = Newcase.Resource_Requirements__c;
                 CMT_Enhancement.Scope_of_Change__c = Newcase.Scope_of_Change__c;
                 CMT_Enhancement.Technical_components_of_change__c = Newcase.Technical_components_of_change__c;
                 CMT_Enhancement.Technical_impact_of_change__c = Newcase.Technical_impact_of_change__c;
                 CMT_Enhancement.Developers_person_hours__c = Newcase.Developers_person_hours__c;                      
                 CMT_Enhancement.Outsourced_Consultant_Cost__c = Newcase.Outsourced_Consultant_Cost__c;
                 CMT_Enhancement.Project_Manager_person_hours__c = Newcase.Project_Manager_person_hours__c;
                 CMT_Enhancement.Professional_Services_Cost__c = Newcase.Professional_Services_Cost__c;                         
                 CMT_Enhancement.Service_and_Support_Staff_person_hours__c = Newcase.Service_and_Support_Staff_person_hours__c;
                 CMT_Enhancement.Total_estimated_capitol_cost__c = Newcase.Total_estimated_capitol_cost__c;                             
                 CMT_Enhancement.Capitol_cost_details__c = Newcase.Capitol_cost_details__c;                            
                 CMT_Enhancement.Total_estimated_expense_cost__c = Newcase.Total_estimated_expense_cost__c;                             
                 CMT_Enhancement.Expense_cost_details__c = Newcase.Expense_cost_details__c; 
                 CMT_Enhancement.Explain_effected_Business_Processes__c = Newcase.Explain_effected_Business_Processes__c;
                 CMT_Enhancement.Explain_effected_Processes_Roles__c = Newcase.Explain_effected_Processes__c;
                                          
                 CMT_Enhancement.Priority__c = Newcase.Priority;
                 CMT_Enhancement.ownerid = Newcase.ownerid;
                 Newcase.Resolution_Code__c = 'Moved to CMT';
                 
                 Newcase.caseResolution__c= 'Your enhancement request has been copied into the Global Change Management system and is now closed in the SF Support system.  Please refer to this Global Change Management project name when communicating about your request: "'+ Newcase.Enhancement_Title__c
                  
                 + '".\r\n\nThese requests are evaluated and scheduled for formal review on a minimum of a quarterly basis.  You may be contacted with a request for additional information before the formal review meeting.  If the request included a justification for an expedited solution, the Global Team will consider this in their assessment of each request.\r\n\n'
                 + 'A team member will update you before the next review meeting.';

                 
                                
                  
                  AllCMT_Enhancements.add(CMT_Enhancement);
                  
                  Newcase.Copied_to_CMT__c = true;
                }
             } 
             else
             {
                 Newcase.addError(' This Enhancement request has already been copied to CMT. No modifictions are now allowed on this case. Please use CMT to make changes to this request.' );
             }
               
        }
        
        
       /*  system.debug('::new SF case record type' + Newcase.Recordtypeid + 'SF_CaseID ' + SF_CaseID + 'SF_EnhancementID '+ SF_EnhancementID + 'Newcase.Recordtypeid:' + Newcase.Recordtypeid);
        if(Newcase.Recordtypeid == SF_CaseID || Newcase.Recordtypeid == SF_EnhancementID )
        {
        
        system.debug('::caseSubject' + Newcase.Subject);
         if(Newcase.Subject!= null)
             caseSubject = Newcase.Subject;
         
         if(caseSubject!='' )
         {
             if(!(caseSubject.contains(NewHireSubject) || caseSubject.contains(LeaverSubject )) )
             {
                 Newcase.addError('New SF support case is allowed only for new hire or leaver' ); 
             }
             else
             {
                 Newcase.Request_Title__c = Newcase.Subject;
             }
         }
        }*/
     //} 
     
    // insert AllCMT_Enhancements;    
     
     //}*/
        
}