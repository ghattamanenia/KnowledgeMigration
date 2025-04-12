/*******************
Description:TransmissionMailSend
Developer: Hitachi Solutions, Ltd.
Date Created: 05/07/2012
Date Modified:05/10/2012
*****************/
trigger JP_TRTransmissionMailSend on Opportunity (after insert,after update) {

        integer dummy1 = 0;
        integer dummy2 = 0;
        integer dummy3 = 0;
        
        System.debug('★★★JP_TRTransmissionMailSendStart★★★');

        // send TransmissionMail.
        // Definition : send Email Opportunity Map.
        
        if(!JP_CLTransmissionMailSend.hasTargetSet()){
            // 1st trigger or no send Mail action.Select japanese Recordtype.
            List<RecordType> RecordTypeList = [select Id from RecordType where SObjectType = 'Opportunity' and Name = 'JP_Opportunity' limit 1];

            if(RecordTypeList != null && RecordTypeList.size() > 0){
                // Call JP_CLTransmissionMailSend Class
                JP_CLTransmissionMailSend.setTargetSet(Trigger.New,RecordTypeList[0].Id);
            } else {
                // error handling.
                for(Opportunity opp :Trigger.new){
                    opp.addError('JP_Opportunity Recordtype does not exist.');
                }
                return;
            }

        }else{
            // 2nd trigger action.Call JP_CLTransmissionMailSend Class.
            if(JP_Flag.TRTransmissionMailSendFlag == false){
                JP_Flag.TRTransmissionMailSendFlag = true;
                JP_CLTransmissionMailSend.UpdateMailSendMap(Trigger.newMap);
            }
        }
}