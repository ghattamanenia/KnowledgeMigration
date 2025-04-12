@RestResource(urlMapping='/SendMailIntenalUser/*')
global class SendMailIntenalUserCotroller {

    /**
     * POSTメソッド
     * 
     * @description パートナーサイトでの社内ユーザ登録があったことをメール通知する
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
            String lastName = EncodingUtil.urlDecode(String.valueOf(bodyMap.get('lastName')), 'UTF-8');
            String firstName = EncodingUtil.urlDecode(String.valueOf(bodyMap.get('firstName')), 'UTF-8');
            String loginId = EncodingUtil.urlDecode(String.valueOf(bodyMap.get('loginId')), 'UTF-8');
            String email = EncodingUtil.urlDecode(String.valueOf(bodyMap.get('email')), 'UTF-8');
            String password = EncodingUtil.urlDecode(String.valueOf(bodyMap.get('password')), 'UTF-8');

            // 組織のメールアドレスを取得する
            OrgWideEmailAddress wkOrgWideEmailAddress = [SELECT ID FROM OrgWideEmailAddress WHERE DisplayName = 'アライドテレシス パートナープログラム事務局' LIMIT 1];

            // メールテンプレート取得
            EmailTemplate mailTemp = [SELECT Subject, Body FROM EmailTemplate WHERE DeveloperName = 'NotificationInternalUser' LIMIT 1];

            // テンプレートを置換する
            String subject = mailTemp.Subject.replace('[lastName]', lastName);
            subject = subject.replace('[firstName]', firstName);
            subject = subject.replace('[loginId]', loginId);
            subject = subject.replace('[email]', email);
            subject = subject.replace('[password]', password);

            String body = mailTemp.Body.replace('[lastName]', lastName);
            body = body.replace('[firstName]', firstName);
            body = body.replace('[loginId]', loginId);
            body = body.replace('[email]', email);
            body = body.replace('[password]', password);

            // 送信先をカスタムメタデータから取得する
            List<String> toAddressList = new List<String>();
            toAddressList.add(email);

            // メール送信
            List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(toAddressList);                         // 宛先
            mail.setOrgWideEmailAddressId(wkOrgWideEmailAddress.Id);    // 送信者
            mail.setBccSender(false);                                   // 送信者にBCCで送信
            mail.setSaveAsActivity(false);                              // 活動に紐づける
            mail.setSubject(subject);                                   // 件名
            mail.setPlainTextBody(body);                                // 本文
            mailList.add(mail);
            Messaging.sendEmail(mailList);

            // Responseに連携成功ステータスをセット
            RestResponse res = RestContext.response;
            res.statusCode = 200;
        }catch(Exception e){
            // システムエラーをログに出力
            system.debug('システムエラーが発生しました。\r\n' + e.getMessage() + '\r\n' + e.getStackTraceString());

            // Responseにエラー情報をセット
            RestResponse res = RestContext.response;
            res.addHeader('Content-Type', 'application/json');
            String jsonResponse = '';
            res.statusCode = 500;
            jsonResponse = '{"message":"' + e.getMessage() + '", "errorCode": "Integration Failed"}';
            res.responseBody = blob.valueOf(jsonResponse);
        }
    }

}