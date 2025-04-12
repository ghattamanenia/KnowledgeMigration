@isTest(SeeAllData=true)
public class test_ContentversionTigger
{
    static testMethod void test1()
    {
         Test.Starttest();
    ContentVersion CV = [SELECT id FROM ContentVersion  limit 1];
            update CV;
          Test.Stoptest();
    }        
}