public class QuoteExpirationNotificationBatchHelper 
{
    static string emailbody ='Dear User, \n Below is(are) the Quotes expiring in next one week.\n';
    
    public static void sendNotification(Map<Id,list<SBQQ__Quote__c>> OwnerIdQuoteList,Map<id,string> QuoteOwnerIdEmail)
    {
        system.debug('@@@@@OwnerIdQuoteList in helper'+OwnerIdQuoteList);
        
        list<OrgWideEmailAddress> outGoingFromEmail= new list<OrgWideEmailAddress>();
        outGoingFromEmail=[SELECT Id, Address, DisplayName FROM OrgWideEmailAddress where DisplayName='SF Support'];
        
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>();
        string Instance=URL.getOrgDomainUrl().toExternalForm();
        for(Id uId: QuoteOwnerIdEmail.keyset())
        {
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            //emailbody='';
        
           emailbody ='Dear User, \n Below is(are) the Quotes expiring in next one week.\n';
            list<string> toEmails = new List<String>();
            string str=QuoteOwnerIdEmail.get(UId);
            toEmails.add(str);
            for(SBQQ__Quote__c q:OwnerIdQuoteList.get(Uid))
            {
               system.debug('@@@@q.Id'+q.Id);
               system.debug('@@@@@OwnerIdQuoteList.get(q.OwnerId)'+OwnerIdQuoteList.get(q.OwnerId));
               emailbody= '\n'+emailbody +'\n' + Instance+'/'+q.Id+'   Quote Name-->'+q.Name;
            }
            message.toAddresses = toEmails;
            message.optOutPolicy = 'FILTER';
            message.subject = 'Quote Exipiring Notice';
            message.plainTextBody = emailbody;
            message.setOrgWideEmailAddressId(outGoingFromEmail[0].Id);
            messages.add(message);
         }
            
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            if (results[0].success) 
            {
                System.debug('The email was sent successfully.');
            } 
            else 
            {
                System.debug('The email failed to send: '+ results[0].errors[0].message);
            }
            
        }
}