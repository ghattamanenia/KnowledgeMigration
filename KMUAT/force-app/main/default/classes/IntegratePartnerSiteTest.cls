@isTest(SeeAllData=true)
private class IntegratePartnerSiteTest {
    private static String createAccount(){
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true;
        dml.DuplicateRuleHeader.runAsCurrentUser = true;
        RecordType accountRecordType = [SELECT Id FROM RecordType WHERE DeveloperName = 'JP_Accounts'];
        Account upsAccount = new Account();
        upsAccount.RecordTypeId = accountRecordType.Id;
        upsAccount.Name = 'PartnerSiteTestName';
        upsAccount.JP_CompanyKana__c = 'テスト';
        upsAccount.JP_AlternateName__c = 'PartnerSiteTestName';
        upsAccount.Industry = 'A　農業，林業';
        upsAccount.JP_Industry1b__c = '01　農業';
        upsAccount.Type = 'ディストリビューター';
        upsAccount.JP_Prefecture__c = '東京都';
        upsAccount.Phone = '0312345678';
        upsAccount.JP_ASP_Rank__c = 'AAA';
        Database.insert(upsAccount, dml);
        return upsAccount.Id;
    }
    private static String createContact(String accId){
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true;
        dml.DuplicateRuleHeader.runAsCurrentUser = true;
        RecordType contactRecordType = [SELECT Id FROM RecordType WHERE DeveloperName = 'JP_Contacts'];
        Contact upsContact = new Contact();
        upsContact.RecordTypeId = contactRecordType.Id;
        upsContact.AccountId = accId;
        upsContact.LastName = 'PartnerSiteTestLastName';
        upsContact.FirstName = 'PartnerSiteTestFirstName';
        upsContact.Email = 'test.user01@test.co.jp';
        upsContact.JP_Grade__c = 'A';
        upsContact.Email = 'test.user01@test.co.jp';
        Database.insert(upsContact, dml);
        return upsContact.Id;
    }

