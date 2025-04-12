public with sharing class AssetCTRL 
{
public Asset__c hwAsset {get;set;}
public boolean isHWSection {get;set;}
public boolean isProductSection {get;set;}
public string ProductString {get;set;}
public list<product2> productsList {get;set;}
public boolean isProduct {get;set;}
public string selectedProduct {get;set;}
public string errorMessage {get;set;}
public Integer count {get;set;}
public user oUser = new user();
public list<string> userCounry = new list<string>();
public map<string,string> userCountryMap = new map<string,string>();
public boolean editpage {get;set;}
public string clonedFrom = '';
public static boolean isFromclone = false;

 
    public AssetCTRL(ApexPages.StandardController controller) 
    {
        editpage = false;
        map<ID,ID> memMap = new map<ID,ID>();       
                
        //hwAsset = new Asset__c();
          hwAsset= (Asset__c)controller.getRecord();
          
        // custom clone
        if(ApexPages.currentPage().getParameters().containsKey('clonedfrom') &&  ApexPages.currentPage().getParameters().get('clonedfrom') != null)
        {
            clonedFrom  = ApexPages.currentPage().getParameters().get('clonedfrom');
                Asset__c otemp = new Asset__c ();            
                memMap.put(clonedFrom,clonedFrom);
            
                Set<ID> keys = memMap.keySet();
                otemp = Database.query(generateQuery());
                hwAsset  = otemp.clone();
                AssetCTRL.isFromclone = true;
        }
        
        
          // Make your dynamic call
          if(hwAsset.ID != null)
          {
            memMap.put(hwAsset.ID,hwAsset.ID);
            Set<ID> keys = memMap.keySet();
            hwAsset  = Database.query(generateQuery());
            editpage = true;            
          }     
                    
        
        //  fullbox custom field      CF00Nm0000000JZ5B_lkid
        boolean tempFlag = false;
        if(ApexPages.currentPage().getParameters().get(label.AccountCFID) != null)
        {
           hwAsset.Account__c =  ApexPages.currentPage().getParameters().get(label.AccountCFID);

        } 
        
        if(ApexPages.currentPage().getParameters().get('prodid') != null && ApexPages.currentPage().getParameters().get('prodid') != '')
        {
           hwAsset.Product__c =  ApexPages.currentPage().getParameters().get('prodid');
           tempFlag = true;
        }
        if(ApexPages.currentPage().getParameters().get('accountid') != null && ApexPages.currentPage().getParameters().get('accountid') != '')
        {
           hwAsset.Account__c =  ApexPages.currentPage().getParameters().get('accountid');
           tempFlag = true;
        }
        
        if(ApexPages.currentPage().getParameters().get('serialnum') != null && ApexPages.currentPage().getParameters().get('serialnum') != '')
        {        
           hwAsset.Serial_Number__c = ApexPages.currentPage().getParameters().get('serialnum');
              tempFlag = true;
        }
        
        if(tempFlag)
        {
           hwAsset.Start_Date__c = system.today();
        }                               
 


        
        isHWSection = true;
        isProductSection  = false;
        ProductString  = '';
        isProduct = false;
        errorMessage = '';
        count = 0;
        productsList  = new list<product2>();
        
          

    }
    
    public string generateQuery()
    {
        Map<String, Schema.SObjectField> fldObjMap = schema.SObjectType.Asset__c.fields.getMap();
        List<Schema.SObjectField> fldObjMapValues = fldObjMap.values();
        
        String theQuery = 'SELECT ';
        for(Schema.SObjectField s : fldObjMapValues)
        {
           String theLabel = s.getDescribe().getLabel(); 
           String theName = s.getDescribe().getName();
                           
           theQuery += theName + ',';
        }
        
        // Trim last comma
        theQuery = theQuery.subString(0, theQuery.length() - 1);        
                            
        theQuery += ' FROM Asset__c WHERE ID IN :keys' ;
        
        
        return theQuery;
    }
    public PageReference  save()
    {   
        if(clonedFrom != '')
        {
                AssetCTRL.isFromclone = true;
        }
        
        if(hwAsset.Id == null)     
            insert hwAsset;
        else
            update hwAsset;
        
                
        PageReference hwPage = new ApexPages.StandardController(hwAsset).view();
        hwPage.setRedirect(true);
        return hwPage ;
    
    }
    
    public PageReference   savenew()
    {
        if(hwAsset.Id == null)     
            insert hwAsset;
        else
            update hwAsset;

                
       // return new PageReference ('/apex/HardwareAssetNew');
        PageReference pr = new PageReference('/apex/HardwareAssetNew');
        pr.getParameters().put(label.AccountCFID,hwAsset.Account__c);
         
        pr.setRedirect(true); 
        return pr;         
    }
    
    public PageReference  cancel()
    {
        Schema.DescribeSObjectResult r = Asset__c.sObjectType.getDescribe();
        String keyPrefix = r.getKeyPrefix();
        
        if(clonedFrom  != '')
        {
          return new PageReference ('/'+clonedFrom);  
        }
        
        if(hwAsset != null && hwAsset.Id == null)   
            return new PageReference ('/'+keyPrefix );
        else
            return new PageReference ('/'+hwAsset.ID );
    }
  /*  
    public PageReference   SearchProduct()
    {
        productsList = new list<Product2>();
        ProductString = '';
        isHWSection = false;
        isProduct = false;
        count = 0;
        isProductSection   = true;
        return null;
    }
    
    public PageReference  back()
    {
        isHWSection = true;
        isProductSection   = false;
        count = 0;
        return null;
    }
    
    public PageReference FilterProduct()
    {    
        // ge user details for country 
        oUser  = [SELECT ID,Price_Book_Region__c FROM USER WHERE ID=:userinfo.getUserId()];         
        userCounry = oUser.Price_Book_Region__c.split(';');
        
        for(string oString : userCounry)
        {
            userCountryMap.put(oString,oString );
        }
                     
        // search products  
        errorMessage = '';  
        count = 0;   
        productsList = new list<Product2>();
        if(ProductString != '' && ProductString.length() > 1)
        {

            String wildcardSearchText='%'+ ProductString+ '%';            
            list<product2> producttemp = [SELECT ID,
                                   Name,
                                   ProductCode,
                                   Description,
                                   Family,
                                   ATFE_ProductRegion__c 
                             FROM 
                                  PRODUCT2
                             WHERE 
                                  IsActive = true
                                  AND
                                  Family = 'PRODUCT'                                  
                                  AND                                   
                                  NAME LIKE :wildcardSearchText 
                                  
                                  LIMIT 800];
            for(product2 oproduct : producttemp)                                  
            {
                isProduct = true;
                if(oproduct.ATFE_ProductRegion__c != null && userCountryMap != null && userCountryMap.containsKey(oproduct.ATFE_ProductRegion__c))
                {
                  productsList.add(oproduct);  
                }
            }
           count = productsList.size();            
        }
        else
        {
           errorMessage = 'Error: Please enter a search string at least 2 characters long.';
           //errorMsg
        }            
    
        return null;
    }
    
     public PageReference getSelected() 
     {     

     if(ApexPages.currentPage().getParameters().get('id') != null)
     {
      System.debug('ProductID*****'+ApexPages.currentPage().getParameters().get('id'));               
      hwAsset.Product__c = ApexPages.currentPage().getParameters().get('id');
     }

      return back();
    }
    
     public PageReference navigateProduct() 
     {
     if(ApexPages.currentPage().getParameters().get('id') != null)
     {
      System.debug('ProductID*****'+ApexPages.currentPage().getParameters().get('id'));                 
      Product2 tempProduct = [SELECT ID,Name FROM Product2 WHERE ID =: ApexPages.currentPage().getParameters().get('id')];      
      //hwAsset.Product__c = [SELECT ID,Name FROM Product2 WHERE ID =: ApexPages.currentPage().getParameters().get('id')].ID;
      selectedProduct = tempProduct.Name; 
      hwAsset.Product__c = tempProduct.ID;
     }

        system.debug('******log*****'+hwAsset);
        isHWSection = true;
        isProductSection   = false;
      return null;
    }
    */
       
}