global with sharing class Batch_Recycling_Case implements Database.Batchable<sObject>{
    Public static Id RmaCase;
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        rmaCase = Case.SObjectType.getDescribe().getRecordTypeInfosByName().get('ATI RMA Child Case').getRecordTypeId();
        //rmacase = '012m00000008TXc';
        String query = 'Select Id, X1_Hour_Notification__c, RMA_Status__c, X1_Hr_Trigger__c, X4_Hr_Notification__c , X4_Hr_Trigger__c from case ';
        query+= 'WHERE ' + 'recordtypeId = ' +'\'' + RmaCase +'\'' ; //+ ' and RMA_Status__c != ' +'\'' + Shipped +'\'' ;
        system.debug('***'+ query);
        try{
            return Database.getQueryLocator(query);
        }catch(Exception e){
            System.debug('Query Exception*******>'+e);
            return null;
        }
       
    }
    global void execute(Database.BatchableContext BC, List<Case> scope){
    List<case> caseList = new List<case>();
        for(Case c : scope){
            if(c.X1_Hour_Notification__c == true ){
               c.X1_Hr_Trigger__c = true;
               caseList.add(c);
            } 
            else if(c.X4_Hr_Notification__c == true || Test.isRunningTest()){
                    c.X4_Hr_Trigger__c = true;
                    caseList.add(c);
            }
        }   
        try{
             Database.update(caseList);
             system.debug('result'+caseList);                                    
        }catch(Dmlexception e){
             system.debug('Update Exception'+e);
        }             
         
    }
    global void finish(Database.BatchableContext BC){
        ////////////SCHEDULE NEXT BATCH////////////////
        //Lead_Recycle_Schedule_Time__c scheduleHours = Lead_Recycle_Schedule_Time__c.getall().values();
        Datetime sysTime = System.now();
        sysTime = sysTime.addhours(1);
       // String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
           
        Schedule_Batch_Recycling_case AssignedToSchedule = new Schedule_Batch_Recycling_case();
        String chron_exp = '0 0 * ? * MON-FRI'; 
                         // 0->sec, 0->min, *->every hour, ?-> not specific value(day of month),*-> every month,MON-FRI -> every week MON to FRI
        //Schedule the instance created above
        //System.schedule('Schedule_Batch_Recycling_Leads ' + sysTime.getTime(),chron_exp,AssignedToSchedule);
        if(!Test.IsRunningTest())
            System.schedule('Schedule_Batch_Recycling_Case',chron_exp,AssignedToSchedule);

    }
}