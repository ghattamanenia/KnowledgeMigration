trigger updateFirstResponse on Case_Comment__c (before insert,after insert,before update) {  
if(Trigger.isbefore)
{
 List<Case_Comment__c> lstCmnt= new List<Case_Comment__c>();
 List<CaseMilestone> cmsToUpdate= new List<CaseMilestone> ();
 List<CaseMilestone> cmsToUpdate1= new List<CaseMilestone> ();
 List<CaseMilestone> cmsToUpdate2= new List<CaseMilestone> ();
  List<CaseMilestone> cmsToUpdate3= new List<CaseMilestone> ();
 List<Case> lstCase = new  List<Case>();
 boolean responseFlag= false;
  List<Case_Comment__c> lstCmt= new List<Case_Comment__c>();
 List<Id> lstCaseId=new List<Id>();

 
 for(Case_Comment__c caseCmnt: trigger.new)
 {
     system.debug('tirgger.oldmap'+Trigger.oldMap);
         //if(casecmnt.First_Public_Comment__c==true && casecmnt.Comment_Type__c !='Customer Comment' && casecmnt.Comment_Type__c !='Inbound Email')
         boolean isChanged = false;
         if(casecmnt.First_Public_Comment__c==true)
         {         
             if(Trigger.oldMap != null && (casecmnt.First_Public_Comment__c !=Trigger.oldMap.get(casecmnt.ID).First_Public_Comment__c || casecmnt.Comment_Type__c !=Trigger.oldMap.get(casecmnt.ID).Comment_Type__c))
             {
                 isChanged = true;
             }
             if(Trigger.oldMap == null)
             {
                 isChanged = true;   
             }
         }
         if(isChanged && casecmnt.Comment_Type__c !='Customer Comment' && casecmnt.Comment_Type__c !='Inbound Email'){
             lstCmnt.add(caseCmnt);
             if(caseCmnt.case__r.recordtypeId != '012m00000008TXc')
                lstCaseId.add(caseCmnt.case__c);
                
             }
     
     }
     
 if(lstCmnt.size()>0 && lstCaseId.size()>0)
   {
   // cmsToUpdate = [select Id, completionDate,TargetDate,CaseId from CaseMilestone cm where caseId In: lstCaseId  and cm.MilestoneType.Name= 'First response' and completionDate = null limit 1];
     cmsToUpdate = [select Id, completionDate,TargetDate,CaseId from CaseMilestone cm where caseId In: lstCaseId  and cm.MilestoneType.Name= 'First response' and completionDate = null limit 1];    
    if (cmsToUpdate.isEmpty() == false){
        for (CaseMilestone cm : cmsToUpdate){
            cm.completionDate = system.now();
            BusinessHour.skipCaseComment = true;
            cmsToUpdate1.add(cm);
            
            }
    responseFlag= true;
    if(cmsToUpdate1.size()>0)
        update cmsToUpdate1;
        }
        //List<CaseMilestone> cmlist = [select id from CaseMilestone cm where caseId In: lstCaseId  and cm.MilestoneType.Name= 'First response' and completionDate != null limit 1]; 
     cmsToUpdate2 = [select Id, completionDate,TargetDate,startdate, CaseId from CaseMilestone cm where caseId In: lstCaseId  and cm.MilestoneType.Name= 'Response' and completionDate = null limit 1];
        //cmsToUpdate2 = [select Id, completionDate,TargetDate,startdate, CaseId from CaseMilestone cm where caseId In: lstCaseId  and cm.MilestoneType.Name= 'Response' and completionDate != null limit 1];     
    if (cmsToUpdate2.isEmpty() == false && responseFlag==false){
        for (CaseMilestone cm : cmsToUpdate2){
        system.debug('****cm.StartDate***'+cm.StartDate);
        system.debug('****System.now()***'+System.now());
        
            if(cm.StartDate < System.now()){
                cm.completionDate = system.now();
                cmsToUpdate3.add(cm);
                
            }   
        }
        if(cmsToUpdate3.size()>0)
            update cmsToUpdate3;
            
        }
        
    if( cmsToUpdate1.size()>0){
    for(case c : [select id,status from case where id In : lstCaseId  ]){
        if(c.status=='New')
            {
            BusinessHour.skipCaseComment = true;
            for(CaseMilestone cms : cmsToUpdate1){
            //c.status='Open';
               c.First_Response_Met__c = true;
            c.sla_met__c=true;
            //for lapse time
           c.First_Response__c = cms.completionDate;
            //c.First_Response__c=system.now();
            if(cmsToUpdate2.isEmpty() == false && cms.CaseId==c.Id){
               // c.Next_Response_Due_Date__c=cms.TargetDate;
                }
            lstCase.add(c);
            }
            }    
        }
    if(lstCase.size()>0)    
        update lstCase;  
    }   
     
    }     
   
}
if(Trigger.isAfter)
{
   
    List<Feeditem> casefeedlist = new List<Feeditem>();
    string publicStatus;// = new string(); 
    for(Case_Comment__c caseCmnt: trigger.new)
    {
       if(caseCmnt.Public__c == true)
            publicStatus = 'yes';
       else
            publicStatus = 'No';
       Feeditem newfeed = new Feeditem();
      newfeed.Body = 'Case Comment:\n' + 'Public: ' + publicStatus + '\n' + caseCmnt.Comment__c;
       //newfeed.CreatedById = caseCmnt.CreatedById;
       newfeed.LinkUrl = '/' + caseCmnt.id;
       newfeed.title = 'Case Comment Link';
       //newfeed.InsertedById = caseCmnt.CreatedBy;
       newfeed.ParentId = caseCmnt.case__c;
       casefeedlist.add(newfeed);
      // Visibility = 
    }  
      try 
      {
            insert casefeedlist;
      }
      catch(exception e)
      {
          system.debug('Exception occured while creating feed from case comment: ' + e);
      } 
     
}
}