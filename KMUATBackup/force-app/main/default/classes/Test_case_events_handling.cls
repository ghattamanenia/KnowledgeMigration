@isTest
private class Test_case_events_handling {
    static testMethod void validate_ATI_Case_events() {
    
            // Channelinsight.CI_TEST_TestUtils.createBaseInstallData();
              RecordTypesSingleTon rt = RecordTypesSingleTon.getInstance();
               
              Id AccRCTypeId = rt.RtMap.get('Americas_Accounts').ID;
              Id ConRCTypeId = rt.RtMap.get('Americas_Contacts').ID;   
              //List<RecordType> AllCaseRT = [SELECT Id, DeveloperName  FROM RecordType where Sobjecttype = 'Case'];
              
                Id  ATI_CaseID =  rt.RtMap.get('ATI_Case').ID;
                Id  ATI_UserRegCaseID = rt.RtMap.get('ATI_Community_Registration').ID;
                Id  ATI_RMAChildCaseID =rt.RtMap.get('ATI_RMA_Child_Case').ID;
                Id  ATI_RMAParentCaseID = rt.RtMap.get('ATI_RMA_Parent_Case').ID; 
                
                /*
                for(RecordType CaseRT : AllCaseRT )
                {
                    if(CaseRT.DeveloperName == 'ATI_Case')
                        ATI_CaseID = CaseRT.ID;
                    if(CaseRT.DeveloperName == 'ATI_Community_Registration')
                        ATI_UserRegCaseID = CaseRT.ID;
                    if(CaseRT.DeveloperName == 'ATI_RMA_Child_Case')
                        ATI_RMAChildCaseID = CaseRT.ID;
                    if(CaseRT.DeveloperName == 'ATI_RMA_Parent_Case')
                        ATI_RMAParentCaseID = CaseRT.ID;
                }
                */
              // insert test product - type product
              Product2 newtestproduct = new Product2(ATFE_NA__c = true, ATFE_PartStatusDesc__c = 'Active-Active' ,ATFE_ProductRegion__c   = 'NA',
              ATFE_ProductType__c = 'OPTICAL', ATFE_Status__c = 'ACTIVE', CurrencyIsoCode = 'USD', 
              Description  = '500m 850nm 1000Base-SX Small Form Pluggable - Hot Swappable',
              Family = 'PRODUCT',IsActive = true,Name = 'AT-SPSX',ProductCode = '990-001201-00',Warranty__c = 'NA-NA-C-1825'
              );
              
              insert newtestproduct ;
              System.assert(newtestproduct.Id!= null);
             
             // insert test product - type service
              Product2 newtestservice = new Product2(ATFE_NA__c = true, ATFE_PartStatusDesc__c = 'Active-Active' ,ATFE_ProductRegion__c   = 'NA',
              ATFE_ProductType__c = 'T - SERVICE', ATFE_Status__c = 'ACTIVE', CurrencyIsoCode = 'USD', ATFE_Service_Product_Type__c='NCB-1',
              Description  = 'PS Bundle Serv 40 Hours',
              Family = 'SERVICE',IsActive = true,Name = 'AT-EFIH-40',ProductCode = '960-20201-40'
              );
              
              insert newtestservice ;
              System.assert(newtestservice.Id!= null);
              // insert test hardware asset.
              
              // Set up the Account record.
              Account Acc = new Account(Name='Test Account',ATFE_AccountType__c = 'End Customer',Region__c = 'NA',Sub_Region__c = 'NA',
              ATFE_SalesOrgName__c = 'Sales Ops',website = 'www.none.com.in',RecordTypeId = AccRCTypeId,ATFE_VerticalMarketInit__c = 'Other',
              BillingCity = 'San Jose',BillingCountry = 'United States', BillingPostalCode  = '95134', BillingState = 'California',
              BillingStreet = 'Orchard Pkwy', ShippingCity = 'San Jose',ShippingCountry = 'United States', ShippingPostalCode = '95134', 
              ShippingState = 'California', ShippingStreet = 'Orchard Pkwy' );
              insert Acc ;
              
              System.assert(Acc.Id!= null);
              
              // test contact
              Contact Con = new Contact(FirstName  = 'TestFirstName', LastName  = 'TestLastName',RecordTypeId  = ConRCTypeId ,AccountId  = Acc.id, Email = 'none@none.com',
              Phone  = '+9140 80000000' );
              insert Con;
              System.assert(Con.Id!= null);
              
              //new Test hw Asset
              Asset__c TestHW = new Asset__c( Name = 'AT-SPSX' , Product__c = newtestproduct.id, Serial_Number__c = 'A234567890122345',
              Account__c = Acc.Id,  Start_Date__c = date.Today());
              insert TestHW;
              System.assert(TestHW.Id!= null);
              // new warranty code
              Warranty__c WarrantyCode = new Warranty__c(Description__c = '2 Years Warranty',Duration_Days__c = 730.00,Name = 'NA-NA-A-730',Region__c = 'NA',Sub_Region__c = 'NA',Warranty_Type__c = 'K'); 
              insert WarrantyCode ;
              System.assert(WarrantyCode.Id!= null);
              //new warranty item
              Warranty_Items__c W_Item = new Warranty_Items__c(Duration__c = WarrantyCode.Duration_Days__c ,HW_Asset__c = TestHW.Id ,
              Name = WarrantyCode.Name ,Region__c =  WarrantyCode.Region__c,Sub_Region__c = WarrantyCode.Sub_Region__c,
              Warranty_End_Date__c = date.today().addDays(730),Warranty_Start_Date__c = date.today(),Warranty__c = WarrantyCode.Id);
              insert W_Item;
              System.assert(W_Item.Id!= null);
              
              //new service Asset
              UtilSODOFlags.skip_serviceAssetTrigger = true;
              UtilSODOFlags.skip_serviceContactTigger = true;
              Service_Asset__c TestSW = new Service_Asset__c(Account__c =Acc.Id ,Asset__c = TestHW.Id,Name = 'AT-EFIH-40',Service_Product__c = newtestservice.Id,Start_Date__c =  date.today());
              insert TestSW ;
              System.assert(TestSW.Id!= null);
              
             /* UtilSODOFlags.skip_assetAfterInsert = true;
              UtilSODOFlags.skip_serviceAssetTrigger = true;
              UtilSODOFlags.skip_assetAfterInsert = true;
              UtilSODOFlags.skip_assetAfterUpdate = true;  
              UtilSODOFlags.skip_serviceContactTigger = true;
              UtilSODOFlags.skip_ATFE_SendChatterCaseMessageTriggerOnCase = true;
              UtilSODOFlags.skip_businesshourTriggerOnCase = true;
              UtilSODOFlags.skip_createWarrantyTriggerOnHWAsset = true;
              UtilSODOFlags.skip_createWarrantyTriggerOnHWAsset = true;*/
              
              Case ATI_CASE = new Case();   
              ATI_CASE.Accountid  = Acc.Id ; //Account Name
              ATI_CASE.Contactid  = Con.Id; //Contact Name
              ATI_CASE.Request_Title__c  = 'Test Request'; //Customer title
              ATI_CASE.Description  = 'Test description';  //Customer description
              ATI_CASE.Hw_Asset_Name__c = TestHW.Id;
              //ATI_CASE.Warranty__c  = W_Item.id; //Warranty
              ATI_CASE.Impact__c= 'High'; //Impact
              ATI_CASE.Urgency__c= 'High'; //Impact           
              ATI_CASE.RecordTypeId = ATI_CaseID;
              insert  ATI_CASE; 
              System.assert( ATI_CASE.Id!= null);  
              ATI_CASE.RMA_Request__c = true;
              
              Test.startTest();
              update ATI_CASE;
              System.assert( ATI_CASE.RMA_Request__c == true); 
              Test.stopTest();
             
              
    }
    @IsTest(SeeAllData=true)
    static void validate_UserReg_Case_events() {
               //Channelinsight.CI_TEST_TestUtils.createBaseInstallData();
              //Get Case record type info through DescribeSObjectResult - this is better as no SOQL is used.
              Schema.DescribeSObjectResult caseDescribe = Schema.SObjectType.Case; 
              Map<String,Schema.RecordTypeInfo> caseRtMapByName = caseDescribe.getRecordTypeInfosByName();
              Id  ATI_UserRegCaseID = caseRtMapByName.get('ATI Community Registration').getRecordTypeId();
              Id  ATI_RMAChildCaseID = caseRtMapByName.get('ATI RMA Child Case').getRecordTypeId(); 
              Schema.DescribeSObjectResult AccDescribe = Schema.SObjectType.Account; 
              Map<String,Schema.RecordTypeInfo> AccRtMapByName = AccDescribe.getRecordTypeInfosByName();       
              Id AccRCTypeId = AccRtMapByName.get('ATI Accounts').getRecordTypeId();
              
              Schema.DescribeSObjectResult ConDescribe = Schema.SObjectType.Contact; 
              Map<String,Schema.RecordTypeInfo> ConRtMapByName = ConDescribe.getRecordTypeInfosByName();
              Id ConRCTypeId = ConRtMapByName.get('Americas Contacts').getRecordTypeId();
             
              
              // Set up the Account record.
              Account Acc = new Account(Name='Test Account',ATFE_AccountType__c = 'End Customer',Region__c = 'NA',Sub_Region__c = 'NA',
              ATFE_SalesOrgName__c = 'Sales Ops',website = 'www.none.com.in',RecordTypeId = AccRCTypeId,ATFE_VerticalMarketInit__c = 'Other',
              BillingCity = 'San Jose',BillingCountry = 'United States', BillingPostalCode  = '95134', BillingState = 'California',
              BillingStreet = 'Orchard Pkwy', ShippingCity = 'San Jose',ShippingCountry = 'United States', ShippingPostalCode = '95134', 
              ShippingState = 'California', ShippingStreet = 'Orchard Pkwy' );
              insert Acc ;
              
              System.assert(Acc.Id!= null);
              
              // test contact
              Contact Con = new Contact(FirstName  = 'TestFirstName', LastName  = 'TestLastName',RecordTypeId  = ConRCTypeId ,AccountId  = Acc.id, Email = 'none90876666@none.com',
              Phone  = '+9140 80000000' );
              insert Con;
              System.assert(Con.Id!= null);
              
             
              
              Case UserReg_CASE = new Case();   
             // UserReg_CASE.Accountid  = Acc.Id ; //Account Name
             // UserReg_CASE.Contactid  = Con.Id; //Contact Name
              UserReg_CASE.Request_Title__c  = 'user reg Test Request'; //Customer title
              UserReg_CASE.Description  = 'user reg Test description';  //Customer description
              UserReg_CASE.RecordTypeId = ATI_UserRegCaseID;
              UserReg_CASE.CommunityNickname__c = 'nick';
              UserReg_CASE.User_Time_Zone__c = 'Asia/Kuala_Lumpur';
               UserReg_CASE.Company_Name__c = 'Test1';
               UserReg_CASE.First_Name__c = 'T1';
               UserReg_CASE.Last_Name__c = 'T2';
               UserReg_CASE.Phone__c= '+1(566)548-4835';
               UserReg_CASE.Website__c= '12121.com';
               UserReg_CASE.email__c = 't1t2@gmail.com';
               UserReg_CASE.Street__c = '123';
               UserReg_CASE.City__c = 'San jose';
               UserReg_CASE.State_Province__c = 'CA';
               UserReg_CASE.Zip_Postal_Code__c = '95051';
               UserReg_CASE.Country__c = 'United States';
               UserReg_CASE.User_Time_Zone__c = 'Asia/Kuala_Lumpur';
               UserReg_CASE.CountryISOCode__c = 'US';
              
              
              
              
              insert  UserReg_CASE; 
              System.assert( UserReg_CASE.Id!= null); 
              
             UserReg_CASE.Status = 'Closed';
              UserReg_Case.User_Accepted__c = 'Yes'; 
              
              Test.startTest();
              
                  update UserReg_CASE; 
                 /* System.assert( UserReg_CASE.Status == 'Closed'); 
                  UserReg_CASE.Status = 'New';
                  update UserReg_CASE; 
                  System.assert( UserReg_CASE.Status == 'New'); 
                  UserReg_CASE.Status = 'Closed';
                  UserReg_Case.User_Accepted__c = 'No'; 
                  update UserReg_CASE;
                  
                  
                  UserReg_CASE.RecordTypeId = ATI_RMAChildCaseID  ;
                  UserReg_CASE.Status = 'New';
                  UserReg_CASE.Impact__c= 'Medium'; //Impact
                  UserReg_CASE.Urgency__c= 'Medium'; //Urgency
                 // update UserReg_CASE;
                  UserReg_CASE.Impact__c= 'Low'; //Impact
                  UserReg_CASE.Urgency__c= 'Medium'; //Urgency
                 // update UserReg_CASE;
                  UserReg_CASE.Impact__c= 'High'; //Impact
                  UserReg_CASE.Urgency__c= 'Low'; //Urgency
                  update UserReg_CASE;
                  UserReg_CASE.Impact__c= 'Medium'; //Impact
                  UserReg_CASE.Urgency__c= 'Low'; //Urgency
                  update UserReg_CASE;
                  UserReg_CASE.Impact__c= 'Low'; //Impact
                  UserReg_CASE.Urgency__c= 'Low'; //Urgency
                 // update UserReg_CASE;
                  //System.assert( UserReg_CASE.Status == 'Closed');
              
              Test.stopTest();
              UserReg_CASE.Status = 'New';
              UserReg_Case.User_Accepted__c = 'No';
              UserReg_CASE.RecordTypeId = ATI_UserRegCaseID;
             // update UserReg_CASE;  
              UserReg_CASE.User_Time_Zone__c = 'problem';
              UserReg_CASE.Status = 'Closed';
              UserReg_Case.User_Accepted__c = 'Yes'; 
              try{
                  update UserReg_CASE; 
              } 
               catch (DmlException e) {
               System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  , 
                        e.getDmlStatusCode(0));
               
               }*/
              
            // System.DmlException: Update failed. First exception on row 0 with id 500g0000002WBK6AAO; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, The following exception has occurred creating user: Insert failed. First exception on row 0; first error: INVALID_OR_NULL_FOR_RESTRICTED_PICKLIST, Time Zone: bad value for restricted picklist field: problem: [TimeZoneSidKey]: []
    }
}