public with sharing class OpportunityExtn 
{

    public string opportunityID {get;set;}
    public opportunity opportunityObj;
     public string salesUser {get;set;}
    
    public OpportunityExtn(ApexPages.StandardController stdController) 
    {
    
        salesUser = 'false';
     //   if(userinfo.getProfileId().contains(label.SalesUser_ProfileID) || userinfo.getProfileId().contains(label.Service_User_ProfileID ))
     
     User u = [select Profile.Name , COGS_Access__c from User where id = :userinfo.getUserId()];
     
      If(u.COGS_Access__c == false)
        {
           salesUser = 'true'; 
        }
        
        this.opportunityObj = (opportunity )stdController.getRecord();
        string temp = this.opportunityObj.ID;
        opportunityID = temp.Substring(0,temp.length()-3); 
        opportunityObj = [SELECT ID,
                                 RecordType.Name
                          FROM
                               Opportunity
                          WHERE ID =:  opportunityID    
                         ];     
    }
    
    
    public pageReference verifyRecordType()
    {
        system.debug('****recordType***'+opportunityObj.RecordType.Name);     
        if(opportunityObj.RecordType.Name == 'ATI Opportunity' || opportunityObj.RecordType.Name == 'Editable Amount')
        {
            return null;
        } 
        else
        {
            system.debug('############ returning' + opportunityObj.ID);
            return new pageReference('/'+opportunityObj.ID+'?nooverride=1');
            
        }                              
    }
    
    public list<OpportunityLineItem> getOpplineitems()
    {
     list<OpportunityLineItem> oppLines = new list<OpportunityLineItem>();
         oppLines = [SELECT ID,                           
                            OpportunityId,
                            ATFE_Margin__c,
                            ATFE_Product_Family__c,
                            ATFE_PAC__c,
                            TotalPrice
                            
                      FROM
                           OpportunityLineItem
                      WHERE           
                           OpportunityId =: opportunityObj.ID
                    ];   
        return oppLines;                        
    }

}