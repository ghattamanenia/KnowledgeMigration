public  class ATFE_PLMUpdateOnQuoteHelper {


public static void updatePLMOnInsert(Set<Id> quoteIds)
{
        updatePLM(quoteIds,null);
}

public static void updatePLMAysncOnDelete(Set<Id> quoteIds,Set<Id> qliIds){
    updatePLM(quoteIds,qliIds);
}
public static void updatePLM(Set<Id> quoteIds,Set<Id> qliIds)
{

        Map<String,ATFE_ProductTypePLM__c> plmMap = ATFE_ProductTypePLM__c.getAll();
        List<Quote> quotesToUpdate = new List<Quote>();
        String plmOwners = '' ;
        List<String> ownerList ;
        Set<String> plmsSet ;
        // Default price
        Object price = 0.0;
       
        if(quoteIds != null && quoteIds.size() > 0)
        {
            // sum of total price in Quote lineitems 
            AggregateResult[] groupedResults  = [SELECT sum(totalprice)totalprice FROM QuoteLineItem WHERE QuoteID IN: quoteIds];      
            price = groupedResults[0].get('totalprice');       
        }    
     
        for(Quote quote : [select ATFE_PLM_s__c ,TotalPrice,(select id ,ATFE_Discount__c , ATFE_Product_Type__c from QuoteLineItems where id not in :qliIds) from Quote where id in :quoteIds   ]){
            plmOwners = '';
            ownerList = new List<String>();
             plmsSet  = new Set<String>();               
            for(QuoteLineItem qli : quote.QuoteLineItems){
                
                if(qli.ATFE_Product_Type__c != null && plmMap.containsKey(qli.ATFE_Product_Type__c))
                {                    
                    if(( qli.ATFE_Discount__c > 0) )
                    {
                        String str = plmMap.get(qli.ATFE_Product_Type__c).ATFE_Product_Owner__c ;
                        if(!plmsSet.contains(str))
                        {
                            ownerList.add(str);
                            plmsSet.add(str);
                        }
                    }
                  
                }
                    
            }
                Quote quoteObj = new  Quote(id = quote.id ); 
                if(ownerList != null && ownerList.size() > 0){
                    ownerList.sort();
                    for(String str : ownerList){
                        plmOwners += str ;
                        plmOwners += ',';
                    }
                    plmOwners = plmOwners.trim();
                    plmOwners = plmOwners.subString(0,plmOwners.length() - 1);
                    System.debug('plmOwners:'+plmOwners);
                    quoteObj.ATFE_PLM_s__c = plmOwners;
                    
            }
            else 
                quoteObj.ATFE_PLM_s__c = 'None';
            quotesToUpdate.add(quoteObj);
            
        }
        if(quotesToUpdate != null && quotesToUpdate.size() > 0)
            update quotesToUpdate ;  
                           
    }
    
   
    
    

}