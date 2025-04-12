@isTest
public without sharing class ATFE_TestMethodUtility {
    
    private static Integer counter = 1;
    private static Schema.DescribeSObjectResult accountDescribe = Schema.SObjectType.Account; 
    private static Map<String,Schema.RecordTypeInfo> acctRtMapByName = accountDescribe.getRecordTypeInfosByName();
    
    private static Schema.DescribeSObjectResult opptyDescribe = Schema.SObjectType.Opportunity; 
    private static Map<String,Schema.RecordTypeInfo> opptyRtMapByName = opptyDescribe.getRecordTypeInfosByName();
    
    private static Schema.DescribeSObjectResult caseDescribe = Schema.SObjectType.Case; 
    private static Map<String,Schema.RecordTypeInfo> caseRtMapByName = caseDescribe.getRecordTypeInfosByName();
    
    private static Schema.DescribeSObjectResult quoteDescribe = Schema.SObjectType.Quote; 
    private static Map<String,Schema.RecordTypeInfo> quoteRtMapByName = quoteDescribe.getRecordTypeInfosByName();
    
    public static User getTestUserWithProfileAndRole(String pProfile, String pRole){
        String nowString = System.Now().format().trim().replace(' ', '').replace('-', '').replace(':', '').replace(',','');
        
        Profile p = [SELECT Id FROM Profile WHERE Name = :pProfile];
        UserRole r = [SELECT Id FROM UserRole WHERE Name = :pRole];
          
        User u = new User(Alias = 'test3687', 
                          Email = 'standarduser@testorg.com', 
                          EmailEncodingKey = 'UTF-8', 
                          LastName = 'Testing', 
                          LanguageLocaleKey = 'en_US', 
                          LocaleSidKey = 'en_US', 
                          ProfileId = p.Id, 
                          UserRoleId = r.Id,
                          TimeZoneSidKey = 'America/Los_Angeles', 
                          UserName = nowString + counter + 'teston@testcorp.net',
                          Price_Book_Region__c = 'NA');     
        counter++;
        
        return u;
    }
    
    public static Account getTestAccountWithRecordType(String pRecordTypeName) {
        Id rtId =  acctRtMapByName.get(pRecordTypeName).getRecordTypeId();
        
        return new Account (Name = 'TestAccount',
                            BillingCountry='United States',
                            BillingCity='TestCity',
                            BillingStreet='TestStreet',
                            BillingState='CA',
                            Billingpostalcode='123456',
                            ATFE_AccountType__c ='End Customer', 
                            RecordTypeId = rtId,
                            Region__c = 'NA',
                            Sub_Region__c = 'NA',
                            ATFE_SalesOrgName__c = 'NSP');
    }
    
    public static Opportunity getTestOpportunityWithRecordType(String pRecordTypeName) {
        Id rtId =  opptyRtMapByName.get(pRecordTypeName).getRecordTypeId();
        
        return new Opportunity (Name ='TestOpp',
                                RecordTypeId = rtId, 
                                StageName ='Prospect/Qualification',Required_Delivery_Date__c=System.today().addDays(3),
                                //Probability = 0.25,
                                CloseDate = System.today().addDays(2));
    }
    
    public static Case getTestCaseWithRecordType(String pRecordTypeName) {
        Id rtId =  caseRtMapByName.get(pRecordTypeName).getRecordTypeId();
        
        return new Case(RecordTypeId = rtId,
                        Status = 'New');
    }
    
    public static Quote getQuoteWithRecordType(String pRecordTypeName) {
        Id rtId =  quoteRtMapByName.get(pRecordTypeName).getRecordTypeId();
        
        return new Quote(RecordTypeId = rtId,
                         Name = 'test quote');  
    }
}