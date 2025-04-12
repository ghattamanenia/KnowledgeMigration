global  class autocompleteforProduct{

    public static List<String> AllRel_products{get;set;}
     
    public autocompleteforProduct(CustomerCommunityCretCasHWRegController controller) {
     
    }

    
    @RemoteAction
    global static List<String> getAllRel_products() {
    
     List<Product2> AllRel_prod;// = new List<Product2>();
     AllRel_products= new List<String>();
     system.debug('::AutoComplete ::'  );
     User usr = [SELECT Id, AccountId, ContactId from user where Id =: UserInfo.getUserId()];
     Account RelAccnt = [SELECT Id, Region__c from Account Where Id =: usr.AccountId];
     
        try 
        {
          
         
         if(RelAccnt.Region__c == 'NA')
            AllRel_prod= [select Id, Name FROM Product2  where ATFE_NA__c = true AND Family = 'PRODUCT' and (NOT ProductCode like 'Q%')  AND ProductCode != '' and (NOT ProductCode like '%E+%') ];
        else if(RelAccnt.Region__c == 'CSA')
            AllRel_prod= [select Id, Name FROM Product2  where ATFE_EMEA__c = true  AND Family = 'PRODUCT' and (NOT ProductCode like 'Q%')  AND ProductCode != '' and (NOT ProductCode like '%E+%') ];
        else if(RelAccnt.Region__c == 'EMEA')
            AllRel_prod= [select Id, Name FROM Product2  where ATFE_CSA__c = true AND Family = 'PRODUCT' and (NOT ProductCode like 'Q%')  AND ProductCode != '' and (NOT ProductCode like '%E+%') ];
        else if(RelAccnt.Region__c == 'APAC')
            AllRel_prod= [select Id, Name FROM Product2  where ATFE_APAC__c = true  AND Family = 'PRODUCT' and (NOT ProductCode like 'Q%')  AND ProductCode != '' and (NOT ProductCode like '%E+%') ];
        else
            AllRel_prod= [select Id, Name FROM Product2 where  ATFE_NA__c = false AND ATFE_EMEA__c = false AND ATFE_CSA__c = false and ATFE_APAC__c = false AND Family = 'PRODUCT' and (NOT ProductCode like 'Q%')  AND ProductCode != '' and (NOT ProductCode like '%E+%') ];
          
  
        }
        catch (QueryException e) 
        {
            return null;
        }
        finally{}
        for (Product2 prdct : AllRel_prod)
        {
            
            AllRel_products.add(String.valueOf(prdct.get('Name')));
        }
        system.debug('productList::->' + AllRel_products);
       
       return AllRel_products;
      
    }
}