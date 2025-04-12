public class NewCommentCustom {
    public Comment__c NewComment {get;set;}
    public List<string> Selected_emails{get;set;}
    public List<string> Selected_attachments{get;set;}
    private string To_emails;
    string reference;
    ApexPages.StandardController CommntController; 
    
     map<id,Attachment> AttachMap = new map<id,Attachment>();
     
     
    
    public NewCommentCustom(ApexPages.StandardController controller) {
       CommntController = controller;
        
        NewComment =  (Comment__c)controller.getRecord();
        
        NewComment.Recipient_Email__c = null;
        if(NewComment.Related_Case__c == null && NewComment.Related_Project__c != null)
        {
            Milestone1_Project__c RelProject = [Select id,Name,Related_Case__c from Milestone1_Project__c where id = :NewComment.Related_Project__c];
            NewComment.Related_Case__c =  RelProject.Related_Case__c;
        }
        
        if(NewComment.Related_Case__c != null && NewComment.Related_Project__c == null)
        {
            Case RelCase = [Select id,Related_CMT_Project__c from Case where id = :NewComment.Related_Case__c ];
            NewComment.Related_Project__c =  RelCase.Related_CMT_Project__c;
        }
        
        
         
    }
    
       /*public List<SelectOption> getUsers() {
            List<User> AllUsers = [select id,Name,email from user where isactive = true and profileid != '00ew0000001A35x' / order by Name ASC]; // hardcoding for now
            List<SelectOption> options = new List<SelectOption>();
            for(user usr : AllUsers )
            {
                options.add(new SelectOption(usr.email,usr.Name));
            }
            return options;
        }
        
        public List<SelectOption> getAttachmnts() {
        
            List<Attachment > AllAttachPrjct = [SELECT id,Body,BodyLength,Name,parentid,ContentType FROM Attachment where parentid = :NewComment.Related_Project__c order by Name ASC];
             List<Attachment > AllAttachCase = [SELECT id,Body,BodyLength,Name,parentid,ContentType FROM Attachment where parentid = :NewComment.Related_Case__c order by Name ASC];
            //  " [ref:_" + LEFT($Organization.Id, 5) + MID($Organization.Id, 12, 4) +"._" + LEFT( Related_Case__r.Id , 5) + MID(Related_Case__r.Id, 11, 5) + ":ref ]"
            String orgId = UserInfo.getOrganizationId();
            String RelCasId = NewComment.Related_Case__c;
            reference = ' [ ref:_'+ (orgId.substring(0, 5)) + (orgId.substring(11, 15)) + '._' + (RelCasId .substring(0, 5)) + (RelCasId.substring(10, 15)) + ':ref ]';
            List<SelectOption> options = new List<SelectOption>();
            for(Attachment atch : AllAttachPrjct )
            {
                options.add(new SelectOption(atch.id,'Project File: '+ atch.Name));
                AttachMap.put(atch.id,atch);
            }
            for(Attachment atch : AllAttachCase )
            {
                options.add(new SelectOption(atch.id,'Case File: '+ atch.Name));
                AttachMap.put(atch.id,atch);
            }
            return options;
        } 
   
   
   
   
   
   
   
   
        public PageReference emailSave() {
        
        if(Selected_emails.size()>0){
            List<Messaging.Emailfileattachment> efaList = new List<Messaging.Emailfileattachment>();
            
            for(string email : Selected_emails)
            {
                if(NewComment.Recipient_Email__c == null)            
                  NewComment.Recipient_Email__c = email ;
                else
                  NewComment.Recipient_Email__c = NewComment.Recipient_Email__c + ','+email ;
            
            }
            // First, reserve email capacity for the current Apex transaction to ensure
                                    
            // that we won't exceed our daily email limits when sending email after
                                    
            // the current transaction is committed.
            Messaging.reserveSingleEmailCapacity(2);
            
            // Processes and actions involved in the Apex transaction occur next,
            // which conclude with sending a single email.
            
            // Now create a new single email message object
            // that will send out a single email to the addresses in the To, CC & BCC list.
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            system.debug('Selected Emails are::' + Selected_emails);
            // Strings to hold the email addresses to which you are sending the email.
            String[] toAddresses = Selected_emails; 
            //String[] fromAddresses = new String[] {'salesforcesupport-test@alliedtelesis.com'};
              
            
            // Assign the addresses for the To and CC lists to the mail object.
            mail.setToAddresses(toAddresses);
            //mail.setFromAddresses(toAddresses);
           // mail.setCcAddresses(ccAddresses);
            
            // Specify the address used when the recipients reply to the email. 
            mail.setReplyTo('salesforcesupport-test@alliedtelesis.com');
            
            // Specify the name used as the display name.
            mail.setSenderDisplayName('Salesforce Support');
            
            // Specify the subject line for your email address.
            mail.setSubject('New Comment.' + reference );
            
            // Set to True if you want to BCC yourself on the email.
            mail.setBccSender(true);
            
            // Optionally append the salesforce.com email signature to the email.
            // The email address of the user executing the Apex Code will be used.
            mail.setUseSignature(false);
            
            mail.whatId = NewComment.Related_Case__c;
            // Specify the text content of the email.
            mail.setPlainTextBody(NewComment.Comment__c);
            
            mail.setHtmlBody(NewComment.Comment__c);
            
            // Create the email attachment
             system.debug('Selected_attachments' + Selected_attachments);
            for(string Attachid : Selected_attachments){
                
                system.debug('Attachment id' + Attachid );
                Attachment attach = AttachMap.get(Attachid);
           
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName(attach.Name);
                efa.setBody(attach.body);
                efa.setContentType(attach.ContentType);
                efaList.add( efa );
               // mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
                
            }
            if(efaList.size()>0)
                mail.setFileAttachments(efaList );
            // Send the email you have created.
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        return CommntController.save();
       // return new PageReference('/' + NewComment.id);
    }*/
}