trigger CreateAssetOnSodo on SODO_Line_Item__c (after insert) 
{
    System.debug('Entering into Sodo Line Item Trigger :'+userInfo.getUserName());
    
    List<Asset__c> assetsToInsert                         = new List<Asset__c>();
    List<Service_asset__c> serviceAssetsToInsert          = new List<Service_asset__c>();

    // Get all the SODO lineitems and relationship records and append based on product family
    for(SODO_Line_Item__c sli : [Select DO_Line_Number__c,SO_Line_Number__c,DO_Ship_Date__c,Start_Date__c,SAP_SODO__c,Serial_Number__c,SAP_SODO__r.Account__c,SAP_SODO__r.Shipping_Street__c,SAP_SODO__r.Shipping_City__c,SAP_SODO__r.Shipping_State__c,SAP_SODO__r.Shipping_Country__c,SAP_SODO__r.Shipping_Zipcode__c,Product__r.Family, Product__r.Name, Product__r.Id, Product__c From SODO_Line_Item__c 
                                    where id in :trigger.newmap.keyset()])
    {
        system.debug('logRavinder****'+sli.Product__r.Family+'******log2'+sli.Product__r.Name);
                // If Product family = "product" create  H/W Asset    
                if(sli.Product__c != null && sli.Product__r.Family == 'PRODUCT' )
                {
                        Asset__c oAsset                   = new Asset__C();
                        oAsset.Name                       = sli.Product__r.Name;
                        oAsset.Product__c                 = sli.Product__c;
                        oAsset.Serial_Number__c           = sli.Serial_Number__c;
                        oAsset.Account__c                 = sli.SAP_SODO__r.Account__c;
                        oAsset.SAP_SODO__C                = sli.SAP_SODO__c;
                        oAsset.Locationstreet__c          = sli.SAP_SODO__r.Shipping_Street__c;
                        oAsset.Locationcity__c            = sli.SAP_SODO__r.Shipping_City__c;
                        oAsset.Locationstate__c           = sli.SAP_SODO__r.Shipping_State__c;
                        oAsset.LocationCountry__c         = sli.SAP_SODO__r.Shipping_Country__c;
                        oAsset.LocationZipcode__c         = sli.SAP_SODO__r.Shipping_Zipcode__c;
                        oAsset.SODO_Line_Item__c          = sli.id ;
                        oAsset.DO_ID__c                   = sli.DO_Line_Number__c;
                        oAsset.SO_ID__c                   = sli.SO_Line_Number__c;
                        oAsset.DO_Ship_Date__c            = sli.DO_Ship_Date__c;
                       // oAsset.Start_Date__c            = sli.Start_Date__c;
                       oAsset.Start_Date__c            = sli.DO_Ship_Date__c;
                        assetsToInsert.add(oAsset);                 
                }
                // If Product family = "Service" create Service Asset                
                else if(sli.Product__c != null && sli.Product__r.Family == 'SERVICE'    )
                {
                        Service_asset__c oAsset           = new Service_asset__c();
                       // oAsset.Name                       = 'SA' + '-' + Date.today().year();
                       oAsset.Name                       = sli.Product__r.Name;
                        oAsset.Service_Product__c         = sli.Product__c;
                        oAsset.Account__c                 = sli.SAP_SODO__r.Account__c;
                        oAsset.SAP_SODO__C                = sli.SAP_SODO__c;
                        oAsset.SODO_Line_Item__c          = sli.id ;
                        oAsset.DO__c                      = sli.DO_Line_Number__c;
                        oAsset.SO__c                      = sli.SO_Line_Number__c;
                        oAsset.Start_Date__c            = sli.DO_Ship_Date__c;
                        serviceAssetsToInsert.add(oAsset);                  
                }
            }
            // if list size GT zero
            if(assetsToInsert != null && assetsToInsert.size() > 0)
                insert assetsToInsert ;
            if(serviceAssetsToInsert != null && serviceAssetsToInsert.size() > 0)
                insert serviceAssetsToInsert ;
                
            List<SODO_Line_Item__c> slitToUpdate  = new List<SODO_Line_Item__c>();  
            // Update SODO lineitems with H/W assets
            for(Asset__c oAsset  : [select id,SODO_Line_Item__c from Asset__c where SODO_Line_Item__c in :trigger.new])
            {
                slitToUpdate.add(new SODO_Line_Item__c( id= oAsset.SODO_Line_Item__c, H_w_Asset_ID__c= oAsset.id      ));
            } 
            // Update SODO lineitems with Service assets
            for(Service_asset__c sa  : [select id,SODO_Line_Item__c from Service_asset__c where SODO_Line_Item__c in :trigger.new])
            {
                slitToUpdate.add(new SODO_Line_Item__c( id= sa.SODO_Line_Item__c,Service_Asset_ID__c = sa.id));
            }                
            
    database.update(slitToUpdate,false);
}