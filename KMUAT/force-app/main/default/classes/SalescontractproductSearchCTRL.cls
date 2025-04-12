public with sharing class SalescontractproductSearchCTRL 
{
public list<product2> productlist = new list<product2>();
public string ProductString{get;set;}
public string errorMessage {get;set;}
public integer count {get;set;}
public Integer noOfRecords{get; set;}
public Integer size{get;set;}
public boolean resultFound {get;set;}    
public user oUser = new user();
public list<string> userCounry = new list<string>();
public map<string,string> userCountryMap = new map<string,string>();
public string countryString = '';
public integer productName {get;set;}
public string pricebookid = '';    
    
public SalescontractproductSearchCTRL()
{
    productName  = 0;
    ProductString = '';
    errorMessage = '';
    count = 0;   
    errorMessage = '';
    resultFound  = false;
  
   // ge user details for country 
        oUser  = [SELECT ID,Price_Book_Region__c FROM USER WHERE ID=:userinfo.getUserId()];         
        userCounry = oUser.Price_Book_Region__c.split(';');
        string tempString = '';
        integer count = 1;               
        if(system.currentPageReference().getParameters().get('lksrch') != null)
           ProductString =  system.currentPageReference().getParameters().get('lksrch');
        
        pricebookid  = system.currentPageReference().getParameters().get('pricebookID');
        
      
       
        for(string oString : userCounry)
        {        
           if(oString.contains('NA'))
           {            
               if(count > 1){               
                   tempString = tempString + ' OR ' + ' ATFE_NA__c = true ';
               }    
               else{
                   tempString = ' ATFE_NA__c = true ';
                   count++;
               }                                                       
           }
           if(oString.contains('EMEA'))
           {             
               if(count > 1){
                   tempString = tempString + ' OR ' + ' ATFE_EMEA__c  = true ';
               }    
               else{
                   tempString = ' ATFE_EMEA__c = true ';
                    count++;                                    
               }
               
               if(count > 1){
                   tempString = tempString + ' OR ' + ' ATFE_CSA__c  = true ';
                   }
               else{
                   tempString = ' ATFE_CSA__c  = true ';
                    count++;
               }                         
           }
           if(oString.contains('APAC'))
           {
              if(count > 1){
                   tempString = tempString + ' OR ' + ' ATFE_APAC__c  = true ';
               }    
               else{
                   tempString = ' ATFE_APAC__c  = true ';
               count++;
               }              
           } 
                                
                      
        }
   
    // countryString =  ' AND ( ' + tempString + ' ) ';
      countryString = '';
     // AND (ATFE_NA__c = true OR ATFE_EMEA__c = true OR ATFE_CSA__c = true OR ATFE_APAC__c = true) 
     system.debug('***countryString***'+countryString);
}

    
    
    public ApexPages.StandardSetController setCon 
    {
        get
        {
        if(ProductString == null || ProductString  == '')
            setCon = null;
           
            if(setCon == null && ProductString != null && ProductString != '' && ProductString.length() > 1)
            {      
             
                set<Id> productIds = new set<ID>();
                
                for(PricebookEntry pe : [SELECT ID,Product2Id FROM PricebookEntry WHERE Pricebook2Id =: pricebookid  ])
                {
                  productIds.add(pe.Product2Id);  
                }
             
                resultFound = true;          
                size = 20;   
                ProductString = ProductString.replace('*', '');               
                String wildcardSearchText='\'%' + String.escapeSingleQuotes(ProductString.trim()) + '%\'';                                                                       
                string queryString = 'Select Name,ProductCode,Description,Family,IsActive,ATFE_APAC__c,ATFE_CSA__c,ATFE_EMEA__c,ATFE_NA__C  from Product2 WHERE  ID IN: productIds AND  ProductCode != null AND ( NOT ProductCode LIKE \'Q%\') AND (NOT ProductCode LIKE \'%E+%\') AND NAME LIKE '+ wildcardSearchText+' AND IsActive = true Order  by Name LIMIT 200';
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
                setCon.setPageSize(size);                
                noOfRecords = setCon.getResultSize();
            }
            else
            {
               // errorMessage = 'Error: Please enter a search string at least 2 characters long.';
            }
            return setCon;
        }
        set;
    }
    




public PageReference FilterProduct()
{   
   setCon = null;
    if(ProductString != null && ProductString != '' && ProductString.length() > 1)
    {
        errorMessage = '';
     
        getProducts();
        setCon.setPageNumber(1);
    }     
    else
        errorMessage = 'Error: Please enter a search string at least 2 characters long.';
    return null;
}

// used by the visualforce page to send the link to the right dom element
public string getFormTag() 
{
    return System.currentPageReference().getParameters().get('frm');
}

// used by the visualforce page to send the link to the right dom element for the text box
public string getTextBox() 
{
    return System.currentPageReference().getParameters().get('txt');
}

     
    public List<Product2> getProducts()
    {
        productName  = 0;
        List<Product2> proList = new List<Product2>();
        if(setCon != null && setCon.getRecords() != null &&  setCon.getRecords().size() > 0 )
        {
            resultFound = true;
            for(Product2 a : (List<Product2>)setCon.getRecords())
            {
                if(a.Name.length() > productName )
                {
                   productName = a.Name.length() + 10; 
                }
                // if(a.ATFE_ProductRegion__c != null && userCountryMap != null && userCountryMap.containsKey(a.ATFE_ProductRegion__c))
                    proList.add(a);
            }
        }
        return proList;
    }
     
    public pageReference refresh() 
    {
        setCon = null;
        getProducts();
        setCon.setPageNumber(1);
        return null;
    }
     
    public Boolean hasNext 
    {
        get 
        {
            if(setCon != null)
                return setCon.getHasNext();
            else
                return false;
        }
        set;
    }
    public Boolean hasPrevious 
    {
        get 
        {
            if(setCon != null)            
                return setCon.getHasPrevious();
            else
                return false;
        }
        set;
    }
  
    public Integer pageNumber 
    {
        get 
        {
            if(setCon != null)
                return setCon.getPageNumber();
            else
                return 0;
        }
        set;
    }
  
    public void first() 
    {
        setCon.first();
    }
  
    public void last() 
    {
        setCon.last();
    }
  
    public void previous() 
    {
        setCon.previous();
    }
  
    public void next() 
    {
        setCon.next();
    }


  
  
}