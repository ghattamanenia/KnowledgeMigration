/*******************
Description: This code is used to upsert the CrossViewToDo.
Developer: Hitachi Solutions, Ltd.
Date Created: 12/2/2010
Date Modified: 6/7/2011
*****************/
/**
 * This is a Trigger of Task
 */
public without sharing class JP_CLCrossViewToDoUpsert {
    
    /**
    * Prior processing：get three head digit of each object ID
    * @param nList is List of "Trigger.new" List.
    * @param isIns is Boolean.
    * @return nothing
    * @throws nothing
    */

    public void CrossViewToDo_Upsert(List<Task> nList,  Boolean isIns){
/*
        //get Japanuse Record
        List<RecordType> japan = [select ID from RecordType where name = 'JP_Tasks'];

        //get head three digits of each ID
        Schema.DescribeSObjectResult Resc = Contact.SObjectType.getDescribe();
        String con_prefix = Resc.getKeyPrefix();
        Schema.DescribeSObjectResult Reso = Opportunity.SObjectType.getDescribe();
        String opp_prefix = Reso.getKeyPrefix();
        Schema.DescribeSObjectResult Resl = Lead.SObjectType.getDescribe();
        String lead_prefix = Resl.getKeyPrefix();
        Schema.DescribeSObjectResult Resa = Account.SObjectType.getDescribe();
        String acc_prefix = Resa.getKeyPrefix();
        Schema.DescribeSObjectResult Rest = Contract.SObjectType.getDescribe();
        String contract_prefix = Rest.getKeyPrefix();

        createListVal(nList,con_prefix,opp_prefix,lead_prefix,acc_prefix,contract_prefix,isIns);
*/
    }

    /**
    * Insert/Update processing
    * @param nList is List of "Trigger.new" List.
    * @param acc_prefix is String of AccountID.
    * @param con_prefix is String of ContactID.
    * @param opp_prefix is String of Opportunity.
    * @param isIns is Boolean.
    * @return nothing
    * @throws nothing
    */
/*
    public void createListVal(List<Task> nList,String con_prefix,String opp_prefix,String lead_prefix,String acc_prefix,String contract_prefix,Boolean isIns){
        //data pattern of Insert/Update
        List<JP_CrossViewToDo__c> upsertList = new List<JP_CrossViewToDo__c>();
        List<Task> deleteList = new List<Task>();
        List<RecordType> jrecord = [select Id from RecordType where Name = 'JP_Tasks'];
        for(Integer i =0; i < nList.size(); i++){
            //System.debug(nList[i].AccountId + '★'+ nList[i].WhoId + '★'+ nList[i].WhatId + '★'+ nList[i].Subject + '★' + nList[i].Status+'★'+nList[i].RecordTypeId+'★'+jrecord[0].Id);
            //Japanese Record and not empty AccointId 
            if((nList[i].RecordTypeId == jrecord[0].Id) && (nList[i].WhoId != Null || nList[i].WhatId != Null)){
                //data pattern of Insert
                JP_CrossViewToDo__c cvToDo = new JP_CrossViewToDo__c();
                cvToDo.JP_ToDoId__c = nList[i].Id;
                if(nList[i].WhoId != Null){
                    String who_tmp = nList[i].WhoId;
                    String Who_init_str = who_tmp.substring(0,3);
                    if(Who_init_str == con_prefix){
                        cvToDo.JP_ContactId__c = nList[i].WhoId;
                    }else{
                        cvToDo.JP_ContactId__c = Null;
                    }
                }else if(nList[i].WhoId == Null){
                    cvToDo.JP_ContactId__c = Null;
                }
                if(nList[i].WhatId != Null){
                    String what_tmp = nList[i].WhatId;
                    String What_init_str = what_tmp.substring(0,3); 
                    if(What_init_str == opp_prefix){
                        cvToDo.JP_OpportunityId__c = nList[i].WhatId;
                        cvToDo.JP_AccountId__c = Null;
                    }else if((What_init_str == acc_prefix) || (What_init_str == contract_prefix)){
                        cvToDo.JP_AccountId__c = nList[i].AccountId;
                        cvToDo.JP_OpportunityId__c = Null;
                    }else{
                        cvToDo.JP_AccountId__c = Null;
                        cvToDo.JP_OpportunityId__c = Null;
                    }
                }else if(nList[i].WhatId == Null){
                    cvToDo.JP_AccountId__c = Null;
                    cvToDo.JP_OpportunityId__c = Null;
                }
                cvToDo.JP_Name__c = nList[i].Subject;
                cvToDo.JP_Status__c = nList[i].Status;
                cvToDo.JP_Type__c = nList[i].Type;
                cvToDo.JP_ActivityDate__c = nList[i].ActivityDate;
                cvToDo.JP_Priority__c = nList[i].Priority;
                cvToDo.JP_ToDoRecordTypeId__c = nList[i].RecordTypeId;
                cvToDo.JP_IsClosed__c = nList[i].IsClosed;
                cvToDo.JP_Description__c = nList[i].Description; 
                //System.debug(cvToDo.JP_ContactId__c + '★'+ cvToDo.JP_AccountId__c + '★'+ cvToDo.JP_OpportunityId__c + '★'+ nList[i].Subject + '★' + nList[i].Status);
                if((cvToDo.JP_ContactId__c != Null) || (cvToDo.JP_AccountId__c != Null) || (cvToDo.JP_OpportunityId__c != Null)){
                    upsertList.add(cvToDo);
                }
            }
            if(isIns != True && nList[i].RecordTypeId == jrecord[0].Id){
                if(nList[i].WhoId != Null){
                    String who_tmp2 = nList[i].WhoId;
                    String Who_init_str2 = who_tmp2.substring(0,3);
                    if(Who_init_str2 == lead_prefix){
                        deleteList.add(nList[i]);
                    }
                }
                if(nList[i].WhoId == Null && nList[i].WhatId != Null){
                    String what_tmp2 = nList[i].WhatId;
                    String What_init_str2 = what_tmp2.substring(0,3); 
                    if((What_init_str2 != opp_prefix) && (What_init_str2 != acc_prefix) && (What_init_str2 != contract_prefix)){
                        deleteList.add(nList[i]);
                    }
                }
                if(nList[i].WhatId == Null && nList[i].WhoId == Null){
                    deleteList.add(nList[i]);
                }
            }   
        }
        if(upsertList != Null && upsertList.size() != 0){
            upsert upsertList JP_ToDoId__c;
        }
        if(deleteList != Null && deleteList.size() != 0){
            CrossViewToDo_delete(deleteList); 
        }
    }
*/
    /**
    * Delete processing
    * @param deleteTmpList is List of "Trigger.old" List or List od deleteList.
    * @return nothing
    * @throws nothing
    */

    public void CrossViewToDo_delete(List<Task> deleteTmpList){
/*
        Set <String> strSet = new Set<String>();
        for(Integer i=0; i< deleteTmpList.size(); i++){
            strSet.add(deleteTmpList[i].Id);
        }
        List<JP_CrossViewToDo__c> deleteList = [select ID from JP_CrossViewToDo__c where JP_ToDoId__c in :strSet];

        delete deleteList;
*/
    }

}