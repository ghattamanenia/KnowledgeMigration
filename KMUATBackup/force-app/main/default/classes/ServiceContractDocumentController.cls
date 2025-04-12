public class ServiceContractDocumentController
{
    public list<ServiceContract> childSevContracts {get;set;}
    public ServiceContract scon {get;set;}
    public string currServContractId {get;set;}
    public list<string> currServContractNumber {get;set;}
    public set<Id> ServiceContractIds = new set<Id>();
    public list<Service_Asset__c> serviceAssets {get;set;}
    public list<ServiceContractDocumentWrap> SCDWrapList {get;set;}
    public boolean EMEADateShow {get;set;}
    public boolean NADateShow {get;set;}
    public boolean CSADateShow {get;set;}
    
    
    
    public ServiceContractDocumentController(ApexPages.standardcontroller sc)
    {
        currServContractId='';
        childSevContracts=new list<ServiceContract>();
        scon=new ServiceContract();
        currServContractId=ApexPages.currentpage().getParameters().get('Id');
        currServContractNumber = new list<string>();
        scon=[select Id,Region__c,Account.Name,Contact.Name,Contact.Email,Account.Billingstreet,Account.BillingCity,Account.BillingCountry,Account.BillingState,Account.Billingpostalcode,Technical_Contact__r.Name,Technical_Contact__r.Email,H_W_Asset_Location__c from ServiceContract where Id=:currServContractId];
        if(scon.Region__c=='NA')
        {
            NADateShow=true;
            EMEADateShow=false;
            CSADateShow=false;
            
        }
        if(scon.Region__c=='EMEA')
        {
            EMEADateShow =true;
            NADateShow=false;
            CSADateShow=false;
        }
        
        if(scon.Region__c=='CSA')
        {
            EMEADateShow =false;
            NADateShow=false;
            CSADateShow =true;
        }
        
        
        
        for(serviceContract sca : [select Id,Name from ServiceContract where Id=:currServContractId])
        currServContractNumber.add(sca.Name);
        
        system.debug('@@@@currServContractNumber'+currServContractNumber);
        
        system.debug('@@@@currServContractId'+currServContractId);
        
        SCDWrapList =new list<ServiceContractDocumentWrap>();
        
        
        
        childSevContracts=[select Id,Parent_Service_Contract__c,Service_Asset__c from ServiceContract where (Parent_Service_Contract__c=:currServContractId OR Id=:currServContractId)];
        
        system.debug('@@@@childSevContracts'+childSevContracts);
        
        for(ServiceContract csc:childSevContracts)
        {
            ServiceContractIds.add(csc.Id);
        }
        
        system.debug('@@@@ServiceContractIds'+ServiceContractIds);
        
        serviceAssets=new list<Service_Asset__c>();
        
       serviceAssets=[select Id,Asset__r.Name,Service_Product__r.Name,Service_Product__r.Description,H_W_serial_no__c,Start_Date__c,End_Date__c from Service_Asset__c where Service_Contract__c IN :ServiceContractIds];
        
        for(Service_Asset__c sa:serviceAssets)
        {
            
            SCDWrapList.add(new ServiceContractDocumentWrap(currServContractNumber[0],sa.Service_Product__r.Description.left(sa.Service_Product__r.Description.indexof('-')),sa.Asset__r.Name,sa.H_W_serial_no__c,sa.Start_Date__c,sa.End_Date__c ));
        }
        
        
        system.debug('@@@@@SCDWrapList'+SCDWrapList);
        
        
        
        
    }
    
    
    
    
}