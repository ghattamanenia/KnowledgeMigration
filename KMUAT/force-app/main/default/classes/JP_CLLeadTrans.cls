public with sharing class JP_CLLeadTrans {
    /** メソッド：所有者変更 **/
    static public void LeadOwnerChange(ID idRec,List<Lead> translst_New) {
        for (Lead le:translst_New){
            //所有者を営業担当or拠点長の値で上書きする
            le.OwnerId = le.JP_TransUser__c;
        }
    }

    /**
    * 説明：LeadTransで送信するメールの内容。
    * string mailSubjectStr：メール件名
    * mailBodyStr：メール本文
    */
//    private static final string mailSubjectStr = '{0}TransReport ({1}) {2} {3}様';
//    private static final string mailBodyStr
//                      = 'TO：{0}　様 \n'+
//                        'CC：拠点関係各位、関連各位 \n'+
//                        'FR：{1} \n'+
//                        '　　（承認：{2}） \n'+
//                        '\n'+
//                        '■{3} {4}\n'+
//                        '\n'+
//                        '==顧客情報== \n'+
//                        '【会社名】{5} \n'+
//                        '【 氏名 】{6} 様 \n'+
//                        '\n'+
//                        '==SFDCリード== \n'+
//                        '{7} \n'+
//                        'リードから活動履歴の「件名」をクリックし、ToDo情報を確認してください。 \n'+
//                        '確認後、ToDo情報画面の右上「名前」からリードに戻り、「営業コメント」を選択してください。 \n'+
//                        '「取引の開始」をクリックし、商談にするか否かを選択してください。 \n'+
//                        '\n'+
//                        '以上、宜しくお願い致します。\n';
    private static final string mailSubjectStr = JP_CLCommonConst.TRANSMAILSUBJECT;
    private static final string mailBodyStr
                      = JP_CLCommonConst.TRANSMAILTEXT;


    private static boolean IsEmpty(string str){
        return ( (str==null) || (str.trim().length()==0) );
    }

    public static boolean IsEmpty(list<Object> lst){
        return ( (lst==null) || (lst.isEmpty()) );
    }

    private static string ToString(object obj){
        return (obj!=null) ? String.valueOf(obj) : '';
    }

    /** メソッド：トランス通知メール送信 **/
    static public void LeadTrans(Map<Id,Lead> transmap_New){

        // トランス先情報の取得
        List<JP_LeadTrans__c> lst_MailCc = [Select
                                                JP_LeadTrans__c.JP_Lead__c,
                                                JP_LeadTrans__c.JP_PersonInChargeEmail__c
                                           from JP_LeadTrans__c
                                          where JP_LeadTrans__c.JP_Lead__c in :transMap_New.keySet() ];

        // Lead-MailCcトランス先リストのMap作成
        Map<Id,List<string>> map_MailCC = new Map<Id,List<string>>();
        for(JP_LeadTrans__c lt : lst_MailCc) {
            if (IsEmpty(lt.JP_PersonInChargeEmail__c))  continue;
            List<string> listLT = ( map_MailCC.containsKey(lt.JP_Lead__c) ) ? map_MailCC.get(lt.JP_Lead__c) : new list<string>();
            listLT.add(lt.JP_PersonInChargeEmail__c);
            map_MailCC.put(lt.JP_Lead__c,listLT);
        }

        // トランス通知対象データ全件のメール送信データを格納するリスト
        List<Messaging.Singleemailmessage> mailList = new List<Messaging.Singleemailmessage>();
        List<Id> sendLeadIdList = new List<Id>();

        // ログインユーザの情報を取得
        List<User> loginUser = [Select JP_FullName__c From User Where id=: Userinfo.getUserId()];
        if(loginUser[0].JP_FullName__c == null){
            loginUser[0].JP_FullName__c = '';
        }

        // ループ処理：トランス通知対象データ全件
        for( Lead le : transmap_New.values() ){

            // メール作成
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            // 件名
            mail.setSubject(String.format(mailSubjectStr, new list<string>{ToString(le.JP_Priority__c), ToString(le.JP_TransformerClassification__c), ToString(le.Company),ToString(le.LastName) + ToString(le.FirstName)}));

            // 本文
            mail.setPlainTextBody(String.format(mailBodyStr, new list<string>{ToString(le.JP_TransUserName__c),
                                                                                  ToString(le.JP_CreatedByUserName__c),
                                                                                  loginUser[0].JP_FullName__c,
                                                                                  ToString(le.JP_TransformerClassification__c),
                                                                                  ToString(le.JP_Priority__c),
                                                                                  ToString(le.Company),
                                                                                  ToString(le.LastName) + ToString(le.FirstName),
                                                                                  URL.getSalesforceBaseUrl().toExternalForm() + '/' + ToString(le.id)}));
            // 宛先Toへ営業担当を設定
            mail.setToAddresses(new List<string>{le.JP_TransUserEmail__c});

            // CCメールアドレスのリスト取得
            List<string> listLT = ( map_MailCC.containsKey(le.Id) ) ? map_MailCC.get(le.Id) : new list<string>();

            //リード作成者のアドレス確認
            if (!IsEmpty(le.JP_CreatedByEmail__c)){
                //宛先Ccへリード作成者を設定
                listLT.add(le.JP_CreatedByEmail__c);
                //ReplyToへリード作成者を設定
                mail.setReplyTo(le.JP_CreatedByEmail__c);
                //差出人名へリード作成者を設定
                mail.setSenderDisplayName(le.JP_CreatedByUserName__c);
            }

            if (!IsEmpty(listLT))    mail.setCcAddresses(listLT);
                //１件のメール送信データをリストへ追加
                mailList.add(mail);
                // メール送信リードIDリストにも追加
                sendLeadIdList.add(le.Id);
            }

        // 送信するメールがなければRETURN
        if(isEmpty(mailList))    return;

        //メール送信クラスの呼び出し
        try{
            list<Messaging.Sendemailresult> serList = Messaging.sendEmail(mailList,false);

            // 送信結果中にエラーがあった場合は対象リードにaddError。
            for(Integer i=0 ; i<serList.size() ; i++){
                if(serList[i]==null || serList[i].isSuccess() || serList[i].getErrors()==null)    continue;
                for(Messaging.Sendemailerror see : serList[i].getErrors()){    transmap_New.get(sendLeadIdList[i]).addError(see.getMessage());    }
            }
        }
        catch ( Exception e ){
            for( Lead le : transmap_New.values() ){   le.addError(e.getmessage());    }
            System.debug(e.getMessage());
            system.debug('★★★SendEmailError★★★');
        }
    }
}