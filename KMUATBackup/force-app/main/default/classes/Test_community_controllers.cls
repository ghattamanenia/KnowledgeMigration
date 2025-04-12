@isTest
private class Test_community_controllers {
   private  static Id AccRCTypeId;
   private  static Id ConRCTypeId;
   private  static Id  ATI_CaseID;
   private  static Id  ATI_RMAParent_CASEID;
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
        
       //AccRCTypeId = [SELECT id,name FROM RecordType where developername = 'Americas_Accounts'].id;
       //ConRCTypeId = [SELECT id FROM RecordType where developername = 'Americas_Contacts'].id;

       AccRCTypeId = rt.RtMap.get('Americas_Accounts').ID;
       ConRCTypeId = rt.RtMap.get('Americas_Contacts').ID;
       ATI_CaseID = rt.RtMap.get('ATI_Case').ID;
       ATI_RMAParent_CASEID  = rt.RtMap.get('ATI_RMA_Parent_Case').ID;       
       
       /*
        List<RecordType> AllCaseRT = [SELECT Id, DeveloperName  FROM RecordType where Sobjecttype = 'Case'];
        
        for(RecordType CaseRT : AllCaseRT )
        {
            if(CaseRT.DeveloperName == 'ATI_Case')
                ATI_CaseID = CaseRT.ID;
            if(CaseRT.DeveloperName == 'ATI_RMA_Parent_Case')
                ATI_RMAParent_CASEID = CaseRT.ID;
        }
       */
       guestProfileID = [SELECT Id,Name FROM Profile where Name = 'Standard User'].Id;
       CommunityProfileID = [SELECT Id,Name FROM Profile where Name = 'Customer Support Community'].Id;
      //Channelinsight.CI_TEST_TestUtils.createBaseInstallData();
       
