public class ServiceAssetMassUpdateCTRL 
{
     
    private ApexPages.StandardSetController standardsetController;
    public list<Service_Asset__c> selectedServiceAssets{set;get;}
    public Service_Asset__c saMassupdate  {get;set;}
    public string accoundID = '';
    public set<ID> SAids = new set<ID>();
    public boolean displayMassUpdate {get;set;}
    
    
    public ServiceAssetMassUpdateCTRL(ApexPages.StandardSetController standardsetController) 
    {
        this.standardsetController= standardsetController;
        system.debug('selected cases in controller:-> ' + (List<Service_Asset__c>) standardsetController.getSelected());
        saMassupdate  = new Service_Asset__c();  
        accoundID  = ApexPages.currentPage().getParameters().get('Id');
    }
        
    public PageReference onload()            
    { 
        selectedServiceAssets =  (List<Service_Asset__c>) standardsetController.getSelected();
        system.debug('**size***'+selectedServiceAssets.size());
        if(selectedServiceAssets.size()<=0)
        {
            apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.error,'Please select at least one record to perform this operation' );
            apexpages.addmessage(msg);
            displayMassUpdate = false;
        }
        else
        {
            displayMassUpdate = true;
        }
        
            for(Service_Asset__c  oSA :selectedServiceAssets )
            {
                SAids.add(oSA.ID);                
            }            
        return null;        
    }
    
    
    public PageReference Save()            
    {
        list<Service_Asset__c> toUpdateSA = new list<Service_Asset__c>();
        
        for(Service_Asset__c  oSA : [SELECT ID,Start_Date__c,End_Date__c ,Asset__c,Purchase_Information__c,Service_Product__c FROM Service_Asset__c WHERE ID IN: SAids])
        {
            Service_Asset__c  temp = new Service_Asset__c(ID=oSA.ID);
                if(saMassupdate.Start_Date__c != null)
                    temp.Start_Date__c = saMassupdate.Start_Date__c;
                if(saMassupdate.End_Date__c  != null)         
                    temp.End_Date__c   = saMassupdate.End_Date__c ;
                if(saMassupdate.Asset__c != null)
                    temp.Asset__c      = saMassupdate.Asset__c ;
                 if(saMassupdate.Opportunity_Raised_Date__c  != null)         
                    temp.Opportunity_Raised_Date__c   = saMassupdate.Opportunity_Raised_Date__c ;    
                if(saMassupdate.Purchase_Information__c!=null)
                temp.Purchase_Information__c=saMassupdate.Purchase_Information__c;
                if(saMassupdate.Account__c!=null)
                temp.Account__c=saMassupdate.Account__c;
                if(saMassupdate.Trace_Id__c!=null)
                temp.Trace_Id__c=saMassupdate.Trace_Id__c;
                if(saMassupdate.Renewal_Date__c!=null)
                temp.Renewal_Date__c=saMassupdate.Renewal_Date__c;
                if(saMassupdate.Renewal_Notice_Sent_Date__c!=null)
                temp.Renewal_Notice_Sent_Date__c=saMassupdate.Renewal_Notice_Sent_Date__c;
                if(saMassupdate.Comments__c!=null)
                temp.Comments__c=saMassupdate.Comments__c;
                if(saMassupdate.Renewal_Not_Sent__c!=null)
                temp.Renewal_Not_Sent__c=saMassupdate.Renewal_Not_Sent__c;   
                          
                //Code added by Neha to help in Mass update and change service asset 1/24/22
                if(saMassupdate.Service_Product__c!=null)
                temp.Service_Product__c=saMassupdate.Service_Product__c;
                
                // end of Neha code changes on 1/24/22
                
              toUpdateSA.add(temp);  
    
        }
        if(toUpdateSA != null && toUpdateSA.size() > 0)
        {
            update toUpdateSA;
        }
      return new PageReference('/'+accoundID) ;  
    }
    
    public PageReference Cancel()            
    {
       return standardsetController.cancel(); 
    }
    
    




 
}