trigger createWarranty on Asset__c (after insert,after update) {
   
   
  /*if(Utils.hascreateWarrantyAlreadyDone())
       return;
    
   Utils.setcreateWarrantyAlreadyDone(); ***/
    
    Map<Id,Id> productAsstMap = new Map<Id,Id>();
    Map<Id,List<Id>> asstproductMap = new Map<Id,List<Id>>();
    Map<Id,Id> accountAsstMap= new Map<Id,Id>();
    Map<Id,List<Id>> asstAccountMap= new Map<Id,List<Id>>();
    Map<Id,Id> asstWarrantyMap= new Map<Id,Id>();
    Map<Id,String> asstMap= new Map<Id,String>();
    Map<Id, Id> productMap= new Map<Id,Id>();
    Map<Id, Id> productMap1= new Map<Id,Id>();
    List<Id> accLst= new List<Id>();
    List<Id> accLst1= new List<Id>();
    List<Id> plist = new List<Id>();
    List<Id> accountIdList = new List<Id>();
    List<Id> ProductIdList = new List<Id>();
    List<Id> finalProductList = new List<Id>();
    Map<Id,String> asstRegionMap= new Map<Id,String>();
    Map<Id,List<Warranty_Code__c>> warrantyAsstMap= new  Map<Id,List<Warranty_Code__c>>();
    List<Warranty_Items__c > warrantyList= new List<Warranty_Items__c >();
    List<Asset__c> assetList= new List<Asset__c>();
    
    for(Asset__c asst: trigger.new){
        system.debug('::: asst::::' + asst);
        accountAsstMap.put(asst.Id,asst.Account__c);
        accountIdList.add(asst.Account__c);
        ProductIdList.add(asst.Product__c);
        if(!asstproductMap.keyset().contains(asst.Product__c))
            asstproductMap.put(asst.Product__c,new List<Id>());
        asstproductMap.get(asst.Product__c).add(asst.Id);
        if(!asstAccountMap.keyset().contains(asst.Account__c))
            asstAccountMap.put(asst.Account__c,new List<Id>());
        asstAccountMap.get(asst.Account__c).add(asst.Id);
        
    } 
       
            
        if(accountIdList.size()>0){
            for(Account a :[Select Id,Region__c,sub_region__c from Account where Id In : asstAccountMap.keySet()]){
                    for(Id asstId : asstAccountMap.get(a.Id)){
                           asstMap.put(asstId, a.Region__c);
                           asstRegionMap.put(asstId,a.sub_region__c);
                        
                    }   
                }
            }   
  
    if(ProductIdList !=null && ProductIdList.size()>0 ){
        for(Product2 p : [select Id, Warranty__c, Family,IsActive from Product2 where Id In : asstproductMap.keySet()]){
            if(p.family=='Product' ){
                for(Id asstId : asstproductMap.get(p.Id)){
                    productMap1.put(asstId,p.Id);
                }   
                finalProductList.add(p.Id);
            }
          }
      }  
      List<Warranty_Code__c> warnCodeList = new List<Warranty_Code__c>();
      Map<Id,List<Warranty_Code__c>> warnProductMap = new Map<Id,List<Warranty_Code__c>>();
    if(finalProductList!=null && finalProductList.size()>0){
    for(Warranty_Code__c warnLst : [Select Product_Id__c,Warranty_Id__c,Warranty_Name__c  from Warranty_Code__c where Product_Id__c In : finalProductList]){
        //warnCodeList= new List<Warranty_Code__c>();
        if(!warnProductMap.keyset().contains(warnLst.Product_Id__c))
            warnProductMap.put(warnLst.Product_Id__c,new List<Warranty_Code__c>());
        warnProductMap.get(warnLst.Product_Id__c).add(warnLst);
        }
        }
        system.debug('***'+warnProductMap );
        if(warnProductMap !=null){
            for(Id pId : warnProductMap.keySet()){
                for(Id asstId : productMap1.keySet()){
                    if(pId ==productMap1.get(asstId))
                        warrantyAsstMap.put(asstId,warnProductMap.get(pid));
                }       
            }
        }
        system.debug('***'+warrantyAsstMap);
        list<Warranty_Items__c> warnitemLists = new list<Warranty_Items__c>();
        list<Warranty_Items__c> deletewarrantyList = new list<Warranty_Items__c>();
        list<Asset__c> assetList1 = new list<Asset__c>();
        if(trigger.isupdate){
            for(Asset__c st: trigger.new){
               // if(st.Account__c !=Trigger.oldMap.get(st.ID).Account__c || st.Product__c !=Trigger.oldMap.get(st.ID).Product__c){
                   assetList1.add(st);
                  
               // }   
        }  
         
        system.debug('::: assetList1 ::::' + assetList1 );     
        warnitemLists=[Select id from Warranty_Items__c where HW_Asset__c In : assetList1];
        
    if(warnitemLists.size()>0)
        database.delete(warnitemLists,false);
    }   
         
    if(warrantyAsstMap !=null && warrantyAsstMap.size()>0){
    for(Id asstId : warrantyAsstMap.keySet()){
        String Region =asstMap.get(asstId );
        String Sub_Region=asstRegionMap.get(asstId );
        if(Region=='EMEA' || Region=='NA' )
            Sub_Region = Region;
        String warrantyCode=Region + '-' + Sub_Region;
        system.debug('warrantyCode'+warrantyCode);
        
        
    /*    if(Region=='NA')
            Sub_Region='NA';
        string warrantyCode1=Region + '-' + Sub_Region;
        system.debug('warrantyCode1'+warrantyCode); */
        
        
        
        
        if(warrantyCode.startsWithIgnoreCase('CSA-CCA')){
                warrantyCode='CSA-CCA';
            }
            system.debug('***$$$'+warrantyAsstMap);
            system.debug('***$$$'+asstId);
        for(Warranty_Code__c warn : warrantyAsstMap.get(asstId)){
            if((warn.Warranty_Name__c).startsWithIgnoreCase(warrantyCode)){
                    asstWarrantyMap.put(asstId,warn.Warranty_Id__c);
                    system.debug(asstWarrantyMap);
                }
            
        }
    } 
    }
    List<Id> warnIdList = new List<Id>();
    List<Warranty__c>  warnList = new List<Warranty__c>();
    for(Id AsstId : asstWarrantyMap.keySet()){
        warnIdList.add(asstWarrantyMap.get(AsstId));
    }   
    if(warnIdList.size()>0)
     warnList =[Select Id,Name, Duration_Days__c,Warranty_Start_Date__c,Warranty_End_Date__c,Warranty_Type__c  from Warranty__c where Id = : warnIdList];
        
    
    if(trigger.isinsert)
    {
       system.debug(':::Insert trigger:::');
        if(asstWarrantyMap != null && asstWarrantyMap.size()>0 && warnList.size()>0)
        {
            for(Warranty__c warn : warnList)
            {
                for(Id asstId : asstWarrantyMap.keySet())
                {
                    if(asstWarrantyMap.get(asstId) == warn.Id)
                    {
                        system.debug('***'+warn);
                        if(warn !=null )
                        {
                            Warranty_Items__c warnItem= new Warranty_Items__c();
                            warnItem.Name=warn.Name;
                            warnItem.HW_Asset__c=asstId;
                            warnItem.Region__c= asstRegionMap.get(asstId );
                            warnItem.Warranty__c=warn.Id; 
                            warnItem.Sub_Region__c= asstRegionMap.get(asstId );
                            warnItem.Duration__c=warn.Duration_Days__c;
                            warrantyList.add(warnItem);
                        }
                        system.debug('***'+true);
                        
                    }
                }
            }
        }
    }
    else
    {
        system.debug(':::Update trigger:::');
            if(asstWarrantyMap != null && asstWarrantyMap.size()>0&& warnList.size()>0)
            {
             system.debug(':::Update trigger asstWarrantyMap :::' + asstWarrantyMap + '::WarnList::' + warnList);
            for(Warranty__c warn : warnList)
            {
                system.debug(':::Update trigger warn :::' + warn );
                for(Asset__c asstId : assetList1)
                {
                    system.debug(':::Update trigger asstId :::' + asstId );
                    if(asstWarrantyMap.get(asstId.Id) == warn.Id)
                    {
                         system.debug(':::Update trigger warn.Id :::' + warn.Id);
                        if(warn !=null )
                        {
                            Warranty_Items__c warnItem= new Warranty_Items__c();
                            warnItem.Name=warn.Name;
                            warnItem.HW_Asset__c=asstId.Id;
                            warnItem.Region__c= asstRegionMap.get(asstId.Id);
                            warnItem.Warranty__c=warn.Id; 
                            warnItem.Sub_Region__c= asstRegionMap.get(asstId.Id);
                            //warnItem.Duration__c=warn.Duration_Days__c;
                            warnItem.Warranty_Start_Date__c =asstId.Start_Date__c;
                            warnItem.Warranty_End_Date__c = asstId.End_Date__c;
                            warrantyList.add(warnItem);
                            system.debug(':::Update trigger warnItem :::' + warnItem);
                        }
                        system.debug('***'+true);
                        
                    }   
                }
            }
            }
    }

    if(warrantyList !=null && warrantyList.size() > 0  && AssetCTRL.isFromclone == false)
    {              
          Database.insert(warrantyList); 
    }
    
    
    if(warrantyList !=null && warrantyList.size() > 0 &&  Utils.warrantyCreated == false && AssetCTRL.isFromclone == true)
    {          
          Utils.warrantyCreated = true;
          Database.insert(warrantyList);
 
    }
    
        
         
 }