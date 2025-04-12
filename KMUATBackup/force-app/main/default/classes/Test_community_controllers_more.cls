@isTest
private class Test_community_controllers_more {
   private  static Id AccRCTypeId;
   private  static Id ConRCTypeId;
   private  static Id  ATI_CaseID;
   private  static Id  ATI_RMAParent_CASEID;
   private  static Id  ATI_RMAChild_CASEID;
   private  static Account Acc;
   private  static Contact Con;
   private  static ID guestProfileID;
   private  static ID CommunityProfileID;
   private  static User guest_user;
   private  static User com_user;
   private  static Product2 newtestproduct;
   private  static Product2 newtestservice;
   private  static Asset__c TestHW;
   private  static Warranty__c WarrantyCode;
   private  static Warranty_Items__c W_Item; 
   private  static Service_Asset__c TestSW;
   //common  test data
   static {
           RecordTypesSingleTon rt = RecordTypesSingleTon.getInstance();
           
       //Channelinsight.CI_TEST_TestUtils.createBaseInstallData(); Neha commented for model n package uninstallation
       AccRCTypeId = rt.RtMap.get('Americas_Accounts').ID;
       ConRCTypeId = rt.RtMap.get('Americas_Contacts').ID;
       ATI_CaseID = rt.RtMap.get('ATI_Case').ID;
       ATI_RMAParent_CASEID  = rt.RtMap.get('ATI_RMA_Parent_Case').ID;
       ATI_RMAChild_CASEID =   rt.RtMap.get('ATI_RMA_Child_Case').ID;
       
       
        /*
        AccRCTypeId = [SELECT id,name FROM RecordType where developername = 'Americas_Accounts'].id;
        ConRCTypeId = [SELECT id FROM RecordType where developername = 'Americas_Contacts'].id;
       
        List<RecordType> AllCaseRT = [SELECT Id, DeveloperName  FROM RecordType where Sobjecttype = 'Case'];
        
        for(RecordType CaseRT : AllCaseRT )
        {
            if(CaseRT.DeveloperName == 'ATI_Case')
                ATI_CaseID = CaseRT.ID;
            if(CaseRT.DeveloperName == 'ATI_RMA_Parent_Case')
                ATI_RMAParent_CASEID = CaseRT.ID;
            if(CaseRT.DeveloperName == 'ATI_RMA_Child_Case')
                ATI_RMAChild_CASEID = CaseRT.ID;
        }
        */
       
       guestProfileID = [SELECT Id,Name FROM Profile where Name = 'Standard User'].Id;
       CommunityProfileID = [SELECT Id,Name FROM Profile where Name = 'Customer Support Community'].Id;
      
       
       Acc = new Account(Name='Test Account',ATFE_AccountType__c = 'End Customer',Region__c = 'NA',Sub_Region__c = 'NA',
           ATFE_SalesOrgName__c = 'Sales Ops',website = 'www.none.com.in',RecordTypeId = AccRCTypeId,ATFE_VerticalMarketInit__c = 'Other',
           BillingCity = 'San Jose',BillingCountry = 'United States', BillingPostalCode  = '95134', BillingState = 'California',
           BillingStreet = 'Orchard Pkwy', ShippingCity = 'San Jose',ShippingCountry = 'United States', ShippingPostalCode = '95134', 
           ShippingState = 'California', ShippingStreet = 'Orchard Pkwy' );
       insert Acc ;
       System.assert(Acc.Id!= null);
       Con = new Contact(FirstName  = 'TestFirstName', LastName  = 'TestLastName',RecordTypeId  = ConRCTypeId ,AccountId  = Acc.id, Email = 'none@none.com',
       Phone  = '+9140 80000000' );
        insert Con ;
       System.assert(Con.Id!= null);
       
      
       //new Test hw Asset
      // insert test product - type product
      newtestproduct = new Product2(ATFE_NA__c = true, ATFE_PartStatusDesc__c = 'Active-Active' ,ATFE_ProductRegion__c   = 'NA',
      ATFE_ProductType__c = 'OPTICAL', ATFE_Status__c = 'ACTIVE', CurrencyIsoCode = 'USD', 
      Description  = '500m 850nm 1000Base-SX Small Form Pluggable - Hot Swappable',
      Family = 'PRODUCT',IsActive = true,Name = 'AT-SPSX',ProductCode = '990-001201-00',Warranty__c = 'NA-NA-C-1825,CSA-CCA-L-90'
      );
      
      insert newtestproduct ;
      System.assert(newtestproduct.Id!= null);
     
     // insert test product - type service
      newtestservice = new Product2(ATFE_NA__c = true, ATFE_PartStatusDesc__c = 'Active-Active' ,ATFE_ProductRegion__c   = 'NA',
      ATFE_ProductType__c = 'T - SERVICE', ATFE_Status__c = 'ACTIVE', CurrencyIsoCode = 'USD', ATFE_Service_Product_Type__c='NCB-1',
      Description  = 'PS Bundle Serv 40 Hours',
      Family = 'SERVICE',IsActive = true,Name = 'AT-EFIH-40',ProductCode = '960-20201-40'
      );
      
      insert newtestservice ;
      System.assert(newtestservice.Id!= null);
      // insert test hardware asset.


      TestHW = new Asset__c( Name = 'AT-SPSX' , Product__c = newtestproduct.id, Serial_Number__c = 'A234567890122345',
      Account__c = Acc.Id,  Start_Date__c = date.Today());
      insert TestHW;
      System.assert(TestHW.Id!= null);
      // new warranty code
      WarrantyCode = new Warranty__c(Description__c = '2 Years Warranty',Duration_Days__c = 730.00,Name = 'NA-NA-A-730',Region__c = 'NA',Sub_Region__c = 'NA',Warranty_Type__c = 'K'); 
      insert WarrantyCode ;
      System.assert(WarrantyCode.Id!= null);
      //new warranty item
      W_Item = new Warranty_Items__c(Duration__c = WarrantyCode.Duration_Days__c ,HW_Asset__c = TestHW.Id ,
      Name = WarrantyCode.Name ,Region__c =  WarrantyCode.Region__c,Sub_Region__c = WarrantyCode.Sub_Region__c,
      Warranty_End_Date__c = date.today().addDays(730),Warranty_Start_Date__c = date.today(),Warranty__c = WarrantyCode.Id);
      insert W_Item;
      System.assert(W_Item.Id!= null);
      
      //new service Asset
    /*  TestSW = new Service_Asset__c(Account__c =Acc.Id ,Asset__c = TestHW.Id,Name = 'AT-EFIH-40',Service_Product__c = newtestservice.Id,Start_Date__c =  date.today());
      insert TestSW ;
      System.assert(TestSW.Id!= null);*/
     
       /* guest_user = new User();
        guest_user.Username = 'test@none.com';
        guest_user.Email = 'test@none.com';
        guest_user.FirstName = 'testname';
        guest_user.LastName = 'lastname';
        guest_user.CommunityNickname = 'n091';
        guest_user.ProfileId = guestProfileID ;
        guest_user.Alias = 'test';
        guest_user.TimeZoneSidKey = 'GMT';
        guest_user.LocaleSidKey = 'en_US';                
        guest_user.EmailEncodingKey = 'ISO-8859-1';       
        guest_user.LanguageLocaleKey = 'en_US'; 
        guest_user.IsActive  = true;
     
       insert guest_user;
       System.assert(guest_user.Id!= null);
       
        com_user = new User();
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
        insert com_user;
        System.assert(com_user.Id!= null);*/
    
    }
private static void createusers(string username)
{
       // Channelinsight.CI_TEST_TestUtils.createBaseInstallData();
        guest_user = new User();
        guest_user.Username = 'guest'+ username+ '@none.com';
        guest_user.Email = 'test@none.com';
        guest_user.FirstName = 'testname';
        guest_user.LastName = 'lastname';
        guest_user.CommunityNickname = 'n091';
        guest_user.ProfileId = guestProfileID ;
        guest_user.Alias = 'test';
        guest_user.TimeZoneSidKey = 'GMT';
        guest_user.LocaleSidKey = 'en_US';                
        guest_user.EmailEncodingKey = 'ISO-8859-1';       
        guest_user.LanguageLocaleKey = 'en_US'; 
        guest_user.IsActive  = true;
     
       insert guest_user;
       System.assert(guest_user.Id!= null);
    
        com_user = new User();
        com_user.Username = 'com'+ username+ '@none.com';
        com_user.Email = 'com_usertest@none.com';
        com_user.FirstName = 'com_usertestname';
        com_user.LastName = 'com_userlastname';
        com_user.CommunityNickname = 'com_usern091';
        com_user.ProfileId = CommunityProfileID;
        com_user.ContactId = Con.id;
        //com_user.Accountid = Acc.id; 
        com_user.Alias = 'com_u';
        com_user.TimeZoneSidKey = 'GMT';
        com_user.LocaleSidKey = 'en_US';                 
        com_user.EmailEncodingKey = 'ISO-8859-1';        
        com_user.LanguageLocaleKey = 'en_US'; 
        com_user.IsActive  = true;
        insert com_user;
        System.assert(com_user.Id!= null);
    
    } 

static testMethod void validate_AddAttachment_controller() 
{
        //Channelinsight.CI_TEST_TestUtils.createBaseInstallData();
        createusers('AddAttachment');
        PageReference pageRef = Page.CustomerCommunityAddAttachment;
        Test.setCurrentPage(pageRef);
        System.RunAs(com_user)
        {
        Case ATI_CASE = new Case();   
            ATI_CASE.Accountid  = Acc.Id ; //Account Name
            ATI_CASE.Contactid  = Con.Id; //Contact Name
            ATI_CASE.Request_Title__c  = 'Test parent Request'; //Customer title
            ATI_CASE.Description  = 'Test parent Request';  //Customer description
            ATI_CASE.Impact__c= 'High'; //Impact
            ATI_CASE.Urgency__c= 'High'; //Impact 
            ATI_CASE.Hw_Asset_Name__c   =  TestHw.Id; 
                 
            ATI_CASE.RecordTypeId = ATI_RMAParent_CASEID;
            insert ATI_CASE;
            CustomerCommunityAddAttachmentController  AddAttach1 = new CustomerCommunityAddAttachmentController();
            ApexPages.currentPage().getParameters().put('caseId', ATI_CASE.Id);
            
            CustomerCommunityAddAttachmentController  AddAttach = new CustomerCommunityAddAttachmentController();
            Attachment attach = new Attachment();
            Blob b = Blob.valueOf('A');
            attach.Body = b;
            attach.ContentType = 'application/pdf';
            attach.Name = 'Test';
            attach.ParentId = ATI_CASE.Id;
            
            
            
            AddAttach.attachment = attach;
            // AddAttach.attachment = new attachment();
            AddAttach.loadMessages();
            AddAttach.BackPage();
            AddAttach.upload();
            test.starttest();
                AddAttach.attachment = null;
                AddAttach.upload();
            test.stoptest();
            
            
        }
        CustomerCommunityAddAttachmentController  AddAttach2 = new CustomerCommunityAddAttachmentController();
}
static testMethod void validate_Article_controller() 
{
       // Channelinsight.CI_TEST_TestUtils.createBaseInstallData();
        PageReference pageRef = Page.CustomerCommunityArticle;
        Test.setCurrentPage(pageRef);
         ApexPages.currentPage().getParameters().put('articleId', null);
        CustomerCommunityArticleController ArtcleInTest = new CustomerCommunityArticleController();
        ArtcleInTest.article = null;
         
       
}

static testMethod void validate_ArticleList_controller() 
{
       // Channelinsight.CI_TEST_TestUtils.createBaseInstallData();
        PageReference pageRef = Page.CustomerCommunityArticlesList;
        Test.setCurrentPage(pageRef);
         ApexPages.currentPage().getParameters().put('articleId', null);
         ApexPages.currentPage().getParameters().put('articleId', 'searchTerm');
        CustomerCommunityArticlesListController ArtcleListInTest = new CustomerCommunityArticlesListController();
        ArtcleListInTest.BackPage();
        ArtcleListInTest.searchTerm = 'Tes';
        ArtcleListInTest.searchKB();
        ArtcleListInTest.searchTerm = '';
        ArtcleListInTest.searchKB();
        ApexPages.currentPage().getParameters().put('articleId', null);
         ApexPages.currentPage().getParameters().put('searchTerm', '');
        CustomerCommunityArticlesListController ArtcleListInTestt = new CustomerCommunityArticlesListController();
         
       
}

static testMethod void validate_changepassword_controller() 
{
//Channelinsight.CI_TEST_TestUtils.createBaseInstallData();
createusers('changepassword');
        PageReference pageRef = Page.CustomerCommunityChangePassword;
        Test.setCurrentPage(pageRef);
        System.RunAs(com_user)
        {
            CustomerCommunityCPController changepassword = new CustomerCommunityCPController();
            changepassword.oldpassword = 'test1';
            changepassword.password  = 'test2';
            changepassword.confirmpassword  = 'test2';
            changepassword.Save();
            changepassword.oldpassword = '';
            changepassword.password  = '';
            changepassword.confirmpassword  = '';
            changepassword.Save();
            changepassword.forwardToCustomAuthPage();
            changepassword.BackPage();
           }
       


        //Run As guest user
        System.RunAs(guest_user)
        {
            CustomerCommunityCPController changepassword = new CustomerCommunityCPController();
            String result= changepassword.forwardToCustomAuthPage().getUrl();
            System.assertEquals('/CustomerCommunityHome', result);
        }
}
static testMethod void validate_UserAccountEdit_controller() 
{
//Channelinsight.CI_TEST_TestUtils.createBaseInstallData();
createusers('UserAccountEdit');
        PageReference pageRef = Page.CustomerCommunityUserAccountEdit;
        Test.setCurrentPage(pageRef);
        System.RunAs(com_user)
        {
            CustomerCommunityUAEditController UserAccountEdit = new CustomerCommunityUAEditController();
            UserAccountEdit.password  = 'UAEditest2';
            UserAccountEdit.confirmpassword  = 'UAEditest2';
            
            UserAccountEdit.firstName = 'UAEdit_firstname';
            UserAccountEdit.lastName = 'UAEdit_lastname';
            UserAccountEdit.email = 'UAEdit@none.com';
            UserAccountEdit.communityNickname = 'UAEdit';
    
            UserAccountEdit.Save();
            UserAccountEdit.firstName = '';
            UserAccountEdit.lastName = '';
            UserAccountEdit.email = '';
            UserAccountEdit.Save();
            UserAccountEdit.forwardToCustomAuthPage();
            UserAccountEdit.BackPage();
           }
       


        //Run As guest user
        System.RunAs(guest_user)
        {
             CustomerCommunityUAEditController UserAccountEdit1 = new CustomerCommunityUAEditController();
            String result= UserAccountEdit1.forwardToCustomAuthPage().getUrl();
            System.assertEquals('/CustomerCommunityHome', result);
        }
}

static testMethod void validate_UserAccount_controller() 
{
//Channelinsight.CI_TEST_TestUtils.createBaseInstallData();
createusers('UserAccount');
        PageReference pageRef = Page.CustomerCommunityUserAccount;
        Test.setCurrentPage(pageRef);
        System.RunAs(com_user)
        {
            CustomerCommunityUserAccountController UserAccount = new CustomerCommunityUserAccountController();
            UserAccount.password  = 'UAEditest2';
            UserAccount.error = 'test';
            UserAccount.firstName = 'UAEdit_firstname';
            UserAccount.lastName = 'UAEdit_lastname';
            UserAccount.email = 'UAEdit@none.com';
            UserAccount.communityNickname = 'UAEdit';
    
            UserAccount.forwardToCustomAuthPage();
            UserAccount.BackPage();
            UserAccount.ChangePassword();
            UserAccount.EditAccount();
           }
       


        //Run As guest user
        System.RunAs(guest_user)
        {
            CustomerCommunityUserAccountController UserAccount1 = new CustomerCommunityUserAccountController();
            String result= UserAccount1.forwardToCustomAuthPage().getUrl();
            System.assertEquals('/CustomerCommunityHome', result);
        }
}

static testMethod void validate_createComment_controller() 
{
        //Channelinsight.CI_TEST_TestUtils.createBaseInstallData();
        createusers('createComment');
            
          
        System.RunAs(com_user)
        {
          PageReference pageRef = Page.CustomerCummunityCreateComment;
            Test.setCurrentPage(pageRef);
        Case ATI_CASE = new Case(); 
        ATI_CASE.Accountid  = Acc.Id ; //Account Name
        ATI_CASE.Contactid  = Con.Id; //Contact Name
        ATI_CASE.RecordTypeId = ATI_CaseID;//ATI_RMAParent_CASEID;
        ATI_CASE.Request_Title__c  = 'Test parent Request'; //Customer title
        ATI_CASE.Description  = 'Test parent Request';  //Customer description
        ATI_CASE.Impact__c= 'High'; //Impact
        ATI_CASE.Urgency__c= 'High'; //Impact 
        ATI_CASE.Hw_Asset_Name__c   =  TestHw.Id; 
        Test.StartTest();
        insert ATI_CASE;
        System.assert(ATI_CASE.Id!= null);
        
        CustomerCummunityCreateCommentController comment_test = new CustomerCummunityCreateCommentController();
        ApexPages.currentPage().getParameters().put('caseId', ATI_CASE.Id); 
          CustomerCummunityCreateCommentController comment = new CustomerCummunityCreateCommentController();
          comment.userComment = 'UAEditest2';
          comment.forwardToCustomAuthPage();
          comment.BackPage();
          comment.SubmitComment();
             Test.StopTest();
        }


}

static testMethod void validate_createComment_controller2() 
{
       // Channelinsight.CI_TEST_TestUtils.createBaseInstallData();
        createusers('guest_user');
        //Run As guest user
        System.RunAs(guest_user)
        {
            CustomerCummunityCreateCommentController comment1 = new CustomerCummunityCreateCommentController();
            String result= comment1.forwardToCustomAuthPage().getUrl();
            System.assertEquals('/CustomerCommunityHome', result);
        }
        
}
static testMethod void validate_PublisherActionCaseComment_controller() 
{
//Channelinsight.CI_TEST_TestUtils.createBaseInstallData();
createusers('PublisherActionCaseComment');
        Case ATI_CASE = new Case();   
        ATI_CASE.Accountid  = Acc.Id ; //Account Name
        ATI_CASE.Contactid  = Con.Id; //Contact Name
        ATI_CASE.Request_Title__c  = 'Test parent Request'; //Customer title
        ATI_CASE.Description  = 'Test parent Request';  //Customer description
        ATI_CASE.Impact__c= 'High'; //Impact
        ATI_CASE.Urgency__c= 'High'; //Impact 
        ATI_CASE.Hw_Asset_Name__c   =  TestHw.Id; 
             
        ATI_CASE.RecordTypeId = ATI_RMAParent_CASEID;
        insert ATI_CASE;
        ApexPages.StandardController sc = new ApexPages.standardController(ATI_CASE);
        PublisherActionCaseCommentController  ActionCaseExt = new PublisherActionCaseCommentController(sc);
        
        ActionCaseExt.lastError = 'last_error';
        ActionCaseExt.createCaseComment();
        
}

static testMethod void validate_autocompleteforProduct_controller() 
{
    //Channelinsight.CI_TEST_TestUtils.createBaseInstallData();
    createusers('autocompProduct');
    PageReference pageRef = Page.customercommunitycreatecasehwreg;
    Test.setCurrentPage(pageRef);
    ApexPages.currentPage().getParameters().put('AccId', Acc.Id);
    ApexPages.currentPage().getParameters().put('HwInfo', 'true');
     System.RunAs(com_user)
     { 
    
     CustomerCommunityCretCasHWRegController  createcaseHWRegcontroller = new CustomerCommunityCretCasHWRegController();
     autocompleteforProduct autoComplete = new autocompleteforProduct(createcaseHWRegcontroller); 
     autocompleteforProduct.getAllRel_products();
     }
     Acc.BillingCountry = 'Belize';
     Acc.ShippingCountry = 'Belize';
     update Acc;
     System.RunAs(com_user)
     {    
         CustomerCommunityCretCasHWRegController  createcaseHWRegcontroller = new CustomerCommunityCretCasHWRegController();
         autocompleteforProduct autoComplete = new autocompleteforProduct(createcaseHWRegcontroller);
         autocompleteforProduct.getAllRel_products();
     }
      Test.StartTest();
     Acc.Region__c = 'CSA';
     update Acc;
     System.RunAs(com_user)
     { 
         autocompleteforProduct.getAllRel_products();
     }
     
    // Acc.Region__c = 'EMEA';
    // update Acc;
    // System.RunAs(com_user)
    // { 
    //     autocompleteforProduct.getAllRel_products();
   //  }
    
    // Acc.Region__c = 'other';
     //update Acc;
    // System.RunAs(com_user)
    // { 
     //    autocompleteforProduct.getAllRel_products();
    // }
     
         Acc.Region__c = 'APAC';
         update Acc;
          System.RunAs(com_user)
         { 
             autocompleteforProduct.getAllRel_products();
         }
         Acc.Region__c = 'NA';
         update Acc;
       Test.StopTest();    
    }
static testMethod void validate_emailMessageHandling_trigger() 
{
 //Channelinsight.CI_TEST_TestUtils.createBaseInstallData();
  Test.startTest();
createusers('emaieHandling');
        Case ATI_CASE = new Case();   
        ATI_CASE.Accountid  = Acc.Id ; //Account Name
        ATI_CASE.Contactid  = Con.Id; //Contact Name
        ATI_CASE.Request_Title__c  = 'Test parent Request'; //Customer title
        ATI_CASE.Description  = 'Test parent Request';  //Customer description
        ATI_CASE.Impact__c= 'High'; //Impact
        ATI_CASE.Urgency__c= 'High'; //Impact 
        ATI_CASE.Hw_Asset_Name__c   =  TestHw.Id; 
             
        ATI_CASE.RecordTypeId = ATI_CASEID;
        insert ATI_CASE;
       EmailMessage[] newEmail = new EmailMessage[0];
       newEmail.add(new EmailMessage(FromAddress = 'test@abc.org', Incoming = True, ToAddress= 'none@none.com', Subject = 'Test email', TextBody = '23456 ', ParentId = ATI_CASE.Id)); 
       insert newEmail;
       Test.stopTest();
}

static testMethod void validate_MassRMAupdate_controller() 
{
       //Channelinsight.CI_TEST_TestUtils.createBaseInstallData();
        createusers('MassRMAupdate');
      
        List<Case> AllCases = new  List<Case>();
        List<Case> AllSelectedCases = new  List<Case>();
       // Set<ID> child_IDs = new Set<ID>();
         
        Case ATI_CASE = new Case();   
        ATI_CASE.Accountid  = Acc.Id ; //Account Name
        ATI_CASE.Contactid  = Con.Id; //Contact Name
        ATI_CASE.Request_Title__c  = 'Test parent Request'; //Customer title
        ATI_CASE.Description  = 'Test parent Request';  //Customer description
        ATI_CASE.Impact__c= 'High'; //Impact
        ATI_CASE.Urgency__c= 'High'; //Impact 
        ATI_CASE.Hw_Asset_Name__c   =  TestHw.Id; 
             
        ATI_CASE.RecordTypeId = ATI_RMAParent_CASEID;
         Test.StartTest();
         UtilSODOFlags.skip_caseTrigges = true;
        insert ATI_CASE;
         
        for(integer i =0; i<1; i++)
        {    
            Case ATI_CHILD_CASE = new Case();   
            ATI_CHILD_CASE.Accountid  = Acc.Id ; //Account Name
            ATI_CHILD_CASE.Contactid  = Con.Id; //Contact Name
            ATI_CHILD_CASE.Request_Title__c  = 'Test child Request'; //Customer title
            ATI_CHILD_CASE.Description  = 'Test child Request';  //Customer description
            ATI_CHILD_CASE.Impact__c= 'High'; //Impact
            ATI_CHILD_CASE.Urgency__c= 'High'; //Impact 
            ATI_CHILD_CASE.Priority = 'P2'; //priority
            ATI_CHILD_CASE.Origin= 'Email'; //Origin
            ATI_CHILD_CASE.Status = 'New';
            ATI_CHILD_CASE.Hw_Asset_Name__c   =  TestHw.Id; 
            ATI_CHILD_CASE.RMA_Status__c = 'Awaiting ATI';
            ATI_CHILD_CASE.ParentId = ATI_CASE.id;
                 
            ATI_CHILD_CASE.RecordTypeId = ATI_RMAChild_CASEID;
            AllCases.add(ATI_CHILD_CASE);
        }
       
        insert AllCases;
         Test.StopTest();
        PageReference pageRef = Page.CaseMassRMAupdate;
       // AllSelectedCases = [SELECT id,RecordTypeId ,Description FROM Case where RecordTypeId  = :AllCases[0].id];
       system.debug('selected cases in test case:-> ' + AllCases);
        
       ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(AllCases);
       CaseMassRMAupdate cRMAupdateTest1 = new CaseMassRMAupdate(ssc);
       cRMAupdateTest1.selectCases();
       ssc.setSelected(AllCases);
       CaseMassRMAupdate cRMAupdateTest2 = new CaseMassRMAupdate(ssc);
       cRMAupdateTest2.selectCases();
       
       cRMAupdateTest2.cRMAupdate.Date_of_Purchase__c = date.today();
       cRMAupdateTest2.cRMAupdate.RMA_Reason__c = 'Repair';
       cRMAupdateTest2.cRMAupdate.ATI_Fault_Code_1__c = 'UnKnown'; 
       cRMAupdateTest2.cRMAupdate.RMA_Service_Offered__c = 'On-Site';
       cRMAupdateTest2.cRMAupdate.RMA_Status__c = 'Awaiting ATI';
       cRMAupdateTest2.cRMAupdate.RMA_Number__c = '123';
       cRMAupdateTest2.cRMAupdate.RMA_Number__c = '456';
    
       cRMAupdateTest2.SubmitChanges();
       cRMAupdateTest2.CancelChanges();
        UtilSODOFlags.skip_caseTrigges = false;
       
}

}