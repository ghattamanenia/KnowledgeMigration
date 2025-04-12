/**********************************************************
TestClassName : NewCaseCtrlTest
Purpose       : if biilling addres equal to empty creat new case in accout object      
Created By    : Fusion GS
Created Date  : 12th March 2021
**********************************************************/
@isTest
Private class NewCaseCtrlTest{

    /********
    *Method Name : NewCaseRedirect
    ************/
    static testMethod void NewCaseRedirect()  {
         test.startTest();
         TestUtil.Genratetestdada();
         Account acc=[select id from account limit 1];
         PageReference pageRef = Page.NewCaseVF;
         Test.setCurrentPage(pageRef);
         pageRef.getParameters().put('id',acc.id);
         NewCaseCtrl ctrl = new NewCaseCtrl();
         ctrl.validateAndRedirect();
         ctrl.onCancel();
         //PageReference pageRef1 = new PageReference('/lightning/o/Case/new?useRecordTypeCheck=1&defaultFieldValues=AccountId='+acc.id);
         //pageRef.setRedirect(true);
             
         test.stopTest();
        
      }
  }