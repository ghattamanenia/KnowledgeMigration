@isTest(seealldata = true)
private class Test_JP_controllers {
static testMethod void validate_JP_CLCommonConst_controller() {
JP_CLCommonConst  CLCommon = new JP_CLCommonConst();
JP_CLCommonConst.PROFILENAME();
JP_CLCommonConst.PROFILENAME_ALLJP();

}

static testMethod void validate_RSDefaultNewPortalUser_class(){
 Schema.DescribeSObjectResult AccDescribe = Schema.SObjectType.Account; 
       Map<String,Schema.RecordTypeInfo> AccRtMapByName = AccDescribe.getRecordTypeInfosByName();       
       Id AccRCTypeId = AccRtMapByName.get('ATI Accounts').getRecordTypeId();
      
       Schema.DescribeSObjectResult ConDescribe = Schema.SObjectType.Contact; 
       Map<String,Schema.RecordTypeInfo> ConRtMapByName = ConDescribe.getRecordTypeInfosByName();
       Id ConRCTypeId = ConRtMapByName.get('Americas Contacts').getRecordTypeId();
account Acc = new Account(Name='Test Account',ATFE_AccountType__c = 'End Customer',Region__c = 'NA',Sub_Region__c = 'NA',
           ATFE_SalesOrgName__c = 'Sales Ops',website = 'www.none.com.in',RecordTypeId = AccRCTypeId,ATFE_VerticalMarketInit__c = 'Other',
           BillingCity = 'San Jose',BillingCountry = 'United States', BillingPostalCode  = '95134', BillingState = 'California',
           BillingStreet = 'Orchard Pkwy', ShippingCity = 'San Jose',ShippingCountry = 'United States', ShippingPostalCode = '95134', 
           ShippingState = 'California', ShippingStreet = 'Orchard Pkwy' );
       insert Acc ;
       System.assert(Acc.Id!= null);
        contact Con = new Contact(FirstName  = 'TestFirstName', LastName  = 'TestLastName',RecordTypeId  = ConRCTypeId ,AccountId  = Acc.id, Email = 'none12345@none.com',
       Phone  = '+9140 80000000' , MailingCountry = 'Japan');//2024/01/22 仙波追記
        insert Con ;
       System.assert(Con.Id!= null);
       
       ID CommunityProfileID = [SELECT Id,Name FROM Profile where Name = 'Customer Support Community'].Id;

 User com_user = new User();
        com_user.Username = 'com_usertest@none.com';
        com_user.Email = 'com_usertest@none.com';
        com_user.FirstName = 'com_usertestname';
        com_user.LastName = 'com_userlastname';
        com_user.CommunityNickname = 'com_usern091';
        com_user.ProfileId = CommunityProfileID;
        com_user.ContactId = Con.id;
        com_user.Alias = 'com_u';
        com_user.TimeZoneSidKey = 'GMT';
        com_user.LocaleSidKey = 'en_US';                 
        com_user.EmailEncodingKey = 'ISO-8859-1';        
        com_user.LanguageLocaleKey = 'en_US'; 
        com_user.IsActive  = true;
        //insert com_user;
        //System.assert(com_user.Id!= null);
        
    RSDefaultNewPortalUser RSD = new RSDefaultNewPortalUser();
    
    RSD.execute(com_user,Acc.id,'test123');
}

/*static testMethod void validate_CustomerCommunityURLRewriter_class(){
  CustomerCommunityURLRewriter CCR = new CustomerCommunityURLRewriter();
  PageReference pageref = null;
  CCR.mapRequestUrl(pageref );
}*/

}