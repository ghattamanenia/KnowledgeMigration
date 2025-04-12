//Ravinder
// get Started date from Hardware Asset
trigger serviceAssetBeforeUpdate on Service_Asset__c (before Update,after insert) 
{
if(!UtilSODOFlags.skip_serviceAssetTrigger) 
{
// put Product name as Service Asset Name 
map<Id,Service_Asset__c> ProductNames = new map<ID,Service_Asset__c>([SELECT ID,Service_Product__r.Name FROM Service_Asset__c WHERE ID IN: trigger.newmap.keyset()]);
list<Service_Asset__c> ServiceAssets = new list<Service_Asset__c>();

for(Service_Asset__c oServiceAsset : trigger.new)
{
    if(trigger.isBefore)
        oServiceAsset.Name = ProductNames.get(oServiceAsset.ID).Service_Product__r.Name;
    else    
        ServiceAssets.add(new Service_Asset__c(Id=oServiceAsset.ID,Name = ProductNames.get(oServiceAsset.ID).Service_Product__r.Name));
}
if(ServiceAssets.size() > 0)
{
    UtilSODOFlags.skip_serviceAssetTrigger = true;
    update ServiceAssets;
    
}

if(trigger.isBefore && trigger.isUpdate)
{
set<ID> HAsset = new set<ID>();
set<ID> sAsset = new set<ID>();

for(Service_Asset__c oServiceAsset : trigger.new)
{
    if(oServiceAsset.Asset__c != null)
    {
      HAsset.add(oServiceAsset.Asset__c);  
    }    
}


/*
modified by ravinder on 04/09/2014
map<ID,Asset__c> HassetMap = new map<ID,Asset__c>([SELECT ID,Start_Date__c FROM Asset__C WHERE ID IN: HAsset]);

for(Service_Asset__c oSAssetUpdate : trigger.new)
{
    if(HassetMap.containsKey(oSAssetUpdate.Asset__c))
    {
        oSAssetUpdate.Start_Date__c = HassetMap.get(oSAssetUpdate.Asset__c).Start_Date__c;
        sAsset.add(oSAssetUpdate.ID);
    }
}

*/

}


/*
 System.debug('Entering into CreateServiceContractOnServiceAsset : '+userInfo.getUserName());
    Map<Id,PricebookEntry> priceBookMap      = new Map<Id,PricebookEntry>();
    Set<Id> accPriceBooks                    = new Set<Id>();
    List<ServiceContract> serviceContractList= new List<ServiceContract>();
    Set<String> serviceProctTypes            = new Set<String>();
    Map<String,EntitlementTemplate> etMap    = new Map<String,EntitlementTemplate>();
    map<ID,Service_Asset__c> assetsMap       = new map<ID,Service_Asset__c>([SELECT ID,Start_date__c,SODO_Line_Item__r.Serial_Number__c,Service_Product__r.ATFE_Service_Product_Type__c,SODO_Line_Item__r.DO_Ship_Date__c,Service_Product__c,Asset__c,Account__r.ATFE_Price_Book__c,SAP_SODO__r.Account__c,SAP_SODO__r.Name FROM Service_Asset__c WHERE ID IN: trigger.newmap.keyset()]); 
    Pricebook2 stdpb                         = [Select Name, IsStandard, IsActive, Id From Pricebook2 where IsStandard= true and IsActive= true limit 1];

        // get service product types based on assets
         for(Service_Asset__c asset : trigger.new)
         {
                if(assetsMap.get(asset.id).Service_Product__c != null) 
                {
                    accPriceBooks.add(assetsMap.get(asset.id).Service_Product__c);
                    serviceProctTypes.add(assetsMap.get(asset.id).Service_Product__r.ATFE_Service_Product_Type__c);
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
            for(Service_Asset__c  oAsset: trigger.new)
            {                 
               // if(oAsset.SAP_SODO__c != null) 
                {
                    for(ServiceContract  oserContract : [SELECT ID,EndDate,Asset__c,Name,StartDate,AccountID,Pricebook2Id  FROM ServiceContract WHERE Asset__C IN: HAsset])
                    {
                        
               
                    Service_Asset__c  assetObj= assetsMap.get(oAsset.id); 
                    ServiceContract  oContract= new ServiceContract(Id=oserContract.ID);  
                    
                    if(etMap.containsKey(assetObj.Service_Product__r.ATFE_Service_Product_Type__c) && etMap.get(assetObj.Service_Product__r.ATFE_Service_Product_Type__c) != null )
                    {
                     if(assetObj.SODO_Line_Item__c != null && assetObj.SODO_Line_Item__r.DO_Ship_Date__c != null)
                     {
                        Integer term     = etMap.get(assetObj.Service_Product__r.ATFE_Service_Product_Type__c).Term;
                        system.debug('Term is ;;;->' + term      );

                        Date  endDate    = assetObj.SODO_Line_Item__r.DO_Ship_Date__c.addDays(term);
                        if(endDate!= NULL )
                            oContract.EndDate= endDate ;
                      }      
                    
                    if(assetObj.Start_date__c != null && assetObj.SODO_Line_Item__c == null)
                        {
                            Integer term2     = etMap.get(assetObj.Service_Product__r.ATFE_Service_Product_Type__c).Term;
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
              }   
                    System.debug('contracts:'+serviceContractList);
 
         update serviceContractList;
                   

*/

}

}