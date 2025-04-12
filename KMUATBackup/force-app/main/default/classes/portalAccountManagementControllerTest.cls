@isTest
public class portalAccountManagementControllerTest{

    @isTest
    static void portalAccountManagement()
    {
        Account acc = DataSetupUtility.createTestAccount('Test Account 2000');
        Contact con= DataSetupUtility.createTestContact(acc,'testfirstname','testlastname','email600@gmail.com',true);
        con.Service_Portal_User_Activated__c=true;
        update con;
        
        Contact con2= DataSetupUtility.createTestContact(acc,'','testlastname','',true);
        con2.Service_Portal_User_Activated__c=true;
        try{
        update con2; } catch(exception e){}
        
        Contact con3= DataSetupUtility.createTestContact(acc,'testfirstname300','testlastname300','email2307@gmail.com',true);
        Schema.DescribeSObjectResult describeResult = Case.SObjectType.getDescribe(); 
		Map<String, Schema.RecordTypeInfo> recordTypeInfos = describeResult.getRecordTypeInfosByDeveloperName(); 
		Id recTypeId = recordTypeInfos.get('ATI_Community_Registration').getRecordTypeId(); 

        List<Case> cs=new List<Case>();
        cs.add(new Case(RecordTypeId=recTypeId,User_Time_Zone__c='Asia/Tokyo',ContactId=con3.Id,accountId=acc.Id,User_Accepted__c='Yes',Status='New',Origin='Portal',Description='Please accept',Company_Name__c='Gentle',First_Name__c='Test FName',Last_Name__c='Test LName',Email__c='test300@mgail.com'));
        insert cs;
        cs[0].Status='Closed';
        update cs[0];
        
    }
    
}