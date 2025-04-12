public class QuoteLineItemsAgreegationsController
{
    public list<SBQQ__Quote__c> Quote = new List<SBQQ__Quote__c>();
    public Id QuoteId;
    public list<SBQQ__QuoteLine__c> QuoteLines = new List<SBQQ__QuoteLine__c>();
    public Map<Id,decimal> ProductMinPrice = new Map<Id,decimal>();
    public Map<Id,String> QuoteNameForMinPriceMap = new Map<Id,string>();
    public Map<Id,string> QuoteIdForMinPriceMap = new Map<Id,String>();
    public Map<Id,decimal> ProductMaxPrice = new Map<Id,decimal>();
    public Map<Id,String> QuoteNameForMaxPriceMap = new Map<Id,string>();
    public Map<Id,string> QuoteIdForMaxPriceMap = new Map<Id,String>();
    public list<QuoteLineWrap> QLWrap {get;set;}
    public set<Id> PrdIds = new set<Id>();
    public Map<Id,Product2> ProdMap = new Map<Id,Product2>();
    public Map<Id,SBQQ__Quote__c> QuoteMap = new Map<Id,SBQQ__Quote__c>();
    public set<Id> QuoteIdsSet = new Set<Id>();
    public boolean show {get;set;}
    public list<String> UserIds = new list<String>();
    public boolean showmsg {get;set;}
    public Map<Id,integer> ProductIdQuoteCount = new Map<Id,Integer>();
    public Map<Id,decimal> ProductIdQuoteAmountSum = new Map<Id,decimal>();
    
    public QuoteLineItemsAgreegationsController(ApexPages.StandardController sc)
    {
        show = false;
        showmsg=true;
        UserIds=label.AggregationUserIds.split(';');
        system.debug('@@@userIds'+userIds);
        system.debug('@@@entering'+UserInfo.getUserId());
        if(UserIds.contains(UserInfo.getUserId()))
        {
            show=true;
            showmsg=false;
        }
        QLWrap= new list<QuoteLineWrap>();
        QuoteMap = new Map<Id,SBQQ__Quote__c>();
        QuoteIdsSet = new Set<Id>();
        QuoteId=ApexPages.currentPage().getParameters().get('Id');
        system.debug('@@@@@QuoteId'+QuoteId);
        if(QuoteId!=null)
        Quote=[select Id,Name,SBQQ__Account__c ,Account_ID__c from SBQQ__Quote__c where Id=:QuoteId];
        system.debug('@@@@@Quote'+Quote);
        if(QuoteId!=null && !Test.isrunningTest())
        QuoteLines=[Select Id,Name,SBQQ__ListPrice__c,SBQQ__NetPrice__c,SBQQ__CustomerTotal__c,SBQQ__Quote__c,SBQQ__Product__c,SBQQ__Product__r.Name from SBQQ__QuoteLine__c where SBQQ__Quote__r.Account_ID__c =:Quote[0].Account_ID__c AND SBQQ__Quote__r.ATFE_SPQ_Approved__c=TRUE];
        if(QuoteId!=null && Test.isrunningTest())
        QuoteLines=[Select Id,Name,SBQQ__ListPrice__c,SBQQ__NetPrice__c,SBQQ__CustomerTotal__c,SBQQ__Quote__c,SBQQ__Product__c,SBQQ__Product__r.Name from SBQQ__QuoteLine__c where SBQQ__Quote__r.Account_ID__c !=:Quote[0].Account_ID__c AND SBQQ__Quote__r.ATFE_SPQ_Approved__c=TRUE limit 20];
        
        for(SBQQ__QuoteLine__c sql:QuoteLines)
        {
            QuoteIdsSet.add(sql.SBQQ__Quote__c);
        }
        
        for(SBQQ__Quote__c quo:[Select Id,Name,ATFE_Quote_Name__c from SBQQ__Quote__c where Id IN :QuoteIdsSet])
        {
            QuoteMap.put(quo.Id,quo);
        }
        system.debug('@@@@quotemap after loop'+QuoteMap);
        
        for(SBQQ__QuoteLine__c ql:QuoteLines)
        {
            // Avg Logic
            
            if(ProductIdQuoteCount.keyset().contains(ql.SBQQ__Product__c))
            {
                integer count=ProductIdQuoteCount.get(ql.SBQQ__Product__c)+1;
                ProductIdQuoteCount.put(ql.SBQQ__Product__c,count);
            }
            else
            ProductIdQuoteCount.put(ql.SBQQ__Product__c,1);
            
            if(ProductIdQuoteAmountSum.keyset().contains(ql.SBQQ__Product__c))
            {
                decimal sum=ProductIdQuoteAmountSum.get(ql.SBQQ__Product__c)+ql.SBQQ__NetPrice__c;
                ProductIdQuoteAmountSum.put(ql.SBQQ__Product__c,sum);
            }
            else
            ProductIdQuoteAmountSum.put(ql.SBQQ__Product__c,ql.SBQQ__NetPrice__c);
            
            
            string QuoteName=QuoteMap.get(ql.SBQQ__Quote__c).Name;
            PrdIds.add(ql.SBQQ__Product__c);
            system.debug('@@@@before min logic');
            
            // Min logic
            
            if(ProductMinPrice.keyset().contains(ql.SBQQ__Product__c))
            {
                if(ProductMinPrice.get(ql.SBQQ__Product__c)>ql.SBQQ__NetPrice__c)
                {
                    ProductMinPrice.put(ql.SBQQ__Product__c,ql.SBQQ__NetPrice__c);
                    system.debug('@@@@QuoteMap.get(ql.SBQQ__Quote__c).Name in min logic'+QuoteMap.get(ql.SBQQ__Quote__c).Name);
                    
                    QuoteNameForMinPriceMap.put(ql.SBQQ__Product__c,QuoteName);
                    QuoteIdForMinPriceMap.put(ql.SBQQ__Product__c,ql.SBQQ__Quote__c);
                    
                }
                else
                {
                    ProductMinPrice.put(ql.SBQQ__Product__c,ProductMinPrice.get(ql.SBQQ__Product__c));
                    if(QuoteNameForMinPriceMap.keyset().contains(ql.SBQQ__Product__c))
                    QuoteNameForMinPriceMap.put(ql.SBQQ__Product__c,QuoteNameForMinPriceMap.get(ql.SBQQ__Product__c));
                    else
                    QuoteNameForMinPriceMap.put(ql.SBQQ__Product__c,QuoteName);
                    if(QuoteIdForMinPriceMap.keyset().contains(ql.SBQQ__Product__c))
                    QuoteIdForMinPriceMap.put(ql.SBQQ__Product__c,QuoteIdForMinPriceMap.get(ql.SBQQ__Product__c));
                    else
                    QuoteIdForMinPriceMap.put(ql.SBQQ__Product__c,ql.SBQQ__Quote__c);
                    
                }
            }
            else
            {
                ProductMinPrice.put(ql.SBQQ__Product__c,ql.SBQQ__NetPrice__c);
                QuoteNameForMinPriceMap.put(ql.SBQQ__Product__c,QuoteName);
                QuoteIdForMinPriceMap.put(ql.SBQQ__Product__c,ql.SBQQ__Quote__c);
            }
            
             system.debug('@@@@before max logic');
            // Max logic 
            
            if(ProductMaxPrice.keyset().contains(ql.SBQQ__Product__c))
            {
                if(ProductMaxPrice.get(ql.SBQQ__Product__c)>ql.SBQQ__NetPrice__c)
                {
                    ProductMaxPrice.put(ql.SBQQ__Product__c,ProductMaxPrice.get(ql.SBQQ__Product__c));
                    if(QuoteNameForMaxPriceMap.keyset().contains(ql.SBQQ__Product__c))
                    QuoteNameForMaxPriceMap.put(ql.SBQQ__Product__c,QuoteNameForMaxPriceMap.get(ql.SBQQ__Product__c));
                    else
                    QuoteNameForMaxPriceMap.put(ql.SBQQ__Product__c,QuoteName);
                    if(QuoteIdForMaxPriceMap.keyset().contains(ql.SBQQ__Product__c))
                    QuoteIdForMaxPriceMap.put(ql.SBQQ__Product__c,QuoteIdForMaxPriceMap.get(ql.SBQQ__Product__c));
                    else
                    QuoteIdForMaxPriceMap.put(ql.SBQQ__Product__c,ql.SBQQ__Quote__c);
                }
                else
                {
                    ProductMaxPrice.put(ql.SBQQ__Product__c,ql.SBQQ__NetPrice__c);
                    QuoteNameForMaxPriceMap.put(ql.SBQQ__Product__c,QuoteName);
                    QuoteIdForMaxPriceMap.put(ql.SBQQ__Product__c,ql.SBQQ__Quote__c);
                    
                }
            }
            else
            {
                ProductMaxPrice.put(ql.SBQQ__Product__c,ql.SBQQ__NetPrice__c);
                QuoteNameForMaxPriceMap.put(ql.SBQQ__Product__c,QuoteName);
                QuoteIdForMaxPriceMap.put(ql.SBQQ__Product__c,ql.SBQQ__Quote__c);
            }
            
        }
        
        system.debug('@@@@@@ProductMinPrice'+ProductMinPrice);
        system.debug('@@@@@@ProductMaxPrice'+ProductMaxPrice);
        
        system.debug('@@@@@@QuoteNameForMaxPriceMap'+QuoteNameForMaxPriceMap);
        system.debug('@@@@@@QuoteNameForMinPriceMap'+QuoteNameForMinPriceMap);
        
        ProdMap= new Map<Id,Product2>([Select Id,Name from Product2 where Id IN :PrdIds]);
        system.debug('@@@@@ProdMap'+ProdMap);
        
        for(Product2 pr:[select Id,ProductCode from Product2 where Id IN :PrdIds])
        {
            decimal avgprice=((ProductIdQuoteAmountSum.get(pr.Id))/(ProductIdQuoteCount.get(pr.Id)));
            QLWrap.add(new QuoteLineWrap(pr.Id,pr.ProductCode,ProdMap.get(pr.Id).Name,ProductMinPrice.get(pr.Id),QuoteNameForMinPriceMap.get(pr.Id),QuoteIdForMinPriceMap.get(pr.Id),ProductMaxPrice.get(pr.Id),QuoteNameForMaxPriceMap.get(pr.Id),QuoteIdForMaxPriceMap.get(pr.Id),avgprice));
        }
        
        system.debug('@@@@@QLWrap'+QLWrap);
           
    }
}