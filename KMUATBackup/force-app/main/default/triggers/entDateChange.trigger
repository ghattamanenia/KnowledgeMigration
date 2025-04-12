trigger entDateChange on Service_Asset__c(after insert, after update){
    list<Service_Asset__c> lstServStartDate = new List<Service_Asset__c>();
    list<Service_Asset__c> lstservEndDate = new List<Service_Asset__c>();
    List<Warranty_Items__c> lstWarrnty = new List<Warranty_Items__c>();
    List<Warranty_Items__c> updatedWarrnty = new List<Warranty_Items__c>();
    List<Entitlement> lstEnt = new List<Entitlement>();
    List<Entitlement> updatedEntEndDate = new List<Entitlement>();
    List<Entitlement> updatedEnt = new List<Entitlement>();
    List<Service_Asset__c> ServAssetWO_HW = new List<Service_Asset__c>();
    for(Service_Asset__c ServAsst: trigger.new){
        if(ServAsst.Start_Date__c !=null )     
        {
            system.debug('::new hwasset::' + ServAsst);
            lstServStartDate.add(ServAsst);
        }
        if(ServAsst.End_Date__c !=null )     
        {
            lstservEndDate.add(ServAsst);
        }
    }   
    
    system.debug('#######ServAssetWO_HW::#### ' + ServAssetWO_HW);
    
    if(lstServStartDate.size()>0){
       /* lstWarrnty = [Select Id,Warranty_Start_Date__c,Service_Asset__c from  Warranty_Items__c where Service_Asset__c In : lstServStartDate];
        if(lstWarrnty.size()>0){
           for(Service_Asset__c asst: lstServStartDate){   
               for(Warranty_Items__c updateWarnty : lstWarrnty ){
                    if(updateWarnty.Service_Asset__c == asst.Id){
                       updateWarnty.Warranty_Start_Date__c=asst.Start_Date__c;
                       updatedWarrnty.add(updateWarnty);
                    }  
                }
            }
        }   */    
        lstEnt = [Select Id,StartDate,HW_Asset__c,Service_Asset__c from Entitlement where Service_Asset__c In : lstServStartDate];
        if(lstEnt.size()>0){
            for(Service_Asset__c asst: lstServStartDate){   
               for(Entitlement updateEntitl : lstEnt ){
                   if((updateEntitl.Service_Asset__c ==asst.Id) &&  asst.Asset__c != null) {
                   system.debug('::updating start date on entitlement:: ID::->' + updateEntitl.id + '::startdate::->' + updateEntitl.Startdate);
                   updateEntitl.Startdate=asst.Start_Date__c;
                   updatedEnt.add(updateEntitl);
                   }
                }   
            }
        }   
    }
    if(lstservEndDate.size()>0){
        List<Entitlement> lstEnt1 = [Select Id,EndDate,HW_Asset__c,Service_Asset__c from Entitlement where Service_Asset__c In : lstservEndDate];
        if(lstEnt.size()>0){
            for(Service_Asset__c asst: lstservEndDate){   
               for(Entitlement updateEntitl : lstEnt ){
                   if((updateEntitl.Service_Asset__c ==asst.Id) &&  asst.Asset__c != null) {
                   system.debug('::updating start date on entitlement:: ID::->' + updateEntitl.id + '::startdate::->' + updateEntitl.Startdate);
                   updateEntitl.EndDate=asst.End_Date__c;
                   updatedEntEndDate.add(updateEntitl);
                   }
                }   
            }
        }
     }  
     
    
      
        UtilSODOFlags.skip_assetAfterUpdate = true;
        //system.debug('::updating warranty::->'+ updatedWarrnty);
        if(updatedEnt.size()>0)
            update updatedEnt;
        if(updatedWarrnty.size()>0)
            update updatedWarrnty;  
        
   }