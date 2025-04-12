/*******************
Description: This code is used to edit the contact whose grade is 'E'.
Developer: Hitachi Solutions, Ltd.
Date Created: 10/1/2010
Date Modified: 6/7/2011
*****************/
/*
 * we change recordType in 2 cases in Japan.
 *  -- one is when Contact's grade become from not "E" to "E".
 *  -- the other one is when Contact's grade become from "E" to not "E".
 *     This rule is not applied to JP TeleMarketing/CSC user.
 * ----Check below.----
 * At Unit test, we tried to make trigger-duplicate-execution-block function.
 * It is function that block trigger-duplicate-execution during workflow is moving.
 * We want to change this parameter value from true to false after first insert logic and back the value to true after second insert logic..
 * But this function haven't moved, because after second insert logic, the parameter "exeTR" defined at JP_CLContactGradeE, is taken over to update logic too.
 * So, now this function's code is comment-outed.
 */
public with sharing class JP_CLContactGradeE {

    // This is a flag that stop to execute trigger when workflow acted.
//  private static Boolean exeTR = true;

//  public static boolean checkExeTR(){
//      return exeTR;
//  }
//  public static void setexeTR(Boolean exeTrVal) {
//       exeTR = exeTrVal;
//  }
    public static string NGWORD = '【無効】_';
    List<RecordType> RecordTypeList = [select Name,ID from RecordType where SObjectType ='Contact' order by name];
        
    /**
     * this code is executed when Grade is changed to "E" --- Update
     * this code is executed when Grade is "E"  --- Insert
     * @param oList is List of "Trigger.old" List.
     * @param nList is List of "Trigger.new" List.
     * @return nothing
     * @throws nothing
     */
    public void grade_e_Rename(List<Contact> oList, List<Contact> nList, Boolean isIns){
        Map<String, Id> RecordTypeMap = new Map<String, Id>();
        for(Integer i = 0; i < RecordTypeList.size(); i++){
            RecordTypeMap.put(RecordTypeList[i].Name,RecordTypeList[i].Id);
        }
        String other = RecordTypeMap.get('JP_Contacts');
        String other2 = RecordTypeMap.get('JP_ContactsBeforeCleansing');
        String grade_e = RecordTypeMap.get('JP_Contacts(GradeE)');
        
        for(Integer i =0; i < nList.size(); i++){
            if((oList != null && oList.size() > 0 && oList[i].JP_Grade__c !='E' && nList[i].JP_Grade__c=='E' && (nList[i].RecordTypeId ==grade_e || nList[i].RecordTypeId ==other || nList[i].RecordTypeId ==other2 ))
                || (isIns == true && nList[i].JP_Grade__c =='E' && (nList[i].RecordTypeId ==grade_e || nList[i].RecordTypeId ==other || nList[i].RecordTypeId ==other2))){
                    // Add Invalid-Meaning-Character
                    nList[i].LastName = JP_CLContactGradeE.NGWORD + nList[i].LastName;
                    nList[i].recordTypeId = grade_e;
            }
        }
    }

    /**
     * this code move at Grade is changed to "E" --- Update
     * @param oList is List of "Trigger.old" List.
     * @param nList is List of "Trigger.new" List.
     * @return nothing
     * @throws nothing
     */
    public void grade_e_Backname(List<Contact> oList, List<Contact> nList, Boolean isIns){
        Map<String, Id> RecordTypeMap = new Map<String, Id>();
        for(Integer i = 0; i < RecordTypeList.size(); i++){
            RecordTypeMap.put(RecordTypeList[i].Name,RecordTypeList[i].Id);
        }
        String other = RecordTypeMap.get('JP_Contacts');
        String other2 = RecordTypeMap.get('JP_ContactsBeforeCleansing');
        String grade_e = RecordTypeMap.get('JP_Contacts(GradeE)');
        for(Integer i =0; i < nList.size(); i++){
            if(oList != null && oList.size() > 0 && oList[i].JP_Grade__c =='E' && nList[i].JP_Grade__c!='E' && nList[i].LastName.startsWith(JP_CLContactGradeE.NGWORD)){
                // Remove Invalid-Meaning-Charactor
                Integer limitLength = nList[i].LastName.length();
                nList[i].LastName = nList[i].LastName.substring(JP_CLContactGradeE.NGWORD.length(),limitLength);
            }
            if (nList[i].JP_Grade__c != 'E' && nList[i].JP_CleansingFlag__c == True && (nList[i].RecordTypeId ==grade_e || nList[i].RecordTypeId ==other || nList[i].RecordTypeId ==other2)){
                nList[i].recordTypeId = other2;
            }
            if (nList[i].JP_Grade__c != 'E' && nList[i].JP_CleansingFlag__c == False && (nList[i].RecordTypeId ==grade_e || nList[i].RecordTypeId ==other || nList[i].RecordTypeId ==other2)){
                nList[i].recordTypeId = other;
            }
        }
    }
}