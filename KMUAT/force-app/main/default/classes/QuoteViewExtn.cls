public with sharing class QuoteViewExtn {

    public string quoteID {get;set;}
    public string pricebookName {get;set;}
    public SBQQ__Quote__c oQuote;
    public string salesUser {get;set;}
    
    
    public QuoteViewExtn(ApexPages.StandardController stdController) 
    {
        salesUser = 'false';
     //   if(userinfo.getProfileId().contains(label.SalesUser_ProfileID) || userinfo.getProfileId().contains(label.Service_User_ProfileID ))
     
     User u = [select Profile.Name , COGS_Access__c from User where id = :userinfo.getUserId()];
     
      If(u.COGS_Access__c == false)
        {
           salesUser = 'true'; 
        }
        
     this.oQuote = (SBQQ__Quote__c)stdController.getRecord();
     string temp = this.oQuote.ID;
     quoteID  = temp.Substring(0,temp.length()-3);   
        
        oQuote = [SELECT ID,
                         RecordType.Name,Quote_To_Pricebook_Name__c
                  FROM
                        SBQQ__Quote__c
                  WHERE ID =: oQuote.ID
                  ];
        
        this.pricebookName = oQuote.Quote_To_Pricebook_Name__c;
        
    }
    
     public pageReference verifyRecordType()
    {
     system.debug('****recordType***'+oQuote.RecordType.Name);
     
        if(oQuote.RecordType.Name == 'ATFE_Quote After Approval' || oQuote.RecordType.Name == 'ATFE_Quote Before Approval')
        {
            return null;
        } 
        else
        {
            return new pageReference('/'+oQuote.ID+'?nooverride=1');
        }                       
        
    }
    
    
    public list<SBQQ__QuoteLine__c> getQlineitems()
    {
    list<SBQQ__QuoteLine__c> qLineitems = new list<SBQQ__QuoteLine__c>();
     qLineitems = [SELECT ID,
                        ATFE_Margin__c,
                        ATFE_QuoteId__c,
                        SBQQ__Quote__c  ,
                        ATFE_Product_Family__c ,
                        MSRP_Pricebook_ID__c,                        
                        SBQQ__NetTotal__c,
                        ATFE_PAC__c,
                        CurrencyISOCode                    
                  FROM
                       SBQQ__QuoteLine__c
                  WHERE SBQQ__Quote__c  =: this.oQuote.ID
                 ]; 
        return  qLineitems ;                  
    }
    

}