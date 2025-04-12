public with sharing class ServiceSearchCTRL
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
    
    
public ServiceSearchCTRL()
{
    ProductString = '';
    errorMessage = '';
    count = 0;   
    errorMessage = '';
    resultFound  = false;
    
   if(system.currentPageReference().getParameters().get('lksrch') != null)
       ProductString =  system.currentPageReference().getParameters().get('lksrch');
           
    
   //get user details for country 
        oUser  = [SELECT ID,Price_Book_Region__c FROM USER WHERE ID=:userinfo.getUserId()];         
        userCounry = oUser.Price_Book_Region__c.split(';');
        string tempString = '';
        integer count = 1;               
        
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
                 resultFound = true;          
                size = 20;   
                ProductString = ProductString.replace('*', '');               
                String wildcardSearchText='\'%' + String.escapeSingleQuotes(ProductString.trim()) + '%\'';                                                                       
                string queryString = 'Select Name,IsActive,ProductCode,Description,Family,ATFE_ProductRegion__c,ATFE_APAC__c,ATFE_CSA__c,ATFE_EMEA__c,ATFE_NA__C  from Product2 WHERE Family = \'SERVICE\' AND NAME LIKE '+ wildcardSearchText+' Order  by Name LIMIT 200';
            //AND ProductCode != null AND ( NOT ProductCode LIKE \'Q%\') AND (NOT ProductCode LIKE \'%E+%\')                 
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
    




public PageReference FilterService()
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
        List<Product2> proList = new List<Product2>();
        if(setCon != null && setCon.getRecords() != null &&  setCon.getRecords().size() > 0 )
        {
            resultFound = true;
            for(Product2 a : (List<Product2>)setCon.getRecords())
            {
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