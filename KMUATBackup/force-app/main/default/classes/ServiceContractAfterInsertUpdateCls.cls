public class ServiceContractAfterInsertUpdateCls
{
    public static boolean isRecurssion = false;
    public static void updateServiceAsset(list<ServiceContract> scList)
    {
        map<ID,ID> scMap = new map<ID,ID>();
        list<Service_Asset__c> updateSAssets = new list<Service_Asset__c>();
        
        
        for(ServiceContract sc : scList)
        {
            if(sc.Service_Asset__c != null)
            {
               scMap.put(sc.Service_Asset__c,sc.ID); 
            }
        }    
            for(Service_Asset__c sa : [SELECT ID FROM Service_Asset__c WHERE ID IN: scMap.keyset()])                        
            {
               Service_Asset__c  otemp  = new Service_Asset__c(ID=sa.ID,Service_Contract__c=scMap.get(sa.ID)); 
               updateSAssets.add(otemp);
            }
    
            if(updateSAssets.size() > 0)
            {
                isRecurssion = true;
                update updateSAssets;
            }
    }


}