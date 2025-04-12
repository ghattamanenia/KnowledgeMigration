trigger Comments_events_Handling on Comment__c (before insert) {
    
    //Sarvinder: changes start for updating field Case Contact Email
List<RecordType> AllCaseRT = [SELECT Id, DeveloperName  FROM RecordType where Sobjecttype = 'Case']; //get all case recordtypeIds
Id  SFCaseID; //SF generic case record type ID
Id  SFEnhancementID; //SF enhancement case record type ID
Id  SFDataCaseID; //SF data case record type ID
Id  SFAccessCaseID; //SF Access case record type ID

//save record values in variables
for(RecordType CaseRT : AllCaseRT )
{
    if(CaseRT.DeveloperName == 'SF_Case')
        SFCaseID = CaseRT.ID;
    if(CaseRT.DeveloperName == 'SF_Case_Enhancement')
        SFEnhancementID = CaseRT.ID;
    if(CaseRT.DeveloperName == 'SF_Case_Access')
        SFAccessCaseID = CaseRT.ID;
    if(CaseRT.DeveloperName == 'SF_Case_Data')
        SFDataCaseID = CaseRT.ID;
}

SET<ID> AllCasIDs = new SET<ID>();
for(Comment__c caseCmnt: trigger.new)
    AllCasIDs.add(caseCmnt.Related_Case__c);  //save IDs of all cases related to new comments 

List<Case> cases = [select contact.email,Submitter_Email__c,recordtypeid from case where id IN :AllCasIDs ]; //get contact email id and submitter email id

for(Comment__c caseCmnt: trigger.new)
{
    for(Case cs: cases )
    {
        if(caseCmnt.Related_Case__c == cs.id)
        {                //caseCmnt.Public__c = true;
                //caseCmnt.Comment_Type__c = 'TAC Comment';
                caseCmnt.Case_Contact_Email__c = cs.Submitter_Email__c;
        }
    }
}
//Sarvinder: changes end for updating field Case contact Email

set<ID> RelProjectIDs = new set<ID>();
set<ID> RelCaseIDs = new set<ID>();
for(Comment__c newComment : trigger.new)
{
    system.debug('inside tigger');
    if(newComment.Related_Case__c == null && newComment.Related_Project__c != null)
        RelProjectIDs.add(newComment.Related_Project__c);
    if(newComment.Related_Case__c != null && newComment.Related_Project__c == null)
        RelCaseIDs.add(newComment.Related_Case__c);
}

map<id,Milestone1_Project__c> RelProjectsMap = new map<id,Milestone1_Project__c>([select id,Related_Case__c from Milestone1_Project__c where id IN : RelProjectIDs and Related_Case__c != null]);
map<id,Case> RelCaseMap = new map<id,Case>([select id,Related_CMT_Project__c from Case where id IN : RelCaseIDs and Related_CMT_Project__c != null]);


for(Comment__c newComment : trigger.new)
{
system.debug('newComment.Related_Case__c' + newComment.Related_Case__c);
system.debug('newComment.Related_Project__c' + newComment.Related_Project__c);
  
    if(newComment.Related_Case__c == null && newComment.Related_Project__c != null)
    {
        
            
           Milestone1_Project__c RelPrjct = RelProjectsMap.get(newComment.Related_Project__c);
            if(RelPrjct!=null)
                newComment.Related_Case__c =  RelPrjct.Related_Case__c;
       
    }
    if(newComment.Related_Case__c != null && newComment.Related_Project__c == null)
    {
      
           
           Case RelCase = RelCaseMap.get(newComment.Related_Case__c);
           if(RelCase!=null)
           newComment.Related_Project__c = RelCase.Related_CMT_Project__c;
       
    }
}

}