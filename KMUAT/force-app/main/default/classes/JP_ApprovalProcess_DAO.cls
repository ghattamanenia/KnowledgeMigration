public with sharing class JP_ApprovalProcess_DAO {

    public static Map<String,String> getApprovalProcessNo(Set<String> processKeys){
        Map<String,String> processNoMap = new Map<String,String>();
        
        List<JP_DecideApprovalProcess__c> apList = [select 
                                                    JP_ApprovalProcessNo__c,
                                                    JP_ApprovalProcessKey__c
                                                from 
                                                    JP_DecideApprovalProcess__c
                                                where 
                                                    JP_ApprovalProcessKey__c IN :processKeys];
        
        for(JP_DecideApprovalProcess__c ap :apList){
            if(!processNoMap.containsKey(ap.JP_ApprovalProcessKey__c)){
                String processNo = String.valueOf(ap.JP_ApprovalProcessNo__c);
                system.debug('◆承認プロセス番号：' + processNo);
                processNoMap.put(ap.JP_ApprovalProcessKey__c, processNo);
            }
        }
        
        return processNoMap;
    }
    
    public static JP_ApprovalProcessMaster__c getApprovalProcessInfoByNo(Integer processNo){
        return [Select  
                    JP_ApprovalProcessNo__c,
                    JP_Description__c,
                    JP_Step0Status__c,
                    JP_Step1Approver__c,
                    JP_Step1exec__c,
                    JP_Step1Status__c,
                    JP_Step1type__c,
                    JP_Step2Approver__c,
                    JP_Step2exec__c,
                    JP_Step2Status__c,
                    JP_Step2type__c,
                    JP_Step3Approver__c,
                    JP_Step3exec__c,
                    JP_Step3Status__c,
                    JP_Step3type__c,
                    JP_Step4Approver__c,
                    JP_Step4exec__c,
                    JP_Step4Status__c,
                    JP_Step4type__c,
                    JP_Step5Approver__c,
                    JP_Step5exec__c,
                    JP_Step5Status__c,
                    JP_Step5type__c,
                    JP_Step6Approver__c,
                    JP_Step6exec__c,
                    JP_Step6Status__c,
                    JP_Step6type__c,
                    JP_StepCnt__c
                From
                    JP_ApprovalProcessMaster__c
                Where
                    JP_ApprovalProcessNo__c = :processNo
                limit 1
                ];
    }
}