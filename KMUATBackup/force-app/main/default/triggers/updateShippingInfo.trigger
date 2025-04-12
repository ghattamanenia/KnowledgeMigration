trigger updateShippingInfo on Asset__c (before insert,before update) 
{

    set<ID> accountIDs = new set<ID>();
    set<ID> prodcutIDs = new set<ID>();
    
    for(Asset__c oAsset : trigger.new)
    {
        if(oAsset.Account__c != null)
            accountIDs.add(oAsset.Account__c); 
             
        if(oAsset.DO_Ship_Date__c == null && oAsset.Start_Date__c != null)
         //  oAsset.DO_Ship_Date__c = oAsset.Start_Date__c;
           
        if(oAsset.DO_Ship_Date__c != null && oAsset.Start_Date__c == null)
           oAsset.Start_Date__c =  oAsset.DO_Ship_Date__c;  
           
        if(oAsset.Product__c!= null)        
            prodcutIDs.add(oAsset.Product__c);
           
                  
    }
    map<ID,Product2> productMap = new map<Id,Product2>([SELECT Id,Name FROM Product2 WHERE ID IN: prodcutIDs]);
    

    map<ID,Account> accountsMap = new map<ID,Account>([SELECT ID,
                                                              ShippingCity,
                                                              ShippingCountry,
                                                              ShippingPostalCode,
                                                              ShippingState,
                                                              ShippingStreet,
                                                              BillingCity,
                                                              BillingCountry,
                                                              BillingStreet ,
                                                              BillingState,
                                                              BillingPostalCode                                                                                                                                                                                           
                                                       FROM
                                                              Account
                                                       WHERE ID IN: accountIDs 
                                                       ]);
    for(Asset__c oAssetUpdate : trigger.new)
    {
        if(oAssetUpdate.Product__c != null && productMap.containsKey(oAssetUpdate.Product__c))
        {
               oAssetUpdate.Name =  productMap.get(oAssetUpdate.Product__c).Name;
        }
            
        if(oAssetUpdate.Account__c != null && accountsMap.containsKey(oAssetUpdate.Account__c))
        {
            if(oAssetUpdate.Locationcity__c == null && accountsMap.get(oAssetUpdate.Account__c).ShippingCity != null)
                oAssetUpdate.Locationcity__c    = accountsMap.get(oAssetUpdate.Account__c).ShippingCity;
            else if(oAssetUpdate.Locationcity__c == null && accountsMap.get(oAssetUpdate.Account__c).BillingCity != null)
                oAssetUpdate.Locationcity__c    = accountsMap.get(oAssetUpdate.Account__c).BillingCity;
                
            if(oAssetUpdate.LocationCountry__c == null && accountsMap.get(oAssetUpdate.Account__c).ShippingCountry != null)
                oAssetUpdate.LocationCountry__c = accountsMap.get(oAssetUpdate.Account__c).ShippingCountry;
            else if(oAssetUpdate.LocationCountry__c == null && accountsMap.get(oAssetUpdate.Account__c).BillingCountry != null)
                oAssetUpdate.LocationCountry__c = accountsMap.get(oAssetUpdate.Account__c).BillingCountry;
                                
            if(oAssetUpdate.Locationstate__c == null && accountsMap.get(oAssetUpdate.Account__c).ShippingState != null)
                oAssetUpdate.Locationstate__c   = accountsMap.get(oAssetUpdate.Account__c).ShippingState;
            else if(oAssetUpdate.Locationstate__c == null && accountsMap.get(oAssetUpdate.Account__c).BillingState != null)
                oAssetUpdate.Locationstate__c   = accountsMap.get(oAssetUpdate.Account__c).BillingState;                    
                
            if(oAssetUpdate.Locationstreet__c == null && accountsMap.get(oAssetUpdate.Account__c).ShippingStreet != null)
                oAssetUpdate.Locationstreet__c  = accountsMap.get(oAssetUpdate.Account__c).ShippingStreet;
            else if(oAssetUpdate.Locationstreet__c == null && accountsMap.get(oAssetUpdate.Account__c).BillingStreet != null)               
              oAssetUpdate.Locationstreet__c  = accountsMap.get(oAssetUpdate.Account__c).BillingStreet; 
                
            if(oAssetUpdate.LocationZipcode__c == null && accountsMap.get(oAssetUpdate.Account__c).ShippingPostalCode != null)
                oAssetUpdate.LocationZipcode__c = accountsMap.get(oAssetUpdate.Account__c).ShippingPostalCode;                        
            else  if(oAssetUpdate.LocationZipcode__c == null && accountsMap.get(oAssetUpdate.Account__c).BillingPostalCode != null)    
                oAssetUpdate.LocationZipcode__c = accountsMap.get(oAssetUpdate.Account__c).BillingPostalCode ;                        
            
        }
        
    }
                                                           
    

}