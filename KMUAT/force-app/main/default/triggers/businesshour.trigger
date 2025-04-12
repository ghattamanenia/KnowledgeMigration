trigger businesshour on Case (before Insert,before update) {
  boolean status = false;
  
  List<RecordType> AllCaseRT = [SELECT Id, DeveloperName  FROM RecordType where Sobjecttype = 'Case'];
    Id  ATI_CaseID; 
    Id  ATI_UserRegCaseID; 
    Id  ATI_RMAChildCaseID;
    Id  ATI_RMAParentCaseID; 
    Id  JP_CaseID;
    for(RecordType CaseRT : AllCaseRT )
    {
        if(CaseRT.DeveloperName == 'ATI_Case')
            ATI_CaseID = CaseRT.ID;
        if(CaseRT.DeveloperName == 'ATI_Community_Registration')
            ATI_UserRegCaseID = CaseRT.ID;
        if(CaseRT.DeveloperName == 'ATI_RMA_Child_Case')
            ATI_RMAChildCaseID = CaseRT.ID;
        if(CaseRT.DeveloperName == 'ATI_RMA_Parent_Case')
            ATI_RMAParentCaseID = CaseRT.ID;
        if(CaseRT.DeveloperName == 'JP_Case')
            JP_CaseID = CaseRT.ID;    
    }
    
  if(trigger.isInsert){
      status = true;
      BusinessHour.updatCase(trigger.new,status );
      BusinessHour.updateBusinessHourNotifications(trigger.new);
      }
  else{
      status = false;
      BusinessHour.updatCase(trigger.new,status );
      }
      //adding Validations for Case status change
     /* try{
    if(Trigger.isInsert){
        for(Case c : trigger.new){
            if(c.status != 'New' && c.recordtypeId =='01220000000ALEJ'){
                c.Status.addError('Cases can be created only with New Status. Please change value of status to New.');
            }
        }
     }
     system.debug('***'+BusinessHour.skipCaseComment );
     if(!BusinessHour.skipCaseComment){
         if(Trigger.isUpdate){
             for(Case c : trigger.new){
                if(c.recordtypeId ==ATI_CaseID '01220000000ALEJ'&& c.status != 'New' && trigger.oldmap.get(c.Id).Status == 'New' && trigger.newmap.get(c.Id).Status != trigger.oldmap.get(c.Id).Status){
                    c.status.addError('Status Value of New Case cannot be changed.');
                }
            }  
         }  
     }  
     }Catch(Exception ex){
         system.debug('Error'+ ex.getMessage());
         }   */
     
}