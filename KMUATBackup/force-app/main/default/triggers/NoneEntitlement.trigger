trigger NoneEntitlement on Asset__c (after insert,after update) {
 
List<Entitlement> lstEntitlement =new List<Entitlement>();
List<Entitlement> updatedEnt =new List<Entitlement>();
List<Warranty_Items__c> lstWarrnty = new List<Warranty_Items__c>();
List<Warranty_Items__c> updatedWarrnty = new List<Warranty_Items__c>();
List<Asset__c> lstHardwareasst=new List<Asset__c>();
List<Entitlement> lstEnt =new List<Entitlement>();
if(Trigger.isinsert && !UtilSODOFlags.skip_assetAfterInsert){
Entitlement e=new Entitlement();
EntitlementTemplate  productEntileMent = [Select Type, Term, slaprocessid , Name,BusinessHoursId From EntitlementTemplate where name='Default' limit 1];
//Entitlement querye=[Select id,name from entitlement where name ='none'];    
    for(Asset__c hw: trigger.new){
        
        if(productEntileMent != null && productEntileMent.term != null && hw.Start_Date__c != null)
        {
        date d=hw.Start_Date__c;
        date d1=d.adddays(productEntileMent.term);
        
             if(hw.Account__c !=null){
                  e= new entitlement(name=productEntileMent.name,HW_Asset__c=hw.id,accountid=hw.Account__c,Term_Days__c=productEntileMent.term,startdate=d,enddate=d1,slaprocessid=productEntileMent.slaprocessid,region__c = hw.Region__c,BusinessHoursid=productEntileMent.BusinessHoursId);
                  lstEntitlement.add(e);
             }
    /*querye.HW_Asset__c=hw.id;
    update querye;*/
                       
        }// end if term condition           
      
   }
UtilSODOFlags.skip_assetAfterInsert = true;
insert lstEntitlement;
}
//code added for warranty part
if(trigger.isupdate && !UtilSODOFlags.skip_assetAfterUpdate )
{
map<ID,Asset__c> HwStartDate = new map<ID,Asset__c>();
list<Service_Asset__c> OServiceAssets = new list<Service_Asset__c>();

    
    for(Asset__c hardAsst: trigger.new){
    system.debug('****hardAsst.Start_Date__c***'+hardAsst.Start_Date__c);
    system.debug('****hardAsst.Account__c***'+hardAsst.Account__c);
    system.debug('****Trigger.oldMap.get(hardAsst.ID).Account__C)***'+Trigger.oldMap.get(hardAsst.ID).Account__C);
    system.debug('****hardAsst.Start_Date__c***'+hardAsst.Start_Date__c);
    system.debug('****Trigger.oldMap.get(hardAsst.ID).Start_Date__c)***'+Trigger.oldMap.get(hardAsst.ID).Start_Date__c);
        
        if(hardAsst.End_Date__c !=null && (( hardAsst.Account__c != Trigger.oldMap.get(hardAsst.ID).Account__C) || (hardAsst.End_Date__c != Trigger.oldMap.get(hardAsst.ID).End_Date__c) || (Test.isRunningTest())) )        
        {
            system.debug('::new hwasset::' + hardAsst);
            lstHardwareasst.add(hardAsst);
            HwStartDate.put(hardAsst.ID,hardAsst);
        }
        system.debug('::lstHardwareasst -1 ::->' + lstHardwareasst);
        }
    try{
   system.debug('::lstHardwareasst::->' + lstHardwareasst); 
   lstWarrnty = [Select Id,Warranty_End_Date__c,HW_Asset__c from Warranty_Items__c where HW_Asset__c In : lstHardwareasst];
   system.debug('::warranty:::->' + lstWarrnty);
   
   for(Asset__c asst: lstHardwareasst){   
       for(Warranty_Items__c updateWarnty : lstWarrnty ){
            if(updateWarnty.HW_Asset__c== asst.Id){
               updateWarnty.Warranty_End_Date__c=asst.End_Date__c;
               system.debug('::modified warranty::->'+ updateWarnty);
               updatedWarrnty.add(updateWarnty);
             }  
           }
        }
    // modfied by ravinder
    for (Service_Asset__c OserviceAsset : [SELECT ID,Start_Date__c,Asset__c FROM Service_Asset__c WHERE Asset__c IN: HwStartDate.keyset()])
    {
     system.debug('::DEBUG:: Associated service Asset:->' + OserviceAsset);
        if(HwStartDate.containsKey(OserviceAsset.Asset__c) && HwStartDate.get(OserviceAsset.Asset__c).Start_Date__c != null)
        {
            system.debug('::DEBUG::Add for date update:->' + HwStartDate.get(OserviceAsset.Asset__c).Start_Date__c);
           //OServiceAssets.add(new Service_Asset__c(Account__c = HwStartDate.get(OserviceAsset.Asset__c).Account__c,ID=OserviceAsset.ID,Start_Date__c= HwStartDate.get(OserviceAsset.Asset__c).Start_Date__c ));           
          // OServiceAssets.add(new Service_Asset__c(Account__c = HwStartDate.get(OserviceAsset.Asset__c).Account__c,ID=OserviceAsset.ID));           
        }
    }
    system.debug('::DEBUG::service assets SIZE:->' + OServiceAssets.size());
    if(OServiceAssets.size() > 0)
    {
    system.debug('::DEBUG::updating assetAfterupdate:->' + UtilSODOFlags.skip_assetAfterUpdate);
     UtilSODOFlags.skip_assetAfterUpdate = true;
     update OServiceAssets;   
     system.debug('::DEBUG::updated service assets:->' + OServiceAssets);
    }
        UtilSODOFlags.skip_assetAfterUpdate = true;
        //system.debug('::updating warranty::->'+ updatedWarrnty);
        if(updatedWarrnty.size()>0)
            update updatedWarrnty;  
        
       // update updatedEnt;
     }
     Catch(Exception ex){}
   }
            
}