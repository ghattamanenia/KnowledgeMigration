@isTest (seeAlldata=true)
public class AddContractedPriceControllerTest
{
    public static testmethod void testm()
    {
        SBQQ__ContractedPrice__c cp = new SBQQ__ContractedPrice__c();
        SBQQ__ContractedPrice__c cp1 = new SBQQ__ContractedPrice__c();
        cp=[select Id,SBQQ__Account__c,Sales_Contract__c from SBQQ__ContractedPrice__c limit 1];
        cp1=cp.clone();
        /*
        Contract ct = new Contract();
        contract ct1 = new contract();
        ct=[select id,AccountId from contract limit 1];
        ct1=ct.clone();
        ct1.AccountId=cp.Id;
        cp1.SBQQ__Account__c=cp.Id; 
        */ 
        ApexPages.StandardController sc = new ApexPages.StandardController(cp1);

        AddContractedPriceController acp = new AddContractedPriceController(sc);
        acp.onCalculateListPrice();
        acp.onSaveMore();
        acp.onDone();
        
    }
}