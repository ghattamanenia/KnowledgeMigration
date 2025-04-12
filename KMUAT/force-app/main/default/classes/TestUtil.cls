/**********************************************************
TestClassName : TestUtil
Purpose       : Test Utility utilised by other test classes  
Created By    : Fusion 
Created Date : 12th March 2021
**********************************************************/

@isTest
public class TestUtil {
    /*
     * Method used in TestSetup methods to ensure the basic test setup has been completed
     */
    public static void Genratetestdada(){
   

    // Account insert
       Account acc = new account();
       acc.name = 'Testing 1234';
       insert acc;
       
       // insert Contact  data 
       Contact conts = new Contact ();
       conts.FirstName = 'Testing First Name';
       conts.LastName = 'Testing Last Name';
       conts.email = 'testig@test.com';
       conts.accountId = acc.id;
       insert conts;
       
       //insert case record
       Case c = new case();
       c.AccountId = acc.Id;
       c.Status ='New';
       c.Priority = 'Medium';
       c.Origin = 'Email';
       c.Request_Title__c='Titletest';
       c.Description='TestDescription';
       c.Impact__c='High';
       c.Urgency__c='High';
       //c.RecordTypeId = Schema.sObjectType.Case.getRecordTypeInfosByName().get('ATI_Case').getRecordTypeId();
       insert c;
       
       //insert case commend 
       Case_Comment__c cm=new Case_Comment__c();
       cm.case__c=c.Id;
       cm.Comment__c='testcommend';
       cm.Public__c=true;
       cm.Comment_Type__c='Inbound Email';
       insert cm;
     
      } 
      
     }