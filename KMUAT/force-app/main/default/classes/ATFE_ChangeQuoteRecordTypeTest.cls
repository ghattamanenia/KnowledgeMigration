@isTest(seeAllData=true)
public class ATFE_ChangeQuoteRecordTypeTest
{
    public static testmethod void testm()
    {
         list<Quote> qus = new List<Quote>();
         Schema.DescribeSObjectResult quoteDescribe = Schema.SObjectType.Quote; 
         Map<String,Schema.RecordTypeInfo> quoteRtMapByName = quoteDescribe.getRecordTypeInfosByName();
         Id quoteAfterRTId =  quoteRtMapByName.get('ATFE_Quote After Approval').getRecordTypeId();
         Id quoteBeforeRTId =  quoteRtMapByName.get('ATFE_Quote Before Approval').getRecordTypeId();
        /*
        for(Quote q:[SELECT ExpirationDate, RecordTypeId FROM Quote where RecordTypeId=:quoteAfterRTId and ExpirationDate<=TODAY limit 4])
        {
            q.ExpirationDate=system.today()-2;
            qus.add(q);
            
        }
        update qus;
        */
        Test.starttest();
        ATFE_ChangeQuoteRecordType  m = new ATFE_ChangeQuoteRecordType ();
        ATFE_ChangeQuoteQuicklyRecordType mm = new ATFE_ChangeQuoteQuicklyRecordType ();
        String sch = '20 30 8 10 2 ?';
        //String jobID = system.schedule('Merge Job', sch, m);
        //String jobID1 = system.schedule('Merge Job1', sch, mm);
        Test.stopTest();
    }
    
}