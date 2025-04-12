/*******************
Description:顧客情報コピー機能
Developer: Hitachi Solutions, Ltd.
DateCreated: 01/31/2013
DateModified:01/31/2013
*****************/
@isTest
public class Test_JP_CLCopyContactInfo {
    //'JP_Contacts'のレコードタイプを取得する
    public static Id getJPConRecordTypeId () {
        List<RecordType> otherRec = [select id from RecordType where name = 'JP_Contacts' and SObjectType = 'Contact'];
        return otherRec[0].Id;
    }
    
     //'JP_Accounts'のレコードタイプを取得する
     public static Id getJPAccRecordTypeId () {
        List<RecordType> accRec = [select id from RecordType where name = 'JP_Accounts' and SObjectType = 'Account'];
        return accRec[0].Id;
     }
     
     //'JP_Case'のレコードタイプを取得する
     public static Id getJPCaseRecordTypeId () {
        List<RecordType> caseRec = [select id from RecordType where name = 'JP_Case' and SObjectType = 'Case'];
        return caseRec[0].Id;
     }
     
     private static testMethod void myUnitTest1() {
        List<Contact> targetCon = new List<Contact>();
        List<Case> targetCase = new List<Case>();
        List<Product2> targetProduct = new List<Product2>();
        List<JP_RepairItem__c> targetRep = new List<JP_RepairItem__c>();
        targetCon.add(new Contact(Lastname = 'RepairItemテストクラス顧客', JP_Grade__c = 'A', recordtypeId = getJPConRecordTypeId(), MailingCountry = 'Japan', MailingPostalCode = '123-4567', MailingState = '東京都', MailingCity='大田区', MailingStreet = '1-2-3' ));
        insert targetCon;
        targetCase.add(new Case(Contact = targetCon[0], Origin = 'FAX', recordtypeId = getJPCaseRecordTypeId() ));
        insert targetCase;
        targetProduct.add(new Product2(IsActive = true, Name = 'RepairItemテストクラス商品', JP_SalesOrganization__c = '1022', ProductCode = '1', JP_DistributionChannel__c = '1', JP_Division__c='1', JP_ConnectionKey__c = '1_1022_1_1'));
        insert targetProduct;
        Test.Starttest();
        targetRep.add(new JP_RepairItem__c(JP_ProductName__c = targetProduct[0].id ,JP_CaseNumber__c = targetCase[0].id, JP_SendToEqualsFlag__c = true));
        insert targetRep;
        Test.StopTest();
     }

}