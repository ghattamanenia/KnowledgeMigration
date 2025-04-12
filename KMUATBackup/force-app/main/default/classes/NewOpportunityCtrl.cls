/**********************************************************
TestClassName : NewOpportunityCtrl
Purpose       : Create the Opportunity based on the loged in user access    
Created By    : Fusion GS
Created Date  : 12th March 2021
**********************************************************/
public class NewOpportunityCtrl
{ 

  public Id accid {get; set;}
  public Account acc {get; set;}
  Public List<Contact> lisrcon {get; set;}
  public Boolean currentUserIsAccOwner {get; set;}
  public Boolean currentUserHasEditForOppties {get;set;}
  public NewOpportunityCtrl(){
      accid = apexpages.currentpage().getparameters().get('id');
      currentUserIsAccOwner = false;
      currentUserHasEditForOppties = false;
      Id currentUserId = UserInfo.getUserId();
      List<AccountShare> accshare = [SELECT OpportunityAccessLevel FROM AccountShare WHERE AccountId =:accid AND UserOrGroupId=:currentUserId limit 1];
      acc = [select id, name,OwnerId,Freeze_Account__c ,Region__c,BillingCity,BillingCountry,BillingState,BillingStreet,BillingPostalCode,Business__c from Account where id=:accid];
      /** If a share record was found for this user and this account then there should only be 1, check the oppty access level **/
      if(accshare.size() > 0){
          if(accshare[0].OpportunityAccessLevel == 'Edit')
             currentUserHasEditForOppties = true;
      }
      /** Check if the current user is the account owner **/
      if(currentUserId == acc.OwnerId)
          currentUserIsAccOwner = true;

      lisrcon = new List<Contact>();
      lisrcon = [select id, name from contact where accountid=:accid limit 5000];
  }
 
  public PageReference validateAndRedirect(){
    
      PageReference pageRef = new PageReference('/lightning/o/Opportunity/new?useRecordTypeCheck=1&defaultFieldValues=AccountId='+acc.id+'&cancelURL='+accid);
      pageRef.setRedirect(true);
      return pageRef;
  }
 
  public PageReference onCancel() {
        return new PageReference('/'+accid);
  }
}