/**
 * Keep the field histories
 */

public with sharing class JP_FieldHistory {
    
    public JP_FieldHistory(){
    }
        

    // Net.Monitor
    public void doNet_Monitor(Map<Id,JP_Net_Monitor__c> oldRecMap, List<JP_Net_Monitor__c> newRecList){
 
        List<JP_FieldHistory__c> hisList= new List<JP_FieldHistory__c>();
        List<Schema.FieldSetMember> fieldSet = SObjectType.JP_Net_Monitor__c.FieldSets.JP_Net_MonitorHistory.getFields();
        Savepoint sp = Database.setSavepoint();
        
        try{
        
            for(JP_Net_Monitor__c newRec : newRecList){
                JP_Net_Monitor__c oldRec = oldRecMap.get(newRec.Id);
                
                for(Schema.FieldSetMember field : fieldSet) {
                    String apiName = field.getFieldPath();
                    if(newRec.get(apiName) != oldRec.get(apiName)){

                        JP_FieldHistory__c his = new JP_FieldHistory__c(JP_Net_Monitor__c = newRec.Id);
                        his = setHis(his, oldRec.get(apiName), newRec.get(apiName), field.getLabel(), String.valueOf(field.getType()));
                        hisList.add(his);
                    }
                }
            }
            if(hisList.size() > 0){
                insert hisList;
            }

        }catch(Exception e){
            System.debug('◆error');
            System.debug('◆newRecList'+ oldRecMap);
            System.debug('◆oldRecMap'+ oldRecMap);
            Database.rollback(sp);
        }
    }


    // 契約番号
    public void doContractInformation(Map<Id,JP_ContractInformation__c> oldRecMap, List<JP_ContractInformation__c> newRecList){
 
        List<JP_FieldHistory__c> hisList= new List<JP_FieldHistory__c>();
        List<Schema.FieldSetMember> fieldSet = SObjectType.JP_ContractInformation__c.FieldSets.JP_ContractInformationHistory.getFields();
        Savepoint sp = Database.setSavepoint();
        
        try{
        
            for(JP_ContractInformation__c newRec : newRecList){
                JP_ContractInformation__c oldRec = oldRecMap.get(newRec.Id);
                
                for(Schema.FieldSetMember field : fieldSet) {
                    String apiName = field.getFieldPath();
                    if(newRec.get(apiName) != oldRec.get(apiName)){

                        JP_FieldHistory__c his = new JP_FieldHistory__c(JP_ContractInformation__c = newRec.Id);
                        his = setHis(his, oldRec.get(apiName), newRec.get(apiName), field.getLabel(), String.valueOf(field.getType()));
                        hisList.add(his);
                    }
                }
            }
            if(hisList.size() > 0){
                insert hisList;
            }

        }catch(Exception e){
            System.debug('◆error');
            System.debug('◆newRecList'+ oldRecMap);
            System.debug('◆oldRecMap'+ oldRecMap);
            Database.rollback(sp);
        }
    }


    // 契約顧客
    public void doMatter(Map<Id,JP_Matter__c> oldRecMap, List<JP_Matter__c> newRecList){
 
        List<JP_FieldHistory__c> hisList= new List<JP_FieldHistory__c>();
        List<Schema.FieldSetMember> fieldSet = SObjectType.JP_Matter__c.FieldSets.JP_MatterHistory.getFields();
        Savepoint sp = Database.setSavepoint();
        
        try{
        
            for(JP_Matter__c newRec : newRecList){
                JP_Matter__c oldRec = oldRecMap.get(newRec.Id);
                
                for(Schema.FieldSetMember field : fieldSet) {
                    String apiName = field.getFieldPath();
                    if(newRec.get(apiName) != oldRec.get(apiName)){

                        JP_FieldHistory__c his = new JP_FieldHistory__c(JP_Matter__c = newRec.Id);
                        his = setHis(his, oldRec.get(apiName), newRec.get(apiName), field.getLabel(), String.valueOf(field.getType()));
                        hisList.add(his);
                    }
                }
            }
            if(hisList.size() > 0){
                insert hisList;
            }

        }catch(Exception e){
            System.debug('◆error');
            System.debug('◆newRecList'+ oldRecMap);
            System.debug('◆oldRecMap'+ oldRecMap);
            Database.rollback(sp);
        }
    }

    // 管理番号
    public void doManagement_No(Map<Id,JP_Management_No__c> oldRecMap, List<JP_Management_No__c> newRecList){
 
        List<JP_FieldHistory__c> hisList= new List<JP_FieldHistory__c>();
        List<Schema.FieldSetMember> fieldSet = SObjectType.JP_Management_No__c.FieldSets.JP_Management_NoHistory.getFields();
        Savepoint sp = Database.setSavepoint();
        
        try{
        
            for(JP_Management_No__c newRec : newRecList){
                JP_Management_No__c oldRec = oldRecMap.get(newRec.Id);
                
                for(Schema.FieldSetMember field : fieldSet) {
                    String apiName = field.getFieldPath();
                    if(newRec.get(apiName) != oldRec.get(apiName)){

                        JP_FieldHistory__c his = new JP_FieldHistory__c(JP_Management_No__c = newRec.Id);
                        his = setHis(his, oldRec.get(apiName), newRec.get(apiName), field.getLabel(), String.valueOf(field.getType()));
                        hisList.add(his);
                    }
                }
            }
            if(hisList.size() > 0){
                insert hisList;
            }

        }catch(Exception e){
            System.debug('◆error');
            System.debug('◆newRecList'+ oldRecMap);
            System.debug('◆oldRecMap'+ oldRecMap);
            Database.rollback(sp);
        }
    }


    // SOヘッダ
    public void doRequestInformation(Map<Id,JP_RequestInformation__c> oldRecMap, List<JP_RequestInformation__c> newRecList){
 
        List<JP_FieldHistory__c> hisList= new List<JP_FieldHistory__c>();
        List<Schema.FieldSetMember> fieldSet = SObjectType.JP_RequestInformation__c.FieldSets.JP_RequestInformationHistory.getFields();
        Savepoint sp = Database.setSavepoint();
        
        try{
        
            for(JP_RequestInformation__c newRec : newRecList){
                JP_RequestInformation__c oldRec = oldRecMap.get(newRec.Id);
                
                for(Schema.FieldSetMember field : fieldSet) {
                    String apiName = field.getFieldPath();
                    if(newRec.get(apiName) != oldRec.get(apiName)){

                        JP_FieldHistory__c his = new JP_FieldHistory__c(JP_RequestInformation__c = newRec.Id);
                        his = setHis(his, oldRec.get(apiName), newRec.get(apiName), field.getLabel(), String.valueOf(field.getType()));
                        hisList.add(his);
                    }
                }
            }
            if(hisList.size() > 0){
                insert hisList;
            }

        }catch(Exception e){
            System.debug('◆error');
            System.debug('◆newRecList'+ oldRecMap);
            System.debug('◆oldRecMap'+ oldRecMap);
            Database.rollback(sp);
        }
    }

    // POヘッダ
    public void doConsignmentInformation(Map<Id,JP_ConsignmentInformation__c> oldRecMap, List<JP_ConsignmentInformation__c> newRecList){
 
        List<JP_FieldHistory__c> hisList= new List<JP_FieldHistory__c>();
        List<Schema.FieldSetMember> fieldSet = SObjectType.JP_ConsignmentInformation__c.FieldSets.JP_ConsignmentInformationHistory.getFields();
        Savepoint sp = Database.setSavepoint();
        
        try{
        
            for(JP_ConsignmentInformation__c newRec : newRecList){
                JP_ConsignmentInformation__c oldRec = oldRecMap.get(newRec.Id);
                
                for(Schema.FieldSetMember field : fieldSet) {
                    String apiName = field.getFieldPath();
                    if(newRec.get(apiName) != oldRec.get(apiName)){

                        JP_FieldHistory__c his = new JP_FieldHistory__c(JP_ConsignmentInformation__c = newRec.Id);
                        his = setHis(his, oldRec.get(apiName), newRec.get(apiName), field.getLabel(), String.valueOf(field.getType()));
                        hisList.add(his);
                    }
                }
            }
            if(hisList.size() > 0){
                insert hisList;
            }

        }catch(Exception e){
            System.debug('◆error');
            System.debug('◆newRecList'+ oldRecMap);
            System.debug('◆oldRecMap'+ oldRecMap);
            Database.rollback(sp);
        }
    }

    // 契約機器
    public void doMachineInformation(Map<Id,JP_MachineInformation__c> oldRecMap, List<JP_MachineInformation__c> newRecList){
 
        List<JP_FieldHistory__c> hisList= new List<JP_FieldHistory__c>();
        List<Schema.FieldSetMember> fieldSet = SObjectType.JP_MachineInformation__c.FieldSets.JP_MachineInformationHistory.getFields();
        Savepoint sp = Database.setSavepoint();
        
        try{
        
            for(JP_MachineInformation__c newRec : newRecList){
                JP_MachineInformation__c oldRec = oldRecMap.get(newRec.Id);
                
                for(Schema.FieldSetMember field : fieldSet) {
                    String apiName = field.getFieldPath();
                    if(newRec.get(apiName) != oldRec.get(apiName)){

                        JP_FieldHistory__c his = new JP_FieldHistory__c(JP_MachineInformation__c = newRec.Id);
                        his = setHis(his, oldRec.get(apiName), newRec.get(apiName), field.getLabel(), String.valueOf(field.getType()));
                        hisList.add(his);
                    }
                }
            }
            if(hisList.size() > 0){
                insert hisList;
            }

        }catch(Exception e){
            System.debug('◆error');
            System.debug('◆newRecList'+ oldRecMap);
            System.debug('◆oldRecMap'+ oldRecMap);
            Database.rollback(sp);
        }
    }


    // Net.CyberSecurity
    public void doNet_CyberSecurity(Map<Id,JP_Net_CyberSecurity__c> oldRecMap, List<JP_Net_CyberSecurity__c> newRecList){
 
        List<JP_FieldHistory__c> hisList= new List<JP_FieldHistory__c>();
        List<Schema.FieldSetMember> fieldSet = SObjectType.JP_Net_CyberSecurity__c.FieldSets.JP_Net_CyberSecurityHistory.getFields();
        Savepoint sp = Database.setSavepoint();
        
        try{
        
            for(JP_Net_CyberSecurity__c newRec : newRecList){
                JP_Net_CyberSecurity__c oldRec = oldRecMap.get(newRec.Id);
                
                for(Schema.FieldSetMember field : fieldSet) {
                    String apiName = field.getFieldPath();
                    if(newRec.get(apiName) != oldRec.get(apiName)){

                        JP_FieldHistory__c his = new JP_FieldHistory__c(JP_Net_CyberSecurity__c = newRec.Id);
                        his = setHis(his, oldRec.get(apiName), newRec.get(apiName), field.getLabel(), String.valueOf(field.getType()));
                        hisList.add(his);
                    }
                }
            }
            if(hisList.size() > 0){
                insert hisList;
            }

        }catch(Exception e){
            System.debug('◆error');
            System.debug('◆newRecList'+ oldRecMap);
            System.debug('◆oldRecMap'+ oldRecMap);
            Database.rollback(sp);
        }
    }

    // アライド光
    public void doAllied_Hikari(Map<Id,JP_Allied_Hikari__c> oldRecMap, List<JP_Allied_Hikari__c> newRecList){
 
        List<JP_FieldHistory__c> hisList= new List<JP_FieldHistory__c>();
        List<Schema.FieldSetMember> fieldSet = SObjectType.JP_Allied_Hikari__c.FieldSets.JP_Allied_HikariHistory.getFields();
        Savepoint sp = Database.setSavepoint();
        
        try{
        
            for(JP_Allied_Hikari__c newRec : newRecList){
                JP_Allied_Hikari__c oldRec = oldRecMap.get(newRec.Id);
                
                for(Schema.FieldSetMember field : fieldSet) {
                    String apiName = field.getFieldPath();
                    if(newRec.get(apiName) != oldRec.get(apiName)){

                        JP_FieldHistory__c his = new JP_FieldHistory__c(JP_Allied_Hikari__c = newRec.Id);
                        his = setHis(his, oldRec.get(apiName), newRec.get(apiName), field.getLabel(), String.valueOf(field.getType()));
                        hisList.add(his);
                    }
                }
            }
            if(hisList.size() > 0){
                insert hisList;
            }

        }catch(Exception e){
            System.debug('◆error');
            System.debug('◆newRecList'+ oldRecMap);
            System.debug('◆oldRecMap'+ oldRecMap);
            Database.rollback(sp);
        }
    }

    // SO明細
    public void doSO_Detail(Map<Id,JP_SO_Detail__c> oldRecMap, List<JP_SO_Detail__c> newRecList){
 
        List<JP_FieldHistory__c> hisList= new List<JP_FieldHistory__c>();
        List<Schema.FieldSetMember> fieldSet = SObjectType.JP_SO_Detail__c.FieldSets.JP_SO_DetailHistory.getFields();
        Savepoint sp = Database.setSavepoint();
        
        try{
        
            for(JP_SO_Detail__c newRec : newRecList){
                JP_SO_Detail__c oldRec = oldRecMap.get(newRec.Id);
                
                for(Schema.FieldSetMember field : fieldSet) {
                    String apiName = field.getFieldPath();
                    if(newRec.get(apiName) != oldRec.get(apiName)){

                        JP_FieldHistory__c his = new JP_FieldHistory__c(JP_SO_Detail__c = newRec.Id);
                        his = setHis(his, oldRec.get(apiName), newRec.get(apiName), field.getLabel(), String.valueOf(field.getType()));
                        hisList.add(his);
                    }
                }
            }
            if(hisList.size() > 0){
                insert hisList;
            }

        }catch(Exception e){
            System.debug('◆error');
            System.debug('◆newRecList'+ oldRecMap);
            System.debug('◆oldRecMap'+ oldRecMap);
            Database.rollback(sp);
        }
    }


    // PO明細
    public void doPO_Detail(Map<Id,JP_PO_Detail__c> oldRecMap, List<JP_PO_Detail__c> newRecList){
 
        List<JP_FieldHistory__c> hisList= new List<JP_FieldHistory__c>();
        List<Schema.FieldSetMember> fieldSet = SObjectType.JP_PO_Detail__c.FieldSets.JP_PO_DetailHistory.getFields();
        Savepoint sp = Database.setSavepoint();
        
        try{
        
            for(JP_PO_Detail__c newRec : newRecList){
                JP_PO_Detail__c oldRec = oldRecMap.get(newRec.Id);
                
                for(Schema.FieldSetMember field : fieldSet) {
                    String apiName = field.getFieldPath();
                    if(newRec.get(apiName) != oldRec.get(apiName)){

                        JP_FieldHistory__c his = new JP_FieldHistory__c(JP_PO_Detail__c = newRec.Id);
                        his = setHis(his, oldRec.get(apiName), newRec.get(apiName), field.getLabel(), String.valueOf(field.getType()));
                        hisList.add(his);
                    }
                }
            }
            if(hisList.size() > 0){
                insert hisList;
            }

        }catch(Exception e){
            System.debug('◆error');
            System.debug('◆newRecList'+ oldRecMap);
            System.debug('◆oldRecMap'+ oldRecMap);
            Database.rollback(sp);
        }
    }

    public JP_FieldHistory__c setHis(JP_FieldHistory__c his, Object oldValue, Object newValue, String fieldLabel, String FieldType){

                        his.JP_Field__c = fieldLabel;
                        his.JP_OldValue__c = getStrValue(oldValue, FieldType);
                        his.JP_NewValue__c = getStrValue(newValue, FieldType);
                        his.JP_CreatedDate__c = Datetime.now();
                        his.JP_User__c = UserInfo.getUserId();
        return his;
    }

    public String getStrValue(Object FieldValue, String FieldType){

        String StrValue = String.valueOf(FieldValue);

        if(StrValue == null){
        
        }else if(FieldType == 'DATE'){
            StrValue  = Date.valueOf(FieldValue).format();
            
        }else if(FieldType == 'DATETIME'){
            StrValue  = Datetime.valueOf(FieldValue).format();
            
        }else if(FieldType == 'TIME'){
            StrValue = StrValue.left(5);
            
        }else if(StrValue.length() > 255){
            StrValue = StrValue.left(255);
        }
        return StrValue;
    }

}