trigger case_events_handling on Case (before insert,before update,after insert, after update) {
      if(UtilSODOFlags.skip_caseTrigges)
        return;    
    // changes by sarvinder starts - dont forget to put check for ATI case
    
   if (Trigger.isBefore) 
   {
   system.debug('sarvinder test::This is before trigger.');
    //updating entitlements and service contracts 
   // ID ATI_CaseID = [select Name,Id from RecordType where Name = 'ATI Case'].Id;
   
   //Get Case record type info through DescribeSObjectResult - this is better as no SOQL is used.
   /* Schema.DescribeSObjectResult caseDescribe = Schema.SObjectType.Case; 
    Map<String,Schema.RecordTypeInfo> caseRtMapByName = caseDescribe.getRecordTypeInfosByName();
    Id  ATI_CaseID = caseRtMapByName.get('ATI Case').getRecordTypeId();
    Id  ATI_UserRegCaseID = caseRtMapByName.get('ATI Community Registration').getRecordTypeId();
    Id  ATI_RMAChildCaseID = caseRtMapByName.get('ATI RMA Child Case').getRecordTypeId();
    Id  ATI_RMAParentCaseID = caseRtMapByName.get('ATI RMA Parent Case').getRecordTypeId();
    Id  JP_CaseID = caseRtMapByName.get('JP_Case').getRecordTypeId();*/
    
    // Realised that getting ID by name using schema is more fragile(more chances of name getting changed than developer name) 
    // than using developerName hence using commenting above section and developername for recordtype
    
    //   List<RecordType> AllCaseRT = [SELECT Id, DeveloperName  FROM RecordType where Sobjecttype = 'Case'];
    RecordTypesSingleTon rt = RecordTypesSingleTon.getInstance();

    Id  ATI_CaseID = rt.RtMap.get('ATI_Case').ID;
    Id  ATI_UserRegCaseID = rt.RtMap.get('ATI_Community_Registration').ID;
    Id  ATI_RMAChildCaseID = rt.RtMap.get('ATI_RMA_Child_Case').ID;
    Id  ATI_RMAParentCaseID = rt.RtMap.get('ATI_RMA_Parent_Case').ID;
    Id  JP_CaseID = rt.RtMap.get('JP_Case').ID;
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
        if(CaseRT.DeveloperName == 'JP_Case')
            JP_CaseID = CaseRT.ID;    
    }
    */
    
    system.debug('ATI_CaseID ###' + ATI_CaseID + ' ATI_UserRegCaseID ###' + ATI_UserRegCaseID + ' ATI_RMAChildCaseID ###' + ATI_RMAChildCaseID + ' ATI_RMAParentCaseID ## '+  ATI_RMAParentCaseID + ' JP_CaseID ##' + JP_CaseID );
   
    List<Group>  NoNotificationgrp = [SELECT Id FROM Group where DeveloperName = 'No_Case_Assignment_Notification'];
    //Get members from No notification public group.
    List<GroupMember> No_notification_groupMembers = [SELECT UserOrGroupId FROM GroupMember  where   GroupId = :NoNotificationgrp[0].Id];
    SET<ID>  No_notification_userIDs = new SET<ID>();
    for(GroupMember GM: No_notification_groupMembers)
    {
        No_notification_userIDs.add(GM.UserOrGroupId);
    }
   
    
    
    if(Trigger.isInsert || Trigger.isUpdate)
    {
         Set<ID> Asset_ID = new Set<ID>();
         List<Entitlement> entiles = new List<Entitlement>();
         List<Service_Asset__c> serviceAssets = new List<Service_Asset__c>();
         List<ServiceContract> serContracts = new List<ServiceContract>();
         List<Warranty_Items__c> WarrntItems = new List<Warranty_Items__c>();
         Set<ID> SerAssetIDs = new Set<ID>();
         List<Asset__c> HW_Assets = new List<Asset__c>();
         //Set<ID> ProductIDs = new Set<ID>();
         system.debug('sarvinder test::capture all hardware asset ids.');
         for(case CaseUpdate: trigger.new)
         {
         
             if(No_notification_userIDs.contains(CaseUpdate.OwnerId) )
                 CaseUpdate.No_Assignment_Notification__c =  true;
             else
                 CaseUpdate.No_Assignment_Notification__c =  false;
         system.debug('####RecordTypeId::#####' + CaseUpdate.RecordTypeId);
       
         system.debug('####Hw_Asset_Name__c::#####' + CaseUpdate.Hw_Asset_Name__c);
             if(CaseUpdate.RecordTypeId == ATI_CaseID || CaseUpdate.RecordTypeId == ATI_RMAChildCaseID)
             {
                if(CaseUpdate.Hw_Asset_Name__c!=null)
                {
                    Asset_ID.add(CaseUpdate.Hw_Asset_Name__c);
                }
               // ProductIDs.add(CaseUpdate.Hw_Asset_Name__r.Product__c);
             }
         }
         
         
        system.debug('Asset_ID size :-> '+ Asset_ID.size());
        if(Asset_ID.size()>0)
        {
            WarrntItems = [select Name,id,HW_Asset__c,Warranty_Start_Date__c,Warranty_End_Date__c from Warranty_Items__c where HW_Asset__c IN :Asset_ID];
            HW_Assets = [select id,Start_Date__c,End_Date__c from Asset__c where ID IN :Asset_ID]; 
            
            serviceAssets = [select Id, Asset__c,Purchase_Information__c from Service_Asset__c where Asset__c IN :Asset_ID ];
            Map<Id, Service_Asset__c> ServAssetIds = new Map<Id, Service_Asset__c>();
            for(Service_Asset__c SA : serviceAssets )
            {
                ServAssetIds.put(SA.id,SA);
            }
           // Map<Id, Service_Asset__c> ServAssetIds = new Map<Id, Service_Asset__c>([select Id, Asset__c from Service_Asset__c where Asset__c IN :Asset_ID]);
            SerAssetIDs = ServAssetIds.keySet();
            if(SerAssetIDs.size()>0)
            {
                serContracts  = [select id ,StartDate,EndDate,Service_Asset__c,status from ServiceContract where Service_Asset__c IN :SerAssetIDs ];
            }
            
          //  integer entNum = [Select count() from Entitlement where HW_Asset__c IN :Asset_ID and Status ='Active'];
            //if(entNum > 1)
            //    entiles = [select Name,Id,HW_Asset__c,ServiceContract.Id from Entitlement where HW_Asset__c IN :Asset_ID and Status ='Active' and name != 'Default']; 
            //else
                entiles = [select Name,Id,HW_Asset__c,ServiceContract.Id,SlaProcessId  from Entitlement where HW_Asset__c IN :Asset_ID and Status ='Active' ]; 
            
            
            system.debug('All Asset ID:: ->' + Asset_ID);
            system.debug('All entitlements ::->' + entiles); 
            
           
        }
        //Entitlements_priority_mapping__c Entitl_Priority = Entitlements_priority_mapping__c.getValues(CaseUpdate.Entitlement);
        // Find all the countries in the custom setting
        string EntitlmentPriority = '';
        Map<String, Entitlements_priority_mapping__c > Entitl_Priority = Entitlements_priority_mapping__c.getAll();
        // updating entitlements
        
        Map<ID,ServiceContract> SC_Map = new Map<ID,ServiceContract>();
        for(case CaseUpdate: trigger.new)
        {
            if(CaseUpdate.RecordTypeId == ATI_CaseID && Trigger.isUpdate)
            {
             if(CaseUpdate.Hw_Asset_Name__c != Trigger.oldmap.get(CaseUpdate.id).Hw_Asset_Name__c )
                 {
                 CaseUpdate.Service_Contract__c = null;
                 CaseUpdate.Purchase_Information__c = null;
                 if(CaseUpdate.Priority == Trigger.oldmap.get(CaseUpdate.id ).Priority )
                     CaseUpdate.Priority = 'P4';
                 CaseUpdate.EntitlementId = null;
                 }
            }
         
          system.debug('CaseUpdate.RecordTypeId ::->' + CaseUpdate.RecordTypeId);   
          if(CaseUpdate.RecordTypeId == ATI_CaseID /*|| CaseUpdate.RecordTypeId == ATI_RMAChildCaseID*/)
           { 
           
           if((serviceAssets.size()>0)&& (serContracts.size()>0))
            {
                for(Service_Asset__c SA :serviceAssets)
                {
                   
                    for(ServiceContract SC :serContracts)
                    {
                        if((CaseUpdate.Hw_Asset_Name__c != Null) && (CaseUpdate.Hw_Asset_Name__c == SA.Asset__c))
                        {
                            if(SA.Id == SC.Service_Asset__c)
                            {
                                CaseUpdate.Service_Contract__c = SC.Id;
                                CaseUpdate.Purchase_Information__c = SA.Purchase_Information__c;
                                SC_Map.put(SC.Id,SC);
                            
                            }
                        }
                    }
                }
            }
            
            
            if(entiles.size()>0) // if entitlemects are associated with hardware on case
            {   
               system.debug('::Associated entitlements:::->' + entiles );
               
             //  system.debug('::Service contract status :::->' + CaseUpdate.Service_Contract__r.status);
                for(Entitlement Ent : entiles  )
                {   
                   
                    if((CaseUpdate.Hw_Asset_Name__c != Null) && (Ent.HW_Asset__c == CaseUpdate.Hw_Asset_Name__c)  )
                    {
                    
                        EntitlmentPriority = ''; 
                        system.debug('### updating entitlement here ###' + Ent.Id + '::Name:' + Ent.Name + '::Harware Asset:' + Ent.HW_Asset__c);
                        system.debug('### CaseUpdate.Service_Contract__c ###' + CaseUpdate.Service_Contract__c);
                         system.debug('### Entitlement here ###' + Ent);
                        if(CaseUpdate.Service_Contract__c != null){
                        // below if condition is added by Neha Reddy
                        
                        if(SC_Map.keyset().contains(CaseUpdate.Service_Contract__c))
                        {
                            system.debug('### SC_Map.get(CaseUpdate.Service_Contract__c).Status ###' +SC_Map.get(CaseUpdate.Service_Contract__c).Status);
                        
                            if( SC_Map.get(CaseUpdate.Service_Contract__c).Status == 'Active'){
                            
                                    if(Ent.Name != 'Default'){
                                         CaseUpdate.EntitlementId = Ent.Id;
                                         if(CaseUpdate.Priority == null)
                                               CaseUpdate.Priority = 'P4'; 
                                         if(Trigger.isInsert && Entitl_Priority.get(Ent.Name)!= null)
                                         {
                                             EntitlmentPriority = Entitl_Priority.get(Ent.Name).Priority__c;
                                              system.debug('::Associated entitlements priority:::->' + EntitlmentPriority );
                                              CaseUpdate.Priority = ((EntitlmentPriority != '') && (EntitlmentPriority < CaseUpdate.Priority)) ? EntitlmentPriority : CaseUpdate.Priority;
                                   
                                         }
                                         
                                         
                                    }
                                }
                        }
                        }
                        
                        if((CaseUpdate.EntitlementId == null) && (Ent.Name == 'Default')){
                            CaseUpdate.EntitlementId = Ent.Id;
                            if(CaseUpdate.Priority == null)
                                       CaseUpdate.Priority = 'P4'; 
                        
                        }
                         
                        system.debug('::final entitlements priority:::->' + EntitlmentPriority );
                        system.debug('::final case priority:::->' + CaseUpdate.Priority);
                    }
                }
            }
            else
            {
                if(Trigger.isInsert )//|| Trigger.isUpdate)
                 {
                    system.debug('NewCase.RecordTypeId ::->' + CaseUpdate.RecordTypeId);
                   if(CaseUpdate.RecordTypeId == ATI_CaseID || CaseUpdate.RecordTypeId == ATI_RMAChildCaseID)
                   {
                                   if(CaseUpdate.Priority == null)
                                       CaseUpdate.Priority = 'P4'; 
                                  
                  }           
                }
            }
            
            
           // if(WarrntItems.size()>0)
            //{
            
            /*if(CaseUpdate.Hw_Asset_Name__c != Null )
            {
            
             for(Asset__c HWAsset : HW_Assets){
                 if(CaseUpdate.Hw_Asset_Name__c == HWAsset.id ){
                    if((HWAsset.Start_Date__c <= date.today()) && (date.today() <= (HWAsset.End_Date__c)))
                        CaseUpdate.Warranty__c = 'Active';
                    else
                        CaseUpdate.Warranty__c = 'InActive';
                    
                    //CaseUpdate.Warranty_Start_Date__c = HWAsset.Start_Date__c;
                    //CaseUpdate.Warranty_End_Date__c = HWAsset.End_Date__c;
                   
                 }
             }
            }
            
            for(Warranty_Items__c W_Item : WarrntItems)
            {
                if((CaseUpdate.Hw_Asset_Name__c != Null) && (W_Item.HW_Asset__c == CaseUpdate.Hw_Asset_Name__c))
                {
                    if((W_Item.Warranty_Start_Date__c <= date.today()) && (date.today() <= (W_Item.Warranty_End_Date__c)))
                        CaseUpdate.Warranty__c = 'Active';
                    else
                        CaseUpdate.Warranty__c = 'InActive';
                    
                    CaseUpdate.Warranty_Start_Date__c = W_Item.Warranty_Start_Date__c;
                    CaseUpdate.Warranty_End_Date__c = W_Item.Warranty_End_Date__c;
                }
            }*/
            //}
            
           }
          
        }
       
    }

    // update TAC engineer 
    if(Trigger.isUpdate)
    {
        List<User> userList = new List<User>();
        ID CommunityProfileID = [SELECT Id,Name FROM Profile where Name = 'Customer Support Community'].Id;
        Set<ID> conIds = new Set<ID>();
        List<Case> ChildCases;
      
         for (Case c: trigger.new) {
            conIds.add(c.ContactId);
            
          }
        Map<Id, Contact> conMap = new Map<Id, Contact>([SELECT Id, Email,FirstName,LastName,ATFE_Active__c FROM Contact WHERE Id In :conIds]);
        
        
        ChildCases = [SELECT Id, Status,ParentId FROM Case WHERE ParentId IN :trigger.newMap.keyset()];
        system.debug('All Child cases are:' +  ChildCases);
         system.debug('Trigger new keyset :' + trigger.newMap.keyset());
        for(case CaseUpdate: trigger.new)
        {
        
        if(ChildCases.size()>0)
        {   
         for(case Child : ChildCases)
         {
            system.debug('details Child.Parent: ' +  Child.ParentId + ' CaseUpdate.Id: ' +  CaseUpdate.Id  + 
            'Child.Status: ' + Child.Status + 'CaseUpdate.Status ' + CaseUpdate.Status);
            if((Child.ParentId == CaseUpdate.Id) &&  (Child.Status != 'Closed' ) && (CaseUpdate.Status == 'Closed'))
            {
                  CaseUpdate.Status.addError('Please close all Child cases related to this case before closing this case.');
            }
            
         }
        }
            
         system.debug('CaseUpdate.RecordTypeId ::->' + CaseUpdate.RecordTypeId);
         if(CaseUpdate.RecordTypeId != JP_CaseID)
          {
            if(CaseUpdate.TAC_Enginer__c == NULL)
            {
                String ownId = CaseUpdate.OwnerId;    // necessary to convert ID to string
                CaseUpdate.TAC_Enginer__c = (ownId.substring(0,3) == '005' ? CaseUpdate.OwnerId : NULL);
                system.debug('TAC engineer is  --> ' + CaseUpdate.TAC_Enginer__c);
            }
          }

          /*Case oldCase = Trigger.oldMap.get(CaseUpdate.ID);
          
          // create new user for customer registration cases 
          if(CaseUpdate.RecordTypeId == ATI_UserRegCaseID && CaseUpdate.Status == 'Closed' && oldCase.Status != 'Closed')
          {
              if(CaseUpdate.User_Accepted__c == 'Yes')
              {
                       
                        //Alias = Alias.left(2);
                        //String EmailString = CaseUpdate.Contact.Email;
                        
                        Contact relatedCaseContact = conMap.get(CaseUpdate.ContactId);
                        String AliasString =  relatedCaseContact.LastName;
                        AliasString =  AliasString.left(4); 
                           
                        system.debug('Email string is::->' + relatedCaseContact.Email );    
                        User u = new User();
                        u.Username = relatedCaseContact.Email;//String.valueOf(CaseUpdate.Contact.Email);
                        u.Email = relatedCaseContact.Email;//String.valueOf(CaseUpdate.Contact.Email);
                        u.FirstName = relatedCaseContact.FirstName;
                        u.LastName = relatedCaseContact.LastName;//CaseUpdate.Contact.LastName;
                        u.CommunityNickname = CaseUpdate.CommunityNickname__c;
                        u.ProfileId = CommunityProfileID ;
                        u.ContactId = CaseUpdate.Contactid;
                        u.Alias = AliasString;//Alias;//CaseUpdate.Contact.LastName;
                        u.TimeZoneSidKey = CaseUpdate.User_Time_Zone__c;
                        u.LocaleSidKey = 'en_US';                 //hardcoding for now
                        u.EmailEncodingKey = 'ISO-8859-1';        //hardcoding
                        u.LanguageLocaleKey = 'en_US'; 

                        
                        //Database.DMLOptions dlo = new Database.DMLOptions();
                        //dlo.EmailHeader.triggerUserEmail = true;
                       // database.insert(user,dlo);
                       
                        try
                        {
                            insert u;
                            system.resetPassword(u.id, true); 
                           system.debug('inserted user' + u);
                        }
                        catch (Exception e) 
                        {
                            System.debug('The following exception has occurred creating user: ' + e.getMessage()); 
                            CaseUpdate.addError('The following exception has occurred creating user: ' + e.getMessage());
                       }
      
              
              }
              else
              {
                    Contact relatedCaseContact = conMap.get(CaseUpdate.ContactId);
                    relatedCaseContact.ATFE_Active__c = False;
                    
                    try
                        {
                            update relatedCaseContact;
                            
                        }
                        catch (Exception e) 
                        {
                            System.debug('The following exception has occurred creatinging user: ' + e.getMessage()); 
                            CaseUpdate.addError('The following exception has occurred creatinging user: ' + e.getMessage());
                       }
      
              }
          
          
          }*/
              // create first RMA item for ATI RMA Cases
          system.debug('CaseUpdate.RecordTypeId :: ' + CaseUpdate.RecordTypeId);
          
          if(CaseUpdate.RecordTypeId == ATI_CaseID  && CaseUpdate.RMA_Request__c == true && CaseUpdate.ParentId == Null)
          {
              // creating new RMA item for cases
              CaseUpdate.RecordTypeId = ATI_RMAParentCaseID;
              // RMA_item__c RMAitem = new RMA_item__c();
              Case RMAChildCase = new Case();
              
              // RMA child case should not be auto assigned and should remain with user
              /*AssignmentRule AR = new AssignmentRule();
                AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
                //Creating the DMLOptions for "Assign using active assignment rules" checkbox
                Database.DMLOptions dmlOpts = new Database.DMLOptions();
                dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
                dmlOpts.EmailHeader.triggerAutoResponseEmail = true;
                dmlOpts.EmailHeader.triggerOtherEmail = true;
                dmlOpts.EmailHeader.triggerUserEmail = true;
                RMAChildCase.setOptions(dmlOpts);*/
              
              CaseUpdate.Priority = 'P5';
              
              RMAChildCase.Accountid  = CaseUpdate.Accountid ; //Account Name
              //RMAChildCase.Account_Type__c = CaseUpdate.Account_Type__c;
              RMAChildCase.Contactid  = CaseUpdate.Contactid; //Contact Name
              RMAChildCase.Request_Title__c  = CaseUpdate.Request_Title__c; //'This is a Child case for parent case number ' + CaseUpdate.CaseNumber ;
              RMAChildCase.Description  = CaseUpdate.Description; //'This is a Child case for parent case number ' + CaseUpdate.CaseNumber ;
              
              RMAChildCase.New_or_Existing_Installation__c  = CaseUpdate.New_or_Existing_Installation__c; //New or existing
              RMAChildCase.If_existing_were_there_recent_changes__c  = CaseUpdate.If_existing_were_there_recent_changes__c; //If existing were there recent changes
              RMAChildCase.Allied_Description__c  = CaseUpdate.Allied_Description__c; //Allied description
              RMAChildCase.specific_circumstances__c  = CaseUpdate.specific_circumstances__c; //Specific circumstances
              RMAChildCase.Is_it_reproducible__c  = CaseUpdate.Is_it_reproducible__c; //Is it reproducable by user
              RMAChildCase.What_are_the_steps_to_reproduce_it__c  = CaseUpdate.What_are_the_steps_to_reproduce_it__c; //What are the steps to reproduce it
              RMAChildCase.RMA_Request__c = CaseUpdate.RMA_Request__c; //RMA request
              RMAChildCase.Is_your_network_down__c  = CaseUpdate.Is_your_network_down__c; //is the network down
              RMAChildCase.Have_services_degraded__c  = CaseUpdate.Have_services_degraded__c; //have service degraded
              RMAChildCase.Is_there_a_workaround_in_place__c  = CaseUpdate.Is_there_a_workaround_in_place__c; //is there a workaround in place
              RMAChildCase.Hw_Asset_Name__c  = CaseUpdate.Hw_Asset_Name__c; //H/w Asset
              //RMAChildCase.Warranty__c  = CaseUpdate.Warranty__c; //Warranty
              //RMAChildCase.Warranty_Start_Date__c = CaseUpdate.Warranty_Start_Date__c;
              //RMAChildCase.Warranty_End_Date__c = CaseUpdate.Warranty_End_Date__c;
              RMAChildCase.Service_Contract__c = CaseUpdate.Service_Contract__c;
              RMAChildCase.Purchase_Information__c = CaseUpdate.Purchase_Information__c;
              RMAChildCase.Impact__c= CaseUpdate.Impact__c; //Impact
              RMAChildCase.Urgency__c= CaseUpdate.Urgency__c; //Impact           
              RMAChildCase.RecordTypeId = ATI_RMAChildCaseID;           
              // RMAChildCase.RMA_Status__c = 'Awaiting Terms & Conditions';//'Awaiting Shipment'; 
              RMAChildCase.RMA_Status__c='Customer RMA Request';
              RMAChildCase.Origin = CaseUpdate.Origin;
              RMAChildCase.Priority = CaseUpdate.Priority;
              RMAChildCase.TAC_Enginer__c = CaseUpdate.TAC_Enginer__c;   
              if(caseUpdate.Billing_State__c!=null)
              RMAChildCase.Billing_State__c=CaseUpdate.Billing_State__c;
              if(caseUpdate.Billing_City__c!=null)
              RMAChildCase.Billing_City__c=CaseUpdate.Billing_City__c;
              if(caseUpdate.Billing_Country1__c!=null)
              RMAChildCase.Billing_Country1__c=CaseUpdate.Billing_Country1__c;
              if(caseUpdate.Billing_Street__c!=null)
              RMAChildCase.Billing_Street__c=CaseUpdate.Billing_Street__c;
              if(caseUpdate.Billing_Zip_Code__c!=null)
              RMAChildCase.Billing_Zip_Code__c=CaseUpdate.Billing_Zip_Code__c;
              if(caseUpdate.Billing_Address_Company_Name__c!=null)
              RMAChildCase.Billing_Address_Company_Name__c=CaseUpdate.Billing_Address_Company_Name__c;
              if(caseUpdate.Is_billing_address_different__c!=null)
              RMAChildCase.Is_billing_address_different__c=CaseUpdate.Is_billing_address_different__c;
              if(caseUpdate.Shipping_Address_Company_Name__c!=null)
              RMAChildCase.Shipping_Address_Company_Name__c=CaseUpdate.Shipping_Address_Company_Name__c;
              if(caseUpdate.Shipping_City__c!=null)
              RMAChildCase.Shipping_City__c=CaseUpdate.Shipping_City__c;
              if(caseUpdate.Shipping_Country__c!=null)
              RMAChildCase.Shipping_Country__c=CaseUpdate.Shipping_Country__c;
              if(caseUpdate.Shipping_State__c!=null)
              RMAChildCase.Shipping_State__c=CaseUpdate.Shipping_State__c;
              if(caseUpdate.Shipping_Street__c!=null)
              RMAChildCase.Shipping_Street__c=CaseUpdate.Shipping_Street__c;
              if(caseUpdate.Shipping_Zip_Code__c!=null)
              RMAChildCase.Shipping_Zip_Code__c=CaseUpdate.Shipping_Zip_Code__c;
              RMAChildCase.VAT_Number__c=CaseUpdate.VAT_Number__c;
              if(caseUpdate.Name__c!=null)
              RMAChildCase.Name__c=CaseUpdate.Name__c;
              if(caseUpdate.Phone_Number__c!=null)
              RMAChildCase.Phone_Number__c=CaseUpdate.Phone_Number__c;
              
              
              // Autofill date of purchase on child case
             // system.debug('Date of purchase on harware is::->' + CaseUpdate.Hw_Asset_Name__r.Start_Date__c);
             // RMAChildCase.Date_of_Purchase__c =  CaseUpdate.Hw_Asset_Name__r.Start_Date__c;   
                          
              RMAChildCase.ParentId = CaseUpdate.Id;
              //RMAChildCase.ownerid = CaseUpdate.ownerid;
              //CaseUpdate.Hw_Asset_Name__c = Null;
              CaseUpdate.EntitlementId = Null;
              //CaseUpdate.SlaStartDate = Null;
              //CaseUpdate.SlaExitDate  = Null;
              CaseUpdate.Service_Contract__c =Null;
               //RMAitem.Asset__c = CaseUpdate.Hw_Asset_Name__c;
               try
                {
                   
                   insert RMAChildCase  ;
                   system.debug('inserted RMAChildCase  item' + RMAChildCase  );
                }
                catch (Exception e) 
                {
                    System.debug('The following exception has occurred while creating RMAChildCase  :  '+ e.getMessage()); 
                    CaseUpdate.addError('The following exception has occurred while creating RMAChildCase  :' + e.getMessage());
               }
              
               
          
          }
                
        }
    }
    //update TAC engineer 
    
    
    //Changes by sarvinder ends
   }

}