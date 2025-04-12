/*******************
Description: This code is used to update the owner_department__c.
Developer: Hitachi Solutions, Ltd.
Date Created: 10/4/2010
Date Modified: 10/24/2011
*****************/
/** set new opportunity owner's UserRole to owner_department__c,
 *  when opportunity owner is changed.
 * ----Check below.----
 * At Unit test, we tried to make trigger-duplicate-execution-block function.
 * It is function that block trigger-duplicate-execution during workflow is moving.
 * We want to change this parameter value from true to false after first insert logic and back the value to true after second insert logic..
 * But this function haven't moved, because after second insert logic, the parameter "exeTR" defined at JP_CLContactGradeE, is taken over to update logic too.
 * So, now this function's code is comment-outed.
 */
public with sharing class JP_CLOpportunityOwnerDept {
    // This is a flag that stop to execute trigger when workflow acted.
//  private static Boolean exeTR = true;

//  public static boolean checkExeTR(){
//      return exeTR;
//  }
//  public static void setexeTR() {
//       exeTR = false;
//  }
    /**
     * this code move at Opportunity owner is created or changed --- Insert or Update
     * @param nList is List of "Trigger.new" List.
     * @return nothing
     * @throws nothing
     */
    public void deptValChange(List<Opportunity> nList, Set<String> strSet){
        
        //When this exection was triggered OppotunityLineItem , this function is skipped-
        if(JP_CLEditOppLineItem.checkExeTR() == false){

            List<RecordType> tmpID = [select ID, name from RecordType where name = 'JP_Opportunity' and SObjectType = 'Opportunity'];
            
//2011/10/24 HISOL 所有部署設定：ロール名→division Begin
//            List<UserRole> uRoleList = [select id, Name from UserRole];
//            List<User> userList = [select id, userRoleId from User where id in : strSet];
//    
//            Map<ID, String> uRoleMap = new map <Id, String>();
//            Map<ID, String> uRNameMap = new map <Id, String>();
//            Map<ID, String> ownerRoleNamemap = new map<Id, String>();
//    
//            // create userRole map
//            for(Integer i = 0; i < uRoleList.size() ; i++){
//                uRoleMap.put(uRoleList[i].Id, uRoleList[i].Name);
//            }
//            // create userId and userRoleName map
//            for(Integer i = 0; i < userList.size(); i++){
//                uRNameMap.put(userList[i].id, uRoleMap.get(userList[i].UserRoleId));
//            }
            List<User> userList = [select id, Division from User where id in : strSet];

            Map<ID, String> uRNameMap = new map <Id, String>();
            
            // create userId and userRoleName map
            for(Integer i = 0; i < userList.size(); i++){
                 uRNameMap.put(userList[i].id, userList[i].Division);
            }
//2011/10/24 HISOL 所有部署設定：ロール名→division End

            for(Integer i =0; i < nList.size(); i++){
                if(nList[i].RecordTypeId ==tmpID[0].Id){
                    nList[i].JP_OpportunityOwnerRole__c = uRNameMap.get(nList[i].ownerId);
                }
            }
        }
    }
}