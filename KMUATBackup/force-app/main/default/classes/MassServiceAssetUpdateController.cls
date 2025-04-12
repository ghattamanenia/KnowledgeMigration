public class MassServiceAssetUpdateController
{
    private ApexPages.StandardSetController standardController;
    public date startdate {get;set;}
    public date enddate {get;set;}
    public string purchaseinfo {get;set;}
    
    public list<Service_Asset__c> SAToUpdate = new list<Service_Asset__c>();
    
    public MassServiceAssetUpdateController(ApexPages.StandardSetController sc)
    {
        this.standardController = sc;
    }
    
    public PageReference massUpdate()
    {
         List<Service_Asset__c> selectedServiceAssets = (List<Service_Asset__c>) standardController.getSelected();
         SAToUpdate = new list<Service_Asset__c>();
         
         for(Service_Asset__c selectedSA : selectedServiceAssets)
         {
            
                selectedSA.Start_Date__c= startdate;
            
                selectedSA.End_Date__c= enddate;
                selectedSA.Purchase_Information__c=purchaseinfo;
                
                SAToUpdate.add(selectedSA);
            
         }       
         
         if(!SAToUpdate.isempty())
         {
             try
             {
                 update SAToUpdate;
             }catch(exception e){}
         }
         
         PageReference pg = new PageReference('/a5E/o');
         return pg;
    }
}