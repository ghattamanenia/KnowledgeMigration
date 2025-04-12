trigger ContractPriceTrigger on SBQQ__ContractedPrice__c (after insert,after update,after delete) 
{
       set<ID> contractIDs = new set<ID>();    
                                                                         
       if(trigger.isInsert || trigger.isUpdate)
       {
            for(SBQQ__ContractedPrice__c  price : trigger.new)
            {
                contractIDs.add(price.Sales_Contract__c);
            }
       }
          
       if(trigger.isDelete)
       {
         for(SBQQ__ContractedPrice__c  price : trigger.old)
         {
            contractIDs.add(price.Sales_Contract__c);
         }        
       }
          
       if(contractIDs.size() > 0 && contractPriceclass.stopRecurssion == false)
       {
          contractPriceclass.updateContract(contractIDs);
       }  
}