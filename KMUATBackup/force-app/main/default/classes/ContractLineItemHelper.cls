public with sharing class ContractLineItemHelper {

// an asyncronous call.
@future
public static void createContractLineItems(Set<Id> serviceContacts){
    set<ID> assetIDs                    = new set<ID>();
    map<ID,String> ProductsMap          = new map<Id,String>();
    list<ContractLineItem> contLineitems= new list<ContractLineItem>();
    Map<Id,PricebookEntry> priceBookIds = new Map<Id,PricebookEntry>();
    Set<Id> priceBooks                  = new Set<Id>();
    List<ServiceContract> serviceCons   = [select id ,Service_Asset__c,Asset__c,Pricebook2Id from ServiceContract where id in :serviceContacts];

    // get service asset Ids and Contract Ids
    for(ServiceContract oContract : serviceCons)
    {
        System.debug('Pricebook2Id:'+oContract.Pricebook2Id);
        if(oContract.Service_Asset__c != null)
        {          
            assetIDs.add(oContract.Service_Asset__c);
        }
        if(oContract.Pricebook2Id != null)
            priceBooks.add(oContract.Pricebook2Id);
    }
    if(assetIDs != null && assetIDs.size() > 0)
    {
         map<Id,List<Id>> assetMap = new map<Id,List<Id>>();
         Set<Id> productIds = new Set<Id>();
         List<id> procutsList ;
         System.debug('priceBooks:'+priceBooks);
         
            Map<Id,Service_Asset__c> assetsMap = new Map<Id,Service_Asset__c>([SELECT ID,SAP_SODO__c,SAP_SODO__r.Service_Product__c,Service_Product__c FROM Service_Asset__c WHERE ID IN: assetIDs]);
            for(Service_Asset__c asset : assetsMap.values())
            {
                if(asset.Service_Product__c != null)
                {
                    productIds.add(asset.Service_Product__c);
                }
            } 
                          
            for(PricebookEntry pb : [Select UnitPrice, Product2Id, Pricebook2.Name, Pricebook2Id From PricebookEntry where Product2Id in :productIds and  Pricebook2Id in :priceBooks order by CreatedDate desc limit 100])
            {
                if(!priceBookIds.containskey(pb.Pricebook2Id))
                    priceBookIds.put(pb.Pricebook2Id,pb);
            }  
        // update service assets with pricebook and product ids.
        if(priceBookIds.size() > 0)
        {
            for(ServiceContract oContract : serviceCons)
            {
                if(oContract.Service_Asset__c != null && assetsMap.containsKey(oContract.Service_Asset__c) && assetsMap.get(oContract.Service_Asset__c) != null)
                {
                    Service_Asset__c asset   = assetsMap.get(oContract.Service_Asset__c) ;
                    ContractLineItem lineItem= new ContractLineItem(ServiceContractId= oContract.id);  
                    lineItem.PricebookEntryId=   priceBookIds.get(oContract.Pricebook2Id).id  ;
                    lineItem.Quantity        = 1 ;
                    lineItem.UnitPrice       =   priceBookIds.get(oContract.Pricebook2Id).UnitPrice ;             
                    contLineitems.add(lineItem);
                    
                }
            }
        }
        if(!TEST.isRunningTest())
        if(contLineitems != null && contLineitems.size() > 0)
            insert contLineitems ;
    }
  }

}