    static testmethod void test() {
        String accId = createAccount();
        String conId = createContact(accId);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new IntegratePartnerSiteMock());
        flg.firstRun = true;
        Contact con = [SELECT JP_isPartnerSiteUser__c FROM Contact WHERE Id = :conId];
        con.JP_isPartnerSiteUser__c = true;
        con.JP_isPartnerSiteInvited__c = false;
        update con;
        flg.firstRun = true;
        con.JP_isPartnerSiteInvited__c = true;
        update con;
        flg.firstRun = true;
        con.JP_isPartnerSiteUser__c = false;
        update con;
        Test.stopTest();
    }

    static testmethod void test1() {
        String accId = createAccount();
        String conId = createContact(accId);
        Test.startTest();
        Contact con = [SELECT Id FROM Contact WHERE Id = :conId];
        Test.setMock(HttpCalloutMock.class, new IntegratePartnerSiteMock());
        IntegratePartnerSiteHandler.CreateUser(conId);
        Test.stopTest();
    }

    static testmethod void test1_1() {
        String accId = createAccount();
        String conId = createContact(accId);
        Test.startTest();
        Contact con = [SELECT Id FROM Contact WHERE Id = :conId];
        Test.setMock(HttpCalloutMock.class, new IntegratePartnerSiteMock2());
        IntegratePartnerSiteHandler.CreateUser(conId);
        Test.stopTest();
    }

    static testmethod void test1_2() {
        String accId = createAccount();
        String conId = createContact(accId);
        Test.startTest();
        Contact con = [SELECT Id FROM Contact WHERE Id = :conId];
        Test.setMock(HttpCalloutMock.class, new IntegratePartnerSiteMock());
        IntegratePartnerSiteHandler.DeactivateUser(conId);
        Test.stopTest();
    }

    static testmethod void test1_2_1() {
        String accId = createAccount();
        String conId = createContact(accId);
        Test.startTest();
        Contact con = [SELECT Id FROM Contact WHERE Id = :conId];
        Test.setMock(HttpCalloutMock.class, new IntegratePartnerSiteMock2());
        IntegratePartnerSiteHandler.DeactivateUser(conId);
        Test.stopTest();
    }

    static testmethod void test1_3() {
        String accId = createAccount();
        String conId = createContact(accId);
        Test.startTest();
        flg.firstRun = true;
        try{
            Contact con = [SELECT AccountId FROM Contact WHERE Id = :conId];
            con.JP_isPartnerSiteUser__c = true;
            con.AccountId = null;
            update con;
        }catch (Exception e){

        }
        Test.stopTest();
    }

    static testmethod void test1_4() {
        String accId = createAccount();
        String conId = createContact(accId);
        Test.startTest();
        flg.firstRun = true;
        try{
            Contact con = [SELECT FirstName FROM Contact WHERE Id = :conId];
            con.JP_isPartnerSiteUser__c = true;
            con.FirstName = '';
            update con;
        }catch (Exception e){

        }
        Test.stopTest();
    }

    static testmethod void test1_5() {
        String accId = createAccount();
        String conId = createContact(accId);
        Test.startTest();
        flg.firstRun = true;
        Contact con = [SELECT Email FROM Contact WHERE Id = :conId];
        try{
            con.JP_isPartnerSiteUser__c = true;
            con.Email = '';
            update con;
        }catch (Exception e){

        }
        Test.stopTest();
    }

    static testmethod void test1_6() {
        String accId = createAccount();
        String conId = createContact(accId);
        Contact con = [SELECT JP_isPartnerSiteUser__c FROM Contact WHERE Id = :conId];
        con.JP_isPartnerSiteUser__c = true;
        con.JP_isPartnerSiteInvited__c = true;
        update con;
        Test.startTest();
        flg.firstRun = true;
        try{
            con = [SELECT Email FROM Contact WHERE Id = :conId];
            con.Email = '';
            update con;
        }catch (Exception e){

        }
        Test.stopTest();
    }
    static testmethod void test2() {
        String accId = createAccount();
        String conId = createContact(accId);
        Contact con = [SELECT JP_isPartnerSiteUser__c FROM Contact WHERE Id = :conId];
        con.JP_isPartnerSiteUser__c = true;
        con.JP_isPartnerSiteInvited__c = true;
        update con;
        Test.startTest();
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/SendMailSeminar';
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json');
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('userId', conId);
        gen.writeStringField('seminar', 'テストセミナー');
        gen.writeStringField('companyName', 'テスト会社');
        gen.writeStringField('department', 'テスト部署');
        gen.writeStringField('sfdcdepartment', 'SFDCテスト部署');
        gen.writeStringField('name', 'テスト顧客');
        gen.writeStringField('phone', '0312345678');
        gen.writeStringField('sfdcphone', '0323456789');
        gen.writeStringField('email', 'test@test.co.jp');
        gen.writeStringField('sfdcemail', 'test.user@test.co.jp');
        gen.writeStringField('attendanceDatetime', '2020-01-01');
        gen.writeStringField('memo', 'テストメモ');
        gen.writeEndObject();
        req.requestBody = Blob.valueOf(gen.getAsString());
        RestContext.request = req;
        RestResponse res = new RestResponse();
        RestContext.response = res;
        SendMailSeminarCotroller.doPost();
        Test.stopTest();
    }

    static testmethod void test3() {
        String accId = createAccount();
        String conId = createContact(accId);
        Contact con = [SELECT JP_isPartnerSiteUser__c FROM Contact WHERE Id = :conId];
        con.JP_isPartnerSiteUser__c = true;
        con.JP_isPartnerSiteInvited__c = true;
        update con;
        Test.startTest();
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/SendMailSaleVerifier';
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json');
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('userId', conId);
        gen.writeStringField('seminar', 'テストセミナー');
        gen.writeStringField('companyName', 'テスト会社');
        gen.writeStringField('department', 'テスト部署');
        gen.writeStringField('sfdcdepartment', 'SFDCテスト部署');
        gen.writeStringField('name', 'テスト顧客');
        gen.writeStringField('phone', '0312345678');
        gen.writeStringField('sfdcphone', '0323456789');
        gen.writeStringField('email', 'test@test.co.jp');
        gen.writeStringField('sfdcemail', 'test.user@test.co.jp');
        gen.writeStringField('saleRequestMachine', 'テスト機器');
        gen.writeStringField('memo', 'テストメモ');
        gen.writeEndObject();
        req.requestBody = Blob.valueOf(gen.getAsString());
        RestContext.request = req;
        RestResponse res = new RestResponse();
        RestContext.response = res;
        SendMailSaleVerifierCotroller.doPost();
        Test.stopTest();
    }

    static testmethod void test4() {
        String accId = createAccount();
        String conId = createContact(accId);
        Contact con = [SELECT JP_isPartnerSiteUser__c FROM Contact WHERE Id = :conId];
        con.JP_isPartnerSiteUser__c = true;
        con.JP_isPartnerSiteInvited__c = true;
        update con;
        Test.startTest();
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/SendMailRentalVerifier';
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json');
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('userId', conId);
        gen.writeStringField('seminar', 'テストセミナー');
        gen.writeStringField('companyName', 'テスト会社');
        gen.writeStringField('department', 'テスト部署');
        gen.writeStringField('sfdcdepartment', 'SFDCテスト部署');
        gen.writeStringField('name', 'テスト顧客');
        gen.writeStringField('phone', '0312345678');
        gen.writeStringField('sfdcphone', '0323456789');
        gen.writeStringField('email', 'test@test.co.jp');
        gen.writeStringField('sfdcemail', 'test.user@test.co.jp');
        gen.writeStringField('description', 'テスト詳細');
        gen.writeStringField('introductionTime', 'テスト時期');
        gen.writeStringField('verifierContent', 'テスト内容');
        gen.writeStringField('rentalRequestMachine', 'テスト機器');
        gen.writeStringField('rentalRequestPeriod', 'テスト貸出期間');
        gen.writeStringField('sendPostalCode', 'テスト郵便番号');
        gen.writeStringField('sendAddress', 'テスト住所');
        gen.writeStringField('sendCompany', 'テスト会社');
        gen.writeStringField('sendDepartment', 'テスト部署');
        gen.writeStringField('sendContact', 'テストユーザ');
        gen.writeStringField('sendPhone', '0312345678');
        gen.writeStringField('memo', 'テストメモ');
        gen.writeEndObject();
        req.requestBody = Blob.valueOf(gen.getAsString());
        RestContext.request = req;
        RestResponse res = new RestResponse();
        RestContext.response = res;
        SendMailRentalVerifierCotroller.doPost();
        Test.stopTest();
    }

    static testmethod void test5() {
        String accId = createAccount();
        String conId = createContact(accId);
        Contact con = [SELECT JP_isPartnerSiteUser__c FROM Contact WHERE Id = :conId];
        con.JP_isPartnerSiteUser__c = true;
        con.JP_isPartnerSiteInvited__c = true;
        update con;
        Test.startTest();
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/DeliveryMail';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestResponse res = new RestResponse();
        RestContext.response = res;
        SendMailDeliveryMail.doGet();
        Test.stopTest();
    }

    static testmethod void test6() {
        String accId = createAccount();
        String conId = createContact(accId);
        Contact con = [SELECT JP_isPartnerSiteUser__c FROM Contact WHERE Id = :conId];
        con.JP_isPartnerSiteUser__c = true;
        con.JP_isPartnerSiteInvited__c = true;
        con.JP_PurchaseDetailAccessLv__c = 'あり(利益表示あり)';
        update con;
        Test.startTest();
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/DeliveryMail';
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json');
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('accountName', 'テスト会社');
        gen.writeStringField('name', 'テスト顧客');
        gen.writeEndObject();
        req.requestBody = Blob.valueOf(gen.getAsString());
        RestContext.request = req;
        RestResponse res = new RestResponse();
        RestContext.response = res;
        SendMailDeliveryMail.doPost();
        Test.stopTest();
    }

    static testmethod void test7() {
        String accId = createAccount();
        String conId = createContact(accId);
        flg.firstRun = true;
        Contact con = [SELECT JP_isPartnerSiteUser__c, JP_CustomerCode__c FROM Contact WHERE Id = :conId];
        con.JP_isPartnerSiteUser__c = true;
        con.JP_isPartnerSiteInvited__c = true;
        con.JP_PurchaseDetailAccessLv__c = 'あり(利益表示あり)';
        update con;
        Test.startTest();
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/DeliveryMailTest';
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json');
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('contact_code', con.JP_CustomerCode__c);
        gen.writeStringField('accountName', 'テスト会社');
        gen.writeStringField('name', 'テスト顧客');
        gen.writeEndObject();
        req.requestBody = Blob.valueOf(gen.getAsString());
        RestContext.request = req;
        RestResponse res = new RestResponse();
        RestContext.response = res;
        con = [SELECT JP_isRebateAccessPermitted__c, JP_isPartnerSiteInvited__c, JP_CustomerCode__c FROM Contact WHERE Id = :conId];
        System.debug(con.JP_isRebateAccessPermitted__c);
        System.debug(con.JP_isPartnerSiteInvited__c);
        System.debug(con.JP_CustomerCode__c);
        SendMailTestDeliveryMail.doPost();
        Test.stopTest();
    }

    static testmethod void test7_2() {
        String accId = createAccount();
        String conId = createContact(accId);
        flg.firstRun = true;
        Contact con = [SELECT JP_isPartnerSiteUser__c, JP_CustomerCode__c FROM Contact WHERE Id = :conId];
        con.JP_isPartnerSiteUser__c = true;
        con.JP_isPartnerSiteInvited__c = true;
        con.JP_PurchaseDetailAccessLv__c = '';
        update con;
        Test.startTest();
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/DeliveryMailTest';
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json');
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('contact_code', con.JP_CustomerCode__c);
        gen.writeStringField('accountName', 'テスト会社');
        gen.writeStringField('name', 'テスト顧客');
        gen.writeEndObject();
        req.requestBody = Blob.valueOf(gen.getAsString());
        RestContext.request = req;
        RestResponse res = new RestResponse();
        RestContext.response = res;
        con = [SELECT JP_isRebateAccessPermitted__c, JP_isPartnerSiteInvited__c, JP_CustomerCode__c FROM Contact WHERE Id = :conId];
        System.debug(con.JP_isRebateAccessPermitted__c);
        System.debug(con.JP_isPartnerSiteInvited__c);
        System.debug(con.JP_CustomerCode__c);
        SendMailTestDeliveryMail.doPost();
        Test.stopTest();
    }

    static testmethod void test7_3() {
        String accId = createAccount();
        String conId = createContact(accId);
        flg.firstRun = true;
        Contact con = [SELECT JP_isPartnerSiteUser__c, JP_CustomerCode__c FROM Contact WHERE Id = :conId];
        con.JP_isPartnerSiteUser__c = true;
        con.JP_isPartnerSiteInvited__c = true;
        con.JP_PurchaseDetailAccessLv__c = 'あり(利益表示あり)';
        update con;
        Test.startTest();
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/DeliveryMailTest';
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json');
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('accountName', 'テスト会社');
        gen.writeStringField('name', 'テスト顧客');
        gen.writeEndObject();
        req.requestBody = Blob.valueOf(gen.getAsString());
        RestContext.request = req;
        RestResponse res = new RestResponse();
        RestContext.response = res;
        con = [SELECT JP_isRebateAccessPermitted__c, JP_isPartnerSiteInvited__c, JP_CustomerCode__c FROM Contact WHERE Id = :conId];
        System.debug(con.JP_isRebateAccessPermitted__c);
        System.debug(con.JP_isPartnerSiteInvited__c);
        System.debug(con.JP_CustomerCode__c);
        SendMailTestDeliveryMail.doPost();
        Test.stopTest();
    }

    static testmethod void test8() {
        String accId = createAccount();
        String conId = createContact(accId);
        Contact con = [SELECT JP_isPartnerSiteUser__c FROM Contact WHERE Id = :conId];
        con.JP_isPartnerSiteUser__c = true;
        con.JP_isPartnerSiteInvited__c = true;
        update con;
        Test.startTest();
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/SendMailResetPassword';
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json');
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('email', 'test@test.co.jp');
        gen.writeStringField('name', 'テスト顧客');
        gen.writeStringField('password', '12345678');
        gen.writeEndObject();
        req.requestBody = Blob.valueOf(gen.getAsString());
        RestContext.request = req;
        RestResponse res = new RestResponse();
        RestContext.response = res;
        SendMailResetPasswordCotroller.doPost();
        Test.stopTest();
    }

    static testmethod void test9() {
        String accId = createAccount();
        String conId = createContact(accId);
        Contact con = [SELECT JP_isPartnerSiteUser__c FROM Contact WHERE Id = :conId];
        con.JP_isPartnerSiteUser__c = true;
        con.JP_isPartnerSiteInvited__c = true;
        update con;
        Test.startTest();
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/SendMailIntenalUser';
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json');
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('lastName', 'テスト顧客');
        gen.writeStringField('firstName', 'テスト顧客');
        gen.writeStringField('loginId', 'test@test.co.jp');
        gen.writeStringField('email', 'test@test.co.jp');
        gen.writeStringField('password', '12345678');
        gen.writeEndObject();
        req.requestBody = Blob.valueOf(gen.getAsString());
        RestContext.request = req;
        RestResponse res = new RestResponse();
        RestContext.response = res;
        SendMailIntenalUserCotroller.doPost();
        Test.stopTest();
    }

    static testmethod void test10() {
        String accId = createAccount();
        String conId = createContact(accId);
        Contact con = [SELECT JP_isPartnerSiteUser__c FROM Contact WHERE Id = :conId];
        con.JP_isPartnerSiteUser__c = true;
        con.JP_isPartnerSiteInvited__c = true;
        update con;
        Test.startTest();
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/SendMailInquiry';
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json');
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('userId', conId);
        gen.writeStringField('companyCode', '123456');
        gen.writeStringField('companyName', 'テスト会社');
        gen.writeStringField('department', 'テスト部署');
        gen.writeStringField('sfdcdepartment', 'SFDCテスト部署');
        gen.writeStringField('name', 'テスト顧客');
        gen.writeStringField('phone', '0312345678');
        gen.writeStringField('sfdcphone', '0323456789');
        gen.writeStringField('email', 'test@test.co.jp');
        gen.writeStringField('sfdcemail', 'test.user@test.co.jp');
        gen.writeStringField('subject', 'テスト件名');
        gen.writeStringField('content', 'テスト内容');
        gen.writeEndObject();
        req.requestBody = Blob.valueOf(gen.getAsString());
        RestContext.request = req;
        RestResponse res = new RestResponse();
        RestContext.response = res;
        SendMailInquiryCotroller.doPost();
        Test.stopTest();
    }

    static testmethod void test11() {
        Test.startTest();
        SendMailDeliveryMail.TestThread();
        CustomException ce = new CustomException();
        ce.coverRate = 'test';
        Test.stopTest();
    }

    static testmethod void test12() {
        String accId = createAccount();
        String conId = createContact(accId);
        Contact con = [SELECT JP_isPartnerSiteUser__c FROM Contact WHERE Id = :conId];
        con.JP_isPartnerSiteUser__c = true;
        con.JP_isPartnerSiteInvited__c = true;
        update con;
        JP_ASP_Program__c aspProgram = new JP_ASP_Program__c();
        aspProgram.Name = 'test';
        aspProgram.JP_Period__c = 'test';
        aspProgram.JP_Status__c = '受付中';
        insert aspProgram;
         
        Test.startTest();
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/SendMailAspProgram';
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json');
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('userId', conId);
        gen.writeStringField('aspProgramId', aspProgram.Id);
        gen.writeEndObject();
        req.requestBody = Blob.valueOf(gen.getAsString());
        RestContext.request = req;
        RestResponse res = new RestResponse();
        RestContext.response = res;
        SendMailAspProgramCotroller.doPost();
        Test.stopTest();
    }

}