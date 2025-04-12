public class QuoteLineWrap
{
    public Id PrdId {get;set;}
    public string Name {get;set;}
    public decimal Minprice {get;set;}
    public string MinpriceQuoteName {get;set;}
    public string MinpriceQuoteId {get;set;}
    public decimal Maxprice {get;set;}
    public string MaxpriceQuoteName {get;set;}
    public string MaxpriceQuoteId {get;set;}
    public string ProductCode {get;set;}
    public decimal avgPrice {get;set;}
    
    public QuoteLineWrap(Id LineId,string prcode,String PrdName,decimal MinItemprice,string MinPriceQteName,string MinPriceQteId,decimal MaxItemPrice,string MaxPriceQteName,string MaxPriceQteId,decimal averageprice)
    {
        PrdId=LineId;
        Name=PrdName;
        Minprice=MinItemprice;
        MinpriceQuoteName=MinPriceQteName;
        MinpriceQuoteId =MinPriceQteId;
        Maxprice=MaxItemPrice;
        MaxpriceQuoteName =MaxPriceQteName;
        MaxpriceQuoteId =MaxPriceQteId;
        ProductCode=prcode;
        avgPrice=averageprice;
        
    }
}