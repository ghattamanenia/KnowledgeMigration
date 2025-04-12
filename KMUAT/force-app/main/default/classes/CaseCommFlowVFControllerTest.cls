/**********************************************************
TestClassName : CaseCommFlowVFControllerTest
Purpose   : To Pass the Selected Case Commments reccords to Flow. 
Created By : Fusion GS
Created Date : 25th Feb 2021
**********************************************************/
@isTest
Private class CaseCommFlowVFControllerTest{

    static testMethod void casecommend()  {
         
       TestUtil.Genratetestdada();
       case c= [select id from case limit 1];      
       //insert case commend 
       Case_Comment__c cm=new Case_Comment__c();
       cm.case__c=c.Id;
       cm.Comment__c='testcommend';
       cm.Public__c=true;
       cm.Comment_Type__c='Inbound Email';
       insert cm;
       
        //insert case commend 
       Case_Comment__c cm1=new Case_Comment__c();
       cm1.case__c=c.Id;
       cm1.Comment__c='testcommend1';
       cm1.Public__c=true;
       cm1.Comment_Type__c='Inbound Email';
       insert cm1;
       
       list<Case_Comment__c> listcm = new list<Case_Comment__c>();
       listcm.add(cm);
       listcm.add(cm1);
       
       Test.startTest();
       ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(listcm);
       stdSetController.setSelected(listcm);
       CaseCommFlowVFController ext = new CaseCommFlowVFController(stdSetController);
      

       Test.stopTest();
    }
    
 }