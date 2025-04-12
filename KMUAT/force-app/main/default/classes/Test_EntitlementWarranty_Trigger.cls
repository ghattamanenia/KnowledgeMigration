@isTest
private class Test_EntitlementWarranty_Trigger{
    static List<Account> AccList = new List<Account>();
    static List<Account> NonaccList = new List<Account>();
    static List<Product2> productList = new List<Product2>(); 
    static List<Product2> serviceproductList = new List<Product2>();
    static List<Asset__c> assetList= new List<Asset__c>();
    static List<Asset__c> chAssetList= new List<Asset__c>();
    Static List<Service_Asset__c> serviceAssetList= new List<Service_Asset__c>();
    Static list<Warranty__c> WarrantyList= new list<Warranty__c>();
    Static list<Warranty_Code__c> WarrantyCodeList= new list<Warranty_Code__c>();
    Static list<Warranty_Items__c> WarrantyItemList= new list<Warranty_Items__c>();
    Static List<PricebookEntry> prList = new List<PricebookEntry>();
    
    static testMethod void TestTrigger(){
        AccList = Test_Data_Asset_Class.Account_Data();
        Database.insert(AccList,false);
        productList = Test_Data_Asset_Class.Product_Data();
        Database.insert(productList ,false);
        serviceproductList = Test_Data_Asset_Class.Service_Product_Data();
        Database.insert(serviceproductList,false);
        WarrantyList=Test_Data_Asset_Class.warranty_Data();
        Database.insert(WarrantyList,false);
        test.startTest();
        system.debug('**WarrantyList'+ WarrantyList);
        WarrantyCodeList=Test_Data_Asset_Class.warrantyCode_Data(productList,WarrantyList);
        Database.insert(WarrantyCodeList,false);
        assetList= Test_Data_Asset_Class.Asset_Data(productList,AccList );
        Database.insert(assetList,false);
        chAssetList= Test_Data_Asset_Class.AssetChanged_Data(productList,AccList );
        Database.insert(chAssetList,false);
        serviceAssetList= Test_Data_Asset_Class.servicAsset_Data(productList ,AccList,assetList);
        Database.insert(serviceAssetList,false);
        system.debug('**serviceAssetList'+ serviceAssetList);
        serviceAssetList[0].Asset__c= chAssetList[0].Id;
        Database.update(serviceAssetList,false);
        system.debug('**serviceAssetList'+ serviceAssetList); 
        WarrantyItemList= Test_Data_Asset_Class.warrantyItem_Data(assetList,WarrantyList);
        Database.insert(WarrantyItemList,false);
        system.debug('**WarrantyItemList'+ WarrantyItemList);
        test.stopTest(); 
    }
}