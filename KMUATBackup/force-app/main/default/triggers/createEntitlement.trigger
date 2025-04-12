trigger createEntitlement on Service_Asset__c (after insert,after update) {
  /*  Map<Id,List<Service_Asset__c>> mapProductAsset = new Map<Id,List<Service_Asset__c>>();
    List<Service_Asset__c> serviceAssetList = new List<Service_Asset__c>();
    List<Service_Asset__c> serviceLst= new List<Service_Asset__c>();
    List<Entitlement> entitlementlst = new List<Entitlement>();
    Map<Id,List<Service_Asset__c>> hardwareAsstMap = new Map<Id,List<Service_Asset__c>>();
    List<Entitlement> noneeLst =new List<Entitlement>();
    List<Entitlement> entList =new List<Entitlement>();
    List<Entitlement> entList1 =new List<Entitlement>();
    List<Service_Asset__c> finalServiceasstlst= new List<Service_Asset__c>();
    List<Id> hardwareasstList = new List<Id>();
    String serviceproduct;
    List<id> RelAccountIds = new List<id>();
    Set<id> ServAsset_IDS = new Set<id>();
    String Region;
  
     
    
    Map<string,List<Service_Asset__c>> serviceTempStringMap = new Map<string,List<Service_Asset__c>>();
    for(Service_Asset__c sc: trigger.new){
    
        ServAsset_IDS.add(sc.id);
        
        if(sc.Service_Product__c!=null){
            if(!mapProductAsset.keySet().contains(sc.Service_Product__c)){
               mapProductAsset.put(sc.Service_Product__c,new List<Service_Asset__c>());
            }
            mapProductAsset.get(sc.Service_Product__c).add(sc);                                             
        }
    } 
  
    
   
    system.debug('mapProductAsset'+ mapProductAsset); 
    
    for(Product2 p : [select Id,Family from Product2 where Id=:mapProductAsset.keySet()]){
        if(p.Family =='SERVICE'){
           for(Service_Asset__c scv : mapProductAsset.get(p.Id)){
               serviceAssetList.add(scv);
            }  
        }
    }
    system.debug('serviceAssetList'+ serviceAssetList);  
    // hardware asset not null and earlier value not null. new value is different than earlier
    if(trigger.isupdate){
    if(serviceAssetList.size()>0){
    for(Service_Asset__c services : serviceAssetList){
        //system.debug('services.Service_Product__c'+ services.Service_Product__c +'services.Asset__c' +services.Asset__c+'**'+Trigger.oldMap.get(services.ID).asset__c);
        if(services.Service_Product__c!=null && services.Asset__c!=null &&services.asset__c !=Trigger.oldMap.get(services.ID).asset__c){
            if(Trigger.oldMap.get(services.Id).asset__c!=null){
                //hardwareasstList.add(Trigger.oldMap.get(services.ID).asset__c);
                serviceLst.add(services );
                //hardwareAsstMap.put(services.asset__c,serviceLst);
            }
        }   
    } 
    }
    system.debug('serviceLst'+ serviceLst); 
    
    
    try{
    //system.debug('***'+entLst);
    
    
        if(serviceLst !=null && serviceLst.size() >0){ 
          
            for(Service_Asset__c ser : serviceLst){
                 serviceproduct = ser.Service_Type__c;
                 Region= ser.Region__c;
                 if(serviceproduct !=null && serviceproduct !='' && region !=null && region != ''){
                      String tempString= Region + '-' + serviceproduct ;
                      system.debug('temp**'+tempString);
                      if(!serviceTempStringMap.keySet().contains(tempString)){
                        serviceTempStringMap.put(tempString,new List<Service_Asset__c>());
                    }
                    serviceTempStringMap.get(tempString).add(ser);
                }
            }
        }
        entList = [Select id,name,Service_Asset__c from Entitlement where Service_Asset__c IN :ServAsset_IDS];
        boolean EntilementExist = false;
        List<EntitlementTemplate>  productEntileMent = [Select Type, Term, slaprocessid , Name,BusinessHoursId From EntitlementTemplate where Name In :serviceTempStringMap.keySet()];
        if(productEntileMent.size() > 0){
            for(EntitlementTemplate ee : productEntileMent){
                for(Service_Asset__c ser1 : serviceTempStringMap.get(ee.Name) ){
                EntilementExist = false;
                     for(Entitlement entitl : entList ){
                         if((entitl.Service_Asset__c == ser1.id) && (entitl.Name == ee.Name)){
                                 EntilementExist = true;
                                 break;
                             }
                     }
                    if((ser1.Start_Date__c !=null) && (!EntilementExist)){
                        Region= ser1.Region__c;
                        date d=ser1.Start_Date__c;
                        date d1=d.adddays(ee.term);
                        entitlement e= new entitlement(name=ee.Name,HW_Asset__c=ser1 .Asset__c,Service_Asset__c=ser1.Id,Region__c=Region,accountid=ser1.Account__c,Term_Days__c=ee.term,startdate=d,enddate=d1,slaprocessid=ee.slaprocessid,BusinessHoursid=ee.BusinessHoursId);
                        entitlementlst.add(e);
                    }
                }
            }
        }   
        
        database.insert(entitlementlst,false);
        system.debug('****'+entitlementlst);
        
    
    
     }
     Catch(Exception e){}
     
    // Old value is null and new value is not null. new value is different from old value.
     for(Service_Asset__c services : serviceAssetList){
        if(services.Service_Product__c!=null && services.Asset__c!=null &&services.asset__c !=Trigger.oldMap.get(services.ID).asset__c){
            if(Trigger.oldMap.get(services.Id).asset__c==null){ 
                finalServiceasstlst.add(services);
                }
         }
      }
      system.debug('old value&&'+finalServiceasstlst);
      //Map<string,List<Service_Asset__c>> serviceTempStringMap = new Map<string,List<Service_Asset__c>>();
        if(finalServiceasstlst !=null && finalServiceasstlst.size() >0){ 
          
            for(Service_Asset__c ser : finalServiceasstlst){
                 serviceproduct = ser.Service_Type__c;
                 Region= ser.Region__c;
                 if(serviceproduct !=null && serviceproduct !='' && Region !=null && Region != ''){
                      String tempString= Region + '-' + serviceproduct ;
                      system.debug('temp**'+tempString);
                      if(!serviceTempStringMap.keySet().contains(tempString)){
                        serviceTempStringMap.put(tempString,new List<Service_Asset__c>());
                    }
                    serviceTempStringMap.get(tempString).add(ser);
                }
            }
        }
        
        entList1 = [Select id,name,Service_Asset__c from Entitlement where Service_Asset__c IN :ServAsset_IDS];
        boolean EntilementExist1 = false;
        List<EntitlementTemplate>  productEntileMent = [Select Type, Term, slaprocessid , Name,BusinessHoursId From EntitlementTemplate where Name In :serviceTempStringMap.keySet()];
        if(productEntileMent.size() > 0){
            for(EntitlementTemplate ee : productEntileMent){
                for(Service_Asset__c ser1 : serviceTempStringMap.get(ee.Name) ){
                EntilementExist1 = false;
                for(Entitlement entitl : entList1 ){
                     if((entitl.Service_Asset__c == ser1.id) && (entitl.Name == ee.Name)){
                         EntilementExist1 = true;
                         break;
                     }
                         
                 }
                    if((ser1.Start_Date__c !=null) &&  (!EntilementExist1) ){
                        Region= ser1.Region__c;
                        date d=ser1.Start_Date__c;
                        date d1=d.adddays(ee.term);
                        entitlement e= new entitlement(name=ee.Name,Service_Asset__c=ser1.Id,HW_Asset__c=ser1 .Asset__c,Region__c=Region,accountid=ser1.Account__c,Term_Days__c=ee.term,startdate=d,enddate=d1,slaprocessid=ee.slaprocessid,BusinessHoursid=ee.BusinessHoursId);
                        entitlementlst.add(e);
                    }
                }
            }
        }   
      
          if(entitlementlst.size()>0)
              database.insert(entitlementlst,false);
          system.debug('***inserting in update insert'+ entitlementlst);  
     
     }  
     if(trigger.isinsert){
      // Entitlement insert part
        for(Service_Asset__c services : serviceAssetList){
            if(services.Service_Product__c!=null && services.Asset__c!=null){
                finalServiceasstlst.add(services);
                }
            }
        if(finalServiceasstlst !=null && finalServiceasstlst.size() >0){ 
          
            for(Service_Asset__c ser : finalServiceasstlst){
                 serviceproduct = ser.Service_Type__c;
                 Region= ser.Region__c;
                 if(serviceproduct !=null && serviceproduct !='' && region !=null && region != ''){
                      String tempString= Region + '-' + serviceproduct ;
                      system.debug('temp**'+tempString);
                      if(!serviceTempStringMap.keySet().contains(tempString)){
                        serviceTempStringMap.put(tempString,new List<Service_Asset__c>());
                    }
                    serviceTempStringMap.get(tempString).add(ser);
                }
            }
        }
        List<EntitlementTemplate>  productEntileMent = [Select Type, Term, slaprocessid , Name,BusinessHoursId From EntitlementTemplate where Name In :serviceTempStringMap.keySet()];
        if(productEntileMent.size() > 0){
            for(EntitlementTemplate ee : productEntileMent){
                for(Service_Asset__c ser1 : serviceTempStringMap.get(ee.Name) ){
                    if(ser1.Start_Date__c !=null){
                        Region= ser1.Region__c;
                        date d=ser1.Start_Date__c;
                        date d1=d.adddays(ee.term);
                        entitlement e= new entitlement(name=ee.Name,Service_Asset__c=ser1.Id,HW_Asset__c=ser1 .Asset__c,Region__c=Region,accountid=ser1.Account__c,Term_Days__c=ee.term,startdate=d,enddate=d1,slaprocessid=ee.slaprocessid,BusinessHoursid=ee.BusinessHoursId);
                        entitlementlst.add(e);
                    }
                }
            }
        }   
          try{
          if(entitlementlst.size()>0)
          database.insert(entitlementlst,false);
          
         }
         Catch(exception ex){}
     }
      
      
     for(Service_Asset__c sc: trigger.new)
     {
         RelAccountIds.add(sc.Account__c);
     }
  if(trigger.isupdate)
    {
      list<Asset__c> HwAsset =[select Id,Account__c,H_W_assigned__c from Asset__c where Account__c IN :RelAccountIds];
      list<Asset__c> HwAsset_to_update = new list<Asset__c>();
      map<ID,Asset__c> HwAssetMap = new map<ID,Asset__c>();
      
      system.debug('OUR HARDWARE :: ' + HwAsset);
      if(HwAsset.size()>0)
      {
      for(Service_Asset__c sc: trigger.new)
      {
          for(Asset__c HW : HwAsset){
          // HW.H_W_assigned__c = FALSE;
           system.debug('HW.Id :: ' + HW.Id);
           system.debug('sc.Asset__c :: ' + sc.Asset__c);
           system.debug('trigger.oldmap.get(sc.ID).Asset__c :: ' + trigger.oldmap.get(sc.ID).Asset__c);
           
           
           
              if(HW.Id == sc.Asset__c)
              {              
                  if(HW.H_W_assigned__c == FALSE)
                  {
                       HW.H_W_assigned__c = TRUE;
                            //HwAsset_to_update.add(HW);
                             HwAssetMap.put(HW.Id,Hw);                                              
                  }                                
              } 
              
                  if(sc.Asset__c == null && trigger.oldmap.get(sc.ID).Asset__c == hw.ID)
                  {
                      HW.H_W_assigned__c = false;
                      HwAssetMap.put(HW.Id,Hw);                 
                      
                  }             
                  
               // else{
                // HW.H_W_assigned__c = FALSE;
               // }
          } 
      }
     // update HwAsset_to_update; 
         update HwAssetMap.Values(); 
     
     }
    } */
}