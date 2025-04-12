trigger ServiceContractAfterInsertUpdate on ServiceContract (After Insert,After Update) 
{

        if(ServiceContractAfterInsertUpdateCls.isRecurssion == false)
        {
            ServiceContractAfterInsertUpdateCls.updateServiceAsset(trigger.new);    
        }
}