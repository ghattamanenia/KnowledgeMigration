@RestResource(urlMapping='/SendMailAspProgram/*')
global class SendMailAspProgramCotroller {

    /**
     * POSTメソッド
     * 
     * @description パートナーサイトでの利益還元プログラムの申し込みがあったことをメール通知する
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
            String aspProgramId = EncodingUtil.urlDecode(String.valueOf(bodyMap.get('aspProgramId')), 'UTF-8');

            // 顧客情報取得
            Contact con = [SELECT AccountId, Account.JP_CompanyCode__c, Account.Name,JP_CustomerCode__c, Name, Department, Phone, Email, Account.JP_ASP_Rank__c FROM Contact WHERE Id = :userId];

            // 利益還元プログラム取得
            JP_ASP_Program__c aspProgram = [SELECT JP_Period__c FROM JP_ASP_Program__c WHERE Id = :aspProgramId];
            
            // ASPプログラムを登録する
            JP_Management_ASP_Program__c ASP_Program = new JP_Management_ASP_Program__c();
            ASP_Program.JP_ASP_Rank__c = con.Account.JP_ASP_Rank__c;
            ASP_Program.JP_ASP_Program__c = aspProgramId;
            ASP_Program.JP_Account__c = con.AccountId;
            ASP_Program.JP_RegisteredBy__c = con.Id;
            insert ASP_Program;

            // 組織のメールアドレスを取得する
            OrgWideEmailAddress wkOrgWideEmailAddress = [SELECT ID FROM OrgWideEmailAddress WHERE DisplayName = 'アライドテレシス パートナープログラム事務局' LIMIT 1];

            // メールテンプレート取得
            EmailTemplate mailTemp = [SELECT Subject, Body FROM EmailTemplate WHERE DeveloperName = 'NotificationAspProgram' LIMIT 1];

            // テンプレートを置換する
            String subject = mailTemp.Subject.replace('[period]', aspProgram.JP_Period__c);
            subject = subject.replace('[companyCode]', con.Account.JP_CompanyCode__c);
            subject = subject.replace('[companyName]', con.Account.Name);
            subject = subject.replace('[customerCode]', con.JP_CustomerCode__c);
            subject = subject.replace('[name]', con.Name);
            subject = subject.replace('[sfdcemail]', con.Email);

            String body = mailTemp.Body.replace('[period]', aspProgram.JP_Period__c);
            body = body.replace('[companyCode]', con.Account.JP_CompanyCode__c);
            body = body.replace('[companyName]', con.Account.Name);
            body = body.replace('[customerCode]', con.JP_CustomerCode__c);
            body = body.replace('[name]', con.Name);
            body = body.replace('[sfdcemail]', con.Email);

            // 送信先をカスタムメタデータから取得する
            PartnerSiteMailAddresses__mdt partnerSiteMailAddress = [SELECT Email__c FROM PartnerSiteMailAddresses__mdt WHERE DeveloperName = 'NotificationAspProgram' LIMIT 1];
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