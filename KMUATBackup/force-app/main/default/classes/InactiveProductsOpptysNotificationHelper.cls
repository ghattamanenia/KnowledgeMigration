public class InactiveProductsOpptysNotificationHelper
{
    static string emailbody ='Dear User, \n Below is(are) the opportunities that have products that are announced EOS.\n';
    
    public static void sendNotification(Map<Id,list<Opportunity>> OwnerIdOpptyMap,Map<id,string> OppIdInactivePrdNames)
    {
        system.debug('@@@@@OppIdInactivePrdNames in helper'+OppIdInactivePrdNames);
        
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>();
        string Instance=URL.getOrgDomainUrl().toExternalForm();
        
        list<OrgWideEmailAddress> outGoingFromEmail= new list<OrgWideEmailAddress>();
        outGoingFromEmail=[SELECT Id, Address, DisplayName FROM OrgWideEmailAddress where DisplayName='SF Support'];
 
        list<string> ccEmails = new list<string>();
        for(string ccemail:label.EOS_CC_Emails.split(';'))
        {
             ccEmails.add(ccemail);
         }
         
        for(Id uId: OwnerIdOpptyMap.keyset())
        {
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            //emailbody='';
        
           emailbody ='Dear User, \n Below is(are) the opportunities that have products that are announced EOS.\n';
            list<string> toEmails = new List<String>();
            
            string str=OwnerIdOpptyMap.get(UId)[0].Owner.Email;
            toEmails.add(str);
            for(Opportunity o:OwnerIdOpptyMap.get(Uid))
            {
               system.debug('@@@@o.Id'+o.Id);
               system.debug('@@@@@OppIdInactivePrdNames.get(o.Id)'+OppIdInactivePrdNames.get(o.Id));
               emailbody= '\n'+emailbody +'\n' + Instance+'/'+o.Id+'   EOS Product Names-->'+OppIdInactivePrdNames.get(o.Id);
            }
            message.toAddresses = toEmails;
            if(OwnerIdOpptyMap.get(uId)[0].Account_Region__c=='NA' || OwnerIdOpptyMap.get(uId)[0].Account_Region__c=='CSA' )
            message.ccAddresses=ccEmails;
            message.optOutPolicy = 'FILTER';
            message.subject = 'Product EOS Notice';
            emailbody=emailbody+'\n \n Please contact your local customer support team Or PLM/GPM \n'+ '\n -Media Coverter/Fiber Optics/Network Interface Card/iMG : Doug Barga and his team. \n';
            emailbody=emailbody+'\n -Switch, Router, Wireless, : Dobe and his team.\n'+'\n -Industrial Switch(except "L" series) : Graham Walker and Luca Sinigaglia. \n';
            emailbody=emailbody+'\n For EMEA Services contact: Pero Koruga. \n'+'\n For NA Services contact: Alasdair McGregor. \n';
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