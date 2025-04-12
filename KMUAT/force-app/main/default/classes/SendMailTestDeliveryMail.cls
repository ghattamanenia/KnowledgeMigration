@RestResource(urlMapping='/DeliveryMailTest/*')
global class SendMailTestDeliveryMail {

    /**
     * POSTメソッド
     * 
     * @description メールをテスト配信する
     */
    @HttpPost
    global static void doPost() {
        try{
            // リクエストを取得する
            RestRequest req = RestContext.request;
            System.debug('req = ' + req.requestBody.toString());
            // BODY(JSON)をマップに変換する
            Map<String, Object> bodyMap = (Map<String, Object>)JSON.deserializeUntyped(req.requestBody.toString());
            System.debug('bodyMap = ' + bodyMap);
            String contactCode = EncodingUtil.urlDecode(String.valueOf(bodyMap.get('contact_code')), 'UTF-8');

            // 組織のメールアドレスを取得する
            OrgWideEmailAddress wkOrgWideEmailAddress = [SELECT ID FROM OrgWideEmailAddress WHERE DisplayName = 'アライドテレシス パートナープログラム事務局' LIMIT 1];

            List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
            String errMessage = '';
            for (Contact con: [SELECT Account.Name, Name FROM Contact WHERE JP_isRebateAccessPermitted__c = true AND JP_isPartnerSiteInvited__c = true AND EmailBouncedDate = NULL AND JP_CustomerCode__c = :contactCode]){
                // メールテンプレート取得
                EmailTemplate mailTemp = [SELECT Subject, Body FROM EmailTemplate WHERE DeveloperName = 'DeliveryMail' LIMIT 1];

                // テンプレートを置換する
                String subject = mailTemp.Subject.replace('[accountName]', con.Account.Name);
                subject = subject.replace('[name]', con.Name);

                String body = mailTemp.Body.replace('[accountName]', con.Account.Name);
                body = body.replace('[name]', con.Name);

                // メール送信
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setTargetObjectId(con.Id);                             // 宛先
                mail.setOrgWideEmailAddressId(wkOrgWideEmailAddress.Id);    // 送信者
                mail.setBccSender(false);                                   // 送信者にBCCで送信
                mail.setSaveAsActivity(false);                              // 活動に紐づける
                mail.setSubject(subject);                                   // 件名
                mail.setPlainTextBody(body);                                // 本文
                mailList.add(mail);
                List<Messaging.SendEmailResult> results = Messaging.sendEmail(mailList);
                for (Messaging.SendEmailResult result: results){
                    if (result.isSuccess() == false){
                        for (Messaging.SendEmailError err: result.getErrors()){
                            if (String.isBlank(errMessage) == false) {
                                errMessage = errMessage + '\r\n';
                            }
                            errMessage = errMessage + err.targetobjectid + ':' + err.getMessage();
                        }
                    }
                }
            }
            if (String.isBlank(errMessage) == false) {
                RestResponse res = RestContext.response;
                res.statusCode = 200;
                res.responseBody = blob.valueOf(EncodingUtil.urlEncode(errMessage, 'UTF-8'));
                return;
            }
            if (mailList.size() == 0){
                RestResponse res = RestContext.response;
                res.statusCode = 200;
                res.responseBody = blob.valueOf(EncodingUtil.urlEncode('送信対象者がいません', 'UTF-8'));
                return;
            }

            // Responseに連携成功ステータスをセット
            RestResponse res = RestContext.response;
            res.statusCode = 200;
        }catch(Exception e){
            // システムエラーをログに出力
            system.debug('システムエラーが発生しました。\r\n' + e.getMessage() + '\r\n' + e.getStackTraceString());

            // Responseにエラー情報をセット
            RestResponse res = RestContext.response;
            res.statusCode = 200;
            res.responseBody = blob.valueOf(EncodingUtil.urlEncode(e.getMessage(), 'UTF-8'));
        }
    }

}