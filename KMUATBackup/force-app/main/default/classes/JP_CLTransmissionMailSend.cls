/*******************
Description:TransmissionMailSend
Developer: Hitachi Solutions, Ltd.
Date Created: 05/07/2012
Date Modified:05/10/2012
*****************/
public with sharing class JP_CLTransmissionMailSend {
    /**
    * description：The contents of the mail to transmit. 
    * SendMailMap : send Mail Opportunity Map
    * mailSubjectStr：Mail subject
    * mailBodyStr：Mail text
    */
    private static Set<id> targetSet = null;

    private static string ToString(object obj){
System.debug('obj =' + obj);
        return (obj!=null) ? String.valueOf(obj) : '';
    }
    
    /** method：return hasTargetSet **/
    public static boolean hasTargetSet(){
        return (targetSet != null) ? true : false;
    }

    /** method:set targetSet **/
    public static void setTargetSet(List<Opportunity> orgList,ID targetID) {
        targetSet = new Set<id>();
        for( Opportunity opp : orgList){
            // select Opportunity which are send mail.
            if(opp.RecordTypeId == targetID && opp.JP_MailFlag__c == true){
                targetSet.add(opp.ID);
            }
        }
    }

    /** method：update SendMailMap **/
    public static void UpdateMailSendMap(Map<Id,Opportunity> afterOppMap){
        // when there is no record, RETURN.
        if(targetSet.size() == 0) {
            return;
        }
        // when there is a record, create send Mail Map.
        Map<Id,Opportunity> targetMap = new Map<Id,Opportunity>();

        for(ID targetID : targetSet){
            if(afterOppMap.containsKey(targetID)){
                targetMap.put(targetID,afterOppMap.get(targetID));
            }
        }
        
        if(targetMap.size() > 0) {
            // call method MailSend.
            MailSend(targetMap);
        }
    }

    /** method：send TransmissionMail **/
    private static void MailSend(Map<Id,Opportunity> oppMap){

        // get data OpportunityTeamMember(Outside Sales,Inside Sales)
        List<OpportunityTeamMember> list_Sales = [Select
                                                OpportunityId,
                                                User.Name,
                                                User.Email,
                                                User.UserRoleId,
                                                TeamMemberRole
                                           from OpportunityTeamMember
                                          where OpportunityId in :oppMap.keySet()
                                            and User.IsActive = True
                                            and (TeamMemberRole = :JP_CLCommonConst.OPPORTUNITYTEAMMEMBERROLEOUT
                                             or TeamMemberRole = :JP_CLCommonConst.OPPORTUNITYTEAMMEMBERROLEIN)
                                       order by LastModifiedDate asc];

        // create Outside Sales,Inside Sales Map and make Set for get UserRoleData.
        Map<Id,OpportunityTeamMember> map_Out = new Map<Id,OpportunityTeamMember>();
        Map<Id,Id> map_IdOut = new Map<Id,Id>();
        Map<Id,OpportunityTeamMember> map_In = new Map<Id,OpportunityTeamMember>();
        for(OpportunityTeamMember opptm : list_Sales){
            if(opptm.TeamMemberRole==JP_CLCommonConst.OPPORTUNITYTEAMMEMBERROLEOUT){
                map_Out.put(opptm.OpportunityID,opptm);
                map_IdOut.put(opptm.OpportunityID,opptm.User.UserRoleId);
            }else{
                map_In.put(opptm.OpportunityID,opptm);
            }
        }
        
        // create Outside Sales list,make Map for UserRole.
        Map<Id,UserRole> map_RoleUser  = new Map<Id,UserRole>([Select Id,Name From UserRole Where id in : map_IdOut.values()]);
        
        // get data Partner.
        List<OpportunityPartner> list_Partner = [Select
                                                OpportunityId,
                                                AccountTo.Name
                                           from OpportunityPartner
                                          where OpportunityId in :oppMap.keySet()
                                            and isPrimary = True ];
                                            

        // create map for OpportunityPartner.
        Map<Id,String> map_Partner = new Map<Id,String>();
        for(OpportunityPartner oppP : list_Partner) {
            map_Partner.put(oppP.OpportunityId,oppP.AccountTo.Name);
        }
        
        // create Set for User.(LoginUser & OwnerUser)
        Set<Id> set_UserId = new Set<Id>();
        set_userId.add(Userinfo.getUserId());
        for(Opportunity op : oppMap.values()){
            set_UserId.add(op.OwnerId);
        }

        // create Map for User's Email.(LoginUser & OwnerUser)
        Map<Id,User> map_User = new Map<Id,User>([Select Id,Email,Name From User Where IsActive = True and Id in : set_UserId]);

        // create List for send Mail.
        List<Messaging.Singleemailmessage> mailList = new List<Messaging.Singleemailmessage>();
        List<Id> sendOppIDList = new List<Id>();

        // Loop : number which sends Email Opportunity.
        for(Opportunity op : oppMap.values()){
            String OutName='';
            String OutRole='';
            String OutEmail='';
            String InName='';
            String InEmail='';
            if(map_Out.get(op.Id)!=null ){
                ToString(OutName=map_Out.get(op.Id).User.Name);
                ToString(OutRole=map_RoleUser.get(map_Out.get(op.Id).User.UserRoleId).Name);
                ToString(OutEmail=map_Out.get(op.Id).User.Email);
            }
            if(map_In.get(op.Id)!=null){
                ToString(InName=map_In.get(op.Id).User.Name);
                ToString(InEmail=map_In.get(op.Id).User.Email);
            }
            
            // create Email.
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            // create Subject.
            mail.setSubject(String.format(JP_CLCommonConst.MAILSUBJECT,new list<string>{op.JP_AccountName__c}));
            
            // create Text.
            mail.setPlainTextBody(String.format(JP_CLCommonConst.MAILTEXT, new list<string>{OutName,
                                                                                  InName,
                                                                                  OutRole,
                                                                                  URL.getSalesforceBaseUrl().toExternalForm() + '/' +ToString(op.Id),
                                                                                  ToString(op.ATFE_OppID__c),
                                                                                  ToString(op.JP_AccountName__c),
                                                                                  ToString(op.Name),
                                                                                  ToString(op.JP_StageName__c),
                                                                                  ToString(op.JP_EnduserPrefecture__c),
                                                                                  ToString(op.JP_EnduserUrl__c),
                                                                                  ToString(op.JP_EnduserIndustry__c),
                                                                                  ToString((String)map_Partner.get(op.Id)),
                                                                                  ToString(op.JP_SpecialServiceForMembers__c),
                                                                                  ToString(op.JP_Distribution__c),
                                                                                  //ワークフローでの動きに合わせ、round（四捨五入）を使用 -
                                                                                  ToString(op.CurrencyIsoCode+' '+op.Amount.round().format()),
                                                                                  ToString(op.JP_MaintenanceTrace__c),
                                                                                  ToString(op.JP_Rank__c),
                                                                                  // 20210210 ATKK確度と代理店確度を削除(P99_04-98)
                                                                                  '',
                                                                                  '',
                                                                                  ToString(op.JP_OrderDate__c.format()),
                                                                                  ToString(op.CloseDate.format()),
                                                                                  ToString(op.Description)}));

            // set SendToAddress : outside Sales, inside Sales, Owner, MailAilias.
            Set<string> set_MailTo = new Set<string>();
            List<string> list_MailTo = new List<string>();
            if(OutEmail != ''){
                set_MailTo.add(OutEmail);
            }
            if(InEmail != ''){
                set_MailTo.add(InEmail);
            }
            if(ToString(map_User.get(op.OwnerId)) != ''){
                set_MailTo.add(ToString(map_User.get(op.OwnerId).Email));
            }
            set_MailTo.add(ToString(op.JP_OppMailAilias__c));
            list_MailTo.addAll(set_MailTo);
            mail.setToAddresses(list_MailTo);

            // set SendFromAddress : LoginUser.
            mail.setSenderDisplayName(map_User.get(Userinfo.getUserId()).Name);

            // add sendEmailList.
            mailList.add(mail);
            
            // add send Email Opportunity List.
            sendOppIDList.add(op.Id);
        }

        // call Class to send mail.
        try{
            list<Messaging.Sendemailresult> serList = Messaging.sendEmail(mailList,false);

            system.debug(sendOppIdList+'★★★');
            // when an error is inside as a result of e-mail transmission, add Opportunity addError.
            for(Integer i=0 ; i<serList.size() ; i++){
                if(serList[i].isSuccess()!=true && serList[i].getErrors()!=null){
                    for(Messaging.Sendemailerror see : serList[i].getErrors()){
                        system.debug(serList[i]+'★★★'+serList[i].getErrors()+'■■■'+see.getFields()+'Code'+see.getStatusCode()+'Id'+see.getTargetObjectId());
                        oppMap.get(sendOppIdList[i]).addError(see.getMessage());
                    }
                }
            }
        }
        catch ( Exception e ){
            for( Opportunity opp : oppMap.values() ){
                opp.addError(e.getmessage());
            }
            System.debug(e.getMessage());
            system.debug('★★★SendEmailError★★★');
        }
    }
}