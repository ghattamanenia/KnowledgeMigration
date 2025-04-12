/**
 * パートナーサイト連携トリガハンドラー
 **/
public class IntegratePartnerSiteHandler {
    /**
     * ユーザ作成
     **/
    @future(callout=true)
    public static void CreateUser(ID conId){
        System.debug('CreateUser Start');
        // 顧客情報取得
        Contact con = [SELECT Account.JP_CompanyCode__c, Account.Name, LastName, FirstName, Email, JP_isPartnerSiteInvited__c FROM Contact WHERE Id = :conId];
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        // 連携先情報取得
        PartnerSiteIntegrateInfo__mdt partnerSiteIntegrateInfo = [SELECT URL__c, MethodNameOfCreateUser__c FROM PartnerSiteIntegrateInfo__mdt WHERE DeveloperName = 'IntegrateInfo'];
        req.setEndpoint(partnerSiteIntegrateInfo.URL__c +partnerSiteIntegrateInfo.MethodNameOfCreateUser__c);
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('POST');
        req.setTimeout(120000);

        // 連携情報セット
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('salesforceId', con.Id);
        gen.writeStringField('acCode', con.Account.JP_CompanyCode__c);
        gen.writeStringField('companyName', con.Account.Name);
        gen.writeStringField('lastName', con.lastName);
        gen.writeStringField('firstName', con.firstName);
        gen.writeStringField('email', con.Email);
        gen.writeEndObject();
        req.setBody(gen.getAsString());
        System.debug('gen = ' + gen.getAsString());

        // 連携実行
        res = http.send(req);
        // 連携が失敗した場合
        if (res.getStatusCode() != 200){
            flg.firstRun = false;
            // パートナーサイトユーザフラグとパートナーサイト招待済みフラグをtrueに更新
            con.JP_isPartnerSiteUser__c = false;
            con.JP_isPartnerSiteInvited__c = false;
            update con;

            // 組織のメールアドレスを取得する
            OrgWideEmailAddress wkOrgWideEmailAddress = [SELECT ID FROM OrgWideEmailAddress WHERE DisplayName = 'アライドテレシス パートナープログラム事務局' LIMIT 1];

            // 送信先セット
            List<String> toAddressList = new List<String>();
            toAddressList.add(con.Email);

            // メール送信
            List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTargetObjectId(UserInfo.getUserId());               // 宛先
            mail.setOrgWideEmailAddressId(wkOrgWideEmailAddress.Id);    // 送信者
            mail.setBccSender(false);                                   // 送信者にBCCで送信
            mail.setSaveAsActivity(false);                              // 活動に紐づける
            mail.setSubject('パートナーサイトへのユーザ登録が失敗しました');    // 件名
            mail.setPlainTextBody('パートナーサイトへのユーザ登録が失敗しました。\r\n\r\n'+res.getBody()); // 本文
            mailList.add(mail);
            Messaging.sendEmail(mailList);

            // 連携が成功した場合
        }else{
            // パートナーサイト招待済みフラグをtrueに更新
            con.JP_isPartnerSiteInvited__c = true;
            update con;

            // メール送信
            System.debug('res = ' + res.getBody());
            Map<String, Object> bodyMap = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
            System.debug('bodyMap = ' + bodyMap);
            String password = EncodingUtil.urlDecode(String.valueOf(bodyMap.get('password')), 'UTF-8');

            // 組織のメールアドレスを取得する
            OrgWideEmailAddress wkOrgWideEmailAddress = [SELECT ID FROM OrgWideEmailAddress WHERE DisplayName = 'アライドテレシス パートナープログラム事務局' LIMIT 1];

            // メールテンプレート取得
            EmailTemplate mailTemp = [SELECT Subject, Body FROM EmailTemplate WHERE DeveloperName = 'NotificationUserCreate' LIMIT 1];

            // テンプレートを置換する
            String subject = mailTemp.Subject;

            String body = mailTemp.Body.replace('[name]', con.lastName + ' ' + con.firstName);
            body = body.replace('[loginId]', con.Email);
            body = body.replace('[password]', password);

            // 送信先セット
            List<String> toAddressList = new List<String>();
            toAddressList.add(con.Email);

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

        }
        System.debug('CreateUser End');
    }

    /**
     * ユーザ無効化
     **/
    @future(callout=true)
    public static void DeactivateUser(String conId){
        System.debug('DeactivateUser Start');
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        // 連携先情報取得
        PartnerSiteIntegrateInfo__mdt partnerSiteIntegrateInfo = [SELECT URL__c, MethodNameOfUpdateUser__c FROM PartnerSiteIntegrateInfo__mdt WHERE DeveloperName = 'IntegrateInfo'];
        req.setEndpoint(partnerSiteIntegrateInfo.URL__c +partnerSiteIntegrateInfo.MethodNameOfUpdateUser__c);
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('POST');
        req.setTimeout(120000);

        // 連携情報セット
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('salesforceId', conId);
        gen.writeStringField('active', 'false');
        gen.writeEndObject();
        req.setBody(gen.getAsString());

        // テストクラスの場合は実行しない
        if (Test.IsRunningTest() == false){
            // 連携実行
            res = http.send(req);
            // 連携が失敗した場合
            if (res.getStatusCode() != 200){
                CustomException ex = new CustomException();
                ex.setMessage('ユーザ無効化 error!!\n' + res.getBody());
                throw ex;
            }
        }
        System.debug('DeactivateUser End');
    }
}