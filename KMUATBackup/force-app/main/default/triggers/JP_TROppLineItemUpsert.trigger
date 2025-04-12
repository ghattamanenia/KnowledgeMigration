/*******************
Description: This cord is used to set a standard price to a product.
Developer: Hitachi Solutions, Ltd.
Date Created: 11/19/2010
Date Modified: 6/7/2011
*****************/
/**
 * This is a Trigger of OpportunityLineItem
 */
trigger JP_TROppLineItemUpsert on OpportunityLineItem (before insert, before update) {


    //Customer's record type name is made a list. 
    List<RecordType> RecordTypeList = [select Name,ID from RecordType where SObjectType = 'Opportunity'];
    //The record type name and ID are put in rtmap.
    Map<String,Id> rtmap = new Map<String,Id>();
    for(Integer j=0; j<RecordTypeList.size(); j++){
        rtmap.put(RecordTypeList[j].Name,RecordTypeList[j].Id);
    }
    //OpportunityID of the trigger object is put in newopp. 
    Set<id> newopp = new Set<id>();
    for(OpportunityLineItem oli: Trigger.new){
        newopp.add(oli.OpportunityId);
        System.debug(newopp.size()+'■■■');
    }
    //OpportunityID and record type ID of the trigger object are made a list from the opportunity object. 
    List<Opportunity> OppList = [select Id,RecordTypeId From Opportunity where id in : newopp];
    //Opportunity ID and record type ID of the trigger object are put in oppId. 
    Map<Id,Id> oppId = new Map<Id,Id>();
    for(Integer k=0; k<OppList.size(); k++){
        oppId.put(OppList[k].Id,OppList[k].RecordTypeId);
    }

    //----------------------------------------------------
    //  Define a variable
    //----------------------------------------------------
    Integer iResult = 0;
    List<OpportunityLineItem> JP_oList = new List<OpportunityLineItem>();
    List<OpportunityLineItem> JP_nList = new List<OpportunityLineItem>();

    for(OpportunityLineItem oli: Trigger.new){

        //----------------------------------------------------
        //  This is Japan Logic
        //----------------------------------------------------
        System.debug(oli.OpportunityId + '★★★' + oppId.get(oli.OpportunityId) + '★★★' + rtmap.get('JP_Opportunity'));
        //record type ID corresponding to Opportunity ID of the object record is acquired from oppId, and it agrees to record type ID of Japan. 
        if(oppId.get(oli.OpportunityId)==rtmap.get('JP_Opportunity')){
            if(oli.JP_NoTriggerFlag__c == false){
                JP_nList.add(oli);
                if(Trigger.isUpdate){
                    JP_oList.add(Trigger.oldMap.get(oli.id));
                }
            }
        }

    }

    //----------------------------------------------------
    //  This is Japan Logic
    //----------------------------------------------------
    if(JP_nList.size() > 0 ){
        try{
            //Execute Setting Fixed Price Process
            System.debug('★★★OpportunityLineItem★★★');
            JP_CLEditOppLineItem eoli = new JP_CLEditOppLineItem();
            iResult = eoli.setFixedPrice(JP_oList, JP_nList);
        }
        catch (Exception e){
            Trigger.new[0].addError(e.getMessage());
        }
    }

}