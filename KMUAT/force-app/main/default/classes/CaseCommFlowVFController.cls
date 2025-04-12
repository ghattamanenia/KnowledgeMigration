/**********************************************************
ClassName : CaseCommFlowVFController
Purpose   : To Pass the Selected Case Commments reccords to Flow. 
Created By : Fusion GS
Created Date : 24th Feb 2021
**********************************************************/
public class CaseCommFlowVFController {
    
    public string[] SelectedRecordIDs {get;set;}
    Public Id caseid {get;set;}
    /** Constructor ****/
    public CaseCommFlowVFController(ApexPages.StandardSetController controller){
        SelectedRecordIDs = new string[]{};
         
        /** Loop the selected Records **/
        for(Case_Comment__c casecom :[select id,name,case__c from Case_Comment__c where Id in:controller.getSelected() limit 200]){
            SelectedRecordIDs.add(casecom.Id);
            caseid= casecom.case__c;
        }
        
    }
}