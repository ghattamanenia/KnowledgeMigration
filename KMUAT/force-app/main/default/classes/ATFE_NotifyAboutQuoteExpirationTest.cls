@isTest (seeAllData=true)
public class ATFE_NotifyAboutQuoteExpirationTest
{
    public static testmethod void testm()
    {
      /*  Quote q = new Quote();
        Schema.DescribeSObjectResult quoteDescribe = Schema.SObjectType.Quote; 
      Map<String,Schema.RecordTypeInfo> quoteRtMapByName = quoteDescribe.getRecordTypeInfosByName();
         Id quoteAfterRTId =  quoteRtMapByName.get('ATFE_Quote After Approval').getRecordTypeId();
        
        q=[SELECT Name,Opportunity.Name,ATFE_Send_14_Day_Expiration_Notice__c, ATFE_Send_7_Day_Expiration_Notice__c, ExpirationDate, RecordTypeId 
                  FROM Quote WHERE RecordTypeId = :quoteAfterRTId limit 1];
        Quote q1 = new Quote();
        q1=q.clone(false,false,false,false);
        q1.ExpirationDate=system.today()+14;
        Insert q1;
        
        Quote q2 = new Quote();
        q2=q1.clone(false,false,false,false);
        q2.ExpirationDate=system.today()+7;
        insert q2;
        
        ATFE_NotifyAboutQuoteExpiration anaq = new ATFE_NotifyAboutQuoteExpiration();
        anaq.execute(null);   */
        
    }
}