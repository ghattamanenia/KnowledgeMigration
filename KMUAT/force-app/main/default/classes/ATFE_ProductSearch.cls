global class ATFE_ProductSearch {
    
    public class productDetail {
        public list<string> productCode {get; set;}
        public list<string> productDescription {get;set;}
        public list<string> productName {get; set;}
        public list<string> pricebookName {get; set;}
        public list<string> pricebookId {get; set;}
        public list<string> pricebookPrice {get; set;}
        
        public productDetail (){
            productCode = new list<string>();
            productDescription = new list<string>();
            productName = new list<string>();
            pricebookName = new list<string>();
            pricebookId = new list<string>();
            pricebookPrice = new list<string>();
        }
    }
    
    public class pricebookInfo {
        public list<string> colNames {get; set;}
        public list<string> colModel {get; set;}
        public list<productDetail> products {get; set;}
    }

    // Call to get the Price Book Names
    WebService static String getPricebookNames(List<String> regions)
    {
        //system.debug('start getPricebookNames');
        
        MAP<String, String> myPBNames = new MAP<String, String>();
        List<ID> ids = new List<ID>();
        MAP<String, String> regionISO = new MAP<String, String>();
        
        //Defining ISOs
        regionISO.put('NA', 'USD');
        regionISO.put('APAC', 'USD');
        regionISO.put('EMEA', 'EUR');
        
        system.debug('===== regions pricebook ===' + regions);
    
        for (String region: regions){
            //PriceBookDetails__c pbIds = [select PriceBook2Id__c from PriceBookDetails__c];
            //for (PriceBookDetails__c pbd : [select PriceBook2Id__c from PriceBookDetails__c where region__c = :region and ProductSearchViewable__c = true])
            //{
            //    ids.add((ID) pbd.PriceBook2Id__c);
            //}
            ids.addAll(getPricebookIDs(region));
            //ids.add(getPricebookIDs(region));
        /* commenting out the list prices
            string id = '00000std_' + regionISO.get(region);
            string name = 'List(' + regionISO.get(region) + ')';
            myPBNames.put(id, name);
        */
        }
    
        // Adding the function to show List price both in EUR and USD for EMEA only
    /* commenting out the list prices
        Boolean emea = false;
        Boolean na = false;
        for (Integer i = 0; i < regions.size(); i++)
        {
            if (regions.get(i) == 'EMEA')
            {
                emea = true;
            }
            if (regions.get(i) == 'NA')
            {
                na = true;
            }

        }
    */
    /* commenting out the list prices
        if ((emea == true) && (na == false))
        {
            string id = '00000std_' + regionISO.get('NA');
            string name = 'List(' + regionISO.get('NA') + ')';
            myPBNames.put(id, name);
        }
    */
        //system.debug('====================> Pricebook ids: ' + ids);
        
        //Pricebook2 pbs = [select id, Name from Pricebook2 where id in (:ids)];
        for (Pricebook2 pb : [select id, Name from Pricebook2 where id in :ids])
        {
            myPBNames.put(pb.id, pb.Name);
        }
        system.debug('====================> myPBNames: ' + myPBNames);
        //system.debug('====================> JSON.serialize(myPBNames): ' + JSON.serialize(myPBNames));
        
        return JSON.serialize(myPBNames);
    }
    
    static List<ID> getPricebookIDs(String region) 
    {
        system.debug('===============> getPricebookIDs region: ' + region);
        List<ID> ids = new List<ID>();
        for (PriceBookDetails__c pbd : [select PriceBook2Id__c from PriceBookDetails__c where region__c = :region and ProductSearchViewable__c = true])
        {
            ids.add((ID) pbd.PriceBook2Id__c);
        }
       
        system.debug('===============> getPricebookIDs ids: ' + ids);
       
        return ids;
    }
    
    WebService static List<String> getProductList(List<String> regions)
    {
        //system.debug('===============> regions: ' + regions);
        List<ID> ids = new List<ID>();
        String prodPriceBooks = '';
        
        for (String region: regions)
        {
            //ids = getPricebookIDs(region);
        
            for (ID id : getPricebookIDs(region))
            {
                //system.debug('====================>prodPriceBooks: ' + prodPriceBooks);
                
                if (prodPriceBooks == '')
                {
                    prodPriceBooks = 'pricebook2.id = \'' + id + '\'';
                }
                else
                {
                    prodPriceBooks = prodPriceBooks + ' or pricebook2.id = \'' + id + '\'';
                }
            }
        }
        
        //system.debug('====================>Last prodPriceBooks: ' + prodPriceBooks);
            
        //List<Product2> products = [select name from product2 where isactive = true and Family = 'Product'];
        
        //String prodListQuery = 'select product2.name from pricebookentry where isactive = true and product2.family = \'Product\' and (' + prodPriceBooks + ') and (not (pricebook2.name like \'%Master%\' or pricebook2.name like \'%JP%\' or pricebook2.name like \'%APAC%\' or pricebook2.name like \'%Standard%\')) group by product2.name';
        String prodListQuery = 'select name from PricebookEntry where product2.isactive = true and isactive = true and product2.Family = \'Product\' and (pricebook2.name = \'EMEA MSRP (USD)\' or pricebook2.name = \'APAC_MSRP_Common\' or pricebook2.name = \'NA Direct (USD)\')';
            
        //system.debug('====================>prodListQuery: ' + prodListQuery);
        
        List<PricebookEntry> products = Database.query(prodListQuery);
        List<String> productList = new List<String>();
        
        for (PricebookEntry pl : products)
        {
            productList.add(String.valueOf(pl.get('Name')));
        }
        
        return productList;
    }
    
    WebService static String getSearchResults(String keyword, List<String> regions)
    {
        system.debug('====================> keyword:' + keyword);
        system.debug('====================> regions:' + regions);
        
            Map<String, Map<String, Map<String, String>>> searchResult = new Map<String, Map<String, Map<String, String>>>();
            string pricebookWhere = '';
            string prodType = '';
            
            // Build out the query string for the Price Books allowed for the user
            for (String region: regions)
            {
                //system.debug('====================> region: ' + region);
                for (PriceBookDetails__c pbd : [select PriceBook2Id__c from PriceBookDetails__c where Region__c = :region and ProductSearchViewable__c = true])
                    {

                    system.debug('====================> pbd: ' + pbd);

                    if (pricebookWhere == '')
                    {
                        //pricebookWhere = 'pricebook2id = \'01s20000000HSJzAAO\' or ' + 'pricebook2id = \'' + pbd.PriceBook2Id__c + '\'';
                        pricebookWhere = 'pricebook2id = \'' + pbd.PriceBook2Id__c + '\'';
                    }
                    else
                    {
                        pricebookWhere = pricebookWhere + ' or pricebook2id = \'' + pbd.PriceBook2Id__c + '\'';
                    }
                }
            }
        system.debug('====================> regions__after: ' + regions);
        system.debug('====================> pricebookWhere: ' + pricebookWhere);
        
        string prodQuery = 'select id, name, productcode, description, family from product2 where isactive = true and name like \'%' + keyword + '%\' and Family = \'Product\' limit 50';
        
        system.debug('====================> ProdQuery: ' + ProdQuery);
        
        List<Product2> prodQueried = Database.query(prodQuery);
        
        //system.debug('==================> SQL Count: ' + Limits.getQueries());
        system.debug('==================> prodQueried: ' + prodQueried);
        
        for (Product2 prd : prodQueried)
        {
                
            Map<String, String> pricebookData = new Map<String, String>();
            Map<String, String> productInfo = new Map<String, String>();
            Map<String, Map<String, String>> productResult = new Map<String, Map<String, String>>();
                
            productInfo.put('Name', prd.name);
            productInfo.put('Id', prd.id);
            productInfo.put('SKU', prd.productcode);
            productInfo.put('Description', prd.description);
            productInfo.put('Type', prd.family);
            
            string pbeQuery = 'select name, product2Id, product2.Description, product2.productcode, unitprice, pricebook2id, CurrencyIsoCode from pricebookentry where product2id = \'' + prd.id + '\' and (' + pricebookWhere + ') and isActive = true' + ' and (not (pricebook2.name like \'%Master%\' or pricebook2.name like \'%JP%\'))' + '  limit 20';
    
            List<PricebookEntry> pbeQueried = Database.query(pbeQuery);
            
            system.debug('==================> pbeQueried: ' + pbeQueried);
            
            for (PricebookEntry pbe : pbeQueried)
            {
                if (pbe.pricebook2id == '01s20000000HSJzAAO'){
                    system.debug('=========pricebookData__<1>======== ');
                    pricebookData.put('00000std_' + String.valueOf(pbe.CurrencyIsoCode), String.valueOf(pbe.unitprice));
                    pricebookData.put('00000std_' + String.valueOf(pbe.CurrencyIsoCode) + 'CurrencyISOCode', String.valueOf(pbe.CurrencyIsoCode));
                }
                else {
                    system.debug('=========pricebookData__<2>======== ');
                    pricebookData.put(pbe.pricebook2id, String.valueOf(pbe.unitprice));
                    pricebookData.put(pbe.pricebook2id + 'CurrencyISOCode', String.valueOf(pbe.CurrencyIsoCode));
                }
            }
            system.debug('=================> size: ' + pricebookData.size());
             system.debug('=================> ProductData: ' + productInfo);
             system.debug('=================> pricebookData: ' + pricebookData);
            //system.debug('=================> true?: ' + pricebookData.size() > 1);
                if(pricebookData.size() >= 2) //sarvinder: fix for case 68597
                {
                    productResult.put('ProductData', productInfo);
                    productResult.put('PriceBookData', pricebookData);
                    searchResult.put(prd.name, productResult);
                }
                
                system.debug('=================> searchResult: ' + searchResult);
        }
        
        return JSON.serialize(searchResult);
    }  
}