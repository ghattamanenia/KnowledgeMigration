public class ProductPriceBook23 {

    public class productInfo {
    
        public Product2 prod{get; set;}
        public List<PriceBookEntry> pbes {get; set;}
        public productInfo() {
            pbes = new List<PriceBookEntry>();
        }
        
    }
    
    public List<ProductInfo> products {get; set;}
    
    public ProductPriceBook23() {
        products = new List<productInfo >();
        Map<Id, productInfo> pInfoMap = new Map<Id, productInfo>();
        for (PricebookEntry pEntry :[Select id, unitPrice, product2Id, product2.Name, product2.Description, product2.Family, product2.ProductCode, pricebook2id, pricebook2.name from PricebookEntry limit 1000]) {
            ProductInfo pInfo = new ProductInfo();
            if(!pInfoMap.containsKey(pEntry.product2Id)) {
                pInfo.prod = new Product2(id=pEntry.product2Id, Name=pEntry.product2.Name, Description=pEntry.product2.Description, Family=pEntry.product2.Family, ProductCode=pEntry.product2.ProductCode);
                pInfo.pbes.add(pEntry);
                pInfoMap.put(pEntry.product2Id, pInfo);
            } else {
                pInfo = pInfoMap.get(pEntry.product2Id);
                pInfo.pbes.add(pEntry);
            }
        }
        products = pInfoMap.values();
    }
    
}