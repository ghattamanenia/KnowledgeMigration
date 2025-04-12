trigger populateProduct on SODO_Line_Item__c (before insert) {
    
    Set<String> setProductCode = new Set<String>();
    for(SODO_Line_Item__c item : trigger.new){
        //if(!String.isBlank(item.Productcode__c))
        if(item.Productcode__c != null)
            setProductCode.add(item.Productcode__c);
    }
    
    if(!setProductCode.isEmpty()){
        list<Product2> lstProducts = [select ID,Name,ProductCode from Product2 where IsActive =true and (ATFE_NA__c=true OR ATFE_EMEA__c=true OR ATFE_CSA__c=true) and  ProductCode in: setProductCode];
        Map<String, Product2> mapProductIDs = new Map<String, Product2 >();
        for(Product2 product : lstProducts)
            mapProductIDs.put(product.ProductCode, product);
        
        for(SODO_Line_Item__c item : trigger.new){
            Product2 product = mapProductIDs.get(item.Productcode__c);
            if(product != null){
                item.Product__c = product.ID;
                item.Name = product.Name;
            }
        }
    }
}