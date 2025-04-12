trigger ATFE_CreateCaseForAccount on Account (after insert) { 
    // To bypass the Test data records. 
    if(UtilSODOFlags.skip_caseTrigges)
        return;
    User currentUser = [select Profile.Name, Price_Book_Region__c from User where id = :userinfo.getUserId()];
    //check if the current user has the "NA" or "EMEA" price book region
    Boolean hasValidRegion = ATFE_Utility.validateUserPriceBookRegion(currentUser, new Set<String>{'NA', 'EMEA','APAC'});
    
    //if (hasValidRegion) { // modifying for community user
    if ((hasValidRegion) || (currentUser.Profile.Name == 'Customer Support Profile')) {
  
        //System.debug('Entering into Case create after Account insert :'+userInfo.getUserName());
        List<Case> casesToCreate = new List<Case>();
        Set<Id> accountRtIds = new Set<Id>();
        String currentUserRegion = currentUser.Price_Book_Region__c;
        
        //There are two ways to access record types in apex
        // 1) Through SOQL queries
        // 2) Through SObject describes
        //Using SOQL is less ideal because it adds to the number of queries of the operation
        //for(RecordType accountRt : [select id from RecordType where Name IN ('Americas Accounts', 'EMEA Accounts')]) {
            
            //accountRtIds.add(accountRt.Id);
        //}
        
        //Get Account record type info through DescribeSObjectResult
        Schema.DescribeSObjectResult accountDescribe = Schema.SObjectType.Account; 
        Map<String,Schema.RecordTypeInfo> acctRtMapByName = accountDescribe.getRecordTypeInfosByName();
        Id americasAccountsRtId =  acctRtMapByName.get('ATI Accounts').getRecordTypeId(); //returns the 18 digit id
        //Id emeaAccountsRtId =  acctRtMapByName.get('EMEA Accounts').getRecordTypeId(); //returns the 18 digit id
        accountRtIds.add(americasAccountsRtId);
        //accountRtIds.add(emeaAccountsRtId);
    
        //Get Case record type info through DescribeSObjectResult
        Schema.DescribeSObjectResult caseDescribe = Schema.SObjectType.Case; 
        Map<String,Schema.RecordTypeInfo> caseRtMapByName = caseDescribe.getRecordTypeInfosByName();
        Id americasCaseRtId = caseRtMapByName.get('Validate New Account Case').getRecordTypeId(); 
        Id naAccountOpsId = null;
        Id emeaAccountOpsId = null;
        Id apacAccountOpsId = null;
        Id KoreaAccountOpsId = null;
        Id TaiwanAccountOpsId = null;
        Id VietnamAccountOpsId = null;
        Id IndiaAccountOpsId = null;
        Id ThailandAccountOpsId = null;
        Id MalaysiaAccountOpsId = null;
        Id MyanmarAccountOpsId = null;
        Id CambodiaAccountOpsId = null;
        Id SingaporeAccountOpsId = null;
        Id PhilippinAccountOpsId = null;
        Id IndonesiaAccountOpsId = null;
        Id NewZealanAccountOpsId = null;
        Id AustraliaAccountOpsId = null;
        Id ChinaAccountOpsId = null;
        
        //System.Debug('$$$ americasAccountsRtId: ' + americasAccountsRtId); 
      for(GroupMember gm : [Select UserOrGroupId, GroupId, Group.DeveloperName From GroupMember where  Group.DeveloperName IN ('NA_Sales_Ops_Queue', 
         'EMEA_Sales_Ops_Queue',
         'APAC_Sales_Ops_Queue',
         'APAC_Korea_Support_New_Account_Owner',
         'APAC_Taiwan_Support_New_Account_Owner',
         'APAC_Vietnam_Support_New_Account_Owner',
         'APAC_India_Support_New_Account_Owner',
         'APAC_Thailand_Support_New_Account_Owner',
         'APAC_Malaysia_Support_New_Account_Owner',
         'APAC_Myanmar_Support_New_Account_Owner',
         'APAC_Cambodia_Support_New_Account_Owner',
         'APAC_Singapore_Support_New_Account_Owner',
         'APAC_Philippin_Support_New_Account_Owner',
         'APAC_Indonesia_Support_New_Account_Owner',
         'APAC_NewZealan_Support_New_Account_Owner',
         'APAC_Australia_Support_New_Account_Owner',
         'APAC_China_Support_New_Account_Owner' )])
        {
            if (gm.Group.DeveloperName == 'NA_Sales_Ops_Queue') 
            {
                naAccountOpsId = gm.UserOrGroupId;
            } 
            else if (gm.Group.DeveloperName == 'EMEA_Sales_Ops_Queue') 
            {
                emeaAccountOpsId = gm.UserOrGroupId;
            }
            else if (gm.Group.DeveloperName == 'APAC_Sales_Ops_Queue') 
            {
                apacAccountOpsId = gm.UserOrGroupId;
            }
            else if (gm.Group.DeveloperName == 'APAC_Korea_Support_New_Account_Owner') 
            {
                KoreaAccountOpsId = gm.UserOrGroupId;
            }
            else if (gm.Group.DeveloperName == 'APAC_Taiwan_Support_New_Account_Owner') 
            {
                TaiwanAccountOpsId = gm.UserOrGroupId;
            }
            else if (gm.Group.DeveloperName == 'APAC_Vietnam_Support_New_Account_Owner') 
            {
                VietnamAccountOpsId = gm.UserOrGroupId;
            }
            else if (gm.Group.DeveloperName == 'APAC_India_Support_New_Account_Owner') 
            {
                IndiaAccountOpsId = gm.UserOrGroupId;
            }
            else if (gm.Group.DeveloperName == 'APAC_Thailand_Support_New_Account_Owner') 
            {
                ThailandAccountOpsId = gm.UserOrGroupId;
            }
            else if (gm.Group.DeveloperName == 'APAC_Malaysia_Support_New_Account_Owner') 
            {
                MalaysiaAccountOpsId = gm.UserOrGroupId;
            }
            else if (gm.Group.DeveloperName == 'APAC_Myanmar_Support_New_Account_Owner') 
            {
                MyanmarAccountOpsId = gm.UserOrGroupId;
            }
            else if (gm.Group.DeveloperName == 'APAC_Cambodia_Support_New_Account_Owner') 
            {
                CambodiaAccountOpsId = gm.UserOrGroupId;
            }
            else if (gm.Group.DeveloperName == 'APAC_Singapore_Support_New_Account_Owner') 
            {
                SingaporeAccountOpsId = gm.UserOrGroupId;
            }
            else if (gm.Group.DeveloperName == 'APAC_Philippin_Support_New_Account_Owner') 
            {
                PhilippinAccountOpsId = gm.UserOrGroupId;
            }
            else if (gm.Group.DeveloperName == 'APAC_Indonesia_Support_New_Account_Owner') 
            {
                IndonesiaAccountOpsId = gm.UserOrGroupId;
            }
            else if (gm.Group.DeveloperName == 'APAC_NewZealan_Support_New_Account_Owner') 
            {
                NewZealanAccountOpsId = gm.UserOrGroupId;
            }
            else if (gm.Group.DeveloperName == 'APAC_Australia_Support_New_Account_Owner') 
            {
                AustraliaAccountOpsId = gm.UserOrGroupId;
            }
            else if (gm.Group.DeveloperName == 'APAC_China_Support_New_Account_Owner') 
            {
                ChinaAccountOpsId = gm.UserOrGroupId;
            }       
        }
        
        //CaseQueue = 00GW0000000R0xm
        for(Account acc : trigger.new){
            //check if this account has an America's or EMEA record type
            if(accountRtIds.contains(acc.RecordTypeId)) {
                Case salesOpsCase = new Case(AccountId = acc.Id,
                                           ATFE_is_Case_Create_From_Account__c = true,
                                           Type = 'New Account',
                                           Status = 'New',
                                           Priority = 'High',
                                           Description = acc.Description, 
                                           RecordTypeId = americasCaseRtId,
                                           ATFE_Submitted_By__c = UserInfo.getUserId(),
                                           Subject = 'New Account Created for Sales Ops Review',
                                           Origin = 'Salesforce',
                                           Reason = 'New Account');

                    if (acc.Region__c == 'NA') 
                   {
                    salesOpsCase.OwnerId = naAccountOpsId;

                   }
                   else if (acc.Region__c == 'EMEA' || acc.Region__c == 'CSA') 
                   {
                    salesOpsCase.OwnerId = emeaAccountOpsId;

                   }
                   else if (acc.Sub_Region__c == 'APAC') 
                   {
                    salesOpsCase.OwnerId = apacAccountOpsId;

                   }
                   else if (acc.Sub_Region__c == 'Australia') 
                   {
                    salesOpsCase.OwnerId = AustraliaAccountOpsId;

                   }
                   else if (acc.Sub_Region__c == 'Cambodia') 
                   {
                    salesOpsCase.OwnerId = CambodiaAccountOpsId;

                   }
                   else if (acc.Sub_Region__c == 'China') 
                   {
                    salesOpsCase.OwnerId = ChinaAccountOpsId;

                   }
                   else if (acc.Sub_Region__c == 'India') 
                   {
                    salesOpsCase.OwnerId = IndiaAccountOpsId;
  
                   }
                   else if (acc.Sub_Region__c == 'Indonesia') 
                   {
                    salesOpsCase.OwnerId = IndonesiaAccountOpsId;

                   }
                   else if (acc.Sub_Region__c == 'Korea') 
                   {
                    salesOpsCase.OwnerId = KoreaAccountOpsId;

                   }
                   else if (acc.Sub_Region__c == 'Malaysia') 
                   {
                    salesOpsCase.OwnerId = MalaysiaAccountOpsId;

                   }
                   else if (acc.Sub_Region__c == 'Myanmar') 
                   {
                    salesOpsCase.OwnerId = MyanmarAccountOpsId;

                   }
                   else if (acc.Sub_Region__c == 'New Zealand') 
                   {
                    salesOpsCase.OwnerId = NewZealanAccountOpsId;

                   }
                   else if (acc.Sub_Region__c == 'Philippines') 
                   {
                    salesOpsCase.OwnerId = PhilippinAccountOpsId;

                   }
                   else if (acc.Sub_Region__c == 'Singapore') 
                   {
                    salesOpsCase.OwnerId = SingaporeAccountOpsId;

                   }
                   else if (acc.Sub_Region__c == 'Taiwan') 
                   {
                    salesOpsCase.OwnerId = TaiwanAccountOpsId;

                   }
                   else if (acc.Sub_Region__c == 'Thailand') 
                   {
                    salesOpsCase.OwnerId = ThailandAccountOpsId;

                   }
                   else if (acc.Sub_Region__c == 'Vietnam') 
                   {
                    salesOpsCase.OwnerId = VietnamAccountOpsId;

                   }
                
               casesToCreate.add(salesOpsCase);
            }
        }
        
        if(casesToCreate != null && casesToCreate.size() > 0)
            try {
                insert casesToCreate;
          
            }catch(Exception e){
                System.debug('While creating cases from Account:'+e.getMessage());
        }
    }
}