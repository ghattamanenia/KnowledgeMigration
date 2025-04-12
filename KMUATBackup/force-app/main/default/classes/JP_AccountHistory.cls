/**
 * Keep the account histories
 */

public with sharing class JP_AccountHistory {
    
    public JP_AccountHistory(){
    }
        
    public void CreateAccHistory(List<Account> newAccList, Map<Id,Account> oldAccMap){

        List<JP_AccountHistory__c> accHisList = new List<JP_AccountHistory__c>();
        Savepoint sp = Database.setSavepoint();
        
        try{
        
            for(Account newAcc : newAccList){
                Account oldAcc = oldAccMap.get(newAcc.Id);
                
                for(Schema.FieldSetMember field : this.getFields()) {
                    String apiName = field.getFieldPath();
                    if(newAcc.get(apiName) != oldAcc.get(apiName)){

                        JP_AccountHistory__c accHis = new JP_AccountHistory__c(JP_AccountId__c = newAcc.Id);

                        accHis.JP_Field__c = field.getLabel();
                        accHis.JP_OldValue__c = String.valueOf(oldAcc.get(apiName));
                        accHis.JP_NewValue__c = String.valueOf(newAcc.get(apiName));
                        accHis.JP_CreatedDate__c = Datetime.now();
                        accHis.JP_User__c = UserInfo.getUserId();
                        accHisList.add(accHis);
                    }
                }
            }
            insert accHisList;

        }catch(Exception e){
            System.debug('◆error');
            System.debug('◆newAccList'+ newAccList);
            System.debug('◆oldAccMap'+ oldAccMap);
            Database.rollback(sp);
        }
    }

    // Field sets
    public List<Schema.FieldSetMember> getFields() {
        return SObjectType.Account.FieldSets.JP_AccountHistory.getFields();
    }

}