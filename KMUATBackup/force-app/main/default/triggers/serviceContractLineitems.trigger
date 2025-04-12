trigger serviceContractLineitems on ServiceContract (after insert) 
{
    set<ID> assetIDs = new set<ID>();
    set<ID> SAIDs = new set<ID>();
    

    
    for(ServiceContract oContract : trigger.new)
    {
        if(oContract.Service_Asset__c != null)
        {
            assetIDs.add(oContract.id);
            SAIDs.add(oContract.Service_Asset__c );
        }
        if(oContract.Pricebook2Id != null)
            assetIDs.add(oContract.id);
            
    }   

   if(assetIDs.size() > 0)
   {
   list<Service_Asset__c> saList = new list<Service_Asset__c>();
   map<ID,ServiceContract> scMap = new map<ID,ServiceContract>();
   
   for(ServiceContract  sc: trigger.new)
   {
      scMap.put(sc.Service_Asset__c,sc); 
   }
   
   
       for(Service_Asset__c sa :[SELECT ID,End_Date__c FROM Service_Asset__c WHERE ID IN: SAIDs ])
       {
           if(scMap.get(sa.ID).EndDate != sa.End_Date__c )
           saList.add(new Service_Asset__c(ID=sa.ID,End_Date__c=scMap.get(sa.ID).EndDate));
       }
       if(saList.size() >0)
       {
           update saList;
       }
   }
      ContractLineItemHelper.createContractLineItems(assetIDs);
 /*
    map<ID,String> ProductsMap = new map<Id,String>();
    list<ContractLineItem> contLineitems = new list<ContractLineItem>();
    Map<Id,PricebookEntry> priceBookIds = new Map<Id,PricebookEntry>();
    Set<Id> priceBooks = new Set<Id>();
    for(ServiceContract oContract : trigger.new)
    {
        if(oContract.Asset__c != null)
        {
            assetIDs.add(oContract.Asset__c);
        }
        if(oContract.Pricebook2Id != null)
            priceBooks.add(oContract.Pricebook2Id);
    }
    if(assetIDs != null && assetIDs.size() > 0){
         map<Id,List<Id>> assetMap = new map<Id,List<Id>>();
         Set<Id> productIds = new Set<Id>();
         List<id> procutsList ;
         
         
         for(Asset__c asset : [SELECT ID,SAP_SODO__c,SAP_SODO__r.Service_Product_ID__c FROM Asset__c WHERE ID IN: assetIDs]){
            if(asset.SAP_SODO__r.Service_Product_ID__c != null){
                String serviceProducts = asset.SAP_SODO__r.Service_Product_ID__c  ;
                 procutsList = new List<Id>();
                 for(String oProductID : serviceProducts.split(',')){
                           procutsList.add(oProductID) ; 
                                    
                }
                
                productIds.addAll(procutsList);
                assetMap.put(asset.id , procutsList);
                System.debug('priceBooks:'+priceBooks);
               for(PricebookEntry pb : [Select UnitPrice, Product2Id, Pricebook2.Name, Pricebook2Id From PricebookEntry where product2Id in :productIds or Pricebook2Id in :priceBooks]){
                    if(!priceBookIds.containskey(pb.Product2Id))
                        priceBookIds.put(pb.Product2Id,pb);
                    if(!priceBookIds.containskey(pb.Pricebook2Id))
                        priceBookIds.put(pb.Pricebook2Id,pb);
               }
            }
         }
        for(ServiceContract oContract : trigger.new){
            if(oContract.Asset__c != null && assetMap.containsKey(oContract.Asset__c) && assetMap.get(oContract.Asset__c) != null){
                for(Id serviceProdId : assetMap.get(oContract.Asset__c) ){
                  ContractLineItem lineItem = new ContractLineItem(ServiceContractId = oContract.id);  
                  lineItem.PricebookEntryId =   priceBookIds.get(oContract.Pricebook2Id).id  ;
                  lineItem.Quantity = 1 ;
                  lineItem.UnitPrice =   priceBookIds.get(serviceProdId).UnitPrice ;             
                  contLineitems.add(lineItem);
                }
            }
        }
        if(contLineitems != null && contLineitems.size() > 0)
        insert contLineitems ;
    }*/

   
  /*  
    
    for( Asset__c   oAsset : [SELECT ID,SAP_SODO__c,SAP_SODO__r.Service_Product_ID__c FROM Asset__c WHERE ID IN: assetIDs])
    {
        if(oAsset.SAP_SODO__r.Service_Product_ID__c != null)
            ProductsMap.put(oAsset.SAP_SODO__c,oAsset.SAP_SODO__r.Service_Product_ID__c);
    }
    for(ID oID : ProductsMap.keyset())
    {
            for(String oProductID : productsMap.get(oID).split(','))
            {
                ContractLineItem lineItem = new ContractLineItem();                    
                lineItem.ServiceContractId = oID;
                contLineitems.add(lineItem);                    
            }
    }
    if(contLineitems.size() > 0)
    {
    //    insert contLineitems;
    }
    
*/
}