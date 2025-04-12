public class CaseMassRMAupdate
{

   public list<case> selectedCases{set;get;}
   //public case cRMAupdate {get;set;}
   public Case cRMAupdate {get;set;}
   public boolean showblock {get;set;}
   public boolean showerror {get;set;}
   private Id  ATI_RMAChildCaseID;
   private boolean Relcases = false;
  // cRMAupdate = new case();
   private ApexPages.StandardSetController standardController;

    public CaseMassRMAupdate(ApexPages.StandardSetController standardController)
    {
        this.standardController = standardController;
        system.debug('selected cases in controller:-> ' + (List<Case>) standardController.getSelected());
        cRMAupdate = new case();
        cRMAupdate.Status = '';
       // ID rID = [SELECT ID FROM RecordTYpe WHERE SobjectType = 'Case' AND Name = 'ATI RMA Child Case'].ID;
       // cRMAupdate.recordtypeId =  rID;
        //cRMAupdate.ownerid = UserInfo.getUserId();
        //Get Case record type info through DescribeSObjectResult.
        Schema.DescribeSObjectResult caseDescribe = Schema.SObjectType.Case; 
        Map<String,Schema.RecordTypeInfo> caseRtMapByName = caseDescribe.getRecordTypeInfosByName();
    
        ATI_RMAChildCaseID = caseRtMapByName.get('ATI RMA Child Case').getRecordTypeId();
    
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
       for(case caseupdate : selectedCases )
       {
        if(caseupdate.RecordTypeid == ATI_RMAChildCaseID )
         {
           if(cRMAupdate.Ownerid != null)
               caseupdate.Ownerid = cRMAupdate.Ownerid;
           if(cRMAupdate.Status != null)
               caseupdate.Status = cRMAupdate.Status;
               
          // if(cRMAupdate.Date_of_Purchase__c != null)
          //     caseupdate.Date_of_Purchase__c = cRMAupdate.Date_of_Purchase__c;
          if(cRMAupdate.TAC_Comments__c!= null)
              caseupdate.TAC_Comments__c = cRMAupdate.TAC_Comments__c;
              
           if(cRMAupdate.RMA_Reason__c != null)    
               caseupdate.RMA_Reason__c = cRMAupdate.RMA_Reason__c; 
           if(cRMAupdate.ATI_Fault_Code_1__c != null)
               caseupdate.ATI_Fault_Code_1__c = cRMAupdate.ATI_Fault_Code_1__c;
           if(cRMAupdate.RMA_Service_Offered__c != null)
               caseupdate.RMA_Service_Offered__c = cRMAupdate.RMA_Service_Offered__c;
           if(cRMAupdate.RMA_Status__c != null)
           {
               caseupdate.RMA_Status__c = cRMAupdate.RMA_Status__c; 
               caseupdate.RMA_Status_Date__c = date.today(); // if status is changing , change the date too
           }
           if(cRMAupdate.RMA_Number__c != null)
               caseupdate.RMA_Number__c = cRMAupdate.RMA_Number__c; 
           if(cRMAupdate.RMA_Tracking_Number__c != null)
               caseupdate.RMA_Tracking_Number__c = cRMAupdate.RMA_Tracking_Number__c;
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