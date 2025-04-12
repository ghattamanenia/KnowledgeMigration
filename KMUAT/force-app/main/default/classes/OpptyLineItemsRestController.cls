@RestResource(urlMapping='/OpptyLineItems/*')
Global with sharing class OpptyLineItemsRestController
{
    @HttpPost
    
    Global static list<OpptyLineItemsWapper> doPost(datetime startDateTime,datetime endDateTime)
    {
        
        
        list<OpportunityLineItem > OpptyLineItems = new list<OpportunityLineItem >();
        
        list<OpptyLineItemsWapper> OpLineWraplist = new list<OpptyLineItemsWapper>();
        
        list<Exceptions__c> exceptions = new list<Exceptions__c>();
        
        set<Id> OppIds = new set<Id>();
        
        Map<Id,String> OpptyIdDistriNameMap = new map<Id,string>();
        
        for(OpportunityLineItem ol:[select Id,OpportunityId from OpportunityLineItem where Opportunity.LastModifiedDate>=:startDateTime and Opportunity.LastModifiedDate<=:endDateTime and Opportunity.Account.Region__c='APAC'])
        {
            OppIds.add(ol.OpportunityId);
        }
        
        
        for(OpportunityPartner Opart:[select id,OpportunityId,Role,AccountToId,AccountTo.Name,isprimary from OpportunityPartner where isprimary=true and Role='Distributor' and OpportunityId IN :OppIds])
        {
            OpptyIdDistriNameMap.put(Opart.OpportunityId,Opart.AccountTo.Name);
        }
        
        
        if(!Test.isrunningTest())
        OpptyLineItems = [SELECT Id,Opportunity.LastModifiedDate,CurrencyIsoCode,Opportunity.NextStep,opportunity.Special_Opportunity__c,Opportunity.ATFE_OppID__c,Discount,OpportunityId,opportunity.ATFE_SalesOrgName__c,Opportunity.Owner.Name,Product2.name,Product2.Description,Product2Id,ProductCode, Name, UnitPrice, ListPrice, Quantity, MSRP_Price__c, MSRP_Discount__c,Opportunity.Name,opportunity.StageName,opportunity.Amount,opportunity.Probability,lastmodifieddate,createddate,opportunity.Required_Delivery_Date__c FROM OpportunityLineItem where Opportunity.LastModifiedDate>=:startDateTime and Opportunity.LastModifiedDate<=:endDateTime and Opportunity.Account.Region__c='APAC'];
        else
        {
            
            OpptyLineItems = [SELECT Id,Opportunity.LastModifiedDate,CurrencyIsoCode,Opportunity.NextStep,opportunity.Special_Opportunity__c,Opportunity.ATFE_OppID__c,Discount,OpportunityId,opportunity.ATFE_SalesOrgName__c,Opportunity.Owner.Name,Product2.name,Product2.Description,Product2Id,ProductCode, Name, UnitPrice, ListPrice, Quantity, MSRP_Price__c, MSRP_Discount__c,Opportunity.Name,opportunity.StageName,opportunity.Amount,opportunity.Probability,lastmodifieddate,createddate,opportunity.Required_Delivery_Date__c FROM OpportunityLineItem where Opportunity.LastModifiedDate < THIS_WEEK and Opportunity.Account.Region__c='APAC' Limit 10];
            string URL= TestDataUtility.OpptyLineItemsRestControllerURL;
        }
        
        try
        {
            for(OpportunityLineItem oli:OpptyLineItems)
            {
                OpptyLineItemsWapper oliw = new OpptyLineItemsWapper();
                oliw.Unique_ID=oli.Id;
                oliw.OppID=oli.Opportunity.ATFE_OppID__c;
                oliw.ProductCode=oli.ProductCode;
                oliw.ProductDesc=oli.Product2.Description;
                oliw.CurrencyType=oli.CurrencyIsoCode;
                oliw.UnitPrice=oli.UnitPrice;
                oliw.ListPrice=oli.ListPrice;
                oliw.Quantity=oli.Quantity;
                if(oli.Opportunity.NextStep!=null)
                oliw.NextStep=oli.Opportunity.NextStep;
                else
                oliw.NextStep='';
                if(oli.Discount != null)
                oliw.Discount=oli.Discount;
                else
                oliw.Discount=0.0;
                oliw.LastModifiedDate=oli.Opportunity.LastModifiedDate;
                oliw.CreatedDate=oli.CreatedDate;
                oliw.Probability=oli.opportunity.Probability;
                oliw.Owner=oli.Opportunity.Owner.Name;
                oliw.Sales_Department=oli.Opportunity.ATFE_SalesOrgName__c;
                oliw.Required_Delivery_Date=oli.opportunity.Required_Delivery_Date__c;
                oliw.StageName=oli.Opportunity.StageName;
                if(OpptyIdDistriNameMap.keyset().contains(oli.OpportunityId))
                oliw.distributor=OpptyIdDistriNameMap.get(oli.OpportunityId);
                else
                oliw.distributor='';
                oliw.specialopportunity=oli.opportunity.Special_Opportunity__c;
                OpLineWraplist.add(oliw);
            
            }
           }catch(Exception e)
           {
               exceptions.add(new Exceptions__c(Exception_Date_Time__c=system.now(),Exception_Description__c=e.getMessage(),Exception_Source__c='OpptyLineItemsRestController',Exception_Type__c=e.getTypeName()));
               
               if(!exceptions.isempty())
               Insert exceptions;
              
           }
        
        return OpLineWraplist;
    }
    
    
}