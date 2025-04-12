/**********************************************************
TestClassName : NewCaseCtrl
Purpose       : Validating the Billing address befor creating the Account Object     
Created By    : Fusion GS
Created Date  : 12th March 2021
**********************************************************/
public class NewCaseCtrl
{ 

  public Id accid {get; set;}
  public Account acc {get; set;}
  Public List<Contact> lisrcon {get; set;}
  public NewCaseCtrl(){
      accid = apexpages.currentpage().getparameters().get('id');
      acc = [select id, name,Region__c,BillingCity,BillingCountry,BillingState,BillingStreet,BillingPostalCode,Business__c from Account where id=:accid];
      lisrcon = new List<Contact>();
      lisrcon = [select id, name from contact where accountid=:accid limit 5000];
  }
 
  public PageReference validateAndRedirect(){
    
      PageReference pageRef = new PageReference('/lightning/o/Case/new?useRecordTypeCheck=1&defaultFieldValues=AccountId='+acc.id+'&cancelURL='+accid);
      pageRef.setRedirect(true);
      return pageRef;
  }
 
  public PageReference onCancel() {
        return new PageReference('/'+accid);
  }
}