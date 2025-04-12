public class CaseMassStatusUpdate
{

   public list<case> selectedCases{set;get;}
   //public case cRMAupdate {get;set;}
   public Case cCaseUpdate {get;set;}
   public boolean showblock {get;set;}
   public boolean showerror {get;set;}
   private Id  ATI_RMAChildCaseID;
   private boolean Relcases = false;
  // cRMAupdate = new case();
   private ApexPages.StandardSetController standardController;

    public CaseMassStatusUpdate(ApexPages.StandardSetController standardController)
    {
        this.standardController = standardController;
        system.debug('selected cases in controller:-> ' + (List<Case>) standardController.getSelected());
        cCaseUpdate = new case();
        cCaseUpdate.Status = 'Closed';
       ATI_RMAChildCaseID = [SELECT ID FROM RecordTYpe WHERE SobjectType = 'Case' AND DeveloperName = 'ATI_RMA_Child_Case'].ID;
       // cRMAupdate.recordtypeId =  rID;
        //cRMAupdate.ownerid = UserInfo.getUserId();
        //Get Case record type info through DescribeSObjectResult.
       // Schema.DescribeSObjectResult caseDescribe = Schema.SObjectType.Case; 
       // Map<String,Schema.RecordTypeInfo> caseRtMapByName = caseDescribe.getRecordTypeInfosByName();
    
       // ATI_RMAChildCaseID = caseRtMapByName.get('ATI RMA Child Case').getRecordTypeId();
    
    }

    public PageReference selectCases()
    {       
        // Get the selected records (optional, you can use getSelected to obtain ID's and do your own SOQL)
        selectedCases = (List<Case>) standardController.getSelected();
        system.debug('selected cases are ' + selectedCases);
        
       
                
        if(selectedCases.size()>0)
        {
         for(case selCas : selectedCases )
         {
             if(selCas.RecordTypeid == ATI_RMAChildCaseID  )
             {
                Relcases = true;
                break;
             }
         }
           
        }
       
        if(Relcases == true)
        {
            showblock = true;
            showerror = false;
        }
        else
        {
            showblock = false;
            showerror = true;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No RMA Case record selected. Click the "Back" button and select at least one RMA Case record to perform this operation.'); 
            ApexPages.addMessage(myMsg); 
        }
        return null;        
    }

    public PageReference SubmitChanges()
    {       
       for(case UpdateCase : selectedCases )
       {
        if(UpdateCase.RecordTypeid == ATI_RMAChildCaseID )
         {
           if(cCaseUpdate.Status != null)
               UpdateCase.Status = cCaseUpdate.Status;
           if(cCaseUpdate.ATFE_Status_Comments__c != null)
               UpdateCase.ATFE_Status_Comments__c = cCaseUpdate.ATFE_Status_Comments__c;
         }
             
       }
        // Call StandardSetController 'save' method to update (optional, you can use your own DML)
        return standardController.save();   
    }
    
     public PageReference CancelChanges()
    { 
        return standardController.cancel();  
     }
}