@RestResource(urlMapping='/SendMailSaleVerifier/*')
global class SendMailSaleVerifierCotroller {

    /**
     * POSTメソッド
     * 
     * @description パートナーサイトでの検証機特別販売の申し込みがあったことをメール通知する
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
            String userId = EncodingUtil.urlDecode(String.valueOf(bodyMap.get('userId')), 'UTF-8');
            String companyName = EncodingUtil.urlDecode(String.valueOf(bodyMap.get('companyName')), 'UTF-8');
            String department = EncodingUtil.urlDecode(String.valueOf(bodyMap.get('department')), 'UTF-8');
            String sfdcdepartment = EncodingUtil.urlDecode(String.valueOf(bodyMap.get('sfdcdepartment')), 'UTF-8');
            String name = EncodingUtil.urlDecode(String.valueOf(bodyMap.get('name')), 'UTF-8');
            String phone = EncodingUtil.urlDecode(String.valueOf(bodyMap.get('phone')), 'UTF-8');
            String sfdcphone = EncodingUtil.urlDecode(String.valueOf(bodyMap.get('sfdcphone')), 'UTF-8');
            String email = EncodingUtil.urlDecode(String.valueOf(bodyMap.get('email')), 'UTF-8');
            String sfdcemail = EncodingUtil.urlDecode(String.valueOf(bodyMap.get('sfdcemail')), 'UTF-8');
            String saleRequestMachine = EncodingUtil.urlDecode(String.valueOf(bodyMap.get('saleRequestMachine')), 'UTF-8');
            String memo = EncodingUtil.urlDecode(String.valueOf(bodyMap.get('memo')), 'UTF-8');

            // 顧客情報取得
            Contact con = [SELECT JP_CustomerCode__c FROM Contact WHERE Id = :userId];

            // 組織のメールアドレスを取得する
            OrgWideEmailAddress wkOrgWideEmailAddress = [SELECT ID FROM OrgWideEmailAddress WHERE DisplayName = 'アライドテレシス パートナープログラム事務局' LIMIT 1];

            // メールテンプレート取得
            EmailTemplate mailTemp = [SELECT Subject, Body FROM EmailTemplate WHERE DeveloperName = 'NotificationSaleVerifier' LIMIT 1];

            // テンプレートを置換する
            String subject = mailTemp.Subject.replace('[companyName]', companyName);
            subject = subject.replace('[department]', department);
            subject = subject.replace('[sfdcdepartment]', sfdcdepartment);
            subject = subject.replace('[name]', name);
            subject = subject.replace('[phone]', phone);
            subject = subject.replace('[sfdcphone]', sfdcphone);
            subject = subject.replace('[email]', email);
            subject = subject.replace('[sfdcemail]', sfdcemail);
            subject = subject.replace('[saleRequestMachine]', saleRequestMachine);
            subject = subject.replace('[memo]', memo);
            subject = subject.replace('[customerCode]', con.JP_CustomerCode__c);

            String body = mailTemp.Body.replace('[companyName]', companyName);
            body = body.replace('[department]', department);
            body = body.replace('[sfdcdepartment]', sfdcdepartment);
            body = body.replace('[name]', name);
            body = body.replace('[phone]', phone);
            body = body.replace('[sfdcphone]', sfdcphone);
            body = body.replace('[email]', email);
            body = body.replace('[sfdcemail]', sfdcemail);
            body = body.replace('[saleRequestMachine]', saleRequestMachine);
            body = body.replace('[memo]', memo);
            body = body.replace('[customerCode]', con.JP_CustomerCode__c);

            // 送信先をカスタムメタデータから取得する
            PartnerSiteMailAddresses__mdt partnerSiteMailAddress = [SELECT Email__c FROM PartnerSiteMailAddresses__mdt WHERE DeveloperName = 'NotificationSaleVerifier' LIMIT 1];
            List<String> toAddressList = new List<String>();
            toAddressList.add(partnerSiteMailAddress.Email__c);

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