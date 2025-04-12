trigger FileTag_Sync on ContentVersion (after update) {
  
system.debug('::::Utils.shouldRunFileSync:::' + Utils.shouldRunFileSync());
if(Utils.shouldRunFileSync() == true || Test.isRunningtest()){ //trigger should run only when we set so OR if it is a test

  Utils.UnsetRunFileSync(); // this trigger should not run again and again utill explicitly set 

  system.debug('FileTagSync  ON ContentVersion  Trigger ' );
  SET<ID> ALLConVersions = new SET<ID>();
  SET<ID> ALLConVersionsNotToUpdate = new SET<ID>();
  SET<ID> ALLConVersionsToUpdate = new SET<ID>();
  
  List<ContentVersion> CVF = new List<ContentVersion>();
  
  List<ContentDocumentLink> ConDocLinkList = new List<ContentDocumentLink>();
  List<ContentDocumentLink> ConDocLinkExistingList = new List<ContentDocumentLink>();
  CollaborationGroup ChatterAdminGroup = [SELECT CollaborationType,Id,MemberCount,Name FROM CollaborationGroup where Name = 'Chatter Files Administrators'];
  
    for(ContentVersion CV: trigger.new)
    {
        ALLConVersions.add(CV.ContentDocumentId); 
    }
  
  system.debug(':::ALLConVersions:::'+ ALLConVersions);
  // check if the current document is already shared with chatter files administrators
   ConDocLinkExistingList = [SELECT ContentDocumentId ,LinkedEntityId from ContentDocumentLink where ContentDocumentId IN :ALLConVersions AND LinkedEntityId = :ChatterAdminGroup.Id];
   
   
   for(ContentDocumentLink CL: ConDocLinkExistingList)
   {
        ALLConVersionsNotToUpdate.add(CL.ContentDocumentId); 
   }
   
   system.debug(':::ConDocLinkExistingList :::'+ ConDocLinkExistingList );
   
   
   for(ContentVersion CV: trigger.new)
    {
        // if the current document is not already shared with chatter files administrators add it for sharing
        if(!ALLConVersionsNotToUpdate.contains(CV.ContentDocumentId) ){
                CVF.add(CV); 
         }
    }
  system.debug(':::CVF:::'+ CVF);
    for(ContentVersion CV: CVF)
    {
        ContentDocumentLink CDL = new ContentDocumentLink(ContentDocumentId = CV.ContentDocumentId,LinkedEntityId=ChatterAdminGroup.Id,ShareType='C');
        ConDocLinkList.add(CDL);     
    }
    system.debug('All new ConDocLink :: ' + ConDocLinkList);
    if(!Test.isRunningtest())
   upsert ConDocLinkList;
   
   
}
}