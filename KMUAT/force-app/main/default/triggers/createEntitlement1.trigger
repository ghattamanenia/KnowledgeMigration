trigger createEntitlement1 on Service_Asset__c (after insert, after update) {
    
    List<Entitlement> entitlementlst = new List<Entitlement>();
    List<Entitlement> entList =new List<Entitlement>();
    List<Service_Asset__c> finalServiceasstlst = new  List<Service_Asset__c>();
    List<Service_Asset__c> dateUpdateServAssttlst = new  List<Service_Asset__c>();
    List<Service_Asset__c> SAwithTemp = new  List<Service_Asset__c>();
    Set<ID> dateupdateservIDs = new Set<Id>();
    Set<ID> ServAsset_IDS = new Set<Id>();
    List<id> RelAccountIds = new List<id>();
    Set<string> ServiceTypeSet = new Set<string>();
    String servicetype;
    String Region;
    boolean  EntilementExist = false;
    
    // if no hardware the no entitlement..... "Service_Product__c" will always be there just putting as precaution
    if(trigger.isinsert){
    for(Service_Asset__c services : trigger.new){
            if(services.Service_Product__c!=null && services.Asset__c!=null){
                finalServiceasstlst.add(services);
                }
      }
        system.debug('### Insert trigger finalServiceasstlst' + finalServiceasstlst);
        
        // make entitlement template names from region and service type
       for(Service_Asset__c ser : finalServiceasstlst){
              servicetype = ser.Service_Type__c;
              Region= ser.Region__c;
            if(servicetype !=null && servicetype !='' && region !=null && region != ''){
                ServiceTypeSet.add( Region + '-' + servicetype) ;
                SAwithTemp.add(ser);
            }
       }
    system.debug('## service type set ##' + ServiceTypeSet);
    // get all entitlements for the service which got inserted.
   List<EntitlementTemplate>  Ent_templt = new   List<EntitlementTemplate>();
   Ent_templt = [Select Type, Term, slaprocessid , Name,BusinessHoursId From EntitlementTemplate where Name In :ServiceTypeSet];
        
    string Rgn,temSAEntname ;
    date st_dt,en_dt;
    
    if(Ent_templt.size() > 0){
          for(Service_Asset__c SA : SAwithTemp ){ // loop through all service assets one by one
             temSAEntname = SA.Region__c + '-' + SA.Service_Type__c; //make a temp entitlement template name from service asset fields
          for(EntitlementTemplate ET : Ent_templt){   // loop through all entitlement templates
                   if( temSAEntname == ET.name){ //match with service asset
                       if(SA.Start_Date__c != null){ //if start date is not null on service asset then create an enetitlement.
                            Rgn= SA.Region__c;
                            st_dt = SA.Start_Date__c;
                           if(SA.End_Date__c != null)
                               en_dt = SA.End_Date__c;
                            else
                                en_dt = st_dt.adddays(ET.term);
                            entitlement e= new entitlement(name=ET.Name,Service_Asset__c=SA.Id,HW_Asset__c=SA .Asset__c,Region__c=Region,accountid=SA.Account__c,Term_Days__c=ET.term,
                                                           startdate=st_dt,enddate=en_dt,slaprocessid=ET.slaprocessid,BusinessHoursid=ET.BusinessHoursId);
                            entitlementlst.add(e);
                           
                       }                       
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
   if(trigger.isupdate){
    for(Service_Asset__c services : trigger.new){
           if(services.Service_Product__c!=null && services.Asset__c!=null && services.asset__c !=Trigger.oldMap.get(services.ID).asset__c){
                finalServiceasstlst.add(services);
                ServAsset_IDS.add(services.id);
                }
      }
       system.debug('### update trigger finalServiceasstlst' + finalServiceasstlst);
       entList = [Select id,name,Service_Asset__c from Entitlement where Service_Asset__c IN :ServAsset_IDS];
       
       // make entitlement template names from region and service type
       for(Service_Asset__c ser : finalServiceasstlst){
              servicetype = ser.Service_Type__c;
              Region= ser.Region__c;
            if(servicetype !=null && servicetype !='' && region !=null && region != ''){
                ServiceTypeSet.add( Region + '-' + servicetype) ;
                SAwithTemp.add(ser);
            }
       }
    system.debug('## service type set ##' + ServiceTypeSet);
    // get all entitlements for the service which got inserted.
   List<EntitlementTemplate>  Ent_templt = new   List<EntitlementTemplate>();
   Ent_templt = [Select Type, Term, slaprocessid , Name,BusinessHoursId From EntitlementTemplate where Name In :ServiceTypeSet];
        
    string Rgn,temSAEntname ;
    date st_dt,en_dt;
    
    if(Ent_templt.size() > 0){
          for(Service_Asset__c SA : SAwithTemp ){ // loop through all service assets one by one
             temSAEntname = SA.Region__c + '-' + SA.Service_Type__c; //make a temp entitlement template name from service asset fields
             
          for(EntitlementTemplate ET : Ent_templt){   // loop through all entitlement templates
                EntilementExist = false;
               for(Entitlement entitl : entList ){
                         if((entitl.Service_Asset__c == SA.id) && (entitl.Name == ET.Name)){
                                 EntilementExist = true;
                                 break;
                             }
                     }
                   if( (temSAEntname == ET.name) && (!EntilementExist)){ //match with service asset
                       if(SA.Start_Date__c != null){ //if start date is not null on service asset then create an enetitlement.
                            Rgn= SA.Region__c;
                            st_dt = SA.Start_Date__c;
                           if(SA.End_Date__c != null)
                               en_dt = SA.End_Date__c;
                            else
                                en_dt = st_dt.adddays(ET.term);
                            entitlement e= new entitlement(name=ET.Name,Service_Asset__c=SA.Id,HW_Asset__c=SA .Asset__c,Region__c=Region,accountid=SA.Account__c,Term_Days__c=ET.term,
                                                           startdate=st_dt,enddate=en_dt,slaprocessid=ET.slaprocessid,BusinessHoursid=ET.BusinessHoursId);
                            entitlementlst.add(e);
                           
                       }                       
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
    
    
   
    
       if(trigger.isupdate){
            for(Service_Asset__c services : trigger.new){
                if((services.Start_Date__c !=Trigger.oldMap.get(services.ID).Start_Date__c) || (services.End_Date__c != Trigger.oldMap.get(services.ID).End_Date__c)){
                        dateUpdateServAssttlst.add(services);        
                        dateupdateservIDs.add(services.id);
                }
            } 
            List<Entitlement> lstEnt = new List<Entitlement>();
              List<Entitlement> finalupdate  = new List<Entitlement>();
            lstEnt = [Select Id,StartDate,EndDate,Service_Asset__c,Term_Days__c from Entitlement where status = 'Active' and Service_Asset__c In : dateupdateservIDs];
            for(Service_Asset__c asst: dateUpdateServAssttlst){   
               for(Entitlement updateEntitl : lstEnt ){
                   if(updateEntitl.Service_Asset__c ==asst.Id){
                       if(asst.Start_Date__c!= null)
                             updateEntitl.Startdate=asst.Start_Date__c;
                        if(asst.End_Date__c!= null)
                            updateEntitl.EndDate=asst.End_Date__c;   
                       else{
                           integer day = (integer)updateEntitl.Term_Days__c;
                           updateEntitl.EndDate =  updateEntitl.Startdate.adddays(day);
                       }
                       finalupdate.add(updateEntitl);                          
                   }
               }
                
            }
        
          try{
          if(entitlementlst.size()>0)
          database.insert(finalupdate,false);
         }
         Catch(exception ex){}
    
       }
    
    if(trigger.isupdate)
    {
    for(Service_Asset__c sc: trigger.new)
     {
         RelAccountIds.add(sc.Account__c);
     }
      list<Asset__c> HwAsset =[select Id,Account__c,H_W_assigned__c from Asset__c where Account__c IN :RelAccountIds];
      list<Asset__c> HwAsset_to_update = new list<Asset__c>();
      map<ID,Asset__c> HwAssetMap = new map<ID,Asset__c>();
      
      system.debug('OUR HARDWARE :: ' + HwAsset);
      if(HwAsset.size()>0)
      {
      for(Service_Asset__c sc: trigger.new)
      {
          for(Asset__c HW : HwAsset){
           system.debug('HW.Id :: ' + HW.Id);
           system.debug('sc.Asset__c :: ' + sc.Asset__c);
           system.debug('trigger.oldmap.get(sc.ID).Asset__c :: ' + trigger.oldmap.get(sc.ID).Asset__c);
           
              if(HW.Id == sc.Asset__c)
              {              
                  if(HW.H_W_assigned__c == FALSE)
                  {
                       HW.H_W_assigned__c = TRUE;
                        HwAssetMap.put(HW.Id,Hw);                                              
                  }                                
              } 
              
                  if(sc.Asset__c == null && trigger.oldmap.get(sc.ID).Asset__c == hw.ID)
                  {
                      HW.H_W_assigned__c = false;
                      HwAssetMap.put(HW.Id,Hw);                 
                      
                  }             
                
          } 
      }
         update HwAssetMap.Values(); 
     
     }
    }
}