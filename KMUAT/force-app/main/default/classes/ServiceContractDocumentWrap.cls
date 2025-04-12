public class ServiceContractDocumentWrap
{
    public string contractNumber {get;set;}
    public string serviceType {get;set;}
    public string modelNumber {get;set;}
    public string serialNumber {get;set;}
    public date startDate {get;set;}
    public date endDate {get;set;}
    
    public ServiceContractDocumentWrap(string contractNo,string servType,string modelNo,string serialNo,date stDate,date edDate)
    {
        contractNumber=contractNo;
        serviceType=servType;
        modelNumber=modelNo;
        serialNumber=serialNo;
        startDate=stDate;
        endDate=edDate;
    }
}