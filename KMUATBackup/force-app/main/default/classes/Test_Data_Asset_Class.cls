public class Test_Data_Asset_Class{

    public static list<Account> Account_Data(){
        List<Account> AccList = new List<Account>();
        AccList.add(new Account(Name = 'Test Account1',Region__c='NA',Sub_Region__c='NA',ATFE_SalesOrgName__c='Enterprise',ATFE_AccountType__c='End customer',website='http://abc.com',ATFE_VerticalMarketInit__c='Defense'));
        return AccList;
    }
    Public Static List<Product2> Product_Data(){    
      list<Product2> productList = new list<Product2>();
      Product2 pr = new Product2();
             pr.Name = 'TESTProduct1';
             pr.Description = 'test Desc';
             pr.Family = 'PRODUCT';
             pr.IsActive = true;
             pr.productcode = '960-002642';
           //pr.PriceBook2Id =pricbookId ;
             pr.ATFE_Service_Product_Type__c = 'PC-1';
             productList.add(pr);
             return productList;
       }
        Public Static List<Product2> Service_Product_Data(){    
      list<Product2> productList = new list<Product2>();
      Product2 pr = new Product2();
             pr.Name = 'TESTProduct1';
             pr.Description = 'test Desc';
             pr.Family = 'Service';
             pr.IsActive = true;
             pr.productcode = '961-002642';
             //pr.Pricebook2Id=priceList[0].Id;
             pr.ATFE_Service_Product_Type__c = 'PC-1';
             productList.add(pr);
             return productList;
       }
     Public Static List<Asset__c> Asset_Data(List<Product2> proList, List<Account> AccList){             
          list<Asset__c> assetList= new list<Asset__c>();
          Asset__c asset = new Asset__c();
          asset.Name = 'Test'; 
          asset.Product__c = proList[0].Id;
          asset.Serial_Number__c = '1234566';
          asset.Account__c = AccList[0].Id;
          asset.Start_Date__c= system.today();
          assetList.add(asset);
          //RecordType
          return assetList;
          }
          Public Static List<Asset__c> AssetChanged_Data(List<Product2> proList, List<Account> AccList){             
          list<Asset__c> assetList= new list<Asset__c>();
          Asset__c asset = new Asset__c();
          asset.Name = 'Test1'; 
          asset.Product__c = proList[0].Id;
          asset.Serial_Number__c = '12345667';
          asset.Account__c = AccList[0].Id;
          asset.Start_Date__c= system.today();
          assetList.add(asset);
          //RecordType
          return assetList;
          }
      Public Static List<Service_Asset__c> servicAsset_Data(List<Product2> proList, List<Account> AccList, List<Asset__c> assetList){             
          list<Service_Asset__c> serviceAssetList= new list<Service_Asset__c>();
          Service_Asset__c asset = new Service_Asset__c();
          asset.Name = 'Test'; 
          asset.Service_Product__c= proList[0].Id;
          asset.Asset__c= assetList[0].Id;
          asset.Account__c = AccList[0].Id;
          asset.Start_Date__c= system.today();
          serviceAssetList.add(asset);
          //RecordType
          return serviceAssetList;
          }  
      Public Static List<Warranty__c> warranty_Data(){
           list<Warranty__c> WarrantyList= new list<Warranty__c>();
           Warranty__c warranty= new Warranty__c();
           warranty.Name = 'Test';
           //warranty.HW_Asset__c= assetList[0].Id;
           //warranty.Warranty__c = '1';
           warranty.Duration_Days__c = 90;
           warranty.Warranty_Start_Date__c = system.today();
           WarrantyList.add(warranty);
           return WarrantyList;
      } 
       Public Static List<Warranty_Code__c> warrantyCode_Data(List<Product2> proList , List<Warranty__c> warnList){
           list<Warranty_Code__c> WarrantyList= new list<Warranty_Code__c>();
           Warranty_Code__c warranty= new Warranty_Code__c();
           warranty.Name = 'NA-NA';
           warranty.Warranty_Id__c = warnList[0].Id;
           warranty.Product_Id__c = proList[0].Id; 
           WarrantyList.add(warranty);
           return WarrantyList;
        }        
      Public Static List<Warranty_Items__c> warrantyItem_Data(List<Asset__c> assetList, List<Warranty__c> WarrantyList){
           list<Warranty_Items__c> WarrantyItemList= new list<Warranty_Items__c>();
           Warranty_Items__c warranty= new Warranty_Items__c();
           warranty.Name = 'Test';
           warranty.HW_Asset__c= assetList[0].Id;
           warranty.Warranty__c = WarrantyList[0].Id;
           warranty.Duration__c = 90;
           WarrantyItemList.add(warranty);
           return WarrantyItemList;
      }
      Public Static List<Pricebook2> PriceBookData(){
            List<Pricebook2> prList = new List<Pricebook2>();
            Pricebook2 prEntry = new Pricebook2();
            prEntry.IsActive = true;
            //prEntry.Pricebook2Id = pricbook.ID;
           // prEntry.Product2Id = proList[0].Id;
            //prEntry.UnitPrice  = 56;
            prList.add(prEntry);
            return prList;
            }     
          
   /*   Product2 pr1 = new Product2();
             pr1.Name = 'TESTProduct2';
             pr1.Description = 'test Desc';
             pr1.Family = 'SERVICE';
           //  pr1.productcode = '960-002642';
             pr1.ATFE_Service_Product_Type__c = 'NCB-3';             
             pr1.IsActive = true;
             products.add(pr1);
             //insert pr1;          
            insert products;
       system.debug('*****products***'+products);       
     for(Product2 oProduct : products)
     {
        if(oProduct.Name == 'TESTProduct1')
            pr = products[0];
        else
            pr1 = products[1];
     }
            
      PricebookEntry prEntry = new PricebookEntry();
            prEntry.IsActive = true;
            prEntry.Pricebook2Id = pricbook.ID;
            prEntry.Product2Id = pr1.ID;
            prEntry.UnitPrice  = 56;
            prEntry.CurrencyIsoCode = pricbook.CurrencyIsoCode;
            
        insert prEntry;          
    
     public static list<Asset__c> Asset_Data(List<Account> accList){
        list<Asset__c> assetData = new list<Asset__c>();
        Asset__c ast = new Asset__c();
        ast.Name = 'Test-Opportunity';
        ast.Serial_Number__c = 'A123456789';
        ast.Start_Date__c = system.today();
        ast.Account__c =accList[0].Id;        
       // ast.RecordType = 'Manual H/w Asset';
        assetData.add(ast);
        return assetData;
    } */
    
    
  }