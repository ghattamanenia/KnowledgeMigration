@isTest
public class EmailMessageTriggerHandlerTest
{
    public static testmethod void tesmm()
    {
        //Insert test case record
        Case c = new Case();
        c.Subject = 'Om Test';  
        
        c.Status ='New';
        c.Priority = 'Medium';
        c.Origin = 'Email';
        insert c;

        //Insert emailmessage for case
        EmailMessage email = new EmailMessage();
        email.FromAddress = 'test@abc.org';
        email.Incoming = True;
        email.ToAddress= 'test@xyz.org';
        email.Subject = 'Test email';
        email.textbody = 'Account Name: Allied Telesis;;Contact Name: Paul Priber;;Contact E-Mail: paul_priber@alliedtelesis.com;;Case Origin: Net.Monitor;;Customer Title: hg_customer_b: host_img2524h_10.52.140.251 - Unavailable by ICMP ping;;Description: The Net.Monitor Service has detected the following fault on your network:- host_img2524h_10.52.140.251- Unavailable by ICMP pingA support engineer is investigating and working to recover the deviceservice that is impacted. This case will be updated once new information is available. Regards, Paul Priber;;Customer Impact: High;;Customer Urgency: High;;New or Existing Installation: Existing;;Status: New;;Priority: P2;;Case Manager: Alasdair McGregor;;Case Manager E-Mail: alasdair_mcgregor@alliedtelesis.com;;Case Owner: L1 NA;;External Ticket #: 1968;;';
email.ParentId = c.Id; 
        insert email;
    }
}