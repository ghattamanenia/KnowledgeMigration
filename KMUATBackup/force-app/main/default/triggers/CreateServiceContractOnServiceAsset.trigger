trigger CreateServiceContractOnServiceAsset on Service_Asset__c (after insert,after update) 
{
if(serviceAssetcontroller.isTestRunning == true)
return ;

if(!UtilSODOFlags.skip_serviceContactTigger)
{
if (Trigger.isInsert) {

    System.debug('Entering into CreateServiceContractOnServiceAsset : '+userInfo.getUserName());
    Map<Id,PricebookEntry> priceBookMap      = new Map<Id,PricebookEntry>();
    Set<Id> accPriceBooks                    = new Set<Id>();
    List<ServiceContract> serviceContractList= new List<ServiceContract>();
    Set<String> serviceProctTypes            = new Set<String>();
    Map<String,EntitlementTemplate> etMap    = new Map<String,EntitlementTemplate>();
    map<ID,Service_Asset__c> assetsMap       = new map<ID,Service_Asset__c>([SELECT Account_Region_Product__c,ID,Start_date__c,SODO_Line_Item__r.Serial_Number__c,Service_Product__r.ATFE_Service_Product_Type__c,SODO_Line_Item__r.DO_Ship_Date__c,Service_Product__c,Asset__c,Account__r.ATFE_Price_Book__c,SAP_SODO__r.Account__c,SAP_SODO__r.Name FROM Service_Asset__c WHERE ID IN: trigger.newmap.keyset()]); 
    map<Id,Service_Asset__c> accountMap      = new map<ID,Service_Asset__C>([SELECT Account_Region_Product__c,ID,Account__c,Account__r.Region__c FROM Service_Asset__C WHERE ID IN:  trigger.newmap.keyset()]);

    // Pricebook2 stdpb                         = [Select Name, IsStandard, IsActive, Id From Pricebook2 where IsStandard= true and IsActive= true limit 1];

    List<Pricebook2> Liststdpb               = [Select Name, IsStandard, IsActive, Id From Pricebook2 where IsStandard= true and IsActive= true limit 1];
    Pricebook2 stdpb;
    if(Liststdpb.size() > 0 )
    {
        stdpb = Liststdpb[0];
    }
    
        // get service product types based on assets
         for(Service_Asset__c asset : trigger.new)
         {




             if(accountMap.containsKey(asset.ID) && accountMap.get(asset.ID).Account__r.Region__c != null)
             {
                if(assetsMap.get(asset.id).Service_Product__c != null) 
                {
                    accPriceBooks.add(assetsMap.get(asset.id).Service_Product__c);
                    serviceProctTypes.add(accountMap.get(asset.ID).Account__r.Region__c + '-'+assetsMap.get(asset.id).Service_Product__r.ATFE_Service_Product_Type__c);
                }                                  
             }
                
         }
         system.debug('serviceProctTypes****'+serviceProctTypes);
         // get entitelement tempaltes from service product types
         List<EntitlementTemplate>  productEntileMent ;
          for(EntitlementTemplate et : [Select Type, Term, Id , Name From EntitlementTemplate where name in :serviceProctTypes])
          {
            etMap.put(et.Name,et);
          }

         // get pricebook entries from product Ids 
         if(accPriceBooks != null && accPriceBooks.size() > 0)
         {              
               for(PricebookEntry pb : [Select UnitPrice, Product2Id, Pricebook2.Name, Pricebook2Id From PricebookEntry where product2Id in :accPriceBooks and isActive = true order by CreatedDate desc])
               {
                    if(!priceBookMap.containskey(pb.Product2Id))
                        priceBookMap.put(pb.Product2Id,pb);
               }  
          }
          // Insert service contracts based on Service Assets
          list<ServiceContract> scList = new list<ServiceContract>();
          
            for(Service_Asset__c  oAsset: trigger.new)
            {                 
               // if(oAsset.SAP_SODO__c != null) 
                {
                    Service_Asset__c  assetObj= assetsMap.get(oAsset.id); 
                    ServiceContract  oContract= new ServiceContract();  
                    
                    if(etMap.containsKey(assetObj.Account_Region_Product__c) && etMap.get(assetObj.Account_Region_Product__c) != null )
                    {
                     if(assetObj.SODO_Line_Item__c != null && assetObj.SODO_Line_Item__r.DO_Ship_Date__c != null)
                     {
                        Integer term     = etMap.get(assetObj.Account_Region_Product__c).Term;
                        system.debug('Term is ;;;->' + term      );

                        Date  endDate    = assetObj.SODO_Line_Item__r.DO_Ship_Date__c.addDays(term);
                        if(endDate!= NULL )
                            oContract.EndDate= endDate ;
                      }      
                    
                    if(assetObj.Start_date__c != null && assetObj.SODO_Line_Item__c == null)
                        {
                            Integer term2     = etMap.get(assetObj.Account_Region_Product__c).Term;
                            Date  endDate2    = assetObj.Start_date__c.addDays(term2);
                            oContract.EndDate = endDate2 ;
                        }
                  }                                                        
                    if(assetObj.Asset__c != null)
                        oContract.Asset__c    =   assetObj.Asset__c;
                    oContract.Service_Asset__c=   oAsset.ID; 
                  //  oContract.Name            =   'SC' + '-' + Date.today().year() + '-' + assetObj.SODO_Line_Item__r.Serial_Number__c;
                   oContract.Name            =   'SC' + '-' + Date.today().year();
                   if(oAsset.SAP_SODO__c != null)
                        oContract.SAP_SODO__c     = oAsset.SAP_SODO__c;
                    
                    if(assetObj.SODO_Line_Item__c != null)    
                        oContract.StartDate       = assetObj.SODO_Line_Item__r.DO_Ship_Date__c;
                    else
                        oContract.StartDate       = assetObj.Start_date__c;
                    if(assetsMap.get(oAsset.ID).SAP_SODO__c != null)
                        oContract.AccountID       = assetsMap.get(oAsset.ID).SAP_SODO__r.Account__c;
                    else
                        oContract.AccountID       = assetObj.Account__C;    
                    oContract.Pricebook2Id    = (assetObj.Service_Product__c != null && priceBookMap.containsKey(assetObj.Service_Product__c)) ? priceBookMap.get(assetObj.Service_Product__c).Pricebook2Id : stdpb.id ;                  
                    serviceContractList.add(oContract);         
                             
                }   
              }   
                    System.debug('contracts:'+serviceContractList);

        insert serviceContractList;
   }
   if (Trigger.isAfter)
   {
   
    System.debug('Entering into CreateServiceContractOnServiceAsset : '+userInfo.getUserName());
    Map<Id,PricebookEntry> priceBookMap      = new Map<Id,PricebookEntry>();
    Set<Id> accPriceBooks                    = new Set<Id>();
    List<ServiceContract> serviceContractList= new List<ServiceContract>();
    Set<String> serviceProctTypes            = new Set<String>();
    Map<String,EntitlementTemplate> etMap    = new Map<String,EntitlementTemplate>();
    map<ID,Service_Asset__c> assetsMap       = new map<ID,Service_Asset__c>([SELECT Account_Region_Product__c,ID,Start_date__c,SODO_Line_Item__r.Serial_Number__c,Service_Product__r.ATFE_Service_Product_Type__c,SODO_Line_Item__r.DO_Ship_Date__c,Service_Product__c,Asset__c,Account__r.ATFE_Price_Book__c,SAP_SODO__r.Account__c,SAP_SODO__r.Name FROM Service_Asset__c WHERE ID IN: trigger.newmap.keyset()]); 
    map<Id,Service_Asset__c> accountMap      = new map<ID,Service_Asset__C>([SELECT Account_Region_Product__c,ID,Account__c,Account__r.Region__c FROM Service_Asset__C WHERE ID IN:  trigger.newmap.keyset()]);

    //Pricebook2 stdpb                         = [Select Name, IsStandard, IsActive, Id From Pricebook2 where IsStandard= true and IsActive= true limit 1];


      /* Case Update added by sarvinder - start*/
      /*Set<Id> HardwareAssetIds  = new Set<Id>();
      for(Service_Asset__c asset : trigger.new)
      {
          HardwareAssetIds.add(asset.Asset__c);
      }
      if(HardwareAssetIds.size() > 0)
      {
         List<Case> AllrelatedCases = [Select Id ,Hw_Asset_Name__c  From Case where Hw_Asset_Name__c in :HardwareAssetIds];
        if(AllrelatedCases.size() > 0)
        {
            //update AllrelatedCases;

            try
            {
             update AllrelatedCases;
            system.debug('AllrelatedCases :' + AllrelatedCases);
            }
            catch (Exception e) 
            {
              System.debug('The following exception has occurred updating case: ' + e.getMessage()); 
              //asset.addError('The following exception has occurred updating case: ' + e.getMessage());
            }
        }

      }*/
     
      /* Case Update added by sarvinder - end*/


        // get service product types based on assets
         for(Service_Asset__c asset : trigger.new)
         {
             if(accountMap.containsKey(asset.ID) && accountMap.get(asset.ID).Account__r.Region__c != null)
             {
                if(assetsMap.get(asset.id).Service_Product__c != null) 
                {
                    accPriceBooks.add(assetsMap.get(asset.id).Service_Product__c);
                    serviceProctTypes.add(accountMap.get(asset.ID).Account__r.Region__c + '-'+assetsMap.get(asset.id).Service_Product__r.ATFE_Service_Product_Type__c);
                }                                  
             }
                
         }
         system.debug('serviceProctTypes****'+serviceProctTypes);
         // get entitelement tempaltes from service product types
         List<EntitlementTemplate>  productEntileMent ;
          for(EntitlementTemplate et : [Select Type, Term, Id , Name From EntitlementTemplate where name in :serviceProctTypes])
          {
            etMap.put(et.Name,et);

          }

         // get pricebook entries from product Ids 
         if(accPriceBooks != null && accPriceBooks.size() > 0)
         {              
               for(PricebookEntry pb : [Select UnitPrice, Product2Id, Pricebook2.Name, Pricebook2Id From PricebookEntry where product2Id in :accPriceBooks and isActive = true order by CreatedDate desc])
               {
                    if(!priceBookMap.containskey(pb.Product2Id))
                        priceBookMap.put(pb.Product2Id,pb);
               }  
          }
          // Insert service contracts based on Service Assets
          list<ServiceContract> scList = new list<ServiceContract>();
          
          /* Added by Neha to avoid SOQL queries in below piece of code... 
          
          */
            map<id,id> ServAsstIdServContractIdMap = new Map<Id,Id>();
            for(ServiceContract oSContract : [SELECT Pricebook2Id,AccountID,StartDate,ID,EndDate,Asset__c,Service_Asset__c,Name,SAP_SODO__c  FROM ServiceContract  WHERE Service_Asset__c IN :trigger.newMap.keyset()])
            {
                ServAsstIdServContractIdMap.put(oSContract.Service_Asset__c,oSContract.Id);
            }
               
          
          
            for(Service_Asset__c  oAsset: trigger.new)
            {                 
              
               if(ServAsstIdServContractIdMap.keyset().contains(oAsset.Id))
               {
                    Service_Asset__c  assetObj= assetsMap.get(oAsset.id); 
                    ServiceContract  oContract= new ServiceContract(id=ServAsstIdServContractIdMap.get(oAsset.Id));  
                    
                    if(etMap.containsKey(assetObj.Account_Region_Product__c) && etMap.get(assetObj.Account_Region_Product__c) != null )
                    {
                     if(assetObj.SODO_Line_Item__c != null && assetObj.SODO_Line_Item__r.DO_Ship_Date__c != null)
                     {
                        Integer term     = etMap.get(assetObj.Account_Region_Product__c).Term;
                        system.debug('Term is ;;;->' + term      );

                        Date  endDate    = assetObj.SODO_Line_Item__r.DO_Ship_Date__c.addDays(term);
                        if(endDate!= NULL )

                        {
                            if(oAsset.End_Date__c != null && oAsset.End_Date__c != endDate )
                            {
                                            oContract.EndDate= oAsset.End_Date__c ;
                            }
                            else
                            {

                            oContract.EndDate= endDate ;
                            }              
                        }
                      }      
                    
                    if(assetObj.Start_date__c != null && assetObj.SODO_Line_Item__c == null)
                        {
                            Integer term2     = etMap.get(assetObj.Account_Region_Product__c).Term;
                            Date  endDate2    = assetObj.Start_date__c.addDays(term2);
                            if(oAsset.End_Date__c != null && oAsset.End_Date__c != endDate2 )
                            {
                             oContract.EndDate= oAsset.End_Date__c ;        
                            }
                            else
                            {
                            oContract.EndDate= endDate2 ;

                            }
                        }
                  }                                                        
                    if(assetObj.Asset__c != null)
                        oContract.Asset__c    =   assetObj.Asset__c;
                    oContract.Service_Asset__c=   oAsset.ID; 
                  //  oContract.Name            =   'SC' + '-' + Date.today().year() + '-' + assetObj.SODO_Line_Item__r.Serial_Number__c;
                   oContract.Name            =   'SC' + '-' + Date.today().year();
                   if(oAsset.SAP_SODO__c != null)
                        oContract.SAP_SODO__c     = oAsset.SAP_SODO__c;
                    
                    if(assetObj.SODO_Line_Item__c != null)    
                        oContract.StartDate       = assetObj.SODO_Line_Item__r.DO_Ship_Date__c;
                    else
                        oContract.StartDate       = assetObj.Start_date__c;
                    if(assetsMap.get(oAsset.ID).SAP_SODO__c != null)
                        oContract.AccountID       = assetsMap.get(oAsset.ID).SAP_SODO__r.Account__c;
                    else
                        oContract.AccountID       = assetObj.Account__C;    

                    if(trigger.isInsert)   {
                        if(assetObj.Service_Product__c != null && priceBookMap.containsKey(assetObj.Service_Product__c)){
                            oContract.Pricebook2Id    = priceBookMap.get(assetObj.Service_Product__c).Pricebook2Id;
                        }
                    }
                    serviceContractList.add(oContract);         
                             
               } 
              }   
                    System.debug('update contracts:'+serviceContractList);



        update serviceContractList;
      if(Test.isRunningTest() == true)
       {
                    serviceAssetcontroller.isTestRunning = true;                      
       }


     
   }


    
}   
   
}