       Acc = new Account(Name='Test Account',ATFE_AccountType__c = 'End Customer',Region__c = 'NA',Sub_Region__c = 'NA',
           ATFE_SalesOrgName__c = 'Sales Ops',website = 'www.none.com.in',RecordTypeId = AccRCTypeId,ATFE_VerticalMarketInit__c = 'Other',
           BillingCity = 'San Jose',BillingCountry = 'United States', BillingPostalCode  = '95134', BillingState = 'California',
           BillingStreet = 'Orchard Pkwy', ShippingCity = 'San Jose',ShippingCountry = 'United States', ShippingPostalCode = '95134', 
           ShippingState = 'California', ShippingStreet = 'Orchard Pkwy' );
       insert Acc ;
       System.assert(Acc.Id!= null);
       Con = new Contact(FirstName  = 'TestFirstName', LastName  = 'TestLastName',RecordTypeId  = ConRCTypeId ,AccountId  = Acc.id, Email = 'none198777@none.com',
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
    /* TestSW = new Service_Asset__c(Account__c =Acc.Id ,Asset__c = TestHW.Id,Name = 'AT-EFIH-40',Service_Product__c = newtestservice.Id,Start_Date__c =  date.today());
      insert TestSW ;
      System.assert(TestSW.Id!= null);*/
     
        /*guest_user = new User();
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
    private static void createusers(string username){
        guest_user = new User();
        guest_user.Username = 'guest'+ username + '@none.com';
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
        com_user.Alias = 'com_u';
        com_user.TimeZoneSidKey = 'GMT';
        com_user.LocaleSidKey = 'en_US';                 
        com_user.EmailEncodingKey = 'ISO-8859-1';        
        com_user.LanguageLocaleKey = 'en_US'; 
        com_user.IsActive  = true;
        insert com_user;
        System.assert(com_user.Id!= null);
    
    }
    
  
static testMethod  void validate_ContrctController(){
//CustomerCommunityContrctController  ContrctController;
serviceAssetcontroller.isTestRunning = true;
Service_Asset__c TestSW1 = new Service_Asset__c(Account__c =Acc.Id ,Asset__c = TestHW.Id,Name = 'AT-EFIH-40',Service_Product__c = newtestservice.Id,Start_Date__c =  date.today());
    insert TestSW1 ;
//ServiceContractAfterInsertUpdateCls.isRecurssion = true;      
ServiceContract SC = new ServiceContract(Name = 'test', Accountid = Acc.Id, Service_Asset__c = TestSW1.id,Asset__c =  TestHw.Id , StartDate = date.today() , enddate = date.today());
Test.StartTest();
insert SC;

     PageReference pageRef = Page.CustomerCommunityContractDetails;
     Test.setCurrentPage(pageRef);
     ApexPages.currentPage().getParameters().put('Accid', Acc.Id);
     ApexPages.currentPage().getParameters().put('HwId', TestHw.Id);

     CustomerCommunityContrctController ContrctController = new CustomerCommunityContrctController();
   
     ContrctController.Create_Case_for_Prod();

      ContrctController.BackPage();
      
      ContrctController.forwardToCustomAuthPage();

  Test.StopTest();  
 

}

static testMethod void validate_home_controller() {
       createusers('home');
       PageReference pageRef = Page.CustomerCommunityHome;
       Test.setCurrentPage(pageRef);
       CustomerCommunityHomeController  Homecontroller = new CustomerCommunityHomeController (); 
       Homecontroller.forwardToCustomAuthPage();
       Homecontroller.selfreg();
       System.RunAs(guest_user){
           Homecontroller.ForgotPassword();
           Homecontroller.login();
           Homecontroller.username = 'test';
           Homecontroller.password = 'testpass';
           Homecontroller.login();
           Homecontroller.searchKB();
           Homecontroller.username = '';
           Homecontroller.password = '';
           Homecontroller.login();
       }
       
      
}
     
     
static testMethod void validate_loggedin_controller() {
     createusers('loggedin');
     System.RunAs(com_user){
      list<Case> Allcases = new list<Case>();
      Case ATI_CASE = new Case();   
      ATI_CASE.Accountid  = Acc.Id ; //Account Name
      ATI_CASE.Contactid  = Con.Id; //Contact Name
      ATI_CASE.Request_Title__c  = 'Test Request'; //Customer title
      ATI_CASE.Description  = 'Test description';  //Customer description
      ATI_CASE.Impact__c= 'High'; //Impact
      ATI_CASE.Urgency__c= 'High'; //Impact           
      ATI_CASE.RecordTypeId = ATI_CaseID;
      Allcases.add(ATI_CASE);
        
      for(integer i = 0 ; i<9 ;i++) {
          ATI_CASE = new Case();   
          ATI_CASE.Accountid  = Acc.Id ; //Account Name
          ATI_CASE.Contactid  = Con.Id; //Contact Name
          ATI_CASE.RecordTypeId = ATI_CaseID;
           Allcases.add(ATI_CASE);
      }
      insert Allcases;
      System.assert( Allcases.size() > 0);
       PageReference pageRef = Page.CustomerCommunityLoggedIn;
       Test.setCurrentPage(pageRef);
         
       CustomerCommunityLoggedInController LoggedIncontroller = new CustomerCommunityLoggedInController(); 
       
       LoggedIncontroller.getGetcaseResult();
        
      
           LoggedIncontroller.forwardToCustomAuthPage();
           LoggedIncontroller.getprev();
           LoggedIncontroller.beginning();
           LoggedIncontroller.getnxt();
           LoggedIncontroller.next();
           LoggedIncontroller.next();
           LoggedIncontroller.previous();
           LoggedIncontroller.getprev();
           LoggedIncontroller.getnxt();
           LoggedIncontroller.end();
           LoggedIncontroller.getcaseRslt();
           LoggedIncontroller.searchKB();
           for(integer i = 0 ; i<5 ;i++) {
              ATI_CASE = new Case();   
              ATI_CASE.Accountid  = Acc.Id ; //Account Name
              ATI_CASE.Contactid  = Con.Id; //Contact Name
              ATI_CASE.RecordTypeId = ATI_CaseID;
              Allcases.add(ATI_CASE);
          }
          Test.StartTest();
          upsert Allcases;
           Test.StopTest();
           CustomerCommunityLoggedInController LoggedIncontroller12 = new CustomerCommunityLoggedInController();
           LoggedIncontroller12.end();
           
           
           
       
       }
       
       //Run As guest user
        System.RunAs(guest_user){
            CustomerCommunityLoggedInController LoggedIncontroller1 = new CustomerCommunityLoggedInController(); 
            String result= LoggedIncontroller1.forwardToCustomAuthPage().getUrl();
            System.assertEquals('/CustomerCommunityHome', result);
        }
       
      
    }
    
static testMethod void validate_findHW_controller() {
createusers('findHW');
System.RunAs(com_user){ 
      PageReference pageRef = Page.CustomerCommunityFindHardWare;
      Test.setCurrentPage(pageRef);
      ApexPages.currentPage().getParameters().put('AccId', Acc.Id);
      
        
           CustomerCommunityFindHWController findHWcontroller = new CustomerCommunityFindHWController(); 
           findHWcontroller.forwardToCustomAuthPage();
           findHWcontroller.HW_SerialNo = TestHw.Serial_Number__c;
           findHWcontroller.HW_id =  TestHw.Id;
           findHWcontroller.Create_Case_for_Prod();
           findHWcontroller.Create_Case_noHW();
           findHWcontroller.Create_Case();
           findHWcontroller.BackPage();
           findHWcontroller.searchtxt = 'AT';
           findHWcontroller.Search_Hardware();
           CustomerCommunityFindHWController.getHWList(Acc.Id);
           
       }
       
       System.RunAs(guest_user){
           CustomerCommunityFindHWController findHWcontroller1 = new CustomerCommunityFindHWController();  
            String result= findHWcontroller1.forwardToCustomAuthPage().getUrl();
            System.assertEquals('/CustomerCommunityHome', result);
       }
     
}




static testMethod void validate_createcase_controller() {
  createusers('createcase');
    CustomerCommunityCreateCaseController createcasecontroller ;
  System.RunAs(com_user){
      PageReference pageRef = Page.customercommunitycreatecase;
      Test.setCurrentPage(pageRef);
      ApexPages.currentPage().getParameters().put('AccId', Acc.Id);
      ApexPages.currentPage().getParameters().put('HWId', TestHw.Id);
      ApexPages.currentPage().getParameters().put('HWSerialNo', TestHw.Serial_Number__c);
     
        createcasecontroller  = new CustomerCommunityCreateCaseController(); 
        createcasecontroller.forwardToCustomAuthPage();
        createcasecontroller.caseNumber = '1234';
        createcasecontroller.caseTitle = 'testtitle';
        createcasecontroller.caseDescription = 'testdes';
        createcasecontroller.caseStatus = 'New';
        createcasecontroller.caseNewExistingInstallation = 'Yes';
        createcasecontroller.caseReproducible = 'Yes';
        createcasecontroller.caseReproSteps= 'Yes';
        createcasecontroller.caseRecentChanges= 'Yes';
        createcasecontroller.caseSpecificCircumstances= 'Yes';
        createcasecontroller.caseNetworkDown= 'Yes';
        createcasecontroller.caseWorkaround= 'Yes';
        createcasecontroller.caseServicesDegraded= 'Yes';
        createcasecontroller.caseWarranty = 'Yes';
        createcasecontroller.casePriority = 'P1';
        createcasecontroller.caseStatusComments = 'P1';
        createcasecontroller.caseCaseOpenDate = 'Yes';
        createcasecontroller.caseFirstResponseDate = 'Yes';
        createcasecontroller.caseClosedDate = 'Yes';
        createcasecontroller.caseResolution = 'Yes';
        createcasecontroller.caseImpact = 'High';
        createcasecontroller.caseUrgency = 'High';
        createcasecontroller.Hw_Asset = TestHw.Id;
        createcasecontroller.showfield = true;
        createcasecontroller.error = 'High';
        }  
         
        Test.StartTest();
        createcasecontroller.SubmitCase();
        //createcasecontroller.caseReproducible = 'No';
       
        //createcasecontroller.SubmitCase();
        createcasecontroller.BackPage();
        Test.StopTest();
    
       System.RunAs(guest_user){
           CustomerCommunityCreateCaseController createcasecontroller1 = new CustomerCommunityCreateCaseController ();  
            String result= createcasecontroller1.forwardToCustomAuthPage().getUrl();
            System.assertEquals('/CustomerCommunityHome', result);
       }
     
   
}


static testMethod  void validate_createcasehwreg_controller() {
    createusers('createcasehwreg');
   
       CustomerCommunityCretCasHWRegController  createcaseHWRegcontroller;
     System.RunAs(com_user){  
      PageReference pageRef = Page.customercommunitycreatecasehwreg;
      Test.setCurrentPage(pageRef);
      ApexPages.currentPage().getParameters().put('AccId', Acc.Id);
      ApexPages.currentPage().getParameters().put('HwInfo', 'true');
      createcaseHWRegcontroller = new CustomerCommunityCretCasHWRegController(); 
      //System.RunAs(com_user){
       // CustomerCommunityCretCasHWRegController  createcaseHWRegcontroller = new CustomerCommunityCretCasHWRegController(); 
        createcaseHWRegcontroller.forwardToCustomAuthPage();
        createcaseHWRegcontroller.caseNumber = '1234';
        createcaseHWRegcontroller.caseTitle = 'testtitle';
        createcaseHWRegcontroller.caseDescription = 'testdes';
        createcaseHWRegcontroller.caseStatus = 'New';
        createcaseHWRegcontroller.caseNewExistingInstallation = 'Yes';
        createcaseHWRegcontroller.caseReproducible = 'Yes';
        createcaseHWRegcontroller.caseReproSteps= '';
        createcaseHWRegcontroller.caseRecentChanges= 'Yes';
        createcaseHWRegcontroller.caseSpecificCircumstances= 'Yes';
        createcaseHWRegcontroller.caseNetworkDown= 'Yes';
        createcaseHWRegcontroller.caseWorkaround= 'Yes';
        createcaseHWRegcontroller.caseServicesDegraded= 'Yes';
        createcaseHWRegcontroller.caseWarranty = 'Yes';
        createcaseHWRegcontroller.casePriority = 'P1';
        createcaseHWRegcontroller.caseClosedDate = 'Yes';
        createcaseHWRegcontroller.caseResolution = 'Yes';
        createcaseHWRegcontroller.caseImpact = 'High';
        createcaseHWRegcontroller.caseUrgency = 'High';
        createcaseHWRegcontroller.error = 'High';
        createcaseHWRegcontroller.productModel = 'AT-SPSX';
        createcaseHWRegcontroller.HWSerialNumber = '123456789012';
        }
        createcaseHWRegcontroller.SubmitCase();
        createcaseHWRegcontroller.caseReproSteps= 'No';
        Test.StartTest();
        createcaseHWRegcontroller.SubmitCase();
        createcaseHWRegcontroller.BackPage();
        
      
     
       //System.RunAs(com_user){
        //createcaseHWRegcontroller.SubmitCase();
       //}
       
       Test.StopTest();
       System.RunAs(guest_user){
           CustomerCommunityCretCasHWRegController  createcasecontroller1 = new CustomerCommunityCretCasHWRegController();  
            String result= createcasecontroller1.forwardToCustomAuthPage().getUrl();
            System.assertEquals('/CustomerCommunityHome', result);
       }
     
   
}

static testMethod void validate_caseDetail_controller() {
     createusers('caseDetail');
      PageReference pageRef = Page.CustomerCommunityCaseDetail;
      Test.setCurrentPage(pageRef);
      list<Case> Allcases = new list<Case>();
      
      System.RunAs(com_user){
          Case ATI_CASE = new Case();   
          ATI_CASE.Accountid  = Acc.Id ; //Account Name
          ATI_CASE.Contactid  = Con.Id; //Contact Name
          ATI_CASE.Request_Title__c  = 'Test Request'; //Customer title
          ATI_CASE.Description  = 'Test description';  //Customer description
          ATI_CASE.Impact__c= 'High'; //Impact
          ATI_CASE.Urgency__c= 'High'; //Impact           
          ATI_CASE.RecordTypeId = ATI_CaseID;
          Allcases.add(ATI_CASE);
            
          for(integer i = 0 ; i<9 ;i++) {
              ATI_CASE = new Case();   
              ATI_CASE.Accountid  = Acc.Id ; //Account Name
              ATI_CASE.Contactid  = Con.Id; //Contact Name
              ATI_CASE.RecordTypeId = ATI_CaseID;
              Allcases.add(ATI_CASE);
          }
          insert Allcases;
          ApexPages.currentPage().getParameters().put('caseid', Allcases[0].Id);
         
           CustomerCommunityCaseDetailController caseDetailcontroller = new CustomerCommunityCaseDetailController(); 
           caseDetailcontroller.forwardToCustomAuthPage();
           caseDetailcontroller.BackPage();
           caseDetailcontroller.EditCase();
     }
     
      ApexPages.currentPage().getParameters().put('caseid', Allcases[0].Id);
      CustomerCommunityCaseDetailController caseDetailcontroller12 = new CustomerCommunityCaseDetailController();  
     
       System.RunAs(guest_user){
           CustomerCommunityCaseDetailController caseDetailcontroller1 = new CustomerCommunityCaseDetailController();  
            String result= caseDetailcontroller1.forwardToCustomAuthPage().getUrl();
            System.assertEquals('/CustomerCommunityHome', result);
       }
     
   
}

static testMethod void validate_caseEdit_controller() {
        createusers('caseEdit');
      PageReference pageRef = Page.CustomerCommunityCaseEdit;
      Test.setCurrentPage(pageRef);
      
      list<Case> Allcases = new list<Case>();
      
       System.RunAs(com_user){
          Case ATI_CASE = new Case();   
          ATI_CASE.Accountid  = Acc.Id ; //Account Name
          ATI_CASE.Contactid  = Con.Id; //Contact Name
          ATI_CASE.Request_Title__c  = 'Test Request'; //Customer title
          ATI_CASE.Description  = 'Test description';  //Customer description
          ATI_CASE.Impact__c= 'High'; //Impact
          ATI_CASE.Urgency__c= 'High'; //Impact 
          ATI_CASE.Hw_Asset_Name__c   =  TestHw.Id; 
          ATI_CASE.case_opened_date__c = date.today();      
          ATI_CASE.first_response__c = date.today();
          ATI_CASE.caseResolution__c = 'Test';
          ATI_CASE.Resolution_Code__c = 'RMA';
          ATI_CASE.Status = 'Closed';     
          ATI_CASE.RecordTypeId = ATI_CaseID;
          Allcases.add(ATI_CASE);
            
          for(integer i = 0 ; i<1 ;i++) {
              ATI_CASE = new Case();   
              ATI_CASE.Accountid  = Acc.Id ; //Account Name
              ATI_CASE.Contactid  = Con.Id; //Contact Name
              ATI_CASE.RecordTypeId = ATI_CaseID;
              Allcases.add(ATI_CASE);
          }
            Test.StartTest();
          insert Allcases;
      
     
        ApexPages.currentPage().getParameters().put('caseid', Allcases[0].Id);
        
        CustomerCommunityCaseEditController caseeditcontroller = new CustomerCommunityCaseEditController(); 
        caseeditcontroller.forwardToCustomAuthPage();
        caseeditcontroller.caseNumber = '1234';
        caseeditcontroller.caseTitle = 'testtitle';
        caseeditcontroller.caseDescription = 'testdes';
        caseeditcontroller.caseStatus = 'New';
        caseeditcontroller.caseNewExistingInstallation = 'Yes';
        caseeditcontroller.caseReproducible = 'Yes';
        caseeditcontroller.caseReproSteps= '';
        caseeditcontroller.caseRecentChanges= 'Yes';
        caseeditcontroller.caseSpecificCircumstances= 'Yes';
        caseeditcontroller.caseNetworkDown= 'Yes';
        caseeditcontroller.caseWorkaround= 'Yes';
        caseeditcontroller.caseServicesDegraded= 'Yes';
        caseeditcontroller.caseWarranty = 'Yes';
        caseeditcontroller.casePriority = 'P1';
        caseeditcontroller.caseStatusComments = 'P1';
        caseeditcontroller.caseCaseOpenDate = 'Yes';
        caseeditcontroller.caseFirstResponseDate = 'Yes';
        caseeditcontroller.caseClosedDate = 'Yes';
        caseeditcontroller.caseResolution = 'Yes';
        caseeditcontroller.showfield = true;
        caseeditcontroller.error = 'High';
      
        //caseeditcontroller.SaveCase();
        caseeditcontroller.caseReproSteps= 'red';
        caseeditcontroller.SaveCase();
        caseeditcontroller.BackPage();
        Test.StopTest();
     }
     
      ApexPages.currentPage().getParameters().put('caseid', Allcases[0].Id);
      CustomerCommunityCaseEditController caseeditcontroller12 = new CustomerCommunityCaseEditController(); 
      
       
       System.RunAs(guest_user){
           CustomerCommunityCaseEditController caseEditcontroller1 = new CustomerCommunityCaseEditController();  
            String result= caseEditcontroller1.forwardToCustomAuthPage().getUrl();
            System.assertEquals('/CustomerCommunityHome', result);
       }
     
   
}
@isTest(SeeAllData=true)
static void validate_selfreg_controller() {
 createusers('selfreg');
 System.RunAs(guest_user){
      PageReference pageRef = Page.CustomerCommunitySelfReg;
      Test.setCurrentPage(pageRef);
      
     
        CustomerCommunitySelfRegController SelfReg= new CustomerCommunitySelfRegController(); 
      
        SelfReg.firstName = 'firstTest';
        SelfReg.lastName = 'lastTest';
        SelfReg.email = '#first#Test#@none.com';
        SelfReg.phone =  '+49 40 33345667';  
        SelfReg.communityNickname = '##test##';
        SelfReg.accountName = 'testAcc';
        SelfReg.website = 'www.test.com.in';
        SelfReg.street = '101';
        SelfReg.city = 'testcity';
        SelfReg.state = 'teststate';
        SelfReg.zipCode = '12345';
        SelfReg.countryCode = 'ES';
        SelfReg.pickLabel = 'test';
        //SelfReg.selectedCountry 
        SelfReg.error  = 'test';
        
        SelfReg.BackPage();
        SelfReg.registerUser();
       // SelfReg.registerUser();
        //SelfReg.firstName = '1firstTest';
        
        Test.StartTest();
        //SelfReg.registerUser();
        SelfReg.countrycode = 'CA';
       
        SelfReg.registerUser();
        //SelfReg.countrycode = 'JM';
        //SelfReg.registerUser();
        Test.StopTest();
        
        SelfReg.firstName = '';
        SelfReg.lastName = '';
        SelfReg.email = '';
        SelfReg.phone =  '';
        SelfReg.communityNickname = '';
        SelfReg.accountName = '';
        SelfReg.website = '';
        SelfReg.street = '';
        SelfReg.city = '';
        SelfReg.state = '';
        SelfReg.zipCode = '';
        SelfReg.countrycode = '';
        SelfReg.pickLabel = '';
        SelfReg.registerUser();
   }
   
}

static testMethod void validate_forgotPW_controller() {
createusers('forgotPW');
System.RunAs(guest_user){
      PageReference pageRef = Page.CustomerCommunityForgotPwd;
      Test.setCurrentPage(pageRef);
      CustomerCommunityForgotPwdController forgotPW = new CustomerCommunityForgotPwdController(); 
      forgotPW.BackPage();
      forgotPW.username = '';
      forgotPW.forgotPassword();
      forgotPW.username = 'test';
      forgotPW.error = 'test';
      forgotPW.forgotPassword();
      forgotPW.username = com_user.Email;
      forgotPW.forgotPassword();
      }
}

static testMethod void validate_CaseRMAChildType_controller() {
        createusers('CaseRMAChildType');
        PageReference pageRef = Page.CaseRMAChildType;
        Test.setCurrentPage(pageRef);
        Case ATI_ParentCASE = new Case();   
        ATI_ParentCASE.Accountid  = Acc.Id ; //Account Name
        ATI_ParentCASE.Contactid  = Con.Id; //Contact Name
        ATI_ParentCASE.Request_Title__c  = 'Test parent Request'; //Customer title
        ATI_ParentCASE.Description  = 'Test parent Request';  //Customer description
        ATI_ParentCASE.Impact__c= 'High'; //Impact
        ATI_ParentCASE.Urgency__c= 'High'; //Impact 
        ATI_ParentCASE.Hw_Asset_Name__c   =  TestHw.Id; 
             
        ATI_ParentCASE.RecordTypeId = ATI_RMAParent_CASEID;
        insert ATI_ParentCASE;
        
        ApexPages.currentPage().getParameters().put('RelAccountId', ATI_ParentCASE.Accountid);
        ApexPages.currentPage().getParameters().put('RelContactId', ATI_ParentCASE.Contactid);
        ApexPages.currentPage().getParameters().put('ParentCaseId', ATI_ParentCASE.Id);
     
        CaseRMAChildType RMAChild = new CaseRMAChildType(); 
        
        RMAChild.submitCase.New_or_Existing_Installation__c = 'Yes';
        RMAChild.submitCase.Is_it_reproducible__c = 'Yes';
        RMAChild.submitCase.What_are_the_steps_to_reproduce_it__c = 'Yes';
        RMAChild.submitCase.If_existing_were_there_recent_changes__c = 'Yes';
        RMAChild.submitCase.specific_circumstances__c = 'Yes';
        RMAChild.submitCase.Have_services_degraded__c = 'Yes';
        RMAChild.submitCase.Is_there_a_workaround_in_place__c = 'Yes';
        RMAChild.submitCase.Is_your_network_down__c = 'Yes';
        RMAChild.submitCase.Impact__c  = 'High';
        RMAChild.submitCase.Urgency__c = 'High';
        //RMAChild.Hw_Asset = TestHw.Id;
        RMAChild.error = 'High';
        RMAChild.submitCase.Hw_Asset_Name__c   =  TestHw.Id;
        
        //RMAChild.getAssets();
        RMAChild.CancelSubmit();
        Test.StartTest();
        RMAChild.SubmitCase();
        
       
            RMAChild.submitCase.Impact__c  = '-';
            RMAChild.submitCase.Urgency__c = '-';
            RMAChild.submitCase.Hw_Asset_Name__c   = null;
            //RMAChild.Hw_Asset = '--None--';
            RMAChild.SubmitCase();
        Test.StopTest();
       
    
}



}