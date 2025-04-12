/**********************************************************
TestClassName : NewOpportunityCtrlTest
Purpose       : To Test the NewOpportunityCtrl class   
Created By    : Fusion GS
Created Date  : 12th March 2021
**********************************************************/
@isTest
Private class NewOpportunityCtrlTest
{ 
 /********
    *Method Name : NewCaseRedirect
    ************/
    static testMethod void validatecurrentUserIsAccOwner()  {
         test.startTest();
         TestUtil.Genratetestdada();
         Account acc=[select id,OwnerId from account limit 1];
         PageReference pageRef = Page.NewOpportunityVF;
         Test.setCurrentPage(pageRef);
         pageRef.getParameters().put('id',acc.id);
         NewOpportunityCtrl ctrl = new NewOpportunityCtrl();
         ctrl.validateAndRedirect();
         ctrl.onCancel();
         //PageReference pageRef1 = new PageReference('/lightning/o/Case/new?useRecordTypeCheck=1&defaultFieldValues=AccountId='+acc.id);
         //pageRef.setRedirect(true);
             
         test.stopTest();
        
      }
  }