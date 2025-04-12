public class EmailMessageTriggerHandler
{
    public static void netMonitorProcessing(Map<Id,EmailMessage> newEmailMsgMap)
    {
        system.debug('@@@@@newEmailMsgMap'+newEmailMsgMap);
        
        Map<Id,Case> CaseMap = new Map<Id,case>();
        
        set<String> AccNamesSet = new Set<String>();
        set<string> ConEmailSet = new Set<String>();
        set<string> MgrEmailSet = new Set<String>();
        
        list<case> casesToUpdate = new list<Case>();
        string AccName='Account Name:';
        string ConEmail='Contact E-Mail:';
        string caseorg='Case Origin:';
        string casstatus='Status:';
        string casemgr='Case Manager E-Mail:';
        string casepriority='Priority:';
        string externaltkt='External Ticket #:';
        string newexisting='New or Existing Installation:';
        string urgency='Customer Urgency:';
        string impact='Customer Impact:';
        string title='Customer Title:';
        string description='Description:';
        
        Map<string,Id> AccountNameAccIdMap = new Map<String,Id>();
        Map<String,Id> ContactEmailConIdMap = new Map<String,Id>();
        Map<string,Id> CaseMgrNameMgrIdMap = new Map<String,Id>();
        
        String AccountId='';
        string contactId='';
        string CaseOrigin='';
        string status='';
        string casemanager='';
        string priority='';
        string exttkt='';
        string newex='';
        string customerurg='';
        string customerimp='';
        string custtitle='';
        string descrp='';
        
        Set<Id> CasesToConsider = new set<Id>();
        set<Id> FirstTimeCaseIds = new set<Id>();
        
        for(EmailMessage emm:newEmailMsgMap.values())
        {
            if(emm.ParentId!=null)
            CasesToConsider.add(emm.ParentId);
        }
        
        for(case cs:[Select Id,(select Id from EmailMessages) from case where Id IN:CasesToConsider])
        {
            if(cs.EmailMessages.size()<=1)
            FirstTimeCaseIds.add(cs.Id);
        }
        
       
         for(EmailMessage em:newEmailMsgMap.values())
         {
            if(em.incoming==true && em.ParentId!=null)
            {
                
                for(string str:em.TextBody.split(';;'))
                {
                    system.debug('@@@Entering in to split method');
                    system.debug('@@@@@str'+str);
                    
                    if(str.Contains('Account Name:') && em.Parent.AccountId==null )
                    AccNamesSet.add(str.substring(str.indexof('Account Name')+AccName.length(),str.length()).trim());
                    
                    if(str.contains('Contact E-Mail:') && em.Parent.ContactId==null)
                    ConEmailSet.add(str.substring(str.indexof('Contact E-Mail')+ConEmail.length(),str.length()).trim());
                    
                    if(str.contains('Case Manager E-Mail:') && em.Parent.TAC_Enginer__c==null)
                    MgrEmailSet.add(str.substring(str.indexof('Case Manager E-Mail')+casemgr.length(),str.length()).trim());
                    
                    
                }
            }
            
          
         }
        
        
        system.debug('@@@@AccNamesSet'+AccNamesSet);
        system.debug('@@@@ConEmailSet'+ConEmailSet);
        system.debug('@@@@MgrEmailSet'+MgrEmailSet);
        
        
        
        
        for(Account acc:[Select Id,Name from Account where Name IN :AccNamesSet])
        {
            AccountNameAccIdMap.put(acc.Name,acc.Id);
        }
        
        System.debug('@@@@@AccountNameAccIdMap'+AccountNameAccIdMap);
        
        for(Contact con:[Select Id,Email from Contact where Email IN :ConEmailSet])
        {
            ContactEmailConIdMap.put(con.Email,con.Id);
        }
        
        System.debug('@@@@@ContactEmailConIdMap'+ContactEmailConIdMap);
        
        for(User us:[Select Id,Email from User where Email IN :MgrEmailSet])
        {
            CaseMgrNameMgrIdMap.put(us.Email,us.Id);
        }
        
        
        system.debug('@@@@CaseMgrNameMgrIdMap'+CaseMgrNameMgrIdMap);
        
        for(EmailMessage ema:newEmailMsgMap.values())
        {
            if(ema.incoming==true && ema.ParentId!=null)
            {
                for(string str:ema.TextBody.split(';;'))
                {
                    system.debug('@@@Entering in to split method');
                    system.debug('@@@@@str'+str);
                    
                    if(str.Contains('Account Name:') && ema.Parent.AccountId==null)
                    {
                        if(AccountNameAccIdMap.keyset().contains(str.substring(str.indexof('Account Name')+AccName.length(),str.length()).trim()))
                        AccountId=AccountNameAccIdMap.get(str.substring(str.indexof('Account Name')+AccName.length(),str.length()).trim());
                    }
                    
                    if(str.contains('Contact E-Mail:') && ema.Parent.ContactId==null)
                    {
                        if(ContactEmailConIdMap.keyset().contains(str.substring(str.indexof('Contact E-Mail')+ConEmail.length(),str.length()).trim()))
                        contactId=ContactEmailConIdMap.get(str.substring(str.indexof('Contact E-Mail')+ConEmail.length(),str.length()).trim());
                   
                    }
                    
                    if(str.contains('Case Origin:') && ema.Parent.origin==null)
                    {
                        CaseOrigin=str.substring(str.indexof('Case Origin')+caseorg.length(),str.length()).trim();
                   
                    }
                    
                    if(str.contains('Status:') && ema.Parent.status==null)
                    {
                       system.debug('@@@@str at status '+str);
                        system.debug('@@@@str second at status'+str.substring(str.indexof('Status')+casstatus.length(),str.length()).trim()); 
                        status=str.substring(str.indexof('Status')+casstatus.length(),str.length()).trim();
                   
                    }
                    
                    if(str.Contains('Case Manager E-Mail:') && ema.Parent.TAC_Enginer__c==null)
                    {
                        system.debug('@@@problem creator'+str.substring(str.indexof('Case Manager E-Mail')+casemgr.length(),str.length()).trim());
                        if(CaseMgrNameMgrIdMap.keyset().contains(str.substring(str.indexof('Case Manager E-Mail')+casemgr.length(),str.length()).trim()))
                        casemanager=CaseMgrNameMgrIdMap.get(str.substring(str.indexof('Case Manager E-Mail')+casemgr.length(),str.length()).trim());
                    }
                    
                    
                     if(str.contains('Priority:') && ema.Parent.priority==null)
                    {
                        system.debug('@@@@str at priority'+str);
                        system.debug('@@@@str second at priority'+str.substring(str.indexof('Priority')+casepriority.length(),str.length()).trim()); 
                        priority=str.substring(str.indexof('Priority')+casepriority.length(),str.length()).trim();
                   
                    }
                    
                    if(str.contains('External Ticket #:') && ema.Parent.External_Ticket__c==null)
                    {
                        exttkt=str.substring(str.indexof('External Ticket #')+externaltkt.length(),str.length()).trim();
                   
                    }
                    
                    if(str.contains('Customer Impact:') && ema.Parent.Impact__c==null)
                    {
                        customerimp=str.substring(str.indexof('Customer Impact')+impact.length(),str.length()).trim();
                   
                    }
                    
                    
                    if(str.contains('Customer Urgency:') && ema.Parent.urgency__c==null)
                    {
                        customerurg=str.substring(str.indexof('Customer Urgency')+urgency.length(),str.length()).trim();
                   
                    }
                    
                     if(str.contains('New or Existing Installation:') && ema.Parent.New_or_Existing_Installation__c==null)
                    {
                        newex=str.substring(str.indexof('New or Existing Installation')+newexisting.length(),str.length()).trim();
                   
                    }
                    
                    if(str.contains('Customer Title:') && ema.Parent.Request_Title__c==null)
                    {
                        system.debug('str for customer title'+str);
                        system.debug('custtitle'+custtitle);
                        custtitle=str.substring(str.indexof('Customer Title')+title.length(),str.length()).trim();
                        system.debug('@@@custtitle later'+custtitle);
                   
                    }
                    
                    if(str.contains('Description:'))
                    {
                        system.debug('str for description'+str);
                        system.debug('descrp'+descrp);
                        descrp=str.substring(str.indexof('Description')+description.length(),str.length()).trim();
                        system.debug('@@@descrp later'+descrp);
                   
                    }
                    
                    
                    
                    
                    
                }
                
                
                
                Case cs = new Case();
                system.debug('@@@AccountId--->'+AccountId);
                system.debug('@@@ContactId--->'+ContactId);
               
                if(FirstTimeCaseIds.contains(ema.parentId))
                {
                    cs.Id=ema.ParentId;
                    if(AccountId!='')
                    cs.AccountId=AccountId;
                    if(ContactId!='')
                    cs.ContactId=ContactId;
                    if(CaseOrigin!='')
                    cs.origin=CaseOrigin;
                    if(status!='')
                    cs.status=status;
                    if(casemanager!='')
                    cs.TAC_Enginer__c=casemanager;
                    if(priority!='')
                    cs.priority=priority;
                    if(exttkt!='')
                    cs.External_Ticket__c=exttkt;
                    if(customerimp!='')
                    cs.Impact__c=customerimp;
                    if(customerurg!='')
                    cs.urgency__c=customerurg;
                    if(newex!='')
                    cs.New_or_Existing_Installation__c=newex;
                    if(custtitle!='')
                    cs.Request_Title__c=custtitle;
                    if(descrp!='')
                    cs.description=descrp;
                    cs.Is_Net_Monitor_Case__c=true;
                    casesToUpdate.add(cs);
                
                }
            
          
            }
        }   
        
        system.debug('@@@@@casesToUpdate'+casesToUpdate);
        
        if(!casesToUpdate.isempty())
        {
            system.debug('@@@entering into caseupdate final');
            update casesToUpdate;
        }
        
        // Below logic is to send an email to the queue (case owner) when the new case gets created.
        /*
        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
        OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress limit 1];
        EmailTemplate templateId = [Select id,Name,HtmlValue from EmailTemplate where name = 'Notifications to L1 & L2Queue'];
        
        list<string> toAddresseslst = new list<string>();
        
        for(GroupMember gm:[SELECT Id, GroupId, UserOrGroupId FROM GroupMember where GroupId IN (Select Id from Group where type='Queue' and Name='L1 NA')])
            {
                
                toAddresseslst.add(gm.UserOrGroupId);
            }
        
        system.debug('@@@@FirstTimeCaseIds at the end'+FirstTimeCaseIds);
        
         Map<Id,Case> CasesMap = new Map<Id,case>([Select id,caseNumber,Owner.Name,Request_Title__c,Description,createddate,Account.Id,Account.Name,ContactId,Contact.name,Hw_Asset_Name__c,Service_Contract__c from case where Id IN :FirstTimeCaseIds]);
        system.debug('@@@@@CasesMap '+CasesMap);
        for(case c:casesToUpdate)
        {
            String htmlBody = templateId.HtmlValue;
            system.debug('@@@@@htmlBody '+htmlBody);
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            // message.setWhatId(c.Id);
            
            message.toAddresses = toAddresseslst;
            message.setTemplateID(templateId.Id);
            message.setTargetObjectId(Userinfo.getUserId());
            message.setSaveAsActivity(false);
            message.setOrgWideEmailAddressId(owa.id);
            system.debug('@@@@@CasesMap.get(c.id).caseNumber'+CasesMap.get(c.id).caseNumber);
            
            htmlBody = htmlBody.replace('{!Case.CaseNumber}', CasesMap.get(c.id).caseNumber);
            
            htmlBody = htmlBody.replace('{!Case.CreatedDate}', string.valueof(CasesMap.get(c.id).createddate));
            
            if(CasesMap.get(c.id).Account.Name!=null)
            htmlBody = htmlBody.replace('{!Case.Account}',CasesMap.get(c.id).Account.Name);
            else
            htmlBody = htmlBody.replace('{!Case.Account}','');
            
            if(CasesMap.get(c.id).Contact.Name!=null)
            htmlBody = htmlBody.replace('{!Case.Contact}',CasesMap.get(c.id).Contact.Name);
            else
            htmlBody = htmlBody.replace('{!Case.Contact}','');
            
            if(CasesMap.get(c.id).Hw_Asset_Name__c!=null)
            htmlBody = htmlBody.replace('{!Case.Hw_Asset_Name__c}',CasesMap.get(c.id).Hw_Asset_Name__c);
            else
            htmlBody = htmlBody.replace('{!Case.Hw_Asset_Name__c}','');
            
            if(CasesMap.get(c.id).Service_Contract__c!=null)
            htmlBody = htmlBody.replace('{!Case.Service_Contract__c}',CasesMap.get(c.id).Service_Contract__c);
            else
            htmlBody = htmlBody.replace('{!Case.Service_Contract__c}','');
            
            if(CasesMap.get(c.id).Request_Title__c!=null)
            htmlBody = htmlBody.replace('{!Case.Request_Title__c}',CasesMap.get(c.id).Request_Title__c);
            else
            htmlBody = htmlBody.replace('{!Case.Request_Title__c}','');
            
            if(CasesMap.get(c.id).Description!=null)
            htmlBody = htmlBody.replace('{!Case.Description}',CasesMap.get(c.id).Description);
            else
            htmlBody = htmlBody.replace('{!Case.Description}','');
            
            if(CasesMap.get(c.id).Owner.Name!=null)
            htmlBody = htmlBody.replace('{!Case.OwnerFullName}',CasesMap.get(c.id).Owner.Name);
            else
            htmlBody = htmlBody.replace('{!Case.OwnerFullName}','');
            system.debug('@@@@htmlBody'+htmlBody );
            message.setHtmlBody(htmlBody);

            messages.add(message);
            
        }
        
        system.debug('@@@@messages'+messages);
        try
        {
        Messaging.sendEmail(messages,false);
        }catch(exception e){}
       */ 
    }
}