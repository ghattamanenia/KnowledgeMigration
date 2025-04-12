trigger contractAfterInsert on Contract (before insert, After Insert,after update) 
{
        
            
            
   
    if(trigger.Isbefore && trigger.isInsert)
    {
            contractHelper.updateContractName(trigger.new,trigger.newmap); 
    }
    
    if(trigger.IsAfter && trigger.isInsert)
    {
    map<ID,ID> conIDs = new map<ID,ID>();
    
    for(Contract oContract: trigger.new)
    {
        if(oContract.Clone_From__c != null)
        {
            conIDs.put(oContract.Clone_From__c,oContract.ID);
        }
    }
    list<SBQQ__ContractedPrice__c> ContractsNew = new list<SBQQ__ContractedPrice__c>();
    
    for(SBQQ__ContractedPrice__c contractPrice: [SELECT ID,PriceBook_Price__c,ATFE_MSRP_Price__c,SBQQ__Account__c,SBQQ__Description__c,SBQQ__Operator__c,SBQQ__Product__c,Sales_Contract__c,SBQQ__Price__c,SBQQ__EffectiveDate__c,SBQQ__FilterValue__c,SBQQ__FilterField__c,SBQQ__ExpirationDate__c,SBQQ__Discount__c,SBQQ__DiscountSchedule__c FROM SBQQ__ContractedPrice__c WHERE Sales_Contract__c IN:conIDs.keyset()])
    {
        SBQQ__ContractedPrice__c temp =  contractPrice.clone(false);        
        temp.Sales_Contract__c  = conIDs.get(contractPrice.Sales_Contract__c);                                  
        
        ContractsNew.add(temp);
        
    }
    
        if(ContractsNew.size() > 0)
        {
            insert ContractsNew;        
        }
        
        
         
    }
   
   if(trigger.isAfter && contractHelper.recurssionflag == false)
       contractHelper.updateContracts(trigger.new);
   
  // if(trigger.isAfter)
  // {
      // if(trigger.isInsert && contractHelper.contractNameRecurssion  == false)
      // {
           // contractHelper.updateContractName(trigger.new,trigger.newmap);  
      // }
  // }   
    

}