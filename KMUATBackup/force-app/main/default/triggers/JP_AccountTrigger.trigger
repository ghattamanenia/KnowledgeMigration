/**
 * Trigger for account of Japan 
 */

trigger JP_AccountTrigger on Account(after update){
    JP_AccountHistory AccountHistory = new JP_AccountHistory();

    if(JP_Flag.accountTriggerFlag == false){
        JP_Flag.accountTriggerFlag = true;
    }else if(JP_Flag.accountTriggerFlag == true){
        return;
    }
    
    List<Account> newAccList = new List<Account>();

    for(Account acc : Trigger.New){
        if(acc.JP_Japan__c){
            newAccList.add(acc);
        }
    }

    if(newAccList.size() > 0){
        // Account history
        if(Trigger.isUpdate && Trigger.isAfter){
            AccountHistory.CreateAccHistory(newAccList, Trigger.oldMap);
        }
    }
}